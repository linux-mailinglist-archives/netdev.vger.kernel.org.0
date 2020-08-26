Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45900252673
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 07:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgHZFJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 01:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgHZFJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 01:09:18 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458FBC061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:17 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w2so223241wmi.1
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 22:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wzDaPWxtiI9zNrXoev1hqDUVDRIpByk1Sla/KGRwSQ4=;
        b=Zui/ts+LAL6/9iXs/LOTMMoDpHKI2lyIUqdJMNzh72Cr8xIE569R9y1+3KAxmXCvmY
         vgnYZ8yuQyjJr75JzRQwSkWqC1klYZYnA6eLwFA+hSy079IrtrpjxJZJyCK1AlT++w4z
         GFdwxIIijV2eyQVxS0QHJdU+CWxipB+KiVoSs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wzDaPWxtiI9zNrXoev1hqDUVDRIpByk1Sla/KGRwSQ4=;
        b=sgX3TXFhhFWiOTNCVXA3jiF75QQIWLBPCXx1NCIaykoi2QY83Xv879G47V/xM83SmK
         3E0ASyFw6i9zfwtTD/qud7SSJ19mXg+QTL5r+h5IIwfsyoj8bT/lZBByDGJypGtrPrwX
         lS9WFkkHQLE77ydS2nZvcOXPv17xz6M8ixL5TTn8z5fsXkBWLLcixVe4Oy8nCrJgEUyu
         jnlfOYk6UZvSOSXkmKAfEERrJ6wUk+5aIxUHvKMcCl1Db+B5/sc25VVHAHQxMTpAvlCA
         ayQ8AV+kjzU/NEpGw6q0ALmKybQzwI4x821ivmSOdjRwLRm7lnGurQtCW1A8dOrVLz6C
         w8bg==
X-Gm-Message-State: AOAM533nx0o6yaNWGKAVr3WGR0fKxZmpULLJf2C0FJEV0S/NRo3qJSad
        T/+AcMhXhZjA8rVzeRxHvIIboa6cgRQglQ==
X-Google-Smtp-Source: ABdhPJwRokpXycfh4kdy6Mf9N72DiMUpHmW7DQZaYZ6t8WXVyRUpPk7ZGu/XMokox1Yf/poo4tTJDg==
X-Received: by 2002:a7b:c8d3:: with SMTP id f19mr4882738wml.163.1598418555729;
        Tue, 25 Aug 2020 22:09:15 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm2825832wrm.39.2020.08.25.22.09.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2020 22:09:15 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 8/8] bnxt_en: Setup default RSS map in all scenarios.
Date:   Wed, 26 Aug 2020 01:08:39 -0400
Message-Id: <1598418519-20168-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
References: <1598418519-20168-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent changes to support user-defined RSS map assume that RX
rings are always reserved and the default RSS map is set after the
RX rings are successfully reserved.  If the firmware spec is older
than 1.6.1, no ring reservations are required and the default RSS
map is not setup at all.  In another scenario where the fw Resource
Manager is older, RX rings are not reserved and we also end up with
no valid RSS map.

Fix both issues in bnxt_need_reserve_rings().  In both scenarios
described above, we don't need to reserve RX rings so we need to
call this new function bnxt_check_rss_map_no_rmgr() to setup the
default RSS map when needed.

Without valid RSS map, the NIC won't receive packets properly.

Fixes: 1667cbf6a4eb ("bnxt_en: Add logical RSS indirection table structure.")
Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 39 ++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 27df572..3162271 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6107,6 +6107,21 @@ static int bnxt_get_func_stat_ctxs(struct bnxt *bp)
 	return cp + ulp_stat;
 }
 
+/* Check if a default RSS map needs to be setup.  This function is only
+ * used on older firmware that does not require reserving RX rings.
+ */
+static void bnxt_check_rss_tbl_no_rmgr(struct bnxt *bp)
+{
+	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
+
+	/* The RSS map is valid for RX rings set to resv_rx_rings */
+	if (hw_resc->resv_rx_rings != bp->rx_nr_rings) {
+		hw_resc->resv_rx_rings = bp->rx_nr_rings;
+		if (!netif_is_rxfh_configured(bp->dev))
+			bnxt_set_dflt_rss_indir_tbl(bp);
+	}
+}
+
 static bool bnxt_need_reserve_rings(struct bnxt *bp)
 {
 	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
@@ -6115,22 +6130,28 @@ static bool bnxt_need_reserve_rings(struct bnxt *bp)
 	int rx = bp->rx_nr_rings, stat;
 	int vnic = 1, grp = rx;
 
-	if (bp->hwrm_spec_code < 0x10601)
-		return false;
-
-	if (hw_resc->resv_tx_rings != bp->tx_nr_rings)
+	if (hw_resc->resv_tx_rings != bp->tx_nr_rings &&
+	    bp->hwrm_spec_code >= 0x10601)
 		return true;
 
+	/* Old firmware does not need RX ring reservations but we still
+	 * need to setup a default RSS map when needed.  With new firmware
+	 * we go through RX ring reservations first and then set up the
+	 * RSS map for the successfully reserved RX rings when needed.
+	 */
+	if (!BNXT_NEW_RM(bp)) {
+		bnxt_check_rss_tbl_no_rmgr(bp);
+		return false;
+	}
 	if ((bp->flags & BNXT_FLAG_RFS) && !(bp->flags & BNXT_FLAG_CHIP_P5))
 		vnic = rx + 1;
 	if (bp->flags & BNXT_FLAG_AGG_RINGS)
 		rx <<= 1;
 	stat = bnxt_get_func_stat_ctxs(bp);
-	if (BNXT_NEW_RM(bp) &&
-	    (hw_resc->resv_rx_rings != rx || hw_resc->resv_cp_rings != cp ||
-	     hw_resc->resv_vnics != vnic || hw_resc->resv_stat_ctxs != stat ||
-	     (hw_resc->resv_hw_ring_grps != grp &&
-	      !(bp->flags & BNXT_FLAG_CHIP_P5))))
+	if (hw_resc->resv_rx_rings != rx || hw_resc->resv_cp_rings != cp ||
+	    hw_resc->resv_vnics != vnic || hw_resc->resv_stat_ctxs != stat ||
+	    (hw_resc->resv_hw_ring_grps != grp &&
+	     !(bp->flags & BNXT_FLAG_CHIP_P5)))
 		return true;
 	if ((bp->flags & BNXT_FLAG_CHIP_P5) && BNXT_PF(bp) &&
 	    hw_resc->resv_irqs != nq)
-- 
1.8.3.1

