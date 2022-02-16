Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB884B8C00
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbiBPPEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:04:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbiBPPEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:04:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A3F1E682B
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IE6suBkTnw43hF4QRVpKDZ8u/R+RY+NkFEUS2GtKMgE=; b=DwoNbLQVVm3hmy4WVUD6fmz5U2
        Vt0TdC1NuPdadYlG0qunY76m7JU4b+EkC1O/3C88UiGc4KSjEOnKoYzxI1SoK72ANuIxb9jAb2TfF
        d/s0RT7ADzfdVI8GtVkJfb3q//mrl6qMpPYoLPGvJEp6BbBqsaXm5Fwg4gsxZ7Z1ENOmnxGkAj5zq
        uiMieOjytqGcz+ggaCJHFbUFf1qindTmInmF1OnZXiDPQTCqtizRt8bkV1NE0ZDO3xmgMh/hUuD8P
        4s87TH27ZwrW3M5xOn1hWSfh1TW0rGH6lGKYiq4730eUHOR/qLBsorax/grdKySPTf1Cbtj4N2aZs
        zFb13v+Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57288)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nKLqc-0003yW-M6; Wed, 16 Feb 2022 15:04:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nKLqa-0000AP-FU; Wed, 16 Feb 2022 15:04:00 +0000
Date:   Wed, 16 Feb 2022 15:04:00 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/6] net: dsa: qca8k: convert to phylink_pcs and
 mark as non-legacy
Message-ID: <Yg0SYHh1YNWsPB1D@shell.armlinux.org.uk>
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

Posted 8 days ago as CFT, and received one response unrelated to
reviewing of testing this patch set.

 drivers/net/dsa/qca8k.c | 738 +++++++++++++++++++++++++++---------------------
 drivers/net/dsa/qca8k.h |   8 +
 include/net/dsa.h       |   3 +
 net/dsa/port.c          |  15 +
 4 files changed, 436 insertions(+), 328 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
