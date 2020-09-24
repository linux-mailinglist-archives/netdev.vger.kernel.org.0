Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1652E277BD5
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgIXWvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbgIXWvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 18:51:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3FA923600;
        Thu, 24 Sep 2020 22:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600987866;
        bh=/md7wVL5FcEqWRLC73bqhh0ppcXhJ/PB0OKGSev2RO4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=self7MIULg2dIpA6rrnt2JKUgSGryL4D69i69RYp/5sZEJEE/Fq2QG9MiusYojPxE
         OO7FI13zUk3p8+eAGqNS5IOxfLjpSNB8AYX1DOiZLqPD1I7wldRE30cIPjefCyEVyf
         MYwnABrulPVrsC7u3fwmEJCJdb/tF7Sb79gyd5KA=
Date:   Thu, 24 Sep 2020 15:51:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v3 4/4] gve: Add support for raw addressing in
 the tx path
Message-ID: <20200924155103.7b1dda5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200924010104.3196839-5-awogbemila@google.com>
References: <20200924010104.3196839-1-awogbemila@google.com>
        <20200924010104.3196839-5-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Sep 2020 18:01:04 -0700 David Awogbemila wrote:
> +	info->skb =  skb;

double space

> +	addr = dma_map_single(tx->dev, skb->data, len, DMA_TO_DEVICE);
> +	if (unlikely(dma_mapping_error(tx->dev, addr))) {
> +		priv->dma_mapping_error++;
> +		goto drop;
> +	}
> +	buf = &info->buf;
> +	dma_unmap_len_set(buf, len, len);
> +	dma_unmap_addr_set(buf, dma, addr);
> +
> +	payload_nfrags = shinfo->nr_frags;
> +	if (hlen < len) {
> +		/* For gso the rest of the linear portion of the skb needs to
> +		 * be in its own descriptor.
> +		 */
> +		payload_nfrags++;
> +		gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
> +				     1 + payload_nfrags, hlen, addr);

This..

> +		len -= hlen;
> +		addr += hlen;
> +		seg_desc = &tx->desc[(tx->req + 1) & tx->mask];
> +		seg_idx_bias = 2;
> +		gve_tx_fill_seg_desc(seg_desc, skb, is_gso, len, addr);
> +	} else {
> +		seg_idx_bias = 1;
> +		gve_tx_fill_pkt_desc(pkt_desc, skb, is_gso, l4_hdr_offset,
> +				     1 + payload_nfrags, hlen, addr);

and this look identical. You can probably move it before the if.

Otherwise this one is:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
