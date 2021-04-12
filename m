Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E2C35B7B8
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbhDLASf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:18:35 -0400
Received: from saphodev.broadcom.com ([192.19.232.172]:60284 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235866AbhDLASf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 20:18:35 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 44D887DAF;
        Sun, 11 Apr 2021 17:18:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 44D887DAF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1618186697;
        bh=s4qJ66pPaeZiEn2EaMIHTrg8mnXhXRy1hcZa7XDj3EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n3AdMIk3LI8421aYWn8UE38KMs/6qeTwiRjxQ/g2KT+iNQpSGot/4G2hkqvSB9jk1
         A1recfF0N8jOQQ3ywSAgTUVlYYm4+HyrApANp/Sa4fjhQoMSFL4Fnx/boGpemHUg+V
         EpDGguMJpbreVZi8VkVWM+8tDU1V4Jt950b7Ypiw=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 2/5] bnxt_en: Invalidate health register mapping at the end of probe.
Date:   Sun, 11 Apr 2021 20:18:12 -0400
Message-Id: <1618186695-18823-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
References: <1618186695-18823-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

After probe is successful, interface may not be bought up in all
the cases and health register mapping could be invalid if firmware
undergoes reset. Fix it by invalidating the health register at the
end of probe. It will be remapped during ifup.

Fixes: 43a440c4007b ("bnxt_en: Improve the status_reliable flag in bp->fw_health.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 3d36f945baf8..3f5fbdf61257 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12972,6 +12972,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				   rc);
 	}
 
+	bnxt_inv_fw_health_reg(bp);
 	bnxt_dl_register(bp);
 
 	rc = register_netdev(dev);
-- 
2.18.1

