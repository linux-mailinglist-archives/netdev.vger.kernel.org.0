Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534C0633180
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 01:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbiKVAn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 19:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiKVAn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 19:43:27 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E5565AB
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:43:26 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-39afd53dcdbso63959207b3.8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 16:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hHrEF8AQA3UhNUZXrO/cT+wMny+hOd6xV7yWZ0yM7pQ=;
        b=bYD75ARNcIJshbUI/gDQjnHFw3GqBjAi2IVgV1SF/wvtX055gxoY4wZBm3s82FT3os
         WG4FvyNO+21D5kJQGRoeOvjKwffOLVoC7tryWAdIXDILjXOLiZUOd1Fujwb/gBOO0IuF
         JcNgyvbyNRqP7LqDIkfivTCVGSRCcKAEYlAhKP8GJSKKH1Hf1E5cQPzMQuA1aaszXQfA
         3x0D9KmytkDtAKgbSK0XKq9M90u62CqaZUpnZMwyrScmoo/vFJJwsi9Tk0AwRpb5BE8g
         ofNNlELEKeW666jaVV/Znu8ptAZ3q0Gxf2rApY7MlAygnq2Z+9G6yoNeUmyOPomC8Gnm
         2VeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hHrEF8AQA3UhNUZXrO/cT+wMny+hOd6xV7yWZ0yM7pQ=;
        b=3rYin+lkMHeC1cEOU5kxPEbVUrsEQC/MgORz86KOI0TnbQL5bJE8Fmid4x+KonF8gl
         4f4dUi3a43PL1L92l0gJdfYRgqAJlDxHmGXBnyKjOluVNQyUrq0LQT1kSNtIWdDQvBtA
         S24mHYG65vr2mVP8XTgTyistfeIPPj5BuG772BhclTUVqzqk9Zc2uB0fKP9Ve6Gv58mG
         lXvWpJ79D7QHizrOLx7Xiad2CzzXoS9zeFCsY7M6fEakwXg7KJQMfnZV2keqEbZzXfUf
         adC4MxGXSXimS6qt0YQ7TUX4MCo06HLFPWk0yDlnQm7BSZSLC/YnWGamozQdf8kMRDim
         7xyw==
X-Gm-Message-State: ANoB5pl+6vhBllejizWJZm6DFRLaE1LvrdNQWRAquNbAKV3oRbGM0Exb
        kQOL45q2TdNYnimHPtHk71uOwRVvVhBvVX8=
X-Google-Smtp-Source: AA0mqf7g3f2/IEzv4wwmxMliAIdApbHFbfF5v4g8aRKnb7x+KP1wt5ACGxim6FRmuL5Xk/h5oGdnmrRILO2pasI=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a81:138d:0:b0:39d:1261:bc77 with SMTP id
 135-20020a81138d000000b0039d1261bc77mr2ywt.336.1669077805218; Mon, 21 Nov
 2022 16:43:25 -0800 (PST)
Date:   Mon, 21 Nov 2022 18:42:44 -0600
In-Reply-To: <20221122004246.4186422-1-mfaltesek@google.com>
Mime-Version: 1.0
References: <20221122004246.4186422-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122004246.4186422-2-mfaltesek@google.com>
Subject: [PATCH net v2 1/3] nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION
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

The first validation check for EVT_TRANSACTION has two different checks
tied together with logical AND. One is a check for minimum packet length,
and the other is for a valid aid_tag. If either condition is true (fails),
then an error should be triggered. The fix is to change && to ||.

Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
Reviewed-by: Guenter Roeck <groeck@google.com>
Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/nfc/st-nci/se.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 7764b1a4c3cf..589e1dec78e7 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -326,7 +326,7 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
 		 * AID          81      5 to 16
 		 * PARAMETERS   82      0 to 255
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
+		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
 		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-- 
2.38.1.584.g0f3c55d4c2-goog

