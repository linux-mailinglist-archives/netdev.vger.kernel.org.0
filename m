Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD735B7A8F
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 21:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiIMTGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 15:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiIMTGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 15:06:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8F6D86
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 12:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YDbkfiPKw3JEcERiUZRgalRT32kffmYhTpeX0a5dkWY=; b=zs23xz7onnteoTWs8p7bEm55WV
        4zlTtkmPRCAXWDezgT9vDXZ0C5OjnwrQEa2UpR8kBuy0C6+tMkYb8vARtpCl/Pn5TXR8ysBT/8dhs
        AYrMLU4c/zNpm+fScoEm4diX48JBG7l9R85LeBWLmrPF94e/M5gJw623XrzE3/VuEEQkmD4WZZRJk
        cb4TCS4tzUGhZRZpCyvA82AdMcFugs1Z4fgtCiQYnedpO0+wzJBvjdKErwiZWK05wbUYuPF4yOwuk
        upYOrAzg9LqPOBgQ2KGnlGqxidD8p8QdXimYTRtlbPHYDJMkV+VTiZZbgO4wkVUSGzpFBCdSNbz4F
        kNe+vmWg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34306)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oYBEV-0003QT-7s; Tue, 13 Sep 2022 20:06:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oYBEU-0000vE-5r; Tue, 13 Sep 2022 20:06:06 +0100
Date:   Tue, 13 Sep 2022 20:06:06 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Josef Schlehofer <pepe.schlehofer@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/5] sfp: add support for HALNy GPON module
Message-ID: <YyDUnvM1b0dZPmmd@shell.armlinux.org.uk>
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

This series adds support for the HALNy GPON SFP module. In order to do
this sensibly, we need a more flexible quirk system, since we need to
change the behaviour of the SFP cage driver to ignore the LOS and
TX_FAULT signals after module detection.

Since we move the SFP quirks into the SFP cage driver, we can use it
for the MA5671A and 3FE46541AA modules as well.

 drivers/net/phy/sfp-bus.c | 100 ++-------------------------
 drivers/net/phy/sfp.c     | 173 ++++++++++++++++++++++++++++++++++++++++------
 drivers/net/phy/sfp.h     |  10 ++-
 3 files changed, 163 insertions(+), 120 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
