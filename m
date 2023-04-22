Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B496EB8E3
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 13:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjDVLsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 07:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjDVLsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 07:48:19 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DA21BF2;
        Sat, 22 Apr 2023 04:48:17 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pqBis-000840-13;
        Sat, 22 Apr 2023 13:48:10 +0200
Date:   Sat, 22 Apr 2023 12:48:06 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Chen Minqiang <ptpt52@gmail.com>, Chukun Pan <amadeus@jmu.edu.cn>,
        Yevhen Kolomeiko <jarvis2709@gmail.com>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: [RFC PATCH net-next 0/8] Improvements for RealTek 2.5G Ethernet PHYs
Message-ID: <cover.1682163424.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve support for RealTek 2.5G Ethernet PHYs (RTL822x series).
The PHYs can operate with Clause-22 and Clause-45 MDIO.

When using Clause-45 it is desireable to avoid rate-adapter mode and
rather have the MAC interface mode follow the PHY speed. The PHYs
support 2500Base-X for 2500M, and Cisco SGMII for 1000M/100M/10M.

Also prepare support for proprietary RealTek HiSGMII mode which will
be needed for situations when used with RealTek switch or router SoCs
such as RTL93xx.

Add support for Link Down Power Saving Mode (ALDPS) which is already
supported for older RTL821x series 1GbE PHYs.

Make sure that link-partner advertised modes are only used if the
advertisement can be considered valid. Otherwise we are seeing
false-positives warning about downscaling eventhough higher speeds
are not actually advertised by the link partner.

While at it, improve the driver by using existing macros and inline
functions which are not actually vendor specific.

Alexander Couzens (1):
  net: phy: realtek: rtl8221: allow to configure SERDES mode

Chukun Pan (1):
  net: phy: realtek: switch interface mode for RTL822x series

Daniel Golle (6):
  net: phy: realtek: use genphy_soft_reset for 2.5G PHYs
  net: phy: realtek: disable SGMII in-band AN for 2.5G PHYs
  net: phy: realtek: use phy_read_paged instead of open coding
  net: phy: realtek: use inline functions for 10GbE advertisement
  net: phy: realtek: check validity of 10GbE link-partner advertisement
  net: phy: realtek: setup ALDPS on RTL822x

 drivers/net/phy/realtek.c | 152 ++++++++++++++++++++++++++++++++------
 1 file changed, 130 insertions(+), 22 deletions(-)


base-commit: fbc1449d385d65be49a8d164dfd3772f2cb049ae
-- 
2.40.0

