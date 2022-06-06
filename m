Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4674753E3C2
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiFFHJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 03:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiFFHJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 03:09:34 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DEB1483D4
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 00:08:56 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id v11-20020a17090a4ecb00b001e2c5b837ccso17112215pjl.3
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 00:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/g06ri91gcDq+dUl5GDKQbzhNsogCkqnJb9f6Snl5+Y=;
        b=F2VQPWgHZ8MelxSR29E7VbhkeMe49UxeXitK3UfHb8lvzzWzVwNYgJopaaHXHgx5Ph
         Ttr1NatH44PejImufLnSVTHjrY0k8QJVHRxZzmpRySezUGPWl1tT0LWZ9/pVo+++kSlD
         cVJEgCOGoGQMf1R40IxEIEOcERi6jDFBYc4cicK6wmFgn/jaJ7lxS1RUCKKYksYls17K
         alJ6ivV27ObyTX206FbgmE/GDMVEvF73yslAhyOs3ZcE+ZuV2Il8qkkG3C/d6k8bqd9P
         /KT7sKy+86QT8vi4hE7LMokguw3htg+Rxb9PPfvR8BleI3uz2owmSOdOhWvVYGlzi0fc
         4gVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/g06ri91gcDq+dUl5GDKQbzhNsogCkqnJb9f6Snl5+Y=;
        b=dAThjYQPWZ6Efo5KOK0LLGztpwcyc4YqLWmi+sEqZ2oX+jC6mduz7gTosNLVP6YlPC
         Ciz+0eVLpnCaAHfXRas3CzHCa43h/JmDTzam+1mQzPL0T4jKqOb4BoaZGIgp93up5EdV
         h2YLASFd1WGpB95NWe3BgvMnYx30bW/Mj5zb6FE3sO0pVeWT6lb0BYX7gRRartC1gklW
         jlmIpVioXFHIWfun3+KJCIAyHqmiV8tTuciXHT4xa1PplUZDDOk46rRyOlS+2YwfRGZy
         INIOoOH5qqcpLiqfDu0DdnSDfSzj/+kh1tBbGMQn6F8JlAzsozDQ93pdAsaUYzvBHa++
         9oog==
X-Gm-Message-State: AOAM5339vcqVWZisxyurFkzcmKo8I/Jayq6KcyPaDwrE4VJT7v5m+b0C
        NL+WXtKEarDAwdFoowywYgEeLQ==
X-Google-Smtp-Source: ABdhPJyxE2eFURF1XmViefIWqreeax6uCzG1fbwV19n2hVHPUM3tTURVpWUgC9Jw/Oyaq3bDTkc4Hg==
X-Received: by 2002:a17:902:9a42:b0:158:bf91:ecec with SMTP id x2-20020a1709029a4200b00158bf91ececmr23160787plv.115.1654499332775;
        Mon, 06 Jun 2022 00:08:52 -0700 (PDT)
Received: from FVFYT0MHHV2J.bytedance.net ([2408:8207:18da:2310:7cb7:47eb:4eca:56f3])
        by smtp.gmail.com with ESMTPSA id z27-20020aa79e5b000000b0051bba3844d2sm9548497pfq.162.2022.06.06.00.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 00:08:52 -0700 (PDT)
From:   Muchun Song <songmuchun@bytedance.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] tcp: use kvmalloc_array() to allocate table_perturb
Date:   Mon,  6 Jun 2022 15:08:04 +0800
Message-Id: <20220606070804.40268-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In our server, there may be no high order (>= 6) memory since we reserve
lots of HugeTLB pages when booting.  Then the system panic.  So use
kvmalloc_array() to allocate table_perturb.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 net/ipv4/inet_hashtables.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index e8de5e699b3f..1ecbfdebc6bf 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -1026,8 +1026,8 @@ void __init inet_hashinfo2_init(struct inet_hashinfo *h, const char *name,
 	init_hashinfo_lhash2(h);
 
 	/* this one is used for source ports of outgoing connections */
-	table_perturb = kmalloc_array(INET_TABLE_PERTURB_SIZE,
-				      sizeof(*table_perturb), GFP_KERNEL);
+	table_perturb = kvmalloc_array(INET_TABLE_PERTURB_SIZE,
+				       sizeof(*table_perturb), GFP_KERNEL);
 	if (!table_perturb)
 		panic("TCP: failed to alloc table_perturb");
 }
-- 
2.11.0

