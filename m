Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0234FB99B
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345529AbiDKKaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345488AbiDKKaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:30:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3A0223F326;
        Mon, 11 Apr 2022 03:27:53 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 295DC63049;
        Mon, 11 Apr 2022 12:23:52 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 07/11] netfilter: nf_log_syslog: Consolidate entry checks
Date:   Mon, 11 Apr 2022 12:27:40 +0200
Message-Id: <20220411102744.282101-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220411102744.282101-1-pablo@netfilter.org>
References: <20220411102744.282101-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Every syslog logging callback has to perform the same check to cover for
rogue containers, introduce a helper for clarity. Drop the FIXME as
there is a viable solution since commit 2851940ffee31 ("netfilter: allow
logging from non-init namespaces").

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log_syslog.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index a7ff6fdbafc9..77bcb10fc586 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -40,6 +40,12 @@ struct arppayload {
 	unsigned char ip_dst[4];
 };
 
+/* Guard against containers flooding syslog. */
+static bool nf_log_allowed(const struct net *net)
+{
+	return net_eq(net, &init_net) || sysctl_nf_log_all_netns;
+}
+
 static void nf_log_dump_vlan(struct nf_log_buf *m, const struct sk_buff *skb)
 {
 	u16 vid;
@@ -133,8 +139,7 @@ static void nf_log_arp_packet(struct net *net, u_int8_t pf,
 {
 	struct nf_log_buf *m;
 
-	/* FIXME: Disabled from containers until syslog ns is supported */
-	if (!net_eq(net, &init_net) && !sysctl_nf_log_all_netns)
+	if (!nf_log_allowed(net))
 		return;
 
 	m = nf_log_buf_open();
@@ -831,8 +836,7 @@ static void nf_log_ip_packet(struct net *net, u_int8_t pf,
 {
 	struct nf_log_buf *m;
 
-	/* FIXME: Disabled from containers until syslog ns is supported */
-	if (!net_eq(net, &init_net) && !sysctl_nf_log_all_netns)
+	if (!nf_log_allowed(net))
 		return;
 
 	m = nf_log_buf_open();
@@ -867,8 +871,7 @@ static void nf_log_ip6_packet(struct net *net, u_int8_t pf,
 {
 	struct nf_log_buf *m;
 
-	/* FIXME: Disabled from containers until syslog ns is supported */
-	if (!net_eq(net, &init_net) && !sysctl_nf_log_all_netns)
+	if (!nf_log_allowed(net))
 		return;
 
 	m = nf_log_buf_open();
@@ -904,8 +907,7 @@ static void nf_log_unknown_packet(struct net *net, u_int8_t pf,
 {
 	struct nf_log_buf *m;
 
-	/* FIXME: Disabled from containers until syslog ns is supported */
-	if (!net_eq(net, &init_net) && !sysctl_nf_log_all_netns)
+	if (!nf_log_allowed(net))
 		return;
 
 	m = nf_log_buf_open();
-- 
2.30.2

