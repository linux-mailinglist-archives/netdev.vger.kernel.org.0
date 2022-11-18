Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF88E62FFAF
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiKRWEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiKRWEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:04:34 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D6C7FC13
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:04:33 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id f2-20020a5ec602000000b006dc67829888so3307626iok.3
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VDt+h+giJTgq4fEGS0FuIIAxHV+ol91a3+En2+f2GkQ=;
        b=ptSnuhjZJwMscKOA+GYWNgcahdijtBrL0BGNvRTrrOBF2cojEdRHa3/mrS/zevDGzo
         s5bhQuvjuhFplTxJMbjxctvw9in1Vn8dxYQDFMxHtAeQlUibgZHQPB+ivelFncNLoAM3
         ku3UN6OAEA6cSx9/vYooBJL/nPqGRvtAEGqW5sciMATq10l5yTgqtSiyHH70drYYbLYK
         aMEatXwyRwQIjXaGGlFl1GhGzQkBqa6K+jopcG2IDGXngKl4Ryq/RRlUX07TcLDZNr0L
         c0tN3tmtJETSsAxWVGBgU7eDqvAwtAYEz5xvtbBjDLPQuGdmR0VxUcQhSiwTH8U39TrI
         890A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VDt+h+giJTgq4fEGS0FuIIAxHV+ol91a3+En2+f2GkQ=;
        b=lP0iAdoWf7RDAz3CUxkMnt+hv8YRzxIUMFaAbiVNeG+ye2g+WBEILElVJa9cmVOykU
         EVJ+KWwgLoxU9kQ/YKwlU2zqUE1FmJz6N1sPf/pOn0XRP/40r6+HHEQGlNrn53K/IAjb
         gn5zY4nqF22SctiNGJdjyVpshZZyb/zes+AUnfoCC6kEUceQCS7D/we6O4FSiEz3faZ6
         ciRjLdYCC2aOH9NBQKOTRv+xATZMSVlY0Y2mUGh2Ssd0B0/FpRQ90CCxAr9jsZIOrcZy
         pugc0BuGwOWu6jKAVizZoWHaX2JgJQhXemLkQSsKtEit1lxrRz33UQdv/3mGBQapc3tg
         WJWQ==
X-Gm-Message-State: ANoB5pk57D2etNkEqGLHdMMqpHowsKommMbvoA8PwQNYvqj04eV611GD
        lqJeGlwGF4EUmYrbS0FmxzyorXNFe2aVbvA=
X-Google-Smtp-Source: AA0mqf6uMxbLTtLLPRG2uIrpQU8Naf0g4VjZey7CVtQrp+QL9aRMg/ub7MlKpdVqMCjyPJHpJek2A47zwb9LoC4=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a5d:9d4b:0:b0:6de:3e2c:a77a with SMTP id
 k11-20020a5d9d4b000000b006de3e2ca77amr4277932iok.148.1668809072793; Fri, 18
 Nov 2022 14:04:32 -0800 (PST)
Date:   Fri, 18 Nov 2022 16:04:23 -0600
In-Reply-To: <20221118220423.4038455-1-mfaltesek@google.com>
Mime-Version: 1.0
References: <20221118220423.4038455-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221118220423.4038455-4-mfaltesek@google.com>
Subject: [PATCH net 3/3] nfc: st-nci: fix incorrect sizing calculations in EVT_TRANSACTION
From:   Martin Faltesek <mfaltesek@google.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, linux-nfc@lists.01.org,
        krzysztof.kozlowski@linaro.org, davem@davemloft.net
Cc:     martin.faltesek@gmail.com, christophe.ricard@gmail.com,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        mfaltesek@google.com, sameo@linux.intel.com,
        theflamefire89@gmail.com, duoming@zju.edu.cn,
        Denis Efremov <denis.e.efremov@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The transaction buffer is allocated by using the size of the packet buf,
and subtracting two which seems intended to remove the two tags which are
not present in the target structure. This calculation leads to under
counting memory because of differences between the packet contents and the
target structure. The aid_len field is a u8 in the packet, but a u32 in
the structure, resulting in at least 3 bytes always being under counted.
Further, the aid data is a variable length field in the packet, but fixed
in the structure, so if this field is less than the max, the difference is
added to the under counting.

To fix, perform validation checks progressively to safely reach the
next field, to determine the size of both buffers and verify both tags.
Once all validation checks pass, allocate the buffer and copy the data.
This eliminates freeing memory on the error path, as validation checks are
moved ahead of memory allocation.

Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/nfc/st-nci/se.c | 47 ++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index fc59916ae5ae..0c24f4a5c92e 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -312,6 +312,8 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 	int r = 0;
 	struct device *dev = &ndev->nfc_dev->dev;
 	struct nfc_evt_transaction *transaction;
+	u32 aid_len;
+	u8 params_len;
 
 	pr_debug("connectivity gate event: %x\n", event);
 
@@ -325,28 +327,43 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 		 * Description  Tag     Length
 		 * AID          81      5 to 16
 		 * PARAMETERS   82      0 to 255
+		 *
+		 * The key differences are aid storage length is variably sized
+		 * in the packet, but fixed in nfc_evt_transaction, and that the aid_len
+		 * is u8 in the packet, but u32 in the structure, and the tags in
+		 * the packet are not included in nfc_evt_transaction.
+		 *
+		 * size in bytes: 1          1       5-16 1             1           0-255
+		 * offset:        0          1       2    aid_len + 2   aid_len + 3 aid_len + 4
+		 * member name:   aid_tag(M) aid_len aid  params_tag(M) params_len  params
+		 * example:       0x81       5-16    X    0x82          0-255       X
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
-		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
+		if (skb->len < 2 || skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-		transaction = devm_kzalloc(dev, skb->len - 2, GFP_KERNEL);
-		if (!transaction)
-			return -ENOMEM;
+		aid_len = skb->data[1];
 
-		transaction->aid_len = skb->data[1];
-		memcpy(transaction->aid, &skb->data[2], transaction->aid_len);
+		if (skb->len < aid_len + 4 || aid_len > sizeof(transaction->aid))
+			return -EPROTO;
 
-		/* Check next byte is PARAMETERS tag (82) */
-		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG) {
-			devm_kfree(dev, transaction);
+		params_len = skb->data[aid_len + 3];
+
+		/* Verify PARAMETERS tag is (82), and final check that there is enough
+		 * space in the packet to read everything.
+		 */
+		if (skb->data[aid_len + 2] != NFC_EVT_TRANSACTION_PARAMS_TAG ||
+		    (skb->len < aid_len + 4 + params_len))
 			return -EPROTO;
-		}
 
-		transaction->params_len = skb->data[transaction->aid_len + 3];
-		memcpy(transaction->params, skb->data +
-		       transaction->aid_len + 4, transaction->params_len);
+		transaction = devm_kzalloc(dev, sizeof(*transaction) + params_len, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
+
+		transaction->aid_len = aid_len;
+		transaction->params_len = params_len;
+
+		memcpy(transaction->aid, &skb->data[2], aid_len);
+		memcpy(transaction->params, &skb->data[aid_len + 4], params_len);
 
 		r = nfc_se_transaction(ndev->nfc_dev, host, transaction);
 		break;
-- 
2.38.1.584.g0f3c55d4c2-goog

