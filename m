Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6628A197178
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 02:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgC3AiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 20:38:18 -0400
Received: from correo.us.es ([193.147.175.20]:57130 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727894AbgC3AhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E3BF1EF427
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2D62100A50
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 02:37:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C8386100A4C; Mon, 30 Mar 2020 02:37:19 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6FE2100A42;
        Mon, 30 Mar 2020 02:37:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A0F6842EF42A;
        Mon, 30 Mar 2020 02:37:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/26] netfilter: flowtable: fix NULL pointer dereference in tunnel offload support
Date:   Mon, 30 Mar 2020 02:36:48 +0200
Message-Id: <20200330003708.54017-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The tc ct action does not cache the route in the flowtable entry.

Fixes: 88bf6e4114d5 ("netfilter: flowtable: add tunnel encap/decap action offload support")
Fixes: cfab6dbd0ecf ("netfilter: flowtable: add tunnel match offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ad549317af30..a68136a8d750 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -92,7 +92,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
 
-	if (other_dst->lwtstate) {
+	if (other_dst && other_dst->lwtstate) {
 		tun_info = lwt_tun_info(other_dst->lwtstate);
 		nf_flow_rule_lwt_match(match, tun_info);
 	}
@@ -483,7 +483,7 @@ static void flow_offload_encap_tunnel(const struct flow_offload *flow,
 	struct dst_entry *dst;
 
 	dst = flow->tuplehash[dir].tuple.dst_cache;
-	if (dst->lwtstate) {
+	if (dst && dst->lwtstate) {
 		struct ip_tunnel_info *tun_info;
 
 		tun_info = lwt_tun_info(dst->lwtstate);
@@ -503,7 +503,7 @@ static void flow_offload_decap_tunnel(const struct flow_offload *flow,
 	struct dst_entry *dst;
 
 	dst = flow->tuplehash[!dir].tuple.dst_cache;
-	if (dst->lwtstate) {
+	if (dst && dst->lwtstate) {
 		struct ip_tunnel_info *tun_info;
 
 		tun_info = lwt_tun_info(dst->lwtstate);
-- 
2.11.0

