Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69120252538
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 03:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgHZBuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 21:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgHZBt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 21:49:58 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7C5C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:57 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id h15so144417wrt.12
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O93QnaAX/MySWOIQ4YKwczc3gW9cDPvjwfx/D0wXn9Y=;
        b=OutNAs1FkpeEctHaUbho7g0eZONtc7FhJ/vWLc8EismkL6DpxvrFcZLIoM6S+5CIy2
         u+6CavrBRA4kzQg1Qj3kqKjNz/qU3zS0N8mUC/oWb3uiJNbFT53UNh20njxWZS05io5r
         0WNrwf1/1pEbgi8xFmoM16VUD0zT8LF1CzQr7XVk7/SIQVrVESqutonM+XVyDwtDAvZ1
         t9TzUK24st5ax85x6y8vpRMJakZ8MppKUKTdDUZa4veQHwSjEAt9J3ydA4q9DlYm8Wsg
         F17Y90PlhB6WVYQ0MmsMewDrgh52M0pIWIx2BUUW7mV1PCI6vzplRgeTaIlHFR2Ymxzj
         98mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O93QnaAX/MySWOIQ4YKwczc3gW9cDPvjwfx/D0wXn9Y=;
        b=d0pCDnC2iE2lOoDaLzUJVid7FYsmHvaMP0SDF97XzK1wsSOXINm9H/mKU+sv6qCSBL
         XuU5FUWtIUlYVYPfNDib0A+1/BMhbqDdaGdvUktr2cSzZWBCj2vipEj2TIA0tGa1Sc+M
         DEWycp50ie7J6G5qcdvEbZmt8e4MD8WqLVoUFP2+GF3FDsGjefwAcdw3sRe8sSj/4Tyr
         VZuUJo81z5T45fs1o1iPq9JYu8wyw43U6q4EpguvliBJHHJW1ASF0TkL9fYyx7q/7vq1
         eyXjTVbMs2X22D8AufcZ57Mr8RdFiaSYe/QFMdLSaFrr08WP8ETLBD61f3Sep+Fq2inZ
         MLcQ==
X-Gm-Message-State: AOAM530FIebbam0SuzRAsB3oivJKvsq0ByyEfk5zTsSEuTwLU3/D8BBQ
        2NDyp5L99esF67lWT/cHcM28Aw==
X-Google-Smtp-Source: ABdhPJxWN7j1AuCGxayMew181hcX9dWpmOEq5DAyswYg4pYu60Zzh0vXJU69hSNpuKhBW4sJmrJUaA==
X-Received: by 2002:adf:ed04:: with SMTP id a4mr12756889wro.123.1598406595920;
        Tue, 25 Aug 2020 18:49:55 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c10sm1263661wmk.30.2020.08.25.18.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 18:49:55 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 4/6] xfrm/compat: Add 32=>64-bit messages translator
Date:   Wed, 26 Aug 2020 02:49:47 +0100
Message-Id: <20200826014949.644441-5-dima@arista.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200826014949.644441-1-dima@arista.com>
References: <20200826014949.644441-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XFRM is disabled for compatible users because of the UABI difference.
The difference is in structures paddings and in the result the size
of netlink messages differ.

Possibility for compatible application to manage xfrm tunnels was
disabled by: the commmit 19d7df69fdb2 ("xfrm: Refuse to insert 32 bit
userspace socket policies on 64 bit systems") and the commit 74005991b78a
("xfrm: Do not parse 32bits compiled xfrm netlink msg on 64bits host").

This is my second attempt to resolve the xfrm/compat problem by adding
the 64=>32 and 32=>64 bit translators those non-visibly to a user
provide translation between compatible user and kernel.
Previous attempt was to interrupt the message ABI according to a syscall
by xfrm_user, which resulted in over-complicated code [1].

Florian Westphal provided the idea of translator and some draft patches
in the discussion. Here his idea is reused and some of his initial
code is also present.

Provide the user-to-kernel translator under XFRM_USER_COMPAT, that
creates for 32-bit xfrm-user message a 64-bit translation.
The translation is afterwards reused by xfrm_user code just as if
userspace had sent 64-bit message.

[1]: https://lkml.kernel.org/r/20180726023144.31066-1-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/xfrm.h     |  11 ++
 net/xfrm/Kconfig       |   3 +-
 net/xfrm/xfrm_compat.c | 276 +++++++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_user.c   |  50 +++++---
 4 files changed, 321 insertions(+), 19 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 9febf4f5d2ea..242e690674c6 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -2000,10 +2000,15 @@ static inline int xfrm_tunnel_check(struct sk_buff *skb, struct xfrm_state *x,
 	return 0;
 }
 
+extern const struct nla_policy xfrma_policy[XFRMA_MAX+1];
+
 #ifdef CONFIG_XFRM_USER_COMPAT
 extern int xfrm_alloc_compat(struct sk_buff *skb);
 extern int __xfrm_alloc_compat(struct sk_buff *skb, const struct nlmsghdr *nlh);
 extern const int xfrm_msg_min[XFRM_NR_MSGTYPES];
+extern struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *nlh,
+			int maxtype, const struct nla_policy *policy,
+			struct netlink_ext_ack *extack);
 #else
 static inline int xfrm_alloc_compat(struct sk_buff *skb)
 {
@@ -2014,6 +2019,12 @@ static inline int __xfrm_alloc_compat(struct sk_buff *skb,
 {
 	return 0;
 }
+static inline struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *nlh,
+			int maxtype, const struct nla_policy *policy,
+			struct netlink_ext_ack *extack)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
 #endif
 
 #if IS_ENABLED(CONFIG_IPV6)
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
index b34c8b56a571..79daa7f47d5a 100644
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
@@ -198,6 +231,9 @@ static int xfrm_nla_cpy(struct sk_buff *dst, const struct nlattr *src, int len)
 static int xfrm_xlate64_attr(struct sk_buff *dst, const struct nlattr *src)
 {
 	switch (src->nla_type) {
+	case XFRMA_PAD:
+		/* Ignore */
+		return 0;
 	case XFRMA_ALG_AUTH:
 	case XFRMA_ALG_CRYPT:
 	case XFRMA_ALG_COMP:
@@ -306,3 +342,243 @@ int xfrm_alloc_compat(struct sk_buff *skb)
 
 	return __xfrm_alloc_compat(skb, nlh_src);
 }
+
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
+	pos += dst->nlmsg_len;
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
+struct nlmsghdr *xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
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
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index d135c6949336..c00eeb5503bc 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1013,7 +1013,6 @@ static int xfrm_dump_sa_done(struct netlink_callback *cb)
 	return 0;
 }
 
-static const struct nla_policy xfrma_policy[XFRMA_MAX+1];
 static int xfrm_dump_sa(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct net *net = sock_net(skb->sk);
@@ -2586,7 +2585,7 @@ const int xfrm_msg_min[XFRM_NR_MSGTYPES] = {
 
 #undef XMSGSIZE
 
-static const struct nla_policy xfrma_policy[XFRMA_MAX+1] = {
+const struct nla_policy xfrma_policy[XFRMA_MAX+1] = {
 	[XFRMA_SA]		= { .len = sizeof(struct xfrm_usersa_info)},
 	[XFRMA_POLICY]		= { .len = sizeof(struct xfrm_userpolicy_info)},
 	[XFRMA_LASTUSED]	= { .type = NLA_U64},
@@ -2667,11 +2666,9 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -2683,32 +2680,49 @@ static int xfrm_user_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!netlink_net_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
+	if (in_compat_syscall()) {
+		nlh64 = xfrm_user_rcv_msg_compat(nlh, link->nla_max,
+						 link->nla_pol, extack);
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
 
-	return link->doit(skb, nlh, attrs);
+	err = link->doit(skb, nlh, attrs);
+
+err:
+	kvfree(nlh64);
+	return err;
 }
 
 static void xfrm_netlink_rcv(struct sk_buff *skb)
-- 
2.27.0

