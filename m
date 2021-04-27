Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A0636CC89
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 22:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239029AbhD0Uol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 16:44:41 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54322 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238967AbhD0Uoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 16:44:39 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8EA856413E;
        Tue, 27 Apr 2021 22:43:17 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 5/7] netfilter: nftables: add catch-all set element support
Date:   Tue, 27 Apr 2021 22:43:43 +0200
Message-Id: <20210427204345.22043-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210427204345.22043-1-pablo@netfilter.org>
References: <20210427204345.22043-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the set infrastructure to add a special catch-all set
element. If the lookup fails to find an element (or range) in the set,
then the catch-all element is selected. Users can specify a mapping,
expression(s) and timeout to be attached to the catch-all element.

This patch adds a catchall list to the set, this list might contain more
than one single catch-all element (e.g. in case that the catch-all
element is removed and a new one is added in the same transaction).
However, most of the time, there will be either one element or no
elements at all in this list.

The catch-all element is identified via NFT_SET_ELEM_CATCHALL flag and
such special element has no NFTA_SET_ELEM_KEY attribute. There is a new
nft_set_elem_catchall object that stores a reference to the dummy
catch-all element (catchall->elem) whose layout is the same of the set
element type to reuse the existing set element codebase.

The set size does not apply to the catch-all element, users can define a
catch-all element even if the set is full.

The check for valid set element flags hava been updates to report
EOPNOTSUPP in case userspace requests flags that are not supported when
using new userspace nftables and old kernel.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |   5 +
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/nf_tables_api.c            | 480 ++++++++++++++++++++---
 net/netfilter/nft_lookup.c               |  12 +-
 net/netfilter/nft_objref.c               |  11 +-
 net/netfilter/nft_set_hash.c             |   6 +
 net/netfilter/nft_set_pipapo.c           |   6 +-
 net/netfilter/nft_set_rbtree.c           |   6 +
 8 files changed, 465 insertions(+), 63 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index eb708b77c4a5..27eeb613bb4e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -497,6 +497,7 @@ struct nft_set {
 	u8				dlen;
 	u8				num_exprs;
 	struct nft_expr			*exprs[NFT_SET_EXPR_MAX];
+	struct list_head		catchall_list;
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(u64))));
 };
@@ -522,6 +523,10 @@ struct nft_set *nft_set_lookup_global(const struct net *net,
 				      const struct nlattr *nla_set_id,
 				      u8 genmask);
 
+struct nft_set_ext *nft_set_catchall_lookup(const struct net *net,
+					    const struct nft_set *set);
+void *nft_set_catchall_gc(const struct nft_set *set);
+
 static inline unsigned long nft_set_gc_interval(const struct nft_set *set)
 {
 	return set->gc_int ? msecs_to_jiffies(set->gc_int) : HZ;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 467365ed59a7..1fb4ca18ffbb 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -398,9 +398,11 @@ enum nft_set_attributes {
  * enum nft_set_elem_flags - nf_tables set element flags
  *
  * @NFT_SET_ELEM_INTERVAL_END: element ends the previous interval
+ * @NFT_SET_ELEM_CATCHALL: special catch-all element
  */
 enum nft_set_elem_flags {
 	NFT_SET_ELEM_INTERVAL_END	= 0x1,
+	NFT_SET_ELEM_CATCHALL		= 0x2,
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index faf0424375e8..0b7fe0a902ff 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4389,6 +4389,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	INIT_LIST_HEAD(&set->bindings);
+	INIT_LIST_HEAD(&set->catchall_list);
 	set->table = table;
 	write_pnet(&set->net, net);
 	set->ops   = ops;
@@ -4434,6 +4435,24 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	return err;
 }
 
+struct nft_set_elem_catchall {
+	struct list_head	list;
+	struct rcu_head		rcu;
+	void			*elem;
+};
+
+static void nft_set_catchall_destroy(const struct nft_ctx *ctx,
+				     struct nft_set *set)
+{
+	struct nft_set_elem_catchall *catchall;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+		list_del_rcu(&catchall->list);
+		nft_set_elem_destroy(set, catchall->elem, true);
+		kfree_rcu(catchall);
+	}
+}
+
 static void nft_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	int i;
@@ -4445,6 +4464,7 @@ static void nft_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
 		nft_expr_destroy(ctx, set->exprs[i]);
 
 	set->ops->destroy(set);
+	nft_set_catchall_destroy(ctx, set);
 	kfree(set->name);
 	kvfree(set);
 }
@@ -4521,6 +4541,29 @@ static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
 	return nft_setelem_data_validate(ctx, set, elem);
 }
 
+static int nft_set_catchall_bind_check(const struct nft_ctx *ctx,
+				       struct nft_set *set)
+{
+	u8 genmask = nft_genmask_next(ctx->net);
+	struct nft_set_elem_catchall *catchall;
+	struct nft_set_elem elem;
+	struct nft_set_ext *ext;
+	int ret = 0;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_set_elem_active(ext, genmask))
+			continue;
+
+		elem.priv = catchall->elem;
+		ret = nft_setelem_data_validate(ctx, set, &elem);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
 int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding)
 {
@@ -4550,6 +4593,9 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		iter.fn		= nf_tables_bind_check_setelem;
 
 		set->ops->walk(ctx, set, &iter);
+		if (!iter.err)
+			iter.err = nft_set_catchall_bind_check(ctx, set);
+
 		if (iter.err < 0)
 			return iter.err;
 	}
@@ -4736,7 +4782,8 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 	if (nest == NULL)
 		goto nla_put_failure;
 
-	if (nft_data_dump(skb, NFTA_SET_ELEM_KEY, nft_set_ext_key(ext),
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY) &&
+	    nft_data_dump(skb, NFTA_SET_ELEM_KEY, nft_set_ext_key(ext),
 			  NFT_DATA_VALUE, set->klen) < 0)
 		goto nla_put_failure;
 
@@ -4825,6 +4872,29 @@ struct nft_set_dump_ctx {
 	struct nft_ctx		ctx;
 };
 
+static int nft_set_catchall_dump(struct net *net, struct sk_buff *skb,
+				 const struct nft_set *set)
+{
+	struct nft_set_elem_catchall *catchall;
+	u8 genmask = nft_genmask_cur(net);
+	struct nft_set_elem elem;
+	struct nft_set_ext *ext;
+	int ret = 0;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_set_elem_active(ext, genmask) ||
+		    nft_set_elem_expired(ext))
+			continue;
+
+		elem.priv = catchall->elem;
+		ret = nf_tables_fill_setelem(skb, set, &elem);
+		break;
+	}
+
+	return ret;
+}
+
 static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct nft_set_dump_ctx *dump_ctx = cb->data;
@@ -4889,6 +4959,9 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	args.iter.err		= 0;
 	args.iter.fn		= nf_tables_dump_setelem;
 	set->ops->walk(&dump_ctx->ctx, set, &args.iter);
+
+	if (!args.iter.err && args.iter.count == cb->args[0])
+		args.iter.err = nft_set_catchall_dump(net, skb, set);
 	rcu_read_unlock();
 
 	nla_nest_end(skb, nest);
@@ -4968,8 +5041,8 @@ static int nft_setelem_parse_flags(const struct nft_set *set,
 		return 0;
 
 	*flags = ntohl(nla_get_be32(attr));
-	if (*flags & ~NFT_SET_ELEM_INTERVAL_END)
-		return -EINVAL;
+	if (*flags & ~(NFT_SET_ELEM_INTERVAL_END | NFT_SET_ELEM_CATCHALL))
+		return -EOPNOTSUPP;
 	if (!(set->flags & NFT_SET_INTERVAL) &&
 	    *flags & NFT_SET_ELEM_INTERVAL_END)
 		return -EINVAL;
@@ -5014,6 +5087,46 @@ static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 }
 
+static void *nft_setelem_catchall_get(const struct net *net,
+				      const struct nft_set *set)
+{
+	struct nft_set_elem_catchall *catchall;
+	u8 genmask = nft_genmask_cur(net);
+	struct nft_set_ext *ext;
+	void *priv = NULL;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_set_elem_active(ext, genmask) ||
+		    nft_set_elem_expired(ext))
+			continue;
+
+		priv = catchall->elem;
+		break;
+	}
+
+	return priv;
+}
+
+static int nft_setelem_get(struct nft_ctx *ctx, struct nft_set *set,
+			   struct nft_set_elem *elem, u32 flags)
+{
+	void *priv;
+
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		priv = set->ops->get(ctx->net, set, elem, flags);
+		if (IS_ERR(priv))
+			return PTR_ERR(priv);
+	} else {
+		priv = nft_setelem_catchall_get(ctx->net, set);
+		if (!priv)
+			return -ENOENT;
+	}
+	elem->priv = priv;
+
+	return 0;
+}
+
 static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr)
 {
@@ -5021,7 +5134,6 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_elem elem;
 	struct sk_buff *skb;
 	uint32_t flags = 0;
-	void *priv;
 	int err;
 
 	err = nla_parse_nested_deprecated(nla, NFTA_SET_ELEM_MAX, attr,
@@ -5029,17 +5141,19 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
-	if (!nla[NFTA_SET_ELEM_KEY])
-		return -EINVAL;
-
 	err = nft_setelem_parse_flags(set, nla[NFTA_SET_ELEM_FLAGS], &flags);
 	if (err < 0)
 		return err;
 
-	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
-				    nla[NFTA_SET_ELEM_KEY]);
-	if (err < 0)
-		return err;
+	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
+		return -EINVAL;
+
+	if (nla[NFTA_SET_ELEM_KEY]) {
+		err = nft_setelem_parse_key(ctx, set, &elem.key.val,
+					    nla[NFTA_SET_ELEM_KEY]);
+		if (err < 0)
+			return err;
+	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
 		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
@@ -5048,11 +5162,9 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	}
 
-	priv = set->ops->get(ctx->net, set, &elem, flags);
-	if (IS_ERR(priv))
-		return PTR_ERR(priv);
-
-	elem.priv = priv;
+	err = nft_setelem_get(ctx, set, &elem, flags);
+	if (err < 0)
+		return err;
 
 	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
@@ -5212,7 +5324,8 @@ void *nft_set_elem_init(const struct nft_set *set,
 	ext = nft_set_elem_ext(set, elem);
 	nft_set_ext_init(ext, tmpl);
 
-	memcpy(nft_set_ext_key(ext), key, set->klen);
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY))
+		memcpy(nft_set_ext_key(ext), key, set->klen);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
 		memcpy(nft_set_ext_key_end(ext), key_end, set->klen);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
@@ -5343,6 +5456,192 @@ static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
 	return -ENOMEM;
 }
 
+struct nft_set_ext *nft_set_catchall_lookup(const struct net *net,
+					    const struct nft_set *set)
+{
+	struct nft_set_elem_catchall *catchall;
+	u8 genmask = nft_genmask_cur(net);
+	struct nft_set_ext *ext;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (nft_set_elem_active(ext, genmask) &&
+		    !nft_set_elem_expired(ext))
+			return ext;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nft_set_catchall_lookup);
+
+void *nft_set_catchall_gc(const struct nft_set *set)
+{
+	struct nft_set_elem_catchall *catchall, *next;
+	struct nft_set_ext *ext;
+	void *elem = NULL;
+
+	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+
+		if (!nft_set_elem_expired(ext) ||
+		    nft_set_elem_mark_busy(ext))
+			continue;
+
+		elem = catchall->elem;
+		list_del_rcu(&catchall->list);
+		kfree_rcu(catchall, rcu);
+		break;
+	}
+
+	return elem;
+}
+EXPORT_SYMBOL_GPL(nft_set_catchall_gc);
+
+static int nft_setelem_catchall_insert(const struct net *net,
+				       struct nft_set *set,
+				       const struct nft_set_elem *elem,
+				       struct nft_set_ext **pext)
+{
+	struct nft_set_elem_catchall *catchall;
+	u8 genmask = nft_genmask_next(net);
+	struct nft_set_ext *ext;
+
+	list_for_each_entry(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (nft_set_elem_active(ext, genmask)) {
+			*pext = ext;
+			return -EEXIST;
+		}
+	}
+
+	catchall = kmalloc(sizeof(*catchall), GFP_KERNEL);
+	if (!catchall)
+		return -ENOMEM;
+
+	catchall->elem = elem->priv;
+	list_add_tail_rcu(&catchall->list, &set->catchall_list);
+
+	return 0;
+}
+
+static int nft_setelem_insert(const struct net *net,
+			      struct nft_set *set,
+			      const struct nft_set_elem *elem,
+			      struct nft_set_ext **ext, unsigned int flags)
+{
+	int ret;
+
+	if (flags & NFT_SET_ELEM_CATCHALL)
+		ret = nft_setelem_catchall_insert(net, set, elem, ext);
+	else
+		ret = set->ops->insert(net, set, elem, ext);
+
+	return ret;
+}
+
+static bool nft_setelem_is_catchall(const struct nft_set *set,
+				    const struct nft_set_elem *elem)
+{
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
+	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_CATCHALL)
+		return true;
+
+	return false;
+}
+
+static void nft_setelem_activate(struct net *net, struct nft_set *set,
+				 struct nft_set_elem *elem)
+{
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+
+	if (nft_setelem_is_catchall(set, elem)) {
+		nft_set_elem_change_active(net, set, ext);
+		nft_set_elem_clear_busy(ext);
+	} else {
+		set->ops->activate(net, set, elem);
+	}
+}
+
+static int nft_setelem_catchall_deactivate(const struct net *net,
+					   struct nft_set *set,
+					   struct nft_set_elem *elem)
+{
+	struct nft_set_elem_catchall *catchall;
+	struct nft_set_ext *ext;
+
+	list_for_each_entry(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_is_active(net, ext) ||
+		    nft_set_elem_mark_busy(ext))
+			continue;
+
+		kfree(elem->priv);
+		elem->priv = catchall->elem;
+		nft_set_elem_change_active(net, set, ext);
+		return 0;
+	}
+
+	return -ENOENT;
+}
+
+static int __nft_setelem_deactivate(const struct net *net,
+				    struct nft_set *set,
+				    struct nft_set_elem *elem)
+{
+	void *priv;
+
+	priv = set->ops->deactivate(net, set, elem);
+	if (!priv)
+		return -ENOENT;
+
+	kfree(elem->priv);
+	elem->priv = priv;
+	set->ndeact++;
+
+	return 0;
+}
+
+static int nft_setelem_deactivate(const struct net *net,
+				  struct nft_set *set,
+				  struct nft_set_elem *elem, u32 flags)
+{
+	int ret;
+
+	if (flags & NFT_SET_ELEM_CATCHALL)
+		ret = nft_setelem_catchall_deactivate(net, set, elem);
+	else
+		ret = __nft_setelem_deactivate(net, set, elem);
+
+	return ret;
+}
+
+static void nft_setelem_catchall_remove(const struct net *net,
+					const struct nft_set *set,
+					const struct nft_set_elem *elem)
+{
+	struct nft_set_elem_catchall *catchall, *next;
+
+	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
+		if (catchall->elem == elem->priv) {
+			list_del_rcu(&catchall->list);
+			kfree_rcu(catchall);
+			break;
+		}
+	}
+}
+
+static void nft_setelem_remove(const struct net *net,
+			       const struct nft_set *set,
+			       const struct nft_set_elem *elem)
+{
+	if (nft_setelem_is_catchall(set, elem))
+		nft_setelem_catchall_remove(net, set, elem);
+	else
+		set->ops->remove(net, set, elem);
+}
+
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr, u32 nlmsg_flags)
 {
@@ -5369,14 +5668,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
-	if (nla[NFTA_SET_ELEM_KEY] == NULL)
-		return -EINVAL;
-
 	nft_set_ext_prepare(&tmpl);
 
 	err = nft_setelem_parse_flags(set, nla[NFTA_SET_ELEM_FLAGS], &flags);
 	if (err < 0)
 		return err;
+
+	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
+		return -EINVAL;
+
 	if (flags != 0)
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
 
@@ -5481,12 +5781,14 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		num_exprs = set->num_exprs;
 	}
 
-	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
-				    nla[NFTA_SET_ELEM_KEY]);
-	if (err < 0)
-		goto err_set_elem_expr;
+	if (nla[NFTA_SET_ELEM_KEY]) {
+		err = nft_setelem_parse_key(ctx, set, &elem.key.val,
+					    nla[NFTA_SET_ELEM_KEY]);
+		if (err < 0)
+			goto err_set_elem_expr;
 
-	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
 		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
@@ -5603,7 +5905,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
-	err = set->ops->insert(ctx->net, set, &elem, &ext2);
+
+	err = nft_setelem_insert(ctx->net, set, &elem, &ext2, flags);
 	if (err) {
 		if (err == -EEXIST) {
 			if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) ^
@@ -5630,7 +5933,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (set->size &&
+	if (!(flags & NFT_SET_ELEM_CATCHALL) && set->size &&
 	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
 		err = -ENFILE;
 		goto err_set_full;
@@ -5641,7 +5944,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 
 err_set_full:
-	set->ops->remove(ctx->net, set, &elem);
+	nft_setelem_remove(ctx->net, set, &elem);
 err_element_clash:
 	kfree(trans);
 err_elem_expr:
@@ -5773,7 +6076,6 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_ext *ext;
 	struct nft_trans *trans;
 	u32 flags = 0;
-	void *priv;
 	int err;
 
 	err = nla_parse_nested_deprecated(nla, NFTA_SET_ELEM_MAX, attr,
@@ -5781,23 +6083,26 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
-	if (nla[NFTA_SET_ELEM_KEY] == NULL)
+	err = nft_setelem_parse_flags(set, nla[NFTA_SET_ELEM_FLAGS], &flags);
+	if (err < 0)
+		return err;
+
+	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
 		return -EINVAL;
 
 	nft_set_ext_prepare(&tmpl);
 
-	err = nft_setelem_parse_flags(set, nla[NFTA_SET_ELEM_FLAGS], &flags);
-	if (err < 0)
-		return err;
 	if (flags != 0)
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
 
-	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
-				    nla[NFTA_SET_ELEM_KEY]);
-	if (err < 0)
-		return err;
+	if (nla[NFTA_SET_ELEM_KEY]) {
+		err = nft_setelem_parse_key(ctx, set, &elem.key.val,
+					    nla[NFTA_SET_ELEM_KEY]);
+		if (err < 0)
+			return err;
 
-	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
 		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
@@ -5823,13 +6128,9 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (trans == NULL)
 		goto fail_trans;
 
-	priv = set->ops->deactivate(ctx->net, set, &elem);
-	if (priv == NULL) {
-		err = -ENOENT;
+	err = nft_setelem_deactivate(ctx->net, set, &elem, flags);
+	if (err < 0)
 		goto fail_ops;
-	}
-	kfree(elem.priv);
-	elem.priv = priv;
 
 	nft_setelem_data_deactivate(ctx->net, set, &elem);
 
@@ -5876,6 +6177,49 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 	return err;
 }
 
+static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
+				    struct nft_set *set,
+				    struct nft_set_elem *elem)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc_gfp(ctx, NFT_MSG_DELSETELEM,
+				    sizeof(struct nft_trans_elem), GFP_KERNEL);
+	if (!trans)
+		return -ENOMEM;
+
+	nft_setelem_data_deactivate(ctx->net, set, elem);
+	nft_trans_elem_set(trans) = set;
+	nft_trans_elem(trans) = *elem;
+	nft_trans_commit_list_add_tail(ctx->net, trans);
+
+	return 0;
+}
+
+static int nft_set_catchall_flush(const struct nft_ctx *ctx,
+				  struct nft_set *set)
+{
+	u8 genmask = nft_genmask_next(ctx->net);
+	struct nft_set_elem_catchall *catchall;
+	struct nft_set_elem elem;
+	struct nft_set_ext *ext;
+	int ret = 0;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_set_elem_active(ext, genmask) ||
+		    nft_set_elem_mark_busy(ext))
+			continue;
+
+		elem.priv = catchall->elem;
+		ret = __nft_set_catchall_flush(ctx, set, &elem);
+		if (ret < 0)
+			break;
+	}
+
+	return ret;
+}
+
 static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
 {
 	struct nft_set_iter iter = {
@@ -5884,6 +6228,8 @@ static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
 	};
 
 	set->ops->walk(ctx, set, &iter);
+	if (!iter.err)
+		iter.err = nft_set_catchall_flush(ctx, set);
 
 	return iter.err;
 }
@@ -5918,8 +6264,6 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 		err = nft_del_setelem(&ctx, set, attr);
 		if (err < 0)
 			break;
-
-		set->ndeact++;
 	}
 	return err;
 }
@@ -8270,7 +8614,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		case NFT_MSG_NEWSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
-			te->set->ops->activate(net, te->set, &te->elem);
+			nft_setelem_activate(net, te->set, &te->elem);
 			nf_tables_setelem_notify(&trans->ctx, te->set,
 						 &te->elem,
 						 NFT_MSG_NEWSETELEM, 0);
@@ -8282,9 +8626,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nf_tables_setelem_notify(&trans->ctx, te->set,
 						 &te->elem,
 						 NFT_MSG_DELSETELEM, 0);
-			te->set->ops->remove(net, te->set, &te->elem);
-			atomic_dec(&te->set->nelems);
-			te->set->ndeact--;
+			nft_setelem_remove(net, te->set, &te->elem);
+			if (!nft_setelem_is_catchall(te->set, &te->elem)) {
+				atomic_dec(&te->set->nelems);
+				te->set->ndeact--;
+			}
 			break;
 		case NFT_MSG_NEWOBJ:
 			if (nft_trans_obj_update(trans)) {
@@ -8485,15 +8831,17 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				break;
 			}
 			te = (struct nft_trans_elem *)trans->data;
-			te->set->ops->remove(net, te->set, &te->elem);
-			atomic_dec(&te->set->nelems);
+			nft_setelem_remove(net, te->set, &te->elem);
+			if (!nft_setelem_is_catchall(te->set, &te->elem))
+				atomic_dec(&te->set->nelems);
 			break;
 		case NFT_MSG_DELSETELEM:
 			te = (struct nft_trans_elem *)trans->data;
 
 			nft_setelem_data_activate(net, te->set, &te->elem);
-			te->set->ops->activate(net, te->set, &te->elem);
-			te->set->ndeact--;
+			nft_setelem_activate(net, te->set, &te->elem);
+			if (!nft_setelem_is_catchall(te->set, &te->elem))
+				te->set->ndeact--;
 
 			nft_trans_destroy(trans);
 			break;
@@ -8672,6 +9020,27 @@ static int nf_tables_loop_check_setelem(const struct nft_ctx *ctx,
 	return nft_check_loops(ctx, ext);
 }
 
+static int nft_set_catchall_loops(const struct nft_ctx *ctx,
+				  struct nft_set *set)
+{
+	u8 genmask = nft_genmask_next(ctx->net);
+	struct nft_set_elem_catchall *catchall;
+	struct nft_set_ext *ext;
+	int ret = 0;
+
+	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
+		ext = nft_set_elem_ext(set, catchall->elem);
+		if (!nft_set_elem_active(ext, genmask))
+			continue;
+
+		ret = nft_check_loops(ctx, ext);
+		if (ret < 0)
+			return ret;
+	}
+
+	return ret;
+}
+
 static int nf_tables_check_loops(const struct nft_ctx *ctx,
 				 const struct nft_chain *chain)
 {
@@ -8731,6 +9100,9 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 			iter.fn		= nf_tables_loop_check_setelem;
 
 			set->ops->walk(ctx, set, &iter);
+			if (!iter.err)
+				iter.err = nft_set_catchall_loops(ctx, set);
+
 			if (iter.err < 0)
 				return iter.err;
 		}
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index b0f558b4fea5..a479f8a1270c 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -30,13 +30,17 @@ void nft_lookup_eval(const struct nft_expr *expr,
 	const struct nft_lookup *priv = nft_expr_priv(expr);
 	const struct nft_set *set = priv->set;
 	const struct nft_set_ext *ext = NULL;
+	const struct net *net = nft_net(pkt);
 	bool found;
 
-	found = set->ops->lookup(nft_net(pkt), set, &regs->data[priv->sreg],
-				 &ext) ^ priv->invert;
+	found = set->ops->lookup(net, set, &regs->data[priv->sreg], &ext) ^
+				 priv->invert;
 	if (!found) {
-		regs->verdict.code = NFT_BREAK;
-		return;
+		ext = nft_set_catchall_lookup(net, set);
+		if (!ext) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
 	}
 
 	if (ext) {
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index bc104d36d3bb..7e47edee88ee 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -105,15 +105,18 @@ static void nft_objref_map_eval(const struct nft_expr *expr,
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 	const struct nft_set *set = priv->set;
+	struct net *net = nft_net(pkt);
 	const struct nft_set_ext *ext;
 	struct nft_object *obj;
 	bool found;
 
-	found = set->ops->lookup(nft_net(pkt), set, &regs->data[priv->sreg],
-				 &ext);
+	found = set->ops->lookup(net, set, &regs->data[priv->sreg], &ext);
 	if (!found) {
-		regs->verdict.code = NFT_BREAK;
-		return;
+		ext = nft_set_catchall_lookup(net, set);
+		if (!ext) {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
 	}
 	obj = *nft_set_ext_obj(ext);
 	obj->ops->eval(obj, regs, pkt);
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index bf618b7ec1ae..58f576abcd4a 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -350,6 +350,12 @@ static void nft_rhash_gc(struct work_struct *work)
 	rhashtable_walk_stop(&hti);
 	rhashtable_walk_exit(&hti);
 
+	he = nft_set_catchall_gc(set);
+	if (he) {
+		gcb = nft_set_gc_batch_check(set, gcb, GFP_ATOMIC);
+		if (gcb)
+			nft_set_gc_batch_add(gcb, he);
+	}
 	nft_set_gc_batch_complete(gcb);
 	queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
 			   nft_set_gc_interval(set));
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 9944523f5c2c..528a2d7ca991 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1529,11 +1529,11 @@ static void pipapo_gc(const struct nft_set *set, struct nft_pipapo_match *m)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
 	int rules_f0, first_rule = 0;
+	struct nft_pipapo_elem *e;
 
 	while ((rules_f0 = pipapo_rules_same_key(m->f, first_rule))) {
 		union nft_pipapo_map_bucket rulemap[NFT_PIPAPO_MAX_FIELDS];
 		struct nft_pipapo_field *f;
-		struct nft_pipapo_elem *e;
 		int i, start, rules_fx;
 
 		start = first_rule;
@@ -1569,6 +1569,10 @@ static void pipapo_gc(const struct nft_set *set, struct nft_pipapo_match *m)
 		}
 	}
 
+	e = nft_set_catchall_gc(set);
+	if (e)
+		nft_set_elem_destroy(set, e, true);
+
 	priv->last_gc = jiffies;
 }
 
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 217ab3644c25..9e36eb4a7429 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -541,6 +541,12 @@ static void nft_rbtree_gc(struct work_struct *work)
 	write_seqcount_end(&priv->count);
 	write_unlock_bh(&priv->lock);
 
+	rbe = nft_set_catchall_gc(set);
+	if (rbe) {
+		gcb = nft_set_gc_batch_check(set, gcb, GFP_ATOMIC);
+		if (gcb)
+			nft_set_gc_batch_add(gcb, rbe);
+	}
 	nft_set_gc_batch_complete(gcb);
 
 	queue_delayed_work(system_power_efficient_wq, &priv->gc_work,
-- 
2.30.2

