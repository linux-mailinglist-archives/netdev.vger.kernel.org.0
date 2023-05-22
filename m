Return-Path: <netdev+bounces-4275-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B859C70BDC5
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:24:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73411280EF3
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92191154B1;
	Mon, 22 May 2023 12:17:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9BA1640D
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:17:14 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B511FE3;
	Mon, 22 May 2023 05:16:58 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-96f683e8855so501095966b.2;
        Mon, 22 May 2023 05:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757818; x=1687349818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPhQTZxBab4ufG3A5RcvU+2T8JQbUsDstYw6d3ZLLiw=;
        b=Vh2gMaMcDU8jGTAJ64+I6w7OsRyuFmSt4rWAK1dxNrOoY9tIiRuU75044JIdRePTtO
         NuRK1ZHTVhCCWtrymhT+r6VRukrylRNlGD+PQH/caFXbgixM+lB0fDK2DQ6EZiXRhHPb
         UzdUqwE+r5aTFsVajGP/AgxFxVZ9BWteFm9DrJo2B1465B8RZL71FjHyxbeQ292Eyhow
         JGJb6P/0XbaNmrQ+1mniEKkOxIxeAxZy82IpErLbGpDJRqEytQjhiXEL3T2+ECEeDx8x
         mLxzeIBcMuZn3CxBkCMXqt+emUL24ACR+Gzcv8yabzwR+2HXUwFweAVdFSwE8Mwzj8jm
         /02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757818; x=1687349818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oPhQTZxBab4ufG3A5RcvU+2T8JQbUsDstYw6d3ZLLiw=;
        b=My6AKMX6vqqbrGxXhoHQBMc/g9CvtQkyCr/SrmQ7s1WV3RaE65xBdCmgs6X43HEodJ
         tHy+xgRGVfqRAtXD8E1ecQonPnB2RlbDBaho/fUJNJVjK3woPM2IySVHU/YSul37ATSK
         qinrCkhI3wrKoLZKtmasgqQihVsJMNsCveUYCWbTWk9Z/LVC8t3lsjnKZDg6rNl6W8OE
         Gy55JAj/gD32r9ezhSNiuWNBUCCtSSkQC5Lkij1RDnun8EMnROnAk2Y3HM4yuO63cMPf
         dklnkUDXCeQUhMkNgHKkBURmp/+3AfVkWu9920CpqZEOVuf/+YyESqsQ2S05z2lnJ3XE
         j0vw==
X-Gm-Message-State: AC+VfDx3f4DZpDRgh2lizuY6Kg9iTK10ho/EbK/GAv1DydUo4jK7Yq6K
	XzbKwQl7JltYVTslDrn1f504PnJpTNNtkR56
X-Google-Smtp-Source: ACHHUZ61QvAvaJ6JXwAl5ZK+Z+iWCx3i0ErjlAje5iGoTtpti1TXdrNI1eenVMW0q+/1TTrQZTvoBQ==
X-Received: by 2002:a17:907:ea3:b0:96f:f451:187f with SMTP id ho35-20020a1709070ea300b0096ff451187fmr2155579ejc.7.1684757818084;
        Mon, 22 May 2023 05:16:58 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:16:57 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>
Cc: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com,
	mithat.guner@xeront.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 24/30] net: dsa: mt7530: rename MT7530_MFC to MT753X_MFC
Date: Mon, 22 May 2023 15:15:26 +0300
Message-Id: <20230522121532.86610-25-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230522121532.86610-1-arinc.unal@arinc9.com>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Arınç ÜNAL <arinc.unal@arinc9.com>

The MT7530_MFC register is on MT7530, MT7531, and the switch on the MT7988
SoC. Some bits are for MT7530 only. Call the shared ones MT753X, the
MT7530-specific ones MT7530.

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 30 +++++++++++++++------------
 drivers/net/dsa/mt7530.h | 44 ++++++++++++++++++++--------------------
 2 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9a4d4413287a..58d8738d94d3 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -955,12 +955,13 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 		     PORT_SPEC_TAG);
 
 	/* Enable flooding on the CPU port */
-	mt7530_set(priv, MT7530_MFC, BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) |
-		   UNU_FFP(BIT(port)));
+	mt7530_set(priv, MT753X_MFC, MT753X_BC_FFP(BIT(port)) |
+		   MT753X_UNM_FFP(BIT(port)) | MT753X_UNU_FFP(BIT(port)));
 
 	/* Set CPU port number */
 	if (priv->id == ID_MT7621)
-		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
+		mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_MASK, MT7530_CPU_EN |
+			   MT7530_CPU_PORT(port));
 
 	/* CPU port gets connected to all user ports of
 	 * the switch.
@@ -1120,16 +1121,19 @@ mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
 			   flags.val & BR_LEARNING ? 0 : SA_DIS);
 
 	if (flags.mask & BR_FLOOD)
-		mt7530_rmw(priv, MT7530_MFC, UNU_FFP(BIT(port)),
-			   flags.val & BR_FLOOD ? UNU_FFP(BIT(port)) : 0);
+		mt7530_rmw(priv, MT753X_MFC, MT753X_UNU_FFP(BIT(port)),
+			   flags.val & BR_FLOOD ?
+				MT753X_UNU_FFP(BIT(port)) : 0);
 
 	if (flags.mask & BR_MCAST_FLOOD)
-		mt7530_rmw(priv, MT7530_MFC, UNM_FFP(BIT(port)),
-			   flags.val & BR_MCAST_FLOOD ? UNM_FFP(BIT(port)) : 0);
+		mt7530_rmw(priv, MT753X_MFC, MT753X_UNM_FFP(BIT(port)),
+			   flags.val & BR_MCAST_FLOOD ?
+				MT753X_UNM_FFP(BIT(port)) : 0);
 
 	if (flags.mask & BR_BCAST_FLOOD)
-		mt7530_rmw(priv, MT7530_MFC, BC_FFP(BIT(port)),
-			   flags.val & BR_BCAST_FLOOD ? BC_FFP(BIT(port)) : 0);
+		mt7530_rmw(priv, MT753X_MFC, MT753X_BC_FFP(BIT(port)),
+			   flags.val & BR_BCAST_FLOOD ?
+				MT753X_BC_FFP(BIT(port)) : 0);
 
 	return 0;
 }
@@ -1667,13 +1671,13 @@ mt7530_port_vlan_del(struct dsa_switch *ds, int port,
 static int mt753x_mirror_port_get(unsigned int id, u32 val)
 {
 	return (id == ID_MT7531) ? MT7531_MIRROR_PORT_GET(val) :
-				   MIRROR_PORT(val);
+				   MT7530_MIRROR_PORT(val);
 }
 
 static int mt753x_mirror_port_set(unsigned int id, u32 val)
 {
 	return (id == ID_MT7531) ? MT7531_MIRROR_PORT_SET(val) :
-				   MIRROR_PORT(val);
+				   MT7530_MIRROR_PORT(val);
 }
 
 static int mt753x_port_mirror_add(struct dsa_switch *ds, int port,
@@ -2327,8 +2331,8 @@ mt7531_setup_common(struct dsa_switch *ds)
 	mt7530_mib_reset(ds);
 
 	/* Disable flooding on all ports */
-	mt7530_clear(priv, MT7530_MFC, BC_FFP_MASK | UNM_FFP_MASK |
-		     UNU_FFP_MASK);
+	mt7530_clear(priv, MT753X_MFC, MT753X_BC_FFP_MASK | MT753X_UNM_FFP_MASK
+		     | MT753X_UNU_FFP_MASK);
 
 	for (i = 0; i < MT7530_NUM_PORTS; i++) {
 		/* Disable forwarding by default on all ports */
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 216081fb1c12..5ebb942b07ef 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -32,35 +32,35 @@ enum mt753x_id {
 #define SYSC_REG_RSTCTRL		0x34
 #define  RESET_MCM			BIT(2)
 
-/* Registers to mac forward control for unknown frames */
-#define MT7530_MFC			0x10
-#define  BC_FFP(x)			(((x) & 0xff) << 24)
-#define  BC_FFP_MASK			BC_FFP(~0)
-#define  UNM_FFP(x)			(((x) & 0xff) << 16)
-#define  UNM_FFP_MASK			UNM_FFP(~0)
-#define  UNU_FFP(x)			(((x) & 0xff) << 8)
-#define  UNU_FFP_MASK			UNU_FFP(~0)
-#define  CPU_EN				BIT(7)
-#define  CPU_PORT(x)			((x) << 4)
-#define  CPU_MASK			(0xf << 4)
-#define  MIRROR_EN			BIT(3)
-#define  MIRROR_PORT(x)			((x) & 0x7)
-#define  MIRROR_MASK			0x7
-
-/* Registers for CPU forward control */
+/* Register for MAC forward control */
+#define MT753X_MFC			0x10
+#define  MT753X_BC_FFP(x)		(((x) & 0xff) << 24)
+#define  MT753X_BC_FFP_MASK		MT753X_BC_FFP(~0)
+#define  MT753X_UNM_FFP(x)		(((x) & 0xff) << 16)
+#define  MT753X_UNM_FFP_MASK		MT753X_UNM_FFP(~0)
+#define  MT753X_UNU_FFP(x)		(((x) & 0xff) << 8)
+#define  MT753X_UNU_FFP_MASK		MT753X_UNU_FFP(~0)
+#define  MT7530_CPU_EN			BIT(7)
+#define  MT7530_CPU_PORT(x)		((x) << 4)
+#define  MT7530_CPU_MASK		(0xf << 4)
+#define  MT7530_MIRROR_EN		BIT(3)
+#define  MT7530_MIRROR_PORT(x)		((x) & 0x7)
+#define  MT7530_MIRROR_MASK		0x7
+
+/* Register for CPU forward control */
 #define MT7531_CFC			0x4
 #define  MT7531_MIRROR_EN		BIT(19)
-#define  MT7531_MIRROR_MASK		(MIRROR_MASK << 16)
-#define  MT7531_MIRROR_PORT_GET(x)	(((x) >> 16) & MIRROR_MASK)
-#define  MT7531_MIRROR_PORT_SET(x)	(((x) & MIRROR_MASK) << 16)
+#define  MT7531_MIRROR_MASK		(0x7 << 16)
+#define  MT7531_MIRROR_PORT_GET(x)	(((x) >> 16) & 0x7)
+#define  MT7531_MIRROR_PORT_SET(x)	(((x) & 0x7) << 16)
 #define  MT7531_CPU_PMAP_MASK		GENMASK(7, 0)
 
 #define MT753X_MIRROR_REG(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
-					 MT7531_CFC : MT7530_MFC)
+					 MT7531_CFC : MT753X_MFC)
 #define MT753X_MIRROR_EN(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
-					 MT7531_MIRROR_EN : MIRROR_EN)
+					 MT7531_MIRROR_EN : MT7530_MIRROR_EN)
 #define MT753X_MIRROR_MASK(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
-					 MT7531_MIRROR_MASK : MIRROR_MASK)
+					 MT7531_MIRROR_MASK : MT7530_MIRROR_MASK)
 
 /* Registers for BPDU and PAE frame control*/
 #define MT753X_BPC			0x24
-- 
2.39.2


