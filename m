Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D9363B6B0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbiK2Am6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234129AbiK2Am5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:42:57 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141ACDFC7;
        Mon, 28 Nov 2022 16:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wbeLW34bc4cmMK+53LmuwvcRYDANepCHmKUoPCQ9gFM=; b=EB8u3pcD1VxhbU43/eb0ZkDYNu
        Vb5XBN+d8icIiOfdDV4d/tDentIerCE+IYddBREAKK2nMQx3FyOq8Kez1DywnIDUhkA/VvCryTsc9
        ACAmIYHXdotnNxqObcNNwMbIBJQv62edD+tgeMaoqHAdWXAhkv+uA3mxrptE6oWtGbAIqTtSvYSCt
        bAu5W7n1V2BJbpVDx3je214Tpa+6x7NzwQBMcS5JyeF21RGp5DPdxnGMWRy69/zHTsKLA3aeZSv5A
        rgcd1WEF5hKw07tnyvYyOAjfb77VwOocMeBdAp6BPRpjsfdbV1T+zwEFsf7f58rdHXpa4u+xs8R96
        BEgH4ZQw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35466)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ozoi3-0000DC-4K; Tue, 29 Nov 2022 00:42:51 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ozohz-00011y-6r; Tue, 29 Nov 2022 00:42:47 +0000
Date:   Tue, 29 Nov 2022 00:42:47 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v2 2/2] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <Y4VVhwQqk2iwBzao@shell.armlinux.org.uk>
References: <20221128195409.100873-1-sean.anderson@seco.com>
 <20221128195409.100873-2-sean.anderson@seco.com>
 <Y4VCz2i+kkK0z+XY@shell.armlinux.org.uk>
 <b25b1d9b-35dd-a645-a5f4-05eb0dbc6039@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b25b1d9b-35dd-a645-a5f4-05eb0dbc6039@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 07:21:56PM -0500, Sean Anderson wrote:
> On 11/28/22 18:22, Russell King (Oracle) wrote:
> > This doesn't make any sense. priv->supported_speeds is the set of speeds
> > read from the PMAPMD. The only bits that are valid for this are the
> > MDIO_PMA_SPEED_* definitions, but teh above switch makes use of the
> > MDIO_PCS_SPEED_* definitions. To see why this is wrong, look at these
> > two definitions:
> > 
> > #define MDIO_PMA_SPEED_10               0x0040  /* 10M capable */
> > #define MDIO_PCS_SPEED_2_5G             0x0040  /* 2.5G capable */
> > 
> > Note that they are the same value, yet above, you're testing for bit 6
> > being clear effectively for both 10M and 2.5G speeds. I suspect this
> > is *not* what you want.
> > 
> > MDIO_PMA_SPEED_* are only valid for the PMAPMD MMD (MMD 1).
> > MDIO_PCS_SPEED_* are only valid for the PCS MMD (MMD 3).
> 
> Ugh. I almost noticed this from the register naming...
> 
> Part of the problem is that all the defines are right next to each other
> with no indication of what you just described.

That's because they all refer to the speed register which is at the same
address, but for some reason the 802.3 committees decided to make the
register bits mean different things depending on the MMD. That's why the
definition states the MMD name in it.

This is true of all definitions in mdio.h - the naming convention is of
the format "MDIO_mmd_register_bit" where the bit is specific to a MMD,
or "MDIO_register_bit" where it is non-specific (e.g. the status
register 1 link status bit.)

> Anyway, what I want are the PCS/PMA speeds from the 2018 revision, which
> this phy seems to follow.

I think we should add further entries for the PMA/PMD speed register.
For example, 2.5G is bit 13 and 5G is bit 14. (vs bits 6 and 7 for the
PCS MMD version of the speed register.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
