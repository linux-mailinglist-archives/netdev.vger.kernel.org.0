Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC756A3441
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 22:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjBZVc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 16:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBZVc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 16:32:57 -0500
X-Greylist: delayed 433 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 26 Feb 2023 13:32:54 PST
Received: from ocelot.miegl.cz (ocelot.miegl.cz [IPv6:2a01:4f8:1c1c:20fe::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC56B59D9;
        Sun, 26 Feb 2023 13:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=miegl.cz; s=dkim;
        t=1677446736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qvfqHgyUXGXrYNZDJ5SrURQa+kSmygMApMOH/RLLtkA=;
        b=JchfXmy+MZIAEQi8qAivouH5lRxmxGsmpAVW0eTXx3Wqc2CYT3xFic8y9KSKROQkeKlchb
        /UisN9F/B/cvgyCPMR790pG4ris4iAVTx3IaqIf1z8t7nKr1zfSZ6wmajotbMWaonyp4C3
        zMaJJxbK2oq2IMSR7o5vnLwFsFftQXe6F0nkAQwF4xwRXh//3UPzpXGVwHo0H9Yq+79gvH
        tki7kbGSDRV0Bneh2AIgMaY4vVCkztv+D1ySCNddQDSC9MLxtEg2yiM91LdxAG/UM+rhxd
        1LZuTJo2gtczPVwY7ppwv97JvdmraR97TJhtCEcDrddmfuNK5Dl3CpO5sqX/eQ==
From:   Josef Miegl <josef@miegl.cz>
Cc:     Josef Miegl <josef@miegl.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: geneve: accept every ethertype
Date:   Sun, 26 Feb 2023 22:25:14 +0100
Message-Id: <20230226212514.40875-1-josef@miegl.cz>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
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

This patch removes a restriction that prohibited receiving ethertypes
other than IPv4,IPv6 and Ethernet.

With IFLA_GENEVE_INNER_PROTO_INHERIT flag set, GENEVE interface can now
receive ethertypes such as MPLS.

Signed-off-by: Josef Miegl <josef@miegl.cz>
---
 drivers/net/geneve.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 89ff7f8e8c7e..ea48027db580 100644
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
@@ -381,13 +373,13 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		goto drop;
 
 	if (unlikely((!geneve->cfg.inner_proto_inherit &&
-		      inner_proto != htons(ETH_P_TEB)))) {
+		      geneveh->proto_type != htons(ETH_P_TEB)))) {
 		geneve->dev->stats.rx_dropped++;
 		goto drop;
 	}
 
 	opts_len = geneveh->opt_len * 4;
-	if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len, inner_proto,
+	if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len, geneveh->proto_type,
 				 !net_eq(geneve->net, dev_net(geneve->dev)))) {
 		geneve->dev->stats.rx_dropped++;
 		goto drop;
-- 
2.37.1

