Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E340A280CFE
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 07:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgJBFBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 01:01:36 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41956 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbgJBFBb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 01:01:31 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EA0F2204B4;
        Fri,  2 Oct 2020 07:01:26 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yf1E-xuZjsYL; Fri,  2 Oct 2020 07:01:26 +0200 (CEST)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 142382052E;
        Fri,  2 Oct 2020 07:01:25 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 2 Oct 2020 07:01:24 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 2 Oct 2020
 07:01:24 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 5BB0131846C0;
 Fri,  2 Oct 2020 07:01:23 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 5/7] xfrm/compat: Add 32=>64-bit messages translator
Date:   Fri, 2 Oct 2020 07:01:11 +0200
Message-ID: <20201002050113.2210-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002050113.2210-1-steffen.klassert@secunet.com>
References: <20201002050113.2210-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

Provide the user-to-kernel translator under XFRM_USER_COMPAT, that
creates for 32-bit xfrm-user message a 64-bit translation.
The translation is afterwards reused by xfrm_user code just as if
userspace had sent 64-bit message.

Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |   6 +
 net/xfrm/Kconfig       |   3 +-
 net/xfrm/xfrm_compat.c | 274 +++++++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_user.c   |  57 ++++++---
 4 files changed, 321 insertions(+), 19 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 5b6cc62c9354..fa18cb6bb3f7 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -2001,11 +2001,17 @@ static inline int xfrm_tunnel_check(struct sk_buff *skb, struct xfrm_state *x,
 }
 
 extern const int xfrm_msg_min[XFRM_NR_MSGTYPES];
+extern const struct nla_policy xfrma_policy[XFRMA_MAX+1];
 
 struct xfrm_translator {
 	/* Allocate frag_list and put compat translation there */
 	int (*alloc_compat)(struct sk_buff *skb, const struct nlmsghdr *src);
 
+	/* Allocate nlmsg with 64-bit translaton of received 32-bit message */
+	struct nlmsghdr *(*rcv_msg_compat)(const struct nlmsghdr *nlh,
+			int maxtype, const struct nla_policy *policy,
+			struct netlink_ext_ack *extack);
+
 	struct module *owner;
 };
 
diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index e79b48dab61b..3adf31a83a79 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -30,7 +30,8 @@ config XFRM_USER
 
 config XFRM_USER_COMPAT
 	tristate "Compatible ABI support"
-	depends on XFRM_USER && COMPAT_FOR_U64_ALIGNMENT
+	depends on XFRM_USER && COMPAT_FOR_U64_ALIGNMENT && \
+		HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select WANT_COMPAT_NETLINK_MESSAGES
 	help
 	  Transformation(XFRM) user configuration interface like IPsec
diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index aece41b44ff2..b1b5f972538d 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -96,6 +96,39 @@ static const int compat_msg_min[XFRM_NR_MSGTYPES] = {
 	[XFRM_MSG_MAPPING     - XFRM_MSG_BASE] = XMSGSIZE(xfrm_user_mapping)
 };
 
+static const struct nla_policy compat_policy[XFRMA_MAX+1] = {
+	[XFRMA_SA]		= { .len = XMSGSIZE(compat_xfrm_usersa_info)},
+	[XFRMA_POLICY]		= { .len = XMSGSIZE(compat_xfrm_userpolicy_info)},
+	[XFRMA_LASTUSED]	= { .type = NLA_U64},
+	[XFRMA_ALG_AUTH_TRUNC]	= { .len = sizeof(struct xfrm_algo_auth)},
+	[XFRMA_ALG_AEAD]	= { .len = sizeof(struct xfrm_algo_aead) },
+	[XFRMA_ALG_AUTH]	= { .len = sizeof(struct xfrm_algo) },
+	[XFRMA_ALG_CRYPT]	= { .len = sizeof(struct xfrm_algo) },
+	[XFRMA_ALG_COMP]	= { .len = sizeof(struct xfrm_algo) },
+	[XFRMA_ENCAP]		= { .len = sizeof(struct xfrm_encap_tmpl) },
+	[XFRMA_TMPL]		= { .len = sizeof(struct xfrm_user_tmpl) },
+	[XFRMA_SEC_CTX]		= { .len = sizeof(struct xfrm_sec_ctx) },
+	[XFRMA_LTIME_VAL]	= { .len = sizeof(struct xfrm_lifetime_cur) },
+	[XFRMA_REPLAY_VAL]	= { .len = sizeof(struct xfrm_replay_state) },
+	[XFRMA_REPLAY_THRESH]	= { .type = NLA_U32 },
+	[XFRMA_ETIMER_THRESH]	= { .type = NLA_U32 },
+	[XFRMA_SRCADDR]		= { .len = sizeof(xfrm_address_t) },
+	[XFRMA_COADDR]		= { .len = sizeof(xfrm_address_t) },
+	[XFRMA_POLICY_TYPE]	= { .len = sizeof(struct xfrm_userpolicy_type)},
+	[XFRMA_MIGRATE]		= { .len = sizeof(struct xfrm_user_migrate) },
+	[XFRMA_KMADDRESS]	= { .len = sizeof(struct xfrm_user_kmaddress) },
+	[XFRMA_MARK]		= { .len = sizeof(struct xfrm_mark) },
+	[XFRMA_TFCPAD]		= { .type = NLA_U32 },
+	[XFRMA_REPLAY_ESN_VAL]	= { .len = sizeof(struct xfrm_replay_state_esn) },
+	[XFRMA_SA_EXTRA_FLAGS]	= { .type = NLA_U32 },
+	[XFRMA_PROTO]		= { .type = NLA_U8 },
+	[XFRMA_ADDRESS_FILTER]	= { .len = sizeof(struct xfrm_address_filter) },
+	[XFRMA_OFFLOAD_DEV]	= { .len = sizeof(struct xfrm_user_offload) },
+	[XFRMA_SET_MARK]	= { .type = NLA_U32 },
+	[XFRMA_SET_MARK_MASK]	= { .type = NLA_U32 },
+	[XFRMA_IF_ID]		= { .type = NLA_U32 },
+};
+
 static struct nlmsghdr *xfrm_nlmsg_put_compat(struct sk_buff *skb,
 			const struct nlmsghdr *nlh_src, u16 type)
 {
@@ -303,9 +336,250 @@ static int xfrm_alloc_compat(struct sk_buff *skb, const struct nlmsghdr *nlh_src
 	return 0;
 }
 
+/* Calculates len of translated 64-bit message. */
+static size_t xfrm_user_rcv_calculate_len64(const struct nlmsghdr *src,
+					    struct nlattr *attrs[XFRMA_MAX+1])
+{
+	size_t len = nlmsg_len(src);
+
+	switch (src->nlmsg_type) {
+	case XFRM_MSG_NEWSA:
+	case XFRM_MSG_NEWPOLICY:
+	case XFRM_MSG_ALLOCSPI:
+	case XFRM_MSG_ACQUIRE:
+	case XFRM_MSG_UPDPOLICY:
+	case XFRM_MSG_UPDSA:
+		len += 4;
+		break;
+	case XFRM_MSG_EXPIRE:
+	case XFRM_MSG_POLEXPIRE:
+		len += 8;
+		break;
+	default:
+		break;
+	}
+
+	if (attrs[XFRMA_SA])
+		len += 4;
+	if (attrs[XFRMA_POLICY])
+		len += 4;
+
+	/* XXX: some attrs may need to be realigned
+	 * if !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	 */
+
+	return len;
+}
+
+static int xfrm_attr_cpy32(void *dst, size_t *pos, const struct nlattr *src,
+			   size_t size, int copy_len, int payload)
+{
+	struct nlmsghdr *nlmsg = dst;
+	struct nlattr *nla;
+
+	if (WARN_ON_ONCE(copy_len > payload))
+		copy_len = payload;
+
+	if (size - *pos < nla_attr_size(payload))
+		return -ENOBUFS;
+
+	nla = dst + *pos;
+
+	memcpy(nla, src, nla_attr_size(copy_len));
+	nla->nla_len = nla_attr_size(payload);
+	*pos += nla_attr_size(payload);
+	nlmsg->nlmsg_len += nla->nla_len;
+
+	memset(dst + *pos, 0, payload - copy_len);
+	*pos += payload - copy_len;
+
+	return 0;
+}
+
+static int xfrm_xlate32_attr(void *dst, const struct nlattr *nla,
+			     size_t *pos, size_t size,
+			     struct netlink_ext_ack *extack)
+{
+	int type = nla_type(nla);
+	u16 pol_len32, pol_len64;
+	int err;
+
+	if (type > XFRMA_MAX) {
+		BUILD_BUG_ON(XFRMA_MAX != XFRMA_IF_ID);
+		NL_SET_ERR_MSG(extack, "Bad attribute");
+		return -EOPNOTSUPP;
+	}
+	if (nla_len(nla) < compat_policy[type].len) {
+		NL_SET_ERR_MSG(extack, "Attribute bad length");
+		return -EOPNOTSUPP;
+	}
+
+	pol_len32 = compat_policy[type].len;
+	pol_len64 = xfrma_policy[type].len;
+
+	/* XFRMA_SA and XFRMA_POLICY - need to know how-to translate */
+	if (pol_len32 != pol_len64) {
+		if (nla_len(nla) != compat_policy[type].len) {
+			NL_SET_ERR_MSG(extack, "Attribute bad length");
+			return -EOPNOTSUPP;
+		}
+		err = xfrm_attr_cpy32(dst, pos, nla, size, pol_len32, pol_len64);
+		if (err)
+			return err;
+	}
+
+	return xfrm_attr_cpy32(dst, pos, nla, size, nla_len(nla), nla_len(nla));
+}
+
+static int xfrm_xlate32(struct nlmsghdr *dst, const struct nlmsghdr *src,
+			struct nlattr *attrs[XFRMA_MAX+1],
+			size_t size, u8 type, struct netlink_ext_ack *extack)
+{
+	size_t pos;
+	int i;
+
+	memcpy(dst, src, NLMSG_HDRLEN);
+	dst->nlmsg_len = NLMSG_HDRLEN + xfrm_msg_min[type];
+	memset(nlmsg_data(dst), 0, xfrm_msg_min[type]);
+
+	switch (src->nlmsg_type) {
+	/* Compat message has the same layout as native */
+	case XFRM_MSG_DELSA:
+	case XFRM_MSG_GETSA:
+	case XFRM_MSG_DELPOLICY:
+	case XFRM_MSG_GETPOLICY:
+	case XFRM_MSG_FLUSHSA:
+	case XFRM_MSG_FLUSHPOLICY:
+	case XFRM_MSG_NEWAE:
+	case XFRM_MSG_GETAE:
+	case XFRM_MSG_REPORT:
+	case XFRM_MSG_MIGRATE:
+	case XFRM_MSG_NEWSADINFO:
+	case XFRM_MSG_GETSADINFO:
+	case XFRM_MSG_NEWSPDINFO:
+	case XFRM_MSG_GETSPDINFO:
+	case XFRM_MSG_MAPPING:
+		memcpy(nlmsg_data(dst), nlmsg_data(src), compat_msg_min[type]);
+		break;
+	/* 4 byte alignment for trailing u64 on native, but not on compat */
+	case XFRM_MSG_NEWSA:
+	case XFRM_MSG_NEWPOLICY:
+	case XFRM_MSG_UPDSA:
+	case XFRM_MSG_UPDPOLICY:
+		memcpy(nlmsg_data(dst), nlmsg_data(src), compat_msg_min[type]);
+		break;
+	case XFRM_MSG_EXPIRE: {
+		const struct compat_xfrm_user_expire *src_ue = nlmsg_data(src);
+		struct xfrm_user_expire *dst_ue = nlmsg_data(dst);
+
+		/* compat_xfrm_user_expire has 4-byte smaller state */
+		memcpy(dst_ue, src_ue, sizeof(src_ue->state));
+		dst_ue->hard = src_ue->hard;
+		break;
+	}
+	case XFRM_MSG_ACQUIRE: {
+		const struct compat_xfrm_user_acquire *src_ua = nlmsg_data(src);
+		struct xfrm_user_acquire *dst_ua = nlmsg_data(dst);
+
+		memcpy(dst_ua, src_ua, offsetof(struct compat_xfrm_user_acquire, aalgos));
+		dst_ua->aalgos = src_ua->aalgos;
+		dst_ua->ealgos = src_ua->ealgos;
+		dst_ua->calgos = src_ua->calgos;
+		dst_ua->seq    = src_ua->seq;
+		break;
+	}
+	case XFRM_MSG_POLEXPIRE: {
+		const struct compat_xfrm_user_polexpire *src_upe = nlmsg_data(src);
+		struct xfrm_user_polexpire *dst_upe = nlmsg_data(dst);
+
+		/* compat_xfrm_user_polexpire has 4-byte smaller state */
+		memcpy(dst_upe, src_upe, sizeof(src_upe->pol));
+		dst_upe->hard = src_upe->hard;
+		break;
+	}
+	case XFRM_MSG_ALLOCSPI: {
+		const struct compat_xfrm_userspi_info *src_usi = nlmsg_data(src);
+		struct xfrm_userspi_info *dst_usi = nlmsg_data(dst);
+
+		/* compat_xfrm_user_polexpire has 4-byte smaller state */
+		memcpy(dst_usi, src_usi, sizeof(src_usi->info));
+		dst_usi->min = src_usi->min;
+		dst_usi->max = src_usi->max;
+		break;
+	}
+	default:
+		NL_SET_ERR_MSG(extack, "Unsupported message type");
+		return -EOPNOTSUPP;
+	}
+	pos = dst->nlmsg_len;
+
+	for (i = 1; i < XFRMA_MAX + 1; i++) {
+		int err;
+
+		if (i == XFRMA_PAD)
+			continue;
+
+		if (!attrs[i])
+			continue;
+
+		err = xfrm_xlate32_attr(dst, attrs[i], &pos, size, extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
+			int maxtype, const struct nla_policy *policy,
+			struct netlink_ext_ack *extack)
+{
+	/* netlink_rcv_skb() checks if a message has full (struct nlmsghdr) */
+	u16 type = h32->nlmsg_type - XFRM_MSG_BASE;
+	struct nlattr *attrs[XFRMA_MAX+1];
+	struct nlmsghdr *h64;
+	size_t len;
+	int err;
+
+	BUILD_BUG_ON(ARRAY_SIZE(xfrm_msg_min) != ARRAY_SIZE(compat_msg_min));
+
+	if (type >= ARRAY_SIZE(xfrm_msg_min))
+		return ERR_PTR(-EINVAL);
+
+	/* Don't call parse: the message might have only nlmsg header */
+	if ((h32->nlmsg_type == XFRM_MSG_GETSA ||
+	     h32->nlmsg_type == XFRM_MSG_GETPOLICY) &&
+	    (h32->nlmsg_flags & NLM_F_DUMP))
+		return NULL;
+
+	err = nlmsg_parse_deprecated(h32, compat_msg_min[type], attrs,
+			maxtype ? : XFRMA_MAX, policy ? : compat_policy, extack);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	len = xfrm_user_rcv_calculate_len64(h32, attrs);
+	/* The message doesn't need translation */
+	if (len == nlmsg_len(h32))
+		return NULL;
+
+	len += NLMSG_HDRLEN;
+	h64 = kvmalloc(len, GFP_KERNEL | __GFP_ZERO);
+	if (!h64)
+		return ERR_PTR(-ENOMEM);
+
+	err = xfrm_xlate32(h64, h32, attrs, len, type, extack);
+	if (err < 0) {
+		kvfree(h64);
+		return ERR_PTR(err);
+	}
+
+	return h64;
+}
+
 static struct xfrm_translator xfrm_translator = {
 	.owner				= THIS_MODULE,
 	.alloc_compat			= xfrm_alloc_compat,
+	.rcv_msg_compat			= xfrm_user_rcv_msg_compat,
 };
 
 static int __init xfrm_compat_init(void)
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 7fd7b16a8805..d0c32a8fcc4a 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1019,7 +1019,6 @@ static int xfrm_dump_sa_done(struct netlink_callback *cb)
 	return 0;
 }
 
-static const struct nla_policy xfrma_policy[XFRMA_MAX+1];
 static int xfrm_dump_sa(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct net *net = sock_net(skb->sk);
@@ -2610,7 +2609,7 @@ EXPORT_SYMBOL_GPL(xfrm_msg_min);
 
 #undef XMSGSIZE
 
-static const struct nla_policy xfrma_policy[XFRMA_MAX+1] = {
+const struct nla_policy xfrma_policy[XFRMA_MAX+1] = {
 	[XFRMA_SA]		= { .len = sizeof(struct xfrm_usersa_info)},
 	[XFRMA_POLICY]		= { .len = sizeof(struct xfrm_userpolicy_info)},
 	[XFRMA_LASTUSED]	= { .type = NLA_U64},
@@ -2642,6 +2641,7 @@ static const struct nla_policy xfrma_policy[XFRMA_MAX+1] = {
 	[XFRMA_SET_MARK_MASK]	= { .type = NLA_U32 },
 	[XFRMA_IF_ID]		= { .type = NLA_U32 },
 };
+EXPORT_SYMBOL_GPL(xfrma_policy);
 
 static const struct nla_policy xfrma_spd_policy[XFRMA_SPD_MAX+1] = {
 	[XFRMA_SPD_IPV4_HTHRESH] = { .len = sizeof(struct xfrmu_spdhthresh) },
@@ -2691,11 +2691,9 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net *net = sock_net(skb->sk);
 	struct nlattr *attrs[XFRMA_MAX+1];
 	const struct xfrm_link *link;
+	struct nlmsghdr *nlh64 = NULL;
 	int type, err;
 
-	if (in_compat_syscall())
-		return -EOPNOTSUPP;
-
 	type = nlh->nlmsg_type;
 	if (type > XFRM_MSG_MAX)
 		return -EINVAL;
@@ -2707,32 +2705,55 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!netlink_net_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
+	if (in_compat_syscall()) {
+		struct xfrm_translator *xtr = xfrm_get_translator();
+
+		if (!xtr)
+			return -EOPNOTSUPP;
+
+		nlh64 = xtr->rcv_msg_compat(nlh, link->nla_max,
+					    link->nla_pol, extack);
+		xfrm_put_translator(xtr);
+		if (IS_ERR(nlh64))
+			return PTR_ERR(nlh64);
+		if (nlh64)
+			nlh = nlh64;
+	}
+
 	if ((type == (XFRM_MSG_GETSA - XFRM_MSG_BASE) ||
 	     type == (XFRM_MSG_GETPOLICY - XFRM_MSG_BASE)) &&
 	    (nlh->nlmsg_flags & NLM_F_DUMP)) {
-		if (link->dump == NULL)
-			return -EINVAL;
+		struct netlink_dump_control c = {
+			.start = link->start,
+			.dump = link->dump,
+			.done = link->done,
+		};
 
-		{
-			struct netlink_dump_control c = {
-				.start = link->start,
-				.dump = link->dump,
-				.done = link->done,
-			};
-			return netlink_dump_start(net->xfrm.nlsk, skb, nlh, &c);
+		if (link->dump == NULL) {
+			err = -EINVAL;
+			goto err;
 		}
+
+		err = netlink_dump_start(net->xfrm.nlsk, skb, nlh, &c);
+		goto err;
 	}
 
 	err = nlmsg_parse_deprecated(nlh, xfrm_msg_min[type], attrs,
 				     link->nla_max ? : XFRMA_MAX,
 				     link->nla_pol ? : xfrma_policy, extack);
 	if (err < 0)
-		return err;
+		goto err;
 
-	if (link->doit == NULL)
-		return -EINVAL;
+	if (link->doit == NULL) {
+		err = -EINVAL;
+		goto err;
+	}
+
+	err = link->doit(skb, nlh, attrs);
 
-	return link->doit(skb, nlh, attrs);
+err:
+	kvfree(nlh64);
+	return err;
 }
 
 static void xfrm_netlink_rcv(struct sk_buff *skb)
-- 
2.17.1

