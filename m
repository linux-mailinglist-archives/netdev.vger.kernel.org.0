Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6FA3D94A1
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 19:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhG1Rx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 13:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhG1Rxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 13:53:54 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2671C061757;
        Wed, 28 Jul 2021 10:53:52 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ca5so6291174pjb.5;
        Wed, 28 Jul 2021 10:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4PfC04M9Z5wtL0vKbvHcVlWUtOEqkXBLD/NMtF2oJRM=;
        b=c5eq1xqa8KnEO2pxegnJGOLCeTNjWXinbE5neY3Fr3kWRfW+iSt2lcTN/R7oxw5QGS
         mKjl/CsBjoRTiSnbNVMllxNwR8rfnJ7TEvjHUBPzuKtucXv37rg72Or5S8Q6gieKlzv6
         oX2++teMVgUNos3Jv78iBHtPQjL5u1Rv2M1LVGMA2pD43ATrPVrw8D8AfVOI3LQl9hLa
         iDGFam7TSbRfaVhdyZ3CypbTNK/jqj1NPzqYZZFbweEoutZeVY05tUqE7+08+F5wm1c3
         OxpCH8SV2P1moq7zbKbQg1EjZLG9Pldb3cN34uS2yCwE9sk+FR55h96VzV/BaHGpdeZs
         3MwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4PfC04M9Z5wtL0vKbvHcVlWUtOEqkXBLD/NMtF2oJRM=;
        b=A0GXYLf2XMeeS9CqKIRniIFDVsP1q3nWZ3SfHDiZeNprytXbUlS/QFMrzApi+kliER
         ewFVIWy1F+p1Ae+gaJgCAimt0eEV8dl2JHLSX/vEe3QY16uczU6BPCYmEVfhft95VKPo
         dBckHMUH075yBHBI1UvUpfPzwtNUW9bOu/1RMA8IUvUzDx09RA79rZnPzhI/TQT9yG0T
         63vm+i0snVMV8cOkpvPHL3ifV6PFSSRX36ZUNLI0LJV4Yzs2YPTRIup0Bm5xn1Tsrhg4
         OhxIPp/IlR/9+vU/31blmMtwlNk28x5yb2yjxZKlsK7R50+Ok3608ISByBiEwmuXUig2
         v6/w==
X-Gm-Message-State: AOAM533MhnUkG2Duu5fjW5k6VAX6yJ1/e1LaMNYVykFlrQCBfbEyRCxl
        sVWN82F1cxg/rvk4gu1+kMo=
X-Google-Smtp-Source: ABdhPJxHHHJbldPuFoH4WOkqBVFeq5AAussEvUokUpyiJIbADOk0gjMcm9uJqFX5l4l/g5/1hXSC6Q==
X-Received: by 2002:a17:90b:2246:: with SMTP id hk6mr898497pjb.112.1627494832396;
        Wed, 28 Jul 2021 10:53:52 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id m19sm647113pfa.135.2021.07.28.10.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 10:53:51 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC net-next 2/2] net: dsa: mt7530: trap packets from standalone ports to the CPU
Date:   Thu, 29 Jul 2021 01:53:26 +0800
Message-Id: <20210728175327.1150120-3-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210728175327.1150120-1-dqfext@gmail.com>
References: <20210728175327.1150120-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consider the following bridge configuration, where bond0 is not
offloaded:

         +-- br0 --+
        / /   |     \
       / /    |      \
      /  |    |     bond0
     /   |    |     /   \
   swp0 swp1 swp2 swp3 swp4
     .        .       .
     .        .       .
     A        B       C

Ideally, when the switch receives a packet from swp3 or swp4, it should
forward the packet to the CPU, according to the port matrix and unknown
unicast flood settings.

But packet loss will happen if the destination address is at one of the
offloaded ports (swp0~2). For example, when client C sends a packet to
A, the FDB lookup will indicate that it should be forwarded to swp0, but
the port matrix of swp3 and swp4 is configured to only allow the CPU to
be its destination, so it is dropped.

MT7530's FDB has 8 filter IDs, but they are only available for shared
VLAN learning, and all VLAN-unaware ports use 0 as the default filter
ID.

Fortunately, MT7530 supports ACL, and the ACL action happens before the
FDB lookup. So we install an ACL rule which traps all packets to the
CPU, and enable it for standalone ports. This way, the packet loss can
be avoided.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 28 ++++++++++++++++++++
 drivers/net/dsa/mt7530.h | 56 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 69f21b71614c..6b5c85446e6f 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1228,6 +1228,8 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
 		mt7530_rmw(priv, MT7530_PCR_P(port),
 			   PCR_MATRIX_MASK, PCR_MATRIX(port_bitmap));
 	priv->ports[port].pm |= PCR_MATRIX(port_bitmap);
+	/* Don't trap frames to the CPU port */
+	mt7530_clear(priv, MT7530_PCR_P(port), PORT_ACL_EN);
 
 	mutex_unlock(&priv->reg_mutex);
 
@@ -1328,6 +1330,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 		mt7530_rmw(priv, MT7530_PCR_P(port), PCR_MATRIX_MASK,
 			   PCR_MATRIX(BIT(MT7530_CPU_PORT)));
 	priv->ports[port].pm = PCR_MATRIX(BIT(MT7530_CPU_PORT));
+	/* Trap all frames to the CPU port */
+	mt7530_set(priv, MT7530_PCR_P(port), PORT_ACL_EN);
 
 	mutex_unlock(&priv->reg_mutex);
 }
@@ -2037,6 +2041,24 @@ mt7530_setup_mdio(struct mt7530_priv *priv)
 	return ret;
 }
 
+static void
+mt7530_setup_acl(struct mt7530_priv *priv)
+{
+	u32 action;
+
+	/* Set ACL pattern mask to 0 to match unconditionally */
+	mt7530_write(priv, MT7530_VAWD1, 0);
+	mt7530_write(priv, MT7530_VAWD2, 0);
+	mt7530_vlan_cmd(priv, MT7530_VTCR_WR_ACL_MASK, 0);
+
+	/* Set ACL action to forward frames to the CPU port */
+	action = ACL_PORT_EN | ACL_PORT(BIT(MT7530_CPU_PORT)) |
+		 ACL_EG_TAG(MT7530_VLAN_EG_CONSISTENT);
+	mt7530_write(priv, MT7530_VAWD1, action);
+	mt7530_write(priv, MT7530_VAWD2, 0);
+	mt7530_vlan_cmd(priv, MT7530_VTCR_WR_ACL_ACTION, 0);
+}
+
 static int
 mt7530_setup(struct dsa_switch *ds)
 {
@@ -2133,6 +2155,8 @@ mt7530_setup(struct dsa_switch *ds)
 
 			/* Disable learning by default on all user ports */
 			mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
+			/* Trap all frames to the CPU port */
+			mt7530_set(priv, MT7530_PCR_P(i), PORT_ACL_EN);
 		}
 		/* Enable consistent egress tag */
 		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
@@ -2300,6 +2324,8 @@ mt7531_setup(struct dsa_switch *ds)
 
 			/* Disable learning by default on all user ports */
 			mt7530_set(priv, MT7530_PSC_P(i), SA_DIS);
+			/* Trap all frames to the CPU port */
+			mt7530_set(priv, MT7530_PCR_P(i), PORT_ACL_EN);
 		}
 
 		/* Enable consistent egress tag */
@@ -3005,6 +3031,8 @@ mt753x_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	mt7530_setup_acl(priv);
+
 	ret = mt7530_setup_irq(priv);
 	if (ret)
 		return ret;
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index b19b389ff10a..10cb278d7c36 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -137,6 +137,15 @@ enum mt7530_vlan_cmd {
 	 */
 	MT7530_VTCR_RD_VID = 0,
 	MT7530_VTCR_WR_VID = 1,
+	/* Read/Write the specified ACL rule pattern */
+	MT7530_VTCR_RD_ACL_PATTERN = 4,
+	MT7530_VTCR_WR_ACL_PATTERN = 5,
+	/* Read/Write the specified ACL rule mask */
+	MT7530_VTCR_RD_ACL_MASK = 8,
+	MT7530_VTCR_WR_ACL_MASK = 9,
+	/* Read/Write the specified ACL rule action */
+	MT7530_VTCR_RD_ACL_ACTION = 10,
+	MT7530_VTCR_WR_ACL_ACTION = 11,
 };
 
 /* Register for setup vlan and acl write data */
@@ -153,6 +162,35 @@ enum mt7530_vlan_cmd {
 #define  PORT_MEM_SHFT			16
 #define  PORT_MEM_MASK			0xff
 
+/* ACL rule pattern */
+#define  BIT_CMP(x)			(((x) & 0xffff) << 16)
+#define  CMP_PAT(x)			((x) & 0xffff)
+
+/* ACL rule action */
+#define  ACL_MANG			BIT(29)
+#define  ACL_INT_EN			BIT(28)
+#define  ACL_CNT_EN			BIT(27)
+#define  ACL_CNT_IDX(x)			(((x) & 0x7) << 24)
+#define  VLAN_PORT_EN			BIT(23)
+#define  DA_SWAP			BIT(22)
+#define  SA_SWAP			BIT(21)
+#define  PPP_RM				BIT(20)
+#define  LKY_VLAN			BIT(19)
+#define  ACL_EG_TAG(x)			(((x) & 0x7) << 16)
+#define  ACL_PORT(x)			(((x) & 0xff) << 8)
+#define  ACL_PORT_EN			BIT(7)
+#define  PRI_USER(x)			(((x) & 0x7) << 4)
+#define  ACL_MIR_EN			BIT(3)
+#define  ACL_PORT_FW(x)			((x) & 0x7)
+
+enum mt7530_to_cpu_port_fw {
+	PORT_FW_DEFAULT,
+	PORT_FW_EXCLUDE_CPU = 4,
+	PORT_FW_INCLUDE_CPU,
+	PORT_FW_CPU_ONLY,
+	PORT_FW_DROP,
+};
+
 #define MT7530_VAWD2			0x98
 /* Egress Tag Control */
 #define  ETAG_CTRL_P(p, x)		(((x) & 0x3) << ((p) << 1))
@@ -164,6 +202,23 @@ enum mt7530_vlan_egress_attr {
 	MT7530_VLAN_EGRESS_STACK = 3,
 };
 
+/* ACL rule pattern */
+#define  ACL_TABLE_EN			BIT(19)
+#define  OFST_TP(x)			(((x) & 0x7) << 16)
+#define  ACL_SP(x)			(((x) & 0xff) << 8)
+#define  WORD_OFST(x)			(((x) & 0x7f) << 1)
+#define  CMP_SEL			BIT(0)
+
+enum mt7530_acl_offset_type {
+	MT7530_ACL_MAC_HEADER,
+	MT7530_ACL_L2_PAYLOAD,
+	MT7530_ACL_IP_HEADER,
+	MT7530_ACL_IP_DATAGRAM,
+	MT7530_ACL_TCP_UDP_HEADER,
+	MT7530_ACL_TCP_UDP_DATAGRAM,
+	MT7530_ACL_IPV6_HEADER,
+};
+
 /* Register for address age control */
 #define MT7530_AAC			0xa0
 /* Disable ageing */
@@ -192,6 +247,7 @@ enum mt7530_stp_state {
 
 /* Register for port control */
 #define MT7530_PCR_P(x)			(0x2004 + ((x) * 0x100))
+#define  PORT_ACL_EN			BIT(10)
 #define  PORT_TX_MIR			BIT(9)
 #define  PORT_RX_MIR			BIT(8)
 #define  PORT_VLAN(x)			((x) & 0x3)
-- 
2.25.1

