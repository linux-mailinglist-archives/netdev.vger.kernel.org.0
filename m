Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1088A506027
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbiDRXUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234731AbiDRXUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:20:47 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9655523BD9
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:18:07 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id z19so11121299qtw.2
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cm6vrPc6zBxtc8mQWliADJPsKgyQwKE9+4mqmo5RZKE=;
        b=U8a3jSUSPI7w+GxtadKgv7/XegggLYVFgOz+hbw1AvD0DG03H+DOlpsGSI6Nhwu7dd
         qkPGuqZr5UIW/puXFV8QaEpgY8yYz+xeQ8UH+989o0lXmrOmvXwHXy6rbIlhTMF11tyD
         1/0Q5Ao2CUxstvd2S0cJxiugKkXr5HGO3TbbI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cm6vrPc6zBxtc8mQWliADJPsKgyQwKE9+4mqmo5RZKE=;
        b=cPQV9JopnU2nZ+NRQQLE6iGu6NOF5iPLpRSE7AakOxrv9FvAA5+XzAISbYQioeYd75
         x6S8+1xcXpBXon6GxmKXJcxHujr8ZRSBNRF/VBciCrHZEorjAhfHWg0fb7/QHAHJ8Wxh
         NkrsZ2lfvmt9N0b5nMUaFx4zuiO1twCDlUn2DJ5omltUQY5xBxwxr3TSGQiRz63f5QaM
         tqyrzME8xKWVyIKCMwM9hNjBcwJPBxnT1o7aGh9phRBuT2y8VeirVSDrn9jvrOjJUKB/
         Xs/2rZF0SJyPdIbd2raYz9YGbXSXfGYx20Io6j3KF+sqwSy7CkBYarpR2275vGeZx8IJ
         UjSw==
X-Gm-Message-State: AOAM530M061ajuy5MhmI82GbapYL/6XtE4jPIijH/kpnIHAuQM8fp0fX
        Y5NImn6cfLUcu54wfzqnP+YfGwpp1HnPCA==
X-Google-Smtp-Source: ABdhPJy+508q4T003VTS1J7WP9dq1N2Y5oaYvHODfUb7OW6Ht+xF09/KjxlhYz+MfAtfzD6Y71opyA==
X-Received: by 2002:a05:622a:6182:b0:2f1:e351:abcf with SMTP id hh2-20020a05622a618200b002f1e351abcfmr8548180qtb.321.1650323886785;
        Mon, 18 Apr 2022 16:18:06 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id a1-20020a05622a02c100b002f17cba4930sm8214048qtx.85.2022.04.18.16.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 16:18:06 -0700 (PDT)
From:   Grant Grundler <grundler@chromium.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 3/5] net: atlantic: reduce scope of is_rsc_complete
Date:   Mon, 18 Apr 2022 16:17:44 -0700
Message-Id: <20220418231746.2464800-4-grundler@chromium.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220418231746.2464800-1-grundler@chromium.org>
References: <20220418231746.2464800-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't defer handling the err case outside the loop. That's pointless.

And since is_rsc_complete is only used inside this loop, declare
it inside the loop to reduce it's scope.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 440423b0e8ea..bc1952131799 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -346,7 +346,6 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		     int budget)
 {
 	struct net_device *ndev = aq_nic_get_ndev(self->aq_nic);
-	bool is_rsc_completed = true;
 	int err = 0;
 
 	for (; (self->sw_head != self->hw_head) && budget;
@@ -366,6 +365,8 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		if (!buff->is_eop) {
 			buff_ = buff;
 			do {
+				bool is_rsc_completed = true;
+
 				if (buff_->next >= self->size) {
 					err = -EIO;
 					goto err_exit;
@@ -377,18 +378,16 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 							    next_,
 							    self->hw_head);
 
-				if (unlikely(!is_rsc_completed))
-					break;
+				if (unlikely(!is_rsc_completed)) {
+					err = 0;
+					goto err_exit;
+				}
 
 				buff->is_error |= buff_->is_error;
 				buff->is_cso_err |= buff_->is_cso_err;
 
 			} while (!buff_->is_eop);
 
-			if (!is_rsc_completed) {
-				err = 0;
-				goto err_exit;
-			}
 			if (buff->is_error ||
 			    (buff->is_lro && buff->is_cso_err)) {
 				buff_ = buff;
-- 
2.36.0.rc0.470.gd361397f0d-goog

