Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7621B207C3F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 21:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406226AbgFXTdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 15:33:35 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:46310 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406142AbgFXTdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 15:33:35 -0400
Received: from ubuntu18.lan (unknown [109.129.49.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id B26F1200CD0C;
        Wed, 24 Jun 2020 21:24:25 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be B26F1200CD0C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1593026665;
        bh=7/8yK5qvyAR/dS4O9L+Ejjm9LBqSj6ebNOZjo2vRzM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efA0m9sdfVp5MzNh34CNdn42MPOapOg/PsmUB4DOkz/Ze6PFf5jPKDx6bFi5w152L
         4Q7Sr5rSEd3M96zGBdWSaVAgxj/vJqolhjKcgSeR9dNsaxf40zG/fn0abU6D1NQwji
         z/s3YlS1S8KgFK222MJPLL573wBNlpZQS4jXrv14lJKPxiYT20wK58eGNgDCzUQ7i2
         iHqlG0bu7pjPbJmTeG9tyq5a+Ss7Bm6/V0Zs5J1fUO9qo3hhYr1JALvZqGIEvx8RlP
         s7CG4ETQlaf3ACqqBRuM1JvwBX8nZ52FjDaA7c9pHwUBFhIJ4QSeww1g61qr+uq26l
         uSc3FoIC5AHAQ==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, justin.iurman@uliege.be
Subject: [PATCH net-next 4/5] ipv6: ioam: Generic Netlink to configure IOAM
Date:   Wed, 24 Jun 2020 21:23:09 +0200
Message-Id: <20200624192310.16923-5-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200624192310.16923-1-justin.iurman@uliege.be>
References: <20200624192310.16923-1-justin.iurman@uliege.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Generic Netlink commands to allow userspace to configure IOAM
namespaces and schemas. The target is iproute2 and the patch is ready.
It will be posted as soon as this patchset is merged. Here is a taste:

$ sudo ip ioam
Usage: ip ioam { namespace | schema } { show | del ID }
               schema add ID DATA
	       namespace add ID [ DATA ] [ POP ]
               namespace set ID schema { ID | none }
POP := { true | false }

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/linux/ioam6.h      |   7 +
 include/uapi/linux/ioam6.h |  43 +++
 net/ipv6/ioam6.c           | 519 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 566 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/ioam6.h
 create mode 100644 include/uapi/linux/ioam6.h

diff --git a/include/linux/ioam6.h b/include/linux/ioam6.h
new file mode 100644
index 000000000000..156223095e57
--- /dev/null
+++ b/include/linux/ioam6.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_IOAM6_H
+#define _LINUX_IOAM6_H
+
+#include <uapi/linux/ioam6.h>
+
+#endif
diff --git a/include/uapi/linux/ioam6.h b/include/uapi/linux/ioam6.h
new file mode 100644
index 000000000000..d2be5f820dc5
--- /dev/null
+++ b/include/uapi/linux/ioam6.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_IOAM6_H
+#define _UAPI_LINUX_IOAM6_H
+
+#define IOAM6_GENL_NAME "IOAM6"
+#define IOAM6_GENL_VERSION 0x1
+
+enum {
+	IOAM6_ATTR_UNSPEC,
+
+	IOAM6_ATTR_NS_ID,	/* u16 */
+	IOAM6_ATTR_NS_DATA,	/* u64 */
+	IOAM6_ATTR_NS_POP,	/* Flag */
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
+#endif
diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 406aa78eb504..e414e915bf1e 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -11,8 +11,10 @@
 #include <linux/kernel.h>
 #include <linux/net.h>
 #include <linux/rhashtable.h>
+#include <linux/ioam6.h>
 
 #include <net/addrconf.h>
+#include <net/genetlink.h>
 #include <net/ioam6.h>
 
 static inline void ioam6_ns_release(struct ioam6_namespace *ns)
@@ -71,6 +73,507 @@ static const struct rhashtable_params rht_sc_params = {
 	.obj_cmpfn		= ioam6_sc_cmpfn,
 };
 
+static struct genl_family ioam6_genl_family;
+
+static const struct nla_policy ioam6_genl_policy[IOAM6_ATTR_MAX + 1] = {
+	[IOAM6_ATTR_NS_ID]	= { .type = NLA_U16 },
+	[IOAM6_ATTR_NS_DATA]	= { .type = NLA_U64 },
+	[IOAM6_ATTR_NS_POP]	= { .type = NLA_FLAG },
+	[IOAM6_ATTR_SC_ID]	= { .type = NLA_U32 },
+	[IOAM6_ATTR_SC_DATA]	= { .type = NLA_BINARY,
+				    .len = IOAM6_MAX_SCHEMA_DATA_LEN },
+	[IOAM6_ATTR_SC_NONE]	= { .type = NLA_FLAG },
+};
+
+static int ioam6_genl_addns(struct sk_buff *skb, struct genl_info *info)
+{
+	struct net *net = genl_info_net(info);
+	struct ioam6_pernet_data *nsdata;
+	struct ioam6_namespace *ns;
+	__be16 ns_id;
+	int err;
+
+	if (!info->attrs[IOAM6_ATTR_NS_ID])
+		return -EINVAL;
+
+	ns_id = cpu_to_be16(nla_get_u16(info->attrs[IOAM6_ATTR_NS_ID]));
+	nsdata = ioam6_pernet(net);
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
+	ns->remove_tlv = info->attrs[IOAM6_ATTR_NS_POP] ? true : false;
+
+	if (!info->attrs[IOAM6_ATTR_NS_DATA]) {
+		ns->data = cpu_to_be64(IOAM6_EMPTY_FIELD_u64);
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
+	struct net *net = genl_info_net(info);
+	struct ioam6_pernet_data *nsdata;
+	struct ioam6_namespace *ns;
+	__be16 ns_id;
+	int err;
+
+	if (!info->attrs[IOAM6_ATTR_NS_ID])
+		return -EINVAL;
+
+	ns_id = cpu_to_be16(nla_get_u16(info->attrs[IOAM6_ATTR_NS_ID]));
+	nsdata = ioam6_pernet(net);
+
+	mutex_lock(&nsdata->lock);
+
+	ns = rhashtable_lookup_fast(&nsdata->namespaces, &ns_id, rht_ns_params);
+	if (!ns) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
+
+	if (ns->schema)
+		ns->schema->ns = NULL;
+
+	err = rhashtable_remove_fast(&nsdata->namespaces, &ns->head,
+				     rht_ns_params);
+	if (err) {
+		ns->schema->ns = ns;
+		goto out_unlock;
+	}
+
+	ioam6_ns_release(ns);
+
+out_unlock:
+	mutex_unlock(&nsdata->lock);
+	return err;
+}
+
+static int __ioam6_genl_dumpns_element(struct ioam6_namespace *ns,
+				       u32 portid, u32 seq, u32 flags,
+				       struct sk_buff *skb, u8 cmd)
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
+	    (data != IOAM6_EMPTY_FIELD_u64 &&
+	     nla_put_u64_64bit(skb, IOAM6_ATTR_NS_DATA, data, IOAM6_ATTR_PAD)) ||
+	    (ns->remove_tlv && nla_put_flag(skb, IOAM6_ATTR_NS_POP)) ||
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
+	struct net *net = sock_net(cb->skb->sk);
+	struct ioam6_pernet_data *nsdata;
+	struct rhashtable_iter *iter;
+
+	nsdata = ioam6_pernet(net);
+	iter = (struct rhashtable_iter *)cb->args[0];
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
+	struct rhashtable_iter *iter = (struct rhashtable_iter *)cb->args[0];
+	struct ioam6_namespace *ns;
+	int err;
+
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
+	struct net *net = genl_info_net(info);
+	struct ioam6_pernet_data *nsdata;
+	struct ioam6_schema *sc;
+	int len, pad, err;
+	u32 sc_id;
+
+	if (!info->attrs[IOAM6_ATTR_SC_ID] || !info->attrs[IOAM6_ATTR_SC_DATA])
+		return -EINVAL;
+
+	sc_id = nla_get_u32(info->attrs[IOAM6_ATTR_SC_ID]);
+	nsdata = ioam6_pernet(net);
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
+	pad = (4 - (len % 4)) % 4;
+
+	sc->data = kzalloc(len + pad, GFP_KERNEL);
+	if (!sc->data) {
+		err = -ENOMEM;
+		goto free_sc;
+	}
+
+	sc->id = sc_id;
+	sc->len = len + pad;
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
+	struct net *net = genl_info_net(info);
+	struct ioam6_pernet_data *nsdata;
+	struct ioam6_schema *sc;
+	u32 sc_id;
+	int err;
+
+	if (!info->attrs[IOAM6_ATTR_SC_ID])
+		return -EINVAL;
+
+	sc_id = nla_get_u32(info->attrs[IOAM6_ATTR_SC_ID]);
+	nsdata = ioam6_pernet(net);
+
+	mutex_lock(&nsdata->lock);
+
+	sc = rhashtable_lookup_fast(&nsdata->schemas, &sc_id, rht_sc_params);
+	if (!sc) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
+
+	if (sc->ns)
+		sc->ns->schema = NULL;
+
+	err = rhashtable_remove_fast(&nsdata->schemas, &sc->head,
+				     rht_sc_params);
+	if (err) {
+		sc->ns->schema = sc;
+		goto out_unlock;
+	}
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
+	struct net *net = sock_net(cb->skb->sk);
+	struct ioam6_pernet_data *nsdata;
+	struct rhashtable_iter *iter;
+
+	nsdata = ioam6_pernet(net);
+	iter = (struct rhashtable_iter *)cb->args[0];
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
+	struct rhashtable_iter *iter = (struct rhashtable_iter *)cb->args[0];
+	struct ioam6_schema *sc;
+	int err;
+
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
+	struct net *net = genl_info_net(info);
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
+	nsdata = ioam6_pernet(net);
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
@@ -311,16 +814,26 @@ static struct pernet_operations ioam6_net_ops = {
 
 int __init ioam6_init(void)
 {
-	int err = register_pernet_subsys(&ioam6_net_ops);
+	int err = genl_register_family(&ioam6_genl_family);
+
+	if (err)
+		goto out;
 
+	err = register_pernet_subsys(&ioam6_net_ops);
 	if (err)
-		return err;
+		goto out_unregister_genl;
 
 	pr_info("In-situ OAM (IOAM) with IPv6\n");
-	return 0;
+
+out:
+	return err;
+out_unregister_genl:
+	genl_unregister_family(&ioam6_genl_family);
+	goto out;
 }
 
 void ioam6_exit(void)
 {
 	unregister_pernet_subsys(&ioam6_net_ops);
+	genl_unregister_family(&ioam6_genl_family);
 }
-- 
2.17.1

