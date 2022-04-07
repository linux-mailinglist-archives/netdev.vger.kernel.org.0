Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7461A4F8B8D
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbiDGWxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 18:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbiDGWwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 18:52:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB85B4B843
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 15:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=1OH6I0ObUxD1g+FLt/JDRxws6p3n2wldr4oMty3N2DU=; b=kt6TY85qtLVIQx6ij0L1UXfb6I
        JwQa2R50xamsWLVDp/L0MXSpQlqREzEiyy2NzUe+Hc7OfI+Gu0t9q1zsMdwhgs4vdlUEeYionXaAB
        /PBDT6TBXgNfYoeq32xsKp4avkwBY1qCfteQlAvosUlAbnzUAL/CkhTPnfGrmLxlfvsk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ncaxj-00EjHb-Re; Fri, 08 Apr 2022 00:50:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v0 RFC RFT net-next 0/5] Use MMD/C45 helpers
Date:   Fri,  8 Apr 2022 00:50:18 +0200
Message-Id: <20220407225023.3510609-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MDIO busses can perform two sorts of bus transaction, defined in
clause 22 and clause 45 of 802.3. This results in two register
addresses spaces. The current driver structure for indicating if C22
or C45 should be used is messy, and many C22 only bus drivers will
wrongly interpret a C45 transaction as a C22 transaction.

This patchset is a preparation step to cleanup the situation. It
converts MDIO bus users to make use of existing _mmd and _c45 helpers
to perform accesses to C45 registers. This will later allow C45 and
C22 to be kept separate.

I don't have any of this hardware, so request testing where possible.

Andrew Lunn (5):
  net: phylink: Convert to mdiobus_c45_{read|write}
  net: phy: Convert to mdiobus_c45_{read|write}
  net: phy: bcm87xx: Use mmd helpers
  net: dsa: sja1105: Convert to mdiobus_c45_read
  net: pcs: pcs-xpcs: Convert to mdiobus_c45_read

 drivers/net/dsa/sja1105/sja1105_main.c |  5 ++--
 drivers/net/pcs/pcs-xpcs.c             |  6 ++---
 drivers/net/phy/bcm87xx.c              |  5 ++--
 drivers/net/phy/phy.c                  | 18 +++++++++------
 drivers/net/phy/phylink.c              | 32 ++++++++++++++------------
 5 files changed, 34 insertions(+), 32 deletions(-)

-- 
2.35.1

