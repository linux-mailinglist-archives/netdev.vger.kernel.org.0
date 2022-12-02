Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC7A6407B8
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 14:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiLBNel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 08:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbiLBNej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 08:34:39 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7104DC9353;
        Fri,  2 Dec 2022 05:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=D4fZpyrx2i5YjjD4vPxhMjurysVwUOy3bpQ9AthaYkY=; b=IM6kqtlkIUZ8tL3pUjeU4756yS
        j0Me6H9HF+gf/0z3nnpeRep6iS9Y0l5RBEEdQmrzNK9umpzesekxeB33XZ4KBgSVSnin9rdEVYz2X
        qcy3O8EhHNOwfJzmdBUmC3dbG4zlnMEWuks+Zz+l+Qo2V8AtNb4VhvpL3UHJ4zM64OFyx37QUgUR1
        F1BcjF1li2SZOGG2wDY+QQhSsbOBRXxEXkg57K0Cqf3Wc1vO2kWTcNpqACUmT3qel8ce1dfKfjjx2
        tb9npa6S5do0JQ1AJxRd+im5ioPQ/yQNmE2sbOWT+yEN75OiMGYX8zF1djM2mKlLdfMYx+yTEqcuF
        GB5WA6EQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35528)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p16BJ-00049F-H5; Fri, 02 Dec 2022 13:34:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p16BE-0004Qm-Of; Fri, 02 Dec 2022 13:34:16 +0000
Date:   Fri, 2 Dec 2022 13:34:16 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Frank <Frank.Sae@motor-comm.com>, Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: phy: Add driver for Motorcomm yt8531
 gigabit ethernet phy
Message-ID: <Y4n+2Ehvp6SInxUw@shell.armlinux.org.uk>
References: <20221202073648.3182-1-Frank.Sae@motor-comm.com>
 <Y4n9T+KGj/hX3C0e@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4n9T+KGj/hX3C0e@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 02:27:43PM +0100, Andrew Lunn wrote:
> > +static bool mdio_is_locked(struct phy_device *phydev)
> > +{
> > +	return mutex_is_locked(&phydev->mdio.bus->mdio_lock);
> > +}
> > +
> > +#define ASSERT_MDIO(phydev) \
> > +	WARN_ONCE(!mdio_is_locked(phydev), \
> > +		  "MDIO: assertion failed at %s (%d)\n", __FILE__,  __LINE__)
> > +
> 
> Hi Frank
> 
> You are not the only one who gets locking wrong. This could be used in
> other drivers. Please add it to include/linux/phy.h,

That placement doesn't make much sense.

As I already said, we have lockdep checks in drivers/net/phy/mdio_bus.c,
and if we want to increase their effectiveness, then that's the place
that it should be done.

I don't see any point in using __FILE__ and __LINE__ in the above
macro either. Firstly, WARN_ONCE() already includes the file and line,
and secondly, the backtrace is more useful than the file and line where
the assertion occurs especially if it's placed in mdio_bus.c

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
