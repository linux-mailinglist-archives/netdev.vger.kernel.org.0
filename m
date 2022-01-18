Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972644917C5
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343768AbiARCm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345466AbiARCbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:31:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30E7C06175E;
        Mon, 17 Jan 2022 18:29:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8613BB81255;
        Tue, 18 Jan 2022 02:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4811DC36AE3;
        Tue, 18 Jan 2022 02:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472956;
        bh=qIGi4RJrDO+i3ql4kdOK6GR+gsQ+CYnT4IUlAHuhrXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D8ZOYqHna/0WyWtOBLgqTQoeeFXVsjTS60+JUcs1HfW0kTZ5PaMVC2TzeO4OCuPXL
         53ZdvY4uX3ZD9nCPrV9jZLEshwnTLLv5DXUwnV06h4/KvISBHGfP9OXkAAE8VIu0s3
         8aGQaow9ihpfBBmjYGhOqK5hJ7xh++olqhuUiSz3qHDYqzfKqpbYgYt66l2uZmNQw5
         XBYO+jjXBw5LFGRJ3zgMTpaNA9YoQZ+KR/RnSxrCDTMMNukZESpwh3SovOu90/Gy87
         FI+v7sqcBKpu7GoxV6SbamswJhTBhl4fbKU7hnyoda4VYms30zoByqp/Y7sqonaMc+
         HENpX+uqGAlYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antony Antony <antony.antony@secunet.com>,
        Thomas Egerer <thomas.egerer@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 176/217] xfrm: rate limit SA mapping change message to user space
Date:   Mon, 17 Jan 2022 21:18:59 -0500
Message-Id: <20220118021940.1942199-176-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 2308210793a01..2589e4c0501bd 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -200,6 +200,11 @@ struct xfrm_state {
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
index eda0426ec4c2b..4e29d78518902 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -313,6 +313,7 @@ enum xfrm_attr_type_t {
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
index a2f4001221d16..78d51399a0f4b 100644
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
index 7c36cc1f3d79c..130240680655f 100644
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
@@ -1024,8 +1032,13 @@ static int copy_to_user_state_extra(struct xfrm_state *x,
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
@@ -3069,6 +3082,9 @@ static inline unsigned int xfrm_sa_len(struct xfrm_state *x)
 	/* Must count x->lastused as it may become non-zero behind our back. */
 	l += nla_total_size_64bit(sizeof(u64));
 
+	if (x->mapping_maxage)
+		l += nla_total_size(sizeof(x->mapping_maxage));
+
 	return l;
 }
 
-- 
2.34.1

