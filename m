Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B23652411C
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349402AbiEKXiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349387AbiEKXiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:38:19 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2995D19949C
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:13 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id x12so3077260pgj.7
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U26yQ/QwZQZC3YgBNZ7hODbV1h7xyPcCap1q8PQwiGo=;
        b=A+o/dBS6NwTMEfLGSDGh7XeKMjlpL/Zf5rXZjcgD7JIUbwpfexiUaj+NYw+iM75vuU
         iAHjg47DBAlR6bt5N6L92SvXO7JvHLNUp3bmvdiOO5o29fkYv2+Ry4G0P7rbJHiXV/yB
         KAuQBDLSQkazIY0S5V1A/Axt3NJUnnwV4n6zq7lDTs/zFPp77jQ2HExNkWvaX68YR3IK
         a2yk3dAYGlp/nK+P7AdVRwjZVpZPq+5V1XsCjutJYXzvcThTXr04qeNBwU67H+kUzUqs
         kpwGlhLccMS3JAEQp9iXyIFjIlbYCt8u8dEkZyIfG+x9qX0/qO1dP3so4369GX3XEGkF
         FJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U26yQ/QwZQZC3YgBNZ7hODbV1h7xyPcCap1q8PQwiGo=;
        b=l2JeYA+JfuWfCTibFLov0AVeOK2eoi0LVMLAJW5UTUUy/k2ZLcvsisclNPU66WHpp+
         S0v+yuLVK174Uk8eYgF1ujdIO/w4oi609eG+z35JYu+QUGlqs2VkWTLT4NzuD0r8dQLx
         g8IQokqVVkWd9ni1JOfCLt7JpZKKSGGOHti+JNxj8Z7FmwMWepGi/+fd5+OYvZXbt2fM
         Z2mBDUyM+sKCXViQcMonbwMs/5+Fl878VWdnqZEQoHV3uG5jOH+1V+M91Qto2dK9VRt6
         yFFfvR2Pem0RRP9bI0qOYZKW6pQ/brBpu3+EBq/fcv/iaaTWN/DYgJ0XM4H7hS21YZMM
         1xZw==
X-Gm-Message-State: AOAM531sFyh6KuKq3HDib/BFt7uEB0uXsIitGzwRQd6DdomF2nbrN8M2
        GByABmmJJWKfrIdQdWVR1Dw=
X-Google-Smtp-Source: ABdhPJzY5D6Q5YYLuWh+Vx3wTKOJ688KSrzL0sHyEGu0+YDA/FQD5oEuSl40Ll25ozWC01IvIZ9PfQ==
X-Received: by 2002:a63:1c5:0:b0:39c:c779:b480 with SMTP id 188-20020a6301c5000000b0039cc779b480mr22394235pgb.311.1652312292582;
        Wed, 11 May 2022 16:38:12 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4ded:7658:34ff:528e])
        by smtp.gmail.com with ESMTPSA id x6-20020a623106000000b0050dc76281acsm2308668pfx.134.2022.05.11.16.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 16:38:12 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 07/10] net_sched: em_meta: add READ_ONCE() in var_sk_bound_if()
Date:   Wed, 11 May 2022 16:37:54 -0700
Message-Id: <20220511233757.2001218-8-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220511233757.2001218-1-eric.dumazet@gmail.com>
References: <20220511233757.2001218-1-eric.dumazet@gmail.com>
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
2.36.0.512.ge40c2bad7a-goog

