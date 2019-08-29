Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE90BA2606
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfH2SNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728372AbfH2SNj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1130E23407;
        Thu, 29 Aug 2019 18:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102417;
        bh=9ACL6Y5floZ1bdzEYnHFCfiFYuRsK9W3Q0GQxmWY1WQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRjfKx70RYH/j3ErNKAw9BXGjexkewx+Lvn+DWSv2mDeIWcXL1c6Ln+4q84lAW3js
         AwcK6QaghZLldVNiBl9Wqs3xQms2dKtelNlHpf4anuM7bWjZatNhvq8WYOlYHdzla1
         fMJnYFKxfUoDD7Z4EDuoHQqdnK+UCe8Rcof73150=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 12/76] netfilter: nf_flow_table: teardown flow timeout race
Date:   Thu, 29 Aug 2019 14:12:07 -0400
Message-Id: <20190829181311.7562-12-sashal@kernel.org>
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

[ Upstream commit 1e5b2471bcc4838df298080ae1ec042c2cbc9ce9 ]

Flows that are in teardown state (due to RST / FIN TCP packet) still
have their offload flag set on. Hence, the conntrack garbage collector
may race to undo the timeout adjustment that the fixup routine performs,
leaving the conntrack entry in place with the internal offload timeout
(one day).

Update teardown flow state to ESTABLISHED and set tracking to liberal,
then once the offload bit is cleared, adjust timeout if it is more than
the default fixup timeout (conntrack might already have set a lower
timeout from the packet path).

Fixes: da5984e51063 ("netfilter: nf_flow_table: add support for sending flows back to the slow path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 34 ++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 4254e42605135..49248fe5847a1 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -112,15 +112,16 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 #define NF_FLOWTABLE_TCP_PICKUP_TIMEOUT	(120 * HZ)
 #define NF_FLOWTABLE_UDP_PICKUP_TIMEOUT	(30 * HZ)
 
-static void flow_offload_fixup_ct(struct nf_conn *ct)
+static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
+{
+	return (__s32)(timeout - (u32)jiffies);
+}
+
+static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 {
 	const struct nf_conntrack_l4proto *l4proto;
+	int l4num = nf_ct_protonum(ct);
 	unsigned int timeout;
-	int l4num;
-
-	l4num = nf_ct_protonum(ct);
-	if (l4num == IPPROTO_TCP)
-		flow_offload_fixup_tcp(&ct->proto.tcp);
 
 	l4proto = nf_ct_l4proto_find(l4num);
 	if (!l4proto)
@@ -133,7 +134,20 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 	else
 		return;
 
-	ct->timeout = nfct_time_stamp + timeout;
+	if (nf_flow_timeout_delta(ct->timeout) > (__s32)timeout)
+		ct->timeout = nfct_time_stamp + timeout;
+}
+
+static void flow_offload_fixup_ct_state(struct nf_conn *ct)
+{
+	if (nf_ct_protonum(ct) == IPPROTO_TCP)
+		flow_offload_fixup_tcp(&ct->proto.tcp);
+}
+
+static void flow_offload_fixup_ct(struct nf_conn *ct)
+{
+	flow_offload_fixup_ct_state(ct);
+	flow_offload_fixup_ct_timeout(ct);
 }
 
 void flow_offload_free(struct flow_offload *flow)
@@ -211,7 +225,7 @@ EXPORT_SYMBOL_GPL(flow_offload_add);
 
 static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 {
-	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
+	return nf_flow_timeout_delta(flow->timeout) <= 0;
 }
 
 static void flow_offload_del(struct nf_flowtable *flow_table,
@@ -231,6 +245,8 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 	if (nf_flow_has_expired(flow))
 		flow_offload_fixup_ct(e->ct);
+	else if (flow->flags & FLOW_OFFLOAD_TEARDOWN)
+		flow_offload_fixup_ct_timeout(e->ct);
 
 	flow_offload_free(flow);
 }
@@ -242,7 +258,7 @@ void flow_offload_teardown(struct flow_offload *flow)
 	flow->flags |= FLOW_OFFLOAD_TEARDOWN;
 
 	e = container_of(flow, struct flow_offload_entry, flow);
-	flow_offload_fixup_ct(e->ct);
+	flow_offload_fixup_ct_state(e->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
-- 
2.20.1

