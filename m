Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6552166D365
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 00:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbjAPXxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 18:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbjAPXww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 18:52:52 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E3C22A11;
        Mon, 16 Jan 2023 15:52:51 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 84B6019E1;
        Tue, 17 Jan 2023 00:52:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673913169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3qYLXyBc6yIyyK/QL6G5uDCUOcpKKSAsCoCRDUkxmQ=;
        b=YRLOsOmaFRKZei5adzuAH0AgP0yhArS53j0xCeiNyf4eSu6cevLBmQGDmv02QXMGPTqM3I
        gc7cg5NS3j1olshw8fSbxCXYdhMBiQpsjv94lGCJPoKjOrH3O7yhIzo1EhDdxH+dHwixRs
        xbMVwbCnCMyg1iXDf1YJk0cH+LIr7mYprGlOKUO7u4oz/oTf9fipLNitiOmDX5rRotolKx
        fnRnVdGX0yoFKiCLfjm1mKcq9qrMOQBCXSZIkgKIduCXq1bWPpBCuXc45emkSorCXbtAdR
        zH3n77hq0VeJVDTwEkR+sJa4K4+YoZqEElUwoue1N1S4SRypLEU0ZLt6nCJXVQ==
From:   Michael Walle <michael@walle.cc>
Date:   Tue, 17 Jan 2023 00:52:24 +0100
Subject: [PATCH net-next 09/12] amd-xgbe: Replace MII_ADDR_C45 with XGBE_ADDR_C45
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230116-net-next-c45-seperation-part-3-v1-9-0c53afa56aad@walle.cc>
References: <20230116-net-next-c45-seperation-part-3-v1-0-0c53afa56aad@walle.cc>
In-Reply-To: <20230116-net-next-c45-seperation-part-3-v1-0-0c53afa56aad@walle.cc>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Byungho An <bh74.an@samsung.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        linux-renesas-soc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

The xgbe driver reuses MII_ADDR_C45 for its own purpose. The values
derived with it are never passed to phylib or a linux MDIO bus driver.
In order that MII_ADDR_C45 can be removed, add an XGBE specific

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/amd/xgbe/xgbe-common.h | 11 ++++++-----
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c    | 16 ++++++++--------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-common.h b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
index 466273b22f0a..3fd9728f817f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-common.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-common.h
@@ -1699,20 +1699,21 @@ do {									\
 } while (0)
 
 /* Macros for building, reading or writing register values or bits
- * using MDIO.  Different from above because of the use of standardized
- * Linux include values.  No shifting is performed with the bit
- * operations, everything works on mask values.
+ * using MDIO.
  */
+
+#define XGBE_ADDR_C45 BIT(30)
+
 #define XMDIO_READ(_pdata, _mmd, _reg)					\
 	((_pdata)->hw_if.read_mmd_regs((_pdata), 0,			\
-		MII_ADDR_C45 | (_mmd << 16) | ((_reg) & 0xffff)))
+		XGBE_ADDR_C45 | (_mmd << 16) | ((_reg) & 0xffff)))
 
 #define XMDIO_READ_BITS(_pdata, _mmd, _reg, _mask)			\
 	(XMDIO_READ((_pdata), _mmd, _reg) & _mask)
 
 #define XMDIO_WRITE(_pdata, _mmd, _reg, _val)				\
 	((_pdata)->hw_if.write_mmd_regs((_pdata), 0,			\
-		MII_ADDR_C45 | (_mmd << 16) | ((_reg) & 0xffff), (_val)))
+		XGBE_ADDR_C45 | (_mmd << 16) | ((_reg) & 0xffff), (_val)))
 
 #define XMDIO_WRITE_BITS(_pdata, _mmd, _reg, _mask, _val)		\
 do {									\
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index aafa02fb3fdf..f393228d41c7 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -1157,8 +1157,8 @@ static int xgbe_read_mmd_regs_v2(struct xgbe_prv_data *pdata, int prtad,
 	unsigned int mmd_address, index, offset;
 	int mmd_data;
 
-	if (mmd_reg & MII_ADDR_C45)
-		mmd_address = mmd_reg & ~MII_ADDR_C45;
+	if (mmd_reg & XGBE_ADDR_C45)
+		mmd_address = mmd_reg & ~XGBE_ADDR_C45;
 	else
 		mmd_address = (pdata->mdio_mmd << 16) | (mmd_reg & 0xffff);
 
@@ -1189,8 +1189,8 @@ static void xgbe_write_mmd_regs_v2(struct xgbe_prv_data *pdata, int prtad,
 	unsigned long flags;
 	unsigned int mmd_address, index, offset;
 
-	if (mmd_reg & MII_ADDR_C45)
-		mmd_address = mmd_reg & ~MII_ADDR_C45;
+	if (mmd_reg & XGBE_ADDR_C45)
+		mmd_address = mmd_reg & ~XGBE_ADDR_C45;
 	else
 		mmd_address = (pdata->mdio_mmd << 16) | (mmd_reg & 0xffff);
 
@@ -1220,8 +1220,8 @@ static int xgbe_read_mmd_regs_v1(struct xgbe_prv_data *pdata, int prtad,
 	unsigned int mmd_address;
 	int mmd_data;
 
-	if (mmd_reg & MII_ADDR_C45)
-		mmd_address = mmd_reg & ~MII_ADDR_C45;
+	if (mmd_reg & XGBE_ADDR_C45)
+		mmd_address = mmd_reg & ~XGBE_ADDR_C45;
 	else
 		mmd_address = (pdata->mdio_mmd << 16) | (mmd_reg & 0xffff);
 
@@ -1248,8 +1248,8 @@ static void xgbe_write_mmd_regs_v1(struct xgbe_prv_data *pdata, int prtad,
 	unsigned int mmd_address;
 	unsigned long flags;
 
-	if (mmd_reg & MII_ADDR_C45)
-		mmd_address = mmd_reg & ~MII_ADDR_C45;
+	if (mmd_reg & XGBE_ADDR_C45)
+		mmd_address = mmd_reg & ~XGBE_ADDR_C45;
 	else
 		mmd_address = (pdata->mdio_mmd << 16) | (mmd_reg & 0xffff);
 

-- 
2.30.2
