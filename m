Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04794677F07
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 16:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbjAWPNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 10:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbjAWPNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 10:13:35 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD4C29144
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 07:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CfSLi4sVrQcaG5diEu/HrcqEJGCE81fRwrcbrFYaco0=; b=O8yQb9DksDg0unOI2F5keThJJq
        J/xB1qNmyGuzVSIzxAEUAiqTg+j6PYp/MrANfpBrGCPl7iZv4YbZXKtXVueaHGT45wV1wzG4YYHdA
        fieOCRwvoRa1I+4ezbyJlBriSRzkTe1lCWncTHVoeYIz+2ZrZWvB1sBJtVd1U8IGTP9I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pJyVa-002uwq-P5; Mon, 23 Jan 2023 16:13:18 +0100
Date:   Mon, 23 Jan 2023 16:13:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next 01/10] net: libwx: Add irq flow functions
Message-ID: <Y86kDphvyHj21IxK@lunn.ch>
References: <20230118065504.3075474-1-jiawenwu@trustnetic.com>
 <20230118065504.3075474-2-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230118065504.3075474-2-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + * wx_acquire_msix_vectors - acquire MSI-X vectors
> + * @wx: board private structure
> + *
> + * Attempts to acquire a suitable range of MSI-X vector interrupts. Will
> + * return a negative error code if unable to acquire MSI-X vectors for any
> + * reason.
> + */
> +static int wx_acquire_msix_vectors(struct wx *wx)
> +{
> +	struct irq_affinity affd = {0, };
> +	int nvecs, i;
> +
> +	nvecs = min_t(int, num_online_cpus(), wx->mac.max_msix_vectors);
> +
> +	wx->msix_entries = kcalloc(nvecs,
> +				   sizeof(struct msix_entry),
> +				   GFP_KERNEL);
> +	if (!wx->msix_entries)
> +		return -ENOMEM;

> + * wx_set_interrupt_capability - set MSI-X or MSI if supported
> + * @wx: board private structure to initialize
> + *
> + * Attempt to configure the interrupts using the best available
> + * capabilities of the hardware and the kernel.
> + **/
> +static void wx_set_interrupt_capability(struct wx *wx)
> +{
> +	int nvecs;
> +
> +	/* We will try to get MSI-X interrupts first */
> +	if (!wx_acquire_msix_vectors(wx))
> +		return;

This could return -ENOMEM. You should return that up the call stack.

I would suggest you make this check more specific. Success, or real
errors, return here, with 0 or -errcode. If it indicates MSI-X are not
available then do the fallback.

> +
> +	wx->num_rx_queues = 1;
> +	wx->num_tx_queues = 1;
> +	wx->num_q_vectors = 1;
> +
> +	/* minmum one for queue, one for misc*/
> +	nvecs = 1;
> +	nvecs = pci_alloc_irq_vectors(wx->pdev, nvecs,
> +				      nvecs, PCI_IRQ_MSI);
> +	if (nvecs < 0)
> +		wx_err(wx, "Failed to allocate MSI interrupts. Error: %d\n", nvecs);

If you don't have MSI-X or MSI interrupt, is the device usable? I
would expect some fatal error handling here.

> +/**
> + * wx_cache_ring_rss - Descriptor ring to register mapping for RSS
> + * @wx: board private structure to initialize
> + *
> + * Cache the descriptor ring offsets for RSS, ATR, FCoE, and SR-IOV.
> + *
> + **/
> +static bool wx_cache_ring_rss(struct wx *wx)
> +{
> +	u16 i;
> +
> +	for (i = 0; i < wx->num_rx_queues; i++)
> +		wx->rx_ring[i]->reg_idx = i;
> +
> +	for (i = 0; i < wx->num_tx_queues; i++)
> +		wx->tx_ring[i]->reg_idx = i;
> +
> +	return true;

What is the point of returning true. This cannot fail, so make it
void.

	Andrew
