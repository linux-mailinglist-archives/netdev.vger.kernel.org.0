Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52DCD554220
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356923AbiFVFN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356932AbiFVFNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:20 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B970435DE7
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id d6-20020a256806000000b00668a3d90e95so13749688ybc.2
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RObd3TiRkqvkoKMe+QwcB26i+/ARD+OA3IafA9Z7HpI=;
        b=fupddBHJrPixwqHCGwFKlw24Nz7HiqjO6n4cZuLnawpMh9lsheWvBHlanw2AY+1BW5
         F3lrADz9q1daIJfLOGzU+LV+XuKRZ+9ula5KdwY0IW/OzcsmvSSbTgj+Zx6/HCzFUY3+
         NhguBFjcxMpYLOjqHMtL9FuRi4Td105NzpvGuIxg1pediMmZ/rxYUg12RGx4D2nXiGF5
         hK/lFdSWJPSrV+csmSRzUBH244qoq72JXiNDT2EQ8vD4AUDx1J7AcTOSrl4Pv0UVe8bY
         AzaGc1wbt2hSXq2hP+uob0RUK1cUAEvIwx02V4cZq5vaUJkurJIAJA0OvuOTpBtCi7kx
         oHZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RObd3TiRkqvkoKMe+QwcB26i+/ARD+OA3IafA9Z7HpI=;
        b=s1NSkHgjvEO+uaV2aqfBmpOxmQMWdQAh9OrFPJLv1tvhqk7f88xKkisqTzO80HWw0L
         EDywDW3oxHGn6tOqysnv1/pmou1j/flWGGe+BkFC3A0gcoGjHtjawCXsljXxMq2pzQvd
         G80CDc+IlCYWqcpCE4+BlkTt+y6yc0j+m7ek5SbX99POVnknBnvGqkZ1XP4VuOrUMyOn
         bi/64rq68vn00YFPEzaEiL19+DvAn5fD8xU7X4ozOVA7nsR/x1e1iRd//mfxwqdDgXRI
         G87weoHylzajsQi4T8i+IHCx0nUuXeULrA6og7M/yxDY9qk38mOD6Ks3psSd8KMQz+8q
         0GHg==
X-Gm-Message-State: AJIora/zJKVl4xamrwxFI2ZeErTF1nGdi8Z+oF/tAdsG2PJGWLO0DDuW
        QFcUjtN1YTCW10kCiGG+7/+Y8zayeTHUPg==
X-Google-Smtp-Source: AGRyM1t9LgNI2Pp2O85WHOAa1mqMTDEfX/dSnyhXIMCOf+8WbypzLxmelPscWCM6DiwgtSCiqi5VKRg6h+HHDw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:246:0:b0:619:5651:3907 with SMTP id
 g6-20020a5b0246000000b0061956513907mr1884945ybp.190.1655874796065; Tue, 21
 Jun 2022 22:13:16 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:45 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-10-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 09/19] ipmr: do not acquire mrt_lock in ipmr_get_route()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mr_fill_mroute() uses standard rcu_read_unlock(),
no need to grab mrt_lock anymore.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/ipmr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index b0f2e6d79d62273c8c2682f28cb45fe5ec3df6f3..69ccd3d7c655a53d3cf1ac9104b9da94213416f6 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2289,9 +2289,7 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
 		return err;
 	}
 
-	read_lock(&mrt_lock);
 	err = mr_fill_mroute(mrt, skb, &cache->_c, rtm);
-	read_unlock(&mrt_lock);
 	rcu_read_unlock();
 	return err;
 }
-- 
2.37.0.rc0.104.g0611611a94-goog

