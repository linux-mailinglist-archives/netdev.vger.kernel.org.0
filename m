Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E424AC93B
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbiBGTLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235571AbiBGTHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 14:07:11 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AC9C0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 11:07:10 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v4so7907010pjh.2
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 11:07:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m+zA+AgEiA/KVOvqqoODhw09tmQV1amJ2PzTzbLoxNU=;
        b=kfx6lEYMPttOhdwzhfTcsj5Oj0FDNc3VbuZ57uYvX0OtzdBqUBx1jQ011IpLw5ENf2
         PU3jVN0Ew1Bdk00GGPP6/CPDGQWuhg1fT7hBzjx6e720YXYM0jKgE+tYHTcVjaeeadXk
         +jAf2iZo+m9pTWD0sYY01OJROOzvoDkIgankpBbVzFDy9ByD17vjm89tLIY9MJsio30V
         2DLmH23obYj0TEcy0KkQANTek4rx4rJplkxPvKADCUPjjRlK90xw9CPn19XZI/kkdxwI
         g9+IMlRCin6NoPvGt3NnLOl1HEugG0K8uUNnJ0LxNe5ycnWxM6LigzajsaQ+RNteoHmZ
         pkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=m+zA+AgEiA/KVOvqqoODhw09tmQV1amJ2PzTzbLoxNU=;
        b=mab0zxXfBdsIxw/W5G6zNAF4zuPtkYEEn3UCMqTyoJqyMMra9NW0CAm0SruXrPQYXq
         NATTFZxVPBojhBxa3fPXgK/NsqHTkWmaKRtkFjBPriRhMCyIzi7mbui5lXJr9H42UGYB
         lTgKF1qZvtK1vSOlUGzK16qmt3nVppk0fXCUI4CwGwqlcrGCDoxp5lDJ/hzYDC8EFi0f
         a73au+Ppof1CQhWAsIo+0BY2gOV+XHh4P1Y/pWNzTM+xCFwmH/xiZ3akbcIF/09Q90DT
         DwKfLyLP9gwTFwMC4qyAHo5QwMOgMB06IbtXcH72otgXIu4rh55zhOX5v5BJtqgab/zd
         QSjA==
X-Gm-Message-State: AOAM530ukG1GTdbuuyxhyyu8TIazCj4+tI5H3R0ijD9N+pyr7ge3zh/V
        dQP5F2R08+69HG3PxHpj3VQ=
X-Google-Smtp-Source: ABdhPJy6V4IUSwPtWO56fxtMfAnMUdBL2FQMbzc96NXXchPp8wImoPZ3sX9/Vnk/Q8VNCx0OwkkXCA==
X-Received: by 2002:a17:90b:1e50:: with SMTP id pi16mr305153pjb.16.1644260829950;
        Mon, 07 Feb 2022 11:07:09 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6dea:218:38e6:9e0])
        by smtp.gmail.com with ESMTPSA id d8sm6115490pfj.179.2022.02.07.11.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 11:07:09 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH net-next] can: gw: use call_rcu() instead of costly synchronize_rcu()
Date:   Mon,  7 Feb 2022 11:07:06 -0800
Message-Id: <20220207190706.1499190-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
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

Commit fb8696ab14ad ("can: gw: synchronize rcu operations
before removing gw job entry") added three synchronize_rcu() calls
to make sure one rcu grace period was observed before freeing
a "struct cgw_job" (which are tiny objects).

This should be converted to call_rcu() to avoid adding delays
in device / network dismantles.

Use the rcu_head that was already in struct cgw_job,
not yet used.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/gw.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/can/gw.c b/net/can/gw.c
index d8861e862f157aec36c417b71eb7e8f59bd064b9..20e74fe7d0906dccc65732b8f9e7e14e2d1192c3 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -577,6 +577,13 @@ static inline void cgw_unregister_filter(struct net *net, struct cgw_job *gwj)
 			  gwj->ccgw.filter.can_mask, can_can_gw_rcv, gwj);
 }
 
+static void cgw_job_free_rcu(struct rcu_head *rcu_head)
+{
+	struct cgw_job *gwj = container_of(rcu_head, struct cgw_job, rcu);
+
+	kmem_cache_free(cgw_cache, gwj);
+}
+
 static int cgw_notifier(struct notifier_block *nb,
 			unsigned long msg, void *ptr)
 {
@@ -596,8 +603,7 @@ static int cgw_notifier(struct notifier_block *nb,
 			if (gwj->src.dev == dev || gwj->dst.dev == dev) {
 				hlist_del(&gwj->list);
 				cgw_unregister_filter(net, gwj);
-				synchronize_rcu();
-				kmem_cache_free(cgw_cache, gwj);
+				call_rcu(&gwj->rcu, cgw_job_free_rcu);
 			}
 		}
 	}
@@ -1155,8 +1161,7 @@ static void cgw_remove_all_jobs(struct net *net)
 	hlist_for_each_entry_safe(gwj, nx, &net->can.cgw_list, list) {
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(net, gwj);
-		synchronize_rcu();
-		kmem_cache_free(cgw_cache, gwj);
+		call_rcu(&gwj->rcu, cgw_job_free_rcu);
 	}
 }
 
@@ -1224,8 +1229,7 @@ static int cgw_remove_job(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(net, gwj);
-		synchronize_rcu();
-		kmem_cache_free(cgw_cache, gwj);
+		call_rcu(&gwj->rcu, cgw_job_free_rcu);
 		err = 0;
 		break;
 	}
-- 
2.35.0.263.gb82422642f-goog

