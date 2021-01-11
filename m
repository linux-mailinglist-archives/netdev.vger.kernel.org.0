Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841302F0F11
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 10:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbhAKJ1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 04:27:33 -0500
Received: from saphodev.broadcom.com ([192.19.232.172]:43062 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728359AbhAKJ1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 04:27:33 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 07D984E1A9;
        Mon, 11 Jan 2021 01:26:41 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 07D984E1A9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1610357202;
        bh=H5c51j5MQkivlgHauPLLpfJGdNoSXhcEJ2QgH+LbEB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhMenkX1zTH+ylH5EElMhjiB4Gu2+4od2sLOW6A3M00z5YkWHxs81lMV778velOf+
         w9yaKVg+JklFzuKHz/jAOMkBWHvfKkKkCO0tJjy5CE2n4eMS4AAbEMdH/qAR1hRjpH
         ecHGHKiJjMCKUYcB1qTgjzxQJhypG3WjKuyA0GNw=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 2/2] bnxt_en: Clear DEFRAG flag in firmware message when retry flashing.
Date:   Mon, 11 Jan 2021 04:26:40 -0500
Message-Id: <1610357200-30755-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610357200-30755-1-git-send-email-michael.chan@broadcom.com>
References: <1610357200-30755-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

When the FW tells the driver to retry the INSTALL_UPDATE command after
it has cleared the NVM area, the driver is not clearing the previously
used ALLOWED_TO_DEFRAG flag. As a result the FW tries to defrag the NVM
area a second time in a loop and can fail the request.

Fixes: 1432c3f6a6ca ("bnxt_en: Retry installing FW package under NO_SPACE error condition.")
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 9ff79d5d14c4..2f8b193a772d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2532,7 +2532,7 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 
 		if (rc && ((struct hwrm_err_output *)&resp)->cmd_err ==
 		    NVM_INSTALL_UPDATE_CMD_ERR_CODE_FRAG_ERR) {
-			install.flags |=
+			install.flags =
 				cpu_to_le16(NVM_INSTALL_UPDATE_REQ_FLAGS_ALLOWED_TO_DEFRAG);
 
 			rc = _hwrm_send_message_silent(bp, &install,
@@ -2546,6 +2546,7 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 				 * UPDATE directory and try the flash again
 				 */
 				defrag_attempted = true;
+				install.flags = 0;
 				rc = __bnxt_flash_nvram(bp->dev,
 							BNX_DIR_TYPE_UPDATE,
 							BNX_DIR_ORDINAL_FIRST,
-- 
2.18.1

