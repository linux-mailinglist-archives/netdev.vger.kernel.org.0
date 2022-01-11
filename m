Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A923F48B28E
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343849AbiAKQpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:45:54 -0500
Received: from h2.fbrelay.privateemail.com ([131.153.2.43]:41285 "EHLO
        h2.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343889AbiAKQpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:45:50 -0500
Received: from MTA-11-3.privateemail.com (mta-11-1.privateemail.com [198.54.118.201])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id DFA56180243A;
        Tue, 11 Jan 2022 11:45:49 -0500 (EST)
Received: from mta-11.privateemail.com (localhost [127.0.0.1])
        by mta-11.privateemail.com (Postfix) with ESMTP id D4E921800144;
        Tue, 11 Jan 2022 11:45:47 -0500 (EST)
Received: from localhost.localdomain (unknown [10.20.151.181])
        by mta-11.privateemail.com (Postfix) with ESMTPA id 11177180038B;
        Tue, 11 Jan 2022 11:45:45 -0500 (EST)
From:   Jordy Zomer <jordy@pwning.systems>
To:     jordy@pwning.systems
Cc:     davem@davemloft.net, krzysztof.kozlowski@canonical.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, wengjianfeng@yulong.com
Subject: [PATCH v3] nfc: st-nci: Fix potential buffer overflows in EVT_TRANSACTION
Date:   Tue, 11 Jan 2022 17:45:43 +0100
Message-Id: <20220111164543.3233040-1-jordy@pwning.systems>
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

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
---
 drivers/nfc/st-nci/se.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 7764b1a4c3cf..cdb59ddff4e8 100644
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
@@ -343,6 +348,11 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 			return -EPROTO;
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
+
+		/* Total size is allocated (skb->len - 2) minus fixed array members */
+		if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))
+			return -EINVAL;
+
 		memcpy(transaction->params, skb->data +
 		       transaction->aid_len + 4, transaction->params_len);
 
-- 
2.27.0

