Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349794AD6C6
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 12:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349678AbiBHL3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 06:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355703AbiBHJwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 04:52:46 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4DCC03FEC5;
        Tue,  8 Feb 2022 01:52:44 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id B9F51202A4; Tue,  8 Feb 2022 17:46:34 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, linux-doc@vger.kernel.org
Subject: [PATCH net-next 4/5] mctp: Allow keys matching any local address
Date:   Tue,  8 Feb 2022 17:46:16 +0800
Message-Id: <20220208094617.3675511-5-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220208094617.3675511-1-jk@codeconstruct.com.au>
References: <20220208094617.3675511-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, we require an exact match on an incoming packet's dest
address, and the key's local_addr field.

In a future change, we may want to set up a key before packets are
routed, meaning we have no local address to match on.

This change allows key lookups to match on local_addr = MCTP_ADDR_ANY.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/route.c           | 4 ++--
 net/mctp/test/route-test.c | 8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 654467a7aeae..35f72e99e188 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -76,7 +76,7 @@ static struct mctp_sock *mctp_lookup_bind(struct net *net, struct sk_buff *skb)
 static bool mctp_key_match(struct mctp_sk_key *key, mctp_eid_t local,
 			   mctp_eid_t peer, u8 tag)
 {
-	if (key->local_addr != local)
+	if (!mctp_address_matches(key->local_addr, local))
 		return false;
 
 	if (key->peer_addr != peer)
@@ -616,7 +616,7 @@ static struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
 			continue;
 
 		if (!(mctp_address_matches(tmp->peer_addr, daddr) &&
-		      tmp->local_addr == saddr))
+		      mctp_address_matches(tmp->local_addr, saddr)))
 			continue;
 
 		spin_lock(&tmp->lock);
diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index 044d59e81f89..5496e3a7f4c3 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -646,6 +646,14 @@ static const struct mctp_route_input_sk_keys_test mctp_route_input_sk_keys_tests
 		.hdr = RX_HDR(1, 11, 8, FL_S | FL_E | FL_T(1)),
 		.deliver = true,
 	},
+	{
+		.name = "any local match",
+		.key_peer_addr = 12,
+		.key_local_addr = MCTP_ADDR_ANY,
+		.key_tag = 1,
+		.hdr = RX_HDR(1, 12, 8, FL_S | FL_E | FL_T(1)),
+		.deliver = true,
+	},
 };
 
 static void mctp_route_input_sk_keys_to_desc(
-- 
2.34.1

