Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBEC12D019
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 13:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfL3Mxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 07:53:39 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:21438 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbfL3Mxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 07:53:39 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xBUCrTRo005274;
        Mon, 30 Dec 2019 04:53:30 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com, Surendra Mobiya <surendra@chelsio.com>
Subject: [PATCH net] cxgb4/cxgb4vf: fix flow control display for auto negotiation
Date:   Mon, 30 Dec 2019 18:14:08 +0530
Message-Id: <1577709848-6417-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per 802.3-2005, Section Two, Annex 28B, Table 28B-2 [1], when
_only_ Rx pause is enabled, both symmetric and asymmetric pause
towards local device must be enabled. Also, firmware returns the local
device's flow control pause params as part of advertised capabilities
and negotiated params as part of current link attributes. So, fix up
ethtool's flow control pause params fetch logic to read from acaps,
instead of linkattr.

[1] https://standards.ieee.org/standard/802_3-2005.html

Fixes: c3168cabe1af ("cxgb4/cxgbvf: Handle 32-bit fw port capabilities")
Signed-off-by: Surendra Mobiya <surendra@chelsio.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  1 +
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    |  4 ++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    | 21 ++++++++++++-------
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  4 ++--
 .../ethernet/chelsio/cxgb4vf/t4vf_common.h    |  1 +
 .../net/ethernet/chelsio/cxgb4vf/t4vf_hw.c    | 18 +++++++++-------
 6 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index a70ac2097892..becee29f5df7 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -504,6 +504,7 @@ struct link_config {
 
 	enum cc_pause  requested_fc;     /* flow control user has requested */
 	enum cc_pause  fc;               /* actual link flow control */
+	enum cc_pause  advertised_fc;    /* actual advertised flow control */
 
 	enum cc_fec    requested_fec;	 /* Forward Error Correction: */
 	enum cc_fec    fec;		 /* requested and actual in use */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 20ab3b6285a2..c837382ee522 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -807,8 +807,8 @@ static void get_pauseparam(struct net_device *dev,
 	struct port_info *p = netdev_priv(dev);
 
 	epause->autoneg = (p->link_cfg.requested_fc & PAUSE_AUTONEG) != 0;
-	epause->rx_pause = (p->link_cfg.fc & PAUSE_RX) != 0;
-	epause->tx_pause = (p->link_cfg.fc & PAUSE_TX) != 0;
+	epause->rx_pause = (p->link_cfg.advertised_fc & PAUSE_RX) != 0;
+	epause->tx_pause = (p->link_cfg.advertised_fc & PAUSE_TX) != 0;
 }
 
 static int set_pauseparam(struct net_device *dev,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 19d18acfc9a6..844fdcf55118 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -4089,7 +4089,8 @@ static inline fw_port_cap32_t cc_to_fwcap_pause(enum cc_pause cc_pause)
 		if (cc_pause & PAUSE_TX)
 			fw_pause |= FW_PORT_CAP32_802_3_PAUSE;
 		else
-			fw_pause |= FW_PORT_CAP32_802_3_ASM_DIR;
+			fw_pause |= FW_PORT_CAP32_802_3_ASM_DIR |
+				    FW_PORT_CAP32_802_3_PAUSE;
 	} else if (cc_pause & PAUSE_TX) {
 		fw_pause |= FW_PORT_CAP32_802_3_ASM_DIR;
 	}
@@ -8563,17 +8564,17 @@ static fw_port_cap32_t lstatus_to_fwcap(u32 lstatus)
 void t4_handle_get_port_info(struct port_info *pi, const __be64 *rpl)
 {
 	const struct fw_port_cmd *cmd = (const void *)rpl;
-	int action = FW_PORT_CMD_ACTION_G(be32_to_cpu(cmd->action_to_len16));
-	struct adapter *adapter = pi->adapter;
+	fw_port_cap32_t pcaps, acaps, lpacaps, linkattr;
 	struct link_config *lc = &pi->link_cfg;
-	int link_ok, linkdnrc;
-	enum fw_port_type port_type;
+	struct adapter *adapter = pi->adapter;
+	unsigned int speed, fc, fec, adv_fc;
 	enum fw_port_module_type mod_type;
-	unsigned int speed, fc, fec;
-	fw_port_cap32_t pcaps, acaps, lpacaps, linkattr;
+	int action, link_ok, linkdnrc;
+	enum fw_port_type port_type;
 
 	/* Extract the various fields from the Port Information message.
 	 */
+	action = FW_PORT_CMD_ACTION_G(be32_to_cpu(cmd->action_to_len16));
 	switch (action) {
 	case FW_PORT_ACTION_GET_PORT_INFO: {
 		u32 lstatus = be32_to_cpu(cmd->u.info.lstatus_to_modtype);
@@ -8611,6 +8612,7 @@ void t4_handle_get_port_info(struct port_info *pi, const __be64 *rpl)
 	}
 
 	fec = fwcap_to_cc_fec(acaps);
+	adv_fc = fwcap_to_cc_pause(acaps);
 	fc = fwcap_to_cc_pause(linkattr);
 	speed = fwcap_to_speed(linkattr);
 
@@ -8667,7 +8669,9 @@ void t4_handle_get_port_info(struct port_info *pi, const __be64 *rpl)
 	}
 
 	if (link_ok != lc->link_ok || speed != lc->speed ||
-	    fc != lc->fc || fec != lc->fec) {	/* something changed */
+	    fc != lc->fc || adv_fc != lc->advertised_fc ||
+	    fec != lc->fec) {
+		/* something changed */
 		if (!link_ok && lc->link_ok) {
 			lc->link_down_rc = linkdnrc;
 			dev_warn_ratelimited(adapter->pdev_dev,
@@ -8677,6 +8681,7 @@ void t4_handle_get_port_info(struct port_info *pi, const __be64 *rpl)
 		}
 		lc->link_ok = link_ok;
 		lc->speed = speed;
+		lc->advertised_fc = adv_fc;
 		lc->fc = fc;
 		lc->fec = fec;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index f6fc0875d5b0..f4d41f968afa 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1690,8 +1690,8 @@ static void cxgb4vf_get_pauseparam(struct net_device *dev,
 	struct port_info *pi = netdev_priv(dev);
 
 	pauseparam->autoneg = (pi->link_cfg.requested_fc & PAUSE_AUTONEG) != 0;
-	pauseparam->rx_pause = (pi->link_cfg.fc & PAUSE_RX) != 0;
-	pauseparam->tx_pause = (pi->link_cfg.fc & PAUSE_TX) != 0;
+	pauseparam->rx_pause = (pi->link_cfg.advertised_fc & PAUSE_RX) != 0;
+	pauseparam->tx_pause = (pi->link_cfg.advertised_fc & PAUSE_TX) != 0;
 }
 
 /*
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h
index ccca67cf4487..57cfd10a99ec 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_common.h
@@ -135,6 +135,7 @@ struct link_config {
 
 	enum cc_pause	requested_fc;	/* flow control user has requested */
 	enum cc_pause	fc;		/* actual link flow control */
+	enum cc_pause   advertised_fc;  /* actual advertised flow control */
 
 	enum cc_fec	auto_fec;	/* Forward Error Correction: */
 	enum cc_fec	requested_fec;	/*   "automatic" (IEEE 802.3), */
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
index 8a389d617a23..9d49ff211cc1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c
@@ -1913,16 +1913,16 @@ static const char *t4vf_link_down_rc_str(unsigned char link_down_rc)
 static void t4vf_handle_get_port_info(struct port_info *pi,
 				      const struct fw_port_cmd *cmd)
 {
-	int action = FW_PORT_CMD_ACTION_G(be32_to_cpu(cmd->action_to_len16));
-	struct adapter *adapter = pi->adapter;
+	fw_port_cap32_t pcaps, acaps, lpacaps, linkattr;
 	struct link_config *lc = &pi->link_cfg;
-	int link_ok, linkdnrc;
-	enum fw_port_type port_type;
+	struct adapter *adapter = pi->adapter;
+	unsigned int speed, fc, fec, adv_fc;
 	enum fw_port_module_type mod_type;
-	unsigned int speed, fc, fec;
-	fw_port_cap32_t pcaps, acaps, lpacaps, linkattr;
+	int action, link_ok, linkdnrc;
+	enum fw_port_type port_type;
 
 	/* Extract the various fields from the Port Information message. */
+	action = FW_PORT_CMD_ACTION_G(be32_to_cpu(cmd->action_to_len16));
 	switch (action) {
 	case FW_PORT_ACTION_GET_PORT_INFO: {
 		u32 lstatus = be32_to_cpu(cmd->u.info.lstatus_to_modtype);
@@ -1982,6 +1982,7 @@ static void t4vf_handle_get_port_info(struct port_info *pi,
 	}
 
 	fec = fwcap_to_cc_fec(acaps);
+	adv_fc = fwcap_to_cc_pause(acaps);
 	fc = fwcap_to_cc_pause(linkattr);
 	speed = fwcap_to_speed(linkattr);
 
@@ -2012,7 +2013,9 @@ static void t4vf_handle_get_port_info(struct port_info *pi,
 	}
 
 	if (link_ok != lc->link_ok || speed != lc->speed ||
-	    fc != lc->fc || fec != lc->fec) {	/* something changed */
+	    fc != lc->fc || adv_fc != lc->advertised_fc ||
+	    fec != lc->fec) {
+		/* something changed */
 		if (!link_ok && lc->link_ok) {
 			lc->link_down_rc = linkdnrc;
 			dev_warn_ratelimited(adapter->pdev_dev,
@@ -2022,6 +2025,7 @@ static void t4vf_handle_get_port_info(struct port_info *pi,
 		}
 		lc->link_ok = link_ok;
 		lc->speed = speed;
+		lc->advertised_fc = adv_fc;
 		lc->fc = fc;
 		lc->fec = fec;
 
-- 
2.24.0

