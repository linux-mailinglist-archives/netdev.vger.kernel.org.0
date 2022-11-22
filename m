Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F029633182
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbiKVAne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiKVAn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:43:29 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CFF233A8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:43:28 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id t5-20020a5b07c5000000b006dfa2102debso12323294ybq.4
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H1yu5jUp36F2Io1DFumSdAjJKhv7hshoo5lJERMzyiY=;
        b=VOm3tIo26OCPYle6WoOroukwQ/hFtEyqhCKaSY9e15dz67/HBvJ1ptQvU+kA0Dh+ct
         J1LAuw9uKUpWegbIGUWJ9psGZAYwXWbhADZuONzW48RqN2TP5J7cYOpADfvnjDGUH0Wy
         6rYJU06X7W0PCxi5yD+JihkEgsVaqHxABC8pjOnC4XErnSlDL8jmwaiMwcj8JM94XZnb
         OSzotIpwMyK2GHQRSetqIU4G5HH9Mylqbox/lELSppKGk0nnXi/ep4PiSWM45chPHYFS
         G4OSpGtlY/M1KYwZqK5n68I6SEXqhlhwfRX9nSYZvK2Ur2pYNtsv8UlzLQ7EBa/Rbg56
         KGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H1yu5jUp36F2Io1DFumSdAjJKhv7hshoo5lJERMzyiY=;
        b=CsQd0glhuXD9JGVLBeyi+DX5g+lF3fa14kNBhy6w1Aj3KfYKynstQD37G39D4d3uW5
         NYKwUa3yDp/0GlNHaBSEPo/gs0DgxYTMfHKFoXbDClEjutuXj6cf/EdQtDFM7JwMq4uB
         D7V9f7VkzDzGGfy5m5VuzwA/7baQw1Xn3dN1HXn2R5FXWASpHAZ+4ZwdCB4/O+O6OzlW
         WujcWSuLKGcbGCvaCbbGydpaAE9obd2U2GEP6+kVkM71GmqyF/iKdiFSfQ33FoSQ9neo
         DQNRDHVVAnMS61/g+X1Ot2yJws1dmE79jrZhXUJfzaptbEIHHFHovGCAY9BVqSggPCbS
         A/aw==
X-Gm-Message-State: ANoB5pkMmGPUn1QXxDqZVq0uWr+8aM8gvdiDrNHRisw0R+VAhbfJTF5o
        kQz1hM5hC5/DfRVMxxENDD5Vwbgppyropj0=
X-Google-Smtp-Source: AA0mqf7FKqEKN9UUc+VbjRfU8gfCZsF4NvmmqCpHdwMCO5kzBYXG3Z/2IXbYJAS8jj9bpr2a0oBmW60PwXkXzf4=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a05:6902:108f:b0:6d3:2be0:2ae5 with SMTP
 id v15-20020a056902108f00b006d32be02ae5mr19172204ybu.301.1669077807568; Mon,
 21 Nov 2022 16:43:27 -0800 (PST)
Date:   Mon, 21 Nov 2022 18:42:46 -0600
In-Reply-To: <20221122004246.4186422-1-mfaltesek@google.com>
Mime-Version: 1.0
References: <20221122004246.4186422-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122004246.4186422-4-mfaltesek@google.com>
Subject: [PATCH net v2 3/3] nfc: st-nci: fix incorrect sizing calculations in EVT_TRANSACTION
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
Reviewed-by: Guenter Roeck <groeck@google.com>
Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/nfc/st-nci/se.c | 51 +++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index fc59916ae5ae..ec87dd21e054 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -312,6 +312,8 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 	int r = 0;
 	struct device *dev = &ndev->nfc_dev->dev;
 	struct nfc_evt_transaction *transaction;
+	u32 aid_len;
+	u8 params_len;
 
 	pr_debug("connectivity gate event: %x\n", event);
 
@@ -325,28 +327,47 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 		 * Description  Tag     Length
 		 * AID          81      5 to 16
 		 * PARAMETERS   82      0 to 255
+		 *
+		 * The key differences are aid storage length is variably sized
+		 * in the packet, but fixed in nfc_evt_transaction, and that
+		 * the aid_len is u8 in the packet, but u32 in the structure,
+		 * and the tags in the packet are not included in
+		 * nfc_evt_transaction.
+		 *
+		 * size(b):  1          1       5-16 1             1           0-255
+		 * offset:   0          1       2    aid_len + 2   aid_len + 3 aid_len + 4
+		 * mem name: aid_tag(M) aid_len aid  params_tag(M) params_len  params
+		 * example:  0x81       5-16    X    0x82          0-255       X
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
+		if (skb->len < aid_len + 4 ||
+		    aid_len > sizeof(transaction->aid))
+			return -EPROTO;
 
-		/* Check next byte is PARAMETERS tag (82) */
-		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG) {
-			devm_kfree(dev, transaction);
+		params_len = skb->data[aid_len + 3];
+
+		/* Verify PARAMETERS tag is (82), and final check that there is
+		 * enough space in the packet to read everything.
+		 */
+		if (skb->data[aid_len + 2] != NFC_EVT_TRANSACTION_PARAMS_TAG ||
+		    skb->len < aid_len + 4 + params_len)
 			return -EPROTO;
-		}
 
-		transaction->params_len = skb->data[transaction->aid_len + 3];
-		memcpy(transaction->params, skb->data +
-		       transaction->aid_len + 4, transaction->params_len);
+		transaction = devm_kzalloc(dev, sizeof(*transaction) +
+					   params_len, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
+
+		transaction->aid_len = aid_len;
+		transaction->params_len = params_len;
+
+		memcpy(transaction->aid, &skb->data[2], aid_len);
+		memcpy(transaction->params, &skb->data[aid_len + 4],
+		       params_len);
 
 		r = nfc_se_transaction(ndev->nfc_dev, host, transaction);
 		break;
-- 
2.38.1.584.g0f3c55d4c2-goog

