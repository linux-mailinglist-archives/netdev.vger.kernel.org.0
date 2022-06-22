Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35AAC554956
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358003AbiFVLtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 07:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357933AbiFVLtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 07:49:17 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326113CFD1;
        Wed, 22 Jun 2022 04:49:15 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id i10so19271277wrc.0;
        Wed, 22 Jun 2022 04:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GeKRIUNZiapqoesYYpL5E5Sfq5smki4pt6O3TzGiQ/4=;
        b=jua111Kog8jaHp20p506KaJdFl1RP1h0t2nNf39UCKCOzv6dP8nlt77vxiDs6oNnZt
         2a51QMCR9hJFQYtuoMViaF/G9VjpkIRa09UNYerT9ghcjGLvlsR3fEszhSla5Cj2NFWq
         BHuzlJbP2pNd+vjYsfL52qnuKg3wckW7PieNKzgWef0WWhpyEx8D4ydXzybKXQzw00rb
         BwZg2NICx4hKFRAsFVKog0HCLieycERXbAT1N8mO9amRGLHY+M9Q5uHqZE3/NtouODw0
         U61cWrpYk5VsWYWTxyYKwiIpcbn2q7LI8Orc4YtC6cnf14i5nIiGeJOCVHf6XPdZhDfX
         qh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GeKRIUNZiapqoesYYpL5E5Sfq5smki4pt6O3TzGiQ/4=;
        b=144O50+bImh4GrCD7QblY5ah5ccA3UXJt4YH/5frGdEZw7/mO5XIxFzh8C6Ym6bex3
         iWZC9m1Uq8rvL5ujduxMyiOkIkDKU2/WYODuptRc+n4uA2EQLhCbTO2HsZC4DUK2Iv8Y
         MQ6Cvp944gZ35o08Mnjiij71teXy5Aoh+a+FG/IGoAqQy4GDKjmInrKmAx/Mxc2sdCFk
         Kiu+gtjb+nDi0dquIQvX6qHCuGwse0I4MeKEKYT2du6dl20ANta4Urb8Mdy/ExlXqkZ2
         opGoJbrYQQEZwQOwUC0aLLL4joyQFPro6T///dfrH6nf7oUSuDTi8x4usZi9qYKS1G+E
         TTYg==
X-Gm-Message-State: AJIora8tEujeidQGLeesFWU+74Z2Mm6TADqXuo5D5HfRRKIZqS/ZwLSq
        aKjVo5yqMa//7sBPDrna62k=
X-Google-Smtp-Source: AGRyM1uzLG/4PAZlFcKScgaPsiawG7aWBYZt5EYCDWMJ4XY7BWAmJ5MIAutRjvstEWMnTCAhyLGJ6w==
X-Received: by 2002:a5d:452d:0:b0:21b:81f6:d91 with SMTP id j13-20020a5d452d000000b0021b81f60d91mr2861224wra.521.1655898553669;
        Wed, 22 Jun 2022 04:49:13 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id be8-20020a05600c1e8800b0039c235fb6a5sm21389158wmb.8.2022.06.22.04.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 04:49:13 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] raw: remove redundant pointers saddr and daddr
Date:   Wed, 22 Jun 2022 12:49:12 +0100
Message-Id: <20220622114912.18351-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pointers saddr and daddr are being assigned and are never used. The
pointers are redundant and can be removed.

Cleans up clang scan-build warnings:
net/ipv6/raw.c:348:3: warning: Value stored to 'saddr' is never read
net/ipv6/raw.c:349:3: warning: Value stored to 'daddr' is never read

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 net/ipv6/raw.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 46b560aacc11..722de9dd0ff7 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -332,7 +332,6 @@ static void rawv6_err(struct sock *sk, struct sk_buff *skb,
 void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 		u8 type, u8 code, int inner_offset, __be32 info)
 {
-	const struct in6_addr *saddr, *daddr;
 	struct net *net = dev_net(skb->dev);
 	struct hlist_nulls_head *hlist;
 	struct hlist_nulls_node *hnode;
@@ -345,8 +344,6 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
 	sk_nulls_for_each(sk, hnode, hlist) {
 		/* Note: ipv6_hdr(skb) != skb->data */
 		const struct ipv6hdr *ip6h = (const struct ipv6hdr *)skb->data;
-		saddr = &ip6h->saddr;
-		daddr = &ip6h->daddr;
 
 		if (!raw_v6_match(net, sk, nexthdr, &ip6h->saddr, &ip6h->daddr,
 				  inet6_iif(skb), inet6_iif(skb)))
-- 
2.35.3

