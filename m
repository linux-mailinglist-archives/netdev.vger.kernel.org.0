Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADABE20EE29
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 08:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbgF3GPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 02:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgF3GPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 02:15:19 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFADC061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:15:19 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t6so9463648pgq.1
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 23:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0t9I4K+PGD4udgvUDKyQgW/9AsOg3OY/iWhx6jB31gc=;
        b=QT9JMMP9g0okxvSGagV7J8wtxlYLDvGTwdqtmXyAHhYCEWU7Cp0EHEK0lmRCHCSooz
         RMZdJfbrcFYxDcgdVsSEUCBO4j9eYXMrA7C66ZPRV4L5d4DJJWRuJ4vxG1avsxgUXIz1
         ZjfYnc1KUcn/3T8FIxlcjtTq7Iy1iPrOCUAdZ2WGCbbBQSKs/c8IEtjP/wViAHtO5Gwk
         WUqHBq0P8r6kChmqb/4I8vb9SM/8Wn+pNs6TzSKeLY+yD+ewqXm0ayF9C8pf+GNBcS1b
         yNhHJjGr1dh8LkXM7rUYw3bJXaxyzGlegEcAKQJUMW2qTue9uzM+vfnP+ku/+QoYvUd3
         y6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0t9I4K+PGD4udgvUDKyQgW/9AsOg3OY/iWhx6jB31gc=;
        b=qMPV09tdOJQwD6AXU2PxrtqqAmC961UjaIYoMVotLqzDX7C7efAK94hvVbxkRr4nHt
         bNdg8yojpwWU7TbIAJpG/rZdnTYWwm+oKrD4zonNOaw5fEHrbgbCUDQ4vADfxp9x5elO
         NKUKjZDa3eQevfxauhrypUwKoVu+XnKoBM+AGQxDBQul4Jgp5TTJInMs4y5eIlvkPRGU
         0+fvoHwT4mO+hvWMkDPa/4KdMUQ6qGsuI9VzkiItioy+eN6qBwmDJdI+/YeQwrGQE66M
         SopZk7sYNQD8UUDYq94yZrse+5p7T6PQfrtUUfi0tK2JPA2CpcX9b4naU2vyRPJhCH4r
         K4NA==
X-Gm-Message-State: AOAM532k51huMMR8mo3F2OeKcjyeUo6QODZFOp0iobWb4sAL7u3VLs7s
        9g6CyVv9bJVq5ZOdSKsjm681JIGj
X-Google-Smtp-Source: ABdhPJyz/0E8aL4FTKAFUz7pnNypTa7kQIlsU9sAJ6ofMzpKFsPjQ11FSsJwix5AzmthlT8fBhUuEg==
X-Received: by 2002:a63:4521:: with SMTP id s33mr6963729pga.388.1593497717233;
        Mon, 29 Jun 2020 23:15:17 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s68sm1186131pjb.38.2020.06.29.23.15.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 23:15:15 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Tobias Brunner <tobias@strongswan.org>
Subject: [PATCH ipsec] xfrm: state: match with both mark and mask on user interfaces
Date:   Tue, 30 Jun 2020 14:15:08 +0800
Message-Id: <4aaead9f8306859eb652b90582f23295792e9d15.1593497708.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to commit 4f47e8ab6ab79 ("xfrm: policy: match with both mark and
mask on user interfaces"), this patch is to match both mark and mask for
state on these user interfaces:

  xfrm_state_lookup_byaddr_user
  xfrm_state_lookup_user
  xfrm_state_update
  xfrm_state_find
  xfrm_state_add
      __xfrm_state_lookup_byaddr(struct xfrm_mark)
      __xfrm_state_lookup(struct xfrm_mark)
  xfrm_find_acq_byseq
  xfrm_stateonly_find

          mark.v == x->mark.v && mark.m == x->mark.m

and leave the mark match for tx/rx path only:

  xfrm_state_lookup_byaddr
  xfrm_state_lookup
      __xfrm_state_lookup_byaddr(u32)
      __xfrm_state_lookup(u32)

          (mark & x->mark.m) == x->mark.v

Fixes: 3d6acfa7641f ("xfrm: SA lookups with mark")
Tested-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/xfrm.h    | 21 ++++++++---
 net/core/pktgen.c     |  4 +--
 net/key/af_key.c      |  4 +--
 net/xfrm/xfrm_state.c | 96 ++++++++++++++++++++++++++++++++++++---------------
 net/xfrm/xfrm_user.c  | 34 +++++++++---------
 5 files changed, 107 insertions(+), 52 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 5c20953..eb22627 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1480,7 +1480,8 @@ struct xfrm_state *xfrm_state_find(const xfrm_address_t *daddr,
 				   struct xfrm_tmpl *tmpl,
 				   struct xfrm_policy *pol, int *err,
 				   unsigned short family, u32 if_id);
-struct xfrm_state *xfrm_stateonly_find(struct net *net, u32 mark, u32 if_id,
+struct xfrm_state *xfrm_stateonly_find(struct net *net,
+				       const struct xfrm_mark *mark, u32 if_id,
 				       xfrm_address_t *daddr,
 				       xfrm_address_t *saddr,
 				       unsigned short family,
@@ -1491,6 +1492,11 @@ int xfrm_state_check_expire(struct xfrm_state *x);
 void xfrm_state_insert(struct xfrm_state *x);
 int xfrm_state_add(struct xfrm_state *x);
 int xfrm_state_update(struct xfrm_state *x);
+struct xfrm_state *xfrm_state_lookup_user(struct net *net,
+					  const struct xfrm_mark *mark,
+					  const xfrm_address_t *daddr,
+					  __be32 spi, u8 proto,
+					  unsigned short family);
 struct xfrm_state *xfrm_state_lookup(struct net *net, u32 mark,
 				     const xfrm_address_t *daddr, __be32 spi,
 				     u8 proto, unsigned short family);
@@ -1499,6 +1505,12 @@ struct xfrm_state *xfrm_state_lookup_byaddr(struct net *net, u32 mark,
 					    const xfrm_address_t *saddr,
 					    u8 proto,
 					    unsigned short family);
+struct xfrm_state *xfrm_state_lookup_byaddr_user(struct net *net,
+						 const struct xfrm_mark *mark,
+						 const xfrm_address_t *daddr,
+						 const xfrm_address_t *saddr,
+						 u8 proto,
+						 unsigned short family);
 #ifdef CONFIG_XFRM_SUB_POLICY
 void xfrm_tmpl_sort(struct xfrm_tmpl **dst, struct xfrm_tmpl **src, int n,
 		    unsigned short family);
@@ -1533,7 +1545,8 @@ struct xfrmk_spdinfo {
 	u32 spdhmcnt;
 };
 
-struct xfrm_state *xfrm_find_acq_byseq(struct net *net, u32 mark, u32 seq);
+struct xfrm_state *xfrm_find_acq_byseq(struct net *net,
+				       const struct xfrm_mark *mark, u32 seq);
 int xfrm_state_delete(struct xfrm_state *x);
 int xfrm_state_flush(struct net *net, u8 proto, bool task_valid, bool sync);
 int xfrm_dev_state_flush(struct net *net, struct net_device *dev, bool task_valid);
@@ -1938,14 +1951,12 @@ static inline bool xfrm_dst_offload_ok(struct dst_entry *dst)
 }
 #endif
 
-static inline int xfrm_mark_get(struct nlattr **attrs, struct xfrm_mark *m)
+static inline void xfrm_mark_get(struct nlattr **attrs, struct xfrm_mark *m)
 {
 	if (attrs[XFRMA_MARK])
 		memcpy(m, nla_data(attrs[XFRMA_MARK]), sizeof(struct xfrm_mark));
 	else
 		m->v = m->m = 0;
-
-	return m->v & m->m;
 }
 
 static inline int xfrm_mark_put(struct sk_buff *skb, const struct xfrm_mark *m)
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index b53b6d3..4264f84 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2233,7 +2233,7 @@ static inline int f_pick(struct pktgen_dev *pkt_dev)
 /* If there was already an IPSEC SA, we keep it as is, else
  * we go look for it ...
 */
-#define DUMMY_MARK 0
+static const struct xfrm_mark dummy_mark = {0, 0};
 static void get_ipsec_sa(struct pktgen_dev *pkt_dev, int flow)
 {
 	struct xfrm_state *x = pkt_dev->flows[flow].x;
@@ -2247,7 +2247,7 @@ static void get_ipsec_sa(struct pktgen_dev *pkt_dev, int flow)
 			x = xfrm_state_lookup_byspi(pn->net, htonl(pkt_dev->spi), AF_INET);
 		} else {
 			/* slow path: we dont already have xfrm_state */
-			x = xfrm_stateonly_find(pn->net, DUMMY_MARK, 0,
+			x = xfrm_stateonly_find(pn->net, &dummy_mark, 0,
 						(xfrm_address_t *)&pkt_dev->cur_daddr,
 						(xfrm_address_t *)&pkt_dev->cur_saddr,
 						AF_INET,
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 979c579..e48fb94 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1359,7 +1359,7 @@ static int pfkey_getspi(struct sock *sk, struct sk_buff *skb, const struct sadb_
 	}
 
 	if (hdr->sadb_msg_seq) {
-		x = xfrm_find_acq_byseq(net, DUMMY_MARK, hdr->sadb_msg_seq);
+		x = xfrm_find_acq_byseq(net, &dummy_mark, hdr->sadb_msg_seq);
 		if (x && !xfrm_addr_equal(&x->id.daddr, xdaddr, family)) {
 			xfrm_state_put(x);
 			x = NULL;
@@ -1422,7 +1422,7 @@ static int pfkey_acquire(struct sock *sk, struct sk_buff *skb, const struct sadb
 	if (hdr->sadb_msg_seq == 0 || hdr->sadb_msg_errno == 0)
 		return 0;
 
-	x = xfrm_find_acq_byseq(net, DUMMY_MARK, hdr->sadb_msg_seq);
+	x = xfrm_find_acq_byseq(net, &dummy_mark, hdr->sadb_msg_seq);
 	if (x == NULL)
 		return 0;
 
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 8be2d92..dd566d6 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -927,7 +927,17 @@ xfrm_init_tempstate(struct xfrm_state *x, const struct flowi *fl,
 	x->props.family = tmpl->encap_family;
 }
 
+static inline bool xfrm_state_mark_match(const struct xfrm_mark *m, u32 mark,
+					 struct xfrm_state *x)
+{
+	if (m)
+		return m->v == x->mark.v && m->m == x->mark.m;
+
+	return (mark & x->mark.m) == x->mark.v;
+}
+
 static struct xfrm_state *__xfrm_state_lookup(struct net *net, u32 mark,
+					      const struct xfrm_mark *m,
 					      const xfrm_address_t *daddr,
 					      __be32 spi, u8 proto,
 					      unsigned short family)
@@ -942,7 +952,7 @@ static struct xfrm_state *__xfrm_state_lookup(struct net *net, u32 mark,
 		    !xfrm_addr_equal(&x->id.daddr, daddr, family))
 			continue;
 
-		if ((mark & x->mark.m) != x->mark.v)
+		if (!xfrm_state_mark_match(m, mark, x))
 			continue;
 		if (!xfrm_state_hold_rcu(x))
 			continue;
@@ -953,6 +963,7 @@ static struct xfrm_state *__xfrm_state_lookup(struct net *net, u32 mark,
 }
 
 static struct xfrm_state *__xfrm_state_lookup_byaddr(struct net *net, u32 mark,
+						     const struct xfrm_mark *m,
 						     const xfrm_address_t *daddr,
 						     const xfrm_address_t *saddr,
 						     u8 proto, unsigned short family)
@@ -967,7 +978,7 @@ static struct xfrm_state *__xfrm_state_lookup_byaddr(struct net *net, u32 mark,
 		    !xfrm_addr_equal(&x->props.saddr, saddr, family))
 			continue;
 
-		if ((mark & x->mark.m) != x->mark.v)
+		if (!xfrm_state_mark_match(m, mark, x))
 			continue;
 		if (!xfrm_state_hold_rcu(x))
 			continue;
@@ -981,13 +992,12 @@ static inline struct xfrm_state *
 __xfrm_state_locate(struct xfrm_state *x, int use_spi, int family)
 {
 	struct net *net = xs_net(x);
-	u32 mark = x->mark.v & x->mark.m;
 
 	if (use_spi)
-		return __xfrm_state_lookup(net, mark, &x->id.daddr,
+		return __xfrm_state_lookup(net, 0, &x->mark, &x->id.daddr,
 					   x->id.spi, x->id.proto, family);
 	else
-		return __xfrm_state_lookup_byaddr(net, mark,
+		return __xfrm_state_lookup_byaddr(net, 0, &x->mark,
 						  &x->id.daddr,
 						  &x->props.saddr,
 						  x->id.proto, family);
@@ -1051,7 +1061,6 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	int acquire_in_progress = 0;
 	int error = 0;
 	struct xfrm_state *best = NULL;
-	u32 mark = pol->mark.v & pol->mark.m;
 	unsigned short encap_family = tmpl->encap_family;
 	unsigned int sequence;
 	struct km_event c;
@@ -1065,7 +1074,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h, bydst) {
 		if (x->props.family == encap_family &&
 		    x->props.reqid == tmpl->reqid &&
-		    (mark & x->mark.m) == x->mark.v &&
+		    (pol->mark.v == x->mark.v && pol->mark.m == x->mark.m) &&
 		    x->if_id == if_id &&
 		    !(x->props.flags & XFRM_STATE_WILDRECV) &&
 		    xfrm_state_addr_check(x, daddr, saddr, encap_family) &&
@@ -1082,7 +1091,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h_wildcard, bydst) {
 		if (x->props.family == encap_family &&
 		    x->props.reqid == tmpl->reqid &&
-		    (mark & x->mark.m) == x->mark.v &&
+		    (pol->mark.v == x->mark.v && pol->mark.m == x->mark.m) &&
 		    x->if_id == if_id &&
 		    !(x->props.flags & XFRM_STATE_WILDRECV) &&
 		    xfrm_addr_equal(&x->id.daddr, daddr, encap_family) &&
@@ -1097,8 +1106,9 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	x = best;
 	if (!x && !error && !acquire_in_progress) {
 		if (tmpl->id.spi &&
-		    (x0 = __xfrm_state_lookup(net, mark, daddr, tmpl->id.spi,
-					      tmpl->id.proto, encap_family)) != NULL) {
+		    (x0 = __xfrm_state_lookup(net, 0, &pol->mark, daddr,
+					      tmpl->id.spi, tmpl->id.proto,
+					      encap_family)) != NULL) {
 			to_put = x0;
 			error = -EEXIST;
 			goto out;
@@ -1183,7 +1193,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 }
 
 struct xfrm_state *
-xfrm_stateonly_find(struct net *net, u32 mark, u32 if_id,
+xfrm_stateonly_find(struct net *net, const struct xfrm_mark *mark, u32 if_id,
 		    xfrm_address_t *daddr, xfrm_address_t *saddr,
 		    unsigned short family, u8 mode, u8 proto, u32 reqid)
 {
@@ -1195,7 +1205,7 @@ xfrm_stateonly_find(struct net *net, u32 mark, u32 if_id,
 	hlist_for_each_entry(x, net->xfrm.state_bydst+h, bydst) {
 		if (x->props.family == family &&
 		    x->props.reqid == reqid &&
-		    (mark & x->mark.m) == x->mark.v &&
+		    (mark->v == x->mark.v && mark->m == x->mark.m) &&
 		    x->if_id == if_id &&
 		    !(x->props.flags & XFRM_STATE_WILDRECV) &&
 		    xfrm_state_addr_check(x, daddr, saddr, family) &&
@@ -1276,7 +1286,6 @@ static void __xfrm_state_bump_genids(struct xfrm_state *xnew)
 	u32 reqid = xnew->props.reqid;
 	struct xfrm_state *x;
 	unsigned int h;
-	u32 mark = xnew->mark.v & xnew->mark.m;
 	u32 if_id = xnew->if_id;
 
 	h = xfrm_dst_hash(net, &xnew->id.daddr, &xnew->props.saddr, reqid, family);
@@ -1284,7 +1293,7 @@ static void __xfrm_state_bump_genids(struct xfrm_state *xnew)
 		if (x->props.family	== family &&
 		    x->props.reqid	== reqid &&
 		    x->if_id		== if_id &&
-		    (mark & x->mark.m) == x->mark.v &&
+		    (xnew->mark.v == x->mark.v && xnew->mark.m == x->mark.m) &&
 		    xfrm_addr_equal(&x->id.daddr, &xnew->id.daddr, family) &&
 		    xfrm_addr_equal(&x->props.saddr, &xnew->props.saddr, family))
 			x->genid++;
@@ -1313,7 +1322,6 @@ static struct xfrm_state *__find_acq_core(struct net *net,
 {
 	unsigned int h = xfrm_dst_hash(net, daddr, saddr, reqid, family);
 	struct xfrm_state *x;
-	u32 mark = m->v & m->m;
 
 	hlist_for_each_entry(x, net->xfrm.state_bydst+h, bydst) {
 		if (x->props.reqid  != reqid ||
@@ -1322,7 +1330,7 @@ static struct xfrm_state *__find_acq_core(struct net *net,
 		    x->km.state     != XFRM_STATE_ACQ ||
 		    x->id.spi       != 0 ||
 		    x->id.proto	    != proto ||
-		    (mark & x->mark.m) != x->mark.v ||
+		    (m->v != x->mark.v || m->m != x->mark.m) ||
 		    !xfrm_addr_equal(&x->id.daddr, daddr, family) ||
 		    !xfrm_addr_equal(&x->props.saddr, saddr, family))
 			continue;
@@ -1382,7 +1390,8 @@ static struct xfrm_state *__find_acq_core(struct net *net,
 	return x;
 }
 
-static struct xfrm_state *__xfrm_find_acq_byseq(struct net *net, u32 mark, u32 seq);
+static struct xfrm_state *
+__xfrm_find_acq_byseq(struct net *net, const struct xfrm_mark *mark, u32 seq);
 
 int xfrm_state_add(struct xfrm_state *x)
 {
@@ -1390,7 +1399,6 @@ int xfrm_state_add(struct xfrm_state *x)
 	struct xfrm_state *x1, *to_put;
 	int family;
 	int err;
-	u32 mark = x->mark.v & x->mark.m;
 	int use_spi = xfrm_id_proto_match(x->id.proto, IPSEC_PROTO_ANY);
 
 	family = x->props.family;
@@ -1408,7 +1416,7 @@ int xfrm_state_add(struct xfrm_state *x)
 	}
 
 	if (use_spi && x->km.seq) {
-		x1 = __xfrm_find_acq_byseq(net, mark, x->km.seq);
+		x1 = __xfrm_find_acq_byseq(net, &x->mark, x->km.seq);
 		if (x1 && ((x1->id.proto != x->id.proto) ||
 		    !xfrm_addr_equal(&x1->id.daddr, &x->id.daddr, family))) {
 			to_put = x1;
@@ -1734,13 +1742,27 @@ xfrm_state_lookup(struct net *net, u32 mark, const xfrm_address_t *daddr, __be32
 	struct xfrm_state *x;
 
 	rcu_read_lock();
-	x = __xfrm_state_lookup(net, mark, daddr, spi, proto, family);
+	x = __xfrm_state_lookup(net, mark, NULL, daddr, spi, proto, family);
 	rcu_read_unlock();
 	return x;
 }
 EXPORT_SYMBOL(xfrm_state_lookup);
 
 struct xfrm_state *
+xfrm_state_lookup_user(struct net *net, const struct xfrm_mark *mark,
+		       const xfrm_address_t *daddr, __be32 spi,
+		       u8 proto, unsigned short family)
+{
+	struct xfrm_state *x;
+
+	rcu_read_lock();
+	return __xfrm_state_lookup(net, 0, mark, daddr, spi, proto, family);
+	rcu_read_unlock();
+	return x;
+}
+EXPORT_SYMBOL(xfrm_state_lookup_user);
+
+struct xfrm_state *
 xfrm_state_lookup_byaddr(struct net *net, u32 mark,
 			 const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 			 u8 proto, unsigned short family)
@@ -1748,13 +1770,29 @@ xfrm_state_lookup_byaddr(struct net *net, u32 mark,
 	struct xfrm_state *x;
 
 	spin_lock_bh(&net->xfrm.xfrm_state_lock);
-	x = __xfrm_state_lookup_byaddr(net, mark, daddr, saddr, proto, family);
+	x = __xfrm_state_lookup_byaddr(net, mark, NULL, daddr, saddr, proto, family);
 	spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 	return x;
 }
 EXPORT_SYMBOL(xfrm_state_lookup_byaddr);
 
 struct xfrm_state *
+xfrm_state_lookup_byaddr_user(struct net *net, const struct xfrm_mark *mark,
+			      const xfrm_address_t *daddr,
+			      const xfrm_address_t *saddr,
+			      u8 proto, unsigned short family)
+{
+	struct xfrm_state *x;
+
+	spin_lock_bh(&net->xfrm.xfrm_state_lock);
+	x = __xfrm_state_lookup_byaddr(net, 0, mark, daddr, saddr, proto,
+				       family);
+	spin_unlock_bh(&net->xfrm.xfrm_state_lock);
+	return x;
+}
+EXPORT_SYMBOL(xfrm_state_lookup_byaddr_user);
+
+struct xfrm_state *
 xfrm_find_acq(struct net *net, const struct xfrm_mark *mark, u8 mode, u32 reqid,
 	      u32 if_id, u8 proto, const xfrm_address_t *daddr,
 	      const xfrm_address_t *saddr, int create, unsigned short family)
@@ -1897,7 +1935,8 @@ xfrm_state_sort(struct xfrm_state **dst, struct xfrm_state **src, int n,
 
 /* Silly enough, but I'm lazy to build resolution list */
 
-static struct xfrm_state *__xfrm_find_acq_byseq(struct net *net, u32 mark, u32 seq)
+static struct xfrm_state *
+__xfrm_find_acq_byseq(struct net *net, const struct xfrm_mark *mark, u32 seq)
 {
 	int i;
 
@@ -1906,7 +1945,7 @@ static struct xfrm_state *__xfrm_find_acq_byseq(struct net *net, u32 mark, u32 s
 
 		hlist_for_each_entry(x, net->xfrm.state_bydst+i, bydst) {
 			if (x->km.seq == seq &&
-			    (mark & x->mark.m) == x->mark.v &&
+			    (mark->v == x->mark.v && mark->m == x->mark.m) &&
 			    x->km.state == XFRM_STATE_ACQ) {
 				xfrm_state_hold(x);
 				return x;
@@ -1916,7 +1955,8 @@ static struct xfrm_state *__xfrm_find_acq_byseq(struct net *net, u32 mark, u32 s
 	return NULL;
 }
 
-struct xfrm_state *xfrm_find_acq_byseq(struct net *net, u32 mark, u32 seq)
+struct xfrm_state *
+xfrm_find_acq_byseq(struct net *net, const struct xfrm_mark *mark, u32 seq)
 {
 	struct xfrm_state *x;
 
@@ -1972,7 +2012,6 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
 	int err = -ENOENT;
 	__be32 minspi = htonl(low);
 	__be32 maxspi = htonl(high);
-	u32 mark = x->mark.v & x->mark.m;
 
 	spin_lock_bh(&x->lock);
 	if (x->km.state == XFRM_STATE_DEAD)
@@ -1985,7 +2024,8 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
 	err = -ENOENT;
 
 	if (minspi == maxspi) {
-		x0 = xfrm_state_lookup(net, mark, &x->id.daddr, minspi, x->id.proto, x->props.family);
+		x0 = xfrm_state_lookup_user(net, &x->mark, &x->id.daddr, minspi,
+					    x->id.proto, x->props.family);
 		if (x0) {
 			xfrm_state_put(x0);
 			goto unlock;
@@ -1995,7 +2035,9 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
 		u32 spi = 0;
 		for (h = 0; h < high-low+1; h++) {
 			spi = low + prandom_u32()%(high-low+1);
-			x0 = xfrm_state_lookup(net, mark, &x->id.daddr, htonl(spi), x->id.proto, x->props.family);
+			x0 = xfrm_state_lookup_user(net, &x->mark, &x->id.daddr,
+						    htonl(spi), x->id.proto,
+						    x->props.family);
 			if (x0 == NULL) {
 				x->id.spi = htonl(spi);
 				break;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index fbb7d9d0..43a95e4 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -721,11 +721,13 @@ static struct xfrm_state *xfrm_user_state_lookup(struct net *net,
 	struct xfrm_state *x = NULL;
 	struct xfrm_mark m;
 	int err;
-	u32 mark = xfrm_mark_get(attrs, &m);
+
+	xfrm_mark_get(attrs, &m);
 
 	if (xfrm_id_proto_match(p->proto, IPSEC_PROTO_ANY)) {
 		err = -ESRCH;
-		x = xfrm_state_lookup(net, mark, &p->daddr, p->spi, p->proto, p->family);
+		x = xfrm_state_lookup_user(net, &m, &p->daddr, p->spi, p->proto,
+					   p->family);
 	} else {
 		xfrm_address_t *saddr = NULL;
 
@@ -736,9 +738,8 @@ static struct xfrm_state *xfrm_user_state_lookup(struct net *net,
 		}
 
 		err = -ESRCH;
-		x = xfrm_state_lookup_byaddr(net, mark,
-					     &p->daddr, saddr,
-					     p->proto, p->family);
+		x = xfrm_state_lookup_byaddr_user(net, &m, &p->daddr, saddr,
+						  p->proto, p->family);
 	}
 
  out:
@@ -1312,7 +1313,6 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 	xfrm_address_t *daddr;
 	int family;
 	int err;
-	u32 mark;
 	struct xfrm_mark m;
 	u32 if_id = 0;
 
@@ -1326,13 +1326,13 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	x = NULL;
 
-	mark = xfrm_mark_get(attrs, &m);
+	xfrm_mark_get(attrs, &m);
 
 	if (attrs[XFRMA_IF_ID])
 		if_id = nla_get_u32(attrs[XFRMA_IF_ID]);
 
 	if (p->info.seq) {
-		x = xfrm_find_acq_byseq(net, mark, p->info.seq);
+		x = xfrm_find_acq_byseq(net, &m, p->info.seq);
 		if (x && !xfrm_addr_equal(&x->id.daddr, daddr, family)) {
 			xfrm_state_put(x);
 			x = NULL;
@@ -2043,14 +2043,14 @@ static int xfrm_get_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct sk_buff *r_skb;
 	int err;
 	struct km_event c;
-	u32 mark;
 	struct xfrm_mark m;
 	struct xfrm_aevent_id *p = nlmsg_data(nlh);
 	struct xfrm_usersa_id *id = &p->sa_id;
 
-	mark = xfrm_mark_get(attrs, &m);
+	xfrm_mark_get(attrs, &m);
 
-	x = xfrm_state_lookup(net, mark, &id->daddr, id->spi, id->proto, id->family);
+	x = xfrm_state_lookup_user(net, &m, &id->daddr, id->spi, id->proto,
+				   id->family);
 	if (x == NULL)
 		return -ESRCH;
 
@@ -2086,7 +2086,6 @@ static int xfrm_new_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct xfrm_state *x;
 	struct km_event c;
 	int err = -EINVAL;
-	u32 mark = 0;
 	struct xfrm_mark m;
 	struct xfrm_aevent_id *p = nlmsg_data(nlh);
 	struct nlattr *rp = attrs[XFRMA_REPLAY_VAL];
@@ -2102,9 +2101,10 @@ static int xfrm_new_ae(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!(nlh->nlmsg_flags&NLM_F_REPLACE))
 		return err;
 
-	mark = xfrm_mark_get(attrs, &m);
+	xfrm_mark_get(attrs, &m);
 
-	x = xfrm_state_lookup(net, mark, &p->sa_id.daddr, p->sa_id.spi, p->sa_id.proto, p->sa_id.family);
+	x = xfrm_state_lookup_user(net, &m, &p->sa_id.daddr, p->sa_id.spi,
+				   p->sa_id.proto, p->sa_id.family);
 	if (x == NULL)
 		return -ESRCH;
 
@@ -2233,9 +2233,11 @@ static int xfrm_add_sa_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct xfrm_user_expire *ue = nlmsg_data(nlh);
 	struct xfrm_usersa_info *p = &ue->state;
 	struct xfrm_mark m;
-	u32 mark = xfrm_mark_get(attrs, &m);
 
-	x = xfrm_state_lookup(net, mark, &p->id.daddr, p->id.spi, p->id.proto, p->family);
+	xfrm_mark_get(attrs, &m);
+
+	x = xfrm_state_lookup_user(net, &m, &p->id.daddr, p->id.spi,
+				   p->id.proto, p->family);
 
 	err = -ENOENT;
 	if (x == NULL)
-- 
2.1.0

