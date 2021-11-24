Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A2E45CDEB
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhKXU2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbhKXU2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 15:28:02 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92867C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:24:52 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso3784456pjb.2
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 12:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s43d+9BX0Hd2V+V+j1yYegEqFVRTQMe6t+GR06hayE4=;
        b=EkGt3KflMVH7V9XvOSevppAguHlLLP2s2TNqbyGc98y3SNZmdUj1P0pzbY6dOn+H0e
         j7x86hpnt3nKclMZMZOJf9U7mEMln6+Z1yd2NF5R3lnBiUCfve2EkyOb4OUW4leHEd5E
         r/EAOha3Zi4IkL96fN2nBe3vRVv/hXVBc5C/uvi/ujxkNg6eXsail9zAStVNoANn8z9O
         ygLWkAF5vG/SP4qyKvdGB7yKM5xebdln5hSYU8vKPLXSJUDiYkRg2jNUQ2JNjZ+YPDBg
         Cz1rPZbYlBANgyaWWMzysIGIrQE34kzJiMaYJZl3ZeszzWQJxZqTDtrJxdST6QPq2F2p
         XzBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s43d+9BX0Hd2V+V+j1yYegEqFVRTQMe6t+GR06hayE4=;
        b=fqhT6ORrUe5uYIj3SZQsVNxxjH6yZmBnu6+0i8RxNavCe0dvq/bgpJIM/sNCalgS4F
         a25jnl71lUO638YRbuVOzLFfiaDFmRbqvbmQ3nY8wd/wVkh86MjUQ9VOUVIItro9+/cP
         eV6nvMKdzbTDf1Ky1cdbq6pcuCMUDE608WTqtn5DC7XYJrgdNMrA+Pf24Z19jsE0Ya4s
         6rRZpsQTvK+ajeGmqn7cGLSBMqlAzJHZugAtv1dDZA5A2Q1uNDO47w7Itgmzc6PyoLiS
         eueb0PHqY75WZkyCiEG6vnvYHMgvyj9+aWD4o2O4/bTeIAJM6LSJ/vevE4PRW/8NRa33
         m4Zg==
X-Gm-Message-State: AOAM530n8qnsVnhTiCM7o9g9YxA348QHC4K7NeBvFZ3QLuxj8dMTX09Y
        pkoQfuaBPFELc+knmx8W1sk=
X-Google-Smtp-Source: ABdhPJxiA5wy6IWv9iIHKcKTT1SRXMunoaKqOXcXWwRheaCrg9Q87i6E7eFACl4z9gXgjFE8ifkGcQ==
X-Received: by 2002:a17:90a:f481:: with SMTP id bx1mr19694698pjb.117.1637785492154;
        Wed, 24 Nov 2021 12:24:52 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b6ed:6a42:8a10:2f32])
        by smtp.gmail.com with ESMTPSA id i10sm472839pjd.3.2021.11.24.12.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 12:24:51 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/2] gro: optimize skb_gro_postpull_rcsum()
Date:   Wed, 24 Nov 2021 12:24:45 -0800
Message-Id: <20211124202446.2917972-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124202446.2917972-1-eric.dumazet@gmail.com>
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We can leverage third argument to csum_partial():

  X = csum_sub(X, csum_partial(start, len, 0));

  -->

  X = csum_add(X, ~csum_partial(start, len, 0));

  -->

  X = ~csum_partial(start, len, ~X);

This removes one add/adc pair and its dependency against the carry flag.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/gro.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/gro.h b/include/net/gro.h
index 9c22a010369cb89f9511d78cc322be56170d7b20..b1139fca7c435ca0c353c4ed17628dd7f3df4401 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -173,8 +173,8 @@ static inline void skb_gro_postpull_rcsum(struct sk_buff *skb,
 					const void *start, unsigned int len)
 {
 	if (NAPI_GRO_CB(skb)->csum_valid)
-		NAPI_GRO_CB(skb)->csum = csum_sub(NAPI_GRO_CB(skb)->csum,
-						  csum_partial(start, len, 0));
+		NAPI_GRO_CB(skb)->csum = ~csum_partial(start, len,
+						       ~NAPI_GRO_CB(skb)->csum);
 }
 
 /* GRO checksum functions. These are logical equivalents of the normal
-- 
2.34.0.rc2.393.gf8c9666880-goog

