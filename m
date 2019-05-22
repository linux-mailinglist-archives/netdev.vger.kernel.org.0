Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F0B272C6
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbfEVXNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:13:11 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39645 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbfEVXNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:13:11 -0400
Received: by mail-pl1-f193.google.com with SMTP id g9so1780246plm.6
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lqU0Lq8qSwMBIJn6o3zmSm0gKyQsNYhGPmKNOo7HMJs=;
        b=JCFVZ6sXH2lm8ilUO/wmuHgYQelrfSvpt3OLz/g0i7h9Mq9NKItSa6NOP6H0VUwWzd
         0zi/Ji3GDvVKiyuJa8XFRcU5guLTqh6aIeuz59t9ez49oP3TFpelgUvdlDGPMIdhmg2i
         +ctcv9ZbUkrvz/PdZN5SS1Wi8hM8EAhJ381Cw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lqU0Lq8qSwMBIJn6o3zmSm0gKyQsNYhGPmKNOo7HMJs=;
        b=cX/eEG0qTisNpbYsu2M7C/KNEexKXgJC7nYz0noYtz2s+GDEi3SakqTSDYDYgkIqUj
         jwX2ed6T08asQU1+bycjMmEZW3OyvOQO4fh45i/BGT5rLcUwHMM6+RhA6MCRAabMTmWH
         1ZurH5FM9c56lbKHG4T59vo9yLbag5sFyGQwA/nvfzF1Gwj5h7pvKSB9d+Zou2bVU3LU
         4ztqKbMlvzbQB3yqflltm+QB3pmiLJReutwIdG2LI5IpMYz3G5+0Il1xMq1924WsCEZO
         MPQaR7RPYV53Y9o77VE5TqTdc9YzXGaB4YIXuX12bF3gcNO7+6OMRF4b7SfwnMX1IpsG
         eEQg==
X-Gm-Message-State: APjAAAUOTleCBipuN5qYC/XNtHXn2kfnm2RD5JHkw2useUcNt05zxgSC
        5iYOfo9+x2Fwijo4Fo4ML/l9qoUrUnM=
X-Google-Smtp-Source: APXvYqymQ1ycoLH9cA1YVVmB9QGAD7yeRZgug1sn/6e9c0YpY4iyguDqA81wGgyLtL3o7DIxBKJhcQ==
X-Received: by 2002:a17:902:15c5:: with SMTP id a5mr94296086plh.39.1558566790289;
        Wed, 22 May 2019 16:13:10 -0700 (PDT)
Received: from localhost.localdomain.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q20sm27750419pgq.66.2019.05.22.16.13.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 16:13:09 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 2/4] bnxt_en: Fix possible BUG() condition when calling pci_disable_msix().
Date:   Wed, 22 May 2019 19:12:55 -0400
Message-Id: <1558566777-23429-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1558566777-23429-1-git-send-email-michael.chan@broadcom.com>
References: <1558566777-23429-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When making configuration changes, the driver calls bnxt_close_nic()
and then bnxt_open_nic() for the changes to take effect.  A parameter
irq_re_init is passed to the call sequence to indicate if IRQ
should be re-initialized.  This irq_re_init parameter needs to
be included in the bnxt_reserve_rings() call.  bnxt_reserve_rings()
can only call pci_disable_msix() if the irq_re_init parameter is
true, otherwise it may hit BUG() because some IRQs may not have been
freed yet.

Fixes: 41e8d7983752 ("bnxt_en: Modify the ring reservation functions for 57500 series chips.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 13 +++++++------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c     |  2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 21f6826..cfcc33c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7618,22 +7618,23 @@ static void bnxt_clear_int_mode(struct bnxt *bp)
 	bp->flags &= ~BNXT_FLAG_USING_MSIX;
 }
 
-int bnxt_reserve_rings(struct bnxt *bp)
+int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
 {
 	int tcs = netdev_get_num_tc(bp->dev);
-	bool reinit_irq = false;
+	bool irq_cleared = false;
 	int rc;
 
 	if (!bnxt_need_reserve_rings(bp))
 		return 0;
 
-	if (BNXT_NEW_RM(bp) && (bnxt_get_num_msix(bp) != bp->total_irqs)) {
+	if (irq_re_init && BNXT_NEW_RM(bp) &&
+	    bnxt_get_num_msix(bp) != bp->total_irqs) {
 		bnxt_ulp_irq_stop(bp);
 		bnxt_clear_int_mode(bp);
-		reinit_irq = true;
+		irq_cleared = true;
 	}
 	rc = __bnxt_reserve_rings(bp);
-	if (reinit_irq) {
+	if (irq_cleared) {
 		if (!rc)
 			rc = bnxt_init_int_mode(bp);
 		bnxt_ulp_irq_restart(bp, rc);
@@ -8532,7 +8533,7 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 			return rc;
 		}
 	}
-	rc = bnxt_reserve_rings(bp);
+	rc = bnxt_reserve_rings(bp, irq_re_init);
 	if (rc)
 		return rc;
 	if ((bp->flags & BNXT_FLAG_RFS) &&
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index eca36dd..acc73f3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1790,7 +1790,7 @@ unsigned int bnxt_get_avail_stat_ctxs_for_en(struct bnxt *bp);
 unsigned int bnxt_get_max_func_cp_rings(struct bnxt *bp);
 unsigned int bnxt_get_avail_cp_rings_for_en(struct bnxt *bp);
 int bnxt_get_avail_msix(struct bnxt *bp, int num);
-int bnxt_reserve_rings(struct bnxt *bp);
+int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init);
 void bnxt_tx_disable(struct bnxt *bp);
 void bnxt_tx_enable(struct bnxt *bp);
 int bnxt_hwrm_set_pause(struct bnxt *);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index b126382..a6c7baf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -831,7 +831,7 @@ static int bnxt_set_channels(struct net_device *dev,
 			 */
 		}
 	} else {
-		rc = bnxt_reserve_rings(bp);
+		rc = bnxt_reserve_rings(bp, true);
 	}
 
 	return rc;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index cf47587..bfa342a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -147,7 +147,7 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 			bnxt_close_nic(bp, true, false);
 			rc = bnxt_open_nic(bp, true, false);
 		} else {
-			rc = bnxt_reserve_rings(bp);
+			rc = bnxt_reserve_rings(bp, true);
 		}
 	}
 	if (rc) {
-- 
2.5.1

