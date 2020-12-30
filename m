Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A312E7B73
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 18:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgL3RGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 12:06:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgL3RGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 12:06:47 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91DCC061799;
        Wed, 30 Dec 2020 09:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UL2S7Y+8ynSaVqx8eXrSJ8C08oLdKUB2jzvE74MMIzg=; b=UZfPJ52ciTXBMr72k7+rO1VBa
        9ffTCz9EHMbVtfut64qkmG/ZH5N6P8FdMCATiy6p6wLDDTnw/KnewANHk4STZ4WX36EkDodgFS3kC
        MmnhH7w9kK3bO5thgwAMSAEmP7/L2pnVgF7qOHqakTgGrCHrYEpModm3QMvJnOgxOBp9Wh/Mc7Yt4
        AaqNFg4D7ZDCJ63GjT4DYQ1VfbI1hkKplESz92vZ6+9yioVhpl/mpJGcsgzZwxshLxC/IJcNNTDPH
        rgLWC9fe2hA3iSzy7Xe23VEhvotMYuxHN2fFIi5Mar1NMV+uug6xycFeYt2qbb234Y4zI/6A2MPzY
        LaImFUa/Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44918)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kueuw-0005q1-OB; Wed, 30 Dec 2020 17:05:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kueuw-0002Lo-68; Wed, 30 Dec 2020 17:05:46 +0000
Date:   Wed, 30 Dec 2020 17:05:46 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20201230170546.GU1551@shell.armlinux.org.uk>
References: <20201230154755.14746-1-pali@kernel.org>
 <20201230154755.14746-2-pali@kernel.org>
 <20201230161036.GR1551@shell.armlinux.org.uk>
 <20201230165634.c4ty3mw6djezuyq6@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201230165634.c4ty3mw6djezuyq6@pali>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 05:56:34PM +0100, Pali Rohár wrote:
> This change is really required for those Realtek chips. I thought that
> it is obvious that from *both* addresses 0x50 and 0x51 can be read only
> one byte at the same time. Reading 2 bytes (for be16 value) cannot be
> really done by one i2 transfer, it must be done in two.

Then these modules are even more broken than first throught, and
quite simply it is pointless supporting the diagnostics on them
because we can never read the values in an atomic way.

It's also a violation of the SFF-8472 that _requires_ multi-byte reads
to read these 16 byte values atomically. Reading them with individual
byte reads results in a non-atomic read, and the 16-bit value can not
be trusted to be correct.

That is really not optional, no matter what any manufacturer says - if
they claim the SFP MSAs allows it, they're quite simply talking out of
a donkey's backside and you should dispose of the module in biohazard
packaging. :)

So no, I hadn't understood this from your emails, and as I say above,
if this is the case, then we quite simply disable diagnostics on these
modules since they are _highly_ noncompliant.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
