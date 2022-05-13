Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95A05269AB
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383459AbiEMS4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383447AbiEMS4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:56:04 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3986BFCB
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:01 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 137so8299177pgb.5
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=81G4T+QmKwuwMVNq2fbxbqAa3jbgn5JPe3T0rgFTknQ=;
        b=I6J6i4CU+WxNHLNysJLLGudVxa1buZIIWqgN4YB7eS21LdrSPMLDBQTuzS5TdGFKk7
         +Vl5bDAieSUM5X4jl7mbuHf1443gn8aK7FJ63Y3tA2hhZZQoDWtfvuEdR+4LDbumF6jb
         z1OEUFEE3fIrsbqw2fKfOCSlw89LLkUO1bbmWEdlHFlEidKhHYPM8aVNMtocUl/N8TUZ
         rgRZFptWhyl6EdavxKKB6TkK1eY6NdKaG/IyrtQ3dviiSkgVdskH/f1BOCvY1D0lzswz
         ing5qWv+ybzFdkzt7aoKG3r8WRlpVfy/99xs5gggKKV7H6BYh8nWy8RPBcpR167cKtyB
         CPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=81G4T+QmKwuwMVNq2fbxbqAa3jbgn5JPe3T0rgFTknQ=;
        b=ogUsl9f3eqLW7wuKOSprDza1KDUuI1F05Rdfv+3ariJ5K7Xlo4xIfdlF16m78UbP5V
         ROQec1LLU0rZI00T2bJVWA8lAoTJPOytNbu6sG/mEsb4OsTyr/luLSWOaC7sBIcTOi84
         bylbx/6bj0ZKqOcqMHkEwkvju56uojL+u9VVscCTodqvGWr/6SYT98vsG+5Q8oNcsenH
         rElDg/+qTedM1xLjJU1+aPcX4zUMXu1PqpuwlPBAy8jbT47ybvJY9CNJ85/OxX8FIJbM
         pSkqq/miRf+6Zrmoehvy17eb1r/R7Ue89BH1ZO2jhyZ58fK3Z5nZ5O0hEvsA1A9eTd8p
         4l7Q==
X-Gm-Message-State: AOAM531vKaCkj10ju/tDPCSjZJzGFmIHLUDXHu8bntaNx+8ET6/y9spo
        j4VgKS/4KDRVKvW5Kr36AuxbyEOYO84=
X-Google-Smtp-Source: ABdhPJxMHHtG59pPGpruuB1htwux8AZfFavR7849v5iFFP9N+w6JQJJ2HzQUulxJ5hn4aMjBOIIBiw==
X-Received: by 2002:a62:e80f:0:b0:50d:3693:43df with SMTP id c15-20020a62e80f000000b0050d369343dfmr6067466pfi.36.1652468161390;
        Fri, 13 May 2022 11:56:01 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c10200b0015e8d4eb2absm2159537pli.245.2022.05.13.11.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:56:01 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 05/10] dccp: use READ_ONCE() to read sk->sk_bound_dev_if
Date:   Fri, 13 May 2022 11:55:45 -0700
Message-Id: <20220513185550.844558-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513185550.844558-1-eric.dumazet@gmail.com>
References: <20220513185550.844558-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
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

From: Eric Dumazet <edumazet@google.com>

When reading listener sk->sk_bound_dev_if locklessly,
we must use READ_ONCE().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/dccp/ipv4.c | 2 +-
 net/dccp/ipv6.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 82696ab86f74fd61aae5f60a3e14e769fb21abf9..3074248721607541a707d2e27dc0dfb9ff68463f 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -628,7 +628,7 @@ int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 	sk_daddr_set(req_to_sk(req), ip_hdr(skb)->saddr);
 	ireq->ir_mark = inet_request_mark(sk, skb);
 	ireq->ireq_family = AF_INET;
-	ireq->ir_iif = sk->sk_bound_dev_if;
+	ireq->ir_iif = READ_ONCE(sk->sk_bound_dev_if);
 
 	/*
 	 * Step 3: Process LISTEN state
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 4d95b6400915db56e1058099e6d7015d2d64647e..d717ef0def64a9f3321fc53107f421b70a21bd16 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -374,10 +374,10 @@ static int dccp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 		refcount_inc(&skb->users);
 		ireq->pktopts = skb;
 	}
-	ireq->ir_iif = sk->sk_bound_dev_if;
+	ireq->ir_iif = READ_ONCE(sk->sk_bound_dev_if);
 
 	/* So that link locals have meaning */
-	if (!sk->sk_bound_dev_if &&
+	if (!ireq->ir_iif &&
 	    ipv6_addr_type(&ireq->ir_v6_rmt_addr) & IPV6_ADDR_LINKLOCAL)
 		ireq->ir_iif = inet6_iif(skb);
 
-- 
2.36.0.550.gb090851708-goog

