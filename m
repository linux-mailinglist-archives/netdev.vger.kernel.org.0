Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF3754731FC
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240938AbhLMQkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:40:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbhLMQkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:40:06 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA24BC06173F;
        Mon, 13 Dec 2021 08:40:05 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y8so11578708plg.1;
        Mon, 13 Dec 2021 08:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lxOuteE2e2VwZEMPoNVGi1WADgcDfEtTyVVKRokDP5I=;
        b=Tnp16x3HzN802eSAqxZdDTggs6MWwMVMeGDByE/lSqEUETf0WJRfYJUBkpPwmOFSQn
         7kERFDGvwo9aoYheODGlZ1JmYJqBGaAo6I+lOeIE+kswBi+X72OBb7GglOt4Ws0a1igZ
         3OAwuik5R3JR7XXULnWEtDR6Bjxsrk6U1AEtk5/BTUdc3Qb4F21g3dmwTQONw6HHvQn+
         ptfpA6ifFms2+8t7EM88XF8U189+HB4LYWcF6gYJqHtQYlVXHjxI4/KzrM+4+2rMfygt
         LVWRkQCCh4tW1GSnP4qlPsZHqP4Ib4HjUxduNKERl8V41qqau0S+xhwo1pGC9jG+nTdG
         oNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lxOuteE2e2VwZEMPoNVGi1WADgcDfEtTyVVKRokDP5I=;
        b=XaLT+WUyfPxqH9ChhYaD1yxWBWFnyTULgEM7zlTgjt8BTFc7YDTxi6+gUmGcZK/z8L
         mJC7C/zuc/npy8wHmNItyqHVjTp3m/g/tQLerDaSzHCsZLydtWiGSeOxEWRgacvFo3vj
         RkGKgsy76ikYdde99jJjAuunciIrt8SH/CGx+3EW3b+7Gnq9Fp9SiVWzQhfcA7M9w3ln
         aTVGZudXMLHEIGwERJ6Bjii/RW1JosBMRPkwlTeMtsv5ms07hP2BzL9ZqiviBgwN4FE/
         BEMawQDriHSQ9oV+bdFcoWxdwmg6LOnDYPxCRa3ww/peKPPso9z5WZtDLuQAJLExorxm
         pQfg==
X-Gm-Message-State: AOAM530hbE1hXpotHM6OWYHPZnMGrb1Iu1zucisadUNJuQwOLasZ72Jc
        f93fn2q3jWtppvq91EJ+eDA=
X-Google-Smtp-Source: ABdhPJzjSDpkGy7stBQY7XRpfJb94sVKYuwSgYBAUE8tfIrPPQ5pUWsQKC8oOFdjEk9HlWbns9yz7Q==
X-Received: by 2002:a17:90a:be10:: with SMTP id a16mr45049751pjs.133.1639413605110;
        Mon, 13 Dec 2021 08:40:05 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:84ea:43e5:6ccb:fc65])
        by smtp.gmail.com with ESMTPSA id 78sm1556239pgg.85.2021.12.13.08.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 08:40:04 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/2] netfilter: nfnetlink: add netns refcount tracker to struct nfulnl_instance
Date:   Mon, 13 Dec 2021 08:39:59 -0800
Message-Id: <20211213164000.3241266-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

If compiled with CONFIG_NET_NS_REFCNT_TRACKER=y,
using put_net_track() in nfulnl_instance_free_rcu()
and get_net_track() in instance_create()
might help us finding netns refcount imbalances.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nfnetlink_log.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 691ef4cffdd907cf09d3a7e680ebe83ea5562ee0..7a3a91fc7ffaaf7c632692949a990f5867173e5c 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -66,6 +66,7 @@ struct nfulnl_instance {
 	struct sk_buff *skb;		/* pre-allocatd skb */
 	struct timer_list timer;
 	struct net *net;
+	netns_tracker ns_tracker;
 	struct user_namespace *peer_user_ns;	/* User namespace of the peer process */
 	u32 peer_portid;		/* PORTID of the peer process */
 
@@ -140,7 +141,7 @@ static void nfulnl_instance_free_rcu(struct rcu_head *head)
 	struct nfulnl_instance *inst =
 		container_of(head, struct nfulnl_instance, rcu);
 
-	put_net(inst->net);
+	put_net_track(inst->net, &inst->ns_tracker);
 	kfree(inst);
 	module_put(THIS_MODULE);
 }
@@ -187,7 +188,7 @@ instance_create(struct net *net, u_int16_t group_num,
 
 	timer_setup(&inst->timer, nfulnl_timer, 0);
 
-	inst->net = get_net(net);
+	inst->net = get_net_track(net, &inst->ns_tracker, GFP_ATOMIC);
 	inst->peer_user_ns = user_ns;
 	inst->peer_portid = portid;
 	inst->group_num = group_num;
-- 
2.34.1.173.g76aa8bc2d0-goog

