Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1AC149EF0E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 00:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344196AbiA0Xws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 18:52:48 -0500
Received: from mail.netfilter.org ([217.70.188.207]:43006 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343957AbiA0Xwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 18:52:44 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id DA8D760869;
        Fri, 28 Jan 2022 00:49:38 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 5/8] netfilter: nft_reject_bridge: Fix for missing reply from prerouting
Date:   Fri, 28 Jan 2022 00:52:32 +0100
Message-Id: <20220127235235.656931-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127235235.656931-1-pablo@netfilter.org>
References: <20220127235235.656931-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Prior to commit fa538f7cf05aa ("netfilter: nf_reject: add reject skbuff
creation helpers"), nft_reject_bridge did not assign to nskb->dev before
passing nskb on to br_forward(). The shared skbuff creation helpers
introduced in above commit do which seems to confuse br_forward() as
reject statements in prerouting hook won't emit a packet anymore.

Fix this by simply passing NULL instead of 'dev' to the helpers - they
use the pointer for just that assignment, nothing else.

Fixes: fa538f7cf05aa ("netfilter: nf_reject: add reject skbuff creation helpers")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_reject_bridge.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index eba0efe64d05..fbf858ddec35 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -49,7 +49,7 @@ static void nft_reject_br_send_v4_tcp_reset(struct net *net,
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v4_tcp_reset(net, oldskb, dev, hook);
+	nskb = nf_reject_skb_v4_tcp_reset(net, oldskb, NULL, hook);
 	if (!nskb)
 		return;
 
@@ -65,7 +65,7 @@ static void nft_reject_br_send_v4_unreach(struct net *net,
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v4_unreach(net, oldskb, dev, hook, code);
+	nskb = nf_reject_skb_v4_unreach(net, oldskb, NULL, hook, code);
 	if (!nskb)
 		return;
 
@@ -81,7 +81,7 @@ static void nft_reject_br_send_v6_tcp_reset(struct net *net,
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v6_tcp_reset(net, oldskb, dev, hook);
+	nskb = nf_reject_skb_v6_tcp_reset(net, oldskb, NULL, hook);
 	if (!nskb)
 		return;
 
@@ -98,7 +98,7 @@ static void nft_reject_br_send_v6_unreach(struct net *net,
 {
 	struct sk_buff *nskb;
 
-	nskb = nf_reject_skb_v6_unreach(net, oldskb, dev, hook, code);
+	nskb = nf_reject_skb_v6_unreach(net, oldskb, NULL, hook, code);
 	if (!nskb)
 		return;
 
-- 
2.30.2

