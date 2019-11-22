Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 163DA1065BE
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbfKVG0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:26:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:55684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbfKVFuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBE8F2075B;
        Fri, 22 Nov 2019 05:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401850;
        bh=jKzR5jY6Q+nmrW1yULqWSQepuzyW0D8Ht4y9wTjw5e4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcqR6vgSTEOA2kBZgcLCkqPkKlwT9wcm8gnus+T6XzIVZDFeurJfMegFqK5z2KAjK
         UHVHMr6H0PJ4AcSSpPI+/1KO1T9vN44rJrL9cwqwYzzn2ros8og06CeQBKFQxhPK16
         kvRhGelrc2IOi2rxoa0DmfYfmgRF5a9n1dLZ4/Ys=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alin Nastac <alin.nastac@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 088/219] netfilter: nf_nat_sip: fix RTP/RTCP source port translations
Date:   Fri, 22 Nov 2019 00:47:00 -0500
Message-Id: <20191122054911.1750-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alin Nastac <alin.nastac@gmail.com>

[ Upstream commit 8294059931448aa1ca112615bdffa3eab552c382 ]

Each media stream negotiation between 2 SIP peers will trigger creation
of 4 different expectations (2 RTP and 2 RTCP):
 - INVITE will create expectations for the media packets sent by the
   called peer
 - reply to the INVITE will create expectations for media packets sent
   by the caller

The dport used by these expectations usually match the ones selected
by the SIP peers, but they might get translated due to conflicts with
another expectation. When such event occur, it is important to do
this translation in both directions, dport translation on the receiving
path and sport translation on the sending path.

This commit fixes the sport translation when the peer requiring it is
also the one that starts the media stream. In this scenario, first media
stream packet is forwarded from LAN to WAN and will rely on
nf_nat_sip_expected() to do the necessary sport translation. However, the
expectation matched by this packet does not contain the necessary information
for doing SNAT, this data being stored in the paired expectation created by
the sender's SIP message (INVITE or reply to it).

Signed-off-by: Alin Nastac <alin.nastac@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_sip.c | 39 ++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_nat_sip.c b/net/netfilter/nf_nat_sip.c
index 1f30860749817..aa1be643d7a09 100644
--- a/net/netfilter/nf_nat_sip.c
+++ b/net/netfilter/nf_nat_sip.c
@@ -18,6 +18,7 @@
 
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_helper.h>
+#include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
@@ -316,6 +317,9 @@ static void nf_nat_sip_seq_adjust(struct sk_buff *skb, unsigned int protoff,
 static void nf_nat_sip_expected(struct nf_conn *ct,
 				struct nf_conntrack_expect *exp)
 {
+	struct nf_conn_help *help = nfct_help(ct->master);
+	struct nf_conntrack_expect *pair_exp;
+	int range_set_for_snat = 0;
 	struct nf_nat_range2 range;
 
 	/* This must be a fresh one. */
@@ -327,15 +331,42 @@ static void nf_nat_sip_expected(struct nf_conn *ct,
 	range.min_addr = range.max_addr = exp->saved_addr;
 	nf_nat_setup_info(ct, &range, NF_NAT_MANIP_DST);
 
-	/* Change src to where master sends to, but only if the connection
-	 * actually came from the same source. */
-	if (nf_inet_addr_cmp(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3,
+	/* Do media streams SRC manip according with the parameters
+	 * found in the paired expectation.
+	 */
+	if (exp->class != SIP_EXPECT_SIGNALLING) {
+		spin_lock_bh(&nf_conntrack_expect_lock);
+		hlist_for_each_entry(pair_exp, &help->expectations, lnode) {
+			if (pair_exp->tuple.src.l3num == nf_ct_l3num(ct) &&
+			    pair_exp->tuple.dst.protonum == ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum &&
+			    nf_inet_addr_cmp(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3, &pair_exp->saved_addr) &&
+			    ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.all == pair_exp->saved_proto.all) {
+				range.flags = (NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED);
+				range.min_proto.all = range.max_proto.all = pair_exp->tuple.dst.u.all;
+				range.min_addr = range.max_addr = pair_exp->tuple.dst.u3;
+				range_set_for_snat = 1;
+				break;
+			}
+		}
+		spin_unlock_bh(&nf_conntrack_expect_lock);
+	}
+
+	/* When no paired expectation has been found, change src to
+	 * where master sends to, but only if the connection actually came
+	 * from the same source.
+	 */
+	if (!range_set_for_snat &&
+	    nf_inet_addr_cmp(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3,
 			     &ct->master->tuplehash[exp->dir].tuple.src.u3)) {
 		range.flags = NF_NAT_RANGE_MAP_IPS;
 		range.min_addr = range.max_addr
 			= ct->master->tuplehash[!exp->dir].tuple.dst.u3;
-		nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
+		range_set_for_snat = 1;
 	}
+
+	/* Perform SRC manip. */
+	if (range_set_for_snat)
+		nf_nat_setup_info(ct, &range, NF_NAT_MANIP_SRC);
 }
 
 static unsigned int nf_nat_sip_expect(struct sk_buff *skb, unsigned int protoff,
-- 
2.20.1

