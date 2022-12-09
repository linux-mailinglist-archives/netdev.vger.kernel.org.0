Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B353D648AD6
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiLIWrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiLIWrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:47:19 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0591C12A;
        Fri,  9 Dec 2022 14:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670626037; x=1702162037;
  h=from:to:subject:date:message-id:mime-version;
  bh=QscC73kq0p64g37vmGx5wDJw00wcjEIWLqcqcPelmAI=;
  b=PQeCh/l7Xk0z+FA7CM+MyDird7H1tbJM3Maz+AZoMP4M9TmvdY4YcdGf
   /wBo/wa1946sAGF5PwmPH0mUN2Vy7Qjo8xCoITyKAc6FZh81O77honc8j
   +tyP+EUZHFWrfqT+EUgeTV2spF8kZS4wLEMnvoQp5FIkInC8Bsg5uZzOj
   h4zc/0hXP0H+sBs5Sad6MoG6+xEmIlTc8KtAUrKQtQiS17mBwdqrJd6rf
   EVKkx9JD1wmXyq5ziE4tXFOG3/h1m3niiL3ecQYOrg1QRiCwJtGvDEuLo
   9TNERoqEooKuZiPvrOeRg6wOaCJdiT4R5uFBaHYJ/hofyQgWeZBn3LxyL
   g==;
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="187455845"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 15:47:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 15:47:15 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Dec 2022 15:47:14 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v5 0/6] dsa: lan9303: Move to PHYLINK
Date:   Fri, 9 Dec 2022 16:47:07 -0600
Message-ID: <20221209224713.19980-1-jerry.ray@microchip.com>
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

Migrating to phylink means removing the .adjust_link api. The
functionality from the adjust_link is moved to the phylink_mac_link_up
api.  The code being removed only affected the cpu port.  The other
ports on the LAN9303 do not need anything from the phylink_mac_link_up api.

Patches:
 0001 - Whitespace only change aligning the dsa_switch_ops members.
	No code changes.
 0002 - Moves the Turbo bit initialization out of the adjust_link api and
	places it in a driver initialization execution path. It only needs
	to be initialized once, it is never changed, and it is not a
	per-port flag.
 0003 - Adds exception handling logic in the extremely unlikely event that
	the read of the device fails.
 0004 - Performance optimization that skips a slow register write if there is
	no need to perform it.
 0005 - Change the macro used to identify the cpu port as phydev will be NULL
	when this logic is moved into phylink_mac_link_up.
 0006 - Removes adjust_link and begins using the phylink dsa_switch_ops apis.

---
v3->v5:
  - Created prep patches to better show how things migrate.
  - cleaned up comments.
v3->v4:
  - Addressed whitespace issues as a separate patch.
  - Removed port_max_mtu api patch as it is unrelated to phylink migration.
  - Reworked the implementation to preserve the adjust_link functionality
    by including it in the phylink_mac_link_up api.
v2->v3:
  Added back in disabling Turbo Mode on the CPU MII interface.
  Removed the unnecessary clearing of the phyvsupported interfaces.
v1->v2:
  corrected the reported mtu size, removing ETH_HLEN and ETH_FCS_LEN

 drivers/net/dsa/lan9303-core.c | xx ++++++++++++--------
 1 file changed

