Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF59767C9B7
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 12:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237183AbjAZLVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 06:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbjAZLVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 06:21:37 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDFA42BCC
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 03:21:36 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id l40-20020a25ad68000000b0080b821fbb0fso1513376ybe.13
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 03:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yoK/OuL8Uopxla38Ngsd7+3bS1G/swwXI7HzDGauVRQ=;
        b=qyI9uf18XKPjAsb2v1eUEuVqAibJfRpaxoVwUJUz9uCKRd5wVLW+Yf8yc/Oe+KgLg0
         R4eVDXiisZgTQJ+1ti92Xhq3jV/QLdyvjx04IzBWayXCApiS1JpCeIZy2wVhTvTt1ucK
         nho444pfF1ZXyrXcb7WE7vNNH8MX5WDGEeq4FUUTjJFO4+TeaISOBRakqhdLrTnsQa+r
         uVDbCKetZHzRwXfm699Y5s8m5GoUsym8U+Pyb7Qw5VxiDzZ+SzS7KRpHK79eUZeTIAo3
         qB9PAonFyEUkszZ4/oB0VGxAjRCtWoQHrxUE1poKt+erVP0FJAps15BBp8xuUwFfyEWI
         rrRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yoK/OuL8Uopxla38Ngsd7+3bS1G/swwXI7HzDGauVRQ=;
        b=qdLCffkKeWru+fwxvl1GGnVRd6lCbjMJZ/+e38wJc8rUfYppwaxLrY+ERpUpUAuXS2
         6o0/Aandz3/0ubSmcpFXz37WtJZp1tG8TGQgtrekVIzVyLg8ShbHe83t7gjqJkPvBkA4
         BJUp8Qsrl7YnjKgJlPIxpnZGUFlWduEPY/S7M5Sp57j6NCtTJ64iVStHAcsXjt58D8RX
         hgBuGxxxXB7nOw2xXNd6TNBSXwdOCQzefEA4vLkaJwO5huS5cU8oNVVxOAVxuNnKyHPg
         F4dJPm19u5eV6cKmtRzr8zOfUaUeCsYfVgkENDeLMuPrWkgaehGhlm2/c75vNvpCj6ia
         iWMQ==
X-Gm-Message-State: AFqh2kojI+hnMZ7kBONH3AVbE1DXsOWvWh5yMY3KwqdcM6UcqlJpG4BJ
        Wso+b+Hz1lhCd5w4SI9WkmN2dv87h4fuUw==
X-Google-Smtp-Source: AMrXdXtVWGEvsvJ5kNhaxQvEk5QeHCKi6QKDBC7oN1TpWYYg1bP7jWjKFJqsEq74vWMYZB1udZpDLXarsPNkSw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:1009:0:b0:71e:d3d1:953 with SMTP id
 9-20020a251009000000b0071ed3d10953mr4958849ybq.214.1674732095533; Thu, 26 Jan
 2023 03:21:35 -0800 (PST)
Date:   Thu, 26 Jan 2023 11:21:29 +0000
In-Reply-To: <20230126112130.2341075-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230126112130.2341075-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126112130.2341075-2-edumazet@google.com>
Subject: [PATCH net 1/2] xfrm: consistently use time64_t in xfrm_timer_handler()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Arnd Bergmann <arnd@arndb.de>
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

For some reason, blamed commit did the right thing in xfrm_policy_timer()
but did not in xfrm_timer_handler()

Fixes: 386c5680e2e8 ("xfrm: use time64_t for in-kernel timestamps")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_state.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 89c731f4f0c7283e28fc7697c8729a5d1064da97..5f03d1fbb98ed79900f61c783eba34dbfd99abfe 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -577,7 +577,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 	if (x->km.state == XFRM_STATE_EXPIRED)
 		goto expired;
 	if (x->lft.hard_add_expires_seconds) {
-		long tmo = x->lft.hard_add_expires_seconds +
+		time64_t tmo = x->lft.hard_add_expires_seconds +
 			x->curlft.add_time - now;
 		if (tmo <= 0) {
 			if (x->xflags & XFRM_SOFT_EXPIRE) {
@@ -594,7 +594,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 			next = tmo;
 	}
 	if (x->lft.hard_use_expires_seconds) {
-		long tmo = x->lft.hard_use_expires_seconds +
+		time64_t tmo = x->lft.hard_use_expires_seconds +
 			(x->curlft.use_time ? : now) - now;
 		if (tmo <= 0)
 			goto expired;
@@ -604,7 +604,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 	if (x->km.dying)
 		goto resched;
 	if (x->lft.soft_add_expires_seconds) {
-		long tmo = x->lft.soft_add_expires_seconds +
+		time64_t tmo = x->lft.soft_add_expires_seconds +
 			x->curlft.add_time - now;
 		if (tmo <= 0) {
 			warn = 1;
@@ -616,7 +616,7 @@ static enum hrtimer_restart xfrm_timer_handler(struct hrtimer *me)
 		}
 	}
 	if (x->lft.soft_use_expires_seconds) {
-		long tmo = x->lft.soft_use_expires_seconds +
+		time64_t tmo = x->lft.soft_use_expires_seconds +
 			(x->curlft.use_time ? : now) - now;
 		if (tmo <= 0)
 			warn = 1;
-- 
2.39.1.456.gfc5497dd1b-goog

