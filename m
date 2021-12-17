Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF110478691
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhLQIxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:53:19 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60502 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233949AbhLQIxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 03:53:18 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2C7D3605C3;
        Fri, 17 Dec 2021 09:50:47 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/3] netfilter: fix regression in looped (broad|multi)cast's MAC handling
Date:   Fri, 17 Dec 2021 09:53:02 +0100
Message-Id: <20211217085303.363401-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211217085303.363401-1-pablo@netfilter.org>
References: <20211217085303.363401-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ignacy Gawędzki <ignacy.gawedzki@green-communications.fr>

In commit 5648b5e1169f ("netfilter: nfnetlink_queue: fix OOB when mac
header was cleared"), the test for non-empty MAC header introduced in
commit 2c38de4c1f8da7 ("netfilter: fix looped (broad|multi)cast's MAC
handling") has been replaced with a test for a set MAC header.

This breaks the case when the MAC header has been reset (using
skb_reset_mac_header), as is the case with looped-back multicast
packets.  As a result, the packets ending up in NFQUEUE get a bogus
hwaddr interpreted from the first bytes of the IP header.

This patch adds a test for a non-empty MAC header in addition to the
test for a set MAC header.  The same two tests are also implemented in
nfnetlink_log.c, where the initial code of commit 2c38de4c1f8da7
("netfilter: fix looped (broad|multi)cast's MAC handling") has not been
touched, but where supposedly the same situation may happen.

Fixes: 5648b5e1169f ("netfilter: nfnetlink_queue: fix OOB when mac header was cleared")
Signed-off-by: Ignacy Gawędzki <ignacy.gawedzki@green-communications.fr>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c   | 3 ++-
 net/netfilter/nfnetlink_queue.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 691ef4cffdd9..7f83f9697fc1 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -556,7 +556,8 @@ __build_packet_message(struct nfnl_log_net *log,
 		goto nla_put_failure;
 
 	if (indev && skb->dev &&
-	    skb->mac_header != skb->network_header) {
+	    skb_mac_header_was_set(skb) &&
+	    skb_mac_header_len(skb) != 0) {
 		struct nfulnl_msg_packet_hw phw;
 		int len;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 5837e8efc9c2..f0b9e21a2452 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -560,7 +560,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		goto nla_put_failure;
 
 	if (indev && entskb->dev &&
-	    skb_mac_header_was_set(entskb)) {
+	    skb_mac_header_was_set(entskb) &&
+	    skb_mac_header_len(entskb) != 0) {
 		struct nfqnl_msg_packet_hw phw;
 		int len;
 
-- 
2.30.2

