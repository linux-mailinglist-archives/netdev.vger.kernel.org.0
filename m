Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341B05717CB
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232925AbiGLK6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiGLK5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:57:46 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B4EAEF63
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:45 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id b2so6937530plx.7
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4uTFDPdsLupjidDuaAyhErndHQ6C20td2af7g/YXA8A=;
        b=lvhMy54dzXtcl0CUfiqayaLpTgqzI9JNDPAOKFjE0PzOyaOVe0Y3j8l1LZ481Jauxi
         ZqYiHDGzJ+Ck/wSTW6HYo/IP3i3TaVlgn3n5Wb7EBVTDsSuMMaxuH/l8GaMtG2Kwz2n4
         f3el/GAyaUhKdt9kB9LVD1SxqL2ZWbfptTF6LUGdw3ylsjs9tzWzWTYm5+oJVakVsQj9
         K4r/xSrEvBU6jpobdc04nKnYBBME7umbdDK8ODO1vfzq0o4iZoZm5AfuZ3YdCDebV7lQ
         uchv9We5csrZeoA6JL8y439VI3FxLnYtEhy0NzuSxmVX44UxsxqUov3mDXzS7/P1b9zU
         r2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4uTFDPdsLupjidDuaAyhErndHQ6C20td2af7g/YXA8A=;
        b=UmrX4l4jGLUW6gtMrjuiTIoplfopnAYXGaPexuIdYS6SB3u0Sq0gRh1NTxJa+0R9hY
         GUoxF6yPU57pb5sO8L28E7W5zgEis1VO6IDTx9XHE3qARqmy3AhBmwtyT1385Yl6uhjg
         MQtgKPvM1lkuZUq6bHpaTI1Iqu81/gM+/xjOZwwWlPjobPSwpwsWgqa+OnJEC7dHRpl4
         cCU6iJuWAyhf8lqW1570xgvsldCaTQbV9WdlJmxIEsHnFgQ25EtAuVkUlotCdBOmn4i1
         cSlgZynT0fDYFrZTt9nVscgspcRbUjtxqxQ1WOFBRmtxqG5gCu4s03g/BCD9q4Ji7J7i
         E/Qg==
X-Gm-Message-State: AJIora9WXEeCZsh8OmGqrJZhrcSW5sAUGkRdu262RgqsNJI7eT51MpPO
        WXtoaUmkxDXO648D5vN2Jsc=
X-Google-Smtp-Source: AGRyM1vB024gwJQvjf7x9WT1kua1FmKZwVyUumLXjZDsKdSju2Nfhvmrc7SVZPEdg67GiKPt0Rba/w==
X-Received: by 2002:a17:90a:1a14:b0:1ef:91a9:3c91 with SMTP id 20-20020a17090a1a1400b001ef91a93c91mr3702277pjk.203.1657623465244;
        Tue, 12 Jul 2022 03:57:45 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id im22-20020a170902bb1600b0016c37fe48casm5681714plb.193.2022.07.12.03.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:57:44 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 8/8] amt: do not use amt->nr_tunnels outside of lock
Date:   Tue, 12 Jul 2022 10:57:14 +0000
Message-Id: <20220712105714.12282-9-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220712105714.12282-1-ap420073@gmail.com>
References: <20220712105714.12282-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

amt->nr_tunnels is protected by amt->lock.
But, amt_request_handler() has been using this variable without the
amt->lock.
So, it expands context of amt->lock in the amt_request_handler() to
protect amt->nr_tunnels variable.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 03decb3caa5c..f23d2d270895 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2679,7 +2679,9 @@ static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
 		if (tunnel->ip4 == iph->saddr)
 			goto send;
 
+	spin_lock_bh(&amt->lock);
 	if (amt->nr_tunnels >= amt->max_tunnels) {
+		spin_unlock_bh(&amt->lock);
 		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
 		return true;
 	}
@@ -2687,8 +2689,10 @@ static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
 	tunnel = kzalloc(sizeof(*tunnel) +
 			 (sizeof(struct hlist_head) * amt->hash_buckets),
 			 GFP_ATOMIC);
-	if (!tunnel)
+	if (!tunnel) {
+		spin_unlock_bh(&amt->lock);
 		return true;
+	}
 
 	tunnel->source_port = udph->source;
 	tunnel->ip4 = iph->saddr;
@@ -2701,10 +2705,9 @@ static bool amt_request_handler(struct amt_dev *amt, struct sk_buff *skb)
 
 	INIT_DELAYED_WORK(&tunnel->gc_wq, amt_tunnel_expire);
 
-	spin_lock_bh(&amt->lock);
 	list_add_tail_rcu(&tunnel->list, &amt->tunnel_list);
 	tunnel->key = amt->key;
-	amt_update_relay_status(tunnel, AMT_STATUS_RECEIVED_REQUEST, true);
+	__amt_update_relay_status(tunnel, AMT_STATUS_RECEIVED_REQUEST, true);
 	amt->nr_tunnels++;
 	mod_delayed_work(amt_wq, &tunnel->gc_wq,
 			 msecs_to_jiffies(amt_gmi(amt)));
-- 
2.17.1

