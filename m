Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E854A69DCFD
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbjBUJgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbjBUJgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:36:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EF42331E;
        Tue, 21 Feb 2023 01:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KdDpi/cMpel8T3gS+13huy7I25xOSZPa1qLiuPacEiA=; b=u9HlxeXMVrTXdGYDuHowY4cggB
        qz4KTD70OHei4n0MLkhiryszsrhs/ImnpW7c9I+/Ntm492iHeuve7LVM/rSrsiRHvKNBlkiVwbKJn
        Qi1nV815+p3ql/g+qAKyyx/0c35BDhsn8TGCEL/5mwS6+Jn75kxNPezPMv7vcxvudYmcuLFknrPwg
        iSaTmZgqMJz1vLyVvyD+rxAv9ijtLm4JPUdvOEOeUzQp40fA6dgPKd49WgePzOsksq/ChHhk7j5F0
        2yIPMBKaDn6TakeCGOetpTvMktnXxI7yKQLZml1isdm/fvxvKg0JTAWhueXHNMeTJcESBrQ6D2uaY
        Og8zg/1A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55790)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pUP4f-0005Zh-ST; Tue, 21 Feb 2023 09:36:37 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pUP4d-00026d-OY; Tue, 21 Feb 2023 09:36:35 +0000
Date:   Tue, 21 Feb 2023 09:36:35 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] net: phy: EEE fixes
Message-ID: <Y/SQo20Qes2GpoeM@shell.armlinux.org.uk>
References: <20230221050334.578012-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221050334.578012-1-o.rempel@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 06:03:30AM +0100, Oleksij Rempel wrote:
> changes v2:
> - restore previous ethtool set logic for the case where advertisements
>   are not provided by user space.

I don't think the _kernel_ should be doing this - this introduces a
different behaviour to the kernel. As I already said, setting the
default advertisement in the case of ethtool -s is done by userspace
not by the kernel.

In fact, the kernel explicitly rejects an attempt to have autoneg
enabled with a zero advertising mask:

        linkmode_copy(advertising, cmd->link_modes.advertising);
        linkmode_and(advertising, advertising, phydev->supported);
        if (autoneg == AUTONEG_ENABLE && linkmode_empty(advertising))
                return -EINVAL;

and I think we should have a uniform behaviour with the same API,
rather than different behaviours, as that becomes quite messy.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
