Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAFC3949BC
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 02:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhE2AzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 20:55:09 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.11.229]:39932 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhE2AzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 20:55:07 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 0FFF87DA6;
        Fri, 28 May 2021 17:53:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 0FFF87DA6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1622249608;
        bh=K5pU7baCOVSYdrXyr7PSRr5+P4a08oOmr99zb96nMLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WnTl+kdSay3Vj9O8GXVUrg9cofUouVrQe/ibxGA6KJok8uC8kSncXzv/GoYVUI53S
         AOcVRlqhtXcFtAUbxTojQB+wmk1n6MTWEJfFEtkvklbf3v6Nas1+5F4qGSTetCKtmz
         j4bCXJtqc4vYzhJC9E5OKogb5eg0JxNilFqbO6XU=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next 7/7] bnxt_en: Enable hardware PTP support.
Date:   Fri, 28 May 2021 20:53:21 -0400
Message-Id: <1622249601-7106-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call bnxt_ptp_init() to initialize and register with the clock driver
to enable PTP support.  Call bnxt_ptp_free() to unregister and clean
up during shutdown.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 00dbc2d6c33b..52e5413986a7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12648,6 +12648,8 @@ static void bnxt_remove_one(struct pci_dev *pdev)
 
 	if (BNXT_PF(bp))
 		devlink_port_type_clear(&bp->dl_port);
+
+	bnxt_ptp_clear(bp);
 	pci_disable_pcie_error_reporting(pdev);
 	unregister_netdev(dev);
 	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
@@ -13231,6 +13233,11 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				   rc);
 	}
 
+	if (bnxt_ptp_init(bp)) {
+		netdev_warn(dev, "PTP initialization failed.\n");
+		kfree(bp->ptp_cfg);
+		bp->ptp_cfg = NULL;
+	}
 	bnxt_inv_fw_health_reg(bp);
 	bnxt_dl_register(bp);
 
-- 
2.18.1

