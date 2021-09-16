Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CF140E81E
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 20:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350407AbhIPRnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 13:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355816AbhIPRmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 13:42:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3605661354;
        Thu, 16 Sep 2021 16:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631811345;
        bh=Y6ogfNCq7iZeP1OxSikDX0fSuRFi/23SCRGDL/oRs6M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sRJ+eIzLseHdePhc/xawCa3Dl5sAMr/8edWkdvuK7J1b09ZrxQlMrlDj7cB9cBvmQ
         2MWJQr9dpKtqFbqLdOCHQy6uwFcu4sB7vg84RDzDlsLW6/YG0BJmQByWlLmPWDph0A
         6Cdx4Bb20w/m+RnKjziBw241q+tDsH8cyQ5WNwULFnmI5A7W5+RpFmDnRGG9cbNUbK
         l5m8oOxJd7ABoXzllGz9XLRvKruZqA+7bA6P6Yt+iOFYiDjmOAqwDL0NnlQb/o1BPg
         Bz3EWlqKlYluV1mO7o++vcYteUr0K31J0R5b4dziWF6cbvVcn2fWzqIA6xL6CXlnfl
         tBj+v0QOnqPWA==
Date:   Thu, 16 Sep 2021 09:55:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v14 bpf-next 10/18] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <20210916095544.50978cd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e07aa987d148c168f1ac95a315d45e24e58c54f5.1631289870.git.lorenzo@kernel.org>
References: <cover.1631289870.git.lorenzo@kernel.org>
        <e07aa987d148c168f1ac95a315d45e24e58c54f5.1631289870.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Sep 2021 18:14:16 +0200 Lorenzo Bianconi wrote:
> From: Eelco Chaudron <echaudro@redhat.com>
> 
> This change adds support for tail growing and shrinking for XDP multi-buff.
> 
> When called on a multi-buffer packet with a grow request, it will always
> work on the last fragment of the packet. So the maximum grow size is the
> last fragments tailroom, i.e. no new buffer will be allocated.
> 
> When shrinking, it will work from the last fragment, all the way down to
> the base buffer depending on the shrinking size. It's important to mention
> that once you shrink down the fragment(s) are freed, so you can not grow
> again to the original size.
> 
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

> +static inline unsigned int xdp_get_frag_tailroom(const skb_frag_t *frag)
> +{
> +	struct page *page = skb_frag_page(frag);
> +
> +	return page_size(page) - skb_frag_size(frag) - skb_frag_off(frag);
> +}

How do we deal with NICs which can pack multiple skbs into a page frag?
skb_shared_info field to mark the end of last fragment? Just want to make 
sure there is a path to supporting such designs.

> +static int bpf_xdp_mb_adjust_tail(struct xdp_buff *xdp, int offset)
> +{
> +	struct skb_shared_info *sinfo;
> +
> +	sinfo = xdp_get_shared_info_from_buff(xdp);
> +	if (offset >= 0) {
> +		skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags - 1];
> +		int size;
> +
> +		if (unlikely(offset > xdp_get_frag_tailroom(frag)))
> +			return -EINVAL;
> +
> +		size = skb_frag_size(frag);
> +		memset(skb_frag_address(frag) + size, 0, offset);
> +		skb_frag_size_set(frag, size + offset);
> +		sinfo->xdp_frags_size += offset;
> +	} else {
> +		int i, n_frags_free = 0, len_free = 0, tlen_free = 0;
> +
> +		offset = abs(offset);
> +		if (unlikely(offset > ((int)(xdp->data_end - xdp->data) +
> +				       sinfo->xdp_frags_size - ETH_HLEN)))
> +			return -EINVAL;
> +
> +		for (i = sinfo->nr_frags - 1; i >= 0 && offset > 0; i--) {
> +			skb_frag_t *frag = &sinfo->frags[i];
> +			int size = skb_frag_size(frag);
> +			int shrink = min_t(int, offset, size);
> +
> +			len_free += shrink;
> +			offset -= shrink;
> +
> +			if (unlikely(size == shrink)) {
> +				struct page *page = skb_frag_page(frag);
> +
> +				__xdp_return(page_address(page), &xdp->rxq->mem,
> +					     false, NULL);
> +				tlen_free += page_size(page);
> +				n_frags_free++;
> +			} else {
> +				skb_frag_size_set(frag, size - shrink);
> +				break;
> +			}
> +		}
> +		sinfo->nr_frags -= n_frags_free;
> +		sinfo->xdp_frags_size -= len_free;
> +		sinfo->xdp_frags_truesize -= tlen_free;
> +
> +		if (unlikely(offset > 0)) {
> +			xdp_buff_clear_mb(xdp);
> +			xdp->data_end -= offset;
> +		}
> +	}
> +
> +	return 0;
> +}

nit: most of this function is indented, situation is ripe for splitting
     it into two
