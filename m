Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCDC3553BA
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242961AbhDFMW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:22:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34442 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343984AbhDFMWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:04 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id AD76F63E5C;
        Tue,  6 Apr 2021 14:21:36 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 22/28] netfilter: nf_defrag_ipv4: use net_generic infra
Date:   Tue,  6 Apr 2021 14:21:27 +0200
Message-Id: <20210406122133.1644-23-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This allows followup patch to remove the defrag_ipv4 member from struct
net.  It also allows to auto-remove the hooks later on by adding a
_disable() function.  This will be done later in a follow patch series.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_defrag_ipv4.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 8115611aa47d..ffdcc2b9360f 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -20,8 +20,13 @@
 #endif
 #include <net/netfilter/nf_conntrack_zones.h>
 
+static unsigned int defrag4_pernet_id __read_mostly;
 static DEFINE_MUTEX(defrag4_mutex);
 
+struct defrag4_pernet {
+	unsigned int users;
+};
+
 static int nf_ct_ipv4_gather_frags(struct net *net, struct sk_buff *skb,
 				   u_int32_t user)
 {
@@ -106,15 +111,19 @@ static const struct nf_hook_ops ipv4_defrag_ops[] = {
 
 static void __net_exit defrag4_net_exit(struct net *net)
 {
-	if (net->nf.defrag_ipv4) {
+	struct defrag4_pernet *nf_defrag = net_generic(net, defrag4_pernet_id);
+
+	if (nf_defrag->users) {
 		nf_unregister_net_hooks(net, ipv4_defrag_ops,
 					ARRAY_SIZE(ipv4_defrag_ops));
-		net->nf.defrag_ipv4 = false;
+		nf_defrag->users = 0;
 	}
 }
 
 static struct pernet_operations defrag4_net_ops = {
 	.exit = defrag4_net_exit,
+	.id   = &defrag4_pernet_id,
+	.size = sizeof(struct defrag4_pernet),
 };
 
 static int __init nf_defrag_init(void)
@@ -129,21 +138,22 @@ static void __exit nf_defrag_fini(void)
 
 int nf_defrag_ipv4_enable(struct net *net)
 {
+	struct defrag4_pernet *nf_defrag = net_generic(net, defrag4_pernet_id);
 	int err = 0;
 
 	might_sleep();
 
-	if (net->nf.defrag_ipv4)
+	if (nf_defrag->users)
 		return 0;
 
 	mutex_lock(&defrag4_mutex);
-	if (net->nf.defrag_ipv4)
+	if (nf_defrag->users)
 		goto out_unlock;
 
 	err = nf_register_net_hooks(net, ipv4_defrag_ops,
 				    ARRAY_SIZE(ipv4_defrag_ops));
 	if (err == 0)
-		net->nf.defrag_ipv4 = true;
+		nf_defrag->users = 1;
 
  out_unlock:
 	mutex_unlock(&defrag4_mutex);
-- 
2.30.2

