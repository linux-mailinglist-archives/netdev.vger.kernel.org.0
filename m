Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9984164F2
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 20:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242843AbhIWSPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 14:15:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242769AbhIWSOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 14:14:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A79D36121F;
        Thu, 23 Sep 2021 18:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632420792;
        bh=CXcKjL0dNyoXlfgnPpjkJAtY8Lv7U9Iqs9KkD96mUaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DTwFfgMBKWSHaGqPCWbFbYIFXdy5EQqdpon77mGF6ctb4h0+miOD3b1ZezH5DMFli
         L8PiWaZP/uGWafApMmK/PBUcuE7nHYz7XNzFyHsxzcZNJ+RAfRzWbvQl+DuhQSMHfL
         7YeBu/KcmpgJvwsRme+URggvA5+1tBzfz2D3iquFBNCpqkFmv0zq3l85Mw+KiCR26g
         O6373kMum8XjY8foU5ATBcjov7HLPGqWxO6tibzw85AZaxXbD4Cx0ZIvY479d1jyCb
         Nzi1n3qycbVKlamTVhMogKar4sPcrVMoKdEbjVyivyRKu1WUnwZDqSxrCpWuyuVW00
         KN6bnRQLU8PNA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>,
        intel-wired-lan@lists.osuosl.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Javed Hasan <jhasan@marvell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        netdev@vger.kernel.org, Sathya Perla <sathya.perla@broadcom.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net-next 2/6] bnxt_en: Properly remove port parameter support
Date:   Thu, 23 Sep 2021 21:12:49 +0300
Message-Id: <7b85ce0d2a5056af2c7e14dbd16c55d86aac659c.1632420431.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632420430.git.leonro@nvidia.com>
References: <cover.1632420430.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This driver doesn't have any port parameters and registers
devlink port parameters with empty table. Remove the useless
calls to devlink_port_params_register and _unregister.

Fixes: da203dfa89ce ("Revert "devlink: Add a generic wake_on_lan port parameter"")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index dc0851f709f5..ed95e28d60ef 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -736,9 +736,6 @@ static const struct devlink_param bnxt_dl_params[] = {
 			     NULL),
 };
 
-static const struct devlink_param bnxt_dl_port_params[] = {
-};
-
 static int bnxt_dl_params_register(struct bnxt *bp)
 {
 	int rc;
@@ -753,14 +750,6 @@ static int bnxt_dl_params_register(struct bnxt *bp)
 			    rc);
 		return rc;
 	}
-	rc = devlink_port_params_register(&bp->dl_port, bnxt_dl_port_params,
-					  ARRAY_SIZE(bnxt_dl_port_params));
-	if (rc) {
-		netdev_err(bp->dev, "devlink_port_params_register failed\n");
-		devlink_params_unregister(bp->dl, bnxt_dl_params,
-					  ARRAY_SIZE(bnxt_dl_params));
-		return rc;
-	}
 	devlink_params_publish(bp->dl);
 
 	return 0;
@@ -773,8 +762,6 @@ static void bnxt_dl_params_unregister(struct bnxt *bp)
 
 	devlink_params_unregister(bp->dl, bnxt_dl_params,
 				  ARRAY_SIZE(bnxt_dl_params));
-	devlink_port_params_unregister(&bp->dl_port, bnxt_dl_port_params,
-				       ARRAY_SIZE(bnxt_dl_port_params));
 }
 
 int bnxt_dl_register(struct bnxt *bp)
-- 
2.31.1

