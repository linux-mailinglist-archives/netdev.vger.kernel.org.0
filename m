Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A90241499B0
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgAZJD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:03:29 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:35129 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgAZJD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:03:28 -0500
Received: by mail-pj1-f65.google.com with SMTP id q39so1857236pjc.0
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=swMX3ZhvJus2lpAmQSbywZz47exFvO5e1kSg0QE7pdo=;
        b=Q42pc62yuShvaOj4JrmJO6xIK5FtbVA03dwuvGSJLLsLGtyMDJFcZOKbAz88edczbH
         eGmHDyf3XOnYBtlqZhBCTinaG2druxP6NJBOSEj5WD1pVTVHzHqAjjxwHD52zm90w8UK
         7giEBQYsUVo5RNCpz//ufbYE2sUqmhSdKcF3s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=swMX3ZhvJus2lpAmQSbywZz47exFvO5e1kSg0QE7pdo=;
        b=SXx9G4nQJeCxcCMZo/mqfRTn2nEiuq3o9kK7dLCW0Dd4TnMyTZCAUKpnEZc7EuIUyE
         U2Gahe9rVr4ABr6hmDDGKmG4Gx/CQAhaVAEz0ZGc2F418jZaeadYV44+QWR0OhAi7Gxu
         5TQOI3vH9Vr6NCA30TP3qDX9EDklN7Tln9mFYsil3q+N5qMZeJheVLb254vXqMyRFLcG
         X9uK8ShorH0lvWjDC4ltD0podvgkoMOHmQP/ENIN4xjR6bNCnrFmSd05sZLH++1ncWXo
         7NG4EGj7tYMTzDjoK2NY3+LTw36EsY9wPvSdxwPv1yyxEVSLT6A6/wQY8d44TqCWRTJi
         I3Lg==
X-Gm-Message-State: APjAAAWGzGaf251Ooo8rBGG7k3vvnRNPkSZS6hKnHHyQO8rtn127HaWW
        j0VzLR4LSoccduqmMg9ZPAxrSw==
X-Google-Smtp-Source: APXvYqxmvJd+Kr1HsrM8BZkZgcMGsRM5vMUX84uno+u5h7EMftrYNSMkJePucbCY8Hv/MmqJiORfPQ==
X-Received: by 2002:a17:90a:3502:: with SMTP id q2mr8701185pjb.46.1580029408046;
        Sun, 26 Jan 2020 01:03:28 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i17sm11856315pfr.67.2020.01.26.01.03.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:03:27 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 02/16] bnxt_en: Improve link up detection.
Date:   Sun, 26 Jan 2020 04:02:56 -0500
Message-Id: <1580029390-32760-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In bnxt_update_phy_setting(), ethtool_get_link_ksettings() and
bnxt_disable_an_for_lpbk(), we inconsistently use netif_carrier_ok()
to determine link.  Instead, we should use bp->link_info.link_up
which has the true link state.  The netif_carrier state may be off
during self-test and while the device is being reset and may not always
reflect the true link state.

By always using bp->link_info.link_up, the code is now more
consistent and more correct.  Some unnecessary link toggles are
now prevented with this patch.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 198c69dc..4b6f746 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9064,7 +9064,7 @@ static int bnxt_update_phy_setting(struct bnxt *bp)
 	/* The last close may have shutdown the link, so need to call
 	 * PHY_CFG to bring it back up.
 	 */
-	if (!netif_carrier_ok(bp->dev))
+	if (!bp->link_info.link_up)
 		update_link = true;
 
 	if (!bnxt_eee_config_ok(bp))
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 08d56ec..6171fa8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1462,15 +1462,15 @@ static int bnxt_get_link_ksettings(struct net_device *dev,
 		ethtool_link_ksettings_add_link_mode(lk_ksettings,
 						     advertising, Autoneg);
 		base->autoneg = AUTONEG_ENABLE;
-		if (link_info->phy_link_status == BNXT_LINK_LINK)
+		base->duplex = DUPLEX_UNKNOWN;
+		if (link_info->phy_link_status == BNXT_LINK_LINK) {
 			bnxt_fw_to_ethtool_lp_adv(link_info, lk_ksettings);
+			if (link_info->duplex & BNXT_LINK_DUPLEX_FULL)
+				base->duplex = DUPLEX_FULL;
+			else
+				base->duplex = DUPLEX_HALF;
+		}
 		ethtool_speed = bnxt_fw_to_ethtool_speed(link_info->link_speed);
-		if (!netif_carrier_ok(dev))
-			base->duplex = DUPLEX_UNKNOWN;
-		else if (link_info->duplex & BNXT_LINK_DUPLEX_FULL)
-			base->duplex = DUPLEX_FULL;
-		else
-			base->duplex = DUPLEX_HALF;
 	} else {
 		base->autoneg = AUTONEG_DISABLE;
 		ethtool_speed =
@@ -2707,7 +2707,7 @@ static int bnxt_disable_an_for_lpbk(struct bnxt *bp,
 		return rc;
 
 	fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_1GB;
-	if (netif_carrier_ok(bp->dev))
+	if (bp->link_info.link_up)
 		fw_speed = bp->link_info.link_speed;
 	else if (fw_advertising & BNXT_LINK_SPEED_MSK_10GB)
 		fw_speed = PORT_PHY_CFG_REQ_FORCE_LINK_SPEED_10GB;
-- 
2.5.1

