Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D72D491E12
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351082AbiARDqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351294AbiARCyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:54:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C468C02B8F7;
        Mon, 17 Jan 2022 18:43:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2B2361118;
        Tue, 18 Jan 2022 02:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73166C36AF3;
        Tue, 18 Jan 2022 02:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473822;
        bh=k4YHYUEkLQiykImUM3+wGrUVq8FrjWbRbWJ+gAjVcuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeWDEvuY8h0rI/rbQm09g4Wanj7kZEU8FsEqNmI711X5EASIkyRYEnCU++c/7cFVJ
         8wz2Gs2zygqQAGcCBqEdlUW5txJD4m4gRCH22Z6aqw+nkFKEMMeB8fEJS+nzE9KQGj
         fxsbO8Y/IL1bMjtflPXaBrZouaWGuPl0ymUE+hNVP91tayCRJanmaBxRpBP+lARq6o
         uDBDZ5aWueRW4f6qIlzxAt9dfHG85as8rmnoCLgXZTP6EPmJb1mYLa1Tf5q6tXPfNS
         UEHGaeRJCZZq94JvKQNao5e8z2Mx/yjF+WbwnujrldzPEA9ktyM6XRMzEYqwjCZMzt
         2V66MSeh25e/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antony Antony <antony.antony@secunet.com>,
        Thomas Egerer <thomas.egerer@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 087/116] xfrm: rate limit SA mapping change message to user space
Date:   Mon, 17 Jan 2022 21:39:38 -0500
Message-Id: <20220118024007.1950576-87-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit 4e484b3e969b52effd95c17f7a86f39208b2ccf4 ]

Kernel generates mapping change message, XFRM_MSG_MAPPING,
when a source port chage is detected on a input state with UDP
encapsulation set.  Kernel generates a message for each IPsec packet
with new source port.  For a high speed flow per packet mapping change
message can be excessive, and can overload the user space listener.

Introduce rate limiting for XFRM_MSG_MAPPING message to the user space.

The rate limiting is configurable via netlink, when adding a new SA or
updating it. Use the new attribute XFRMA_MTIMER_THRESH in seconds.

v1->v2 change:
	update xfrm_sa_len()

v2->v3 changes:
	use u32 insted unsigned long to reduce size of struct xfrm_state
	fix xfrm_ompat size Reported-by: kernel test robot <lkp@intel.com>
	accept XFRM_MSG_MAPPING only when XFRMA_ENCAP is present

Co-developed-by: Thomas Egerer <thomas.egerer@secunet.com>
Signed-off-by: Thomas Egerer <thomas.egerer@secunet.com>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h        |  5 +++++
 include/uapi/linux/xfrm.h |  1 +
 net/xfrm/xfrm_compat.c    |  6 ++++--
 net/xfrm/xfrm_state.c     | 23 ++++++++++++++++++++++-
 net/xfrm/xfrm_user.c      | 18 +++++++++++++++++-
 5 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 6232a5f048bde..337d29875e518 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -193,6 +193,11 @@ struct xfrm_state {
 	struct xfrm_algo_aead	*aead;
 	const char		*geniv;
 
+	/* mapping change rate limiting */
+	__be16 new_mapping_sport;
+	u32 new_mapping;	/* seconds */
+	u32 mapping_maxage;	/* seconds for input SA */
+
 	/* Data for encapsulator */
 	struct xfrm_encap_tmpl	*encap;
 	struct sock __rcu	*encap_sk;
diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index ffc6a5391bb7b..2290c98b47cf8 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -308,6 +308,7 @@ enum xfrm_attr_type_t {
 	XFRMA_SET_MARK,		/* __u32 */
 	XFRMA_SET_MARK_MASK,	/* __u32 */
 	XFRMA_IF_ID,		/* __u32 */
+	XFRMA_MTIMER_THRESH,	/* __u32 in seconds for input SA */
 	__XFRMA_MAX
 
 #define XFRMA_OUTPUT_MARK XFRMA_SET_MARK	/* Compatibility */
diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index 2bf2693901631..a0f62fa02e06e 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -127,6 +127,7 @@ static const struct nla_policy compat_policy[XFRMA_MAX+1] = {
 	[XFRMA_SET_MARK]	= { .type = NLA_U32 },
 	[XFRMA_SET_MARK_MASK]	= { .type = NLA_U32 },
 	[XFRMA_IF_ID]		= { .type = NLA_U32 },
+	[XFRMA_MTIMER_THRESH]	= { .type = NLA_U32 },
 };
 
 static struct nlmsghdr *xfrm_nlmsg_put_compat(struct sk_buff *skb,
@@ -274,9 +275,10 @@ static int xfrm_xlate64_attr(struct sk_buff *dst, const struct nlattr *src)
 	case XFRMA_SET_MARK:
 	case XFRMA_SET_MARK_MASK:
 	case XFRMA_IF_ID:
+	case XFRMA_MTIMER_THRESH:
 		return xfrm_nla_cpy(dst, src, nla_len(src));
 	default:
-		BUILD_BUG_ON(XFRMA_MAX != XFRMA_IF_ID);
+		BUILD_BUG_ON(XFRMA_MAX != XFRMA_MTIMER_THRESH);
 		pr_warn_once("unsupported nla_type %d\n", src->nla_type);
 		return -EOPNOTSUPP;
 	}
@@ -431,7 +433,7 @@ static int xfrm_xlate32_attr(void *dst, const struct nlattr *nla,
 	int err;
 
 	if (type > XFRMA_MAX) {
-		BUILD_BUG_ON(XFRMA_MAX != XFRMA_IF_ID);
+		BUILD_BUG_ON(XFRMA_MAX != XFRMA_MTIMER_THRESH);
 		NL_SET_ERR_MSG(extack, "Bad attribute");
 		return -EOPNOTSUPP;
 	}
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index c158e70e8ae10..65e2805fa113a 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1557,6 +1557,9 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	x->km.seq = orig->km.seq;
 	x->replay = orig->replay;
 	x->preplay = orig->preplay;
+	x->mapping_maxage = orig->mapping_maxage;
+	x->new_mapping = 0;
+	x->new_mapping_sport = 0;
 
 	return x;
 
@@ -2208,7 +2211,7 @@ int km_query(struct xfrm_state *x, struct xfrm_tmpl *t, struct xfrm_policy *pol)
 }
 EXPORT_SYMBOL(km_query);
 
-int km_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr, __be16 sport)
+static int __km_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr, __be16 sport)
 {
 	int err = -EINVAL;
 	struct xfrm_mgr *km;
@@ -2223,6 +2226,24 @@ int km_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr, __be16 sport)
 	rcu_read_unlock();
 	return err;
 }
+
+int km_new_mapping(struct xfrm_state *x, xfrm_address_t *ipaddr, __be16 sport)
+{
+	int ret = 0;
+
+	if (x->mapping_maxage) {
+		if ((jiffies / HZ - x->new_mapping) > x->mapping_maxage ||
+		    x->new_mapping_sport != sport) {
+			x->new_mapping_sport = sport;
+			x->new_mapping = jiffies / HZ;
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
index 6f97665b632ed..c71a4c1269e48 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -282,6 +282,10 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 
 	err = 0;
 
+	if (attrs[XFRMA_MTIMER_THRESH])
+		if (!attrs[XFRMA_ENCAP])
+			err = -EINVAL;
+
 out:
 	return err;
 }
@@ -521,6 +525,7 @@ static void xfrm_update_ae_params(struct xfrm_state *x, struct nlattr **attrs,
 	struct nlattr *lt = attrs[XFRMA_LTIME_VAL];
 	struct nlattr *et = attrs[XFRMA_ETIMER_THRESH];
 	struct nlattr *rt = attrs[XFRMA_REPLAY_THRESH];
+	struct nlattr *mt = attrs[XFRMA_MTIMER_THRESH];
 
 	if (re) {
 		struct xfrm_replay_state_esn *replay_esn;
@@ -552,6 +557,9 @@ static void xfrm_update_ae_params(struct xfrm_state *x, struct nlattr **attrs,
 
 	if (rt)
 		x->replay_maxdiff = nla_get_u32(rt);
+
+	if (mt)
+		x->mapping_maxage = nla_get_u32(mt);
 }
 
 static void xfrm_smark_init(struct nlattr **attrs, struct xfrm_mark *m)
@@ -964,8 +972,13 @@ static int copy_to_user_state_extra(struct xfrm_state *x,
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
+		ret = nla_put_u32(skb, XFRMA_MTIMER_THRESH, x->mapping_maxage);
 out:
 	return ret;
 }
@@ -2909,6 +2922,9 @@ static inline unsigned int xfrm_sa_len(struct xfrm_state *x)
 	/* Must count x->lastused as it may become non-zero behind our back. */
 	l += nla_total_size_64bit(sizeof(u64));
 
+	if (x->mapping_maxage)
+		l += nla_total_size(sizeof(x->mapping_maxage));
+
 	return l;
 }
 
-- 
2.34.1

