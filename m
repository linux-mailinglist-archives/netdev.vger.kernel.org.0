Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C70E4FFAB7
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 17:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfKQQPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 11:15:45 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40675 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfKQQPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 11:15:45 -0500
Received: by mail-pl1-f194.google.com with SMTP id e3so8231494plt.7
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 08:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2kOv4TxUNMbh2ZeuuUuuePD4oFRHgyZTJJwf0lipCO4=;
        b=hyphbqExmJxEeYOAhfwl3Dwa5hqm9un6MBBwXRDQkWEYOtdcihxtcVwrZQZkAeoGqQ
         +iJdZvQKv199vZSSBZYAM5ZmCJXBwzLdUw6w9vTBMCydYnppj7Vb7/abZLEkYRUqLXoA
         AvOK/sQ6qnaL95WQaOUhGPHCq8Q4tulcESQgxoXHXtcLVFpZ9tc3yfd/Todpj4WkMF8h
         SScnSOFQStoz+Q73dhGFWNV7dxNT2/tg2B9FWpuM6PiPWTvVCKdWFG3X07W7W0CbUz5+
         84hZ9t4oYZNGvbSXNCW58t+QeVASdQkki0EiuXR6iScgk/M6W1DZnOYXL9femPuo8d1F
         RxrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2kOv4TxUNMbh2ZeuuUuuePD4oFRHgyZTJJwf0lipCO4=;
        b=GCKJkqtsEY/GXRj/jHFapkExQ8h+UfBSJofJYkGAGf90BJTGjl8Lb+9Mxx2hsyyg9O
         /8uIqhdzYJJABqBDDbGJetS25amuTXk+qqfdzah4qfckMYuwyiYKEAL0YlFhJrf9Phug
         gVsrLlR7uTGNJ6+yY+7bqGWzHcUcWIrGkZuyPQg4R5OxE9c4RlvvB6RvZkSRnmwBXSH7
         nJ0WVt3Z2mL3NcemCNOmPALSnMo3TV8QYWcsAra9pcxMROoI1LxRUetPkXonqHw4sZPA
         voPRFRpMw8G9EzGhWYQlrSCu9S9cd9C6kuru3TDfBQYWyaiSmvmcGh0Ig0nyqXLDZYjV
         hgPw==
X-Gm-Message-State: APjAAAVEX40GsHzU06HVo78BxDQ74NW+LoHma2vS/sLN4NS6e+dBVJWf
        yVseASvWAV+l9AzKqkIWlf0EF0MWptA=
X-Google-Smtp-Source: APXvYqydkS4nXky7U0m+QfqdonuQ4cu04UzH+PbiVMbgvV+NoAhVZZa5xNB4KvGtyc+NKtp1cPm9sA==
X-Received: by 2002:a17:902:7c8f:: with SMTP id y15mr18590845pll.341.1574007343599;
        Sun, 17 Nov 2019 08:15:43 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v2sm2675231pgi.79.2019.11.17.08.15.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 17 Nov 2019 08:15:42 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Christina Jacob <cjacob@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 15/15] octeontx2-af: Support to get CGX link info like current speed, fec etc
Date:   Sun, 17 Nov 2019 21:44:26 +0530
Message-Id: <1574007266-17123-16-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christina Jacob <cjacob@marvell.com>

- Implements CGX_FW_DATA_GET command to get the cgx link info shared
  from atf.
- Implement CGX_FEC_SET mailbox message to set current FEC value.
- Update the link status structre in cgx with additional information
  such as the port type, current fec etc.
- Upon request, fetch FEC corrected and uncorrected block counters
  for the mapped CGX LMAC.
- If present get phy's EEPROM data as response to ethtool command.

Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Linu Cherian <lcherian@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 310 +++++++++++++++++++--
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  11 +-
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |  72 ++++-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  76 +++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  99 ++++++-
 6 files changed, 542 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index af30dad..5f3a9bf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -14,12 +14,14 @@
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/ethtool.h>
 #include <linux/phy.h>
 #include <linux/of.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 
 #include "cgx.h"
+#include "rvu.h"
 
 #define DRV_NAME	"octeontx2-cgx"
 #define DRV_STRING      "Marvell OcteonTX2 CGX/MAC Driver"
@@ -326,6 +328,11 @@ int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat)
 
 	if (!cgx || lmac_id >= cgx->lmac_count)
 		return -ENODEV;
+#define CGX_RX_STAT_GLOBAL_INDEX	9
+	/* pass lmac as 0 for CGX_CMR_RX_STAT9-12 */
+	if (idx >= CGX_RX_STAT_GLOBAL_INDEX)
+		lmac_id = 0;
+
 	*rx_stat =  cgx_read(cgx, lmac_id, CGXX_CMRX_RX_STAT0 + (idx * 8));
 	return 0;
 }
@@ -342,6 +349,58 @@ int cgx_get_tx_stats(void *cgxd, int lmac_id, int idx, u64 *tx_stat)
 }
 EXPORT_SYMBOL(cgx_get_tx_stats);
 
+static int cgx_set_fec_stats_count(struct cgx_link_user_info *linfo)
+{
+	if (linfo->fec) {
+		switch (linfo->lmac_type_id) {
+		case LMAC_MODE_SGMII:
+		case LMAC_MODE_XAUI:
+		case LMAC_MODE_RXAUI:
+		case LMAC_MODE_QSGMII:
+			return 0;
+		case LMAC_MODE_10G_R:
+		case LMAC_MODE_25G_R:
+		case LMAC_MODE_100G_R:
+		case LMAC_MODE_USXGMII:
+			return 1;
+		case LMAC_MODE_40G_R:
+			return 4;
+		case LMAC_MODE_50G_R:
+			if (linfo->fec == OTX2_FEC_BASER)
+				return 2;
+			else
+				return 1;
+		}
+	}
+	return 0;
+}
+
+int cgx_get_fec_stats(void *cgxd, int lmac_id, struct cgx_fec_stats_rsp *rsp)
+{
+	int stats, fec_stats_count = 0;
+	int corr_reg, uncorr_reg;
+	struct cgx *cgx = cgxd;
+
+	if (!cgx || lmac_id >= cgx->lmac_count)
+		return -ENODEV;
+	fec_stats_count =
+		cgx_set_fec_stats_count(&cgx->lmac_idmap[lmac_id]->link_info);
+	if (cgx->lmac_idmap[lmac_id]->link_info.fec == OTX2_FEC_BASER) {
+		corr_reg = CGXX_SPUX_LNX_FEC_CORR_BLOCKS;
+		uncorr_reg = CGXX_SPUX_LNX_FEC_UNCORR_BLOCKS;
+	} else {
+		corr_reg = CGXX_SPUX_RSFEC_CORR;
+		uncorr_reg = CGXX_SPUX_RSFEC_UNCORR;
+	}
+	for (stats = 0; stats < fec_stats_count; stats++) {
+		rsp->fec_corr_blks +=
+			cgx_read(cgx, lmac_id, corr_reg + (stats * 8));
+		rsp->fec_uncorr_blks +=
+			cgx_read(cgx, lmac_id, uncorr_reg + (stats * 8));
+	}
+	return 0;
+}
+
 int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable)
 {
 	struct cgx *cgx = cgxd;
@@ -352,9 +411,9 @@ int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable)
 
 	cfg = cgx_read(cgx, lmac_id, CGXX_CMRX_CFG);
 	if (enable)
-		cfg |= CMR_EN | DATA_PKT_RX_EN | DATA_PKT_TX_EN;
+		cfg |= DATA_PKT_RX_EN | DATA_PKT_TX_EN;
 	else
-		cfg &= ~(CMR_EN | DATA_PKT_RX_EN | DATA_PKT_TX_EN);
+		cfg &= ~(DATA_PKT_RX_EN | DATA_PKT_TX_EN);
 	cgx_write(cgx, lmac_id, CGXX_CMRX_CFG, cfg);
 	return 0;
 }
@@ -534,8 +593,8 @@ static int cgx_fwi_cmd_send(u64 req, u64 *resp, struct lmac *lmac)
 	return err;
 }
 
-static inline int cgx_fwi_cmd_generic(u64 req, u64 *resp,
-				      struct cgx *cgx, int lmac_id)
+static int cgx_fwi_cmd_generic(u64 req, u64 *resp,
+			       struct cgx *cgx, int lmac_id)
 {
 	struct lmac *lmac;
 	int err;
@@ -557,7 +616,7 @@ static inline int cgx_fwi_cmd_generic(u64 req, u64 *resp,
 	return err;
 }
 
-static inline void cgx_link_usertable_init(void)
+static void cgx_link_usertable_init(void)
 {
 	cgx_speed_mbps[CGX_LINK_NONE] = 0;
 	cgx_speed_mbps[CGX_LINK_10M] = 10;
@@ -570,6 +629,7 @@ static inline void cgx_link_usertable_init(void)
 	cgx_speed_mbps[CGX_LINK_25G] = 25000;
 	cgx_speed_mbps[CGX_LINK_40G] = 40000;
 	cgx_speed_mbps[CGX_LINK_50G] = 50000;
+	cgx_speed_mbps[CGX_LINK_80G] = 80000;
 	cgx_speed_mbps[CGX_LINK_100G] = 100000;
 
 	cgx_lmactype_string[LMAC_MODE_SGMII] = "SGMII";
@@ -584,23 +644,175 @@ static inline void cgx_link_usertable_init(void)
 	cgx_lmactype_string[LMAC_MODE_USXGMII] = "USXGMII";
 }
 
-static inline void link_status_user_format(u64 lstat,
-					   struct cgx_link_user_info *linfo,
-					   struct cgx *cgx, u8 lmac_id)
+static int cgx_link_usertable_index_map(int speed)
+{
+	switch (speed) {
+	case SPEED_10:
+		return CGX_LINK_10M;
+	case SPEED_100:
+		return CGX_LINK_100M;
+	case SPEED_1000:
+		return CGX_LINK_1G;
+	case SPEED_2500:
+		return CGX_LINK_2HG;
+	case SPEED_5000:
+		return CGX_LINK_5G;
+	case SPEED_10000:
+		return CGX_LINK_10G;
+	case SPEED_20000:
+		return CGX_LINK_20G;
+	case SPEED_25000:
+		return CGX_LINK_25G;
+	case SPEED_40000:
+		return CGX_LINK_40G;
+	case SPEED_50000:
+		return CGX_LINK_50G;
+	case 80000:
+		return CGX_LINK_80G;
+	case SPEED_100000:
+		return CGX_LINK_100G;
+	case SPEED_UNKNOWN:
+		return CGX_LINK_NONE;
+	}
+	return CGX_LINK_NONE;
+}
+
+static void set_mod_args(struct cgx_set_link_mode_args *args,
+			 u32 speed, u8 duplex, u8 autoneg, u64 mode)
+{
+	/* firmware requires this value in the reverse format */
+	args->duplex = duplex;
+	args->speed = speed;
+	args->mode = mode;
+	args->an = autoneg;
+	args->ports = 0;
+}
+
+static void otx2_map_ethtool_link_modes(u64 bitmask,
+					struct cgx_set_link_mode_args *args)
+{
+	switch (bitmask) {
+	case BIT_ULL(ETHTOOL_LINK_MODE_10baseT_Half_BIT):
+		set_mod_args(args, 10, 1, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10baseT_Full_BIT):
+		set_mod_args(args, 10, 0, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_100baseT_Half_BIT):
+		set_mod_args(args, 100, 1, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_100baseT_Full_BIT):
+		set_mod_args(args, 100, 0, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_1000baseT_Half_BIT):
+		set_mod_args(args, 1000, 1, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_1000baseT_Full_BIT):
+		set_mod_args(args, 1000, 0, 1, BIT_ULL(CGX_MODE_SGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_1000baseX_Full_BIT):
+		set_mod_args(args, 1000, 0, 0, BIT_ULL(CGX_MODE_1000_BASEX));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10000baseT_Full_BIT):
+		set_mod_args(args, 1000, 0, 1, BIT_ULL(CGX_MODE_QSGMII));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10000baseKX4_Full_BIT):
+		set_mod_args(args, 10000, 0, 0, BIT_ULL(CGX_MODE_10G_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10000baseR_FEC_BIT):
+		set_mod_args(args, 10000, 0, 0, BIT_ULL(CGX_MODE_10G_C2M));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10000baseKR_Full_BIT):
+		set_mod_args(args, 10000, 0, 1, BIT_ULL(CGX_MODE_10G_KR));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_20000baseMLD2_Full_BIT):
+		set_mod_args(args, 20000, 0, 0, BIT_ULL(CGX_MODE_20G_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10000baseCR_Full_BIT):
+		set_mod_args(args, 25000, 0, 0, BIT_ULL(CGX_MODE_25G_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_25000baseSR_Full_BIT):
+		set_mod_args(args, 25000, 0, 0, BIT_ULL(CGX_MODE_25G_C2M));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT):
+		set_mod_args(args, 25000, 0, 0, BIT_ULL(CGX_MODE_25G_2_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_25000baseCR_Full_BIT):
+		set_mod_args(args, 25000, 0, 1, BIT_ULL(CGX_MODE_25G_CR));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_25000baseKR_Full_BIT):
+		set_mod_args(args, 25000, 0, 1, BIT_ULL(CGX_MODE_25G_KR));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_40000baseSR4_Full_BIT):
+		set_mod_args(args, 40000, 0, 0, BIT_ULL(CGX_MODE_40G_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_40000baseLR4_Full_BIT):
+		set_mod_args(args, 40000, 0, 0, BIT_ULL(CGX_MODE_40G_C2M));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_40000baseCR4_Full_BIT):
+		set_mod_args(args, 40000, 0, 1, BIT_ULL(CGX_MODE_40G_CR4));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_40000baseKR4_Full_BIT):
+		set_mod_args(args, 40000, 0, 1, BIT_ULL(CGX_MODE_40G_KR4));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10000baseSR_Full_BIT):
+		set_mod_args(args, 40000, 0, 0, BIT_ULL(CGX_MODE_40GAUI_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_50000baseSR2_Full_BIT):
+		set_mod_args(args, 50000, 0, 0, BIT_ULL(CGX_MODE_50G_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_56000baseKR4_Full_BIT):
+		set_mod_args(args, 50000, 0, 0, BIT_ULL(CGX_MODE_50G_4_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10000baseLR_Full_BIT):
+		set_mod_args(args, 50000, 0, 0, BIT_ULL(CGX_MODE_50G_C2M));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_50000baseCR2_Full_BIT):
+		set_mod_args(args, 50000, 0, 1, BIT_ULL(CGX_MODE_50G_CR));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_50000baseKR2_Full_BIT):
+		set_mod_args(args, 50000, 0, 1, BIT_ULL(CGX_MODE_50G_KR));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_10000baseLRM_Full_BIT):
+		set_mod_args(args, 80000, 0, 0, BIT_ULL(CGX_MODE_80GAUI_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT):
+		set_mod_args(args, 100000, 0, 0, BIT_ULL(CGX_MODE_100G_C2C));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT):
+		set_mod_args(args, 100000, 0, 0, BIT_ULL(CGX_MODE_100G_C2M));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT):
+		set_mod_args(args, 100000, 0, 1, BIT_ULL(CGX_MODE_100G_CR4));
+		break;
+	case  BIT_ULL(ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT):
+		set_mod_args(args, 100000, 0, 1, BIT_ULL(CGX_MODE_100G_KR4));
+		break;
+	default:
+		set_mod_args(args, 0, 1, 0, BIT_ULL(CGX_MODE_MAX));
+		break;
+	}
+}
+
+static void link_status_user_format(u64 lstat,
+				    struct cgx_link_user_info *linfo,
+				    struct cgx *cgx, u8 lmac_id)
 {
 	char *lmac_string;
 
 	linfo->link_up = FIELD_GET(RESP_LINKSTAT_UP, lstat);
 	linfo->full_duplex = FIELD_GET(RESP_LINKSTAT_FDUPLEX, lstat);
 	linfo->speed = cgx_speed_mbps[FIELD_GET(RESP_LINKSTAT_SPEED, lstat)];
+	linfo->an = FIELD_GET(RESP_LINKSTAT_AN, lstat);
+	linfo->fec = FIELD_GET(RESP_LINKSTAT_FEC, lstat);
+	linfo->port = FIELD_GET(RESP_LINKSTAT_PORT, lstat);
 	linfo->lmac_type_id = cgx_get_lmac_type(cgx, lmac_id);
 	lmac_string = cgx_lmactype_string[linfo->lmac_type_id];
 	strncpy(linfo->lmac_type, lmac_string, LMACTYPE_STR_LEN - 1);
 }
 
 /* Hardware event handlers */
-static inline void cgx_link_change_handler(u64 lstat,
-					   struct lmac *lmac)
+static void cgx_link_change_handler(u64 lstat, struct lmac *lmac)
 {
 	struct cgx_link_user_info *linfo;
 	struct cgx *cgx = lmac->cgx;
@@ -620,6 +832,8 @@ static inline void cgx_link_change_handler(u64 lstat,
 	lmac->link_info = event.link_uinfo;
 	linfo = &lmac->link_info;
 
+	if (err_type == CGX_ERR_SPEED_CHANGE_INVALID)
+		return;
 	/* Ensure callback doesn't get unregistered until we finish it */
 	spin_lock(&lmac->event_cb_lock);
 
@@ -642,13 +856,14 @@ static inline void cgx_link_change_handler(u64 lstat,
 	spin_unlock(&lmac->event_cb_lock);
 }
 
-static inline bool cgx_cmdresp_is_linkevent(u64 event)
+static bool cgx_cmdresp_is_linkevent(u64 event)
 {
 	u8 id;
 
 	id = FIELD_GET(EVTREG_ID, event);
 	if (id == CGX_CMD_LINK_BRING_UP ||
-	    id == CGX_CMD_LINK_BRING_DOWN)
+	    id == CGX_CMD_LINK_BRING_DOWN ||
+	    id == CGX_CMD_MODE_CHANGE)
 		return true;
 	else
 		return false;
@@ -746,7 +961,7 @@ static irqreturn_t cgx_fwi_event_handler(int irq, void *data)
 
 		/* Release thread waiting for completion  */
 		lmac->cmd_pend = false;
-		wake_up_interruptible(&lmac->wq_cmd_cmplt);
+		wake_up(&lmac->wq_cmd_cmplt);
 		break;
 	case CGX_EVT_ASYNC:
 		if (cgx_event_is_linkevent(event))
@@ -819,6 +1034,53 @@ int cgx_get_fwdata_base(u64 *base)
 	return err;
 }
 
+int cgx_set_fec(u64 fec, int cgx_id, int lmac_id)
+{
+	u64 req = 0, resp;
+	struct cgx *cgx;
+	int err = 0;
+
+	cgx = cgx_get_pdata(cgx_id);
+	if (!cgx)
+		return -ENXIO;
+
+	req = FIELD_SET(CMDREG_ID, CGX_CMD_SET_FEC, req);
+	req = FIELD_SET(CMDSETFEC, fec, req);
+	err = cgx_fwi_cmd_generic(req, &resp, cgx, lmac_id);
+	if (!err) {
+		cgx->lmac_idmap[lmac_id]->link_info.fec =
+			FIELD_GET(RESP_LINKSTAT_FEC, resp);
+		return cgx->lmac_idmap[lmac_id]->link_info.fec;
+	}
+	return err;
+}
+
+int cgx_set_link_mode(void *cgxd, struct cgx_set_link_mode_args args,
+		      int cgx_id, int lmac_id)
+{
+	struct cgx *cgx = cgxd;
+	u64 req = 0, resp;
+	int err = 0;
+
+	if (!cgx)
+		return -ENODEV;
+
+	if (args.mode)
+		otx2_map_ethtool_link_modes(args.mode, &args);
+	if (!args.speed && args.duplex && !args.an)
+		return -EINVAL;
+
+	req = FIELD_SET(CMDREG_ID, CGX_CMD_MODE_CHANGE, req);
+	req = FIELD_SET(CMDMODECHANGE_SPEED,
+			cgx_link_usertable_index_map(args.speed), req);
+	req = FIELD_SET(CMDMODECHANGE_DUPLEX, args.duplex, req);
+	req = FIELD_SET(CMDMODECHANGE_AN, args.an, req);
+	req = FIELD_SET(CMDMODECHANGE_PORT, args.ports, req);
+	req = FIELD_SET(CMDMODECHANGE_FLAGS, args.mode, req);
+	err = cgx_fwi_cmd_generic(req, &resp, cgx, lmac_id);
+	return err;
+}
+
 static int cgx_fwi_link_change(struct cgx *cgx, int lmac_id, bool enable)
 {
 	u64 req = 0;
@@ -880,6 +1142,16 @@ static void cgx_lmac_linkup_work(struct work_struct *work)
 	}
 }
 
+int cgx_set_link_state(void *cgxd, int lmac_id, bool enable)
+{
+	struct cgx *cgx = cgxd;
+
+	if (!cgx)
+		return -ENODEV;
+
+	return cgx_fwi_link_change(cgx, lmac_id, enable);
+}
+
 int cgx_lmac_linkup_start(void *cgxd)
 {
 	struct cgx *cgx = cgxd;
@@ -912,6 +1184,7 @@ static int cgx_lmac_init(struct cgx *cgx)
 		sprintf(lmac->name, "cgx_fwi_%d_%d", cgx->cgx_id, i);
 		lmac->lmac_id = i;
 		lmac->cgx = cgx;
+
 		init_waitqueue_head(&lmac->wq_cmd_cmplt);
 		mutex_init(&lmac->cmd_lock);
 		spin_lock_init(&lmac->event_cb_lock);
@@ -1009,7 +1282,7 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!cgx->cgx_cmd_workq) {
 		dev_err(dev, "alloc workqueue failed for cgx cmd");
 		err = -ENOMEM;
-		goto err_free_irq_vectors;
+		goto err_release_regions;
 	}
 
 	list_add(&cgx->cgx_list, &cgx_list);
@@ -1025,8 +1298,6 @@ static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 err_release_lmac:
 	cgx_lmac_exit(cgx);
 	list_del(&cgx->cgx_list);
-err_free_irq_vectors:
-	pci_free_irq_vectors(pdev);
 err_release_regions:
 	pci_release_regions(pdev);
 err_disable_device:
@@ -1039,8 +1310,11 @@ static void cgx_remove(struct pci_dev *pdev)
 {
 	struct cgx *cgx = pci_get_drvdata(pdev);
 
-	cgx_lmac_exit(cgx);
-	list_del(&cgx->cgx_list);
+	if (cgx) {
+		cgx_lmac_exit(cgx);
+		list_del(&cgx->cgx_list);
+	}
+
 	pci_free_irq_vectors(pdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index f0747e4..a491016 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -52,10 +52,14 @@
 #define CGXX_SCRATCH1_REG		0x1058
 #define CGX_CONST			0x2000
 #define CGXX_SPUX_CONTROL1		0x10000
+#define CGXX_SPUX_LNX_FEC_CORR_BLOCKS	0x10700
+#define CGXX_SPUX_LNX_FEC_UNCORR_BLOCKS	0x10800
+#define CGXX_SPUX_RSFEC_CORR		0x10088
+#define CGXX_SPUX_RSFEC_UNCORR		0x10090
+
 #define CGXX_SPUX_CONTROL1_LBK		BIT_ULL(14)
 #define CGXX_GMP_PCS_MRX_CTL		0x30000
 #define CGXX_GMP_PCS_MRX_CTL_LBK	BIT_ULL(14)
-
 #define CGXX_SMUX_RX_FRM_CTL		0x20020
 #define CGX_SMUX_RX_FRM_CTL_CTL_BCK	BIT_ULL(3)
 #define CGXX_GMP_GMI_RXX_FRM_CTL	0x38028
@@ -124,6 +128,7 @@ int cgx_lmac_evh_register(struct cgx_event_cb *cb, void *cgxd, int lmac_id);
 int cgx_lmac_evh_unregister(void *cgxd, int lmac_id);
 int cgx_get_tx_stats(void *cgxd, int lmac_id, int idx, u64 *tx_stat);
 int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat);
+int cgx_get_fec_stats(void *cgxd, int lmac_id, struct cgx_fec_stats_rsp *rsp);
 int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable);
 int cgx_lmac_tx_enable(void *cgxd, int lmac_id, bool enable);
 int cgx_lmac_addr_set(u8 cgx_id, u8 lmac_id, u8 *mac_addr);
@@ -135,9 +140,13 @@ int cgx_get_link_info(void *cgxd, int lmac_id,
 		      struct cgx_link_user_info *linfo);
 int cgx_lmac_linkup_start(void *cgxd);
 int cgx_get_fwdata_base(u64 *base);
+int cgx_set_fec(u64 fec, int cgx_id, int lmac_id);
+int cgx_set_link_mode(void *cgxd, struct cgx_set_link_mode_args args,
+		      int cgx_id, int lmac_id);
 int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
 			   u8 *tx_pause, u8 *rx_pause);
 int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
 			   u8 tx_pause, u8 rx_pause);
+int cgx_set_link_state(void *cgxd, int lmac_id, bool enable);
 int cgx_get_mkex_prfl_info(u64 *addr, u64 *size);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
index cc505bc..db60853 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
@@ -43,7 +43,13 @@ enum cgx_error_type {
 	CGX_ERR_TRAINING_FAIL,
 	CGX_ERR_RX_EQU_FAIL,
 	CGX_ERR_SPUX_BER_FAIL,
-	CGX_ERR_SPUX_RSFEC_ALGN_FAIL,   /* = 22 */
+	CGX_ERR_SPUX_RSFEC_ALGN_FAIL,
+	CGX_ERR_SPUX_MARKER_LOCK_FAIL,
+	CGX_ERR_SET_FEC_INVALID,
+	CGX_ERR_SET_FEC_FAIL,
+	CGX_ERR_MODULE_INVALID,
+	CGX_ERR_MODULE_NOT_PRESENT,
+	CGX_ERR_SPEED_CHANGE_INVALID,
 };
 
 /* LINK speed types */
@@ -59,10 +65,42 @@ enum cgx_link_speed {
 	CGX_LINK_25G,
 	CGX_LINK_40G,
 	CGX_LINK_50G,
+	CGX_LINK_80G,
 	CGX_LINK_100G,
 	CGX_LINK_SPEED_MAX,
 };
 
+enum CGX_MODE_ {
+	CGX_MODE_SGMII,
+	CGX_MODE_1000_BASEX,
+	CGX_MODE_QSGMII,
+	CGX_MODE_10G_C2C,
+	CGX_MODE_10G_C2M,
+	CGX_MODE_10G_KR,
+	CGX_MODE_20G_C2C,
+	CGX_MODE_25G_C2C,
+	CGX_MODE_25G_C2M,
+	CGX_MODE_25G_2_C2C,
+	CGX_MODE_25G_CR,
+	CGX_MODE_25G_KR,
+	CGX_MODE_40G_C2C,
+	CGX_MODE_40G_C2M,
+	CGX_MODE_40G_CR4,
+	CGX_MODE_40G_KR4,
+	CGX_MODE_40GAUI_C2C,
+	CGX_MODE_50G_C2C,
+	CGX_MODE_50G_C2M,
+	CGX_MODE_50G_4_C2C,
+	CGX_MODE_50G_CR,
+	CGX_MODE_50G_KR,
+	CGX_MODE_80GAUI_C2C,
+	CGX_MODE_100G_C2C,
+	CGX_MODE_100G_C2M,
+	CGX_MODE_100G_CR4,
+	CGX_MODE_100G_KR4,
+	CGX_MODE_MAX /* = 29 */
+};
+
 /* REQUEST ID types. Input to firmware */
 enum cgx_cmd_id {
 	CGX_CMD_NONE,
@@ -75,12 +113,20 @@ enum cgx_cmd_id {
 	CGX_CMD_INTERNAL_LBK,
 	CGX_CMD_EXTERNAL_LBK,
 	CGX_CMD_HIGIG,
-	CGX_CMD_LINK_STATE_CHANGE,
+	CGX_CMD_LINK_STAT_CHANGE,
 	CGX_CMD_MODE_CHANGE,		/* hot plug support */
 	CGX_CMD_INTF_SHUTDOWN,
 	CGX_CMD_GET_MKEX_PRFL_SIZE,
 	CGX_CMD_GET_MKEX_PRFL_ADDR,
 	CGX_CMD_GET_FWD_BASE,		/* get base address of shared FW data */
+	CGX_CMD_GET_LINK_MODES,		/* Supported Link Modes */
+	CGX_CMD_SET_LINK_MODE,
+	CGX_CMD_GET_SUPPORTED_FEC,
+	CGX_CMD_SET_FEC,
+	CGX_CMD_GET_AN,
+	CGX_CMD_SET_AN,
+	CGX_CMD_GET_ADV_LINK_MODES,
+	CGX_CMD_GET_ADV_FEC,
 };
 
 /* async event ids */
@@ -149,7 +195,6 @@ enum cgx_cmd_own {
  * CGX_STAT_SUCCESS
  */
 #define RESP_MKEX_PRFL_ADDR		GENMASK_ULL(63, 9)
-
 /* Response to cmd ID as CGX_CMD_GET_FWD_BASE with cmd status as
  * CGX_STAT_SUCCESS
  */
@@ -171,13 +216,19 @@ struct cgx_lnk_sts {
 	uint64_t full_duplex:1;
 	uint64_t speed:4;		/* cgx_link_speed */
 	uint64_t err_type:10;
-	uint64_t reserved2:39;
+	uint64_t an:1;			/* AN supported or not */
+	uint64_t fec:2;			/* FEC type if enabled, if not 0 */
+	uint64_t port:8;
+	uint64_t reserved2:28;
 };
 
 #define RESP_LINKSTAT_UP		GENMASK_ULL(9, 9)
 #define RESP_LINKSTAT_FDUPLEX		GENMASK_ULL(10, 10)
 #define RESP_LINKSTAT_SPEED		GENMASK_ULL(14, 11)
 #define RESP_LINKSTAT_ERRTYPE		GENMASK_ULL(24, 15)
+#define RESP_LINKSTAT_AN		GENMASK_ULL(25, 25)
+#define RESP_LINKSTAT_FEC		GENMASK_ULL(27, 26)
+#define RESP_LINKSTAT_PORT		GENMASK_ULL(35, 28)
 
 /* scratchx(1) CSR used for non-secure SW->ATF communication
  * This CSR acts as a command register
@@ -198,5 +249,18 @@ struct cgx_lnk_sts {
 #define CMDLINKCHANGE_LINKUP	BIT_ULL(8)
 #define CMDLINKCHANGE_FULLDPLX	BIT_ULL(9)
 #define CMDLINKCHANGE_SPEED	GENMASK_ULL(13, 10)
+#define CMDSETFEC		GENMASK_ULL(9, 8)
+/* command argument to be passed for cmd ID - CGX_CMD_MODE_CHANGE */
+#define CMDMODECHANGE_SPEED		GENMASK_ULL(11, 8)
+#define CMDMODECHANGE_DUPLEX		GENMASK_ULL(12, 12)
+#define CMDMODECHANGE_AN		GENMASK_ULL(13, 13)
+#define CMDMODECHANGE_PORT		GENMASK_ULL(21, 14)
+#define CMDMODECHANGE_FLAGS		GENMASK_ULL(63, 22)
+
+/* command argument to be passed for cmd ID - CGX_CMD_SET_PHY_MOD_TYPE */
+#define CMDSETPHYMODTYPE	GENMASK_ULL(8, 8)
+
+/* response to cmd ID - RESP_GETPHYMODTYPE */
+#define RESP_GETPHYMODTYPE	GENMASK_ULL(9, 9)
 
 #endif /* __CGX_FW_INTF_H__ */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 0822fca..0ff24b5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -145,6 +145,13 @@ M(CGX_INTLBK_ENABLE,	0x20A, cgx_intlbk_enable, msg_req, msg_rsp)	\
 M(CGX_INTLBK_DISABLE,	0x20B, cgx_intlbk_disable, msg_req, msg_rsp)	\
 M(CGX_CFG_PAUSE_FRM,	0x20E, cgx_cfg_pause_frm, cgx_pause_frm_cfg,	\
 			       cgx_pause_frm_cfg)			\
+M(CGX_FW_DATA_GET,	0x20F, cgx_get_aux_link_info, msg_req, cgx_fw_data) \
+M(CGX_FEC_SET,		0x210, cgx_set_fec_param, fec_mode, fec_mode) \
+M(CGX_SET_LINK_STATE,	0x214, cgx_set_link_state,    \
+				cgx_set_link_state_msg, msg_rsp)	\
+M(CGX_FEC_STATS,	0x217, cgx_fec_stats, msg_req, cgx_fec_stats_rsp) \
+M(CGX_SET_LINK_MODE,	0x218, cgx_set_link_mode, cgx_set_link_mode_req,\
+			       cgx_set_link_mode_rsp)	\
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 M(NPA_LF_ALLOC,		0x400, npa_lf_alloc,				\
 				npa_lf_alloc_req, npa_lf_alloc_rsp)	\
@@ -350,6 +357,12 @@ struct cgx_stats_rsp {
 	u64 tx_stats[CGX_TX_STATS_COUNT];
 };
 
+struct cgx_fec_stats_rsp {
+	struct mbox_msghdr hdr;
+	u64 fec_corr_blks;
+	u64 fec_uncorr_blks;
+};
+
 /* Structure for requesting the operation for
  * setting/getting mac address in the CGX interface
  */
@@ -363,6 +376,9 @@ struct cgx_link_user_info {
 	uint64_t full_duplex:1;
 	uint64_t lmac_type_id:4;
 	uint64_t speed:20; /* speed in Mbps */
+	uint64_t an:1;	  /* AN supported or not */
+	uint64_t fec:2;	 /* FEC type if enabled else 0 */
+	uint64_t port:8;
 #define LMACTYPE_STR_LEN 16
 	char lmac_type[LMACTYPE_STR_LEN];
 };
@@ -381,6 +397,66 @@ struct cgx_pause_frm_cfg {
 	u8 tx_pause;
 };
 
+struct sfp_eeprom_s {
+#define SFP_EEPROM_SIZE 256
+	u16 sff_id;
+	u8 buf[SFP_EEPROM_SIZE];
+	u64 reserved;
+};
+
+enum fec_type {
+	OTX2_FEC_NONE,
+	OTX2_FEC_BASER,
+	OTX2_FEC_RS,
+};
+
+struct cgx_lmac_fwdata_s {
+	u16 rw_valid;
+	u64 supported_fec;
+	u64 supported_an;
+	u64 supported_link_modes;
+	/* only applicable if AN is supported */
+	u64 advertised_fec;
+	u64 advertised_link_modes;
+	/* Only applicable if SFP/QSFP slot is present */
+	struct sfp_eeprom_s sfp_eeprom;
+#define LMAC_FWDATA_RESERVED_MEM 1024
+	u64 reserved[LMAC_FWDATA_RESERVED_MEM];
+};
+
+struct cgx_fw_data {
+	struct mbox_msghdr hdr;
+	struct cgx_lmac_fwdata_s fwdata;
+};
+
+struct fec_mode {
+	struct mbox_msghdr hdr;
+	int fec;
+};
+
+struct cgx_set_link_state_msg {
+	struct mbox_msghdr hdr;
+	u8 enable; /* '1' for link up, '0' for link down */
+};
+
+struct cgx_set_link_mode_args {
+	u32 speed;
+	u8 duplex;
+	u8 an;
+	u8 ports;
+	u64 mode;
+};
+
+struct cgx_set_link_mode_req {
+	struct mbox_msghdr hdr;
+	struct cgx_set_link_mode_args args;
+};
+
+struct cgx_set_link_mode_rsp {
+	struct mbox_msghdr hdr;
+	int status;
+};
+
 /* NPA mbox message formats */
 
 /* NPA mailbox error codes
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index c54627a..972f4d2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -305,6 +305,10 @@ struct rvu_fwdata {
 	u64 msixtr_base;
 #define FWDATA_RESERVED_MEM 1023
 	u64 reserved[FWDATA_RESERVED_MEM];
+	/* Do not add new fields below this line */
+#define CGX_MAX         4
+#define CGX_LMACS_MAX   4
+	struct cgx_lmac_fwdata_s cgx_fw_data[CGX_MAX][CGX_LMACS_MAX];
 };
 
 struct rvu {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index e9f8953..0fd7b1b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -185,12 +185,8 @@ static void cgx_notify_pfs(struct cgx_link_event *event, struct rvu *rvu)
 		clear_bit(pfid, &pfmap);
 
 		/* check if notification is enabled */
-		if (!test_bit(pfid, &rvu->pf_notify_bmap)) {
-			dev_info(rvu->dev, "cgx %d: lmac %d Link status %s\n",
-				 event->cgx_id, event->lmac_id,
-				 linfo->link_up ? "UP" : "DOWN");
+		if (!test_bit(pfid, &rvu->pf_notify_bmap))
 			continue;
-		}
 
 		/* Send mbox message to PF */
 		msg = otx2_mbox_alloc_msg_cgx_link_event(rvu, pfid);
@@ -286,7 +282,7 @@ int rvu_cgx_init(struct rvu *rvu)
 	rvu->cgx_cnt_max = cgx_get_cgxcnt_max();
 	if (!rvu->cgx_cnt_max) {
 		dev_info(rvu->dev, "No CGX devices found!\n");
-		return -ENODEV;
+		return 0;
 	}
 
 	rvu->cgx_idmap = devm_kzalloc(rvu->dev, rvu->cgx_cnt_max *
@@ -445,6 +441,24 @@ int rvu_mbox_handler_cgx_stats(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
+int rvu_mbox_handler_cgx_fec_stats(struct rvu *rvu,
+				   struct msg_req *req,
+				   struct cgx_fec_stats_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_idx, lmac;
+	int err = 0;
+	void *cgxd;
+
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
+
+	cgxd = rvu_cgx_pdata(cgx_idx, rvu);
+	err = cgx_get_fec_stats(cgxd, lmac, rsp);
+	return err;
+}
+
 int rvu_mbox_handler_cgx_mac_addr_set(struct rvu *rvu,
 				      struct cgx_mac_addr_set_or_get *req,
 				      struct cgx_mac_addr_set_or_get *rsp)
@@ -553,7 +567,7 @@ int rvu_mbox_handler_cgx_get_linkinfo(struct rvu *rvu, struct msg_req *req,
 	pf = rvu_get_pf(req->hdr.pcifunc);
 
 	if (!is_pf_cgxmapped(rvu, pf))
-		return -ENODEV;
+		return -EPERM;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 
@@ -704,3 +718,74 @@ int rvu_cgx_start_stop_io(struct rvu *rvu, u16 pcifunc, bool start)
 	mutex_unlock(&rvu->cgx_cfg_lock);
 	return err;
 }
+
+int rvu_mbox_handler_cgx_get_aux_link_info(struct rvu *rvu, struct msg_req *req,
+					   struct cgx_fw_data *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_id, lmac_id;
+
+	if (!rvu->fwdata)
+		return -ENXIO;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+	memcpy(&rsp->fwdata, &rvu->fwdata->cgx_fw_data[cgx_id][lmac_id],
+	       sizeof(struct cgx_lmac_fwdata_s));
+	return 0;
+}
+
+int rvu_mbox_handler_cgx_set_fec_param(struct rvu *rvu,
+				       struct fec_mode *req,
+				       struct fec_mode *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_id, lmac_id;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	rsp->fec = cgx_set_fec(req->fec, cgx_id, lmac_id);
+	return 0;
+}
+
+int rvu_mbox_handler_cgx_set_link_state(struct rvu *rvu,
+					struct cgx_set_link_state_msg *req,
+					struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	u8 cgx_id, lmac_id;
+	int pf, err;
+
+	pf = rvu_get_pf(pcifunc);
+
+	if (!is_cgx_config_permitted(rvu, pcifunc))
+		return -EPERM;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+	err = cgx_set_link_state(rvu_cgx_pdata(cgx_id, rvu), lmac_id,
+				 !!req->enable);
+	if (err)
+		dev_warn(rvu->dev, "Cannot set link state to %s, err %d\n",
+			 (req->enable) ? "enable" : "disable", err);
+
+	return err;
+}
+
+int rvu_mbox_handler_cgx_set_link_mode(struct rvu *rvu,
+				       struct cgx_set_link_mode_req *req,
+				       struct cgx_set_link_mode_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_idx, lmac;
+	void *cgxd;
+
+	if (!is_cgx_config_permitted(rvu, req->hdr.pcifunc))
+		return -EPERM;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_idx, &lmac);
+
+	cgxd = rvu_cgx_pdata(cgx_idx, rvu);
+
+	rsp->status =  cgx_set_link_mode(cgxd, req->args, cgx_idx, lmac);
+	return 0;
+}
-- 
2.7.4

