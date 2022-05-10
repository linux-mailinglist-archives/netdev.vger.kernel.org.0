Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927E7520B33
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbiEJCcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 22:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbiEJCcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 22:32:43 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB141B0907
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 19:28:40 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id j6so12321617qkp.9
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 19:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bUbzj8GLC4jvUsYc0bHNPk/HK3W9TD3sIIfgXJoJyIY=;
        b=dKUkWB+BSsBV4LJQJgQQIGHHcr10pdJCgyB/PC3+Cizv5Xr6ZwuJgcoHpdJ2pIR7ca
         owKpDe8+vRmPfqytZ8SrTCheO3wx3rNEzMuzhhjeDJufu5ljhytYQOPTCL1SqPwOIbNT
         kAl0rEzPB3Kvxaw3Q0EXAUIly+pN51YVIZ6dI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bUbzj8GLC4jvUsYc0bHNPk/HK3W9TD3sIIfgXJoJyIY=;
        b=Xm6pLcVn5ACY58iPLXGfTYiAmoCxJsWvM1gf79+zq5Swf4HcWJPrmljUA5FI1LeP9V
         7O9itBWAcWOa/CB495oCR92zCDBZvBwbbIJvOyosrmgDxt4S6tcaNam689tomOONN7Ld
         zWIzE7/VmAms00I8uAxvWhjDPryHgPpduU6Wr6RRsikLKkAB3vfNLPa2lnomczzmQ1rL
         5wkPFurjtDXhgMWbvuceid6tkbZDeK/cSqMwa7UDwI0BRVUeVfCCFkvY9w8CJOXQW+9z
         MctqrWzuRSas9ZmUgIFBHJnSTU1KaHqiaWfLBBL2ju4J648ffwAFWrRn/8jj7Wzw0Ryz
         r2WA==
X-Gm-Message-State: AOAM5322PU/BrFrQxqO4GVQOnGiVplWoFpABDv89Y9YkyiIJjhf/MuYI
        z02yZt3lyvVKooWkywMIBVBdgQ==
X-Google-Smtp-Source: ABdhPJw8tInFnILG7NEA+kbxqihBOLVsR4MN4pD697DeaRfAj4WTH5Sbi9DVb3wLh49+sUea6CnPaA==
X-Received: by 2002:a37:a28d:0:b0:6a0:a446:703b with SMTP id l135-20020a37a28d000000b006a0a446703bmr4661918qke.661.1652149719908;
        Mon, 09 May 2022 19:28:39 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id 18-20020a05620a06d200b0069fc13ce213sm7742375qky.68.2022.05.09.19.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 19:28:39 -0700 (PDT)
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
Subject: [PATCH 2/4] net: atlantic: reduce scope of is_rsc_complete
Date:   Mon,  9 May 2022 19:28:24 -0700
Message-Id: <20220510022826.2388423-3-grundler@chromium.org>
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
2.36.0.512.ge40c2bad7a-goog

