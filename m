Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8851F3082BC
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 01:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhA2Axl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 19:53:41 -0500
Received: from www62.your-server.de ([213.133.104.62]:40706 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbhA2Axh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 19:53:37 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l5I1v-0007G6-S5; Fri, 29 Jan 2021 01:52:55 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l5I1v-000EGN-Mm; Fri, 29 Jan 2021 01:52:55 +0100
Subject: Re: [PATCH bpf-next v2 4/4] bpf: enable bpf_{g,s}etsockopt in
 BPF_CGROUP_UDP{4,6}_RECVMSG
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org
References: <20210127232853.3753823-1-sdf@google.com>
 <20210127232853.3753823-5-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3098d1b1-3438-6646-d466-feed27e9ba6b@iogearbox.net>
Date:   Fri, 29 Jan 2021 01:52:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210127232853.3753823-5-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26063/Thu Jan 28 13:28:06 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 12:28 AM, Stanislav Fomichev wrote:
> Those hooks run as BPF_CGROUP_RUN_SA_PROG_LOCK and operate on
> a locked socket.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   net/core/filter.c                                 | 4 ++++
>   tools/testing/selftests/bpf/progs/recvmsg4_prog.c | 5 +++++
>   tools/testing/selftests/bpf/progs/recvmsg6_prog.c | 5 +++++
>   3 files changed, 14 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index ba436b1d70c2..e15d4741719a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -7023,6 +7023,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		case BPF_CGROUP_INET6_BIND:
>   		case BPF_CGROUP_INET4_CONNECT:
>   		case BPF_CGROUP_INET6_CONNECT:
> +		case BPF_CGROUP_UDP4_RECVMSG:
> +		case BPF_CGROUP_UDP6_RECVMSG:
>   		case BPF_CGROUP_UDP4_SENDMSG:
>   		case BPF_CGROUP_UDP6_SENDMSG:
>   		case BPF_CGROUP_INET4_GETPEERNAME:
> @@ -7039,6 +7041,8 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		case BPF_CGROUP_INET6_BIND:
>   		case BPF_CGROUP_INET4_CONNECT:
>   		case BPF_CGROUP_INET6_CONNECT:
> +		case BPF_CGROUP_UDP4_RECVMSG:
> +		case BPF_CGROUP_UDP6_RECVMSG:
>   		case BPF_CGROUP_UDP4_SENDMSG:
>   		case BPF_CGROUP_UDP6_SENDMSG:
>   		case BPF_CGROUP_INET4_GETPEERNAME:

Looks good overall, also thanks for adding the test cases! I was about to apply, but noticed one
small nit that would be good to get resolved before that. Above you now list all the attach hooks
for sock_addr ctx, so we should just remove the whole switch that tests on prog->expected_attach_type
altogether in this last commit.

Thanks,
Daniel
