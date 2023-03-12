Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7936B684C
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 17:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjCLQhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 12:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjCLQhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 12:37:42 -0400
Received: from ocelot.miegl.cz (ocelot.miegl.cz [IPv6:2a01:4f8:1c1c:20fe::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599A238B61;
        Sun, 12 Mar 2023 09:37:40 -0700 (PDT)
From:   Josef Miegl <josef@miegl.cz>
Cc:     Eyal Birger <eyal.birger@gmail.com>, Josef Miegl <josef@miegl.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: geneve: accept every ethertype
Date:   Sun, 12 Mar 2023 17:37:26 +0100
Message-Id: <20230312163726.55257-1-josef@miegl.cz>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,TO_EQ_FM_DIRECT_MX autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Geneve encapsulation, as defined in RFC 8926, has a Protocol Type
field, which states the Ethertype of the payload appearing after the
Geneve header.

Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed the
use of other Ethertypes than Ethernet. However, it imposed a restriction
that prohibits receiving payloads other than IPv4, IPv6 and Ethernet.

This patch removes this restriction, making it possible to receive any
Ethertype as a payload, if the IFLA_GENEVE_INNER_PROTO_INHERIT flag is
set.

This is especially useful if one wants to encapsulate MPLS, because with
this patch the control-plane traffic (IP, IS-IS) and the data-plane
traffic (MPLS) can be encapsulated without an Ethernet frame, making
lightweight overlay networks a possibility.

Signed-off-by: Josef Miegl <josef@miegl.cz>
---
 drivers/net/geneve.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 89ff7f8e8c7e..32684e94eb4f 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -365,13 +365,6 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
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
@@ -380,6 +373,8 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (!geneve)
 		goto drop;
 
+	inner_proto = geneveh->proto_type;
+
 	if (unlikely((!geneve->cfg.inner_proto_inherit &&
 		      inner_proto != htons(ETH_P_TEB)))) {
 		geneve->dev->stats.rx_dropped++;
-- 
2.37.1

