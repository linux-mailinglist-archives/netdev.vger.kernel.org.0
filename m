Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBB3D16534C
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgBTAEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:04:23 -0500
Received: from www62.your-server.de ([213.133.104.62]:52554 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgBTAEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 19:04:22 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4ZK7-0005ZO-0U; Thu, 20 Feb 2020 01:04:11 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j4ZK6-000T1L-L3; Thu, 20 Feb 2020 01:04:10 +0100
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Add sock ops get netns helpers
To:     Lingpeng Chen <forrest0579@gmail.com>, bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Petar Penkov <ppenkov.kernel@gmail.com>
References: <20200206083515.10334-1-forrest0579@gmail.com>
 <20200218091541.107371-1-forrest0579@gmail.com>
 <20200218091541.107371-2-forrest0579@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <07e2568e-0256-29f5-1656-1ac80a69f229@iogearbox.net>
Date:   Thu, 20 Feb 2020 01:04:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200218091541.107371-2-forrest0579@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.1/25728/Wed Feb 19 15:06:20 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 10:15 AM, Lingpeng Chen wrote:
> Currently 5-tuple(sip+dip+sport+dport+proto) can't identify a
> uniq connection because there may be multi net namespace.
> For example, there may be a chance that netns a and netns b all
> listen on 127.0.0.1:8080 and the client with same port 40782
> connect to them. Without netns number, sock ops program
> can't distinguish them.
> Using bpf_sock_ops_get_netns helpers to get current connection
> netns number to distinguish connections.
> 
> Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
> ---
>   include/uapi/linux/bpf.h |  8 +++++++-
>   net/core/filter.c        | 19 +++++++++++++++++++
>   2 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index f1d74a2bd234..3573907d15e0 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2892,6 +2892,11 @@ union bpf_attr {
>    *		Obtain the 64bit jiffies
>    *	Return
>    *		The 64 bit jiffies
> + * u64 bpf_sock_ops_get_netns(struct bpf_sock_ops *bpf_socket)

Nit: newline before the new helper signature starts above.

> + *  Description
> + *      Obtain netns id of sock
> + * Return
> + *      The current netns inum
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -3012,7 +3017,8 @@ union bpf_attr {
>   	FN(probe_read_kernel_str),	\
>   	FN(tcp_send_ack),		\
>   	FN(send_signal_thread),		\
> -	FN(jiffies64),
> +	FN(jiffies64),			\
> +	FN(sock_ops_get_netns),

Please name this something more generic like FN(get_netns_id) or such. Definitely
without the 'sock_ops' part so this can be remapped to various other prog types
for the *_func_proto().

>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>    * function eBPF program intends to call
> diff --git a/net/core/filter.c b/net/core/filter.c
> index c180871e606d..f8e946aa46fc 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -4421,6 +4421,23 @@ static const struct bpf_func_proto bpf_sock_ops_cb_flags_set_proto = {
>   	.arg2_type	= ARG_ANYTHING,
>   };
>   
> +BPF_CALL_1(bpf_sock_ops_get_netns, struct bpf_sock_ops_kern *, bpf_sock)
> +{
> +#ifdef CONFIG_NET_NS
> +	struct sock *sk = bpf_sock->sk;
> +
> +	return (u64)sk->sk_net.net->ns.inum;
> +#endif
> +	return 0;
> +}
> +
> +static const struct bpf_func_proto bpf_sock_ops_get_netns_proto = {
> +	.func		= bpf_sock_ops_get_netns,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +};
> +
>   const struct ipv6_bpf_stub *ipv6_bpf_stub __read_mostly;
>   EXPORT_SYMBOL_GPL(ipv6_bpf_stub);
>   
> @@ -6218,6 +6235,8 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   	case BPF_FUNC_tcp_sock:
>   		return &bpf_tcp_sock_proto;
>   #endif /* CONFIG_INET */
> +	case BPF_FUNC_sock_ops_get_netns:
> +		return &bpf_sock_ops_get_netns_proto;
>   	default:
>   		return bpf_base_func_proto(func_id);
>   	}
> 

