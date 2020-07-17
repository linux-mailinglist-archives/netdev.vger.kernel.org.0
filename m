Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67CE3224581
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 23:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgGQVAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 17:00:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgGQVAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 17:00:09 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B74E2070E;
        Fri, 17 Jul 2020 21:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595019608;
        bh=4GGEcBUMFBVvOfAhbz86y8ZU1aInuKu/y4RJPLZbyOk=;
        h=From:To:Cc:Subject:Date:From;
        b=yCZI5EWHvoOAn9vrb1HtVfrnNtaWPLh0BW+7CIXo992S0FnPk8EJurFyoHXVxaGCG
         EL9DYddzKNbGm8SPXRE4vi1lxcouRiLkkBZWCQ7UUCb/YkaSjdrB2UceAT06YiZvJR
         3meAirNEGPbzn0mCbobPWLQNJT35ElZO0hdx3oWI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        michael.chan@broadcom.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: bnxt: don't complain if TC flower can't be supported
Date:   Fri, 17 Jul 2020 13:59:58 -0700
Message-Id: <20200717205958.163031-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fact that NETIF_F_HW_TC is not set should be a sufficient
indication to the user that TC offloads are not supported.
No need to bother users of older firmware versions with
pointless warnings on every boot.

Also, since the support is optional, bnxt_init_tc() should not
return an error in case FW is old, similarly to how error
is not returned when CONFIG_BNXT_FLOWER_OFFLOAD is not set.

With that we can add an error message to the caller, to warn
about actual unexpected failures.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c    | 5 ++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c | 7 ++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0911eb3b8007..a7e5ebe2d68a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12086,7 +12086,10 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				goto init_err_pci_clean;
 			}
 		}
-		bnxt_init_tc(bp);
+		rc = bnxt_init_tc(bp);
+		if (rc)
+			netdev_err(dev, "Failed to initialize TC flower offload, err = %d.\n",
+				   rc);
 	}
 
 	bnxt_dl_register(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index e82e5cf64d61..5e4429b14b8c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -2000,11 +2000,8 @@ int bnxt_init_tc(struct bnxt *bp)
 	struct bnxt_tc_info *tc_info;
 	int rc;
 
-	if (bp->hwrm_spec_code < 0x10803) {
-		netdev_warn(bp->dev,
-			    "Firmware does not support TC flower offload.\n");
-		return -ENOTSUPP;
-	}
+	if (bp->hwrm_spec_code < 0x10803)
+		return 0;
 
 	tc_info = kzalloc(sizeof(*tc_info), GFP_KERNEL);
 	if (!tc_info)
-- 
2.26.2

