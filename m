Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE754EB2F8
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 19:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240351AbiC2R4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 13:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240039AbiC2R4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 13:56:19 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022CE75E5B
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 10:54:35 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id x4so21915954iop.7
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 10:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KbxZldMhpD338JczCdPyb5lGb8YcxvHCJJTM4P2DQIQ=;
        b=I69csC440VnK8oyaEiX18Zc5xOPSm0g7Owk2yyKCjibAszTIdpPAXDexNns6LetKbU
         3iOS+VXyRpUoedWb9FGCZatL4yxApq5GHWgeJZAQXHaVY/y1qIXclbJo5iBBe2ucW4E/
         CQWpa7PeypHMXiLM0ut7bohZaP/6hsx9+sGu4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KbxZldMhpD338JczCdPyb5lGb8YcxvHCJJTM4P2DQIQ=;
        b=dNnCNdpharrM/c3QayeOmzrsYtmS/ZFuuZgrwHTDI0MqXtiqU09Scz1BPsYJoYwvgN
         duy14kXOta1KWUXToDF++ig57/tqLH1hyTkeTjH3qVH2W4Zouf1pXI8dKaOix6ofdmpN
         PdNuSfo2GAaFPDJ4i04JBMOVcCCQN6CvwBAqvy9N3MSmW3N78ywsEp1KrhVVKNFaTrj2
         4XCQQuDbGRDjOFhjIzIsfllFPG4YZ4sQeuFCHd5yG9b8UmY6J5D3orI0Utq+717aklTv
         GIg9DGUVAjNHw/Sbj4A6aPHNfZuHeTf1IgZk7YOVxbP/bf9YJcwlBGrK7fyrM8lvwpGX
         rCfQ==
X-Gm-Message-State: AOAM532VMQs0f0n/LOFfKshLUDC7frqwoi56ici0F77Yhrbk7h7ZJZJW
        n5MqtH3CrgGIg95dmwudznTOJcVwZqFogA==
X-Google-Smtp-Source: ABdhPJwaNzb9rlJYABS1QClCS+05VmLMoJLSla3OLSzXEjhlj6sTsu6+05kgrsbQ4U0zsOWCqnykDQ==
X-Received: by 2002:a05:6638:d88:b0:322:e0cf:cf8e with SMTP id l8-20020a0566380d8800b00322e0cfcf8emr14622223jaj.171.1648576474228;
        Tue, 29 Mar 2022 10:54:34 -0700 (PDT)
Received: from sunset.corp.google.com (110.41.72.34.bc.googleusercontent.com. [34.72.41.110])
        by smtp.gmail.com with ESMTPSA id r13-20020a6bfc0d000000b00649e7a72afcsm9593064ioh.29.2022.03.29.10.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 10:54:33 -0700 (PDT)
From:   Martin Faltesek <mfaltesek@chromium.org>
X-Google-Original-From: Martin Faltesek <mfaltesek@google.com>
To:     netdev@vger.kernel.org, krzk@kernel.org,
        christophe.ricard@gmail.com, jordy@pwning.systems
Cc:     sameo@linux.intel.com, wklin@google.com, groeck@google.com,
        surenb@google.com, mfaltesek@google.com, gregkh@linuxfoundation.org
Subject: [PATCH] nfc: st21nfca: Refactor EVT_TRANSACTION
Date:   Tue, 29 Mar 2022 12:54:31 -0500
Message-Id: <20220329175431.3175472-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
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

EVT_TRANSACTION has four different bugs:

1. First conditional has logical AND but should be OR. It should
   always check if it isn't NFC_EVT_TRANSACTION_AID_TAG, then
   bail.

2. Potential under allocating memory:devm_kzalloc (skb->len - 2)
   when the aid_len specified in the packet is less than the fixed
   NFC_MAX_AID_LENGTH in struct nfc_evt_transaction. In addition,
   aid_len is u32 in the data structure, and u8 in the packet,
   under counting 3 more bytes.

3. Memory leaks after kzalloc when returning error.

4. The final conditional check is also incorrect, for the same reasons
   explained in #2.

Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/nfc/st21nfca/se.c | 65 ++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index c922f10d0d7b..acc8d831246a 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -292,6 +292,8 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 	int r = 0;
 	struct device *dev = &hdev->ndev->dev;
 	struct nfc_evt_transaction *transaction;
+	u32 aid_len;
+	u8 params_len;
 
 	pr_debug("connectivity gate event: %x\n", event);
 
@@ -306,37 +308,56 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 		 * Description	Tag	Length
 		 * AID		81	5 to 16
 		 * PARAMETERS	82	0 to 255
+		 *
+		 * The key differences are aid storage length is variably sized
+		 * in the packet, but fixed in nfc_evt_transaction, and that the aid_len
+		 * is u8 in the packet, but u32 in the structure, and the tags in
+		 * the packet are not part of nfc_evt_transaction.
+		 *
+		 * size in bytes: 1          1       5-16  1             1	      0-255
+		 * offset:                   1	     2	   aid_len + 2   aid_len + 3  aid_len + 4
+		 * member name  : aid_tag(M) aid_len aid   params_tag(M) params_len   params
+		 * example      :  0x81      5-16     X    0x82          0-255	      X
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
-		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
-			return -EPROTO;
-
-		transaction = devm_kzalloc(dev, skb->len - 2, GFP_KERNEL);
-		if (!transaction)
-			return -ENOMEM;
 
-		transaction->aid_len = skb->data[1];
+		/*
+		 * Validate the packet is large enough to read the first two bytes
+		 * containing the aid_tag and aid_len, and then read both. Capacity
+		 * checks are expanded incrementally after this, for clarity.
+		 */
+		if (skb->len < 2 || skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
+			return -EPROTO;
 
-		/* Checking if the length of the AID is valid */
-		if (transaction->aid_len > sizeof(transaction->aid))
-			return -EINVAL;
+		aid_len = skb->data[1];
+		/*
+		 * With the actual aid_len, verify there is enough space in
+		 * the packet to read params_tag and params_len, and that
+		 * aid_len does not exceed destination capacity. Reference
+		 * offset comment above for +4 +3 +2 offsets used.
+		 */
+		if (skb->len < aid_len + 4 || aid_len > sizeof(transaction->aid))
+			return -EPROTO;
 
-		memcpy(transaction->aid, &skb->data[2],
-		       transaction->aid_len);
+		params_len = skb->data[aid_len + 3];
 
-		/* Check next byte is PARAMETERS tag (82) */
-		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG)
+		/*
+		 * Verify PARAMETERS tag is (82), and final validation that enough
+		 * space in packet to read everything.
+		 */
+		if ((skb->data[aid_len + 2] != NFC_EVT_TRANSACTION_PARAMS_TAG) ||
+		    (skb->len < aid_len + 4 + params_len))
 			return -EPROTO;
 
-		transaction->params_len = skb->data[transaction->aid_len + 3];
+		transaction = devm_kzalloc(dev, sizeof(struct nfc_evt_transaction) +
+			params_len, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
 
-		/* Total size is allocated (skb->len - 2) minus fixed array members */
-		if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))
-			return -EINVAL;
+		transaction->aid_len = aid_len;
+		transaction->params_len = params_len;
 
-		memcpy(transaction->params, skb->data +
-		       transaction->aid_len + 4, transaction->params_len);
+		memcpy(transaction->aid, &skb->data[2], aid_len);
+		memcpy(transaction->params, &skb->data[aid_len + 4], params_len);
 
 		r = nfc_se_transaction(hdev->ndev, host, transaction);
 	break;
-- 
2.35.1.1021.g381101b075-goog

