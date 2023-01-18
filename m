Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6464F672570
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 18:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjARRsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 12:48:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjARRru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 12:47:50 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7D6CC37;
        Wed, 18 Jan 2023 09:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674064011; x=1705600011;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/y2B7Acpa6FvFH8fazzDGApEBpGDAqK/p5/R7++N3iA=;
  b=jbbVgpMHalHpnfj3NhmdA8JYuPh+GSx+HKNwYTTmD22kkzSMWNPCfy6m
   oNfQoNrkBnCKp42zr16QuUkllnqd5a3fdtij3GAJPte4UZW6sbKS3Fb4Y
   I4NDrlKx2SPPoTAzaQi9puu541LYiUtxf3wJaTivnXrSV12Y0I42Qb0Nw
   lEnjK3AmUXGQ7qWvo3QY+c2BmP6Wwt6a/y2vtOWmN1wiJxWuTEGLOlwWq
   546VRGjvcmefOdQaTMOFGRcbLk8LrBoPQqglqlOJmjCLzoxrhiaZsr8S4
   XLqNdzAjhOChq0P5xOxClP27H89OAOoeUCna+MPC9vvhtd39Mposws8cR
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,226,1669100400"; 
   d="scan'208";a="197188845"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2023 10:46:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 10:46:49 -0700
Received: from che-lt-i67786lx.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 10:46:45 -0700
From:   Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
Subject: [PATCH v2 net] net: dsa: microchip: ksz9477: port map correction in ALU table entry register
Date:   Wed, 18 Jan 2023 23:17:35 +0530
Message-ID: <20230118174735.702377-1-rakesh.sankaranarayanan@microchip.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

ALU table entry 2 register in KSZ9477 have bit positions reserved for
forwarding port map. This field is referred in ksz9477_fdb_del() for
clearing forward port map and alu table.

But current fdb_del refer ALU table entry 3 register for accessing forward
port map. Update ksz9477_fdb_del() to get forward port map from correct
alu table entry register.

With this bug, issue can be observed while deleting static MAC entries.
Delete any specific MAC entry using "bridge fdb del" command. This should
clear all the specified MAC entries. But it is observed that entries with
self static alone are retained.

Tested on LAN9370 EVB since ksz9477_fdb_del() is used common across
LAN937x and KSZ series.

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

---

v1->v2
- Based on the community feedback, removed patch from series and
  added as independent patch.
- Added Reviewed-by tag.

---
---
 drivers/net/dsa/microchip/ksz9477.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 47b54ecf2c6f..6178a96e389f 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -540,10 +540,10 @@ int ksz9477_fdb_del(struct ksz_device *dev, int port,
 		ksz_read32(dev, REG_SW_ALU_VAL_D, &alu_table[3]);
 
 		/* clear forwarding port */
-		alu_table[2] &= ~BIT(port);
+		alu_table[1] &= ~BIT(port);
 
 		/* if there is no port to forward, clear table */
-		if ((alu_table[2] & ALU_V_PORT_MAP) == 0) {
+		if ((alu_table[1] & ALU_V_PORT_MAP) == 0) {
 			alu_table[0] = 0;
 			alu_table[1] = 0;
 			alu_table[2] = 0;
-- 
2.34.1

