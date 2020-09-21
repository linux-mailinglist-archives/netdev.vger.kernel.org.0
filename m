Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656922718EA
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 03:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgIUBJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 21:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIUBJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 21:09:23 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F14FC061755
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:23 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q4so6525225pjh.5
        for <netdev@vger.kernel.org>; Sun, 20 Sep 2020 18:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dG4py2OHEa41IiKv1KBn0YcBAe3i40dLXOKhJsyDDj0=;
        b=XWUjk/Ku/XutCaE0u1+cLuzjGQvGNN3CY84ge+mh6uP1ofjFiJu+g/YhZvn/ZLpQg5
         kkkVLP/iEk+1C+UkMeIEfyzKg4QitRGMzuXBpXW86r95tK6ILtQF9P6ql8vQD9RYLJsI
         aMKkPsiYuMMsVMmq5RsqQ9lVKG/OiLM8vE038=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dG4py2OHEa41IiKv1KBn0YcBAe3i40dLXOKhJsyDDj0=;
        b=JIEgVHxTHrAQ/SkYNWcyuSMk7DGJqkDHhkkDGEC8i3TeW3EpHL/NDKAXZ9Aqfo6HMf
         dMFLZO+pFrzpjDg2ji0F47x29Lf97/iJGMpgc0drBSvLN1Fm9pYDz92WRr/jE7drjARr
         JACi4LTq7H/5Rig1X6BFlODDrYjpif7O4+6DwEvJX94inUfLMafNsCA1ByIdzGorRelH
         dwXAhsmNaoTek5hw1IZm6SsxLzbi83KFuoxoGPN9O2ogq7JIblSeSiox7InMiNSFGKYs
         AxOtBSjxGzdNVOL+GwJ2aDTfm+/pdyETR5t0LRe6z31YgYJz9FLnVZ8N6Y5Sb/orshRW
         MdMg==
X-Gm-Message-State: AOAM530pPxh0lhwOMvD5ilu0TzIZl3xhNd4CR1ZbHRfjh59iDQ2htvjC
        dRlWsrFsh6kHwtmNWmLSm+DRw1TADyRCVg==
X-Google-Smtp-Source: ABdhPJxzn4Unszi2dH09mJFb8hgjvNW8qmJjswrFON+p09H9EfwrOCxgyms7KK6T++1ciKzn2Owzpw==
X-Received: by 2002:a17:90a:d70b:: with SMTP id y11mr22095114pju.15.1600650562512;
        Sun, 20 Sep 2020 18:09:22 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bt13sm9098095pjb.23.2020.09.20.18.09.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 18:09:21 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/6] bnxt_en: Protect bnxt_set_eee() and bnxt_set_pauseparam() with mutex.
Date:   Sun, 20 Sep 2020 21:08:56 -0400
Message-Id: <1600650539-19967-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
References: <1600650539-19967-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All changes related to bp->link_info require the protection of the
link_lock mutex.  It's not sufficient to rely just on RTNL.

Fixes: 163e9ef63641 ("bnxt_en: Fix race when modifying pause settings.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 31 +++++++++++++++--------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index d092833..6c75101 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1788,9 +1788,12 @@ static int bnxt_set_pauseparam(struct net_device *dev,
 	if (!BNXT_PHY_CFG_ABLE(bp))
 		return -EOPNOTSUPP;
 
+	mutex_lock(&bp->link_lock);
 	if (epause->autoneg) {
-		if (!(link_info->autoneg & BNXT_AUTONEG_SPEED))
-			return -EINVAL;
+		if (!(link_info->autoneg & BNXT_AUTONEG_SPEED)) {
+			rc = -EINVAL;
+			goto pause_exit;
+		}
 
 		link_info->autoneg |= BNXT_AUTONEG_FLOW_CTRL;
 		if (bp->hwrm_spec_code >= 0x10201)
@@ -1811,11 +1814,11 @@ static int bnxt_set_pauseparam(struct net_device *dev,
 	if (epause->tx_pause)
 		link_info->req_flow_ctrl |= BNXT_LINK_PAUSE_TX;
 
-	if (netif_running(dev)) {
-		mutex_lock(&bp->link_lock);
+	if (netif_running(dev))
 		rc = bnxt_hwrm_set_pause(bp);
-		mutex_unlock(&bp->link_lock);
-	}
+
+pause_exit:
+	mutex_unlock(&bp->link_lock);
 	return rc;
 }
 
@@ -2552,8 +2555,7 @@ static int bnxt_set_eee(struct net_device *dev, struct ethtool_eee *edata)
 	struct bnxt *bp = netdev_priv(dev);
 	struct ethtool_eee *eee = &bp->eee;
 	struct bnxt_link_info *link_info = &bp->link_info;
-	u32 advertising =
-		 _bnxt_fw_to_ethtool_adv_spds(link_info->advertising, 0);
+	u32 advertising;
 	int rc = 0;
 
 	if (!BNXT_PHY_CFG_ABLE(bp))
@@ -2562,19 +2564,23 @@ static int bnxt_set_eee(struct net_device *dev, struct ethtool_eee *edata)
 	if (!(bp->flags & BNXT_FLAG_EEE_CAP))
 		return -EOPNOTSUPP;
 
+	mutex_lock(&bp->link_lock);
+	advertising = _bnxt_fw_to_ethtool_adv_spds(link_info->advertising, 0);
 	if (!edata->eee_enabled)
 		goto eee_ok;
 
 	if (!(link_info->autoneg & BNXT_AUTONEG_SPEED)) {
 		netdev_warn(dev, "EEE requires autoneg\n");
-		return -EINVAL;
+		rc = -EINVAL;
+		goto eee_exit;
 	}
 	if (edata->tx_lpi_enabled) {
 		if (bp->lpi_tmr_hi && (edata->tx_lpi_timer > bp->lpi_tmr_hi ||
 				       edata->tx_lpi_timer < bp->lpi_tmr_lo)) {
 			netdev_warn(dev, "Valid LPI timer range is %d and %d microsecs\n",
 				    bp->lpi_tmr_lo, bp->lpi_tmr_hi);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto eee_exit;
 		} else if (!bp->lpi_tmr_hi) {
 			edata->tx_lpi_timer = eee->tx_lpi_timer;
 		}
@@ -2584,7 +2590,8 @@ static int bnxt_set_eee(struct net_device *dev, struct ethtool_eee *edata)
 	} else if (edata->advertised & ~advertising) {
 		netdev_warn(dev, "EEE advertised %x must be a subset of autoneg advertised speeds %x\n",
 			    edata->advertised, advertising);
-		return -EINVAL;
+		rc = -EINVAL;
+		goto eee_exit;
 	}
 
 	eee->advertised = edata->advertised;
@@ -2596,6 +2603,8 @@ static int bnxt_set_eee(struct net_device *dev, struct ethtool_eee *edata)
 	if (netif_running(dev))
 		rc = bnxt_hwrm_set_link_setting(bp, false, true);
 
+eee_exit:
+	mutex_unlock(&bp->link_lock);
 	return rc;
 }
 
-- 
1.8.3.1

