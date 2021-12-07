Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9F146AF6B
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378748AbhLGAz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378742AbhLGAz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:27 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE0DC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:51:58 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id u17so8233149plg.9
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=POVsHtE5goGeXMDmUT4eCInTWhGc9g0JPMiRMUW/pEs=;
        b=iPDo0iNyT0phH4vtrt0xm9FE3B5Fl9+9UGZbrh65DNgfmxwLSIPJoX17GkLbOvQLVG
         Hn6E2hO2fWc9Vt9iP+S0mA6lIWq1gkilvYj1zilJkSYYotbDpq4VtJOQ7hS0wyJrv9Do
         DEZqhRnb2HA4oXMHgJ7TpOw6YowVYhLZq110TZvi6FrzFcTUpqVrWiR7Ka0phyKyOPFi
         uIPE6buDCdKWfVWgtjPMnq4xom36gWfA8Sb1nAYDJPx7ercdeNdIQ8deoo39iBgKz1Sr
         SGzPQTNVBmJ/qH1K34y+y4+oV847gSMVBr79EUug28Xz5vISCBKObXtCUiAQKdMz70z3
         jF5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=POVsHtE5goGeXMDmUT4eCInTWhGc9g0JPMiRMUW/pEs=;
        b=UDbMvJHQwHrf5oGMSf+omwrmve79YZMr1nzi4J5DnfPtWfvOroOnf1uzLnwccRLCSA
         clZqJi8kz9LKlVAyGr//Kk40Sp4+/MuMevjlvbb7TyrSjbA3fjglt2JF+9N1YJljlmm6
         LQ3h5KkWm1bvP+TXHPTqxqj5j7LRRjVIqsHp2mtvd0J4oBeMFVicH7W1txyc4Iwc1cs5
         J5bQPs+MnGTgUBHoUtRmf8Z0kOX2zAN8/OOARTBSwA9kbvOxybUiVAGIKhZP7CzczWwI
         QSgZ3BQt16duOXsQoUElRcU3mi6oroUFU4+e3AhRxxUn1io+Ny04u9zPQzgQ6ND2UViM
         JP/g==
X-Gm-Message-State: AOAM533C2TWsZpCydFa4FDpQgINiseXM2N2yhsSS/qgDxuOdmaKQQK/D
        XSIwxVDW+ayPyWhKAiWXC+k=
X-Google-Smtp-Source: ABdhPJxMaWPNId/XUHtvwHWlB1YZIqt203RpzSslR0l3StolvOAXq/49aba2ub4V1DVzoQ/xCBfF4Q==
X-Received: by 2002:a17:90b:4c44:: with SMTP id np4mr2543243pjb.195.1638838317636;
        Mon, 06 Dec 2021 16:51:57 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:51:57 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 05/17] netfilter: nfnetlink: add netns refcount tracker to struct nfulnl_instance
Date:   Mon,  6 Dec 2021 16:51:30 -0800
Message-Id: <20211207005142.1688204-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207005142.1688204-1-eric.dumazet@gmail.com>
References: <20211207005142.1688204-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

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
2.34.1.400.ga245620fadb-goog

