Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81F5446B3E
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 00:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhKEXc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 19:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229917AbhKEXc0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 19:32:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37A33611EE;
        Fri,  5 Nov 2021 23:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636154985;
        bh=cCo1QKQ8tvjCSUO1vtMIYOHoaUDLmtGApcGaWzJRrSU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kbS2Qlla2NO1Ui3yN5KqDaZX8OgtPqhMzgGmLbHpcdB4E7MIWMK68cuYTRJRN5WZ4
         tZhLefft049m79RgGWBpqgb+Attphj9hGs92x7GppPZIt+HdLmvNGCv0ITbKkYmIAQ
         +i2WP8j586cKgQ22H/W5xhrtYbkeKR4ynBraRJFV1qLMLNhb58UBhwGSHOWAlmFj5u
         GMXE1MJQtz6u7EGTG7hwMN1rF1pvehNc4+bOLqcjbw6CKis9shMJrID0oRV2j3xyYa
         ayIH3Rq6HGIxeVwSUWE8WvWyLFfEZI5ks53iwcJKxX4T7jEHQsr6ACTGsElNn78hrw
         3xHg+j+bfCtCw==
Date:   Fri, 5 Nov 2021 16:29:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v17 bpf-next 20/23] net: xdp: introduce bpf_xdp_pointer
 utility routine
Message-ID: <20211105162944.5f58487e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <273cc085c8cbe5913defe302800fc69da650e7b1.1636044387.git.lorenzo@kernel.org>
References: <cover.1636044387.git.lorenzo@kernel.org>
        <273cc085c8cbe5913defe302800fc69da650e7b1.1636044387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Nov 2021 18:35:40 +0100 Lorenzo Bianconi wrote:
> Similar to skb_header_pointer, introduce bpf_xdp_pointer utility routine
> to return a pointer to a given position in the xdp_buff if the requested
> area (offset + len) is contained in a contiguous memory area otherwise it
> will be copied in a bounce buffer provided by the caller.
> Similar to the tc counterpart, introduce the two following xdp helpers:
> - bpf_xdp_load_bytes
> - bpf_xdp_store_bytes
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

> diff --git a/net/core/filter.c b/net/core/filter.c
> index 386dd2fffded..534305037ad7 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3840,6 +3840,135 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
>  	.arg2_type	= ARG_ANYTHING,
>  };
>  
> +static void bpf_xdp_copy_buf(struct xdp_buff *xdp, u32 offset,
> +			     u32 len, void *buf, bool flush)
> +{
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	u32 headsize = xdp->data_end - xdp->data;
> +	u32 count = 0, frame_offset = headsize;
> +	int i = 0;
> +
> +	if (offset < headsize) {
> +		int size = min_t(int, headsize - offset, len);
> +		void *src = flush ? buf : xdp->data + offset;
> +		void *dst = flush ? xdp->data + offset : buf;
> +
> +		memcpy(dst, src, size);
> +		count = size;
> +		offset = 0;
> +	}
> +
> +	while (count < len && i < sinfo->nr_frags) {

nit: for (i = 0; ...; i++) ?

> +		skb_frag_t *frag = &sinfo->frags[i++];
> +		u32 frag_size = skb_frag_size(frag);
> +
> +		if  (offset < frame_offset + frag_size) {

nit: double space after if

> +			int size = min_t(int, frag_size - offset, len - count);
> +			void *addr = skb_frag_address(frag);
> +			void *src = flush ? buf + count : addr + offset;
> +			void *dst = flush ? addr + offset : buf + count;
> +
> +			memcpy(dst, src, size);
> +			count += size;
> +			offset = 0;
> +		}
> +		frame_offset += frag_size;
> +	}
> +}
> +
> +static void *bpf_xdp_pointer(struct xdp_buff *xdp, u32 offset,
> +			     u32 len, void *buf)
> +{
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	u32 size = xdp->data_end - xdp->data;
> +	void *addr = xdp->data;
> +	int i;
> +
> +	if (unlikely(offset > 0xffff))
> +		return ERR_PTR(-EFAULT);
> +
> +	if (offset + len > xdp_get_buff_len(xdp))
> +		return ERR_PTR(-EINVAL);

I don't think it breaks anything but should we sanity check len?
Maybe make the test above (offset | len) > 0xffff -> EFAULT?

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
> +	if (IS_ERR(ptr))
> +		return PTR_ERR(ptr);
> +
> +	if (ptr != buf)
> +		memcpy(buf, ptr, len);

Maybe we should just call out to bpf_xdp_copy_buf() like store does
instead of putting one but not the other inside bpf_xdp_pointer().

We'll have to refactor this later for the real bpf_xdp_pointer,
I'd lean on the side of keeping things symmetric for now.

> +	return 0;
> +}

> +BPF_CALL_4(bpf_xdp_store_bytes, struct xdp_buff *, xdp, u32, offset,
> +	   void *, buf, u32, len)
> +{
> +	void *ptr;
> +
> +	ptr = bpf_xdp_pointer(xdp, offset, len, NULL);
> +	if (IS_ERR(ptr))
> +		return PTR_ERR(ptr);
> +
> +	if (!ptr)
> +		bpf_xdp_copy_buf(xdp, offset, len, buf, true);
> +	else
> +		memcpy(ptr, buf, len);
> +
> +	return 0;
> +}
