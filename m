Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29252F0F18
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 10:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbhAKJ1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 04:27:43 -0500
Received: from relay.smtp-ext.broadcom.com ([192.19.232.172]:43058 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728256AbhAKJ1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 04:27:43 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 627D32432B;
        Mon, 11 Jan 2021 01:26:41 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 627D32432B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1610357201;
        bh=/Q4JsZKDXJq6qzvmZKCs5R9+gnvTE0+F5uBKBMF9DYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CyO4yv1t3oHSAxRZY/Zd8FOfQDYoljJhzrICvmloRwxW3yo4s7wh/sskbiQ1ldsy0
         YmdJh88qOUNiS5BefOVgkC2/UzWRBOlyL8iD+OvKDFwAgcPmAISf4z+VZoQfRd/5Um
         GpJXTwGtHY0cSRhjYn6y7Y68Ny5ph5noHkH4KY0g=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 1/2] bnxt_en: Improve stats context resource accounting with RDMA driver loaded.
Date:   Mon, 11 Jan 2021 04:26:39 -0500
Message-Id: <1610357200-30755-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610357200-30755-1-git-send-email-michael.chan@broadcom.com>
References: <1610357200-30755-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function bnxt_get_ulp_stat_ctxs() does not count the stats contexts
used by the RDMA driver correctly when the RDMA driver is freeing the
MSIX vectors.  It assumes that if the RDMA driver is registered, the
additional stats contexts will be needed.  This is not true when the
RDMA driver is about to unregister and frees the MSIX vectors.

This slight error leads to over accouting of the stats contexts needed
after the RDMA driver has unloaded.  This will cause some firmware
warning and error messages in dmesg during subsequent config. changes
or ifdown/ifup.

Fix it by properly accouting for extra stats contexts only if the
RDMA driver is registered and MSIX vectors have been successfully
requested.

Fixes: c027c6b4e91f ("bnxt_en: get rid of num_stat_ctxs variable")
Reviewed-by: Yongping Zhang <yongping.zhang@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 8c8368c2f335..64dbbb04b043 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -222,8 +222,12 @@ int bnxt_get_ulp_msix_base(struct bnxt *bp)
 
 int bnxt_get_ulp_stat_ctxs(struct bnxt *bp)
 {
-	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP))
-		return BNXT_MIN_ROCE_STAT_CTXS;
+	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
+		struct bnxt_en_dev *edev = bp->edev;
+
+		if (edev->ulp_tbl[BNXT_ROCE_ULP].msix_requested)
+			return BNXT_MIN_ROCE_STAT_CTXS;
+	}
 
 	return 0;
 }
-- 
2.18.1

