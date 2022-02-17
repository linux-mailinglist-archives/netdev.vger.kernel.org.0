Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807914BA83D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244314AbiBQSaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:30:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244325AbiBQSaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:30:14 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00DA3890
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xscKnRpjLab8UG/eTaX0RRFX+ySzgEEoaPfdw1BTbr8=; b=jPe9JMKTFDb+aHBqkxgxoWvsyn
        +H08qn6co7DpJeB74P/pdGUzNJASchx7H1m7RKoptauamx93qvKJURlwYadM+uQSc+8QbfXZNCsJx
        wdRrIyii6qNXaVRboGmnlXmtb/Xc6bzhFp3J6aPE5FGqJytzx0LCnytM2NdMTUNMMD0ol5QAv/K3V
        oGa7zUOLoCdSC09XjavxyubAe9jdFOmN5+VtgIyTGtyPpp+sH83dp53rHNzwFHP2/puGrN/fnJoAw
        YhVH44uiF67CV8cdcuP07sbulnCcYxs+AxARs3Dm/YUGL85/rJ2tt9oFd3F1ZWPMrSVKKN23md0+Q
        YIeOqDPA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57304)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nKlXM-0005Fy-Jt; Thu, 17 Feb 2022 18:29:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nKlXK-0001HA-Mt; Thu, 17 Feb 2022 18:29:50 +0000
Date:   Thu, 17 Feb 2022 18:29:50 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2 0/6] net: dsa: qca8k: convert to phylink_pcs and
 mark as non-legacy
Message-ID: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
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

This series adds support into DSA for the mac_select_pcs method, and
converts qca8k to make use of this, eventually marking qca8k as non-
legacy.

Patch 1 adds DSA support for mac_select_pcs.
Patch 2 and patch 3 moves code around in qca8k to make patch 4 more
readable.
Patch 4 does a simple conversion to phylink_pcs.
Patch 5 moves the serdes configuration to phylink_pcs.
Patch 6 marks qca8k as non-legacy.

v2: fix dsa_phylink_mac_select_pcs() formatting and double-blank line
in patch 5

 drivers/net/dsa/qca8k.c | 737 +++++++++++++++++++++++++++---------------------
 drivers/net/dsa/qca8k.h |   8 +
 include/net/dsa.h       |   8 +-
 net/dsa/port.c          |  16 +-
 4 files changed, 435 insertions(+), 334 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
