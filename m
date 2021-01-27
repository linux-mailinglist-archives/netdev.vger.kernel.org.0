Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CB43066A3
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236282AbhA0VpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:45:22 -0500
Received: from www62.your-server.de ([213.133.104.62]:57824 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbhA0VbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 16:31:19 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4sOZ-0006wr-JT; Wed, 27 Jan 2021 22:30:35 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4sOZ-0007bS-Ej; Wed, 27 Jan 2021 22:30:35 +0100
Subject: Re: [PATCH bpf-next] bpf: enable bpf_{g,s}etsockopt in
 BPF_CGROUP_UDP{4,6}_SENDMSG
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org
References: <20210127174714.2240395-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c3bf8a04-818a-248c-fd27-d33b5dc4d826@iogearbox.net>
Date:   Wed, 27 Jan 2021 22:30:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210127174714.2240395-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26062/Wed Jan 27 13:26:15 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/21 6:47 PM, Stanislav Fomichev wrote:
> Can be used to query/modify socket state for unconnected UDP sendmsg.
> Those hooks run as BPF_CGROUP_RUN_SA_PROG_LOCK and operate on
> a locked socket.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   net/core/filter.c                                 | 4 ++++
>   tools/testing/selftests/bpf/progs/sendmsg4_prog.c | 7 +++++++
>   tools/testing/selftests/bpf/progs/sendmsg6_prog.c | 7 +++++++
>   3 files changed, 18 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 9ab94e90d660..3d7f78a19565 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7023,6 +7023,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		case BPF_CGROUP_INET6_BIND:
>   		case BPF_CGROUP_INET4_CONNECT:
>   		case BPF_CGROUP_INET6_CONNECT:
> +		case BPF_CGROUP_UDP4_SENDMSG:
> +		case BPF_CGROUP_UDP6_SENDMSG:
>   			return &bpf_sock_addr_setsockopt_proto;
>   		default:
>   			return NULL;
> @@ -7033,6 +7035,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		case BPF_CGROUP_INET6_BIND:
>   		case BPF_CGROUP_INET4_CONNECT:
>   		case BPF_CGROUP_INET6_CONNECT:
> +		case BPF_CGROUP_UDP4_SENDMSG:
> +		case BPF_CGROUP_UDP6_SENDMSG:
>   			return &bpf_sock_addr_getsockopt_proto;

Patch looks good, could we at this point also add all the others that run under
BPF_CGROUP_RUN_SA_PROG_LOCK while at it, that is v4/v6 flavors of recvmsg as well
as peername/sockname?

Thanks,
Daniel
