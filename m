Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB024791CA
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 17:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239198AbhLQQqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 11:46:30 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:44106 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235989AbhLQQqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 11:46:30 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CD8C22052D;
        Fri, 17 Dec 2021 17:46:27 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8bFnA5xgBgoy; Fri, 17 Dec 2021 17:46:27 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 34FDF20265;
        Fri, 17 Dec 2021 17:46:27 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 2FA2C80004A;
        Fri, 17 Dec 2021 17:46:27 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 17 Dec 2021 17:46:27 +0100
Received: from moon.secunet.de (172.18.149.1) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 17 Dec
 2021 17:46:26 +0100
Date:   Fri, 17 Dec 2021 17:46:18 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     Thomas Egerer <thomas.egerer@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Antony Antony <antony.antony@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH ipsec-next v2] xfrm: rate limit SA mapping change message to
 user space
Message-ID: <e7382eefea550d10cb5f13030dbe809f0366c9bf.1639758955.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
References: <YafsUMtO+zj/2xcC@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YafsUMtO+zj/2xcC@moon.secunet.de>
Organization: secunet
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel generates mapping change message, XFRM_MSG_MAPPING,
when a source port change is detected on a input state with UDP
encapsulation set. Kernel generates a message for each IPsec packet
with new source port. For a high speed flow per packet mapping change
message can be excessive, and can overload the user space listener.

Introduce rate limiting for XFRM_MSG_MAPPING message to the user space.

The rate limiting is configurable via netlink, when adding a new SA or
updating it. Use the new attribute XFRMA_MTIMER_THRESH in seconds.

v1->v2 change:
	update xfrm_sa_len()

Co-developed-by: Thomas Egerer <thomas.egerer@secunet.com>
Signed-off-by: Thomas Egerer <thomas.egerer@secunet.com>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 include/net/xfrm.h        |  5 +++++
 include/uapi/linux/xfrm.h |  1 +
 net/xfrm/xfrm_state.c     | 23 ++++++++++++++++++++++-
 net/xfrm/xfrm_user.c      | 15 ++++++++++++++-
 4 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 2308210793a0..f3842f6bf40d 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -232,6 +232,11 @@ struct xfrm_state {
 	u32			replay_maxage;
 	u32			replay_maxdiff;

+	/* mapping change rate limiting */
+	unsigned long new_mapping;	/* jiffies */
+	unsigned long mapping_maxage;	/* jiffies for input SA */
+	__be16 new_mapping_sport;
+
 	/* Replay detection notification timer */
 	struct timer_list	rtimer;

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index eda0426ec4c2..4e29d7851890 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -313,6 +313,7 @@ enum xfrm_attr_type_t {
 	XFRMA_SET_MARK,		/* __u32 */
 	XFRMA_SET_MARK_MASK,	/* __u32 */
 	XFRMA_IF_ID,		/* __u32 */
+	XFRMA_MTIMER_THRESH,	/* __u32 in seconds for input SA */
 	__XFRMA_MAX

 #define XFRMA_OUTPUT_MARK XFRMA_SET_MARK	/* Compatibility */
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index a2f4001221d1..5d28de6416f6 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1593,6 +1593,9 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	x->km.seq = orig->km.seq;
 	x->replay = orig->replay;
 	x->preplay = orig->preplay;
+	x->mapping_maxage = orig->mapping_maxage;
+	x->new_mapping = 0;
+	x->new_mapping_sport = 0;

 	return x;

@@ -2242,7 +2245,7 @@ int km_query(struct xfrm_state *x, struct xfrm_tmpl *t, struct xfrm_policy *pol)
 }
 EXPORT_SYMBOL(km_query);

-int km_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr, __be16 sport)
+static int __km_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr, __be16 sport)
 {
 	int err = -EINVAL;
 	struct xfrm_mgr *km;
@@ -2257,6 +2260,24 @@ int km_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr, __be16 sport)
 	rcu_read_unlock();
 	return err;
 }
+
+int km_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr, __be16 sport)
+{
+	int ret = 0;
+
+	if (x->mapping_maxage) {
+		if ((jiffies - x->new_mapping) > x->mapping_maxage ||
+		    x->new_mapping_sport != sport) {
+			x->new_mapping_sport = sport;
+			x->new_mapping = jiffies;
+			ret = __km_new_mapping(x, ipaddr, sport);
+		}
+	} else {
+		ret = __km_new_mapping(x, ipaddr, sport);
+	}
+
+	return ret;
+}
 EXPORT_SYMBOL(km_new_mapping);

 void km_policy_expired(struct xfrm_policy *pol, int dir, int hard, u32 portid)
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 7c36cc1f3d79..61c6615ea586 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -521,6 +521,7 @@ static void xfrm_update_ae_params(struct xfrm_state *x, struct nlattr **attrs,
 	struct nlattr *lt = attrs[XFRMA_LTIME_VAL];
 	struct nlattr *et = attrs[XFRMA_ETIMER_THRESH];
 	struct nlattr *rt = attrs[XFRMA_REPLAY_THRESH];
+	struct nlattr *mt = attrs[XFRMA_MTIMER_THRESH];

 	if (re) {
 		struct xfrm_replay_state_esn *replay_esn;
@@ -552,6 +553,9 @@ static void xfrm_update_ae_params(struct xfrm_state *x, struct nlattr **attrs,

 	if (rt)
 		x->replay_maxdiff = nla_get_u32(rt);
+
+	if (mt)
+		x->mapping_maxage = nla_get_u32(mt);
 }

 static void xfrm_smark_init(struct nlattr **attrs, struct xfrm_mark *m)
@@ -1024,8 +1028,14 @@ static int copy_to_user_state_extra(struct xfrm_state *x,
 		if (ret)
 			goto out;
 	}
-	if (x->security)
+	if (x->security) {
 		ret = copy_sec_ctx(x->security, skb);
+		if (ret)
+			goto out;
+	}
+	if (x->mapping_maxage)
+		ret = nla_put_u32(skb, XFRMA_MTIMER_THRESH,
+				  (x->mapping_maxage / HZ));
 out:
 	return ret;
 }
@@ -3069,6 +3079,9 @@ static inline unsigned int xfrm_sa_len(struct xfrm_state *x)
 	/* Must count x->lastused as it may become non-zero behind our back. */
 	l += nla_total_size_64bit(sizeof(u64));

+	if (x->mapping_maxage)
+		l += nla_total_size(sizeof(x->mapping_maxage));
+
 	return l;
 }

--
2.30.2

