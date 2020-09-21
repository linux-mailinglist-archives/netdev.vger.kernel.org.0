Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBD02727C7
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 16:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgIUOhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 10:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727485AbgIUOhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 10:37:04 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08BFC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:37:03 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o5so13011486wrn.13
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 07:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jqXPwfjgInpVF6pl7exVjyUD6F3ypu23mNugo3zmgV8=;
        b=KeVO3zqFFXd/Li/ZDEBseMWJ639BS5d6Ff36WcXrdFJhQYRGv3oMGH+DW7p1cS8T61
         Gj1wigBdJKWidrQthFj4/j/jDPhS+PDdTHFGDWZuorLTfs2jdgrsxIrDnvHnGS1rPM4T
         3U3abl2tZNfJ4qFBs4r5a0Rc/GShId9GgcEjKPCquFUyZ6EmJbC9bK8oTiQFD0Uqc4GA
         RstInSu9tEFfudLi7mJHOjtdEU/GSAY7cU1kUW/9zqKLpU9tEfqGc4bTG4kpcmvnrcHj
         YMdv4ZkNl/L4TcfRrW1tuJ+smEyhOH5ap2CzJbxw37C3GhoPhEFLjMWOUIA1EsLJlz88
         R9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jqXPwfjgInpVF6pl7exVjyUD6F3ypu23mNugo3zmgV8=;
        b=cvakOtTCL24BI3K7EK+v50qrAYnvptva4sb3Rm0RWu6QLlDjjtgmgwraFqOeLacs/D
         ifjoj09YSQhuz2/T2pNsiPohEvN9XBxSz5fnsVNZReFS8OlXQwxPUGFeW+khJIfE9PxP
         YY3I3Eh/TvzzVVwVOO2iCRYSwtPwzODo4sdZxrm1Z7aSH+ks6lIuANfV9QpwN+J/FtGD
         nc6KaZPCL7urDAPbo/15tC3hE4YUZzNl0c8yGe9c52v7ZUAZeCI0jmwhRulEPgJtUOWi
         AUU9Rw4UltrNfelpr2ZCdwWCgRMFtn2dj5KLUvYHJ5+qvSQ/f4CjjEllmR+iW1sgLOGm
         IYfg==
X-Gm-Message-State: AOAM531iYBt5jxbd68yJSaQLtruV1rEiZA1Pgo/r8Ve9Machnx1u4M7i
        GV1ewHkJNYfgYp75KscjkG+LJg==
X-Google-Smtp-Source: ABdhPJw2eq7guYnLgHXl7Y7ohjQCW2furkTzdrpPFgrd1/w914B6eNkI2LL4/GFcrE3oAW++OJEi5A==
X-Received: by 2002:a5d:62c2:: with SMTP id o2mr78113wrv.418.1600699022379;
        Mon, 21 Sep 2020 07:37:02 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c14sm20370753wrv.12.2020.09.21.07.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 07:37:01 -0700 (PDT)
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
Subject: [PATCH v3 2/7] xfrm/compat: Add 64=>32-bit messages translator
Date:   Mon, 21 Sep 2020 15:36:52 +0100
Message-Id: <20200921143657.604020-3-dima@arista.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921143657.604020-1-dima@arista.com>
References: <20200921143657.604020-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide the kernel-to-user translator under XFRM_USER_COMPAT, that
creates for 64-bit xfrm-user message a 32-bit translation and puts it
in skb's frag_list. net/compat.c layer provides MSG_CMSG_COMPAT to
decide if the message should be taken from skb or frag_list.
(used by wext-core which has also an ABI difference)

Kernel sends 64-bit xfrm messages to the userspace for:
- multicast (monitor events)
- netlink dumps

Wire up the translator to xfrm_nlmsg_multicast().

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/net/xfrm.h     |   5 +
 net/xfrm/xfrm_compat.c | 296 +++++++++++++++++++++++++++++++++++++++++
 net/xfrm/xfrm_user.c   |  15 ++-
 3 files changed, 315 insertions(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index fe2e3717da14..5b6cc62c9354 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -2000,7 +2000,12 @@ static inline int xfrm_tunnel_check(struct sk_buff *skb, struct xfrm_state *x,
 	return 0;
 }
 
+extern const int xfrm_msg_min[XFRM_NR_MSGTYPES];
+
 struct xfrm_translator {
+	/* Allocate frag_list and put compat translation there */
+	int (*alloc_compat)(struct sk_buff *skb, const struct nlmsghdr *src);
+
 	struct module *owner;
 };
 
diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index f01d9af41c55..aece41b44ff2 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -8,8 +8,304 @@
 #include <linux/xfrm.h>
 #include <net/xfrm.h>
 
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
+	case XFRMA_PAD:
+		/* Ignore */
+		return 0;
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
+static int xfrm_alloc_compat(struct sk_buff *skb, const struct nlmsghdr *nlh_src)
+{
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
+
 static struct xfrm_translator xfrm_translator = {
 	.owner				= THIS_MODULE,
+	.alloc_compat			= xfrm_alloc_compat,
 };
 
 static int __init xfrm_compat_init(void)
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index fbb7d9d06478..3769227ed4e1 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1083,12 +1083,24 @@ static inline int xfrm_nlmsg_multicast(struct net *net, struct sk_buff *skb,
 				       u32 pid, unsigned int group)
 {
 	struct sock *nlsk = rcu_dereference(net->xfrm.nlsk);
+	struct xfrm_translator *xtr;
 
 	if (!nlsk) {
 		kfree_skb(skb);
 		return -EPIPE;
 	}
 
+	xtr = xfrm_get_translator();
+	if (xtr) {
+		int err = xtr->alloc_compat(skb, nlmsg_hdr(skb));
+
+		xfrm_put_translator(xtr);
+		if (err) {
+			kfree_skb(skb);
+			return err;
+		}
+	}
+
 	return nlmsg_multicast(nlsk, skb, pid, group, GFP_ATOMIC);
 }
 
@@ -2533,7 +2545,7 @@ static int xfrm_send_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 
 #define XMSGSIZE(type) sizeof(struct type)
 
-static const int xfrm_msg_min[XFRM_NR_MSGTYPES] = {
+const int xfrm_msg_min[XFRM_NR_MSGTYPES] = {
 	[XFRM_MSG_NEWSA       - XFRM_MSG_BASE] = XMSGSIZE(xfrm_usersa_info),
 	[XFRM_MSG_DELSA       - XFRM_MSG_BASE] = XMSGSIZE(xfrm_usersa_id),
 	[XFRM_MSG_GETSA       - XFRM_MSG_BASE] = XMSGSIZE(xfrm_usersa_id),
@@ -2556,6 +2568,7 @@ static const int xfrm_msg_min[XFRM_NR_MSGTYPES] = {
 	[XFRM_MSG_NEWSPDINFO  - XFRM_MSG_BASE] = sizeof(u32),
 	[XFRM_MSG_GETSPDINFO  - XFRM_MSG_BASE] = sizeof(u32),
 };
+EXPORT_SYMBOL_GPL(xfrm_msg_min);
 
 #undef XMSGSIZE
 
-- 
2.28.0

