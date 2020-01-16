Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 416C913E37E
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388346AbgAPRCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:02:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387466AbgAPRCV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:21 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F41702077B;
        Thu, 16 Jan 2020 17:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194140;
        bh=Bqung/CFGAAzncMdZ5Rf7tz3HPZrtQ1OIkm3NCvqIwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJ4vwbqDCC79kmnI+ss70m73rKckdjk69hvEmh8v7fl0Kr+ygqnuKUWYtOml2g9aG
         nOkhja0UiV5OOaDKHnABDWRXZTj/3NysBFhiQCShh3/JlSuup53fBzRuW8eI2sNSUx
         1xO+WwAHHzRwbxtDWwJCxicS9FSOuDfPmZiv1I00=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eli Britstein <elibr@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 227/671] net: sched: act_csum: Fix csum calc for tagged packets
Date:   Thu, 16 Jan 2020 11:52:16 -0500
Message-Id: <20200116165940.10720-110-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

[ Upstream commit 2ecba2d1e45b24620a7c3df9531895cf68d5dec6 ]

The csum calculation is different for IPv4/6. For VLAN packets,
tc_skb_protocol returns the VLAN protocol rather than the packet's one
(e.g. IPv4/6), so csum is not calculated. Furthermore, VLAN may not be
stripped so csum is not calculated in this case too. Calculate the
csum for those cases.

Fixes: d8b9605d2697 ("net: sched: fix skb->protocol use in case of accelerated vlan path")
Signed-off-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_csum.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index 1e269441065a..9ecbf8edcf39 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -560,8 +560,11 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
 			struct tcf_result *res)
 {
 	struct tcf_csum *p = to_tcf_csum(a);
+	bool orig_vlan_tag_present = false;
+	unsigned int vlan_hdr_count = 0;
 	struct tcf_csum_params *params;
 	u32 update_flags;
+	__be16 protocol;
 	int action;
 
 	params = rcu_dereference_bh(p->params);
@@ -574,7 +577,9 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
 		goto drop;
 
 	update_flags = params->update_flags;
-	switch (tc_skb_protocol(skb)) {
+	protocol = tc_skb_protocol(skb);
+again:
+	switch (protocol) {
 	case cpu_to_be16(ETH_P_IP):
 		if (!tcf_csum_ipv4(skb, update_flags))
 			goto drop;
@@ -583,13 +588,35 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
 		if (!tcf_csum_ipv6(skb, update_flags))
 			goto drop;
 		break;
+	case cpu_to_be16(ETH_P_8021AD): /* fall through */
+	case cpu_to_be16(ETH_P_8021Q):
+		if (skb_vlan_tag_present(skb) && !orig_vlan_tag_present) {
+			protocol = skb->protocol;
+			orig_vlan_tag_present = true;
+		} else {
+			struct vlan_hdr *vlan = (struct vlan_hdr *)skb->data;
+
+			protocol = vlan->h_vlan_encapsulated_proto;
+			skb_pull(skb, VLAN_HLEN);
+			skb_reset_network_header(skb);
+			vlan_hdr_count++;
+		}
+		goto again;
+	}
+
+out:
+	/* Restore the skb for the pulled VLAN tags */
+	while (vlan_hdr_count--) {
+		skb_push(skb, VLAN_HLEN);
+		skb_reset_network_header(skb);
 	}
 
 	return action;
 
 drop:
 	qstats_drop_inc(this_cpu_ptr(p->common.cpu_qstats));
-	return TC_ACT_SHOT;
+	action = TC_ACT_SHOT;
+	goto out;
 }
 
 static int tcf_csum_dump(struct sk_buff *skb, struct tc_action *a, int bind,
-- 
2.20.1

