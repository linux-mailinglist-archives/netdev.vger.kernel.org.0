Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3C955421D
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357032AbiFVFNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356992AbiFVFNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7310335DF8
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:20 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h82-20020a25d055000000b00668b6a4ee32so11654608ybg.3
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=261UTc4ygE5ZNxBbiTD0X/wTjRF7aQkJ1aLKjWjIVn8=;
        b=p+9t8E5QOu1s/LB8JvD4VhI3LFV/y09LaTnJdaLMKcLZoph2IaYxySTtoJyugqGt0Q
         pywMnheABMGKW4kGhb75Nf+QMWGqQS7au1mWnJgGQS+zIsD+pz8m/EHLu560lSi6Hqya
         WdD0XYCdf4zFCFt3utYzDu1zKD5R869QRu18qXZYRFsj9pzFnmRn6EvtfaW3qjScOTDz
         IeiYwSvoaY9Mt0XlaTNEXQEg5m7dZXuG3Lcwn+937BTyYRD1o3HGnDC5HBDuueMP3y4N
         8QU6ARxXLsu47VDumq5rxRthMk0kXNK8wHAeFUui3vnEA2627C77+IM9nyJISX94yndw
         ieMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=261UTc4ygE5ZNxBbiTD0X/wTjRF7aQkJ1aLKjWjIVn8=;
        b=j1fh4/KhDDZ6NYjqrTgYP1Yn7ZdG6xGqdxAZIlR9zYnIMyinrbpSH0e27zYaQMWXjT
         Ga60gnyeW5wlXYGVLKx//d16GgQAu8TEzGTZ81ulmBgFpAYNPRdPUf0c7OiwK7JczLyB
         oZvtLwG4HFmg4cP9ld6JOBGYkJTVpptwoZUQ/QSkjSQYOXOuIbWQnGofqNcrB+ECpf6k
         iTQd3kNN23qaz1/SOPMFmoBY8oC91NfN8y0FVw9bp+8zh91y8lymHkd89zA/4yGZRpct
         hrC0A95wzNU4xWgiC6erp2hw8FnJMyJbDYg6/LkoJ2YgzhPzziwuNBFeiF5oaqRPSWR8
         /wLg==
X-Gm-Message-State: AJIora/3Vavd7vAopet3kXIad3DSa3HEw08dCPto/r7s1t/0nEXQmiYq
        B27VANBnNoM91ZUciW3XfSp4TwJo/mFi2Q==
X-Google-Smtp-Source: AGRyM1vmuZMmaK3j0K/7qGDDW2eWC0h74Q12D32T5ZwRYhLCZfZs3Il2vZdcU3VHnGuN2jMoNMI6GDQE3sT4kA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:e0c3:0:b0:65c:a85b:b546 with SMTP id
 x186-20020a25e0c3000000b0065ca85bb546mr1776479ybg.111.1655874799752; Tue, 21
 Jun 2022 22:13:19 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:47 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-12-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 11/19] ip6mr: do not acquire mrt_lock in pim6_rcv()
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

rcu_read_lock() protection is more than enough.

vif_dev_read() supports either mrt_lock or rcu_read_lock().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index a6d97952bf5306c245996c612107d0c851bbc822..fa6720377e82d732ccafa02b37cc28e0ab1cea07 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -559,12 +559,11 @@ static int pim6_rcv(struct sk_buff *skb)
 
 	if (ip6mr_fib_lookup(net, &fl6, &mrt) < 0)
 		goto drop;
-	reg_vif_num = mrt->mroute_reg_vif_num;
 
-	read_lock(&mrt_lock);
+	/* Pairs with WRITE_ONCE() in mif6_add()/mif6_delete() */
+	reg_vif_num = READ_ONCE(mrt->mroute_reg_vif_num);
 	if (reg_vif_num >= 0)
 		reg_dev = vif_dev_read(&mrt->vif_table[reg_vif_num]);
-	read_unlock(&mrt_lock);
 
 	if (!reg_dev)
 		goto drop;
-- 
2.37.0.rc0.104.g0611611a94-goog

