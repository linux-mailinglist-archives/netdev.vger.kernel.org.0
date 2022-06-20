Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B375526FD
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 00:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237431AbiFTWdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 18:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238210AbiFTWdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 18:33:02 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF211054A
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 15:33:01 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d13so10898019plh.13
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 15:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=superbaloo.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HBt51kyMpIjC4M3F3ivYqQDQ/GB/fjPiJlkO5Sd3V5s=;
        b=ARjA7VOIGldIFqeNYlx+2tR+WRWCzDXEEfcKbUb/IChFgJkzUMGOx3hE3L4MjyyKgy
         8CFjudUFXQK/UcwZ1IrIa8+UozEzpo5eS2Ox3Uad6ELWpR6WRTLp9JiP92wVTPz7iJAU
         lay0TNI6w/Tv1NjeuhcurW1DQX/EJF4s7Ql9dTO7oZzAxFMWBt3JTftcswvLOQfBbRuQ
         OZVp00yLUNesuPR6F3IIahBw+WRsFITCdpmDzTEledQSZQ1EEadiEe2lCG3mQAu+bxvQ
         x14QTaQeWcYgVGFQCJd4Q9EX9VdWwwpusmZSy0jYjexi3y5kWmaWsKNLvPIx7+pTyrmU
         6mxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HBt51kyMpIjC4M3F3ivYqQDQ/GB/fjPiJlkO5Sd3V5s=;
        b=1kpYR3Y9n+6/+xsEk1nexS6O2+TdkKOsMH2Se0Eqxu+lMCFWmrXDWYDLRtpasw+HS+
         kCzI94tT1YRErkn+hMdZIXgGSv50zuyGZxZNiGIt505LQU/UEv8d76e79JnIfi1C5St+
         SOE3KDVxbFj1lwJDxwLMA4H0Nzydreu4fVPwVF0BqocpW8Nv0mRctVTV52xcbLdNiXzt
         MdUBjBxl5yg7fvUKkJLi3OnaBP2f0FYAWx1skq1QHgvS5IElqQys9gXn83hN8hfLUYwo
         mNyJIMjrewtY2ipT2lnz+2H5guccmbqEQ2x/iNoNVnc1HZZsh61bUpwQ/64gxBKKmcTe
         bBOg==
X-Gm-Message-State: AJIora8NxuzQ9IIiWQOPEWOjYeVW16j+tAHNkK1hTiagID8gJ2rLdh+1
        mtuffS8Go/vxhyyGs7SuTAMJbQIVYBmgRA==
X-Google-Smtp-Source: AGRyM1sF7Lg/02fMXk0W3YjMcikM4u4BOZP6mebxXi5ZH1yfZM0fZ1YFI9qKvVESJXHFv0sQbZV5Xg==
X-Received: by 2002:a17:90b:4d11:b0:1e8:436b:a9cc with SMTP id mw17-20020a17090b4d1100b001e8436ba9ccmr40448785pjb.40.1655764381094;
        Mon, 20 Jun 2022 15:33:01 -0700 (PDT)
Received: from localhost.localdomain ([2607:f598:ba6a:691:9c8b:96fb:387a:11b8])
        by smtp.gmail.com with ESMTPSA id ds12-20020a17090b08cc00b001e0c1044ceasm8657061pjb.43.2022.06.20.15.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 15:33:00 -0700 (PDT)
From:   Arthur Gautier <baloo@superbaloo.net>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     Arthur Gautier <baloo@superbaloo.net>, netdev@vger.kernel.org
Subject: [PATCH] cxgb4: DOM support when using a QSFP to SFP adaptor
Date:   Mon, 20 Jun 2022 22:32:34 +0000
Message-Id: <20220620223234.2443179-1-baloo@superbaloo.net>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a QSFP to SFP adaptor is used, the DOM eeprom is then presented
with the SFF-8472 layout and not translated to SFF-8636 format.

When parsing the eeprom, we can't just read the type of port but we
need to identify the type of transceiver instead.

Signed-off-by: Arthur Gautier <baloo@superbaloo.net>
Cc: Raju Rangoju <rajur@chelsio.com>
Cc: netdev@vger.kernel.org
---
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 69 ++++++++++++++-----
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.h    |  3 +
 2 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 6c790af92170..ff769216dbec 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -2002,11 +2002,43 @@ static bool cxgb4_fw_mod_type_info_available(unsigned int fw_mod_type)
 		fw_mod_type != FW_PORT_MOD_TYPE_ERROR);
 }
 
+static int cxgb4_read_eeprom_sfp(struct adapter *adapter,
+				 struct port_info *pi,
+				 struct ethtool_modinfo *modinfo)
+{
+	u8 sff8472_comp, sff_diag_type;
+	int ret;
+
+	ret = t4_i2c_rd(adapter, adapter->mbox, pi->tx_chan,
+			I2C_DEV_ADDR_A0, SFF_8472_COMP_ADDR,
+			SFF_8472_COMP_LEN, &sff8472_comp);
+	if (ret)
+		return ret;
+	ret = t4_i2c_rd(adapter, adapter->mbox, pi->tx_chan,
+			I2C_DEV_ADDR_A0, SFP_DIAG_TYPE_ADDR,
+			SFP_DIAG_TYPE_LEN, &sff_diag_type);
+	if (ret)
+		return ret;
+
+	if (!sff8472_comp || (sff_diag_type & SFP_DIAG_ADDRMODE)) {
+		modinfo->type = ETH_MODULE_SFF_8079;
+		modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
+	} else {
+		modinfo->type = ETH_MODULE_SFF_8472;
+		if (sff_diag_type & SFP_DIAG_IMPLEMENTED)
+			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
+		else
+			modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN / 2;
+	}
+
+	return 0;
+}
+
 static int cxgb4_get_module_info(struct net_device *dev,
 				 struct ethtool_modinfo *modinfo)
 {
 	struct port_info *pi = netdev_priv(dev);
-	u8 sff8472_comp, sff_diag_type, sff_rev;
+	u8 sff_rev, module_type;
 	struct adapter *adapter = pi->adapter;
 	int ret;
 
@@ -2017,27 +2049,10 @@ static int cxgb4_get_module_info(struct net_device *dev,
 	case FW_PORT_TYPE_SFP:
 	case FW_PORT_TYPE_QSA:
 	case FW_PORT_TYPE_SFP28:
-		ret = t4_i2c_rd(adapter, adapter->mbox, pi->tx_chan,
-				I2C_DEV_ADDR_A0, SFF_8472_COMP_ADDR,
-				SFF_8472_COMP_LEN, &sff8472_comp);
-		if (ret)
-			return ret;
-		ret = t4_i2c_rd(adapter, adapter->mbox, pi->tx_chan,
-				I2C_DEV_ADDR_A0, SFP_DIAG_TYPE_ADDR,
-				SFP_DIAG_TYPE_LEN, &sff_diag_type);
+		ret = cxgb4_read_eeprom_sfp(adapter, pi, modinfo);
 		if (ret)
 			return ret;
 
-		if (!sff8472_comp || (sff_diag_type & SFP_DIAG_ADDRMODE)) {
-			modinfo->type = ETH_MODULE_SFF_8079;
-			modinfo->eeprom_len = ETH_MODULE_SFF_8079_LEN;
-		} else {
-			modinfo->type = ETH_MODULE_SFF_8472;
-			if (sff_diag_type & SFP_DIAG_IMPLEMENTED)
-				modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN;
-			else
-				modinfo->eeprom_len = ETH_MODULE_SFF_8472_LEN / 2;
-		}
 		break;
 
 	case FW_PORT_TYPE_QSFP:
@@ -2045,6 +2060,22 @@ static int cxgb4_get_module_info(struct net_device *dev,
 	case FW_PORT_TYPE_CR_QSFP:
 	case FW_PORT_TYPE_CR2_QSFP:
 	case FW_PORT_TYPE_CR4_QSFP:
+		// lookup the transceiver type, we could be using a SFP
+		// plugged into a QSFP to SFP adapter
+		ret = t4_i2c_rd(adapter, adapter->mbox, pi->tx_chan,
+				I2C_DEV_ADDR_A0, SFF_8636_ID,
+				SFF_8636_ID_LEN, &module_type);
+		if (ret)
+			return ret;
+
+		if (module_type == SFF_8024_ID_SFP) {
+			ret = cxgb4_read_eeprom_sfp(adapter, pi, modinfo);
+			if (ret)
+				return ret;
+
+			break;
+		}
+
 		ret = t4_i2c_rd(adapter, adapter->mbox, pi->tx_chan,
 				I2C_DEV_ADDR_A0, SFF_REV_ADDR,
 				SFF_REV_LEN, &sff_rev);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.h b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.h
index 63bc956d2037..a27e20dc1268 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.h
@@ -297,6 +297,9 @@ enum {
 #define SFP_DIAG_IMPLEMENTED	BIT(6)
 #define SFF_8472_COMP_ADDR	0x5e
 #define SFF_8472_COMP_LEN	0x1
+#define SFF_8636_ID		0x0
+#define SFF_8636_ID_LEN	0x1
+#define SFF_8024_ID_SFP	0x3
 #define SFF_REV_ADDR		0x1
 #define SFF_REV_LEN		0x1
 
-- 
2.33.1

