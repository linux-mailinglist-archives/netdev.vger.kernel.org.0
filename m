Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B4328245D
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 15:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgJCNyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 09:54:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgJCNyF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 09:54:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80EE4206CD;
        Sat,  3 Oct 2020 13:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601733244;
        bh=xMa07e1e6o9GjE+aWDog3EUOHS04coMVzjLbLMskLm0=;
        h=Date:From:To:Cc:Subject:From;
        b=zCggCUoZ2u6fBZUuURtLlIndJ0ryQbJBkaZeCM8tlBWLh+2yDitGN5l39fnlHiA6N
         76t9pG/FkqXWaRsdBKRSUqD5++pvBk0FNnbR1h3uRyJFvDFqofhZV2t/cyuhZbEnP9
         ynIk+GU2pCkr6fJ/e7QNYS1c0EK6YNkXLhP9UBes=
Date:   Sat, 3 Oct 2020 15:54:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sathish Narsimman <sathish.narasimman@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "Bluetooth: Update resolving list when updating
 whitelist"
Message-ID: <20201003135449.GA2691@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 0eee35bdfa3b472cc986ecc6ad76293fdcda59e2 as it
breaks all bluetooth connections on my machine.

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Sathish Narsimman <sathish.narasimman@intel.com>
Fixes: 0eee35bdfa3b ("Bluetooth: Update resolving list when updating whitelist")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_request.c | 41 ++-----------------------------------
 1 file changed, 2 insertions(+), 39 deletions(-)

This has been bugging me for since 5.9-rc1, when all bluetooth devices
stopped working on my desktop system.  I finally got the time to do
bisection today, and it came down to this patch.  Reverting it on top of
5.9-rc7 restored bluetooth devices and now my input devices properly
work.

As it's almost 5.9-final, any chance this can be merged now to fix the
issue?


diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index e0269192f2e5..75b0a4776f10 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -697,21 +697,6 @@ static void del_from_white_list(struct hci_request *req, bdaddr_t *bdaddr,
 	bt_dev_dbg(req->hdev, "Remove %pMR (0x%x) from whitelist", &cp.bdaddr,
 		   cp.bdaddr_type);
 	hci_req_add(req, HCI_OP_LE_DEL_FROM_WHITE_LIST, sizeof(cp), &cp);
-
-	if (use_ll_privacy(req->hdev)) {
-		struct smp_irk *irk;
-
-		irk = hci_find_irk_by_addr(req->hdev, bdaddr, bdaddr_type);
-		if (irk) {
-			struct hci_cp_le_del_from_resolv_list cp;
-
-			cp.bdaddr_type = bdaddr_type;
-			bacpy(&cp.bdaddr, bdaddr);
-
-			hci_req_add(req, HCI_OP_LE_DEL_FROM_RESOLV_LIST,
-				    sizeof(cp), &cp);
-		}
-	}
 }
 
 /* Adds connection to white list if needed. On error, returns -1. */
@@ -732,7 +717,7 @@ static int add_to_white_list(struct hci_request *req,
 		return -1;
 
 	/* White list can not be used with RPAs */
-	if (!allow_rpa && !use_ll_privacy(hdev) &&
+	if (!allow_rpa &&
 	    hci_find_irk_by_addr(hdev, &params->addr, params->addr_type)) {
 		return -1;
 	}
@@ -750,28 +735,6 @@ static int add_to_white_list(struct hci_request *req,
 		   cp.bdaddr_type);
 	hci_req_add(req, HCI_OP_LE_ADD_TO_WHITE_LIST, sizeof(cp), &cp);
 
-	if (use_ll_privacy(hdev)) {
-		struct smp_irk *irk;
-
-		irk = hci_find_irk_by_addr(hdev, &params->addr,
-					   params->addr_type);
-		if (irk) {
-			struct hci_cp_le_add_to_resolv_list cp;
-
-			cp.bdaddr_type = params->addr_type;
-			bacpy(&cp.bdaddr, &params->addr);
-			memcpy(cp.peer_irk, irk->val, 16);
-
-			if (hci_dev_test_flag(hdev, HCI_PRIVACY))
-				memcpy(cp.local_irk, hdev->irk, 16);
-			else
-				memset(cp.local_irk, 0, 16);
-
-			hci_req_add(req, HCI_OP_LE_ADD_TO_RESOLV_LIST,
-				    sizeof(cp), &cp);
-		}
-	}
-
 	return 0;
 }
 
@@ -812,7 +775,7 @@ static u8 update_white_list(struct hci_request *req)
 		}
 
 		/* White list can not be used with RPAs */
-		if (!allow_rpa && !use_ll_privacy(hdev) &&
+		if (!allow_rpa &&
 		    hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
 			return 0x00;
 		}
-- 
2.28.0

