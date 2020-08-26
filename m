Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2534C252672
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 07:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgHZFJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 01:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgHZFJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 01:09:15 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E883C061757
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:15 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k20so440279wmi.5
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lOpnUP/X5SAuRQuOVQxnAT/SG03qBwE9UaU5AK0x0Sw=;
        b=cWAmYvwD7wOgu4/ozQ7YIeSEKhAkIy8BcZY+xyfo88aarGWZdYB57RvQqZfnNejsdt
         jilGyfTjQGcax1fKvI/sDyro9AFMNVj78YBnPhlWyfldlNnfa3y8j36gas8Lmo1hFXt+
         yDtLbpq/BaaMj2djVdvDek79A8SP7HqhRiyQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lOpnUP/X5SAuRQuOVQxnAT/SG03qBwE9UaU5AK0x0Sw=;
        b=mVy2e3DY7MGmYdtxegQ4XuLiDgYUIBV5QSBBQ1s0Bi4keKzPVMXfhP0hV0Jg3wDMqg
         XdFefCG1mf13FQsnz8j6NX6UQxh81uExH2HFb2qLtKhur6wV+/xJPJdvujp+KLIAvK/v
         keUOrXA43dB5kWRikL03bg+m0uK3qM2tTyrs7ydzLe513DyN/60OHf4x3tL+PZYfgz4i
         myNjEOWaZBLwS2PSjS58UJ5JqBqVn2judKfzPQxSK6pcqJ9XJlQBmBNBEdC2EpkDZ8BK
         z8qKZyVQZpmAbwTpJsj+AE/q6BSfRZv5XStlvR73ae1Wwkq1Pigl9/kfS6osOVJChdK9
         tLkg==
X-Gm-Message-State: AOAM531AsQWEmPp4oOweiFCFc6ZZFJO2mbS/U4pk1mLIwxeHX3wocB0q
        sCoOIA08Yu2dJuvDiFimvIwVvA==
X-Google-Smtp-Source: ABdhPJyyBpM7sYs57pM8QEKNKykLLte7XdbJONc57G1ZbkyUvzytPMgzXbGnq6oo0iGbDsVsnXhcsA==
X-Received: by 2002:a1c:2dcc:: with SMTP id t195mr4810956wmt.166.1598418553865;
        Tue, 25 Aug 2020 22:09:13 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm2825832wrm.39.2020.08.25.22.09.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2020 22:09:13 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net 7/8] bnxt_en: init RSS table for Minimal-Static VF reservation
Date:   Wed, 26 Aug 2020 01:08:38 -0400
Message-Id: <1598418519-20168-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
References: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

There are no VF rings available during probe when the device is configured
using the Minimal-Static reservation strategy. In this case, the RSS
indirection table can only be initialized later, during bnxt_open_nic().
However, this was not happening because the rings will already have been
reserved via bnxt_init_dflt_ring_mode(), causing bnxt_need_reserve_rings()
to return false in bnxt_reserve_rings() and bypass the RSS table init.

Solve this by pushing the call to bnxt_set_dflt_rss_indir_tbl() into
__bnxt_reserve_rings(), which is common to both paths and is called
whenever ring configuration is changed. After doing this, the RSS table
init that must be called from bnxt_init_one() happens implicitly via
bnxt_set_default_rings(), necessitating doing the allocation earlier in
order to avoid a null pointer dereference.

Fixes: bd3191b5d87d ("bnxt_en: Implement ethtool -X to set indirection table.")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a23ccb0..27df572 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6219,6 +6219,9 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 	if (!tx || !rx || !cp || !grp || !vnic || !stat)
 		return -ENOMEM;
 
+	if (!netif_is_rxfh_configured(bp->dev))
+		bnxt_set_dflt_rss_indir_tbl(bp);
+
 	return rc;
 }
 
@@ -8500,9 +8503,6 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
 			rc = bnxt_init_int_mode(bp);
 		bnxt_ulp_irq_restart(bp, rc);
 	}
-	if (!netif_is_rxfh_configured(bp->dev))
-		bnxt_set_dflt_rss_indir_tbl(bp);
-
 	if (rc) {
 		netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
 		return rc;
@@ -12209,6 +12209,10 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (BNXT_CHIP_P5(bp))
 		bp->flags |= BNXT_FLAG_CHIP_P5;
 
+	rc = bnxt_alloc_rss_indir_tbl(bp);
+	if (rc)
+		goto init_err_pci_clean;
+
 	rc = bnxt_fw_init_one_p2(bp);
 	if (rc)
 		goto init_err_pci_clean;
@@ -12313,11 +12317,6 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
 
-	rc = bnxt_alloc_rss_indir_tbl(bp);
-	if (rc)
-		goto init_err_pci_clean;
-	bnxt_set_dflt_rss_indir_tbl(bp);
-
 	if (BNXT_PF(bp)) {
 		if (!bnxt_pf_wq) {
 			bnxt_pf_wq =
-- 
1.8.3.1

