Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36665520B35
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbiEJCco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 22:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbiEJCcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 22:32:35 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467E21A90CC
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 19:28:39 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id v11so1912382qkf.1
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 19:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8rinvUkerUnBV1oCCsJspInjXAj8u20lqkKc2zXtN9k=;
        b=YSvcgAJmFkKTvstDHxNY7NSKlk4XIGhWHKxe1SPdH1m/1xkfacghSFkGsFBcHkwRN8
         Hb8hp1lKChVAL/ja5FTS/V1oCZvrrlRYRO73z3pkrl9jv75dH3p+qn2Vv3DQ/h6TW1Zv
         LnW8RqqND7Rumoaid9OuYYJIbUfBQIvfPp1Ls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8rinvUkerUnBV1oCCsJspInjXAj8u20lqkKc2zXtN9k=;
        b=B16WFunwHsd0EB3g5NrsqTqTwjf+3RYegV+fUzFav0p/op87LbvZEV+TSDwL6jeWrv
         dMqBcUE3yhxFeY1v6fGXoJ0gbg2RM7+jh/tN4DogdhGdY4mbuSXkSV2a6H0kfWdGK399
         ycMfz2LJfJTH0Xv8DHE+kUdDs6UoBXeaEkofnXvTr5GkoBvKc+Ng/MD4zMVyGc9oFeBt
         CDAu0eyGxwFztJPI5QiOZlDZaiEHiWltAKGv8evZUqFpi2YXCaRxApA0GUzpUOm0hihp
         4dogLXgljLzVrleGyLokmhJbByeGlcGBPdRg6O5xjUZZeUyckOqNIB3mBQR3DxlSmygv
         sfkg==
X-Gm-Message-State: AOAM530MQSjD8GRy0q7CXpRR1QiCa+HeZu+i/7y3vSvXPuG2BaFaE84X
        ZWb9NVmC15V2SQoBeoJPuxn8eg==
X-Google-Smtp-Source: ABdhPJztevCzT89DbElfTEsOF0uoMW79/1vD5zhMlvLX7s2o06sJ/SCCOBfQbN6I0wISEmd3EJHFCw==
X-Received: by 2002:a05:620a:4481:b0:6a0:1dd3:d210 with SMTP id x1-20020a05620a448100b006a01dd3d210mr14496664qkp.137.1652149718427;
        Mon, 09 May 2022 19:28:38 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id 18-20020a05620a06d200b0069fc13ce213sm7742375qky.68.2022.05.09.19.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 19:28:37 -0700 (PDT)
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
Subject: [PATCH 1/4] net: atlantic:  fix "frag[0] not initialized"
Date:   Mon,  9 May 2022 19:28:23 -0700
Message-Id: <20220510022826.2388423-2-grundler@chromium.org>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220510022826.2388423-1-grundler@chromium.org>
References: <20220510022826.2388423-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In aq_ring_rx_clean(), if buff->is_eop is not set AND
buff->len < AQ_CFG_RX_HDR_SIZE, then hdr_len remains equal to
buff->len and skb_add_rx_frag(xxx, *0*, ...) is not called.

The loop following this code starts calling skb_add_rx_frag() starting
with i=1 and thus frag[0] is never initialized. Since i is initialized
to zero at the top of the primary loop, we can just reference and
post-increment i instead of hardcoding the 0 when calling
skb_add_rx_frag() the first time.

Reported-by: Aashay Shringarpure <aashay@google.com>
Reported-by: Yi Chou <yich@google.com>
Reported-by: Shervin Oloumi <enlightened@google.com>
Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 77e76c9efd32..440423b0e8ea 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -446,7 +446,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 		       ALIGN(hdr_len, sizeof(long)));
 
 		if (buff->len - hdr_len > 0) {
-			skb_add_rx_frag(skb, 0, buff->rxdata.page,
+			skb_add_rx_frag(skb, i++, buff->rxdata.page,
 					buff->rxdata.pg_off + hdr_len,
 					buff->len - hdr_len,
 					AQ_CFG_RX_FRAME_MAX);
@@ -455,7 +455,6 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 
 		if (!buff->is_eop) {
 			buff_ = buff;
-			i = 1U;
 			do {
 				next_ = buff_->next;
 				buff_ = &self->buff_ring[next_];
-- 
2.36.0.512.ge40c2bad7a-goog

