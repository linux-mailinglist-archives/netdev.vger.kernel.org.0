Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42776252541
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 03:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgHZBt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 21:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgHZBty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 21:49:54 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B079C0613ED
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:53 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so176479wrw.1
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PLtmDFaoox/6Kk3QstmLj3GA+oZMK+tPOxejIsZwndo=;
        b=B2yTBTjChJHlEPJyYmch43xTP+WqJy47P0yAxwVdYGGeNTHzjdQS/KtPPbDewcXZJY
         jSl0rzaIpDC0P+95TJOPguXChZmW6N+XDglOnUSt3dA9+4WPLIhckQmuqc4Qu4TfbGPf
         WHHYu84cl49PHtnek+vQWW8BQ5dRe8obxrVGAtvIiG7SEU+EoiD5suhL5uBUBkZ2SPGQ
         TwgDeL4hxPiiNae8iLhjAXFJ2ZZsnCrz1oPQPecJ7swhkSIb0WR/cikT2Q2++S9rYcp+
         yYHuVsPmOdvPNvxMnrX9ouZLjrpQ6DYv9M6pcphKe8e4glN1optVj8RVxRYZyYBAocv9
         EEPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PLtmDFaoox/6Kk3QstmLj3GA+oZMK+tPOxejIsZwndo=;
        b=iyUzA3iA2AjNkN1mFvut9NYOqeY8+id6BcNYPcQ4VNasF867YOQfdMz27hyoOFXneV
         WFcEuHnqq/ADvHt7qK8H8UZ757q3M/OY2Frpfy/Nzs3k4GwdotSBX7QFC7UroPQlD5uV
         D4ws3Hg+t0GU9oFdiVrfSWIUypLva5ldI4nQd6ZKBs65K0BAat25GCbKCSwUb71RmOuA
         5oa1hN71amaSfZeuXecMLC27tTscWJS06Wxdhq4PlqN2nl69fV2Vt4E7uWus4bUjljq1
         wbfCcx34dLUz0mQ6kAbG6MfYHZMMpoEubpayxiwmzNuFFfxptelIStBoKA85QpLxx6WR
         ZF3g==
X-Gm-Message-State: AOAM5316SuygxrzpQ9ST3PIzhYUq0+28MfdcLFXCWI6hGJ2Mj4RTbXmz
        nEVJEJegCI6GQx2uw+DL0GG3kA==
X-Google-Smtp-Source: ABdhPJzrYE0pGCV0e8LI2s6USUHaJ7hEQrakPAwCAuOW0uFBZs+2sFediF6ooArklsD8irgfURYqAQ==
X-Received: by 2002:a5d:6942:: with SMTP id r2mr9116886wrw.76.1598406592031;
        Tue, 25 Aug 2020 18:49:52 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c10sm1263661wmk.30.2020.08.25.18.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 18:49:51 -0700 (PDT)
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
Subject: [PATCH v2 1/6] xfrm/compat: Add 64=>32-bit messages translator
Date:   Wed, 26 Aug 2020 02:49:44 +0100
Message-Id: <20200826014949.644441-2-dima@arista.com>
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
in the discussion. In these patches, his idea is reused and some of his
initial code is also present.

Provide the kernel-to-user translator under XFRM_USER_COMPAT, that
creates for 64-bit xfrm-user message a 32-bit translation and puts it
in skb's frag_list. net/compat.c layer provides MSG_CMSG_COMPAT to
decide if the message should be taken from skb or frag_list.
(used by wext-core which has also an ABI difference)

Kernel sends 64-bit xfrm messages to the userspace for:
- multicast (monitor events)
- netlink dumps

Wire up the translator to xfrm_nlmsg_multicast().

[1]: https://lkml.kernel.org/r/20180726023144.31066-1-dima@arista.com
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/xfrm.h     |  10 ++
 net/xfrm/Kconfig       |  10 ++
 net/xfrm/Makefile      |   1 +
 net/xfrm/xfrm_compat.c | 302 +++++++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_user.c   |   9 +-
 5 files changed, 331 insertions(+), 1 deletion(-)
 create mode 100644 net/xfrm/xfrm_compat.c

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 2737d24ec244..9810b5090338 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -2000,6 +2000,16 @@ static inline int xfrm_tunnel_check(struct sk_buff *skb, struct xfrm_state *x,
 	return 0;
 }
 
+#ifdef CONFIG_XFRM_USER_COMPAT
+extern int xfrm_alloc_compat(struct sk_buff *skb);
+extern const int xfrm_msg_min[XFRM_NR_MSGTYPES];
+#else
+static inline int xfrm_alloc_compat(struct sk_buff *skb)
+{
+	return 0;
+}
+#endif
+
 #if IS_ENABLED(CONFIG_IPV6)
 static inline bool xfrm6_local_dontfrag(const struct sock *sk)
 {
diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 5b9a5ab48111..e79b48dab61b 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -28,6 +28,16 @@ config XFRM_USER
 
 	  If unsure, say Y.
 
+config XFRM_USER_COMPAT
+	tristate "Compatible ABI support"
+	depends on XFRM_USER && COMPAT_FOR_U64_ALIGNMENT
+	select WANT_COMPAT_NETLINK_MESSAGES
+	help
+	  Transformation(XFRM) user configuration interface like IPsec
+	  used by compatible Linux applications.
+
+	  If unsure, say N.
+
 config XFRM_INTERFACE
 	tristate "Transformation virtual interface"
 	depends on XFRM && IPV6
diff --git a/net/xfrm/Makefile b/net/xfrm/Makefile
index 2d4bb4b9f75e..494aa744bfb9 100644
--- a/net/xfrm/Makefile
+++ b/net/xfrm/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_XFRM) := xfrm_policy.o xfrm_state.o xfrm_hash.o \
 obj-$(CONFIG_XFRM_STATISTICS) += xfrm_proc.o
 obj-$(CONFIG_XFRM_ALGO) += xfrm_algo.o
 obj-$(CONFIG_XFRM_USER) += xfrm_user.o
+obj-$(CONFIG_XFRM_USER_COMPAT) += xfrm_compat.o
 obj-$(CONFIG_XFRM_IPCOMP) += xfrm_ipcomp.o
 obj-$(CONFIG_XFRM_INTERFACE) += xfrm_interface.o
 obj-$(CONFIG_XFRM_ESPINTCP) += espintcp.o
diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
new file mode 100644
index 000000000000..b9eb65dde0db
--- /dev/null
+++ b/net/xfrm/xfrm_compat.c
@@ -0,0 +1,302 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * XFRM compat layer
+ * Author: Dmitry Safonov <dima@arista.com>
+ * Based on code and translator idea by: Florian Westphal <fw@strlen.de>
+ */
+#include <linux/compat.h>
+#include <linux/xfrm.h>
+#include <net/xfrm.h>
+
+struct compat_xfrm_lifetime_cfg {
+	compat_u64 soft_byte_limit, hard_byte_limit;
+	compat_u64 soft_packet_limit, hard_packet_limit;
+	compat_u64 soft_add_expires_seconds, hard_add_expires_seconds;
+	compat_u64 soft_use_expires_seconds, hard_use_expires_seconds;
+}; /* same size on 32bit, but only 4 byte alignment required */
+
+struct compat_xfrm_lifetime_cur {
+	compat_u64 bytes, packets, add_time, use_time;
+}; /* same size on 32bit, but only 4 byte alignment required */
+
+struct compat_xfrm_userpolicy_info {
+	struct xfrm_selector sel;
+	struct compat_xfrm_lifetime_cfg lft;
+	struct compat_xfrm_lifetime_cur curlft;
+	__u32 priority, index;
+	u8 dir, action, flags, share;
+	/* 4 bytes additional padding on 64bit */
+};
+
+struct compat_xfrm_usersa_info {
+	struct xfrm_selector sel;
+	struct xfrm_id id;
+	xfrm_address_t saddr;
+	struct compat_xfrm_lifetime_cfg lft;
+	struct compat_xfrm_lifetime_cur curlft;
+	struct xfrm_stats stats;
+	__u32 seq, reqid;
+	u16 family;
+	u8 mode, replay_window, flags;
+	/* 4 bytes additional padding on 64bit */
+};
+
+struct compat_xfrm_user_acquire {
+	struct xfrm_id id;
+	xfrm_address_t saddr;
+	struct xfrm_selector sel;
+	struct compat_xfrm_userpolicy_info policy;
+	/* 4 bytes additional padding on 64bit */
+	__u32 aalgos, ealgos, calgos, seq;
+};
+
+struct compat_xfrm_userspi_info {
+	struct compat_xfrm_usersa_info info;
+	/* 4 bytes additional padding on 64bit */
+	__u32 min, max;
+};
+
+struct compat_xfrm_user_expire {
+	struct compat_xfrm_usersa_info state;
+	/* 8 bytes additional padding on 64bit */
+	u8 hard;
+};
+
+struct compat_xfrm_user_polexpire {
+	struct compat_xfrm_userpolicy_info pol;
+	/* 8 bytes additional padding on 64bit */
+	u8 hard;
+};
+
+#define XMSGSIZE(type) sizeof(struct type)
+
+static const int compat_msg_min[XFRM_NR_MSGTYPES] = {
+	[XFRM_MSG_NEWSA       - XFRM_MSG_BASE] = XMSGSIZE(compat_xfrm_usersa_info),
+	[XFRM_MSG_DELSA       - XFRM_MSG_BASE] = XMSGSIZE(xfrm_usersa_id),
+	[XFRM_MSG_GETSA       - XFRM_MSG_BASE] = XMSGSIZE(xfrm_usersa_id),
+	[XFRM_MSG_NEWPOLICY   - XFRM_MSG_BASE] = XMSGSIZE(compat_xfrm_userpolicy_info),
+	[XFRM_MSG_DELPOLICY   - XFRM_MSG_BASE] = XMSGSIZE(xfrm_userpolicy_id),
+	[XFRM_MSG_GETPOLICY   - XFRM_MSG_BASE] = XMSGSIZE(xfrm_userpolicy_id),
+	[XFRM_MSG_ALLOCSPI    - XFRM_MSG_BASE] = XMSGSIZE(compat_xfrm_userspi_info),
+	[XFRM_MSG_ACQUIRE     - XFRM_MSG_BASE] = XMSGSIZE(compat_xfrm_user_acquire),
+	[XFRM_MSG_EXPIRE      - XFRM_MSG_BASE] = XMSGSIZE(compat_xfrm_user_expire),
+	[XFRM_MSG_UPDPOLICY   - XFRM_MSG_BASE] = XMSGSIZE(compat_xfrm_userpolicy_info),
+	[XFRM_MSG_UPDSA       - XFRM_MSG_BASE] = XMSGSIZE(compat_xfrm_usersa_info),
+	[XFRM_MSG_POLEXPIRE   - XFRM_MSG_BASE] = XMSGSIZE(compat_xfrm_user_polexpire),
+	[XFRM_MSG_FLUSHSA     - XFRM_MSG_BASE] = XMSGSIZE(xfrm_usersa_flush),
+	[XFRM_MSG_FLUSHPOLICY - XFRM_MSG_BASE] = 0,
+	[XFRM_MSG_NEWAE       - XFRM_MSG_BASE] = XMSGSIZE(xfrm_aevent_id),
+	[XFRM_MSG_GETAE       - XFRM_MSG_BASE] = XMSGSIZE(xfrm_aevent_id),
+	[XFRM_MSG_REPORT      - XFRM_MSG_BASE] = XMSGSIZE(xfrm_user_report),
+	[XFRM_MSG_MIGRATE     - XFRM_MSG_BASE] = XMSGSIZE(xfrm_userpolicy_id),
+	[XFRM_MSG_NEWSADINFO  - XFRM_MSG_BASE] = sizeof(u32),
+	[XFRM_MSG_GETSADINFO  - XFRM_MSG_BASE] = sizeof(u32),
+	[XFRM_MSG_NEWSPDINFO  - XFRM_MSG_BASE] = sizeof(u32),
+	[XFRM_MSG_GETSPDINFO  - XFRM_MSG_BASE] = sizeof(u32),
+	[XFRM_MSG_MAPPING     - XFRM_MSG_BASE] = XMSGSIZE(xfrm_user_mapping)
+};
+
+static struct nlmsghdr *xfrm_nlmsg_put_compat(struct sk_buff *skb,
+			const struct nlmsghdr *nlh_src, u16 type)
+{
+	int payload = compat_msg_min[type];
+	int src_len = xfrm_msg_min[type];
+	struct nlmsghdr *nlh_dst;
+
+	/* Compat messages are shorter or equal to native (+padding) */
+	if (WARN_ON_ONCE(src_len < payload))
+		return ERR_PTR(-EMSGSIZE);
+
+	nlh_dst = nlmsg_put(skb, nlh_src->nlmsg_pid, nlh_src->nlmsg_seq,
+			    nlh_src->nlmsg_type, payload, nlh_src->nlmsg_flags);
+	if (!nlh_dst)
+		return ERR_PTR(-EMSGSIZE);
+
+	memset(nlmsg_data(nlh_dst), 0, payload);
+
+	switch (nlh_src->nlmsg_type) {
+	/* Compat message has the same layout as native */
+	case XFRM_MSG_DELSA:
+	case XFRM_MSG_DELPOLICY:
+	case XFRM_MSG_FLUSHSA:
+	case XFRM_MSG_FLUSHPOLICY:
+	case XFRM_MSG_NEWAE:
+	case XFRM_MSG_REPORT:
+	case XFRM_MSG_MIGRATE:
+	case XFRM_MSG_NEWSADINFO:
+	case XFRM_MSG_NEWSPDINFO:
+	case XFRM_MSG_MAPPING:
+		WARN_ON_ONCE(src_len != payload);
+		memcpy(nlmsg_data(nlh_dst), nlmsg_data(nlh_src), src_len);
+		break;
+	/* 4 byte alignment for trailing u64 on native, but not on compat */
+	case XFRM_MSG_NEWSA:
+	case XFRM_MSG_NEWPOLICY:
+	case XFRM_MSG_UPDSA:
+	case XFRM_MSG_UPDPOLICY:
+		WARN_ON_ONCE(src_len != payload + 4);
+		memcpy(nlmsg_data(nlh_dst), nlmsg_data(nlh_src), payload);
+		break;
+	case XFRM_MSG_EXPIRE: {
+		const struct xfrm_user_expire *src_ue  = nlmsg_data(nlh_src);
+		struct compat_xfrm_user_expire *dst_ue = nlmsg_data(nlh_dst);
+
+		/* compat_xfrm_user_expire has 4-byte smaller state */
+		memcpy(dst_ue, src_ue, sizeof(dst_ue->state));
+		dst_ue->hard = src_ue->hard;
+		break;
+	}
+	case XFRM_MSG_ACQUIRE: {
+		const struct xfrm_user_acquire *src_ua  = nlmsg_data(nlh_src);
+		struct compat_xfrm_user_acquire *dst_ua = nlmsg_data(nlh_dst);
+
+		memcpy(dst_ua, src_ua, offsetof(struct compat_xfrm_user_acquire, aalgos));
+		dst_ua->aalgos = src_ua->aalgos;
+		dst_ua->ealgos = src_ua->ealgos;
+		dst_ua->calgos = src_ua->calgos;
+		dst_ua->seq    = src_ua->seq;
+		break;
+	}
+	case XFRM_MSG_POLEXPIRE: {
+		const struct xfrm_user_polexpire *src_upe  = nlmsg_data(nlh_src);
+		struct compat_xfrm_user_polexpire *dst_upe = nlmsg_data(nlh_dst);
+
+		/* compat_xfrm_user_polexpire has 4-byte smaller state */
+		memcpy(dst_upe, src_upe, sizeof(dst_upe->pol));
+		dst_upe->hard = src_upe->hard;
+		break;
+	}
+	case XFRM_MSG_ALLOCSPI: {
+		const struct xfrm_userspi_info *src_usi = nlmsg_data(nlh_src);
+		struct compat_xfrm_userspi_info *dst_usi = nlmsg_data(nlh_dst);
+
+		/* compat_xfrm_user_polexpire has 4-byte smaller state */
+		memcpy(dst_usi, src_usi, sizeof(src_usi->info));
+		dst_usi->min = src_usi->min;
+		dst_usi->max = src_usi->max;
+		break;
+	}
+	/* Not being sent by kernel */
+	case XFRM_MSG_GETSA:
+	case XFRM_MSG_GETPOLICY:
+	case XFRM_MSG_GETAE:
+	case XFRM_MSG_GETSADINFO:
+	case XFRM_MSG_GETSPDINFO:
+	default:
+		WARN_ONCE(1, "unsupported nlmsg_type %d", nlh_src->nlmsg_type);
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	return nlh_dst;
+}
+
+static int xfrm_nla_cpy(struct sk_buff *dst, const struct nlattr *src, int len)
+{
+	return nla_put(dst, src->nla_type, len, nla_data(src));
+}
+
+static int xfrm_xlate64_attr(struct sk_buff *dst, const struct nlattr *src)
+{
+	switch (src->nla_type) {
+	case XFRMA_ALG_AUTH:
+	case XFRMA_ALG_CRYPT:
+	case XFRMA_ALG_COMP:
+	case XFRMA_ENCAP:
+	case XFRMA_TMPL:
+		return xfrm_nla_cpy(dst, src, nla_len(src));
+	case XFRMA_SA:
+		return xfrm_nla_cpy(dst, src, XMSGSIZE(compat_xfrm_usersa_info));
+	case XFRMA_POLICY:
+		return xfrm_nla_cpy(dst, src, XMSGSIZE(compat_xfrm_userpolicy_info));
+	case XFRMA_SEC_CTX:
+		return xfrm_nla_cpy(dst, src, nla_len(src));
+	case XFRMA_LTIME_VAL:
+		return nla_put_64bit(dst, src->nla_type, nla_len(src),
+			nla_data(src), XFRMA_PAD);
+	case XFRMA_REPLAY_VAL:
+	case XFRMA_REPLAY_THRESH:
+	case XFRMA_ETIMER_THRESH:
+	case XFRMA_SRCADDR:
+	case XFRMA_COADDR:
+		return xfrm_nla_cpy(dst, src, nla_len(src));
+	case XFRMA_LASTUSED:
+		return nla_put_64bit(dst, src->nla_type, nla_len(src),
+			nla_data(src), XFRMA_PAD);
+	case XFRMA_POLICY_TYPE:
+	case XFRMA_MIGRATE:
+	case XFRMA_ALG_AEAD:
+	case XFRMA_KMADDRESS:
+	case XFRMA_ALG_AUTH_TRUNC:
+	case XFRMA_MARK:
+	case XFRMA_TFCPAD:
+	case XFRMA_REPLAY_ESN_VAL:
+	case XFRMA_SA_EXTRA_FLAGS:
+	case XFRMA_PROTO:
+	case XFRMA_ADDRESS_FILTER:
+	case XFRMA_OFFLOAD_DEV:
+	case XFRMA_SET_MARK:
+	case XFRMA_SET_MARK_MASK:
+	case XFRMA_IF_ID:
+		return xfrm_nla_cpy(dst, src, nla_len(src));
+	default:
+		BUILD_BUG_ON(XFRMA_MAX != XFRMA_IF_ID);
+		WARN_ONCE(1, "unsupported nla_type %d", src->nla_type);
+		return -EOPNOTSUPP;
+	}
+}
+
+/* Take kernel-built (64bit layout) and create 32bit layout for userspace */
+static int xfrm_xlate64(struct sk_buff *dst, const struct nlmsghdr *nlh_src)
+{
+	u16 type = nlh_src->nlmsg_type - XFRM_MSG_BASE;
+	const struct nlattr *nla, *attrs;
+	struct nlmsghdr *nlh_dst;
+	int len, remaining;
+
+	nlh_dst = xfrm_nlmsg_put_compat(dst, nlh_src, type);
+	if (IS_ERR(nlh_dst))
+		return PTR_ERR(nlh_dst);
+
+	attrs = nlmsg_attrdata(nlh_src, xfrm_msg_min[type]);
+	len = nlmsg_attrlen(nlh_src, xfrm_msg_min[type]);
+
+	nla_for_each_attr(nla, attrs, len, remaining) {
+		int err = xfrm_xlate64_attr(dst, nla);
+
+		if (err)
+			return err;
+	}
+
+	nlmsg_end(dst, nlh_dst);
+
+	return 0;
+}
+
+int xfrm_alloc_compat(struct sk_buff *skb)
+{
+	const struct nlmsghdr *nlh_src = nlmsg_hdr(skb);
+	u16 type = nlh_src->nlmsg_type - XFRM_MSG_BASE;
+	struct sk_buff *new = NULL;
+	int err;
+
+	if (WARN_ON_ONCE(type >= ARRAY_SIZE(xfrm_msg_min)))
+		return -EOPNOTSUPP;
+
+	if (skb_shinfo(skb)->frag_list == NULL) {
+		new = alloc_skb(skb->len + skb_tailroom(skb), GFP_ATOMIC);
+		if (!new)
+			return -ENOMEM;
+		skb_shinfo(skb)->frag_list = new;
+	}
+
+	err = xfrm_xlate64(skb_shinfo(skb)->frag_list, nlh_src);
+	if (err) {
+		if (new) {
+			kfree_skb(new);
+			skb_shinfo(skb)->frag_list = NULL;
+		}
+		return err;
+	}
+
+	return 0;
+}
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index fbb7d9d06478..90c57d4a0b47 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1083,12 +1083,19 @@ static inline int xfrm_nlmsg_multicast(struct net *net, struct sk_buff *skb,
 				       u32 pid, unsigned int group)
 {
 	struct sock *nlsk = rcu_dereference(net->xfrm.nlsk);
+	int err;
 
 	if (!nlsk) {
 		kfree_skb(skb);
 		return -EPIPE;
 	}
 
+	err = xfrm_alloc_compat(skb);
+	if (err) {
+		kfree_skb(skb);
+		return err;
+	}
+
 	return nlmsg_multicast(nlsk, skb, pid, group, GFP_ATOMIC);
 }
 
@@ -2533,7 +2540,7 @@ static int xfrm_send_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 
 #define XMSGSIZE(type) sizeof(struct type)
 
-static const int xfrm_msg_min[XFRM_NR_MSGTYPES] = {
+const int xfrm_msg_min[XFRM_NR_MSGTYPES] = {
 	[XFRM_MSG_NEWSA       - XFRM_MSG_BASE] = XMSGSIZE(xfrm_usersa_info),
 	[XFRM_MSG_DELSA       - XFRM_MSG_BASE] = XMSGSIZE(xfrm_usersa_id),
 	[XFRM_MSG_GETSA       - XFRM_MSG_BASE] = XMSGSIZE(xfrm_usersa_id),
-- 
2.27.0

