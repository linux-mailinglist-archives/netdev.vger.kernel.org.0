Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEE7590E31
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 11:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbiHLJfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 05:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbiHLJfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 05:35:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20163A7AB9;
        Fri, 12 Aug 2022 02:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660296904; x=1691832904;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JbmcTfRAA4pDA3o1rph4T4jxRVh2idM8SrXExwKpUMo=;
  b=Y79Goh4kh1W5r0WDWFi4ZJy3ZpK+G+xVVGc33kvzBUlSHkqs4moyfW7t
   2y55HezccJrbdzfSrn9EcrdZg8k+BXiMvYW65nJDhfKRJPlBysNk5vHuE
   lyex3yju1gtOv161AFCTYXtt5FUGcGA/cbIso+DQbU0gqdfWCdgQRFZO/
   cF1DNX4qYagQMk5kktPBFFMvl9OXJef7keMDcbm3rIcjSQH6dmruKg7Oo
   fOLYF8cC84fzsPe20og9fDcY3yLE0Xtrri3o6OFsK9fyFucU/BjiVD3Uv
   KMmmggYncEwwyWes0slG1+9GAZyNlsNEQcR/91AauwVx9mMVIcgJAKM4e
   g==;
X-IronPort-AV: E=Sophos;i="5.93,231,1654585200"; 
   d="scan'208";a="176122179"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Aug 2022 02:35:03 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 12 Aug 2022 02:35:02 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.28 via Frontend Transport; Fri, 12 Aug 2022 02:34:58 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King" <linux@armlinux.org.uk>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: [Patch net] net: dsa: microchip: ksz9477: fix fdb_dump last invalid entry
Date:   Fri, 12 Aug 2022 15:04:11 +0530
Message-ID: <20220812093411.5879-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the ksz9477_fdb_dump function it reads the ALU control register and
exit from the timeout loop if there is valid entry or search is
complete. After exiting the loop, it reads the alu entry and report to
the user space irrespective of entry is valid. It works till the valid
entry. If the loop exited when search is complete, it reads the alu
table. The table returns all ones and it is reported to user space. So
bridge fdb show gives ff:ff:ff:ff:ff:ff as last entry for every port.
To fix it, after exiting the loop the entry is reported only if it is
valid one.

Fixes: c2e866911e25 ("net: dsa: microchip: break KSZ9477 DSA driver into two files")
Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 4b14d80d27ed..aa961dc03ddf 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -613,15 +613,17 @@ int ksz9477_fdb_dump(struct ksz_device *dev, int port,
 			goto exit;
 		}
 
-		/* read ALU table */
-		ksz9477_read_table(dev, alu_table);
+		if (ksz_data & ALU_VALID) {
+			/* read ALU table */
+			ksz9477_read_table(dev, alu_table);
 
-		ksz9477_convert_alu(&alu, alu_table);
+			ksz9477_convert_alu(&alu, alu_table);
 
-		if (alu.port_forward & BIT(port)) {
-			ret = cb(alu.mac, alu.fid, alu.is_static, data);
-			if (ret)
-				goto exit;
+			if (alu.port_forward & BIT(port)) {
+				ret = cb(alu.mac, alu.fid, alu.is_static, data);
+				if (ret)
+					goto exit;
+			}
 		}
 	} while (ksz_data & ALU_START);
 

base-commit: f86d1fbbe7858884d6754534a0afbb74fc30bc26
-- 
2.36.1

