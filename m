Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F9C53F439
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 04:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbiFGC6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 22:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236141AbiFGC56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 22:57:58 -0400
Received: from mail-il1-x149.google.com (mail-il1-x149.google.com [IPv6:2607:f8b0:4864:20::149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B539564D15
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 19:57:57 -0700 (PDT)
Received: by mail-il1-x149.google.com with SMTP id 3-20020a056e0220c300b002d3d7ebdfdeso12538696ilq.16
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 19:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=h0VUAZ+/P4d+rcM7OhdmQUwR8fhTt/+FRpwZ4ssNaoY=;
        b=KQf6dUggN5nsG14QDq4LREfknFtH+AYRehyVfITQSFywcXQOVe5xpRbCbuQ+0XXQC5
         lZvozjBDhXgm5bwOtMY5mfayninAbsZP8h0HLFAWhJT5L9qNgAkuXzE97CECqohwKPOj
         t/qTRtR0aXDBN7IduWydnZ05TbSKOhj4j1YkULmapAPOu8wZybDkVKvvLcUAuuOYzflp
         vBjAdGXLh8yijKq3Rw0KcPlyat3BW2CI8KGublys9AP5xJ2wue92OcaNBX4GU7gJ/i8w
         gk0XQXHC4dw/g4xM6KCekf0M/ucZWHaCK4Q/a5SHkbhVi4QO7rzqwUqAacOwa7aBkYEV
         4ntg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=h0VUAZ+/P4d+rcM7OhdmQUwR8fhTt/+FRpwZ4ssNaoY=;
        b=ge4v1hVdjrtD3vAu0zMhNbVhiBSvZs4TfFEgExvE75hANwjhR2qfZAdirazNvWJ1WZ
         Bf90X6KV/3oqVoKbp/czH+IVpG4PkIYeaAHrLYOsPCb24sOjrF6+/iKUMkPgoXfrSVit
         h1prCAwGZZFh7k39h8z9lebhLKoxpY9NdhNwAk6vlc1gij6nnP8xNbyCAXFQYNAJ0kDw
         VkQ9HEJIwzkZFTu7umwiwKxeM0XIi5JQ84I8//kd5fqOaxodUWhKDDfwOXUNhuOL7Aw0
         7897y4fZXHwF9qi+xTcMPBWtzYcMS+4MGfi6XLzRdl39o0bTv84aJgWocY8B9KO4esBt
         wEPQ==
X-Gm-Message-State: AOAM531gjzvLsXSbiqAI4Sj4U9LU8JNP+Fjz/7Jk6tRj/qnPaBrOQP9r
        /aU075rMsOeUMAeg2o9fjsmIdF/7MCF05Ow=
X-Google-Smtp-Source: ABdhPJzjIo6i5SEs2c/82eKPbA5G+HcAvxhnbyglvD/5PCyDp4OXYbIYn8yTGEqoGZgS0EHtQ98TZCnG4utf26s=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a05:6e02:198e:b0:2d3:f382:bbc1 with SMTP
 id g14-20020a056e02198e00b002d3f382bbc1mr13051254ilf.129.1654570677049; Mon,
 06 Jun 2022 19:57:57 -0700 (PDT)
Date:   Mon,  6 Jun 2022 21:57:29 -0500
In-Reply-To: <20220607025729.1673212-1-mfaltesek@google.com>
Message-Id: <20220607025729.1673212-4-mfaltesek@google.com>
Mime-Version: 1.0
References: <20220607025729.1673212-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH net v3 3/3] nfc: st21nfca: fix incorrect sizing calculations
 in EVT_TRANSACTION
From:   Martin Faltesek <mfaltesek@google.com>
To:     kuba@kernel.org, krzysztof.kozlowski@linaro.org
Cc:     christophe.ricard@gmail.com, gregkh@linuxfoundation.org,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        mfaltesek@google.com, martin.faltesek@gmail.com,
        netdev@vger.kernel.org, linux-nfc@lists.01.org,
        sameo@linux.intel.com, wklin@google.com, theflamefire89@gmail.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The transaction buffer is allocated by using the size of the packet buf,
and subtracting two which seem intended to remove the two tags which are
not present in the target structure. This calculation leads to under
counting memory because of differences between the packet contents and the
target structure. The aid_len field is a u8 in the packet, but a u32 in
the structure, resulting in at least 3 bytes always being under counted.
Further, the aid data is a variable length field in the packet, but fixed
in the structure, so if this field is less than the max, the difference is
added to the under counting.

The last validation check for transaction->params_len is also incorrect
since it employs the same accounting error.

To fix, perform validation checks progressively to safely reach the
next field, to determine the size of both buffers and verify both tags.
Once all validation checks pass, allocate the buffer and copy the data.
This eliminates freeing memory on the error path, as those checks are
moved ahead of memory allocation.

Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
Cc: stable@vger.kernel.org
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/nfc/st21nfca/se.c | 60 +++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 8e1113ce139b..df8d27cf2956 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -300,6 +300,8 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 	int r = 0;
 	struct device *dev = &hdev->ndev->dev;
 	struct nfc_evt_transaction *transaction;
+	u32 aid_len;
+	u8 params_len;
 
 	pr_debug("connectivity gate event: %x\n", event);
 
@@ -308,50 +310,48 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 		r = nfc_se_connectivity(hdev->ndev, host);
 	break;
 	case ST21NFCA_EVT_TRANSACTION:
-		/*
-		 * According to specification etsi 102 622
+		/* According to specification etsi 102 622
 		 * 11.2.2.4 EVT_TRANSACTION Table 52
 		 * Description	Tag	Length
 		 * AID		81	5 to 16
 		 * PARAMETERS	82	0 to 255
+		 *
+		 * The key differences are aid storage length is variably sized
+		 * in the packet, but fixed in nfc_evt_transaction, and that the aid_len
+		 * is u8 in the packet, but u32 in the structure, and the tags in
+		 * the packet are not included in nfc_evt_transaction.
+		 *
+		 * size in bytes: 1          1       5-16 1             1           0-255
+		 * offset:        0          1       2    aid_len + 2   aid_len + 3 aid_len + 4
+		 * member name:   aid_tag(M) aid_len aid  params_tag(M) params_len  params
+		 * example:       0x81       5-16    X    0x82 0-255    X
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
-		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
+		if (skb->len < 2 || skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-		transaction = devm_kzalloc(dev, skb->len - 2, GFP_KERNEL);
-		if (!transaction)
-			return -ENOMEM;
-
-		transaction->aid_len = skb->data[1];
+		aid_len = skb->data[1];
 
-		/* Checking if the length of the AID is valid */
-		if (transaction->aid_len > sizeof(transaction->aid)) {
-			devm_kfree(dev, transaction);
-			return -EINVAL;
-		}
+		if (skb->len < aid_len + 4 || aid_len > sizeof(transaction->aid))
+			return -EPROTO;
 
-		memcpy(transaction->aid, &skb->data[2],
-		       transaction->aid_len);
+		params_len = skb->data[aid_len + 3];
 
-		/* Check next byte is PARAMETERS tag (82) */
-		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG) {
-			devm_kfree(dev, transaction);
+		/* Verify PARAMETERS tag is (82), and final check that there is enough
+		 * space in the packet to read everything.
+		 */
+		if ((skb->data[aid_len + 2] != NFC_EVT_TRANSACTION_PARAMS_TAG) ||
+		    (skb->len < aid_len + 4 + params_len))
 			return -EPROTO;
-		}
 
-		transaction->params_len = skb->data[transaction->aid_len + 3];
+		transaction = devm_kzalloc(dev, sizeof(*transaction) + params_len, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
 
-		/* Total size is allocated (skb->len - 2) minus fixed array members */
-		if (transaction->params_len > ((skb->len - 2) -
-		    sizeof(struct nfc_evt_transaction))) {
-			devm_kfree(dev, transaction);
-			return -EINVAL;
-		}
+		transaction->aid_len = aid_len;
+		transaction->params_len = params_len;
 
-		memcpy(transaction->params, skb->data +
-		       transaction->aid_len + 4, transaction->params_len);
+		memcpy(transaction->aid, &skb->data[2], aid_len);
+		memcpy(transaction->params, &skb->data[aid_len + 4], params_len);
 
 		r = nfc_se_transaction(hdev->ndev, host, transaction);
 	break;
-- 
2.36.1.255.ge46751e96f-goog

