Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B684F670D89
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 00:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjAQXcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 18:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjAQXbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 18:31:34 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00D78C939;
        Tue, 17 Jan 2023 12:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673989036; x=1705525036;
  h=from:to:subject:date:message-id:mime-version;
  bh=HUcDI0BDItLq7xPF3mfX4cfv5vHR9dKnvrxx0RnOSpw=;
  b=hIHtaNoCthkwQOEzYTSI/lWkxomc4UtVqUHZkBrS5x8cCRyod7q1bJdM
   oGfVBWfqBzV4eBXG2JtvJUz963Kph1tO7HIfASCS3GdkrYKBZcNRLcb1s
   APNHvBbU9NKumBgTRLSw1eXsEX10rL8dkd4dieYBDrEJONSFFeUXI9Dnf
   CjkmcqPbULtrN/+HqEsg8TrF8F+nBvrN2Rur8YiZsXJjsFuIiGCiCChU6
   kB+9nAWDNsfedrIoRxr1Nek4MNIeDWcQHXbiPBdMT/sT/nTB4zZlBxq8+
   QaS2gYlyXYlHkDexO6EkO+uZQvI5TQCS8UG0abbimMGZ7hMYU3EeT2lvy
   g==;
X-IronPort-AV: E=Sophos;i="5.97,224,1669100400"; 
   d="scan'208";a="197058697"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 13:57:06 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 13:57:06 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 13:57:04 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [net-next: PATCH v7 0/7] dsa: lan9303: Move to PHYLINK
Date:   Tue, 17 Jan 2023 14:56:56 -0600
Message-ID: <20230117205703.25960-1-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series moves the lan9303 driver to use the phylink
api away from phylib.

Migrating to phylink means removing the .adjust_link api. The
functionality from the adjust_link is moved to the phylink_mac_link_up
api.  The code being removed only affected the cpu port.  The other
ports on the LAN9303 do not need anything from the phylink_mac_link_up
api.

Patches:
 0001 - Whitespace only change aligning the dsa_switch_ops members.
	No code changes.
 0002 - Moves the Turbo bit initialization out of the adjust_link api and
	places it in a driver initialization execution path. It only needs
	to be initialized once, it is never changed, and it is not a
	per-port flag.
 0003 - Adds exception handling logic in the extremely unlikely event that
	the read of the device fails.
 0004 - Performance optimization that skips a slow register write if there
	is no need to perform it.
 0005 - Change the way we identify the xMII port as phydev will be NULL
	when this logic is moved into phylink_mac_link_up.
 0006 - Removes adjust_link and begins using the phylink dsa_switch_ops
	apis.
 0007 - Adds XMII port flow control settings in the phylink_mac_link_up()
	api while cleaning up the ANEG / speed / duplex implementation.
---
v6->v7:
  - Moved the initialization of the Turbo bit into lan9303_setup().
  - Added a macro for determining is a port is an XMII port.
  - Added setting the XMII flow control in the phylink_mac_link_up() API.
  - removed unnecessary error handling and cleaned up the code flow in
    phylink_mac_link_up().
v5->v6:
  - Moved to using port number to identify xMII port for the LAN9303.
v4->v5:
  - Created prep patches to better show how things migrate.
  - cleaned up comments.
v3->v4:
  - Addressed whitespace issues as a separate patch.
  - Removed port_max_mtu api patch as it is unrelated to phylink migration.
  - Reworked the implementation to preserve the adjust_link functionality
    by including it in the phylink_mac_link_up api.
v2->v3:
  Added back in disabling Turbo Mode on the CPU MII interface.
  Removed the unnecessary clearing of the phy supported interfaces.
v1->v2:
  corrected the reported mtu size, removing ETH_HLEN and ETH_FCS_LEN

 drivers/net/dsa/lan9303-core.c | xx ++++++++++++--------
 1 file changed

