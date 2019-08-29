Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1859A260D
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbfH2SeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:34:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728330AbfH2SNi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7B102339E;
        Thu, 29 Aug 2019 18:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102416;
        bh=vm7PlOFMrhdiuuOeVzjw28rou+yhF1NIk/jyUsin+3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYFFzKXc19SD4IH1cfJCE/ozlcj/nuKaYQHjk3aO/e0+5lRjLFOQvy/Qd/M1iRH9I
         hfr8e66JGWgSiVTzaz2TmgwkZ4yFmJh5OApGORUH31194UOTsuay4bLXGlQ8jNBTHE
         66C6dJmbzkTfYfQ7d72bugbXInAMkIlu/WATc/EM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 11/76] netfilter: nf_flow_table: conntrack picks up expired flows
Date:   Thu, 29 Aug 2019 14:12:06 -0400
Message-Id: <20190829181311.7562-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 3e68db2f6422d711550a32cbc87abd97bb6efab3 ]

Update conntrack entry to pick up expired flows, otherwise the conntrack
entry gets stuck with the internal offload timeout (one day). The TCP
state also needs to be adjusted to ESTABLISHED state and tracking is set
to liberal mode in order to give conntrack a chance to pick up the
expired flow.

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 948b4ebbe3fbd..4254e42605135 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -112,7 +112,7 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 #define NF_FLOWTABLE_TCP_PICKUP_TIMEOUT	(120 * HZ)
 #define NF_FLOWTABLE_UDP_PICKUP_TIMEOUT	(30 * HZ)
 
-static void flow_offload_fixup_ct_state(struct nf_conn *ct)
+static void flow_offload_fixup_ct(struct nf_conn *ct)
 {
 	const struct nf_conntrack_l4proto *l4proto;
 	unsigned int timeout;
@@ -209,6 +209,11 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
 
+static inline bool nf_flow_has_expired(const struct flow_offload *flow)
+{
+	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
+}
+
 static void flow_offload_del(struct nf_flowtable *flow_table,
 			     struct flow_offload *flow)
 {
@@ -224,6 +229,9 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 	e = container_of(flow, struct flow_offload_entry, flow);
 	clear_bit(IPS_OFFLOAD_BIT, &e->ct->status);
 
+	if (nf_flow_has_expired(flow))
+		flow_offload_fixup_ct(e->ct);
+
 	flow_offload_free(flow);
 }
 
@@ -234,7 +242,7 @@ void flow_offload_teardown(struct flow_offload *flow)
 	flow->flags |= FLOW_OFFLOAD_TEARDOWN;
 
 	e = container_of(flow, struct flow_offload_entry, flow);
-	flow_offload_fixup_ct_state(e->ct);
+	flow_offload_fixup_ct(e->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
@@ -299,11 +307,6 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
 	return err;
 }
 
-static inline bool nf_flow_has_expired(const struct flow_offload *flow)
-{
-	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
-}
-
 static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
 	struct nf_flowtable *flow_table = data;
-- 
2.20.1

