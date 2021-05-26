Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFA0391E1F
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 19:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233626AbhEZR3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:29:03 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:46312 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbhEZR26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 13:28:58 -0400
Received: from ubuntu18.home (135.19-200-80.adsl-dyn.isp.belgacom.be [80.200.19.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 1E162200E1CD;
        Wed, 26 May 2021 19:17:11 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 1E162200E1CD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1622049431;
        bh=Kzdh0j7UH1DAJGpf0pqMkqgf6GaAhNci4sP3IDi9YBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6c8lpkXBYtjo3gcU/LaK0EPnHGbFgpU8bXjLbtmd7vWGGC3RxRBQR3i26NBE9GYm
         Tl1pifK+XOuqh9YG8xAvb2+Zv0EAmJ1f4nm1tm7KcuaK+qToa1oMtQ2qc6tETr7BNj
         fr+4jXzgw+Id0EHjcICacRBFBQhVLSvEQay/3avCVNPBEDzhbEow07zP/RFKd9ud9E
         uytYTLRuPdkn32yiEw1AWC3QQDcXlkSj35+8mp/0dB5NcTvaWrCWQ66v1YlhWPt7fH
         HFIUGzX9n81RFdUh7K5YGJy4vfZlMiu72UAB4Wgw0UI1qK5c54AS+c7lbQ0/OlKePa
         k0T6Mc6lBgVvQ==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, tom@herbertland.com,
        justin.iurman@uliege.be
Subject: [RESEND PATCH net-next v3 3/5] ipv6: ioam: IOAM Generic Netlink API
Date:   Wed, 26 May 2021 19:16:38 +0200
Message-Id: <20210526171640.9722-4-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210526171640.9722-1-justin.iurman@uliege.be>
References: <20210526171640.9722-1-justin.iurman@uliege.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Generic Netlink commands to allow userspace to configure IOAM
namespaces and schemas. The target is iproute2 and the patch is ready.
It will be posted as soon as this patchset is merged. Here is an overview:

$ ip ioam
Usage:	ip ioam { COMMAND | help }
	ip ioam namespace show
	ip ioam namespace add ID [ DATA ]
	ip ioam namespace del ID
	ip ioam schema show
	ip ioam schema add ID DATA
	ip ioam schema del ID
	ip ioam namespace set ID schema { ID | none }

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/linux/ioam6_genl.h      |  13 +
 include/uapi/linux/ioam6_genl.h |  49 ++++
 net/ipv6/ioam6.c                | 506 +++++++++++++++++++++++++++++++-
 3 files changed, 566 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/ioam6_genl.h
 create mode 100644 include/uapi/linux/ioam6_genl.h

diff --git a/include/linux/ioam6_genl.h b/include/linux/ioam6_genl.h
new file mode 100644
index 000000000000..176e67919de3
--- /dev/null
+++ b/include/linux/ioam6_genl.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ *  IPv6 IOAM Generic Netlink API
+ *
+ *  Author:
+ *  Justin Iurman <justin.iurman@uliege.be>
+ */
+#ifndef _LINUX_IOAM6_GENL_H
+#define _LINUX_IOAM6_GENL_H
+
+#include <uapi/linux/ioam6_genl.h>
+
+#endif /* _LINUX_IOAM6_GENL_H */
diff --git a/include/uapi/linux/ioam6_genl.h b/include/uapi/linux/ioam6_genl.h
new file mode 100644
index 000000000000..0dd94b26448d
--- /dev/null
+++ b/include/uapi/linux/ioam6_genl.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ *  IPv6 IOAM Generic Netlink API
+ *
+ *  Author:
+ *  Justin Iurman <justin.iurman@uliege.be>
+ */
+
+#ifndef _UAPI_LINUX_IOAM6_GENL_H
+#define _UAPI_LINUX_IOAM6_GENL_H
+
+#define IOAM6_GENL_NAME "IOAM6"
+#define IOAM6_GENL_VERSION 0x1
+
+enum {
+	IOAM6_ATTR_UNSPEC,
+
+	IOAM6_ATTR_NS_ID,	/* u16 */
+	IOAM6_ATTR_NS_DATA,	/* u64 */
+
+#define IOAM6_MAX_SCHEMA_DATA_LEN (255 * 4)
+	IOAM6_ATTR_SC_ID,	/* u32 */
+	IOAM6_ATTR_SC_DATA,	/* Binary */
+	IOAM6_ATTR_SC_NONE,	/* Flag */
+
+	IOAM6_ATTR_PAD,
+
+	__IOAM6_ATTR_MAX,
+};
+#define IOAM6_ATTR_MAX (__IOAM6_ATTR_MAX - 1)
+
+enum {
+	IOAM6_CMD_UNSPEC,
+
+	IOAM6_CMD_ADD_NAMESPACE,
+	IOAM6_CMD_DEL_NAMESPACE,
+	IOAM6_CMD_DUMP_NAMESPACES,
+
+	IOAM6_CMD_ADD_SCHEMA,
+	IOAM6_CMD_DEL_SCHEMA,
+	IOAM6_CMD_DUMP_SCHEMAS,
+
+	IOAM6_CMD_NS_SET_SCHEMA,
+
+	__IOAM6_CMD_MAX,
+};
+#define IOAM6_CMD_MAX (__IOAM6_CMD_MAX - 1)
+
+#endif /* _UAPI_LINUX_IOAM6_GENL_H */
diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index dcec24e09e99..09fb93f4cf1f 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -11,15 +11,18 @@
 #include <linux/kernel.h>
 #include <linux/net.h>
 #include <linux/ioam6.h>
+#include <linux/ioam6_genl.h>
 #include <linux/rhashtable.h>
 
 #include <net/addrconf.h>
+#include <net/genetlink.h>
 #include <net/ioam6.h>
 
 #define IOAM6_EMPTY_u16 0xffff
 #define IOAM6_EMPTY_u24 0x00ffffff
 #define IOAM6_EMPTY_u32 0xffffffff
 #define IOAM6_EMPTY_u56 0x00ffffffffffffff
+#define IOAM6_EMPTY_u64 0xffffffffffffffff
 
 #define IOAM6_MASK_u24	IOAM6_EMPTY_u24
 #define IOAM6_MASK_u56	IOAM6_EMPTY_u56
@@ -80,6 +83,496 @@ static const struct rhashtable_params rht_sc_params = {
 	.obj_cmpfn		= ioam6_sc_cmpfn,
 };
 
+static struct genl_family ioam6_genl_family;
+
+static const struct nla_policy ioam6_genl_policy[IOAM6_ATTR_MAX + 1] = {
+	[IOAM6_ATTR_NS_ID]	= { .type = NLA_U16 },
+	[IOAM6_ATTR_NS_DATA]	= { .type = NLA_U64 },
+	[IOAM6_ATTR_SC_ID]	= { .type = NLA_U32 },
+	[IOAM6_ATTR_SC_DATA]	= { .type = NLA_BINARY,
+				    .len = IOAM6_MAX_SCHEMA_DATA_LEN },
+	[IOAM6_ATTR_SC_NONE]	= { .type = NLA_FLAG },
+};
+
+static int ioam6_genl_addns(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ioam6_pernet_data *nsdata;
+	struct ioam6_namespace *ns;
+	__be16 ns_id;
+	int err;
+
+	if (!info->attrs[IOAM6_ATTR_NS_ID])
+		return -EINVAL;
+
+	ns_id = cpu_to_be16(nla_get_u16(info->attrs[IOAM6_ATTR_NS_ID]));
+	nsdata = ioam6_pernet(genl_info_net(info));
+
+	mutex_lock(&nsdata->lock);
+
+	ns = rhashtable_lookup_fast(&nsdata->namespaces, &ns_id, rht_ns_params);
+	if (ns) {
+		err = -EEXIST;
+		goto out_unlock;
+	}
+
+	ns = kzalloc(sizeof(*ns), GFP_KERNEL);
+	if (!ns) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
+
+	ns->id = ns_id;
+
+	if (!info->attrs[IOAM6_ATTR_NS_DATA]) {
+		ns->data = cpu_to_be64(IOAM6_EMPTY_u64);
+	} else {
+		ns->data = cpu_to_be64(
+				nla_get_u64(info->attrs[IOAM6_ATTR_NS_DATA]));
+	}
+
+	err = rhashtable_lookup_insert_fast(&nsdata->namespaces, &ns->head,
+					    rht_ns_params);
+	if (err)
+		kfree(ns);
+
+out_unlock:
+	mutex_unlock(&nsdata->lock);
+	return err;
+}
+
+static int ioam6_genl_delns(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ioam6_pernet_data *nsdata;
+	struct ioam6_namespace *ns;
+	struct ioam6_schema *sc;
+	__be16 ns_id;
+	int err;
+
+	if (!info->attrs[IOAM6_ATTR_NS_ID])
+		return -EINVAL;
+
+	ns_id = cpu_to_be16(nla_get_u16(info->attrs[IOAM6_ATTR_NS_ID]));
+	nsdata = ioam6_pernet(genl_info_net(info));
+
+	mutex_lock(&nsdata->lock);
+
+	ns = rhashtable_lookup_fast(&nsdata->namespaces, &ns_id, rht_ns_params);
+	if (!ns) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
+
+	sc = ns->schema;
+	err = rhashtable_remove_fast(&nsdata->namespaces, &ns->head,
+				     rht_ns_params);
+	if (err)
+		goto out_unlock;
+
+	if (sc)
+		sc->ns = NULL;
+
+	ioam6_ns_release(ns);
+
+out_unlock:
+	mutex_unlock(&nsdata->lock);
+	return err;
+}
+
+static int __ioam6_genl_dumpns_element(struct ioam6_namespace *ns,
+				       u32 portid,
+				       u32 seq,
+				       u32 flags,
+				       struct sk_buff *skb,
+				       u8 cmd)
+{
+	void *hdr;
+	u64 data;
+
+	hdr = genlmsg_put(skb, portid, seq, &ioam6_genl_family, flags, cmd);
+	if (!hdr)
+		return -ENOMEM;
+
+	data = be64_to_cpu(ns->data);
+
+	if (nla_put_u16(skb, IOAM6_ATTR_NS_ID, be16_to_cpu(ns->id)) ||
+	    (data != IOAM6_EMPTY_u64 &&
+	     nla_put_u64_64bit(skb, IOAM6_ATTR_NS_DATA, data, IOAM6_ATTR_PAD)) ||
+	    (ns->schema && nla_put_u32(skb, IOAM6_ATTR_SC_ID, ns->schema->id)))
+		goto nla_put_failure;
+
+	genlmsg_end(skb, hdr);
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(skb, hdr);
+	return -EMSGSIZE;
+}
+
+static int ioam6_genl_dumpns_start(struct netlink_callback *cb)
+{
+	struct ioam6_pernet_data *nsdata = ioam6_pernet(sock_net(cb->skb->sk));
+	struct rhashtable_iter *iter = (struct rhashtable_iter *)cb->args[0];
+
+	if (!iter) {
+		iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+		if (!iter)
+			return -ENOMEM;
+
+		cb->args[0] = (long)iter;
+	}
+
+	rhashtable_walk_enter(&nsdata->namespaces, iter);
+
+	return 0;
+}
+
+static int ioam6_genl_dumpns_done(struct netlink_callback *cb)
+{
+	struct rhashtable_iter *iter = (struct rhashtable_iter *)cb->args[0];
+
+	rhashtable_walk_exit(iter);
+	kfree(iter);
+
+	return 0;
+}
+
+static int ioam6_genl_dumpns(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct rhashtable_iter *iter;
+	struct ioam6_namespace *ns;
+	int err;
+
+	iter = (struct rhashtable_iter *)cb->args[0];
+	rhashtable_walk_start(iter);
+
+	for (;;) {
+		ns = rhashtable_walk_next(iter);
+
+		if (IS_ERR(ns)) {
+			if (PTR_ERR(ns) == -EAGAIN)
+				continue;
+			err = PTR_ERR(ns);
+			goto done;
+		} else if (!ns) {
+			break;
+		}
+
+		err = __ioam6_genl_dumpns_element(ns,
+						  NETLINK_CB(cb->skb).portid,
+						  cb->nlh->nlmsg_seq,
+						  NLM_F_MULTI,
+						  skb,
+						  IOAM6_CMD_DUMP_NAMESPACES);
+		if (err)
+			goto done;
+	}
+
+	err = skb->len;
+
+done:
+	rhashtable_walk_stop(iter);
+	return err;
+}
+
+static int ioam6_genl_addsc(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ioam6_pernet_data *nsdata;
+	int len, len_aligned, err;
+	struct ioam6_schema *sc;
+	u32 sc_id;
+
+	if (!info->attrs[IOAM6_ATTR_SC_ID] || !info->attrs[IOAM6_ATTR_SC_DATA])
+		return -EINVAL;
+
+	sc_id = nla_get_u32(info->attrs[IOAM6_ATTR_SC_ID]);
+	nsdata = ioam6_pernet(genl_info_net(info));
+
+	mutex_lock(&nsdata->lock);
+
+	sc = rhashtable_lookup_fast(&nsdata->schemas, &sc_id, rht_sc_params);
+	if (sc) {
+		err = -EEXIST;
+		goto out_unlock;
+	}
+
+	sc = kzalloc(sizeof(*sc), GFP_KERNEL);
+	if (!sc) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
+
+	len = nla_len(info->attrs[IOAM6_ATTR_SC_DATA]);
+	len_aligned = ALIGN(len, 4);
+
+	sc->data = kzalloc(len_aligned, GFP_KERNEL);
+	if (!sc->data) {
+		err = -ENOMEM;
+		goto free_sc;
+	}
+
+	sc->id = sc_id;
+	sc->len = len_aligned;
+	sc->hdr = cpu_to_be32(sc->id | ((u8)(sc->len / 4) << 24));
+
+	nla_memcpy(sc->data, info->attrs[IOAM6_ATTR_SC_DATA], len);
+
+	err = rhashtable_lookup_insert_fast(&nsdata->schemas, &sc->head,
+					    rht_sc_params);
+	if (err)
+		goto free_data;
+
+out_unlock:
+	mutex_unlock(&nsdata->lock);
+	return err;
+free_data:
+	kfree(sc->data);
+free_sc:
+	kfree(sc);
+	goto out_unlock;
+}
+
+static int ioam6_genl_delsc(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ioam6_pernet_data *nsdata;
+	struct ioam6_namespace *ns;
+	struct ioam6_schema *sc;
+	u32 sc_id;
+	int err;
+
+	if (!info->attrs[IOAM6_ATTR_SC_ID])
+		return -EINVAL;
+
+	sc_id = nla_get_u32(info->attrs[IOAM6_ATTR_SC_ID]);
+	nsdata = ioam6_pernet(genl_info_net(info));
+
+	mutex_lock(&nsdata->lock);
+
+	sc = rhashtable_lookup_fast(&nsdata->schemas, &sc_id, rht_sc_params);
+	if (!sc) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
+
+	ns = sc->ns;
+	err = rhashtable_remove_fast(&nsdata->schemas, &sc->head,
+				     rht_sc_params);
+	if (err)
+		goto out_unlock;
+
+	if (ns)
+		ns->schema = NULL;
+
+	ioam6_sc_release(sc);
+
+out_unlock:
+	mutex_unlock(&nsdata->lock);
+	return err;
+}
+
+static int __ioam6_genl_dumpsc_element(struct ioam6_schema *sc,
+				       u32 portid, u32 seq, u32 flags,
+				       struct sk_buff *skb, u8 cmd)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(skb, portid, seq, &ioam6_genl_family, flags, cmd);
+	if (!hdr)
+		return -ENOMEM;
+
+	if (nla_put_u32(skb, IOAM6_ATTR_SC_ID, sc->id) ||
+	    nla_put(skb, IOAM6_ATTR_SC_DATA, sc->len, sc->data) ||
+	    (sc->ns && nla_put_u16(skb, IOAM6_ATTR_NS_ID,
+				   be16_to_cpu(sc->ns->id))))
+		goto nla_put_failure;
+
+	genlmsg_end(skb, hdr);
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(skb, hdr);
+	return -EMSGSIZE;
+}
+
+static int ioam6_genl_dumpsc_start(struct netlink_callback *cb)
+{
+	struct ioam6_pernet_data *nsdata = ioam6_pernet(sock_net(cb->skb->sk));
+	struct rhashtable_iter *iter = (struct rhashtable_iter *)cb->args[0];
+
+	if (!iter) {
+		iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+		if (!iter)
+			return -ENOMEM;
+
+		cb->args[0] = (long)iter;
+	}
+
+	rhashtable_walk_enter(&nsdata->schemas, iter);
+
+	return 0;
+}
+
+static int ioam6_genl_dumpsc_done(struct netlink_callback *cb)
+{
+	struct rhashtable_iter *iter = (struct rhashtable_iter *)cb->args[0];
+
+	rhashtable_walk_exit(iter);
+	kfree(iter);
+
+	return 0;
+}
+
+static int ioam6_genl_dumpsc(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct rhashtable_iter *iter;
+	struct ioam6_schema *sc;
+	int err;
+
+	iter = (struct rhashtable_iter *)cb->args[0];
+	rhashtable_walk_start(iter);
+
+	for (;;) {
+		sc = rhashtable_walk_next(iter);
+
+		if (IS_ERR(sc)) {
+			if (PTR_ERR(sc) == -EAGAIN)
+				continue;
+			err = PTR_ERR(sc);
+			goto done;
+		} else if (!sc) {
+			break;
+		}
+
+		err = __ioam6_genl_dumpsc_element(sc,
+						  NETLINK_CB(cb->skb).portid,
+						  cb->nlh->nlmsg_seq,
+						  NLM_F_MULTI,
+						  skb,
+						  IOAM6_CMD_DUMP_SCHEMAS);
+		if (err)
+			goto done;
+	}
+
+	err = skb->len;
+
+done:
+	rhashtable_walk_stop(iter);
+	return err;
+}
+
+static int ioam6_genl_ns_set_schema(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ioam6_pernet_data *nsdata;
+	struct ioam6_namespace *ns;
+	struct ioam6_schema *sc;
+	__be16 ns_id;
+	int err = 0;
+	u32 sc_id;
+
+	if (!info->attrs[IOAM6_ATTR_NS_ID] ||
+	    (!info->attrs[IOAM6_ATTR_SC_ID] &&
+	     !info->attrs[IOAM6_ATTR_SC_NONE]))
+		return -EINVAL;
+
+	ns_id = cpu_to_be16(nla_get_u16(info->attrs[IOAM6_ATTR_NS_ID]));
+	nsdata = ioam6_pernet(genl_info_net(info));
+
+	mutex_lock(&nsdata->lock);
+
+	ns = rhashtable_lookup_fast(&nsdata->namespaces, &ns_id, rht_ns_params);
+	if (!ns) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
+
+	if (info->attrs[IOAM6_ATTR_SC_NONE]) {
+		sc = NULL;
+	} else {
+		sc_id = nla_get_u32(info->attrs[IOAM6_ATTR_SC_ID]);
+		sc = rhashtable_lookup_fast(&nsdata->schemas, &sc_id,
+					    rht_sc_params);
+		if (!sc) {
+			err = -ENOENT;
+			goto out_unlock;
+		}
+	}
+
+	if (ns->schema)
+		ns->schema->ns = NULL;
+	ns->schema = sc;
+
+	if (sc) {
+		if (sc->ns)
+			sc->ns->schema = NULL;
+		sc->ns = ns;
+	}
+
+out_unlock:
+	mutex_unlock(&nsdata->lock);
+	return err;
+}
+
+static const struct genl_ops ioam6_genl_ops[] = {
+	{
+		.cmd	= IOAM6_CMD_ADD_NAMESPACE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit	= ioam6_genl_addns,
+		.flags	= GENL_ADMIN_PERM,
+	},
+	{
+		.cmd	= IOAM6_CMD_DEL_NAMESPACE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit	= ioam6_genl_delns,
+		.flags	= GENL_ADMIN_PERM,
+	},
+	{
+		.cmd	= IOAM6_CMD_DUMP_NAMESPACES,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.start	= ioam6_genl_dumpns_start,
+		.dumpit	= ioam6_genl_dumpns,
+		.done	= ioam6_genl_dumpns_done,
+		.flags	= GENL_ADMIN_PERM,
+	},
+	{
+		.cmd	= IOAM6_CMD_ADD_SCHEMA,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit	= ioam6_genl_addsc,
+		.flags	= GENL_ADMIN_PERM,
+	},
+	{
+		.cmd	= IOAM6_CMD_DEL_SCHEMA,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit	= ioam6_genl_delsc,
+		.flags	= GENL_ADMIN_PERM,
+	},
+	{
+		.cmd	= IOAM6_CMD_DUMP_SCHEMAS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.start	= ioam6_genl_dumpsc_start,
+		.dumpit	= ioam6_genl_dumpsc,
+		.done	= ioam6_genl_dumpsc_done,
+		.flags	= GENL_ADMIN_PERM,
+	},
+	{
+		.cmd	= IOAM6_CMD_NS_SET_SCHEMA,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit	= ioam6_genl_ns_set_schema,
+		.flags	= GENL_ADMIN_PERM,
+	},
+};
+
+static struct genl_family ioam6_genl_family __ro_after_init = {
+	.hdrsize	= 0,
+	.name		= IOAM6_GENL_NAME,
+	.version	= IOAM6_GENL_VERSION,
+	.maxattr	= IOAM6_ATTR_MAX,
+	.policy		= ioam6_genl_policy,
+	.netnsok	= true,
+	.parallel_ops	= true,
+	.ops		= ioam6_genl_ops,
+	.n_ops		= ARRAY_SIZE(ioam6_genl_ops),
+	.module		= THIS_MODULE,
+};
+
 struct ioam6_namespace *ioam6_namespace(struct net *net, __be16 id)
 {
 	struct ioam6_pernet_data *nsdata = ioam6_pernet(net);
@@ -343,15 +836,24 @@ static struct pernet_operations ioam6_net_ops = {
 int __init ioam6_init(void)
 {
 	int err = register_pernet_subsys(&ioam6_net_ops);
+	if (err)
+		goto out;
 
+	err = genl_register_family(&ioam6_genl_family);
 	if (err)
-		return err;
+		goto out_unregister_pernet_subsys;
 
 	pr_info("In-situ OAM (IOAM) with IPv6\n");
-	return 0;
+
+out:
+	return err;
+out_unregister_pernet_subsys:
+	unregister_pernet_subsys(&ioam6_net_ops);
+	goto out;
 }
 
 void ioam6_exit(void)
 {
+	genl_unregister_family(&ioam6_genl_family);
 	unregister_pernet_subsys(&ioam6_net_ops);
 }
-- 
2.17.1

