Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCCC4EF98F
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbiDASMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 14:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236302AbiDASMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 14:12:41 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6513212F173
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:10:51 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id y16so2520759ilq.6
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 11:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UmTWrD4mOMtMQTOfHrlu7TGVh+1s1sgIaxw7/KYWbT8=;
        b=J9974GkTfOfFof2YjkOC1LIUa0moq+1QrtHerXREQPyYUaYtzII07LvkTTZdIS2fPZ
         nolq00GXL3Ug+WcvOPrGGyQxb88+S8oVjBsJTiiBbSbnMinKsyzCQnnzArBXaApH7Vi0
         3fncLd/ES+lPLs5eQ5mX7JATbFm8vdsaNzQWk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UmTWrD4mOMtMQTOfHrlu7TGVh+1s1sgIaxw7/KYWbT8=;
        b=zTbq3/mKsWP2k2iPx8ZLGNs4OFU86SSzkn0iANhmxsYZf2o1xQ4wIDGP2292gWWnuf
         QBlktmliwlA8JCfAuhPGMiqaQo5Y2CCf6O9jCMyYc0PLFUmwlM0HHdy3tspSAc/g/rLJ
         AHPMCcTU5x1rs5+Dy4cyz0q31UyGBHRaSBnGzfJOnNSBW3nC7ivY8IU49WLi1esO82EW
         lTKrYZKSfPYenvZDInGEn8hREBT3SWvUkC09rFJ2RLI1lSqsDIAUsVY/61hSNHZkB/en
         WG9BGAvtPGbmjwhSMUwtKs35x0jmcc4fmY9j+R7PaaLSKIdxvhpU3LjXn7zmbpokjeF8
         99ow==
X-Gm-Message-State: AOAM5305876l4+3021ceA++NFFPYGMYCAOhgKaVDT2IoHa/PvPmLeKyw
        tMivwbgSQsrZ1DBe/lYBuHspJzalztliCg==
X-Google-Smtp-Source: ABdhPJx8U9y7Cm0966kLGX3AdAZodqmYJPoyGa57rYe3Xo44xfkZHU9vxd5ssAWt6i0/8iKLLaWO5A==
X-Received: by 2002:a05:6e02:1bea:b0:2c9:bfed:74a1 with SMTP id y10-20020a056e021bea00b002c9bfed74a1mr509321ilv.133.1648836650341;
        Fri, 01 Apr 2022 11:10:50 -0700 (PDT)
Received: from sunset.corp.google.com (110.41.72.34.bc.googleusercontent.com. [34.72.41.110])
        by smtp.gmail.com with ESMTPSA id g5-20020a92dd85000000b002c65941015bsm1659730iln.38.2022.04.01.11.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 11:10:50 -0700 (PDT)
From:   Martin Faltesek <mfaltesek@chromium.org>
X-Google-Original-From: Martin Faltesek <mfaltesek@google.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, krzk@kernel.org,
        christophe.ricard@gmail.com, jordy@pwning.systems
Cc:     sameo@linux.intel.com, wklin@google.com, groeck@google.com,
        mfaltesek@google.com, gregkh@linuxfoundation.org
Subject: [PATCH v2 3/3] nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION
Date:   Fri,  1 Apr 2022 13:10:48 -0500
Message-Id: <20220401181048.2026145-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/nfc/st21nfca/se.c | 58 ++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index d387ba9c4814..b387fd75be49 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -292,6 +292,8 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 	int r = 0;
 	struct device *dev = &hdev->ndev->dev;
 	struct nfc_evt_transaction *transaction;
+	u32 aid_len;
+	u8 params_len;
 
 	pr_debug("connectivity gate event: %x\n", event);
 
@@ -306,44 +308,44 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
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
+		/*
+		 * Verify PARAMETERS tag is (82), and final check that there is enough
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
2.35.1.1094.g7c7d902a7c-goog

