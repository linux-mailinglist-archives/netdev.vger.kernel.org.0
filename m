Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57242218ED8
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgGHRrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:47:13 -0400
Received: from correo.us.es ([193.147.175.20]:34740 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728500AbgGHRqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:46:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 423AD3066A6
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 229E6DA84F
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 17DB1DA84A; Wed,  8 Jul 2020 19:46:22 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7CE8DA73D;
        Wed,  8 Jul 2020 19:46:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jul 2020 19:46:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 891F14265A2F;
        Wed,  8 Jul 2020 19:46:19 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 03/12] ipvs: register hooks only with services
Date:   Wed,  8 Jul 2020 19:46:00 +0200
Message-Id: <20200708174609.1343-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200708174609.1343-1-pablo@netfilter.org>
References: <20200708174609.1343-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

Keep the IPVS hooks registered in Netfilter only
while there are configured virtual services. This
saves CPU cycles while IPVS is loaded but not used.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip_vs.h             |  5 +++
 net/netfilter/ipvs/ip_vs_core.c | 80 ++++++++++++++++++++++++++-------
 net/netfilter/ipvs/ip_vs_ctl.c  | 23 +++++++++-
 3 files changed, 89 insertions(+), 19 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 83be2d93b407..0c9881241323 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -874,6 +874,7 @@ struct netns_ipvs {
 	struct ip_vs_stats		tot_stats;  /* Statistics & est. */
 
 	int			num_services;    /* no of virtual services */
+	int			num_services6;   /* IPv6 virtual services */
 
 	/* Trash for destinations */
 	struct list_head	dest_trash;
@@ -960,6 +961,7 @@ struct netns_ipvs {
 	 * are not supported when synchronization is enabled.
 	 */
 	unsigned int		mixed_address_family_dests;
+	unsigned int		hooks_afmask;	/* &1=AF_INET, &2=AF_INET6 */
 };
 
 #define DEFAULT_SYNC_THRESHOLD	3
@@ -1670,6 +1672,9 @@ static inline void ip_vs_unregister_conntrack(struct ip_vs_service *svc)
 #endif
 }
 
+int ip_vs_register_hooks(struct netns_ipvs *ipvs, unsigned int af);
+void ip_vs_unregister_hooks(struct netns_ipvs *ipvs, unsigned int af);
+
 static inline int
 ip_vs_dest_conn_overhead(struct ip_vs_dest *dest)
 {
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index aa6a603a2425..ca3670152565 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2256,7 +2256,7 @@ ip_vs_forward_icmp_v6(void *priv, struct sk_buff *skb,
 #endif
 
 
-static const struct nf_hook_ops ip_vs_ops[] = {
+static const struct nf_hook_ops ip_vs_ops4[] = {
 	/* After packet filtering, change source only for VS/NAT */
 	{
 		.hook		= ip_vs_reply4,
@@ -2302,7 +2302,10 @@ static const struct nf_hook_ops ip_vs_ops[] = {
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= 100,
 	},
+};
+
 #ifdef CONFIG_IP_VS_IPV6
+static const struct nf_hook_ops ip_vs_ops6[] = {
 	/* After packet filtering, change source only for VS/NAT */
 	{
 		.hook		= ip_vs_reply6,
@@ -2348,8 +2351,64 @@ static const struct nf_hook_ops ip_vs_ops[] = {
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= 100,
 	},
-#endif
 };
+#endif
+
+int ip_vs_register_hooks(struct netns_ipvs *ipvs, unsigned int af)
+{
+	const struct nf_hook_ops *ops;
+	unsigned int count;
+	unsigned int afmask;
+	int ret = 0;
+
+	if (af == AF_INET6) {
+#ifdef CONFIG_IP_VS_IPV6
+		ops = ip_vs_ops6;
+		count = ARRAY_SIZE(ip_vs_ops6);
+		afmask = 2;
+#else
+		return -EINVAL;
+#endif
+	} else {
+		ops = ip_vs_ops4;
+		count = ARRAY_SIZE(ip_vs_ops4);
+		afmask = 1;
+	}
+
+	if (!(ipvs->hooks_afmask & afmask)) {
+		ret = nf_register_net_hooks(ipvs->net, ops, count);
+		if (ret >= 0)
+			ipvs->hooks_afmask |= afmask;
+	}
+	return ret;
+}
+
+void ip_vs_unregister_hooks(struct netns_ipvs *ipvs, unsigned int af)
+{
+	const struct nf_hook_ops *ops;
+	unsigned int count;
+	unsigned int afmask;
+
+	if (af == AF_INET6) {
+#ifdef CONFIG_IP_VS_IPV6
+		ops = ip_vs_ops6;
+		count = ARRAY_SIZE(ip_vs_ops6);
+		afmask = 2;
+#else
+		return;
+#endif
+	} else {
+		ops = ip_vs_ops4;
+		count = ARRAY_SIZE(ip_vs_ops4);
+		afmask = 1;
+	}
+
+	if (ipvs->hooks_afmask & afmask) {
+		nf_unregister_net_hooks(ipvs->net, ops, count);
+		ipvs->hooks_afmask &= ~afmask;
+	}
+}
+
 /*
  *	Initialize IP Virtual Server netns mem.
  */
@@ -2425,19 +2484,6 @@ static void __net_exit __ip_vs_cleanup_batch(struct list_head *net_list)
 	}
 }
 
-static int __net_init __ip_vs_dev_init(struct net *net)
-{
-	int ret;
-
-	ret = nf_register_net_hooks(net, ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
-	if (ret < 0)
-		goto hook_fail;
-	return 0;
-
-hook_fail:
-	return ret;
-}
-
 static void __net_exit __ip_vs_dev_cleanup_batch(struct list_head *net_list)
 {
 	struct netns_ipvs *ipvs;
@@ -2446,7 +2492,8 @@ static void __net_exit __ip_vs_dev_cleanup_batch(struct list_head *net_list)
 	EnterFunction(2);
 	list_for_each_entry(net, net_list, exit_list) {
 		ipvs = net_ipvs(net);
-		nf_unregister_net_hooks(net, ip_vs_ops, ARRAY_SIZE(ip_vs_ops));
+		ip_vs_unregister_hooks(ipvs, AF_INET);
+		ip_vs_unregister_hooks(ipvs, AF_INET6);
 		ipvs->enable = 0;	/* Disable packet reception */
 		smp_wmb();
 		ip_vs_sync_net_cleanup(ipvs);
@@ -2462,7 +2509,6 @@ static struct pernet_operations ipvs_core_ops = {
 };
 
 static struct pernet_operations ipvs_core_dev_ops = {
-	.init = __ip_vs_dev_init,
 	.exit_batch = __ip_vs_dev_cleanup_batch,
 };
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 412656c34f20..0eed388c960b 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1272,6 +1272,7 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	struct ip_vs_scheduler *sched = NULL;
 	struct ip_vs_pe *pe = NULL;
 	struct ip_vs_service *svc = NULL;
+	int ret_hooks = -1;
 
 	/* increase the module use count */
 	if (!ip_vs_use_count_inc())
@@ -1313,6 +1314,14 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	}
 #endif
 
+	if ((u->af == AF_INET && !ipvs->num_services) ||
+	    (u->af == AF_INET6 && !ipvs->num_services6)) {
+		ret = ip_vs_register_hooks(ipvs, u->af);
+		if (ret < 0)
+			goto out_err;
+		ret_hooks = ret;
+	}
+
 	svc = kzalloc(sizeof(struct ip_vs_service), GFP_KERNEL);
 	if (svc == NULL) {
 		IP_VS_DBG(1, "%s(): no memory\n", __func__);
@@ -1374,6 +1383,8 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	/* Count only IPv4 services for old get/setsockopt interface */
 	if (svc->af == AF_INET)
 		ipvs->num_services++;
+	else if (svc->af == AF_INET6)
+		ipvs->num_services6++;
 
 	/* Hash the service into the service table */
 	ip_vs_svc_hash(svc);
@@ -1385,6 +1396,8 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 
 
  out_err:
+	if (ret_hooks >= 0)
+		ip_vs_unregister_hooks(ipvs, u->af);
 	if (svc != NULL) {
 		ip_vs_unbind_scheduler(svc, sched);
 		ip_vs_service_free(svc);
@@ -1500,9 +1513,15 @@ static void __ip_vs_del_service(struct ip_vs_service *svc, bool cleanup)
 	struct ip_vs_pe *old_pe;
 	struct netns_ipvs *ipvs = svc->ipvs;
 
-	/* Count only IPv4 services for old get/setsockopt interface */
-	if (svc->af == AF_INET)
+	if (svc->af == AF_INET) {
 		ipvs->num_services--;
+		if (!ipvs->num_services)
+			ip_vs_unregister_hooks(ipvs, svc->af);
+	} else if (svc->af == AF_INET6) {
+		ipvs->num_services6--;
+		if (!ipvs->num_services6)
+			ip_vs_unregister_hooks(ipvs, svc->af);
+	}
 
 	ip_vs_stop_estimator(svc->ipvs, &svc->stats);
 
-- 
2.20.1

