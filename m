Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29D9644BD3
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLFSfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiLFSfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:35:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13002DDE;
        Tue,  6 Dec 2022 10:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670351705; x=1701887705;
  h=from:to:subject:date:message-id:mime-version;
  bh=E8753zyjLDm0yzoPomzMO54qW0/wFObJcMt/t49KGLM=;
  b=u3LCP2B7hVuZPv5QO4iCoD7ETHec+by7JvOXZz7nr/LWb5iqgsR1vFym
   +HxCdpPj2Ox1TPvX/OBDsag8QVLW1bS7kYYUJtOGxl4WE33j5sDJ6TFT5
   RtTLnCD+X7NdaT7gDHW8bI7u6bQjJwHrm2E3B4rZJqk3LVRjxLynPRPZN
   Xb6Lpnc/M8yv/h59LKC/mlpxRM5Aa8DagJRzRqAcm9kCH4qijC+bUxH5i
   0jEzi3NclLbChxpcJpsovbWeZAUdd6HY+kunhJMtkwRvDr6Jk4fzneAwV
   m4DGoDiFRAxykaqbfq+OOsqR3ux7QHaho0HqNtvjLZ4U/WRqunHnp2qAv
   w==;
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="190327743"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Dec 2022 11:35:03 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 6 Dec 2022 11:35:03 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 6 Dec 2022 11:35:01 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@armlinux.org.uk>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v3 0/2] dsa: lan9303: Move to PHYLINK
Date:   Tue, 6 Dec 2022 12:34:58 -0600
Message-ID: <20221206183500.6898-1-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series moves the lan9303 driver to use the phylink
api away from phylib.

1) adds port_max_mtu api support.
2) Replace .adjust_link with .phylink_get_caps dsa api

Clearing the Turbo Mode bit previously done in the adjust_link
API is moved to the driver initialization immediately following
the successful detection of a LAN93xx device.  It is forced to a
disabled state and never enabled.

At this point, I do not see anything this driver needs from the other
phylink APIs.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>

---
v2-> v3:
  Added back in disabling Turbo Mode on the CPU MII interface.
  Removed the unnecessary clearing of the phyvsupported interfaces.
v1-> v2:
  corrected the reported mtu size, removing ETH_HLEN and ETH_FCS_LEN

 drivers/net/dsa/lan9303-core.c | 93 ++++++++++++--------
 1 file changed, 56 insertions(+), 37 deletions(-)

