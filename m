Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E0E218EC0
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgGHRq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:46:26 -0400
Received: from correo.us.es ([193.147.175.20]:34738 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728542AbgGHRqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:46:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 228413066A1
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E646DA7B6
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 03593DA78C; Wed,  8 Jul 2020 19:46:24 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50A06DA78F;
        Wed,  8 Jul 2020 19:46:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jul 2020 19:46:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 21CFB42EF42B;
        Wed,  8 Jul 2020 19:46:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 05/12] ipvs: allow connection reuse for unconfirmed conntrack
Date:   Wed,  8 Jul 2020 19:46:02 +0200
Message-Id: <20200708174609.1343-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200708174609.1343-1-pablo@netfilter.org>
References: <20200708174609.1343-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

YangYuxi is reporting that connection reuse
is causing one-second delay when SYN hits
existing connection in TIME_WAIT state.
Such delay was added to give time to expire
both the IPVS connection and the corresponding
conntrack. This was considered a rare case
at that time but it is causing problem for
some environments such as Kubernetes.

As nf_conntrack_tcp_packet() can decide to
release the conntrack in TIME_WAIT state and
to replace it with a fresh NEW conntrack, we
can use this to allow rescheduling just by
tuning our check: if the conntrack is
confirmed we can not schedule it to different
real server and the one-second delay still
applies but if new conntrack was created,
we are free to select new real server without
any delays.

YangYuxi lists some of the problem reports:

- One second connection delay in masquerading mode:
https://marc.info/?t=151683118100004&r=1&w=2

- IPVS low throughput #70747
https://github.com/kubernetes/kubernetes/issues/70747

- Apache Bench can fill up ipvs service proxy in seconds #544
https://github.com/cloudnativelabs/kube-router/issues/544

- Additional 1s latency in `host -> service IP -> pod`
https://github.com/kubernetes/kubernetes/issues/90854

Fixes: f719e3754ee2 ("ipvs: drop first packet to redirect conntrack")
Co-developed-by: YangYuxi <yx.atom1@gmail.com>
Signed-off-by: YangYuxi <yx.atom1@gmail.com>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h             | 10 ++++------
 net/netfilter/ipvs/ip_vs_core.c | 12 +++++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 0c9881241323..011f407b76fe 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1626,18 +1626,16 @@ static inline void ip_vs_conn_drop_conntrack(struct ip_vs_conn *cp)
 }
 #endif /* CONFIG_IP_VS_NFCT */
 
-/* Really using conntrack? */
-static inline bool ip_vs_conn_uses_conntrack(struct ip_vs_conn *cp,
-					     struct sk_buff *skb)
+/* Using old conntrack that can not be redirected to another real server? */
+static inline bool ip_vs_conn_uses_old_conntrack(struct ip_vs_conn *cp,
+						 struct sk_buff *skb)
 {
 #ifdef CONFIG_IP_VS_NFCT
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 
-	if (!(cp->flags & IP_VS_CONN_F_NFCT))
-		return false;
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct)
+	if (ct && nf_ct_is_confirmed(ct))
 		return true;
 #endif
 	return false;
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index ca3670152565..b4a6b7662f3f 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2066,14 +2066,14 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 
 	conn_reuse_mode = sysctl_conn_reuse_mode(ipvs);
 	if (conn_reuse_mode && !iph.fragoffs && is_new_conn(skb, &iph) && cp) {
-		bool uses_ct = false, resched = false;
+		bool old_ct = false, resched = false;
 
 		if (unlikely(sysctl_expire_nodest_conn(ipvs)) && cp->dest &&
 		    unlikely(!atomic_read(&cp->dest->weight))) {
 			resched = true;
-			uses_ct = ip_vs_conn_uses_conntrack(cp, skb);
+			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
 		} else if (is_new_conn_expected(cp, conn_reuse_mode)) {
-			uses_ct = ip_vs_conn_uses_conntrack(cp, skb);
+			old_ct = ip_vs_conn_uses_old_conntrack(cp, skb);
 			if (!atomic_read(&cp->n_control)) {
 				resched = true;
 			} else {
@@ -2081,15 +2081,17 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 				 * that uses conntrack while it is still
 				 * referenced by controlled connection(s).
 				 */
-				resched = !uses_ct;
+				resched = !old_ct;
 			}
 		}
 
 		if (resched) {
+			if (!old_ct)
+				cp->flags &= ~IP_VS_CONN_F_NFCT;
 			if (!atomic_read(&cp->n_control))
 				ip_vs_conn_expire_now(cp);
 			__ip_vs_conn_put(cp);
-			if (uses_ct)
+			if (old_ct)
 				return NF_DROP;
 			cp = NULL;
 		}
-- 
2.20.1

