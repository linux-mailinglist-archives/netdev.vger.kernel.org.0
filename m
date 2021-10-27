Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5465843D6F9
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 00:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbhJ0Wzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 18:55:42 -0400
Received: from www62.your-server.de ([213.133.104.62]:39074 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhJ0Wzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 18:55:42 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mfrnC-000CtE-Ho; Thu, 28 Oct 2021 00:53:10 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mfrnC-000D9B-4d; Thu, 28 Oct 2021 00:53:10 +0200
Subject: Re: [PATCH v16 bpf-next 19/20] net: xdp: introduce bpf_xdp_pointer
 utility routine
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
References: <cover.1634301224.git.lorenzo@kernel.org>
 <98e60294b7ba81ca647cffd4d7b87617e9b1e9d9.1634301224.git.lorenzo@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3d196d1d-69f3-0ff2-1752-f318defbbf33@iogearbox.net>
Date:   Thu, 28 Oct 2021 00:53:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <98e60294b7ba81ca647cffd4d7b87617e9b1e9d9.1634301224.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26335/Wed Oct 27 10:28:55 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/15/21 3:08 PM, Lorenzo Bianconi wrote:
[...]
> +static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset,
> +			     u32 len, void *buf)
> +{
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	u32 size = xdp->data_end - xdp->data;
> +	void *addr = xdp->data;
> +	u32 frame_sz = size;
> +	int i;
> +
> +	if (xdp_buff_is_mb(xdp))
> +		frame_sz += sinfo->xdp_frags_size;
> +
> +	if (offset + len > frame_sz)
> +		return ERR_PTR(-EINVAL);

Given offset is ARG_ANYTHING, the above could overflow. In bpf_skb_*_bytes() we
guard with offset > 0xffff.

> +	if (offset < size) /* linear area */
> +		goto out;
> +
> +	offset -= size;
> +	for (i = 0; i < sinfo->nr_frags; i++) { /* paged area */
> +		u32 frag_size = skb_frag_size(&sinfo->frags[i]);
> +
> +		if  (offset < frag_size) {
> +			addr = skb_frag_address(&sinfo->frags[i]);
> +			size = frag_size;
> +			break;
> +		}
> +		offset -= frag_size;
> +	}
> +
> +out:
> +	if (offset + len < size)
> +		return addr + offset; /* fast path - no need to copy */
> +
> +	if (!buf) /* no copy to the bounce buffer */
> +		return NULL;
> +
> +	/* slow path - we need to copy data into the bounce buffer */
> +	bpf_xdp_copy_buf(xdp, offset, len, buf, false);
> +	return buf;
> +}
> +
> +BPF_CALL_4(bpf_xdp_load_bytes, struct xdp_buff *, xdp, u32, offset,
> +	   void *, buf, u32, len)
> +{
> +	void *ptr;
> +
> +	ptr = bpf_xdp_pointer(xdp, offset, len, buf);
> +	if (ptr == ERR_PTR(-EINVAL))
> +		return -EINVAL;

nit + same below in *_store_bytes(): IS_ERR(ptr) return PTR_ERR(ptr); ? (Or
should we just return -EFAULT to make it analog to bpf_skb_{load,store}_bytes()?
Either is okay, imho.)

> +	if (ptr != buf)
> +		memcpy(buf, ptr, len);
> +
> +	return 0;
> +}
> +
> +static const struct bpf_func_proto bpf_xdp_load_bytes_proto = {
> +	.func		= bpf_xdp_load_bytes,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +	.arg2_type	= ARG_ANYTHING,
> +	.arg3_type	= ARG_PTR_TO_MEM,

ARG_PTR_TO_UNINIT_MEM, or do you need the dst buffer to be initialized?

> +	.arg4_type	= ARG_CONST_SIZE_OR_ZERO,

ARG_CONST_SIZE

> +};
> +
> +BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
> +	   void *, buf, u32, len)
> +{
> +	void *ptr;
> +
> +	ptr = bpf_xdp_pointer(xdp, offset, len, NULL);
> +	if (ptr == ERR_PTR(-EINVAL))
> +		return -EINVAL;
> +
> +	if (!ptr)
> +		bpf_xdp_copy_buf(xdp, offset, len, buf, true);
> +	else
> +		memcpy(ptr, buf, len);
> +
> +	return 0;
> +}
> +
> +static const struct bpf_func_proto bpf_xdp_store_bytes_proto = {
> +	.func		= bpf_xdp_store_bytes,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +	.arg2_type	= ARG_ANYTHING,
> +	.arg3_type	= ARG_PTR_TO_MEM,
> +	.arg4_type	= ARG_CONST_SIZE_OR_ZERO,

ARG_CONST_SIZE, or do you have a use case for bpf_xdp_store_bytes(..., buf, 0)?

> +};
> +
>   static int bpf_xdp_mb_increase_tail(struct xdp_buff *xdp, int offset)
>   {
>   	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> @@ -7619,6 +7749,10 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		return &bpf_xdp_adjust_tail_proto;
>   	case BPF_FUNC_xdp_get_buff_len:
>   		return &bpf_xdp_get_buff_len_proto;
> +	case BPF_FUNC_xdp_load_bytes:
> +		return &bpf_xdp_load_bytes_proto;
> +	case BPF_FUNC_xdp_store_bytes:
> +		return &bpf_xdp_store_bytes_proto;
>   	case BPF_FUNC_fib_lookup:
>   		return &bpf_xdp_fib_lookup_proto;
>   	case BPF_FUNC_check_mtu:
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 1cb992ec0cc8..dad1d8c3a4c1 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -4920,6 +4920,22 @@ union bpf_attr {
>    *		Get the total size of a given xdp buff (linear and paged area)
>    *	Return
>    *		The total size of a given xdp buffer.
> + *
> + * long bpf_xdp_load_bytes(struct xdp_buff *xdp_md, u32 offset, void *buf, u32 len)
> + *	Description
> + *		This helper is provided as an easy way to load data from a
> + *		xdp buffer. It can be used to load *len* bytes from *offset* from
> + *		the frame associated to *xdp_md*, into the buffer pointed by
> + *		*buf*.
> + *	Return
> + *		0 on success, or a negative error in case of failure.
> + *
> + * long bpf_xdp_store_bytes(struct xdp_buff *xdp_md, u32 offset, void *buf, u32 len)
> + *	Description
> + *		Store *len* bytes from buffer *buf* into the frame
> + *		associated to *xdp_md*, at *offset*.
> + *	Return
> + *		0 on success, or a negative error in case of failure.
>    */
>   #define __BPF_FUNC_MAPPER(FN)		\
>   	FN(unspec),			\
> @@ -5101,6 +5117,8 @@ union bpf_attr {
>   	FN(get_branch_snapshot),	\
>   	FN(trace_vprintk),		\
>   	FN(xdp_get_buff_len),		\
> +	FN(xdp_load_bytes),		\
> +	FN(xdp_store_bytes),		\
>   	/* */
>   
>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> 

