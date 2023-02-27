Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E386A3BCB
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 08:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjB0Hlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 02:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjB0Hlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 02:41:47 -0500
Received: from ocelot.miegl.cz (ocelot.miegl.cz [IPv6:2a01:4f8:1c1c:20fe::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546691B2F0;
        Sun, 26 Feb 2023 23:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=miegl.cz; s=dkim;
        t=1677483704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3J8XnFKIlaEVNtE6PqYdTp5E6HxGZ5Xg5pqrrAfE0Qg=;
        b=N0JsDvD/6TT2zD1U9v4y1mvklOqUqEf1a9nyu3ysPk165T3UTyJ+NmyGwDPyEUqYj3hAJq
        BGfh9ZU5oRlsKuCKvdj3hr4tA+MuLksybimrJYt7R5a2JqYv+o/ecE27jmaYera3zlG+rF
        ZCZxIIgc3x9h3tg94MMR5I7djVM6pV37LNrfK8YW1SQkSyPhzy7zH5+wBx33FZ7Eq5NMaq
        y4hL7jQ7fEybmnmRUuMfkyGDuApFwubhoy7BM43am1vJzoTqFz5oLcP4j1X6Ynwoeru540
        YX/IMO4MpKezPfG6s3fGxxcLiRB6SFl9FozghyljAyu32DVzgK7ztYUnCGT6xw==
From:   Josef Miegl <josef@miegl.cz>
Cc:     Josef Miegl <josef@miegl.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] net: geneve: accept every ethertype
Date:   Mon, 27 Feb 2023 08:41:04 +0100
Message-Id: <20230227074104.42153-2-josef@miegl.cz>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230227074104.42153-1-josef@miegl.cz>
References: <20230227074104.42153-1-josef@miegl.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        TO_EQ_FM_DIRECT_MX autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes a restriction that prohibited receiving encapsulated
ethertypes other than IPv4, IPv6 and Ethernet.

With IFLA_GENEVE_INNER_PROTO_INHERIT flag set, GENEVE interface can now
receive ethertypes such as MPLS.

Signed-off-by: Josef Miegl <josef@miegl.cz>
---
 drivers/net/geneve.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 89ff7f8e8c7e..7973659a891f 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -353,7 +353,6 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	struct genevehdr *geneveh;
 	struct geneve_dev *geneve;
 	struct geneve_sock *gs;
-	__be16 inner_proto;
 	int opts_len;
 
 	/* Need UDP and Geneve header to be present */
@@ -365,13 +364,6 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(geneveh->ver != GENEVE_VER))
 		goto drop;
 
-	inner_proto = geneveh->proto_type;
-
-	if (unlikely((inner_proto != htons(ETH_P_TEB) &&
-		      inner_proto != htons(ETH_P_IP) &&
-		      inner_proto != htons(ETH_P_IPV6))))
-		goto drop;
-
 	gs = rcu_dereference_sk_user_data(sk);
 	if (!gs)
 		goto drop;
@@ -381,14 +373,15 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		goto drop;
 
 	if (unlikely((!geneve->cfg.inner_proto_inherit &&
-		      inner_proto != htons(ETH_P_TEB)))) {
+		      geneveh->proto_type != htons(ETH_P_TEB)))) {
 		geneve->dev->stats.rx_dropped++;
 		goto drop;
 	}
 
 	opts_len = geneveh->opt_len * 4;
-	if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len, inner_proto,
-				 !net_eq(geneve->net, dev_net(geneve->dev)))) {
+	if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len,
+				 geneveh->proto_type, !net_eq(geneve->net,
+				 dev_net(geneve->dev)))) {
 		geneve->dev->stats.rx_dropped++;
 		goto drop;
 	}
-- 
2.37.1

