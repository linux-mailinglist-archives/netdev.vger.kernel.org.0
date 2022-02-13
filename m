Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8FB44B3D08
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 19:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237904AbiBMS6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 13:58:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235146AbiBMS6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 13:58:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D7658388;
        Sun, 13 Feb 2022 10:58:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IFdGaNlKE8lE7EacFhEg2jRX1+ugoc5r9KbK+Pal+TE=; b=aU/PanSVBLQHmYSisf+/Wgo8MK
        MqSnlCKO/9/CHMv0zJz94JTbLoC2jJqsDtTU/IPz/tbDpZyA9hOycmALvBxVW94pJa808ImHMM6m1
        37mlU4YN4WA9100IB39iSXLwulyv3Rgn9FX6Ff4za43xHbkoca67pyEKpl6KE6BEmpkml7Nfe9eg3
        zKpvljqYyxBkv/84Zrbj32dHxQSomHL1mBlKRxjDJz2oIesix6nhk8hg+vy2KN3BJ+1Sibks1cr0m
        286Xm9QIw5LKXNYRkvfsLjQ01t7rr5rg9ovAcH5toN5tT0aMOQ+03azxOEXXA1bJM5kGYYLzKgQ5L
        JFEerYXQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57234)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nJK53-0000ac-AZ; Sun, 13 Feb 2022 18:58:41 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nJK51-0005n0-7r; Sun, 13 Feb 2022 18:58:39 +0000
Date:   Sun, 13 Feb 2022 18:58:39 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: dsa: mv88e6xxx: Fix validation of
 built-in PHYs on 6095/6097
Message-ID: <YglU36CAyMoJbxEX@shell.armlinux.org.uk>
References: <20220213185154.3262207-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220213185154.3262207-1-tobias@waldekranz.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 13, 2022 at 07:51:54PM +0100, Tobias Waldekranz wrote:
> These chips have 8 built-in FE PHYs and 3 SERDES interfaces that can
> run at 1G. With the blamed commit, the built-in PHYs could no longer
> be connected to, using an MII PHY interface mode.
> 
> Create a separate .phylink_get_caps callback for these chips, which
> takes the FE/GE split into consideration.
> 
> Fixes: 2ee84cfefb1e ("net: dsa: mv88e6xxx: convert to phylink_generic_validate()")
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
