Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063B827D206
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbgI2O75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:59:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:51692 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgI2O74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 10:59:56 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNH6g-0003AD-MR; Tue, 29 Sep 2020 16:59:54 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNH6g-000A0Y-FS; Tue, 29 Sep 2020 16:59:54 +0200
Subject: Re: [bpf-next PATCH 1/2] bpf, sockmap: add skb_adjust_room to pop
 bytes off ingress payload
To:     John Fastabend <john.fastabend@gmail.com>, ast@kernel.org
Cc:     netdev@vger.kernel.org, jakub@cloudflare.com, lmb@cloudflare.com
References: <160109391820.6363.6475038352873960677.stgit@john-Precision-5820-Tower>
 <160109442512.6363.1622656051946413257.stgit@john-Precision-5820-Tower>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2046cb78-ac23-05c2-6802-40332495d959@iogearbox.net>
Date:   Tue, 29 Sep 2020 16:59:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160109442512.6363.1622656051946413257.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25942/Tue Sep 29 15:56:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/26/20 6:27 AM, John Fastabend wrote:
> This implements a new helper skb_adjust_room() so users can push/pop
> extra bytes from a BPF_SK_SKB_STREAM_VERDICT program.
> 
> Some protocols may include headers and other information that we may
> not want to include when doing a redirect from a BPF_SK_SKB_STREAM_VERDICT
> program. One use case is to redirect TLS packets into a receive socket
> that doesn't expect TLS data. In TLS case the first 13B or so contain the
> protocol header. With KTLS the payload is decrypted so we should be able
> to redirect this to a receiving socket, but the receiving socket may not
> be expecting to receive a TLS header and discard the data. Using the
> above helper we can pop the header off and put an appropriate header on
> the payload. This allows for creating a proxy between protocols without
> extra hops through the stack or userspace.
> 
> So in order to fix this case add skb_adjust_room() so users can strip the
> header. After this the user can strip the header and an unmodified receiver
> thread will work correctly when data is redirected into the ingress path
> of a sock.
> 
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>   net/core/filter.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 51 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 4d8dc7a31a78..d232358f1dcd 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -76,6 +76,7 @@
>   #include <net/bpf_sk_storage.h>
>   #include <net/transp_v6.h>
>   #include <linux/btf_ids.h>
> +#include <net/tls.h>
>   
>   static const struct bpf_func_proto *
>   bpf_sk_base_func_proto(enum bpf_func_id func_id);
> @@ -3218,6 +3219,53 @@ static u32 __bpf_skb_max_len(const struct sk_buff *skb)
>   			  SKB_MAX_ALLOC;
>   }
>   
> +BPF_CALL_4(sk_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
> +	   u32, mode, u64, flags)
> +{
> +	unsigned int len_diff_abs = abs(len_diff);

small nit: u32

> +	bool shrink = len_diff < 0;
> +	int ret = 0;
> +
> +	if (unlikely(flags))
> +		return -EINVAL;

Parameter 'mode' is not used here, I guess we need to reject anything non-zero?

Similarly, any interaction wrt bpf_csum_level() that was needed back then for the
bpf_skb_adjust_room()?

> +	if (unlikely(len_diff_abs > 0xfffU))
> +		return -EFAULT;
> +
> +	if (!shrink) {
> +		unsigned int grow = len_diff;

nit: u32 or just directly len_diff?

> +		ret = skb_cow(skb, grow);
> +		if (likely(!ret)) {
> +			__skb_push(skb, len_diff_abs);
> +			memset(skb->data, 0, len_diff_abs);
> +		}
> +	} else {
> +		/* skb_ensure_writable() is not needed here, as we're
> +		 * already working on an uncloned skb.
> +		 */
> +		if (unlikely(!pskb_may_pull(skb, len_diff_abs)))
> +			return -ENOMEM;
> +		__skb_pull(skb, len_diff_abs);
> +	}
> +	bpf_compute_data_end_sk_skb(skb);
> +	if (tls_sw_has_ctx_rx(skb->sk)) {
> +		struct strp_msg *rxm = strp_msg(skb);
> +
> +		rxm->full_len += len_diff;

If skb_cow() failed, we still adjust rxm->full_len?

> +	}
> +	return ret;
> +}
> +
> +static const struct bpf_func_proto sk_skb_adjust_room_proto = {
> +	.func		= sk_skb_adjust_room,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +	.arg2_type	= ARG_ANYTHING,
> +	.arg3_type	= ARG_ANYTHING,
> +	.arg4_type	= ARG_ANYTHING,
> +};
> +
>   BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
>   	   u32, mode, u64, flags)
>   {
> @@ -6483,6 +6531,7 @@ bool bpf_helper_changes_pkt_data(void *func)
>   	    func == bpf_skb_change_tail ||
>   	    func == sk_skb_change_tail ||
>   	    func == bpf_skb_adjust_room ||
> +	    func == sk_skb_adjust_room ||
>   	    func == bpf_skb_pull_data ||
>   	    func == sk_skb_pull_data ||
>   	    func == bpf_clone_redirect ||
> @@ -6950,6 +6999,8 @@ sk_skb_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		return &sk_skb_change_tail_proto;
>   	case BPF_FUNC_skb_change_head:
>   		return &sk_skb_change_head_proto;
> +	case BPF_FUNC_skb_adjust_room:
> +		return &sk_skb_adjust_room_proto;
>   	case BPF_FUNC_get_socket_cookie:
>   		return &bpf_get_socket_cookie_proto;
>   	case BPF_FUNC_get_socket_uid:
> 

