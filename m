Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82D44FFBC7
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 18:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiDMQyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 12:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiDMQyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 12:54:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D3467D2B
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 09:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vZLpHPa/bYme4d063WT8Rn/fDax1uRG7Z+tDqIQzsx8=; b=sPXr9tsI57fY2JXI4hct3drzv6
        t/QR88rVjqlDfuocJpcKNJySM5UhiOOzLfgawlbg19wyllMez55sDnG+Wafo5s4znvt6sgOI8R9ch
        ZpoClF18gfDu1Qujmyrc+wEtK5muyn2AiuoPrhgPRx4RO/U37RnyCfObYzGWaaUoR73b+nKUMDr4S
        KF6uN2J7MITUtRgCogBmDiP4OxoJhCo6u+aJSi+gdAOJTkOu+haeHEyHWcqziR0hGsoFiU6AD9nRd
        BMjpf/UY0vOxrngnrMTLmPnXMiR7++UaunG2murykOlWNlu3FGvvCo4u7TnFT3jiSULPiUwZKfYsd
        8w6rRK9w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58244)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1negE5-0003QD-11; Wed, 13 Apr 2022 17:52:16 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1negE0-0003V6-6A; Wed, 13 Apr 2022 17:52:12 +0100
Date:   Wed, 13 Apr 2022 17:52:12 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 0/3] net: dsa: mv88e6xxx serdes fixes
Message-ID: <Ylb/vEWXHOmQ7sFd@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series addresses a number of deficiencies in the mv88e6xxx serdes
handling, namely:

1) incorrectly filling out state->an_complete - which was incorrectly
fixed due to confusion with the ANEGCAPABLE bit - patch from Marek to
fix this.

2) make the error print in patch 1 consistent with all the other error
prints.

3) ensure that we always capture a link-drop event by reading the link
status from the BMSR as well, and report link down if BMSR says the link
failed.

 drivers/net/dsa/mv88e6xxx/serdes.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
