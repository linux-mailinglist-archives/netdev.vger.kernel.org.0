Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642DB3185A6
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 08:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhBKHZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 02:25:19 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:47332 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229647AbhBKHZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 02:25:15 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 2D3EF7A48;
        Wed, 10 Feb 2021 23:24:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 2D3EF7A48
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1613028265;
        bh=v321UDrSj+KFvHSOvFhHTflW2wtdU9G+a9rxe8+sTzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCHPUYRr1xYjLlM8pesuJNyWM1/qW30IpFpPxIodIy8D1zMUWH5ZUOyrVwDsUN9Dy
         w5a3v/3KAYDJrBSSNKnJD6XYnLAfG67+7RueczNuR7eMq8TbZ2QzAWBzYJmGA/sX0I
         8DF60UdbLJGRDuVp6wH7VAMmQJkotte+MQdaTUb0=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 2/2] bnxt_en: Fix devlink info's stored fw.psid version format.
Date:   Thu, 11 Feb 2021 02:24:24 -0500
Message-Id: <1613028264-20306-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1613028264-20306-1-git-send-email-michael.chan@broadcom.com>
References: <1613028264-20306-1-git-send-email-michael.chan@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

The running fw.psid version is in decimal format but the stored
fw.psid is in hex format.  This can mislead the user to reset the
NIC to activate the stored version to become the running version.

Fix it to display the stored fw.psid in decimal format.

Fixes: 1388875b3916 ("bnxt_en: Add stored FW version info to devlink info_get cb.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 6b7b69ed62db..a9bcf887d2fb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -472,8 +472,8 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (BNXT_PF(bp) && !bnxt_hwrm_get_nvm_cfg_ver(bp, &nvm_cfg_ver)) {
 		u32 ver = nvm_cfg_ver.vu32;
 
-		sprintf(buf, "%X.%X.%X", (ver >> 16) & 0xF, (ver >> 8) & 0xF,
-			ver & 0xF);
+		sprintf(buf, "%d.%d.%d", (ver >> 16) & 0xf, (ver >> 8) & 0xf,
+			ver & 0xf);
 		rc = bnxt_dl_info_put(bp, req, BNXT_VERSION_STORED,
 				      DEVLINK_INFO_VERSION_GENERIC_FW_PSID,
 				      buf);
-- 
2.18.1

