Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FC6506029
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbiDRXUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234785AbiDRXUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:20:49 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091FA24080
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:18:09 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id fu34so2406043qtb.8
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NlRd4j5md/1GciWxxdILk90+l0dQrFXO0akgvKuGKys=;
        b=hOG03vLUq3iZ50ueHjZVfyhoguvGmU1Wah3UxbLvRBUMDP7zKkkkBuYjd7CwcdDpmd
         wvvPtX/TM+hZxbHCcAAw7kNp7MW8z7+1X6+Xn1Ap+JnbWmme+Uhk6SUloc93MCqSiBSy
         dPQSoaoWybf/RQ5HVgmoPZD+Gdyrau6flv0MU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NlRd4j5md/1GciWxxdILk90+l0dQrFXO0akgvKuGKys=;
        b=XnUStgDRhXexnk2igQP4GA1yjAnmse49WAvf/iw0Y+ntabxJmEQd+U2fBQPWOfz7Ik
         axT9CEEljD05dQljI/80PQ8sCpSKMRS+KBJwp0weHXF3Wp4T3QfbOaUv+tm/T8VcK9C9
         pwyRklfxB/e46O4NtBpo1GyXkQN2PkVuuxSXd1VJQDVieGsc0UtyARj41mz7XPnHaqwL
         9sMDLneYl9ar/Woh52jiIhfURzr7anT4Bttfa54OHsuAKiK/jU9C4W7OUyQusDyy3eeT
         qQQ5Q0Vki/zub8xOZclRh/bhtsAZoPCWgvu3HKTn8OKxjs23QAObJWLbsMyoa1HY9AF5
         174A==
X-Gm-Message-State: AOAM532JAyV35AryayaxjV98Bi+c06WwCTTJP0aqk4VlvReHFoa9fHxX
        FFgzjYoOkwtCrTVsKW14S/xK1AUyQ1mPPA==
X-Google-Smtp-Source: ABdhPJz4CCSb9zYc5fCCMVLbVMjPO5dyAl5MissvY4yDiiQdYIkuU7OrNjGBrPyf5pI+AKWPBQ6/zw==
X-Received: by 2002:a05:622a:40f:b0:2f1:f97b:7519 with SMTP id n15-20020a05622a040f00b002f1f97b7519mr6638240qtx.391.1650323888201;
        Mon, 18 Apr 2022 16:18:08 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id a1-20020a05622a02c100b002f17cba4930sm8214048qtx.85.2022.04.18.16.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 16:18:07 -0700 (PDT)
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
Subject: [PATCH 4/5] net: atlantic: add check for MAX_SKB_FRAGS
Date:   Mon, 18 Apr 2022 16:17:45 -0700
Message-Id: <20220418231746.2464800-5-grundler@chromium.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220418231746.2464800-1-grundler@chromium.org>
References: <20220418231746.2464800-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enforce that the CPU can not get stuck in an infinite loop.

Reported-by: Aashay Shringarpure <aashay@google.com>
Reported-by: Yi Chou <yich@google.com>
Reported-by: Shervin Oloumi <enlightened@google.com>
Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index bc1952131799..8201ce7adb77 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -363,6 +363,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 			continue;
 
 		if (!buff->is_eop) {
+			unsigned int frag_cnt = 0U;
 			buff_ = buff;
 			do {
 				bool is_rsc_completed = true;
@@ -371,6 +372,8 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 					err = -EIO;
 					goto err_exit;
 				}
+
+				frag_cnt++;
 				next_ = buff_->next,
 				buff_ = &self->buff_ring[next_];
 				is_rsc_completed =
@@ -378,7 +381,8 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 							    next_,
 							    self->hw_head);
 
-				if (unlikely(!is_rsc_completed)) {
+				if (unlikely(!is_rsc_completed) ||
+				    frag_cnt > MAX_SKB_FRAGS) {
 					err = 0;
 					goto err_exit;
 				}
-- 
2.36.0.rc0.470.gd361397f0d-goog

