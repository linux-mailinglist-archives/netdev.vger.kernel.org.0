Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005A9374ABE
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 23:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhEEVnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 17:43:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:33038 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhEEVnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 17:43:01 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lePHO-0003ND-It; Wed, 05 May 2021 23:42:02 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lePHO-000SI5-9F; Wed, 05 May 2021 23:42:02 +0200
Subject: Re: [PATCH bpf-next v6 2/3] libbpf: add low level TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Shaun Crampton <shaun@tigera.io>, netdev@vger.kernel.org
References: <20210504005023.1240974-1-memxor@gmail.com>
 <20210504005023.1240974-3-memxor@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <eb6aada2-0de8-3adf-4b69-898a1c31c4e6@iogearbox.net>
Date:   Wed, 5 May 2021 23:42:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210504005023.1240974-3-memxor@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26161/Wed May  5 13:06:38 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/21 2:50 AM, Kumar Kartikeya Dwivedi wrote:
> This adds functions that wrap the netlink API used for adding,
> manipulating, and removing traffic control filters.
> 
> An API summary:

Looks better, few minor comments below:

> A bpf_tc_hook represents a location where a TC-BPF filter can be
> attached. This means that creating a hook leads to creation of the
> backing qdisc, while destruction either removes all filters attached to
> a hook, or destroys qdisc if requested explicitly (as discussed below).
> 
> The TC-BPF API functions operate on this bpf_tc_hook to attach, replace,
> query, and detach tc filters.
> 
> All functions return 0 on success, and a negative error code on failure.
> 
> bpf_tc_hook_create - Create a hook
> Parameters:
> 	@hook - Cannot be NULL, ifindex > 0, attach_point must be set to
> 		proper enum constant. Note that parent must be unset when
> 		attach_point is one of BPF_TC_INGRESS or BPF_TC_EGRESS. Note
> 		that as an exception BPF_TC_INGRESS|BPF_TC_EGRESS is also a
> 		valid value for attach_point.
> 
> 		Returns -EOPNOTSUPP when hook has attach_point as BPF_TC_CUSTOM.
> 
> 		hook's flags member can be BPF_TC_F_REPLACE, which
> 		creates qdisc in non-exclusive mode (i.e. an existing
> 		qdisc will be replaced instead of this function failing
> 		with -EEXIST).

Why supporting BPF_TC_F_REPLACE here? It's not changing any qdisc parameters
given clsact doesn't have any, no? Iow, what effect are you expecting on this
with BPF_TC_F_REPLACE & why supporting it? I'd probably just require flags to
be 0 here, and if hook exists return sth like -EEXIST.

> bpf_tc_hook_destroy - Destroy the hook
> Parameters:
>          @hook - Cannot be NULL. The behaviour depends on value of
> 		attach_point.
> 
> 		If BPF_TC_INGRESS, all filters attached to the ingress
> 		hook will be detached.
> 		If BPF_TC_EGRESS, all filters attached to the egress hook
> 		will be detached.
> 		If BPF_TC_INGRESS|BPF_TC_EGRESS, the clsact qdisc will be
> 		deleted, also detaching all filters.
> 
> 		As before, parent must be unset for these attach_points,
> 		and set for BPF_TC_CUSTOM. flags must also be unset.
> 
> 		It is advised that if the qdisc is operated on by many programs,
> 		then the program at least check that there are no other existing
> 		filters before deleting the clsact qdisc. An example is shown
> 		below:
> 
> 		DECLARE_LIBBPF_OPTS(bpf_tc_hook, .ifindex = if_nametoindex("lo"),
> 				    .attach_point = BPF_TC_INGRESS);
> 		/* set opts as NULL, as we're not really interested in
> 		 * getting any info for a particular filter, but just
> 	 	 * detecting its presence.
> 		 */
> 		r = bpf_tc_query(&hook, NULL);
> 		if (r == -ENOENT) {
> 			/* no filters */
> 			hook.attach_point = BPF_TC_INGRESS|BPF_TC_EGREESS;
> 			return bpf_tc_hook_destroy(&hook);
> 		} else {
> 			/* failed or r == 0, the latter means filters do exist */
> 			return r;
> 		}
> 
> 		Note that there is a small race between checking for no
> 		filters and deleting the qdisc. This is currently unavoidable.
> 
> 		Returns -EOPNOTSUPP when hook has attach_point as BPF_TC_CUSTOM.
> 
> bpf_tc_attach - Attach a filter to a hook
> Parameters:
> 	@hook - Cannot be NULL. Represents the hook the filter will be
> 		attached to. Requirements for ifindex and attach_point are
> 		same as described in bpf_tc_hook_create, but BPF_TC_CUSTOM
> 		is also supported.  In that case, parent must be set to the
> 		handle where the filter will be attached (using TC_H_MAKE).
> 		flags member must be unset.
> 
> 		E.g. To set parent to 1:16 like in tc command line,
> 		     the equivalent would be TC_H_MAKE(1 << 16, 16)

Small nit: I wonder whether from libbpf side we should just support a more
user friendly TC_H_MAKE, so you'd have: BPF_TC_CUSTOM + BPF_TC_PARENT(1, 16).

> 	@opts - Cannot be NULL.
> 
> 		The following opts are optional:
> 			handle - The handle of the filter
> 			priority - The priority of the filter
> 				   Must be >= 0 and <= UINT16_MAX

It should probably be mentioned that if they are not specified, then they
are auto-allocated from kernel.

> 		The following opts must be set:
> 			prog_fd - The fd of the loaded SCHED_CLS prog
> 		The following opts must be unset:
> 			prog_id - The ID of the BPF prog
> 		The following opts are optional:
> 			flags - Currently only BPF_TC_F_REPLACE is
> 				allowed. It allows replacing an existing
> 				filter instead of failing with -EEXIST.
> 
> 		The following opts will be filled by bpf_tc_attach on a
> 		successful attach operation if they are unset:
> 			handle - The handle of the attached filter
> 			priority - The priority of the attached filter
> 			prog_id - The ID of the attached SCHED_CLS prog
> 
> 		This way, the user can know what the auto allocated
> 		values for optional opts like handle and priority are
> 		for the newly attached filter, if they were unset.
> 
> 		Note that some other attributes are set to some default
> 		values listed below (this holds for all bpf_tc_* APIs):
> 			protocol - ETH_P_ALL
> 			mode - direct action
> 			chain index - 0
> 			class ID - 0 (this can be set by writing to the
> 			skb->tc_classid field from the BPF program)
> 
> bpf_tc_detach
> Parameters:
> 	@hook: Cannot be NULL. Represents the hook the filter will be
> 		detached from. Requirements are same as described above
> 		in bpf_tc_attach.
> 
> 	@opts:	Cannot be NULL.
> 
> 		The following opts must be set:
> 			handle
> 			priority
> 		The following opts must be unset:
> 			prog_fd
> 			prog_id
> 			flags
> 
> bpf_tc_query
> Parameters:
> 	@hook: Cannot be NULL. Represents the hook where the filter
> 	       lookup will be performed. Requires are same as described
> 	       above in bpf_tc_attach.
> 
> 	@opts: Can be NULL.

Shouldn't it be: Cannot be NULL?

> 	       The following opts are optional:
> 			handle
> 			priority
> 			prog_fd
> 			prog_id

What is the use case to set prog_fd here?

> 	       The following opts must be unset:
> 			flags
> 
> 	       However, only one of prog_fd and prog_id must be
> 	       set. Setting both leads to an error. Setting none is
> 	       allowed.
> 
> 	       The following fields will be filled by bpf_tc_query on a
> 	       successful lookup if they are unset:
> 			handle
> 			priority
> 			prog_id
> 
> 	       Based on the specified optional parameters, the matching
> 	       data for the first matching filter is filled in and 0 is
> 	       returned. When setting prog_fd, the prog_id will be
> 	       matched against prog_id of the loaded SCHED_CLS prog
> 	       represented by prog_fd.
> 
> 	       To uniquely identify a filter, e.g. to detect its presence,
> 	       it is recommended to set both handle and priority fields.

What if prog_id is not unique, but part of multiple instances? Do we need
to support this case?

Why not just bpf_tc_query() with non-NULL hook and non-NULL opts where
handle and priority is required to be set, and rest must be 0?

> Some usage examples (using bpf skeleton infrastructure):
> 
> BPF program (test_tc_bpf.c):
> 
> 	#include <linux/bpf.h>
> 	#include <bpf/bpf_helpers.h>
> 
> 	SEC("classifier")
> 	int cls(struct __sk_buff *skb)
> 	{
> 		return 0;
> 	}
> 
> Userspace loader:
> 
> 	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, 0);
> 	struct test_tc_bpf *skel = NULL;
> 	int fd, r;
> 
> 	skel = test_tc_bpf__open_and_load();
> 	if (!skel)
> 		return -ENOMEM;
> 
> 	fd = bpf_program__fd(skel->progs.cls);
> 
> 	DECLARE_LIBBPF_OPTS(bpf_tc_hook, hook, .ifindex =
> 			    if_nametoindex("lo"), .attach_point =
> 			    BPF_TC_INGRESS);
> 	/* Create clsact qdisc */
> 	r = bpf_tc_hook_create(&hook);
> 	if (r < 0)
> 		goto end;
> 
> 	DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .prog_fd = fd);

Given we had DECLARE_LIBBPF_OPTS earlier, can't we just set:
opts.prog_fd = fd here?

> 	r = bpf_tc_attach(&hook, &opts);
> 	if (r < 0)
> 		goto end;
> 	/* Print the auto allocated handle and priority */
> 	printf("Handle=%u", opts.handle);
> 	printf("Priority=%u", opts.priority);
> 
> 	opts.prog_fd = opts.prog_id = 0;
> 	bpf_tc_detach(&hook, &opts);

Here we detach ...

> end:
> 	test_tc_bpf__destroy(skel);
> 
> This is equivalent to doing the following using tc command line:
>    # tc qdisc add dev lo clsact
>    # tc filter add dev lo ingress bpf obj foo.o sec classifier da

... so this is not equivalent to your tc cmdline description.

> Another example replacing a filter (extending prior example):
> 
> 	/* We can also choose both (or one), let's try replacing an
> 	 * existing filter.
> 	 */
> 	DECLARE_LIBBPF_OPTS(bpf_tc_opts, replace_opts, .handle =
> 			    opts.handle, .priority = opts.priority,
> 			    .prog_fd = fd);
> 	r = bpf_tc_attach(&hook, &replace_opts);
> 	if (r == -EEXIST) {
> 		/* Expected, now use BPF_TC_F_REPLACE to replace it */
> 		replace_opts.flags = BPF_TC_F_REPLACE;
> 		return bpf_tc_attach(&hook, &replace_opts);
> 	} else if (r < 0) {
> 		return r;
> 	}
> 	/* There must be no existing filter with these
> 	 * attributes, so cleanup and return an error.
> 	 */
> 	replace_opts.flags = replace_opts.prog_fd = replace_opts.prog_id = 0;
> 	bpf_tc_detach(&hook, &replace_opts);
> 	return -1;
> 
> To obtain info of a particular filter:
> 
> 	/* Find info for filter with handle 1 and priority 50 */
> 	DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts, .handle = 1,
> 			    .priority = 50);
> 	r = bpf_tc_query(&hook, &info_opts);
> 	if (r == -ENOENT)
> 		printf("Filter not found");
> 	else if (r < 0)
> 		return r;
> 	printf("Prog ID: %u", info_opts.prog_id);
> 	return 0;
> 
> We can also match using prog_id to find the same filter:
> 
> 	DECLARE_LIBBPF_OPTS(bpf_tc_opts, info_opts2, .prog_id =
> 			    info_opts.prog_id);
> 	r = bpf_tc_query(&hook, &info_opts2);
> 	if (r == -ENOENT)
> 		printf("Filter not found");
> 	else if (r < 0)
> 		return r;
> 	/* If we know there's only one filter for this loaded prog,
> 	 * it is safe to assert that the handle and priority are
> 	 * as expected.
> 	 */
> 	assert(info_opts2.handle == 1);
> 	assert(info_opts2.priority == 50);

What if a given prog_id is attached to multiple instances?

> 	return 0;
> 
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>   tools/lib/bpf/libbpf.h   |  42 ++++
>   tools/lib/bpf/libbpf.map |   5 +
>   tools/lib/bpf/netlink.c  | 473 ++++++++++++++++++++++++++++++++++++++-
>   3 files changed, 519 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index bec4e6a6e31d..09d1a4fb10f9 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -775,6 +775,48 @@ LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filen
>   LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
>   LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
>   
> +enum bpf_tc_attach_point {
> +	BPF_TC_INGRESS = 1 << 0,
> +	BPF_TC_EGRESS  = 1 << 1,
> +	BPF_TC_CUSTOM  = 1 << 2,
> +};
> +
> +enum bpf_tc_flags {
> +	BPF_TC_F_REPLACE = 1 << 0,
> +};
> +
> +struct bpf_tc_hook {
> +	size_t sz;
> +	int ifindex;
> +	int flags;

nit: __u32 flags; (or rather dropping as discussed)

> +	enum bpf_tc_attach_point attach_point;
> +	__u32 parent;
> +	size_t :0;
> +};
> +
> +#define bpf_tc_hook__last_field parent
> +
> +struct bpf_tc_opts {
> +	size_t sz;
> +	int prog_fd;
> +	int flags;

nit: __u32 flags;

> +	__u32 prog_id;
> +	__u32 handle;
> +	__u32 priority;
> +	size_t :0;
> +};
> +
> +#define bpf_tc_opts__last_field priority
> +
> +LIBBPF_API int bpf_tc_hook_create(struct bpf_tc_hook *hook);
> +LIBBPF_API int bpf_tc_hook_destroy(struct bpf_tc_hook *hook);
> +LIBBPF_API int bpf_tc_attach(const struct bpf_tc_hook *hook,
> +			     struct bpf_tc_opts *opts);
> +LIBBPF_API int bpf_tc_detach(const struct bpf_tc_hook *hook,
> +			     const struct bpf_tc_opts *opts);
> +LIBBPF_API int bpf_tc_query(const struct bpf_tc_hook *hook,
> +			    struct bpf_tc_opts *opts);
> +
>   #ifdef __cplusplus
>   } /* extern "C" */
>   #endif
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index b9b29baf1df8..6c96729050dc 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -361,4 +361,9 @@ LIBBPF_0.4.0 {
>   		bpf_linker__new;
>   		bpf_map__inner_map;
>   		bpf_object__set_kversion;
> +		bpf_tc_attach;
> +		bpf_tc_detach;
> +		bpf_tc_hook_create;
> +		bpf_tc_hook_destroy;
> +		bpf_tc_query;
>   } LIBBPF_0.3.0;
> diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
> index 8a01d9eed5f9..95c87f87a178 100644
> --- a/tools/lib/bpf/netlink.c
> +++ b/tools/lib/bpf/netlink.c
> @@ -4,7 +4,10 @@
>   #include <stdlib.h>
>   #include <memory.h>
>   #include <unistd.h>
> +#include <arpa/inet.h>
>   #include <linux/bpf.h>
> +#include <linux/if_ether.h>
> +#include <linux/pkt_cls.h>
>   #include <linux/rtnetlink.h>
>   #include <sys/socket.h>
>   #include <errno.h>
> @@ -73,6 +76,12 @@ static int libbpf_netlink_open(__u32 *nl_pid)
>   	return ret;
>   }
>   
> +enum {
> +	BPF_NL_CONT,
> +	BPF_NL_NEXT,
> +	BPF_NL_DONE,

nit: I don't think we need BPF_ prefix here given it's not specific to BPF.

> +};
> +
>   static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
>   			    __dump_nlmsg_t _fn, libbpf_dump_nlmsg_t fn,
>   			    void *cookie)
> @@ -84,6 +93,7 @@ static int bpf_netlink_recv(int sock, __u32 nl_pid, int seq,
>   	int len, ret;
>   
>   	while (multipart) {
> +start:
>   		multipart = false;
>   		len = recv(sock, buf, sizeof(buf), 0);
>   		if (len < 0) {
[...]
