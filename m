Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5F02727C5
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgIUOhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbgIUOhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:37:14 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB822C0613D4
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:37:13 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id o5so13012131wrn.13
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vXjjlIOOkwh5ekkrrcoKfj8ZYESuPbvxzeR9klmtcE8=;
        b=YkWX5iHijrs0TXB+YHOfTvTPaWbo055gq8NRX+Dv8pogE0AR2Ssn3aqva6loFv6TJk
         ECo70u8Rp3Qjx0Lh4/WtR1emDnsDl8QEr/TAQkzuhGjFw+SDpvNlBKlOE3xTLcw0Z3Ck
         /vnt207zJWWacCk3wT8ezDtKGoT7ggPiR+1R6TtQVYiyY9AmR/PLiLkollMA6bMVI3hd
         OpEbP3VY2sop7HuLtYojE6veC73JlTR2tKUv8z9iE5owJH7uMOnu5qfvKNHQ+AupIrFQ
         cWFC3Pqv/e9lR8HsUtTYaSURA3pO6zuLOZI3RKGqq1CQobDLsB+WHxQyFbZ0g4bmIRRR
         b9JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vXjjlIOOkwh5ekkrrcoKfj8ZYESuPbvxzeR9klmtcE8=;
        b=UL7mZjI3LeyuyA87UnBPIGhebraenkeFrwTwONWqwl+vRCONWPldKHYoFmF1NobWIH
         hJfeklGsEbMP8mPtOku+nf8p1ljoDO6KQLPAyOUZAWdpdYg53pOTGP7GWal7ghnMYm+X
         kc20wtkqnD/zE+NCqgFkWduZnXhFsgfIi9BI40TYuRNzqnexfGQ74qI2wibkjv28mbxZ
         /RV8aAIo5vV19T1U9D95NsGfNzSaoF3bu6TLpZ9UuquM6ehCevGTxOs4jB9bhkb1tBmf
         0zOj4bEXVMcnO2Efkc6OwvQlB4XV2YEzFvOKAnmCAIASE2AFbFpAH9m9yQzf1DAt0RVI
         Mbxg==
X-Gm-Message-State: AOAM532uhn4OUbTQ1+PLBancYcNt8CGkOL6tVVoIzdsb0dNL6W9oC6FY
        rGwcblPy6RRFTOw+2tefskPw3w==
X-Google-Smtp-Source: ABdhPJxfO7/ERDwkmdraq4vKzS3gm4AZ3o8dAgeAnv/vwKDkBRd3RqKuEGwX/nyfs8iCzmraWQO9aQ==
X-Received: by 2002:a5d:69c9:: with SMTP id s9mr84102wrw.348.1600699032388;
        Mon, 21 Sep 2020 07:37:12 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c14sm20370753wrv.12.2020.09.21.07.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 07:37:11 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH v3 5/7] xfrm/compat: Add 32=>64-bit messages translator
Date:   Mon, 21 Sep 2020 15:36:55 +0100
Message-Id: <20200921143657.604020-6-dima@arista.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921143657.604020-1-dima@arista.com>
References: <20200921143657.604020-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide the user-to-kernel translator under XFRM_USER_COMPAT, that
creates for 32-bit xfrm-user message a 64-bit translation.
The translation is afterwards reused by xfrm_user code just as if
userspace had sent 64-bit message.

Signed-off-by: Dmitry Safonov <dima@arista.com>
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
2.28.0

