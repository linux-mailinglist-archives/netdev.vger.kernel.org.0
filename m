Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB656BB832
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbjCOPnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbjCOPnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:43:00 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD45B7A928
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:56 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536d63d17dbso205520837b3.22
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678894976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FIZYIEauPwwiaTeaz6iQAPztD5zSSpkzaJXr8Sk0BNI=;
        b=rNRpkAGWv/tmql8p9E7CGU3wa4F5nSx8RF10EsG3J7RSkkd3A3O+QSv/jaFvUfbtv8
         JYMEhLsy/g9SZnwPVBWPR4HxIb/xgskdp7uuhU05uQGuZoZEa8eHnYEwIoFA9M3i/LUt
         Ix8ocWe1u1iDDeG84rA7P682r0gCJaXujIHr6MBgWbSem5SGoxMdfhtGo87bItiYdlZG
         vbxEsmBh0iNhI9aghKayJgXMMnorXFz+W0Ix5UF37U0g+4jk8xAV1wDCdNQyfGDHDGjN
         nGWUnY0n/iZNXalX9gNhfssK/S9qwlsn0+7twL6bfWQNXNCXdHBj0WSWhcE+OejjaABL
         R2VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FIZYIEauPwwiaTeaz6iQAPztD5zSSpkzaJXr8Sk0BNI=;
        b=5si+XVORh3K+OG0Nu/yhf4RqP8rOLOIY2gMzvAkZGMxbo/EgtuEfnsgSNddLs0uxv7
         a7TqvGTcv604Ne5mXHCl4z4Ey4kjyciIAn4DLFBDxPe11FryNCWNBid51QiGf0HN0IAi
         /IHIx5SXTuyCipEvUoJNL1/5suSyJj5PUNYR/0nxbaW1mErtYw8w3hPK8bXOs9PHm9Bv
         hO1zJ5u4/asf/msPDpe1S3nLER+DvEak9hsWqCcTuXYrt8j9FfsN54bySm7qxpNQubQr
         uTyEuss9S8Lsjr5/uvip2OGyMsSGNo72Hqo+hCC+Lb1GKc5r8oQ5yD1vTrf7JMSssuMb
         6gAQ==
X-Gm-Message-State: AO0yUKUtOUxzEifYH+n8vLhWPQ86zq3QTGfxKpz9/maHOmgELdq0hK3H
        kpDKdaXw4tuwgb2A5FzAdUk8BVLQ5CKmIg==
X-Google-Smtp-Source: AK7set8ERm1PuXCVRKG19uU1hTvZMQaP9dOUy4OOhID7ZgVW0nfTGNCwAftqBUee604yya8VkgEAfamBKBaNQg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:185:b0:9fe:1493:8b9 with SMTP id
 t5-20020a056902018500b009fe149308b9mr21646433ybh.8.1678894976153; Wed, 15 Mar
 2023 08:42:56 -0700 (PDT)
Date:   Wed, 15 Mar 2023 15:42:43 +0000
In-Reply-To: <20230315154245.3405750-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230315154245.3405750-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315154245.3405750-7-edumazet@google.com>
Subject: [PATCH net-next 6/8] ipv6: raw: constify raw_v6_match() socket argument
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
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

This clarifies raw_v6_match() intent.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/rawv6.h | 2 +-
 net/ipv6/raw.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/rawv6.h b/include/net/rawv6.h
index bc70909625f60dcd819f50a258841d20e5ba0c68..82810cbe37984437569186783f39f166e89cb9b8 100644
--- a/include/net/rawv6.h
+++ b/include/net/rawv6.h
@@ -6,7 +6,7 @@
 #include <net/raw.h>
 
 extern struct raw_hashinfo raw_v6_hashinfo;
-bool raw_v6_match(struct net *net, struct sock *sk, unsigned short num,
+bool raw_v6_match(struct net *net, const struct sock *sk, unsigned short num,
 		  const struct in6_addr *loc_addr,
 		  const struct in6_addr *rmt_addr, int dif, int sdif);
 
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index bac9ba747bdecf8df24acb6c980a822d8f237403..6ac2f2690c44c96e9ac4cb7368ee7abdbeaf4334 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -64,7 +64,7 @@
 struct raw_hashinfo raw_v6_hashinfo;
 EXPORT_SYMBOL_GPL(raw_v6_hashinfo);
 
-bool raw_v6_match(struct net *net, struct sock *sk, unsigned short num,
+bool raw_v6_match(struct net *net, const struct sock *sk, unsigned short num,
 		  const struct in6_addr *loc_addr,
 		  const struct in6_addr *rmt_addr, int dif, int sdif)
 {
-- 
2.40.0.rc1.284.g88254d51c5-goog

