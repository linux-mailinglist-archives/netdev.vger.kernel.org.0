Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF9C621255
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiKHN0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbiKHN0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:26:54 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4358517E3C
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3FP+ctssAZ38n+9zqsxTYetpFoDLyZreeNvBvZ5u73A=; b=aMAwQK7Hepn8aErpce8hjXN7Fv
        pc2GIsazRVzWohaTPqIaTpBKoRBAQw4yVjgdbtVJ2NezbWBcXdYcyo66YTtGG6QkIhKt/7x1+CiMX
        TFSaDLUHi6tPOpht9S3yqTq2WRXiDev1rH4JazDMRzAW6Yz7eTbU0Xr1sM8ME3oR9U58=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1osOch-001p1H-Ax; Tue, 08 Nov 2022 14:26:39 +0100
Date:   Tue, 8 Nov 2022 14:26:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 2/9] net: dsa: mv88e6xxx: account for PHY base address
 offset in dual chip mode
Message-ID: <Y2pZD/3AQV1gjbFV@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-3-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108082330.2086671-3-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 09:23:23AM +0100, Lukasz Majewski wrote:
> From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> 
> In dual chip mode (6250 family), not only global and port registers are
> shifted by sw_addr, but also the PHY addresses. Account for this in the
> IRQ mapping.

> +++ b/drivers/net/dsa/mv88e6xxx/smi.c
> @@ -186,5 +186,9 @@ int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
>  	if (chip->smi_ops->init)
>  		return chip->smi_ops->init(chip);
>  
> +	chip->phy_base_addr = chip->info->phy_base_addr;
> +	if (chip->info->dual_chip)
> +		chip->phy_base_addr += sw_addr;
> +
>  	return 0;


Again, reviewing first to last, i assume the will be a patch soon
implementing get_phy_address(), and it will have the same logic. Why
not call it here, a default implementation which returns
info->phy_base_addr, and a version for 6250 which returns sw_addr.

	Andrew
