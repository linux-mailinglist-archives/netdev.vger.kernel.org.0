Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2EB4EF98C
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235825AbiDASM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 14:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbiDASMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 14:12:25 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED36012F14D
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:10:34 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id k25so4093248iok.8
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 11:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kNmPkc3Q+KN04Qrhs+Rs2QAGgucV8w+VTok99kxGASc=;
        b=VJQWjmL5OaERN0mIziOy9HXq5AmOGBpSqSq6n105jj5txfVSXGMFH4yNP4/Cr7c+TP
         ySVsXd9v6ANmnmiLJ+SxrUJR9JbUKs6RMV3MeKi+wWV4mZltGAbs9J0DoGCp2hYYP9/+
         Fp3D/aOiGTHwZUcfczhEdUT52mNLgb3ppKvd4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kNmPkc3Q+KN04Qrhs+Rs2QAGgucV8w+VTok99kxGASc=;
        b=t0iSOEu3zgyw0yQ15Rm+d8WG18G1NZ3mnDjL5Kk0w83H40heRw6MMGgTf5JfkzfUsm
         m+5BZc6Ya/T8rDEwyIMKQHzJ90p2GsMXFSIAGH/SdaRJPhdHT8GMfE4oV5BP4UodePiL
         CfvzNDlm0c1TWSDMnrQSZV38heUW2JKiC0tZJzzCWgElRMGqzJUv5CLTtGl/RQ1XjSTr
         xcozedEX3yvnIbsE1Aj3paICFDr2Lh4Lx8JJJcASC9ghQI05oxa5rCyDweV83j2R5lyH
         O0i8v4sR0PYGRK2g9azfTHjLbmrrVWicBAX1TIAcmErZJjCRd1tUWJO3HiwBzpvleDiw
         S2xg==
X-Gm-Message-State: AOAM532D98qpHVU+fYdNRp4KyzTRVN1PPVbZ61FbSlsfRjgnWdczcWdB
        oM2sMMkCDwXW9vjOIXhrSJX+d0zFpumUFQ==
X-Google-Smtp-Source: ABdhPJxhCPjZ3fgrUNXAw9FEhFyKald4zpt2uW1HmApgyO29NHLhXL0SAEIVZoV0GRcrYivMuMWrHA==
X-Received: by 2002:a05:6638:3284:b0:323:7acb:5164 with SMTP id f4-20020a056638328400b003237acb5164mr6305291jav.48.1648836634275;
        Fri, 01 Apr 2022 11:10:34 -0700 (PDT)
Received: from sunset.corp.google.com (110.41.72.34.bc.googleusercontent.com. [34.72.41.110])
        by smtp.gmail.com with ESMTPSA id r5-20020a92d445000000b002c9eaaa7dc3sm1673040ilm.33.2022.04.01.11.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 11:10:33 -0700 (PDT)
From:   Martin Faltesek <mfaltesek@chromium.org>
X-Google-Original-From: Martin Faltesek <mfaltesek@google.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, krzk@kernel.org,
        christophe.ricard@gmail.com, jordy@pwning.systems
Cc:     sameo@linux.intel.com, wklin@google.com, groeck@google.com,
        mfaltesek@google.com, gregkh@linuxfoundation.org
Subject: [PATCH v2 2/3] nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
Date:   Fri,  1 Apr 2022 13:10:32 -0500
Message-Id: <20220401181032.2026076-1-mfaltesek@google.com>
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

Error paths do not free previously allocated memory. Add devm_kfree() to
those failure paths.

Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/nfc/st21nfca/se.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 9a37de60f73f..d387ba9c4814 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -318,22 +318,29 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 		transaction->aid_len = skb->data[1];
 
 		/* Checking if the length of the AID is valid */
-		if (transaction->aid_len > sizeof(transaction->aid))
+		if (transaction->aid_len > sizeof(transaction->aid)) {
+			devm_kfree(dev, transaction);
 			return -EINVAL;
+		}
 
 		memcpy(transaction->aid, &skb->data[2],
 		       transaction->aid_len);
 
 		/* Check next byte is PARAMETERS tag (82) */
 		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG)
+		    NFC_EVT_TRANSACTION_PARAMS_TAG) {
+			devm_kfree(dev, transaction);
 			return -EPROTO;
+		}
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
 
 		/* Total size is allocated (skb->len - 2) minus fixed array members */
-		if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))
+		if (transaction->params_len > ((skb->len - 2) -
+		    sizeof(struct nfc_evt_transaction))) {
+			devm_kfree(dev, transaction);
 			return -EINVAL;
+		}
 
 		memcpy(transaction->params, skb->data +
 		       transaction->aid_len + 4, transaction->params_len);
-- 
2.35.1.1094.g7c7d902a7c-goog

