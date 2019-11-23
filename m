Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D5F107DC1
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfKWI0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:51 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38812 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbfKWI0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:49 -0500
Received: by mail-pj1-f65.google.com with SMTP id f7so4218251pjw.5
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sTd9J0Mofpzl+oG2X+SW83MLoZuiRSEhZEHOgw7I/3I=;
        b=fNJWYdFuRlVSKBgvQ8U3AebP2qu3XrdqXtzUJp3CnWITa/bXZSUUs8B/FWK2RNj4o0
         cUCsZTKWmD7gpQ8R6PyqQQq3ItRv6txZZhLw0p16XAH5/mQpJKXtbVO/vOyyi12EJiJZ
         NVFMd/33tqL0RcZvQcjUP00Y/NUcgJWHaLxKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sTd9J0Mofpzl+oG2X+SW83MLoZuiRSEhZEHOgw7I/3I=;
        b=hQL4mH39LXZSY+gZMyAYYpKAMPDgKqcmBz7uZc8JvBpp220did79H+TmrhZNt6IZ2W
         BVNFZ/OXym+E7U2l1q46A+/UyaHB4Fs2+XMO03NipODCZuYGFJ/ECEjvzOYR68rCIWLu
         oAEAj0BpE+WfHFPmjkL1yQke+tu+h20XjuyL9/gGfUSSLHjHFP2VBeF8y4evAKioPGON
         SY3gZWgBuaUfpyhHNKiKoiMcOAP+oLJ+vRCxd8M7Q5wZHC4pgzIx4S2Qip6en6Ccjre5
         93kMHs5/gWVmnkleDH3sG5wcNAI3u7PI6dwf6Wn+I0Opvq1TElKUByPY+6g0BeoC1kT1
         emlA==
X-Gm-Message-State: APjAAAVZ5yN93Me8RF2NQHSmD7rk2wZ6sJHEGCpGzlm/qtGlXbAIqsiH
        zz6+nIT9TwPh4ex/hBztSYVmWlUXD6g=
X-Google-Smtp-Source: APXvYqxxqPpiMwWnsOtKXm6VmzzEg4/hoT36EtcgR7VtkphETVpBoAk9GvSoEeh67uSm8Zji8FYKoA==
X-Received: by 2002:a17:90a:bf16:: with SMTP id c22mr23730887pjs.83.1574497608684;
        Sat, 23 Nov 2019 00:26:48 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:48 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 12/15] bnxt_en: Allow PHY settings on multi-function or NPAR PFs if allowed by FW.
Date:   Sat, 23 Nov 2019 03:26:07 -0500
Message-Id: <1574497570-22102-13-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
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

