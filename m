Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9BC17BCDA
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 13:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbgCFMfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 07:35:48 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34992 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbgCFMfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 07:35:48 -0500
Received: by mail-pj1-f66.google.com with SMTP id s8so1039736pjq.0
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 04:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vDi7kWShM1qR0MQriKkvolmESeDxzEsZg+w/X7RK+JQ=;
        b=ICLXexLaaOhLKCmqNJGiL5wmXDx9cFGIW1hrgKV1Hr6drBUA5UlIX1ZbSHfJAhQlD3
         HmVIyyEADVjv1R8vXOoPuliRiq32/e43iuqrLi3nXxrRufFBMb1Bm7g84FX6NgrNbEul
         hiICwmVAyrKMCe5kgWb1D/p83BOcFldIrSiGVC7OqSWVhAuE9SjIxR9zUDSpFJJoJPEL
         cS9ade/nuzzeetNSryQ11BywP62qcL4zWER52DroeOyl69oZGUs9s90Q0gkPFDUNCxFt
         DFCld9aETMp5IkouJZoZf+kWDqNWBanJHAU1OoONR/wr8j+YZViwUdDI2cZBYlxS1hDO
         GHzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vDi7kWShM1qR0MQriKkvolmESeDxzEsZg+w/X7RK+JQ=;
        b=GsXg1aWADJJgYpj11naPfaEYhUmn39vMvth/laL6iyXefTpp7mqXA3b0RoFj8Wp6Hh
         69d3X+6Ce2frYz0/+VGsfAqWve4yR2t8jaNa4qnqGb5zNEokrjUI2aRuqEvnYwCFASqr
         RT40dD2tI3Q1BZQTNPCTA4M4psYg2BsPfW+dhUqzYGln+581EXiRgd/aS+nvm3g8Eg57
         CUabRE+oyYJyDbCwmjpvGv/9WvVCbIU7LUBdWeGxGrjLAc1FGWXdxV+ld/XW+ZgYk1q7
         uCQrS7/SDHFv17gITbIAl8Q7ccrZyCs7RZeaXHBc1S4FXrHhxVi4YrgKXum9+zMFm298
         c6Ww==
X-Gm-Message-State: ANhLgQ3ps5ZChinUh6Lyenmnp9vqwbHgB78svHjd32JQHMHbmS5rFWJr
        gIPj2xzYqPNpsQVcSHcBeyvC7CNU+2o=
X-Google-Smtp-Source: ADFU+vsLmXZjrz4QTceQofT6k89yw6HwBUIel4Ogm67SyWCY40MgzM9evlSpWkH91pnIfP9TMq298A==
X-Received: by 2002:a17:90a:2230:: with SMTP id c45mr3466360pje.190.1583498145390;
        Fri, 06 Mar 2020 04:35:45 -0800 (PST)
Received: from P65xSA.lan ([128.199.164.101])
        by smtp.gmail.com with ESMTPSA id x18sm24364294pfo.148.2020.03.06.04.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 04:35:44 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org
Cc:     opensource@vdorst.com, davem@davemloft.net,
        linux-mediatek@lists.infradead.org, frank-w@public-files.de
Subject: [PATCH] net: dsa: mt7530: add support for port mirroring
Date:   Fri,  6 Mar 2020 20:35:35 +0800
Message-Id: <20200306123535.7540-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring port mirroring through the cls_matchall
classifier. We do a full ingress and/or egress capture towards a
capture port.
MT7530 supports one monitor port and multiple mirrored ports.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 60 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/dsa/mt7530.h |  7 +++++
 2 files changed, 67 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 022466c..0778585 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1222,6 +1222,64 @@ mt7530_port_vlan_del(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int mt7530_port_mirror_add(struct dsa_switch *ds, int port,
+				  struct dsa_mall_mirror_tc_entry *mirror,
+				  bool ingress)
+{
+	struct mt7530_priv *priv = ds->priv;
+	u32 val;
+
+	/* Check for existent entry */
+	if ((ingress ? priv->mirror_rx : priv->mirror_tx) & BIT(port))
+		return -EEXIST;
+
+	val = mt7530_read(priv, MT7530_MFC);
+
+	/* MT7530 only supports one monitor port */
+	if (val & MIRROR_EN && MIRROR_PORT(val) != mirror->to_local_port)
+		return -EEXIST;
+
+	val |= MIRROR_EN;
+	val &= ~MIRROR_MASK;
+	val |= mirror->to_local_port;
+	mt7530_write(priv, MT7530_MFC, val);
+
+	val = mt7530_read(priv, MT7530_PCR_P(port));
+	if (ingress) {
+		val |= PORT_RX_MIR;
+		priv->mirror_rx |= BIT(port);
+	} else {
+		val |= PORT_TX_MIR;
+		priv->mirror_tx |= BIT(port);
+	}
+	mt7530_write(priv, MT7530_PCR_P(port), val);
+
+	return 0;
+}
+
+static void mt7530_port_mirror_del(struct dsa_switch *ds, int port,
+				   struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct mt7530_priv *priv = ds->priv;
+	u32 val;
+
+	val = mt7530_read(priv, MT7530_PCR_P(port));
+	if (mirror->ingress) {
+		val &= ~PORT_RX_MIR;
+		priv->mirror_rx &= ~BIT(port);
+	} else {
+		val &= ~PORT_TX_MIR;
+		priv->mirror_tx &= ~BIT(port);
+	}
+	mt7530_write(priv, MT7530_PCR_P(port), val);
+
+	if (!priv->mirror_rx && !priv->mirror_tx) {
+		val = mt7530_read(priv, MT7530_MFC);
+		val &= ~MIRROR_EN;
+		mt7530_write(priv, MT7530_MFC, val);
+	}
+}
+
 static enum dsa_tag_protocol
 mtk_get_tag_protocol(struct dsa_switch *ds, int port,
 		     enum dsa_tag_protocol mp)
@@ -1611,6 +1669,8 @@ static const struct dsa_switch_ops mt7530_switch_ops = {
 	.port_vlan_prepare	= mt7530_port_vlan_prepare,
 	.port_vlan_add		= mt7530_port_vlan_add,
 	.port_vlan_del		= mt7530_port_vlan_del,
+	.port_mirror_add	= mt7530_port_mirror_add,
+	.port_mirror_del	= mt7530_port_mirror_del,
 	.phylink_validate	= mt7530_phylink_validate,
 	.phylink_mac_link_state = mt7530_phylink_mac_link_state,
 	.phylink_mac_config	= mt7530_phylink_mac_config,
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ccb9da8..5e6c778 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -36,6 +36,9 @@ enum {
 #define  CPU_EN				BIT(7)
 #define  CPU_PORT(x)			((x) << 4)
 #define  CPU_MASK			(0xf << 4)
+#define  MIRROR_EN			BIT(3)
+#define  MIRROR_PORT(x)			((x & 0x7))
+#define  MIRROR_MASK			0x7
 
 /* Registers for address table access */
 #define MT7530_ATA1			0x74
@@ -141,6 +144,8 @@ enum mt7530_stp_state {
 
 /* Register for port control */
 #define MT7530_PCR_P(x)			(0x2004 + ((x) * 0x100))
+#define  PORT_TX_MIR			BIT(9)
+#define  PORT_RX_MIR			BIT(8)
 #define  PORT_VLAN(x)			((x) & 0x3)
 
 enum mt7530_port_mode {
@@ -460,6 +465,8 @@ struct mt7530_priv {
 	phy_interface_t		p6_interface;
 	phy_interface_t		p5_interface;
 	unsigned int		p5_intf_sel;
+	u8			mirror_rx;
+	u8			mirror_tx;
 
 	struct mt7530_port	ports[MT7530_NUM_PORTS];
 	/* protect among processes for registers access*/
-- 
2.25.1

