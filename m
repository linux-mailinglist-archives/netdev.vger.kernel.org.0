Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDC4482F19
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 09:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbiACIrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 03:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiACIrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 03:47:36 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3558C061761;
        Mon,  3 Jan 2022 00:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=llnu8QJu6fQ5fARI5nnJE4VOSVCuPtj0YARKDQ1XaDk=; b=iwanQ2KgFNcFbhFTx85/rdZzlu
        rWCNk7ZUS0f9diiadn9UNHsIQfNSHDMdaBYWMHbgDBzBkb8GjTC38YqoahD1rbTgYCYLiHtIIeX50
        U+GpCJB6LjP85sYpFftg0OtUNs1wkdwmGZ1L85NOeE4dNAadtlMSSLqQg9lzTjB00HGnQHTonC79A
        KdtvRZAGwvTWZUBw0K/IZWJZP0eV/LLqst/9LlRvlDmfEmw+T4qtwRbCV/BlXA3IRc49lwOgHpq1u
        6Uq1tmb5lreDO2Jst+fpcGiOIoMEeIYeogyVIj3dBfFzisxvogpiEAOPNEBX1uAlykqYT9z3TfdoZ
        OrFpM22w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n4J04-008c8E-Jv; Mon, 03 Jan 2022 08:47:28 +0000
Date:   Mon, 3 Jan 2022 00:47:28 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     benve@cisco.com, govind@gmx.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] enic: Use dma_set_mask_and_coherent()
Message-ID: <YdK4IIFvi5O5eXHC@infradead.org>
References: <f926eab883a3e5c4dbfd3eb5108b3e1828e6513b.1641045708.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f926eab883a3e5c4dbfd3eb5108b3e1828e6513b.1641045708.git.christophe.jaillet@wanadoo.fr>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 01, 2022 at 03:02:45PM +0100, Christophe JAILLET wrote:
> -	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(47));
> +	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(47));
>  	if (err) {
> +		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
>  		if (err) {
>  			dev_err(dev, "No usable DMA configuration, aborting\n");
>  			goto err_out_release_regions;
>  		}
>  	} else {
>  		using_dac = 1;

There is no need for the callback.  All the routines to set a DMA mask
will only fail if the passed in mask is too small, but never if it is
larger than what is supported.  Also the using_dac variable is not
needed, NETIF_F_HIGHDMA can and should be set unconditionally.
