Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE7B446B3A
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 00:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbhKEXcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 19:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232329AbhKEXcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 19:32:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4633561037;
        Fri,  5 Nov 2021 23:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636154975;
        bh=ItuVj4ZCBb/4t68SXxbU328vuz5etR5fJsUwxRKFs8U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GN5kjKXV5msCzLyxbKp2V+3kqUjL8Fp84chGjv23Jfkn4oHA9+66y+azvxCbYXVWj
         nKiKNTk83lG7s0AZNdWnlsqOnwokB1v3u/flTTLaqMYmDOcoGDaFU+9K9bBMJqcipW
         5IODn/7P6pv9rFLUprRYZprAoheaVbnCRXUSgoR0VbuRasqom1sAOKbA1V8BY2BLhs
         jMEdemsBe/5cUSx22pEfGnJRfFxFLAAPaR181KzpY7AnGJTa+/dmM9/OWy8ObrhP8V
         gSop3/OV0lOLoI8IK9DmuK2bDJAXdyMBiGQDt+k+6YUN3R08lPt8oJiPWhUabUGNUV
         mBkzCmqF2kKSQ==
Date:   Fri, 5 Nov 2021 16:29:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v17 bpf-next 13/23] bpf: add multi-buffer support to xdp
 copy helpers
Message-ID: <20211105162933.113ce3c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <637cb9a21958e1a5026faba6255debf21d229d1d.1636044387.git.lorenzo@kernel.org>
References: <cover.1636044387.git.lorenzo@kernel.org>
        <637cb9a21958e1a5026faba6255debf21d229d1d.1636044387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Nov 2021 18:35:33 +0100 Lorenzo Bianconi wrote:
> -static unsigned long bpf_xdp_copy(void *dst_buff, const void *src_buff,
> +static unsigned long bpf_xdp_copy(void *dst_buff, const void *ctx,
>  				  unsigned long off, unsigned long len)
>  {
> -	memcpy(dst_buff, src_buff + off, len);
> +	unsigned long base_len, copy_len, frag_off_total;
> +	struct xdp_buff *xdp = (struct xdp_buff *)ctx;
> +	struct skb_shared_info *sinfo;
> +	int i;
> +
> +	if (likely(!xdp_buff_is_mb(xdp))) {

Would it be better to do

	if (xdp->data_end - xdp->data >= off + len)

?

> +		memcpy(dst_buff, xdp->data + off, len);
> +		return 0;
> +	}
> +
> +	base_len = xdp->data_end - xdp->data;
> +	frag_off_total = base_len;
> +	sinfo = xdp_get_shared_info_from_buff(xdp);
> +
> +	/* If we need to copy data from the base buffer do it */
> +	if (off < base_len) {
> +		copy_len = min(len, base_len - off);
> +		memcpy(dst_buff, xdp->data + off, copy_len);
> +
> +		off += copy_len;
> +		len -= copy_len;
> +		dst_buff += copy_len;
> +	}
> +
> +	/* Copy any remaining data from the fragments */
> +	for (i = 0; len && i < sinfo->nr_frags; i++) {
> +		skb_frag_t *frag = &sinfo->frags[i];
> +		unsigned long frag_len, frag_off;
> +
> +		frag_len = skb_frag_size(frag);
> +		frag_off = off - frag_off_total;
> +		if (frag_off < frag_len) {
> +			copy_len = min(len, frag_len - frag_off);
> +			memcpy(dst_buff,
> +			       skb_frag_address(frag) + frag_off, copy_len);
> +
> +			off += copy_len;
> +			len -= copy_len;
> +			dst_buff += copy_len;
> +		}
> +		frag_off_total += frag_len;
> +	}
> +

nit: can't help but feel that you can merge base copy and frag copy:

	sinfo = xdp_get_shared_info_from_buff(xdp);
	next_frag = &sinfo->frags[0];
	end_frag = &sinfo->frags[sinfo->nr_frags];

	ptr_off = 0;
	ptr_buf = xdp->data;
	ptr_len = xdp->data_end - xdp->data;

	while (true) {
		if (off < ptr_off + ptr_len) {
			copy_off = ptr_off - off;
			copy_len = min(len, ptr_len - copy_off);
			memcpy(dst_buff, ptr_buf + copy_off, copy_len);

			off += copy_len;
			len -= copy_len;
			dst_buff += copy_len;
		}

		if (!len || next_frag == end_frag)
			break;
	
		ptr_off += ptr_len;
		ptr_buf = skb_frag_address(next_frag);
		ptr_len = skb_frag_size(next_frag);
		next_frag++;
	}

Up to you.
