Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B29E45550B
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 08:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243528AbhKRHF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 02:05:27 -0500
Received: from mta-13-4.privateemail.com ([198.54.127.109]:47279 "EHLO
        MTA-13-4.privateemail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243524AbhKRHF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 02:05:27 -0500
Received: from mta-13.privateemail.com (localhost [127.0.0.1])
        by mta-13.privateemail.com (Postfix) with ESMTP id 5003F18000BA;
        Thu, 18 Nov 2021 02:02:27 -0500 (EST)
Received: from localhost.localdomain (unknown [10.20.151.247])
        by mta-13.privateemail.com (Postfix) with ESMTPA id 59D27180009F;
        Thu, 18 Nov 2021 02:02:25 -0500 (EST)
From:   Jordy Zomer <jordy@pwning.systems>
To:     linux-kernel@vger.kernel.org
Cc:     Jordy Zomer <jordy@pwning.systems>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        wengjianfeng <wengjianfeng@yulong.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2] nfc: st-nci: Fix potential buffer overflows in EVT_TRANSACTION
Date:   Thu, 18 Nov 2021 08:02:00 +0100
Message-Id: <20211118070202.2739158-1-jordy@pwning.systems>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211117171554.2731340-1-jordy@pwning.systems>
References: <20211117171554.2731340-1-jordy@pwning.systems>
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

EDIT: Changed comment style and double newlines

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
---
 drivers/nfc/st-nci/se.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 7764b1a4c3cf..8e2ac8a3d199 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -335,6 +335,11 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 			return -ENOMEM;
 
 		transaction->aid_len = skb->data[1];
+
+		/* Checking if the length of the AID is valid */
+		if (transaction->aid_len > sizeof(transaction->aid))
+			return -EINVAL;
+
 		memcpy(transaction->aid, &skb->data[2], transaction->aid_len);
 
 		/* Check next byte is PARAMETERS tag (82) */
@@ -343,6 +348,16 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 			return -EPROTO;
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
+
+		/*
+		 * check if the length of the parameters is valid
+		 * we can't use sizeof(transaction->params) because it's
+		 * a flexible array member so we have to check if params_len
+		 * is bigger than the space allocated for the array
+		 */
+		if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))
+			return -EINVAL;
+
 		memcpy(transaction->params, skb->data +
 		       transaction->aid_len + 4, transaction->params_len);
 
-- 
2.27.0

