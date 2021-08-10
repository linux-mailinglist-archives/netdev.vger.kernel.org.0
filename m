Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2B83E5969
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240453AbhHJLsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:48:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:58658 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240303AbhHJLs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 07:48:27 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mDQEj-0004Ca-MX; Tue, 10 Aug 2021 13:48:01 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mDQEj-0006Mu-Dl; Tue, 10 Aug 2021 13:48:01 +0200
Subject: Re: [PATCH bpf-next 1/1] bpf: migrate cgroup_bpf to internal
 cgroup_bpf_attach_type enum
To:     Dave Marchevsky <davemarchevsky@fb.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
References: <20210731233056.850105-1-davemarchevsky@fb.com>
 <20210731233056.850105-2-davemarchevsky@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0ba78964-4eca-ba8a-812f-f34bba4d9a8b@iogearbox.net>
Date:   Tue, 10 Aug 2021 13:48:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210731233056.850105-2-davemarchevsky@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26259/Tue Aug 10 10:19:56 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/21 1:30 AM, Dave Marchevsky wrote:
> Add an enum (cgroup_bpf_attach_type) containing only valid cgroup_bpf
> attach types and a function to map bpf_attach_type values to the new
> enum. Inspired by netns_bpf_attach_type.
> 
> Then, migrate cgroup_bpf to use cgroup_bpf_attach_type wherever
> possible.  Functionality is unchanged as attach_type_to_prog_type
> switches in bpf/syscall.c were preventing non-cgroup programs from
> making use of the invalid cgroup_bpf array slots.
> 
> As a result struct cgroup_bpf uses 504 fewer bytes relative to when its
> arrays were sized using MAX_BPF_ATTACH_TYPE.

Nice!

> bpf_cgroup_storage is notably not migrated as struct
> bpf_cgroup_storage_key is part of uapi and contains a bpf_attach_type
> member which is not meant to be opaque. Similarly, bpf_cgroup_link
> continues to report its bpf_attach_type member to userspace via fdinfo
> and bpf_link_info.
> 
> To ease disambiguation, bpf_attach_type variables are renamed from
> 'type' to 'atype' when changed to cgroup_bpf_attach_type.
> 
> Regarding testing: biggest concerns here are 1) attach/detach/run for
> programs which shouldn't map to a cgroup_bpf_attach_type should continue
> to not involve cgroup_bpf codepaths; and 2) attach types that should be
> mapped to a cgroup_bpf_attach_type do so correctly and run as expected.
> 
> Existing selftests cover both scenarios well. The udp_limit selftest
> specifically validates the 2nd case - BPF_CGROUP_INET_SOCK_RELEASE is
> larger than MAX_CGROUP_BPF_ATTACH_TYPE so if it were not correctly
> mapped to CG_BPF_CGROUP_INET_SOCK_RELEASE the test would fail.
> 
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>

Overall looks good to me, great to reduce memory bloat. Some really minor bits
below ..

> ---
>   include/linux/bpf-cgroup.h     | 200 +++++++++++++++++++++++----------
>   include/uapi/linux/bpf.h       |   2 +-
>   kernel/bpf/cgroup.c            | 154 +++++++++++++++----------
>   net/ipv4/af_inet.c             |   6 +-
>   net/ipv4/udp.c                 |   2 +-
>   net/ipv6/af_inet6.c            |   6 +-
>   net/ipv6/udp.c                 |   2 +-
>   tools/include/uapi/linux/bpf.h |   2 +-
>   8 files changed, 243 insertions(+), 131 deletions(-)
> 
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index a74cd1c3bd87..0fdd8931ec5a 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -23,9 +23,91 @@ struct ctl_table_header;
>   struct task_struct;
>   
>   #ifdef CONFIG_CGROUP_BPF
> +enum cgroup_bpf_attach_type {
> +	CG_BPF_INVALID = -1,
> +	CG_BPF_CGROUP_INET_INGRESS = 0,
> +	CG_BPF_CGROUP_INET_EGRESS,
> +	CG_BPF_CGROUP_INET_SOCK_CREATE,
> +	CG_BPF_CGROUP_SOCK_OPS,
> +	CG_BPF_CGROUP_DEVICE,
> +	CG_BPF_CGROUP_INET4_BIND,
> +	CG_BPF_CGROUP_INET6_BIND,
> +	CG_BPF_CGROUP_INET4_CONNECT,
> +	CG_BPF_CGROUP_INET6_CONNECT,
> +	CG_BPF_CGROUP_INET4_POST_BIND,
> +	CG_BPF_CGROUP_INET6_POST_BIND,
> +	CG_BPF_CGROUP_UDP4_SENDMSG,
> +	CG_BPF_CGROUP_UDP6_SENDMSG,
> +	CG_BPF_CGROUP_SYSCTL,
> +	CG_BPF_CGROUP_UDP4_RECVMSG,
> +	CG_BPF_CGROUP_UDP6_RECVMSG,
> +	CG_BPF_CGROUP_GETSOCKOPT,
> +	CG_BPF_CGROUP_SETSOCKOPT,
> +	CG_BPF_CGROUP_INET4_GETPEERNAME,
> +	CG_BPF_CGROUP_INET6_GETPEERNAME,
> +	CG_BPF_CGROUP_INET4_GETSOCKNAME,
> +	CG_BPF_CGROUP_INET6_GETSOCKNAME,
> +	CG_BPF_CGROUP_INET_SOCK_RELEASE,

small nit: I'd drop the CG_BPF_ prefix altogether, the CG is redundant
with latter CGROUP in name.

> +	MAX_CGROUP_BPF_ATTACH_TYPE
> +};
> +
> +static inline enum cgroup_bpf_attach_type
> +to_cgroup_bpf_attach_type(enum bpf_attach_type attach_type)
> +{
> +	switch (attach_type) {
> +	case BPF_CGROUP_INET_INGRESS:
> +		return CG_BPF_CGROUP_INET_INGRESS;
> +	case BPF_CGROUP_INET_EGRESS:
> +		return CG_BPF_CGROUP_INET_EGRESS;
> +	case BPF_CGROUP_INET_SOCK_CREATE:
> +		return CG_BPF_CGROUP_INET_SOCK_CREATE;
> +	case BPF_CGROUP_SOCK_OPS:
> +		return CG_BPF_CGROUP_SOCK_OPS;
> +	case BPF_CGROUP_DEVICE:
> +		return CG_BPF_CGROUP_DEVICE;
> +	case BPF_CGROUP_INET4_BIND:
> +		return CG_BPF_CGROUP_INET4_BIND;
> +	case BPF_CGROUP_INET6_BIND:
> +		return CG_BPF_CGROUP_INET6_BIND;
> +	case BPF_CGROUP_INET4_CONNECT:
> +		return CG_BPF_CGROUP_INET4_CONNECT;
> +	case BPF_CGROUP_INET6_CONNECT:
> +		return CG_BPF_CGROUP_INET6_CONNECT;
> +	case BPF_CGROUP_INET4_POST_BIND:
> +		return CG_BPF_CGROUP_INET4_POST_BIND;
> +	case BPF_CGROUP_INET6_POST_BIND:
> +		return CG_BPF_CGROUP_INET6_POST_BIND;
> +	case BPF_CGROUP_UDP4_SENDMSG:
> +		return CG_BPF_CGROUP_UDP4_SENDMSG;
> +	case BPF_CGROUP_UDP6_SENDMSG:
> +		return CG_BPF_CGROUP_UDP6_SENDMSG;
> +	case BPF_CGROUP_SYSCTL:
> +		return CG_BPF_CGROUP_SYSCTL;
> +	case BPF_CGROUP_UDP4_RECVMSG:
> +		return CG_BPF_CGROUP_UDP4_RECVMSG;
> +	case BPF_CGROUP_UDP6_RECVMSG:
> +		return CG_BPF_CGROUP_UDP6_RECVMSG;
> +	case BPF_CGROUP_GETSOCKOPT:
> +		return CG_BPF_CGROUP_GETSOCKOPT;
> +	case BPF_CGROUP_SETSOCKOPT:
> +		return CG_BPF_CGROUP_SETSOCKOPT;
> +	case BPF_CGROUP_INET4_GETPEERNAME:
> +		return CG_BPF_CGROUP_INET4_GETPEERNAME;
> +	case BPF_CGROUP_INET6_GETPEERNAME:
> +		return CG_BPF_CGROUP_INET6_GETPEERNAME;
> +	case BPF_CGROUP_INET4_GETSOCKNAME:
> +		return CG_BPF_CGROUP_INET4_GETSOCKNAME;
> +	case BPF_CGROUP_INET6_GETSOCKNAME:
> +		return CG_BPF_CGROUP_INET6_GETSOCKNAME;
> +	case BPF_CGROUP_INET_SOCK_RELEASE:
> +		return CG_BPF_CGROUP_INET_SOCK_RELEASE;

Maybe this could use a small macro helper to map:

	case BPF_<x>:
		return <x>;

> +	default:
> +		return CG_BPF_INVALID;
> +	}
> +}
>   
> -extern struct static_key_false cgroup_bpf_enabled_key[MAX_BPF_ATTACH_TYPE];
> -#define cgroup_bpf_enabled(type) static_branch_unlikely(&cgroup_bpf_enabled_key[type])
> +extern struct static_key_false cgroup_bpf_enabled_key[MAX_CGROUP_BPF_ATTACH_TYPE];
> +#define cgroup_bpf_enabled(atype) static_branch_unlikely(&cgroup_bpf_enabled_key[atype])
>   
[...]
> @@ -667,12 +681,20 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
>   int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>   			struct bpf_cgroup_link *link, enum bpf_attach_type type)
>   {
> -	struct list_head *progs = &cgrp->bpf.progs[type];
> -	u32 flags = cgrp->bpf.flags[type];
> +	struct list_head *progs;
> +	u32 flags;
>   	struct bpf_prog_list *pl;
>   	struct bpf_prog *old_prog;
> +	enum cgroup_bpf_attach_type atype;
>   	int err;

(small nit here and elsewhere in your patch: pls try to retain reverse xmas
tree ordering if possible)

>   
> +	atype = to_cgroup_bpf_attach_type(type);
> +	if (atype < 0)
> +		return -EINVAL;
> +
> +	progs = &cgrp->bpf.progs[atype];
> +	flags = cgrp->bpf.flags[atype];
> +
>   	if (prog && link)
>   		/* only one of prog or link can be specified */
>   		return -EINVAL;
> @@ -686,7 +708,7 @@ int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>   	pl->prog = NULL;
>   	pl->link = NULL;
>   
> -	err = update_effective_progs(cgrp, type);
> +	err = update_effective_progs(cgrp, atype);
>   	if (err)
>   		goto cleanup;
>   
> @@ -695,10 +717,10 @@ int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>   	kfree(pl);
>   	if (list_empty(progs))
>   		/* last program was detached, reset flags to zero */
> -		cgrp->bpf.flags[type] = 0;
> +		cgrp->bpf.flags[atype] = 0;
>   	if (old_prog)
>   		bpf_prog_put(old_prog);
> -	static_branch_dec(&cgroup_bpf_enabled_key[type]);
> +	static_branch_dec(&cgroup_bpf_enabled_key[atype]);
>   	return 0;
>   
>   cleanup:
