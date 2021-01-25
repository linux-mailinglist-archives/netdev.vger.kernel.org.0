Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA633302289
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbhAYHpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:45:06 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33580 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727216AbhAYHUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 02:20:40 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id D9D9380C1;
        Sun, 24 Jan 2021 23:08:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com D9D9380C1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1611558502;
        bh=AtLO5xsrBcLlSxnk4j7JFiXKgOIiHHF5ZQ9OeJdjP0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tcKHRDa5WX5wuahoAHxpvD2TcUqNfWJaYCvBJpF3qjQvLXm6PFUc0dWlho3zAcaQq
         fvmGyyyUnRhk/2Rt+7o7EDdFI6v43LFHivl5XetEwyqbmchDQpf2Ad3p9tR++SsnnG
         R7PH0UNbsfMpRWx69Vo2vWguJ+VcGApJlgO62UQQ=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 05/15] bnxt_en: Move reading VPD info after successful handshake with fw.
Date:   Mon, 25 Jan 2021 02:08:11 -0500
Message-Id: <1611558501-11022-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
References: <1611558501-11022-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

If firmware is in reset or in bad state, it won't be able to return
VPD data.  Move bnxt_vpd_read_info() until after bnxt_fw_init_one_p1()
successfully returns.  By then we would have established proper
communications with the firmware.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c460dd796c1c..2fb9873e0162 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12584,9 +12584,6 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->ethtool_ops = &bnxt_ethtool_ops;
 	pci_set_drvdata(pdev, dev);
 
-	if (BNXT_PF(bp))
-		bnxt_vpd_read_info(bp);
-
 	rc = bnxt_alloc_hwrm_resources(bp);
 	if (rc)
 		goto init_err_pci_clean;
@@ -12598,6 +12595,9 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		goto init_err_pci_clean;
 
+	if (BNXT_PF(bp))
+		bnxt_vpd_read_info(bp);
+
 	if (BNXT_CHIP_P5(bp)) {
 		bp->flags |= BNXT_FLAG_CHIP_P5;
 		if (BNXT_CHIP_SR2(bp))
-- 
2.18.1

