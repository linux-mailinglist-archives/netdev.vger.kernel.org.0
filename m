Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8BD314A142
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 10:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgA0J5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 04:57:00 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40104 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgA0J47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 04:56:59 -0500
Received: by mail-pf1-f195.google.com with SMTP id q8so4673776pfh.7
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 01:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=swMX3ZhvJus2lpAmQSbywZz47exFvO5e1kSg0QE7pdo=;
        b=ORqb2V7RnryP0HZHr934L9LVatO+kZ4uQyKjcaREkDrbkxkzP1yqEEDZe8I7k8R/kT
         iDGzr8cNkLPDKIYhY5Im/uRYKWpsYOKufWMPtRmgojes8nSiqmJ5Ncq1osD6rva88Klc
         En3msIdsJiOzFGNAtmqGBgGu3+Lv4R5oRoyg4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=swMX3ZhvJus2lpAmQSbywZz47exFvO5e1kSg0QE7pdo=;
        b=F/B+xBwinM2FFrY3ZFBrSjGdtA6jXwiNd3K7jY8yLNeiX/NC6D77WAdNMrZCbVI7G4
         bpqOvpx+MSNt7BtIFOoUzawHl1IFrKmGDPzaJQgXeO7T3mXuZJBJ9TVXxScdLJg4lOF6
         CRc4eZaqyRUi/7Yo5RojQ10CzIPae/7Oh/m761QN6HrPUT0g0N22Fq7HNN4sIrmw5aOy
         E19OFIqtC8rcfYuunQUbGo7UNi7OVjgQv+UIwk10dcgtI/ZLlZRBz3LClq+tQI5LZgko
         kMvjQ4K87X+hG2f/VGsoI575AesNqb4Xmuz6xuc5Gimie000xChjCn8JS2PrrQMA4QD3
         8LUQ==
X-Gm-Message-State: APjAAAX5OInYnNjZd2WcSCn0mGx9pECwMcNKXIKKjztQ5B/cMJF3UbjP
        v6ie8L1ERNWYgqHmBEjOXs9JmSW/RBw=
X-Google-Smtp-Source: APXvYqydG5hL2D/tGWEXXxogLb31z31BmQ/YM7Auw3TerSxlCxbvilvv9mXCWSLJ0NQwmZ6Fo8dqtQ==
X-Received: by 2002:a65:6706:: with SMTP id u6mr17830477pgf.38.1580119019107;
        Mon, 27 Jan 2020 01:56:59 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r3sm15232594pfg.145.2020.01.27.01.56.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2020 01:56:58 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 01/15] bnxt_en: Improve link up detection.
Date:   Mon, 27 Jan 2020 04:56:13 -0500
Message-Id: <1580118987-30052-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
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

