Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7B35269A9
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383464AbiEMS4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383455AbiEMS4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:56:13 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7975C6BFDC
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:04 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 202so8278443pgc.9
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d5D8Q+LOxDZKyXKyV0E9bG7L/yCxQeBI9J1yCtvXJSs=;
        b=GgZS4fFANbszLsJCc7K5kbqv27tdOgwjsTQg+1U6biokOUtdqTjVcc8FHF74uT2OWv
         9baz9t7Av9ytiYaOFdXxXCYJpyGOPBgm5/AVw7qGTGucCX3HXfSIs1XVkb31AlKfbRAf
         qPC8KB8ZlzIBQgCm8zKFNZNZOo9byLZGqDlf3QzI1W9lXIkQ5ABhD2VX5oFBl0LbelJl
         A7i/18WXXtmQEX0Ts92Bmw8wMa2ZJ3C1WH/+lcTydFO5jYb9e7h249jk0AuAjUsJgs3f
         SODrjeQ13UTn+CsogTjH6ac+g/Le4rC5QomeY2uysaEdDaPww4DujCv32K6wYkQn/InO
         jQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d5D8Q+LOxDZKyXKyV0E9bG7L/yCxQeBI9J1yCtvXJSs=;
        b=jRJVdG6C8/SxS+rmk90ywouZ5QzeW6mHiAUttRwGWHKRu4yFdk16jFuvOvon0rHsz0
         xKnRHjrF5Jed731arhl2Ky1m3jRAFxeVa8ppDvJ3vbFz4+PF5X6shR90F5qh7QkLI9jm
         x0t3HhZXvdNC6Lr6CigSW33UrMe/rWwpJUPheAO7OVFCFCvfDUrITkEQb9ez7azAIqgk
         vodgZ4iA7WOgWNOMtscVN2nOjtaUGv0xh9tpfCeJxdNoDRMfDpOHDVh6NgCG6CBJ4lf6
         cPeorLtQd+sKO1bRlO1o9vK/D3oyx4L6bm6cls3magkTx61il1l0iTYoWyEcROXvmIqM
         xyUw==
X-Gm-Message-State: AOAM530oXADyWaGzFghBDbV2KbBhmW1+2JVaPuemOmaXe9jPF7dSPDFu
        r3LdbiyWFqaNAwNG+6HnAV0=
X-Google-Smtp-Source: ABdhPJwhMfrR2M7qu9ddY2U+G2f77d6APb2MpxAVy0+EQcBYvIT2LcL0tVqzGP2zyc6Fbzs4nIBaag==
X-Received: by 2002:a05:6a00:10cc:b0:4fe:3f1c:2d1 with SMTP id d12-20020a056a0010cc00b004fe3f1c02d1mr5802765pfu.0.1652468163998;
        Fri, 13 May 2022 11:56:03 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c10200b0015e8d4eb2absm2159537pli.245.2022.05.13.11.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:56:03 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 07/10] net_sched: em_meta: add READ_ONCE() in var_sk_bound_if()
Date:   Fri, 13 May 2022 11:55:47 -0700
Message-Id: <20220513185550.844558-8-eric.dumazet@gmail.com>
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

sk->sk_bound_dev_if can change under us, use READ_ONCE() annotation.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/em_meta.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index 0a04468b73145546097788db0645ef9e5b459bca..49bae3d5006b0f83330b4cbe30344c0741743575 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -311,12 +311,15 @@ META_COLLECTOR(int_sk_bound_if)
 
 META_COLLECTOR(var_sk_bound_if)
 {
+	int bound_dev_if;
+
 	if (skip_nonlocal(skb)) {
 		*err = -1;
 		return;
 	}
 
-	if (skb->sk->sk_bound_dev_if == 0) {
+	bound_dev_if = READ_ONCE(skb->sk->sk_bound_dev_if);
+	if (bound_dev_if == 0) {
 		dst->value = (unsigned long) "any";
 		dst->len = 3;
 	} else {
@@ -324,7 +327,7 @@ META_COLLECTOR(var_sk_bound_if)
 
 		rcu_read_lock();
 		dev = dev_get_by_index_rcu(sock_net(skb->sk),
-					   skb->sk->sk_bound_dev_if);
+					   bound_dev_if);
 		*err = var_dev(dev, dst);
 		rcu_read_unlock();
 	}
-- 
2.36.0.550.gb090851708-goog

