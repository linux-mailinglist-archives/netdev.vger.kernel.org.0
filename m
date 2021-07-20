Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16EB13D0259
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 21:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhGTTNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 15:13:22 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:37761 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbhGTTNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 15:13:10 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jul 2021 15:13:06 EDT
Received: from localhost.localdomain (148.24-240-81.adsl-dyn.isp.belgacom.be [81.240.24.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 533A6200F83E;
        Tue, 20 Jul 2021 21:43:26 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 533A6200F83E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1626810206;
        bh=zRl/iPpmyaZ6NpRT8v7SCyzjlN7UTTBxU5o2k3fuQIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hd4wEiNF8puzS11x5GFo5Y8bnUzvH98lkOEjw+3qINbJXeU0tcgXs/TOC2Dkq5Ex
         NSbupTYBRvUOz1l25f6+2FJCqPX1/0/OJ9C1UzXz/0ndaA1qsTZo/msXxG5NakDxZ8
         DH6igNRFzrof93s3wj9R1kXLj6jdumPjY3V6k0yCQX0LAK3QnuhPQVzw/BaYMpFNpg
         5MfCEAzPFbK4MdqLskOyK9uVmkbs7gv81Wy35G4WeOR+trVxEkvSo192hVYODBkoYQ
         xKP0jU6H/nYvEKZrJeeDoyx8seUzNB3nuxuK2/HKFyV/1mnno3AFGWp4hASWYCQf7V
         m445cV3z3NvPQ==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, tom@herbertland.com, justin.iurman@uliege.be
Subject: [PATCH net-next v5 3/6] ipv6: ioam: IOAM Generic Netlink API
Date:   Tue, 20 Jul 2021 21:42:58 +0200
Message-Id: <20210720194301.23243-4-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210720194301.23243-1-justin.iurman@uliege.be>
References: <20210720194301.23243-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Generic Netlink commands to allow userspace to configure IOAM
namespaces and schemas. The target is iproute2 and the patch is ready.
It will be posted as soon as this patchset is merged. Here is an overview:

$ ip ioam
Usage:	ip ioam { COMMAND | help }
	ip ioam namespace show
	ip ioam namespace add ID [ data DATA32 ] [ wide DATA64 ]
	ip ioam namespace del ID
	ip ioam schema show
	ip ioam schema add ID DATA
	ip ioam schema del ID
	ip ioam namespace set ID schema { ID | none }

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/linux/ioam6_genl.h      |  13 +
 include/uapi/linux/ioam6_genl.h |  52 +++
 net/ipv6/ioam6.c                | 561 +++++++++++++++++++++++++++++++-
 3 files changed, 624 insertions(+), 2 deletions(-)
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
index 000000000000..ca4b22833754
--- /dev/null
+++ b/include/uapi/linux/ioam6_genl.h
@@ -0,0 +1,52 @@
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
+	IOAM6_ATTR_NS_DATA,	/* u32 */
+	IOAM6_ATTR_NS_DATA_WIDE,/* u64 */
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
+
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
+
+#define IOAM6_CMD_MAX (__IOAM6_CMD_MAX - 1)
+
+#endif /* _UAPI_LINUX_IOAM6_GENL_H */
diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index ba629e1b9408..ba59671f32b8 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -11,9 +11,11 @@
 #include <linux/kernel.h>
 #include <linux/net.h>
 #include <linux/ioam6.h>
+#include <linux/ioam6_genl.h>
 #include <linux/rhashtable.h>
 
 #include <net/addrconf.h>
+#include <net/genetlink.h>
 #include <net/ioam6.h>
 
 static void ioam6_ns_release(struct ioam6_namespace *ns)
@@ -72,6 +74,552 @@ static const struct rhashtable_params rht_sc_params = {
 	.obj_cmpfn		= ioam6_sc_cmpfn,
 };
 
+static struct genl_family ioam6_genl_family;
+
+static const struct nla_policy ioam6_genl_policy_addns[] = {
+	[IOAM6_ATTR_NS_ID]	= { .type = NLA_U16 },
+	[IOAM6_ATTR_NS_DATA]	= { .type = NLA_U32 },
+	[IOAM6_ATTR_NS_DATA_WIDE] = { .type = NLA_U64 },
+};
+
+static const struct nla_policy ioam6_genl_policy_delns[] = {
+	[IOAM6_ATTR_NS_ID]	= { .type = NLA_U16 },
+};
+
+static const struct nla_policy ioam6_genl_policy_addsc[] = {
+	[IOAM6_ATTR_SC_ID]	= { .type = NLA_U32 },
+	[IOAM6_ATTR_SC_DATA]	= { .type = NLA_BINARY,
+				    .len = IOAM6_MAX_SCHEMA_DATA_LEN },
+};
+
+static const struct nla_policy ioam6_genl_policy_delsc[] = {
+	[IOAM6_ATTR_SC_ID]	= { .type = NLA_U32 },
+};
+
+static const struct nla_policy ioam6_genl_policy_ns_sc[] = {
+	[IOAM6_ATTR_NS_ID]	= { .type = NLA_U16 },
+	[IOAM6_ATTR_SC_ID]	= { .type = NLA_U32 },
+	[IOAM6_ATTR_SC_NONE]	= { .type = NLA_FLAG },
+};
+
+static int ioam6_genl_addns(struct sk_buff *skb, struct genl_info *info)
+{
+	struct ioam6_pernet_data *nsdata;
+	struct ioam6_namespace *ns;
+	u64 data64;
+	u32 data32;
+	__be16 id;
+	int err;
+
+	if (!info->attrs[IOAM6_ATTR_NS_ID])
+		return -EINVAL;
+
+	id = cpu_to_be16(nla_get_u16(info->attrs[IOAM6_ATTR_NS_ID]));
+	nsdata = ioam6_pernet(genl_info_net(info));
+
+	mutex_lock(&nsdata->lock);
+
+	ns = rhashtable_lookup_fast(&nsdata->namespaces, &id, rht_ns_params);
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
+	ns->id = id;
+
+	if (!info->attrs[IOAM6_ATTR_NS_DATA])
+		data32 = IOAM6_U32_UNAVAILABLE;
+	else
+		data32 = nla_get_u32(info->attrs[IOAM6_ATTR_NS_DATA]);
+
+	if (!info->attrs[IOAM6_ATTR_NS_DATA_WIDE])
+		data64 = IOAM6_U64_UNAVAILABLE;
+	else
+		data64 = nla_get_u64(info->attrs[IOAM6_ATTR_NS_DATA_WIDE]);
+
+	ns->data = cpu_to_be32(data32);
+	ns->data_wide = cpu_to_be64(data64);
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
+	__be16 id;
+	int err;
+
+	if (!info->attrs[IOAM6_ATTR_NS_ID])
+		return -EINVAL;
+
+	id = cpu_to_be16(nla_get_u16(info->attrs[IOAM6_ATTR_NS_ID]));
+	nsdata = ioam6_pernet(genl_info_net(info));
+
+	mutex_lock(&nsdata->lock);
+
+	ns = rhashtable_lookup_fast(&nsdata->namespaces, &id, rht_ns_params);
+	if (!ns) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
+
+	sc = rcu_dereference_protected(ns->schema,
+				       lockdep_is_held(&nsdata->lock));
+
+	err = rhashtable_remove_fast(&nsdata->namespaces, &ns->head,
+				     rht_ns_params);
+	if (err)
+		goto out_unlock;
+
+	if (sc)
+		rcu_assign_pointer(sc->ns, NULL);
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
+	struct ioam6_schema *sc;
+	u64 data64;
+	u32 data32;
+	void *hdr;
+
+	hdr = genlmsg_put(skb, portid, seq, &ioam6_genl_family, flags, cmd);
+	if (!hdr)
+		return -ENOMEM;
+
+	data32 = be32_to_cpu(ns->data);
+	data64 = be64_to_cpu(ns->data_wide);
+
+	if (nla_put_u16(skb, IOAM6_ATTR_NS_ID, be16_to_cpu(ns->id)) ||
+	    (data32 != IOAM6_U32_UNAVAILABLE &&
+	     nla_put_u32(skb, IOAM6_ATTR_NS_DATA, data32)) ||
+	    (data64 != IOAM6_U64_UNAVAILABLE &&
+	     nla_put_u64_64bit(skb, IOAM6_ATTR_NS_DATA_WIDE,
+			       data64, IOAM6_ATTR_PAD)))
+		goto nla_put_failure;
+
+	rcu_read_lock();
+
+	sc = rcu_dereference(ns->schema);
+	if (sc && nla_put_u32(skb, IOAM6_ATTR_SC_ID, sc->id)) {
+		rcu_read_unlock();
+		goto nla_put_failure;
+	}
+
+	rcu_read_unlock();
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
+	u32 id;
+
+	if (!info->attrs[IOAM6_ATTR_SC_ID] || !info->attrs[IOAM6_ATTR_SC_DATA])
+		return -EINVAL;
+
+	id = nla_get_u32(info->attrs[IOAM6_ATTR_SC_ID]);
+	nsdata = ioam6_pernet(genl_info_net(info));
+
+	mutex_lock(&nsdata->lock);
+
+	sc = rhashtable_lookup_fast(&nsdata->schemas, &id, rht_sc_params);
+	if (sc) {
+		err = -EEXIST;
+		goto out_unlock;
+	}
+
+	len = nla_len(info->attrs[IOAM6_ATTR_SC_DATA]);
+	len_aligned = ALIGN(len, 4);
+
+	sc = kzalloc(sizeof(*sc) + len_aligned, GFP_KERNEL);
+	if (!sc) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
+
+	sc->id = id;
+	sc->len = len_aligned;
+	sc->hdr = cpu_to_be32(sc->id | ((u8)(sc->len / 4) << 24));
+	nla_memcpy(sc->data, info->attrs[IOAM6_ATTR_SC_DATA], len);
+
+	err = rhashtable_lookup_insert_fast(&nsdata->schemas, &sc->head,
+					    rht_sc_params);
+	if (err)
+		goto free_sc;
+
+out_unlock:
+	mutex_unlock(&nsdata->lock);
+	return err;
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
+	int err;
+	u32 id;
+
+	if (!info->attrs[IOAM6_ATTR_SC_ID])
+		return -EINVAL;
+
+	id = nla_get_u32(info->attrs[IOAM6_ATTR_SC_ID]);
+	nsdata = ioam6_pernet(genl_info_net(info));
+
+	mutex_lock(&nsdata->lock);
+
+	sc = rhashtable_lookup_fast(&nsdata->schemas, &id, rht_sc_params);
+	if (!sc) {
+		err = -ENOENT;
+		goto out_unlock;
+	}
+
+	ns = rcu_dereference_protected(sc->ns, lockdep_is_held(&nsdata->lock));
+
+	err = rhashtable_remove_fast(&nsdata->schemas, &sc->head,
+				     rht_sc_params);
+	if (err)
+		goto out_unlock;
+
+	if (ns)
+		rcu_assign_pointer(ns->schema, NULL);
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
+	struct ioam6_namespace *ns;
+	void *hdr;
+
+	hdr = genlmsg_put(skb, portid, seq, &ioam6_genl_family, flags, cmd);
+	if (!hdr)
+		return -ENOMEM;
+
+	if (nla_put_u32(skb, IOAM6_ATTR_SC_ID, sc->id) ||
+	    nla_put(skb, IOAM6_ATTR_SC_DATA, sc->len, sc->data))
+		goto nla_put_failure;
+
+	rcu_read_lock();
+
+	ns = rcu_dereference(sc->ns);
+	if (ns && nla_put_u16(skb, IOAM6_ATTR_NS_ID, be16_to_cpu(ns->id))) {
+		rcu_read_unlock();
+		goto nla_put_failure;
+	}
+
+	rcu_read_unlock();
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
+	struct ioam6_namespace *ns, *ns_ref;
+	struct ioam6_schema *sc, *sc_ref;
+	struct ioam6_pernet_data *nsdata;
+	__be16 ns_id;
+	u32 sc_id;
+	int err;
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
+	sc_ref = rcu_dereference_protected(ns->schema,
+					   lockdep_is_held(&nsdata->lock));
+	if (sc_ref)
+		rcu_assign_pointer(sc_ref->ns, NULL);
+	rcu_assign_pointer(ns->schema, sc);
+
+	if (sc) {
+		ns_ref = rcu_dereference_protected(sc->ns,
+						   lockdep_is_held(&nsdata->lock));
+		if (ns_ref)
+			rcu_assign_pointer(ns_ref->schema, NULL);
+		rcu_assign_pointer(sc->ns, ns);
+	}
+
+	err = 0;
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
+		.policy	= ioam6_genl_policy_addns,
+		.maxattr = ARRAY_SIZE(ioam6_genl_policy_addns) - 1,
+	},
+	{
+		.cmd	= IOAM6_CMD_DEL_NAMESPACE,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit	= ioam6_genl_delns,
+		.flags	= GENL_ADMIN_PERM,
+		.policy	= ioam6_genl_policy_delns,
+		.maxattr = ARRAY_SIZE(ioam6_genl_policy_delns) - 1,
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
+		.policy	= ioam6_genl_policy_addsc,
+		.maxattr = ARRAY_SIZE(ioam6_genl_policy_addsc) - 1,
+	},
+	{
+		.cmd	= IOAM6_CMD_DEL_SCHEMA,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.doit	= ioam6_genl_delsc,
+		.flags	= GENL_ADMIN_PERM,
+		.policy	= ioam6_genl_policy_delsc,
+		.maxattr = ARRAY_SIZE(ioam6_genl_policy_delsc) - 1,
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
+		.policy	= ioam6_genl_policy_ns_sc,
+		.maxattr = ARRAY_SIZE(ioam6_genl_policy_ns_sc) - 1,
+	},
+};
+
+static struct genl_family ioam6_genl_family __ro_after_init = {
+	.name		= IOAM6_GENL_NAME,
+	.version	= IOAM6_GENL_VERSION,
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
@@ -319,15 +867,24 @@ static struct pernet_operations ioam6_net_ops = {
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
2.25.1

