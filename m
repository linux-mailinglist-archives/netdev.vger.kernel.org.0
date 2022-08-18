Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421AB598C73
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241095AbiHRTSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240831AbiHRTSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:18:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51276DF70
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 12:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=M4oJ5+KHxJBmccFEyzR5dyGWHFc44gSPTRT/0qlIL3U=; b=vVrWsawdQcUSoxPuV8dKWM5mec
        jbvCVtnxDGmRrSV8JZjUPwW+izxOWpHQ4j//obCjdDCpnulFy8G8nAF1mxsOx/CN2XpoOzdCgFEk7
        pv1nUQOTDb2q8nOkIWr/J9HpgFnUWC2cUO5bHvuSQEUrlgSWqWMYM+MkNNPjbDz1BVCg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOl22-00DphW-QN; Thu, 18 Aug 2022 21:18:18 +0200
Date:   Thu, 18 Aug 2022 21:18:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH 1/2] net: moxa: do not call dma_unmap_single() with null
Message-ID: <Yv6QenTMPkO6gSTI@lunn.ch>
References: <20220818182948.931712-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818182948.931712-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 09:29:47PM +0300, Sergei Antonov wrote:
> It fixes a warning during error unwinding:
> 
> WARNING: CPU: 0 PID: 1 at kernel/dma/debug.c:963 check_unmap+0x704/0x980
> DMA-API: moxart-ethernet 92000000.mac: device driver tries to free DMA memory it has not allocated [device address=0x0000000000000000] [size=1600 bytes]
> CPU: 0 PID: 1 Comm: swapper Not tainted 5.19.0+ #60
> Hardware name: Generic DT based system
>  unwind_backtrace from show_stack+0x10/0x14
>  show_stack from dump_stack_lvl+0x34/0x44
>  dump_stack_lvl from __warn+0xbc/0x1f0
>  __warn from warn_slowpath_fmt+0x94/0xc8
>  warn_slowpath_fmt from check_unmap+0x704/0x980
>  check_unmap from debug_dma_unmap_page+0x8c/0x9c
>  debug_dma_unmap_page from moxart_mac_free_memory+0x3c/0xa8
>  moxart_mac_free_memory from moxart_mac_probe+0x190/0x218
>  moxart_mac_probe from platform_probe+0x48/0x88
>  platform_probe from really_probe+0xc0/0x2e4
> 
> Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")
> Signed-off-by: Sergei Antonov <saproj@gmail.com>

This looks correct as it is:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

But i do wonder how it go into the situation:

	for (i = 0; i < RX_DESC_NUM; i++) {
		desc = priv->rx_desc_base + i * RX_REG_DESC_SIZE;
		memset(desc, 0, RX_REG_DESC_SIZE);
		moxart_desc_write(RX_DESC0_DMA_OWN, desc + RX_REG_OFFSET_DESC0);
		moxart_desc_write(RX_BUF_SIZE & RX_DESC1_BUF_SIZE_MASK,
		       desc + RX_REG_OFFSET_DESC1);

		priv->rx_buf[i] = priv->rx_buf_base + priv->rx_buf_size * i;
		priv->rx_mapping[i] = dma_map_single(&ndev->dev,
						     priv->rx_buf[i],
						     priv->rx_buf_size,
						     DMA_FROM_DEVICE);
		if (dma_mapping_error(&ndev->dev, priv->rx_mapping[i]))
			netdev_err(ndev, "DMA mapping error\n");

		moxart_desc_write(priv->rx_mapping[i],
		       desc + RX_REG_OFFSET_DESC2 + RX_DESC2_ADDRESS_PHYS);
		moxart_desc_write((uintptr_t)priv->rx_buf[i],
		       desc + RX_REG_OFFSET_DESC2 + RX_DESC2_ADDRESS_VIRT);
	}

There is no way out of this, such that it only allocates some but not
all. So maybe there was an dma_mapping_error, it printed: DMA mapping
error, but kept going? So maybe another patch would be good, making
moxart_mac_setup_desc_ring() return an error when something goes
wrong?

    Andrew
