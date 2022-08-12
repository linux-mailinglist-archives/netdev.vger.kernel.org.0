Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E5D590E40
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 11:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238092AbiHLJjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 05:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232592AbiHLJjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 05:39:36 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE90AA3DA;
        Fri, 12 Aug 2022 02:39:34 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M3z8158Cgz1M8Cr;
        Fri, 12 Aug 2022 17:36:17 +0800 (CST)
Received: from localhost.huawei.com (10.137.16.204) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 12 Aug 2022 17:39:31 +0800
From:   sunsuwan <sunsuwan3@huawei.com>
To:     <horms@verge.net.au>, <ja@ssi.bg>, <pablo@netfilter.org>,
        <kadlec@netfilter.org>, <netdev@vger.kernel.org>,
        <lvs-devel@vger.kernel.org>
CC:     <chenzhen126@huawei.com>, <yanan@huawei.com>,
        <liaichun@huawei.com>, <caowangbao@huawei.com>,
        <sunsuwan3@huawei.com>
Subject: [PATCH] net:ipvs: add rcu read lock in some parts
Date:   Fri, 12 Aug 2022 17:34:12 +0800
Message-ID: <20220812093412.808351-1-sunsuwan3@huawei.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.137.16.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We founf a possible UAF if rmmod pe_sid or schedule,
when packages in hook and get pe or sched.

Signed-off-by: sunsuwan <sunsuwan3@huawei.com>
Signed-off-by: chenzhen <chenzhen126@huawei.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 6 ++++++
 net/netfilter/ipvs/ip_vs_ctl.c  | 3 +++
 net/netfilter/ipvs/ip_vs_dh.c   | 2 ++
 3 files changed, 11 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 51ad557a525b..d289f184d5c1 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -235,7 +235,9 @@ ip_vs_conn_fill_param_persist(const struct ip_vs_service *svc,
 {
 	ip_vs_conn_fill_param(svc->ipvs, svc->af, protocol, caddr, cport, vaddr,
 			      vport, p);
+	rcu_read_lock();
 	p->pe = rcu_dereference(svc->pe);
+	rcu_read_unlock();
 	if (p->pe && p->pe->fill_param)
 		return p->pe->fill_param(p, skb);
 
@@ -346,7 +348,9 @@ ip_vs_sched_persist(struct ip_vs_service *svc,
 		 * template is not available.
 		 * return *ignored=0 i.e. ICMP and NF_DROP
 		 */
+		rcu_read_lock();
 		sched = rcu_dereference(svc->scheduler);
+		rcu_read_unlock();
 		if (sched) {
 			/* read svc->sched_data after svc->scheduler */
 			smp_rmb();
@@ -521,7 +525,9 @@ ip_vs_schedule(struct ip_vs_service *svc, struct sk_buff *skb,
 		return NULL;
 	}
 
+	rcu_read_lock();
 	sched = rcu_dereference(svc->scheduler);
+	rcu_read_unlock();
 	if (sched) {
 		/* read svc->sched_data after svc->scheduler */
 		smp_rmb();
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index efab2b06d373..91e568028001 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -580,6 +580,7 @@ bool ip_vs_has_real_service(struct netns_ipvs *ipvs, int af, __u16 protocol,
 	/* Check for "full" addressed entries */
 	hash = ip_vs_rs_hashkey(af, daddr, dport);
 
+	rcu_read_lock();
 	hlist_for_each_entry_rcu(dest, &ipvs->rs_table[hash], d_list) {
 		if (dest->port == dport &&
 		    dest->af == af &&
@@ -587,9 +588,11 @@ bool ip_vs_has_real_service(struct netns_ipvs *ipvs, int af, __u16 protocol,
 		    (dest->protocol == protocol || dest->vfwmark) &&
 		    IP_VS_DFWD_METHOD(dest) == IP_VS_CONN_F_MASQ) {
 			/* HIT */
+			rcu_read_unlock();
 			return true;
 		}
 	}
+	rcu_read_unlock();
 
 	return false;
 }
diff --git a/net/netfilter/ipvs/ip_vs_dh.c b/net/netfilter/ipvs/ip_vs_dh.c
index 5e6ec32aff2b..3e4b9607172b 100644
--- a/net/netfilter/ipvs/ip_vs_dh.c
+++ b/net/netfilter/ipvs/ip_vs_dh.c
@@ -219,7 +219,9 @@ ip_vs_dh_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 	IP_VS_DBG(6, "%s(): Scheduling...\n", __func__);
 
 	s = (struct ip_vs_dh_state *) svc->sched_data;
+	rcu_read_lock();
 	dest = ip_vs_dh_get(svc->af, s, &iph->daddr);
+	rcu_read_unlock();
 	if (!dest
 	    || !(dest->flags & IP_VS_DEST_F_AVAILABLE)
 	    || atomic_read(&dest->weight) <= 0
-- 
2.30.0

