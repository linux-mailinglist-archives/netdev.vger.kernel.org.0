Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D02498859
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 19:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245115AbiAXSal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 13:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbiAXSak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 13:30:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C9DC06173B;
        Mon, 24 Jan 2022 10:30:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FE5D614AD;
        Mon, 24 Jan 2022 18:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623CEC340E5;
        Mon, 24 Jan 2022 18:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643049039;
        bh=sWky1z6e82y61W+ExVfU6DywuqIuqx2MeSnFl2lNsr4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BUpSMogUy9XL3WKGYTkb5rIDTCR5WWPxazUcVTg6rgRYVwk/8EaVNy2RWvDx3lKrP
         /gy10YZIjTcqvcuI9XE011gwb+eF/tog2/HLTO2GIIr12ddLhRABsd/Y10yGyReF/J
         4fSBUK6onn8b1GEw5489RqKiR9TLfMPfpWPXkndzjeSTsUNweNkP74oBqnB01vJaL0
         QKEIPUU9w415bJnTxe01P2xyuMEOpR7kZaFEL4Vs0c68skjYpV+TfdYXVCr8otmtqm
         5Ll6+yMLjpj9377uk0JxHNwac33dXhbOPzpR0oBPUM/xctSzWCFIT3iRDKmGuXUiPL
         4XMSVIWyYAVPQ==
Date:   Mon, 24 Jan 2022 10:30:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tulip: remove redundant assignment to variable
 new_csr6
Message-ID: <20220124103038.76f15516@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220123183440.112495-1-colin.i.king@gmail.com>
References: <20220123183440.112495-1-colin.i.king@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Jan 2022 18:34:40 +0000 Colin Ian King wrote:
> Variable new_csr6 is being initialized with a value that is never
> read, it is being re-assigned later on. The assignment is redundant
> and can be removed.

> @@ -21,7 +21,7 @@ void pnic_do_nway(struct net_device *dev)
>  	struct tulip_private *tp = netdev_priv(dev);
>  	void __iomem *ioaddr = tp->base_addr;
>  	u32 phy_reg = ioread32(ioaddr + 0xB8);
> -	u32 new_csr6 = tp->csr6 & ~0x40C40200;
> +	u32 new_csr6;
>  
>  	if (phy_reg & 0x78000000) { /* Ignore baseT4 */
>  		if (phy_reg & 0x20000000)		dev->if_port = 5;

I can't say I see what you mean, it's not set in some cases:

			if (tp->medialock) {
			} else if (tp->nwayset  &&  (dev->if_port & 1)) {
				next_tick = 1*HZ;
			} else if (dev->if_port == 0) {
				dev->if_port = 3;
				iowrite32(0x33, ioaddr + CSR12);
				new_csr6 = 0x01860000;
				iowrite32(0x1F868, ioaddr + 0xB8);
			} else {
				dev->if_port = 0;
				iowrite32(0x32, ioaddr + CSR12);
				new_csr6 = 0x00420000;
				iowrite32(0x1F078, ioaddr + 0xB8);
			}
			if (tp->csr6 != new_csr6) {
				tp->csr6 = new_csr6;


That said clang doesn't complain so maybe I'm missing something static
analysis had figured out about this code.
