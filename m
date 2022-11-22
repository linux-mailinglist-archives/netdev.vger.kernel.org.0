Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6EE6331B4
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiKVA7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiKVA7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:59:07 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E58B682A7;
        Mon, 21 Nov 2022 16:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zPVMcCH9Caitlz3wUBlsPo77SkoefyvanEm3LccCtxY=; b=jtQozGfH5eP3OXUAZE+c34a19J
        7Ag2NmZxjvTihPff4lb1ygaDigB1vazuQnodxMEpdgWxKRNXwKcwAkEYulfRtFqO1XI3ar7ZSjhhW
        TNURY7ibyYW7uU4EWHaVjR/1LeBYbJqoSv70K6d4RZfM2zru5Op1XpuzJG2+FE5DvtCA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oxHck-0034Is-NX; Tue, 22 Nov 2022 01:58:54 +0100
Date:   Tue, 22 Nov 2022 01:58:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] net: ethernet: ti: am65-cpsw: Fix set channel
 operation
Message-ID: <Y3wezv4J9NTSU4R3@lunn.ch>
References: <20221121142300.9320-1-rogerq@kernel.org>
 <20221121142300.9320-2-rogerq@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121142300.9320-2-rogerq@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 04:22:57PM +0200, Roger Quadros wrote:
> The set channel operation "ethtool -L tx <n>" broke with
> the recent suspend/resume changes.
> 
> Revert back to original driver behaviour of not freeing
> the TX/RX IRQs at am65_cpsw_nuss_common_stop(). We will
> now free them only on .suspend() as we need to release
> the DMA channels (as DMA looses context) and re-acquiring
> them on .resume() may not necessarily give us the same
> IRQs.
> 
> Introduce am65_cpsw_nuss_remove_rx_chns() which is similar
> to am65_cpsw_nuss_remove_tx_chns() and invoke them both in
> .suspend().
> 
> At .resume() call am65_cpsw_nuss_init_rx/tx_chns() to
> acquire the DMA channels.
> 
> To as IRQs need to be requested after knowing the IRQ
> numbers, move am65_cpsw_nuss_ndev_add_tx_napi() call to
> am65_cpsw_nuss_init_tx_chns().

It is probably easier to review if you first do a revert and then add
the new code to make suspend/resume work.

    Andrew
