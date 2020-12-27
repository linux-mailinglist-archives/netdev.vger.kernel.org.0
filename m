Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434722E328A
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 20:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgL0TTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 14:19:12 -0500
Received: from saphodev.broadcom.com ([192.19.232.172]:39826 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbgL0TTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 14:19:11 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id CC3BDEB;
        Sun, 27 Dec 2020 11:18:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com CC3BDEB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1609096700;
        bh=AsAapkoc8CHQsbsevbFOJXBeAm892RaFM89HApT8E0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jtuLAzDokLrtN92fyXnmxJEtSqCTZySKNshkhHcDb1l+Zw0YA6gtZjv87mZjSEInw
         p/PtZqMFQisnT7DCLwNUTPMHSXKtCmR1hE27Odiz172CvKqZ+r7WuoxU/YZBXAZ082
         nrN9rZnvuicNlvjHL7wVO9/kf7TRFGcYneHHNuJI=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 1/2] bnxt_en: Fix AER recovery.
Date:   Sun, 27 Dec 2020 14:18:17 -0500
Message-Id: <1609096698-15009-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1609096698-15009-1-git-send-email-michael.chan@broadcom.com>
References: <1609096698-15009-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

A recent change skips sending firmware messages to the firmware when
pci_channel_offline() is true during fatal AER error.  To make this
complete, we need to move the re-initialization sequence to
bnxt_io_resume(), otherwise the firmware messages to re-initialize
will all be skipped.  In any case, it is more correct to re-initialize
in bnxt_io_resume().

Also, fix the reverse x-mas tree format when defining variables
in bnxt_io_slot_reset().

Fixes: b340dc680ed4 ("bnxt_en: Avoid sending firmware messages when AER error is detected.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 31 ++++++++++-------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4edd6f8e017e..b8351e24395d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12887,10 +12887,10 @@ static pci_ers_result_t bnxt_io_error_detected(struct pci_dev *pdev,
  */
 static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 {
+	pci_ers_result_t result = PCI_ERS_RESULT_DISCONNECT;
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct bnxt *bp = netdev_priv(netdev);
 	int err = 0, off;
-	pci_ers_result_t result = PCI_ERS_RESULT_DISCONNECT;
 
 	netdev_info(bp->dev, "PCI Slot Reset\n");
 
@@ -12919,22 +12919,8 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 		pci_save_state(pdev);
 
 		err = bnxt_hwrm_func_reset(bp);
-		if (!err) {
-			err = bnxt_hwrm_func_qcaps(bp);
-			if (!err && netif_running(netdev))
-				err = bnxt_open(netdev);
-		}
-		bnxt_ulp_start(bp, err);
-		if (!err) {
-			bnxt_reenable_sriov(bp);
+		if (!err)
 			result = PCI_ERS_RESULT_RECOVERED;
-		}
-	}
-
-	if (result != PCI_ERS_RESULT_RECOVERED) {
-		if (netif_running(netdev))
-			dev_close(netdev);
-		pci_disable_device(pdev);
 	}
 
 	rtnl_unlock();
@@ -12952,10 +12938,21 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 static void bnxt_io_resume(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct bnxt *bp = netdev_priv(netdev);
+	int err;
 
+	netdev_info(bp->dev, "PCI Slot Resume\n");
 	rtnl_lock();
 
-	netif_device_attach(netdev);
+	err = bnxt_hwrm_func_qcaps(bp);
+	if (!err && netif_running(netdev))
+		err = bnxt_open(netdev);
+
+	bnxt_ulp_start(bp, err);
+	if (!err) {
+		bnxt_reenable_sriov(bp);
+		netif_device_attach(netdev);
+	}
 
 	rtnl_unlock();
 }
-- 
2.18.1

