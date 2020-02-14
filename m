Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A0915F0E7
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388467AbgBNR6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:58:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730621AbgBNP5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:57:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED396222C4;
        Fri, 14 Feb 2020 15:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695833;
        bh=XdazMGhwIbJBiuiXlZkpj9HZX5NWsSPBy8ztckTuicA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDdl9zWh9mhlZnghccYlO/ED6eS5TRgVuXuVYgYV8WAmrEjEPmW5hCcXNTn98httE
         woBDVmQ862mP3HJ2BlgyrvTNMl9LchEZHl4j8Dw3yKoL8tE7KIp6ZjP85VdNCf3+EQ
         Y9oRUgVWY67XZ6Mc9JCCghtvDWyer6MV9vy8uS9o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 386/542] netfilter: flowtable: restrict flow dissector match on meta ingress device
Date:   Fri, 14 Feb 2020 10:46:18 -0500
Message-Id: <20200214154854.6746-386-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit a7521a60a5f3e1f58a015fedb6e69aed40455feb ]

Set on FLOW_DISSECTOR_KEY_META meta key using flow tuple ingress interface.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_offload.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index d06969af1085e..9e01074dc34cb 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -24,6 +24,7 @@ struct flow_offload_work {
 };
 
 struct nf_flow_key {
+	struct flow_dissector_key_meta			meta;
 	struct flow_dissector_key_control		control;
 	struct flow_dissector_key_basic			basic;
 	union {
@@ -55,6 +56,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	struct nf_flow_key *mask = &match->mask;
 	struct nf_flow_key *key = &match->key;
 
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_META, meta);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_BASIC, basic);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
@@ -62,6 +64,9 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
 
+	key->meta.ingress_ifindex = tuple->iifidx;
+	mask->meta.ingress_ifindex = 0xffffffff;
+
 	switch (tuple->l3proto) {
 	case AF_INET:
 		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
@@ -105,7 +110,8 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	key->tp.dst = tuple->dst_port;
 	mask->tp.dst = 0xffff;
 
-	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_META) |
+				      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 				      BIT(FLOW_DISSECTOR_KEY_BASIC) |
 				      BIT(FLOW_DISSECTOR_KEY_PORTS);
 	return 0;
-- 
2.20.1

