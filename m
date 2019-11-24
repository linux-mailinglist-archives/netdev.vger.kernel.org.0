Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C66A1108199
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 04:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfKXDbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 22:31:40 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40286 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfKXDbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 22:31:38 -0500
Received: by mail-pf1-f195.google.com with SMTP id i187so1405379pfc.7
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 19:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sTd9J0Mofpzl+oG2X+SW83MLoZuiRSEhZEHOgw7I/3I=;
        b=ST57TBsz9pw04T9VbKf5QHG8K1aCns7OBHOvjARrJKjxwAHrXUTGMvXAiH5UpGdqOe
         cd5uUJdoctY6tWk1GFdmtViuAe1md8Qq4kwYSkIvXY/4WW8VDainKHUaiRtJr5i6GTUn
         n/boeKOnFlk+BdNpPNANmyDq3gAOqRdoERhtM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sTd9J0Mofpzl+oG2X+SW83MLoZuiRSEhZEHOgw7I/3I=;
        b=g5HcuN1JWHfkGwk89sUCJZs8rGni133JCpt+UQRkIeYmOo7+3h1Q3xx/kdf8LkVWWc
         B0sngL+MX9t+rdQAgRLSMmtyc0zt17Fy7SzMZSY9BgOWEfqPgCsoSFUNPEcQdTAMOY3a
         bIib89lsDOTa0ibCjD3aBmD84ttbwbX5Mcyy3idOISCUxr7S0Q53YjIdABOKNiV0Evl7
         JUUSW4RZL9VzPqQ3VPCXl4/DcWoCDPrag/kPzs5jAiy9EUZEtjLRUv2wZKNuMP4qQGgT
         H5qXwhvgfkMD0eK9phMGTZLT8w76GdgNEy7cW1dIvYyGFTWiJWb4X8XKnmkTZU7EJcru
         fRUg==
X-Gm-Message-State: APjAAAWiG+9/Q4y/QqikfMKsycrzjekG1wVJdW5hmepJTeDAteOWQjNO
        CjJzQi5J8FU3wJAIj/Yzy4WfiQ==
X-Google-Smtp-Source: APXvYqzOlil3WYLlagwENz+VffhsSMmIRs0OLGulXO240AkSJGdOV0EvSg9Bcxp3UHcpGIJZyU2Frg==
X-Received: by 2002:aa7:90d0:: with SMTP id k16mr27419181pfk.131.1574566297528;
        Sat, 23 Nov 2019 19:31:37 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v63sm3111901pfb.181.2019.11.23.19.31.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 19:31:37 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 12/13] bnxt_en: Allow PHY settings on multi-function or NPAR PFs if allowed by FW.
Date:   Sat, 23 Nov 2019 22:30:49 -0500
Message-Id: <1574566250-7546-13-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
References: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the driver does not allow PHY settings on a multi-function or
NPAR NIC whose port is shared by more than one function.  Newer
firmware now allows PHY settings on some of these NICs.  Check for
this new firmware setting and allow the user to set the PHY settings
accordingly.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 6 +++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 3 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 8 ++++----
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4b0303a..85983f0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8456,6 +8456,10 @@ static int bnxt_hwrm_phy_qcaps(struct bnxt *bp)
 		if (bp->test_info)
 			bp->test_info->flags |= BNXT_TEST_FL_AN_PHY_LPBK;
 	}
+	if (resp->flags & PORT_PHY_QCAPS_RESP_FLAGS_SHARED_PHY_CFG_SUPPORTED) {
+		if (BNXT_PF(bp))
+			bp->fw_cap |= BNXT_FW_CAP_SHARED_PORT_CFG;
+	}
 	if (resp->supported_speeds_auto_mode)
 		link_info->support_auto_speeds =
 			le16_to_cpu(resp->supported_speeds_auto_mode);
@@ -8570,7 +8574,7 @@ static int bnxt_update_link(struct bnxt *bp, bool chng_link_state)
 	}
 	mutex_unlock(&bp->hwrm_cmd_lock);
 
-	if (!BNXT_SINGLE_PF(bp))
+	if (!BNXT_PHY_CFG_ABLE(bp))
 		return 0;
 
 	diff = link_info->support_auto_speeds ^ link_info->advertising;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index cab1703..505af5c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1548,6 +1548,8 @@ struct bnxt {
 #define BNXT_NPAR(bp)		((bp)->port_partition_type)
 #define BNXT_MH(bp)		((bp)->flags & BNXT_FLAG_MULTI_HOST)
 #define BNXT_SINGLE_PF(bp)	(BNXT_PF(bp) && !BNXT_NPAR(bp) && !BNXT_MH(bp))
+#define BNXT_PHY_CFG_ABLE(bp)	(BNXT_SINGLE_PF(bp) ||			\
+				 ((bp)->fw_cap & BNXT_FW_CAP_SHARED_PORT_CFG))
 #define BNXT_CHIP_TYPE_NITRO_A0(bp) ((bp)->flags & BNXT_FLAG_CHIP_NITRO_A0)
 #define BNXT_RX_PAGE_MODE(bp)	((bp)->flags & BNXT_FLAG_RX_PAGE_MODE)
 #define BNXT_SUPPORTS_TPA(bp)	(!BNXT_CHIP_TYPE_NITRO_A0(bp) &&	\
@@ -1682,6 +1684,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_EXT_STATS_SUPPORTED		0x00040000
 	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		0x00100000
 	#define BNXT_FW_CAP_HOT_RESET			0x00200000
+	#define BNXT_FW_CAP_SHARED_PORT_CFG		0x00400000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
 	u32			hwrm_spec_code;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 62ef847..e455aaa 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1590,7 +1590,7 @@ static int bnxt_set_link_ksettings(struct net_device *dev,
 	u32 speed;
 	int rc = 0;
 
-	if (!BNXT_SINGLE_PF(bp))
+	if (!BNXT_PHY_CFG_ABLE(bp))
 		return -EOPNOTSUPP;
 
 	mutex_lock(&bp->link_lock);
@@ -1662,7 +1662,7 @@ static int bnxt_set_pauseparam(struct net_device *dev,
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_link_info *link_info = &bp->link_info;
 
-	if (!BNXT_SINGLE_PF(bp))
+	if (!BNXT_PHY_CFG_ABLE(bp))
 		return -EOPNOTSUPP;
 
 	if (epause->autoneg) {
@@ -2399,7 +2399,7 @@ static int bnxt_set_eee(struct net_device *dev, struct ethtool_eee *edata)
 		 _bnxt_fw_to_ethtool_adv_spds(link_info->advertising, 0);
 	int rc = 0;
 
-	if (!BNXT_SINGLE_PF(bp))
+	if (!BNXT_PHY_CFG_ABLE(bp))
 		return -EOPNOTSUPP;
 
 	if (!(bp->flags & BNXT_FLAG_EEE_CAP))
@@ -2586,7 +2586,7 @@ static int bnxt_nway_reset(struct net_device *dev)
 	struct bnxt *bp = netdev_priv(dev);
 	struct bnxt_link_info *link_info = &bp->link_info;
 
-	if (!BNXT_SINGLE_PF(bp))
+	if (!BNXT_PHY_CFG_ABLE(bp))
 		return -EOPNOTSUPP;
 
 	if (!(link_info->autoneg & BNXT_AUTONEG_SPEED))
-- 
2.5.1

