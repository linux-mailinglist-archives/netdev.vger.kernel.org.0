Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7472B34FB68
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhCaITa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:19:30 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48056 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234383AbhCaIS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 04:18:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4A5DC205CB;
        Wed, 31 Mar 2021 10:18:55 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id OkyaQld7DrPB; Wed, 31 Mar 2021 10:18:54 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D6AD120590;
        Wed, 31 Mar 2021 10:18:53 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 31 Mar 2021 10:18:53 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 31 Mar
 2021 10:18:53 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9479E31805E1; Wed, 31 Mar 2021 10:18:52 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 05/11] net: xfrm: Localize sequence counter per network namespace
Date:   Wed, 31 Mar 2021 10:18:41 +0200
Message-ID: <20210331081847.3547641-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331081847.3547641-1-steffen.klassert@secunet.com>
References: <20210331081847.3547641-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

A sequence counter write section must be serialized or its internal
state can get corrupted. The "xfrm_state_hash_generation" seqcount is
global, but its write serialization lock (net->xfrm.xfrm_state_lock) is
instantiated per network namespace. The write protection is thus
insufficient.

To provide full protection, localize the sequence counter per network
namespace instead. This should be safe as both the seqcount read and
write sections access data exclusively within the network namespace. It
also lays the foundation for transforming "xfrm_state_hash_generation"
data type from seqcount_t to seqcount_LOCKNAME_t in further commits.

Fixes: b65e3d7be06f ("xfrm: state: add sequence count to detect hash resizes")
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/netns/xfrm.h |  4 +++-
 net/xfrm/xfrm_state.c    | 10 +++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index 59f45b1e9dac..b59d73d529ba 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -72,7 +72,9 @@ struct netns_xfrm {
 #if IS_ENABLED(CONFIG_IPV6)
 	struct dst_ops		xfrm6_dst_ops;
 #endif
-	spinlock_t xfrm_state_lock;
+	spinlock_t		xfrm_state_lock;
+	seqcount_t		xfrm_state_hash_generation;
+
 	spinlock_t xfrm_policy_lock;
 	struct mutex xfrm_cfg_mutex;
 };
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index d01ca1a18418..ffd315cff984 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -44,7 +44,6 @@ static void xfrm_state_gc_task(struct work_struct *work);
  */
 
 static unsigned int xfrm_state_hashmax __read_mostly = 1 * 1024 * 1024;
-static __read_mostly seqcount_t xfrm_state_hash_generation = SEQCNT_ZERO(xfrm_state_hash_generation);
 static struct kmem_cache *xfrm_state_cache __ro_after_init;
 
 static DECLARE_WORK(xfrm_state_gc_work, xfrm_state_gc_task);
@@ -140,7 +139,7 @@ static void xfrm_hash_resize(struct work_struct *work)
 	}
 
 	spin_lock_bh(&net->xfrm.xfrm_state_lock);
-	write_seqcount_begin(&xfrm_state_hash_generation);
+	write_seqcount_begin(&net->xfrm.xfrm_state_hash_generation);
 
 	nhashmask = (nsize / sizeof(struct hlist_head)) - 1U;
 	odst = xfrm_state_deref_prot(net->xfrm.state_bydst, net);
@@ -156,7 +155,7 @@ static void xfrm_hash_resize(struct work_struct *work)
 	rcu_assign_pointer(net->xfrm.state_byspi, nspi);
 	net->xfrm.state_hmask = nhashmask;
 
-	write_seqcount_end(&xfrm_state_hash_generation);
+	write_seqcount_end(&net->xfrm.xfrm_state_hash_generation);
 	spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 
 	osize = (ohashmask + 1) * sizeof(struct hlist_head);
@@ -1063,7 +1062,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 
 	to_put = NULL;
 
-	sequence = read_seqcount_begin(&xfrm_state_hash_generation);
+	sequence = read_seqcount_begin(&net->xfrm.xfrm_state_hash_generation);
 
 	rcu_read_lock();
 	h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);
@@ -1176,7 +1175,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	if (to_put)
 		xfrm_state_put(to_put);
 
-	if (read_seqcount_retry(&xfrm_state_hash_generation, sequence)) {
+	if (read_seqcount_retry(&net->xfrm.xfrm_state_hash_generation, sequence)) {
 		*err = -EAGAIN;
 		if (x) {
 			xfrm_state_put(x);
@@ -2666,6 +2665,7 @@ int __net_init xfrm_state_init(struct net *net)
 	net->xfrm.state_num = 0;
 	INIT_WORK(&net->xfrm.state_hash_work, xfrm_hash_resize);
 	spin_lock_init(&net->xfrm.xfrm_state_lock);
+	seqcount_init(&net->xfrm.xfrm_state_hash_generation);
 	return 0;
 
 out_byspi:
-- 
2.25.1

