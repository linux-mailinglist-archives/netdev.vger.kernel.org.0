Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5134B454BCA
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 18:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbhKQRUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 12:20:16 -0500
Received: from h2.fbrelay.privateemail.com ([131.153.2.43]:59763 "EHLO
        h2.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229585AbhKQRUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 12:20:15 -0500
Received: from MTA-13-4.privateemail.com (mta-13-1.privateemail.com [198.54.122.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id 5946A80AFB;
        Wed, 17 Nov 2021 12:17:15 -0500 (EST)
Received: from mta-13.privateemail.com (localhost [127.0.0.1])
        by mta-13.privateemail.com (Postfix) with ESMTP id 8557F18000A1;
        Wed, 17 Nov 2021 12:17:13 -0500 (EST)
Received: from localhost.localdomain (unknown [10.20.151.206])
        by mta-13.privateemail.com (Postfix) with ESMTPA id 10EA918000AB;
        Wed, 17 Nov 2021 12:17:11 -0500 (EST)
From:   Jordy Zomer <jordy@pwning.systems>
To:     linux-kernel@vger.kernel.org
Cc:     Jordy Zomer <jordy@pwning.systems>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH] nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION
Date:   Wed, 17 Nov 2021 18:17:03 +0100
Message-Id: <20211117171706.2731410-1-jordy@pwning.systems>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It appears that there are some buffer overflows in EVT_TRANSACTION.
This happens because the length parameters that are passed to memcpy
come directly from skb->data and are not guarded in any way.

It would be nice if someone can review and test this patch because
I don't own the hardware :)

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
---
 drivers/nfc/st21nfca/se.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index a43fc4117fa5..e3483aca3280 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -316,6 +316,11 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 			return -ENOMEM;
 
 		transaction->aid_len = skb->data[1];
+
+		// Checking if the length of the AID is valid
+		if (transaction->aid_len > sizeof(transaction->aid))
+			return -EINVAL;
+
 		memcpy(transaction->aid, &skb->data[2],
 		       transaction->aid_len);
 
@@ -325,6 +330,14 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 			return -EPROTO;
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
+
+		// check if the length of the parameters is valid
+		// we can't use sizeof(transaction->params) because it's
+		// a flexible array member so we have to check if params_len
+		// is bigger than the space allocated for the array
+		if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))
+			return -EINVAL;
+
 		memcpy(transaction->params, skb->data +
 		       transaction->aid_len + 4, transaction->params_len);
 
-- 
2.27.0

