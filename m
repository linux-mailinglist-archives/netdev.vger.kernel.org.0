Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D24E5EA6D
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbfD2Sqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:46:52 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41711 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729228AbfD2Sqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 14:46:49 -0400
Received: by mail-io1-f66.google.com with SMTP id r10so9902143ioc.8
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 11:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+jcmYgi85pnGcIryIQulxsOHBX/RzTWtCuLuan/5O9w=;
        b=i/gmBeKJ2iNjIODHnbdyCc16ioxWDoqDXXVNHt3nbo7cXEwzjd2mCLm43L5/AWbn3q
         nZmS8N4zAc8UHenYske0SXrqEqDOWfg8Cd1E6yPj+ecuAPNw720gnr3kLKeJMzOKkiIk
         yt1Ivi+9wmEyKPWg9uMdG4DfZsqPgGmfGMOSO90BM7mPvykItVNxazrG3K7oB2xx/MWs
         L78lmfqv9aRKWYt9MFUrTyRuNRuWD44tzRt6ajyczAsKJduZR3bK/KzG8dztp+0TDceb
         YCU0DvEHLfiqxu3CSEGZ5G6EgZreQrmeiIYZX3o5EQUa9GNBcElXZDWyXPCjD0TMyTzI
         /tsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+jcmYgi85pnGcIryIQulxsOHBX/RzTWtCuLuan/5O9w=;
        b=Mc9sYzM/GZFQ4S5mUek6pabDXurXSR0WzV8UeybUnkQnyhGfqxJvVZ329FNQ0aKcxp
         nM7cEU3KtbdKSm3JazURsqSBY/eTSVj/HcbUHOqlkKib/1z2wGdZEsTyaKP/E5qluzWM
         +S2QSMX6CDSC2Hn2rAEXL23mqAy6rdej19jCQUNpYnzZUNEU5o9K+AKVdfszDQLm8JA4
         WvYQWKbsrlngewP3yr+pkYRGI3fFC4fvBgHY6hIzlETWWfhvKZ58WgVT1YoSVEsD9+nU
         CpBPY7R3K8RHRaIycwy9g1018hTSOho++T3HuwT9L0tQCgJtXXEaTo5EjUR8XupiytJ6
         BBMw==
X-Gm-Message-State: APjAAAUkT2wBePcWOipE+grUG9iWGLFOh1jwHsrh9Tj2hhg0mpRdTmo8
        n9eVUl9gzitP5ZNi/z3TJn4wOcApEm8=
X-Google-Smtp-Source: APXvYqwNVFcnxOjqlt1SSEUVgCWUZat/3Oo3b4E1iRzTDySlYFYXUen5exU08HVGwIa0WaVTYkJD4A==
X-Received: by 2002:a5e:da07:: with SMTP id x7mr8599497ioj.138.1556563608023;
        Mon, 29 Apr 2019 11:46:48 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id f129sm181645itf.4.2019.04.29.11.46.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 11:46:47 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v7 net-next 5/6] ip6tlvs: Add netlink interface
Date:   Mon, 29 Apr 2019 11:46:15 -0700
Message-Id: <1556563576-31157-6-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556563576-31157-1-git-send-email-tom@quantonium.net>
References: <1556563576-31157-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a netlink interface to manage the TX TLV parameters. Managed
parameters include those for validating and sending TLVs being sent
such as alignment, TLV ordering, length limits, etc.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 include/net/ipv6.h         |  18 +++
 include/uapi/linux/in6.h   |  31 +++++
 net/ipv6/exthdrs_common.c  | 278 +++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/exthdrs_options.c |  81 ++++++++++++-
 4 files changed, 406 insertions(+), 2 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 4cebc48..edf718f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -17,6 +17,7 @@
 #include <linux/hardirq.h>
 #include <linux/jhash.h>
 #include <linux/refcount.h>
+#include <net/genetlink.h>
 #include <net/if_inet6.h>
 #include <net/ndisc.h>
 #include <net/flow.h>
@@ -449,6 +450,23 @@ int tlv_set_params(struct tlv_param_table *tlv_param_table,
 int tlv_unset_params(struct tlv_param_table *tlv_param_table,
 		     unsigned char type);
 
+extern const struct nla_policy tlv_nl_policy[];
+
+int tlv_nl_cmd_set(struct tlv_param_table *tlv_param_table,
+		   struct genl_family *tlv_nl_family,
+		   struct sk_buff *skb, struct genl_info *info);
+int tlv_nl_cmd_unset(struct tlv_param_table *tlv_param_table,
+		     struct genl_family *tlv_nl_family,
+		     struct sk_buff *skb, struct genl_info *info);
+int tlv_nl_cmd_get(struct tlv_param_table *tlv_param_table,
+		   struct genl_family *tlv_nl_family,
+		   struct sk_buff *skb, struct genl_info *info);
+int tlv_fill_info(struct tlv_param_table *tlv_param_table,
+		  int tlv_type, struct sk_buff *msg, bool admin);
+int tlv_nl_dump(struct tlv_param_table *tlv_param_table,
+		struct genl_family *tlv_nl_family,
+		struct sk_buff *skb, struct netlink_callback *cb);
+
 int exthdrs_init(struct tlv_param_table *tlv_param_table,
 		 const struct tlv_proc_init *init_params,
 		 int num_init_params);
diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
index 6a99ee1..1c79361 100644
--- a/include/uapi/linux/in6.h
+++ b/include/uapi/linux/in6.h
@@ -306,6 +306,37 @@ struct in6_flowlabel_req {
 
 #define IPV6_TLV_CLASS_ANY_DSTOPT      (IPV6_TLV_CLASS_FLAG_RTRDSTOPT | \
 					IPV6_TLV_CLASS_FLAG_DSTOPT)
+/* NETLINK_GENERIC related info for IPv6 TLVs */
+
+#define IPV6_TLV_GENL_NAME	"ipv6-tlv"
+#define IPV6_TLV_GENL_VERSION	0x1
+
+enum {
+	IPV6_TLV_ATTR_UNSPEC,
+	IPV6_TLV_ATTR_TYPE,			/* u8, > 1 */
+	IPV6_TLV_ATTR_ORDER,			/* u8 */
+	IPV6_TLV_ATTR_ADMIN_PERM,		/* u8, perm value */
+	IPV6_TLV_ATTR_USER_PERM,		/* u8, perm value */
+	IPV6_TLV_ATTR_CLASS,			/* u8, 3 bit flags */
+	IPV6_TLV_ATTR_ALIGN_MULT,		/* u8, 1 to 16 */
+	IPV6_TLV_ATTR_ALIGN_OFF,		/* u8, 0 to 15 */
+	IPV6_TLV_ATTR_MIN_DATA_LEN,		/* u8 (option data length) */
+	IPV6_TLV_ATTR_MAX_DATA_LEN,		/* u8 (option data length) */
+	IPV6_TLV_ATTR_DATA_LEN_MULT,		/* u8, 1 to 16 */
+	IPV6_TLV_ATTR_DATA_LEN_OFF,		/* u8, 0 to 15 */
+
+	__IPV6_TLV_ATTR_MAX,
+};
+
+#define IPV6_TLV_ATTR_MAX              (__IPV6_TLV_ATTR_MAX - 1)
+
+enum {
+	IPV6_TLV_CMD_SET,
+	IPV6_TLV_CMD_UNSET,
+	IPV6_TLV_CMD_GET,
+
+	__IPV6_TLV_CMD_MAX,
+};
 
 /* TLV permissions values */
 enum {
diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
index c0ccb0a..b24846d 100644
--- a/net/ipv6/exthdrs_common.c
+++ b/net/ipv6/exthdrs_common.c
@@ -381,6 +381,284 @@ int tlv_unset_params(struct tlv_param_table *tlv_param_table,
 }
 EXPORT_SYMBOL(tlv_unset_params);
 
+const struct nla_policy tlv_nl_policy[IPV6_TLV_ATTR_MAX + 1] = {
+	[IPV6_TLV_ATTR_TYPE] =		{ .type = NLA_U8, },
+	[IPV6_TLV_ATTR_ORDER] =		{ .type = NLA_U8, },
+	[IPV6_TLV_ATTR_ADMIN_PERM] =	{ .type = NLA_U8, },
+	[IPV6_TLV_ATTR_USER_PERM] =	{ .type = NLA_U8, },
+	[IPV6_TLV_ATTR_CLASS] =		{ .type = NLA_U8, },
+	[IPV6_TLV_ATTR_ALIGN_MULT] =	{ .type = NLA_U8, },
+	[IPV6_TLV_ATTR_ALIGN_OFF] =	{ .type = NLA_U8, },
+	[IPV6_TLV_ATTR_MIN_DATA_LEN] =	{ .type = NLA_U8, },
+	[IPV6_TLV_ATTR_MAX_DATA_LEN] =	{ .type = NLA_U8, },
+	[IPV6_TLV_ATTR_DATA_LEN_OFF] =	{ .type = NLA_U8, },
+	[IPV6_TLV_ATTR_DATA_LEN_MULT] =	{ .type = NLA_U8, },
+};
+EXPORT_SYMBOL(tlv_nl_policy);
+
+int tlv_nl_cmd_set(struct tlv_param_table *tlv_param_table,
+		   struct genl_family *tlv_nl_family,
+		   struct sk_buff *skb, struct genl_info *info)
+{
+	struct tlv_params new_params;
+	struct tlv_tx_params *tptx;
+	struct tlv_proc *tproc;
+	int retv = -EINVAL, i;
+	u8 tlv_type, v;
+
+	if (!info->attrs[IPV6_TLV_ATTR_TYPE])
+		return -EINVAL;
+
+	tlv_type = nla_get_u8(info->attrs[IPV6_TLV_ATTR_TYPE]);
+	if (tlv_type < 2)
+		return -EINVAL;
+
+	rcu_read_lock();
+
+	/* Base new parameters on existing ones */
+	tproc = tlv_get_proc(tlv_param_table, tlv_type);
+	new_params = tproc->params;
+
+	if (info->attrs[IPV6_TLV_ATTR_ORDER]) {
+		v = nla_get_u8(info->attrs[IPV6_TLV_ATTR_ORDER]);
+		if (v) {
+			for (i = 2; i < 256; i++) {
+				tproc = tlv_get_proc(tlv_param_table, i);
+				tptx = &tproc->params.t;
+
+				/* Preferred orders must be unique */
+				if (tptx->preferred_order == v &&
+				    i != tlv_type) {
+					retv = -EALREADY;
+					goto out;
+				}
+			}
+			new_params.t.preferred_order = v;
+		}
+	}
+
+	if (!new_params.t.preferred_order) {
+		unsigned long check_map[BITS_TO_LONGS(255)];
+		int pos;
+
+		/* Preferred order not specified, automatically set one.
+		 * This is chosen to be the first value after the greatest
+		 * order in use.
+		 */
+		memset(check_map, 0, sizeof(check_map));
+
+		for (i = 2; i < 256; i++) {
+			unsigned int order;
+
+			tproc = tlv_get_proc(tlv_param_table, i);
+			tptx = &tproc->params.t;
+			order = tptx->preferred_order;
+
+			if (!order)
+				continue;
+
+			WARN_ON(test_bit(255 - order, check_map));
+			set_bit(255 - order, check_map);
+		}
+
+		pos = find_first_bit(check_map, 255);
+		if (pos)
+			new_params.t.preferred_order = 255 - (pos - 1);
+		else
+			new_params.t.preferred_order = 255 -
+			    find_first_zero_bit(check_map, sizeof(check_map));
+	}
+
+	if (info->attrs[IPV6_TLV_ATTR_ADMIN_PERM]) {
+		v = nla_get_u8(info->attrs[IPV6_TLV_ATTR_ADMIN_PERM]);
+		if (v > IPV6_TLV_PERM_MAX)
+			goto out;
+		new_params.t.admin_perm = v;
+	}
+
+	if (info->attrs[IPV6_TLV_ATTR_USER_PERM]) {
+		v = nla_get_u8(info->attrs[IPV6_TLV_ATTR_USER_PERM]);
+		if (v > IPV6_TLV_PERM_MAX)
+			goto out;
+		new_params.t.user_perm = v;
+	}
+
+	if (info->attrs[IPV6_TLV_ATTR_CLASS]) {
+		v = nla_get_u8(info->attrs[IPV6_TLV_ATTR_CLASS]);
+		if (v > IPV6_TLV_CLASS_MAX)
+			goto out;
+		new_params.t.class = v;
+	}
+
+	if (info->attrs[IPV6_TLV_ATTR_ALIGN_MULT]) {
+		v = nla_get_u8(info->attrs[IPV6_TLV_ATTR_ALIGN_MULT]);
+		if (v > 16 || v < 1)
+			goto out;
+		new_params.t.align_mult = v - 1;
+	}
+
+	if (info->attrs[IPV6_TLV_ATTR_ALIGN_OFF]) {
+		v = nla_get_u8(info->attrs[IPV6_TLV_ATTR_ALIGN_OFF]);
+		if (v > 15)
+			goto out;
+		new_params.t.align_off = v;
+	}
+
+	if (info->attrs[IPV6_TLV_ATTR_MAX_DATA_LEN])
+		new_params.t.max_data_len =
+		    nla_get_u8(info->attrs[IPV6_TLV_ATTR_MAX_DATA_LEN]);
+
+	if (info->attrs[IPV6_TLV_ATTR_MIN_DATA_LEN])
+		new_params.t.min_data_len =
+		    nla_get_u8(info->attrs[IPV6_TLV_ATTR_MIN_DATA_LEN]);
+
+	if (info->attrs[IPV6_TLV_ATTR_DATA_LEN_MULT]) {
+		v = nla_get_u8(info->attrs[IPV6_TLV_ATTR_DATA_LEN_MULT]);
+		if (v > 16 || v < 1)
+			goto out;
+		new_params.t.data_len_mult = v - 1;
+	}
+
+	if (info->attrs[IPV6_TLV_ATTR_DATA_LEN_OFF]) {
+		v = nla_get_u8(info->attrs[IPV6_TLV_ATTR_DATA_LEN_OFF]);
+		if (v > 15)
+			goto out;
+		new_params.t.data_len_off = v;
+	}
+
+	retv = tlv_set_params(tlv_param_table, tlv_type, &new_params);
+
+out:
+	rcu_read_unlock();
+	return retv;
+}
+EXPORT_SYMBOL(tlv_nl_cmd_set);
+
+int tlv_nl_cmd_unset(struct tlv_param_table *tlv_param_table,
+		     struct genl_family *tlv_nl_family,
+		     struct sk_buff *skb, struct genl_info *info)
+{
+	unsigned int tlv_type;
+
+	if (!info->attrs[IPV6_TLV_ATTR_TYPE])
+		return -EINVAL;
+
+	tlv_type = nla_get_u8(info->attrs[IPV6_TLV_ATTR_TYPE]);
+	if (tlv_type < 2)
+		return -EINVAL;
+
+	return tlv_unset_params(tlv_param_table, tlv_type);
+}
+EXPORT_SYMBOL(tlv_nl_cmd_unset);
+
+int tlv_fill_info(struct tlv_param_table *tlv_param_table,
+		  int tlv_type, struct sk_buff *msg, bool admin)
+{
+	struct tlv_proc *tproc;
+	struct tlv_params *tp;
+	int ret = 0;
+
+	rcu_read_lock();
+
+	tproc = tlv_get_proc(tlv_param_table, tlv_type);
+	tp = &tproc->params;
+
+	if (nla_put_u8(msg, IPV6_TLV_ATTR_TYPE, tlv_type) ||
+	    nla_put_u8(msg, IPV6_TLV_ATTR_ORDER, tp->t.preferred_order) ||
+	    nla_put_u8(msg, IPV6_TLV_ATTR_USER_PERM, tp->t.user_perm) ||
+	    (admin && nla_put_u8(msg, IPV6_TLV_ATTR_ADMIN_PERM,
+				 tp->t.admin_perm)) ||
+	    nla_put_u8(msg, IPV6_TLV_ATTR_CLASS, tp->t.class) ||
+	    nla_put_u8(msg, IPV6_TLV_ATTR_ALIGN_MULT, tp->t.align_mult + 1) ||
+	    nla_put_u8(msg, IPV6_TLV_ATTR_ALIGN_OFF, tp->t.align_off) ||
+	    nla_put_u8(msg, IPV6_TLV_ATTR_MIN_DATA_LEN, tp->t.min_data_len) ||
+	    nla_put_u8(msg, IPV6_TLV_ATTR_MAX_DATA_LEN, tp->t.max_data_len) ||
+	    nla_put_u8(msg, IPV6_TLV_ATTR_DATA_LEN_MULT,
+		       tp->t.data_len_mult + 1) ||
+	    nla_put_u8(msg, IPV6_TLV_ATTR_DATA_LEN_OFF, tp->t.data_len_off))
+		ret = -1;
+
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL(tlv_fill_info);
+
+static int tlv_dump_info(struct tlv_param_table *tlv_param_table,
+			 struct genl_family *tlv_nl_family,
+			 int tlv_type, u32 portid, u32 seq, u32 flags,
+			 struct sk_buff *skb, u8 cmd, bool admin)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(skb, portid, seq, tlv_nl_family, flags, cmd);
+	if (!hdr)
+		return -ENOMEM;
+
+	if (tlv_fill_info(tlv_param_table, tlv_type, skb, admin) < 0) {
+		genlmsg_cancel(skb, hdr);
+		return -EMSGSIZE;
+	}
+
+	genlmsg_end(skb, hdr);
+
+	return 0;
+}
+
+int tlv_nl_cmd_get(struct tlv_param_table *tlv_param_table,
+		   struct genl_family *tlv_nl_family,
+		   struct sk_buff *skb, struct genl_info *info)
+{
+	struct sk_buff *msg;
+	int ret, tlv_type;
+
+	if (!info->attrs[IPV6_TLV_ATTR_TYPE])
+		return -EINVAL;
+
+	tlv_type = nla_get_u8(info->attrs[IPV6_TLV_ATTR_TYPE]);
+	if (tlv_type < 2)
+		return -EINVAL;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	ret = tlv_dump_info(tlv_param_table, tlv_nl_family,
+			    tlv_type, info->snd_portid, info->snd_seq, 0, msg,
+			    info->genlhdr->cmd,
+			    netlink_capable(skb, CAP_NET_ADMIN));
+	if (ret < 0) {
+		nlmsg_free(msg);
+		return ret;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+EXPORT_SYMBOL(tlv_nl_cmd_get);
+
+int tlv_nl_dump(struct tlv_param_table *tlv_param_table,
+		struct genl_family *tlv_nl_family,
+		struct sk_buff *skb, struct netlink_callback *cb)
+{
+	int idx = 0, ret, i;
+
+	for (i = 2; i < 256; i++) {
+		if (idx++ < cb->args[0])
+			continue;
+		ret = tlv_dump_info(tlv_param_table, tlv_nl_family, i,
+				    NETLINK_CB(cb->skb).portid,
+				    cb->nlh->nlmsg_seq, NLM_F_MULTI,
+				    skb, IPV6_TLV_CMD_GET,
+				    netlink_capable(cb->skb, CAP_NET_ADMIN));
+		if (ret)
+			break;
+	}
+
+	cb->args[0] = idx;
+	return skb->len;
+}
+EXPORT_SYMBOL(tlv_nl_dump);
+
 int exthdrs_init(struct tlv_param_table *tlv_param_table,
 		 const struct tlv_proc_init *tlv_init_params,
 		 int num_init_params)
diff --git a/net/ipv6/exthdrs_options.c b/net/ipv6/exthdrs_options.c
index 0c69d7f..811e5d1 100644
--- a/net/ipv6/exthdrs_options.c
+++ b/net/ipv6/exthdrs_options.c
@@ -6,6 +6,7 @@
 #include <linux/socket.h>
 #include <linux/types.h>
 #include <net/calipso.h>
+#include <net/genetlink.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -256,13 +257,89 @@ static const struct tlv_proc_init tlv_init_params[] __initconst = {
 struct tlv_param_table __rcu ipv6_tlv_param_table;
 EXPORT_SYMBOL(ipv6_tlv_param_table);
 
+static int ipv6_tlv_nl_cmd_set(struct sk_buff *skb, struct genl_info *info);
+static int ipv6_tlv_nl_cmd_unset(struct sk_buff *skb, struct genl_info *info);
+static int ipv6_tlv_nl_cmd_get(struct sk_buff *skb, struct genl_info *info);
+static int ipv6_tlv_nl_dump(struct sk_buff *skb, struct netlink_callback *cb);
+
+static const struct genl_ops ipv6_tlv_nl_ops[] = {
+{
+	.cmd = IPV6_TLV_CMD_SET,
+	.doit = ipv6_tlv_nl_cmd_set,
+	.flags = GENL_ADMIN_PERM,
+},
+{
+	.cmd = IPV6_TLV_CMD_UNSET,
+	.doit = ipv6_tlv_nl_cmd_unset,
+	.flags = GENL_ADMIN_PERM,
+},
+{
+	.cmd = IPV6_TLV_CMD_GET,
+	.doit = ipv6_tlv_nl_cmd_get,
+	.dumpit = ipv6_tlv_nl_dump,
+},
+};
+
+struct genl_family ipv6_tlv_nl_family __ro_after_init = {
+	.hdrsize	= 0,
+	.name		= IPV6_TLV_GENL_NAME,
+	.version	= IPV6_TLV_GENL_VERSION,
+	.maxattr	= IPV6_TLV_ATTR_MAX,
+	.policy		= tlv_nl_policy,
+	.netnsok	= true,
+	.parallel_ops	= true,
+	.ops		= ipv6_tlv_nl_ops,
+	.n_ops		= ARRAY_SIZE(ipv6_tlv_nl_ops),
+	.module		= THIS_MODULE,
+};
+
+static int ipv6_tlv_nl_cmd_set(struct sk_buff *skb, struct genl_info *info)
+{
+	return tlv_nl_cmd_set(&ipv6_tlv_param_table, &ipv6_tlv_nl_family,
+			      skb, info);
+}
+
+static int ipv6_tlv_nl_cmd_unset(struct sk_buff *skb, struct genl_info *info)
+{
+	return tlv_nl_cmd_unset(&ipv6_tlv_param_table, &ipv6_tlv_nl_family,
+				skb, info);
+}
+
+static int ipv6_tlv_nl_cmd_get(struct sk_buff *skb, struct genl_info *info)
+{
+	return tlv_nl_cmd_get(&ipv6_tlv_param_table, &ipv6_tlv_nl_family,
+			      skb, info);
+}
+
+static int ipv6_tlv_nl_dump(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	return tlv_nl_dump(&ipv6_tlv_param_table, &ipv6_tlv_nl_family,
+			   skb, cb);
+}
+
 int __init ipv6_exthdrs_options_init(void)
 {
-	return exthdrs_init(&ipv6_tlv_param_table, tlv_init_params,
-			    ARRAY_SIZE(tlv_init_params));
+	int err;
+
+	err = genl_register_family(&ipv6_tlv_nl_family);
+	if (err)
+		goto out;
+
+	err = exthdrs_init(&ipv6_tlv_param_table, tlv_init_params,
+			   ARRAY_SIZE(tlv_init_params));
+	if (err)
+		goto out_unregister_genl;
+
+	return 0;
+
+out_unregister_genl:
+	genl_unregister_family(&ipv6_tlv_nl_family);
+out:
+	return err;
 }
 
 void ipv6_exthdrs_options_exit(void)
 {
 	exthdrs_fini(&ipv6_tlv_param_table);
+	genl_unregister_family(&ipv6_tlv_nl_family);
 }
-- 
2.7.4

