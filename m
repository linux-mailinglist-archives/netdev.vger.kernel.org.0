Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFA1261C20
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 21:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731681AbgIHTPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 15:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:60364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731770AbgIHTPB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 15:15:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B62F2087D;
        Tue,  8 Sep 2020 19:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599592499;
        bh=2HfdP+uSD5/p7nJvzoH7AHXzOMn2xyhHfqtxGKx4uEg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HO9sK1Anvq+u++KVP3n4AQ2N/ifsSKCyR+HPXhxwlgt56x/6MhqfVQzNgfGEE93UI
         WUChRLBf3kpsDzgTYDuykNEmqPy/7WUZruF8hr+QhbOQCNkc5avG+EMKZ6hD5kaziw
         Mp3Rzlv9MnGRDXgLmt+aoe73zV/k2IHSQpObBgGQ=
Date:   Tue, 8 Sep 2020 12:14:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v3 4/9] gve: Add support for dma_mask register
Message-ID: <20200908121457.0dc67f75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908183909.4156744-5-awogbemila@google.com>
References: <20200908183909.4156744-1-awogbemila@google.com>
        <20200908183909.4156744-5-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Sep 2020 11:39:04 -0700 David Awogbemila wrote:
> +	dma_mask = readb(&reg_bar->dma_mask);
> +	// Default to 64 if the register isn't set
> +	if (!dma_mask)
> +		dma_mask = 64;
>  	gve_write_version(&reg_bar->driver_version);
>  	/* Get max queues to alloc etherdev */
>  	max_rx_queues = ioread32be(&reg_bar->max_tx_queues);
>  	max_tx_queues = ioread32be(&reg_bar->max_rx_queues);
> +
> +	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));

You use the constant 64, not dma_mask?

You jump through hoops to get GFP_DMA allocations yet you don't set the
right DMA mask. Why would swiotlb become an issue to you if there never
was any reasonable mask set?

> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to set dma mask: err=%d\n", err);
> +		goto abort_with_reg_bar;
> +	}
> +
> +	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));

dma_set_mask_and_coherent()

> +	if (err) {
> +		dev_err(&pdev->dev,
> +			"Failed to set consistent dma mask: err=%d\n", err);
> +		goto abort_with_reg_bar;
> +	}
