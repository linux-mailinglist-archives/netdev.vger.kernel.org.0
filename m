Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37A1603665
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJRXHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbiJRXHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F77422E0
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A16C61713
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4671C43142;
        Tue, 18 Oct 2022 23:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134455;
        bh=b9ENQqD1eicwSkhAdLMnisQRH/ws25nMfmKVw2N9muQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQSJqu0bJED7JbCYxTAhptVhZbvmo5qG+aGzcqXfRrnaIz569R5UueQkZ/fs9k999
         8s22lgFc6SDdra+SPu/EtnTMGSoSJgcJmBKz7r6azZo0KfBt6nnVFCs/npbNknwQFJ
         tVBliNJhB+oIbkVEGr8gfhneXoWiB62xriKDdJOKx15NUNqXfrnYl0P6szXxuG4d2l
         wNuPWkb2VdMYy+dbn0Z1hXUoy30yvqRTuw6bRyJdVO75VPG+d8u5CTH8FGgt+YgVOm
         pSr+SC+9TEH2PJp4nsSIyvL2wRpUssJty0cd1qFYW9FG5quBphZ97nuBSH5P/cbP+f
         8hWwihfHgRTbQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        jiri@nvidia.com, nhorman@tuxdriver.com, alex.aring@gmail.com,
        stefan@datenfreihafen.org
Subject: [PATCH net-next 03/13] genetlink: introduce split op representation
Date:   Tue, 18 Oct 2022 16:07:18 -0700
Message-Id: <20221018230728.1039524-4-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018230728.1039524-1-kuba@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently have two forms of operations - small ops and "full" ops
(or just ops). The former does not have pointers for some of the less
commonly used features (namely dump start/done and policy).

The "full" ops, however, still don't contain all the necessary
information. In particular the policy is per command ID, while
do and dump often accept different attributes. It's also not
possible to define different pre_doit and post_doit callbacks
for different commands within the family.

At the same time a lot of commands do not support dumping and
therefore all the dump-related information is wasted space.

Create a new command representation which can hold info about
a do implementation or a dump implementation, but not both at
the same time.

Use this new representation on the command execution path
(genl_family_rcv_msg) as we either run a do or a dump and
don't have to create a "full" op there.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: mareklindner@neomailbox.ch
CC: sw@simonwunderlich.de
CC: a@unstable.cc
CC: sven@narfation.org
CC: jiri@nvidia.com
CC: nhorman@tuxdriver.com
CC: alex.aring@gmail.com
CC: stefan@datenfreihafen.org
CC: johannes@sipsolutions.net
---
 include/net/genetlink.h   | 60 ++++++++++++++++++++++++++++++---
 net/batman-adv/netlink.c  |  6 ++--
 net/core/devlink.c        |  4 +--
 net/core/drop_monitor.c   |  4 +--
 net/ieee802154/nl802154.c |  6 ++--
 net/netlink/genetlink.c   | 70 +++++++++++++++++++++++++++++++++------
 net/wireless/nl80211.c    |  6 ++--
 7 files changed, 131 insertions(+), 25 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index f2366b463597..373a99984cfe 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -18,7 +18,7 @@ struct genl_multicast_group {
 	u8			flags;
 };
 
-struct genl_ops;
+struct genl_split_ops;
 struct genl_info;
 
 /**
@@ -57,10 +57,10 @@ struct genl_family {
 	u8			n_mcgrps;
 	u8			resv_start_op;
 	const struct nla_policy *policy;
-	int			(*pre_doit)(const struct genl_ops *ops,
+	int			(*pre_doit)(const struct genl_split_ops *ops,
 					    struct sk_buff *skb,
 					    struct genl_info *info);
-	void			(*post_doit)(const struct genl_ops *ops,
+	void			(*post_doit)(const struct genl_split_ops *ops,
 					     struct sk_buff *skb,
 					     struct genl_info *info);
 	const struct genl_ops *	ops;
@@ -173,6 +173,58 @@ struct genl_ops {
 	u8			validate;
 };
 
+/**
+ * struct genl_split_ops - generic netlink operations (do/dump split version)
+ * @cmd: command identifier
+ * @internal_flags: flags used by the family
+ * @flags: GENL_* flags (%GENL_ADMIN_PERM or %GENL_UNS_ADMIN_PERM)
+ * @validate: validation flags from enum genl_validate_flags
+ * @policy: netlink policy (takes precedence over family policy)
+ * @maxattr: maximum number of attributes supported
+  *
+ * Do callbacks:
+ * @pre_doit: called before an operation's @doit callback, it may
+ *	do additional, common, filtering and return an error
+ * @doit: standard command callback
+ * @post_doit: called after an operation's @doit callback, it may
+ *	undo operations done by pre_doit, for example release locks
+ *
+ * Dump callbacks:
+ * @start: start callback for dumps
+ * @dumpit: callback for dumpers
+ * @done: completion callback for dumps
+ *
+ * Do callbacks can be used if %GENL_CMD_CAP_DO is set in @flags.
+ * Dump callbacks can be used if %GENL_CMD_CAP_DUMP is set in @flags.
+ * Exactly one of those flags must be set.
+ */
+struct genl_split_ops {
+	union {
+		struct {
+			int (*pre_doit)(const struct genl_split_ops *ops,
+					struct sk_buff *skb,
+					struct genl_info *info);
+			int (*doit)(struct sk_buff *skb,
+				    struct genl_info *info);
+			void (*post_doit)(const struct genl_split_ops *ops,
+					  struct sk_buff *skb,
+					  struct genl_info *info);
+		};
+		struct {
+			int (*start)(struct netlink_callback *cb);
+			int (*dumpit)(struct sk_buff *skb,
+				      struct netlink_callback *cb);
+			int (*done)(struct netlink_callback *cb);
+		};
+	};
+	const struct nla_policy *policy;
+	unsigned int		maxattr;
+	u8			cmd;
+	u8			internal_flags;
+	u8			flags;
+	u8			validate;
+};
+
 /**
  * struct genl_info - info that is available during dumpit op call
  * @family: generic netlink family - for internal genl code usage
@@ -181,7 +233,7 @@ struct genl_ops {
  */
 struct genl_dumpit_info {
 	const struct genl_family *family;
-	struct genl_ops op;
+	struct genl_split_ops op;
 	struct nlattr **attrs;
 };
 
diff --git a/net/batman-adv/netlink.c b/net/batman-adv/netlink.c
index a5e4a4e976cf..ad5714f737be 100644
--- a/net/batman-adv/netlink.c
+++ b/net/batman-adv/netlink.c
@@ -1267,7 +1267,8 @@ batadv_get_vlan_from_info(struct batadv_priv *bat_priv, struct net *net,
  *
  * Return: 0 on success or negative error number in case of failure
  */
-static int batadv_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
+static int batadv_pre_doit(const struct genl_split_ops *ops,
+			   struct sk_buff *skb,
 			   struct genl_info *info)
 {
 	struct net *net = genl_info_net(info);
@@ -1332,7 +1333,8 @@ static int batadv_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
  * @skb: Netlink message with request data
  * @info: receiver information
  */
-static void batadv_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
+static void batadv_post_doit(const struct genl_split_ops *ops,
+			     struct sk_buff *skb,
 			     struct genl_info *info)
 {
 	struct batadv_hard_iface *hard_iface;
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 89baa7c0938b..744d5879914f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -769,7 +769,7 @@ devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
 #define DEVLINK_NL_FLAG_NEED_RATE_NODE		BIT(3)
 #define DEVLINK_NL_FLAG_NEED_LINECARD		BIT(4)
 
-static int devlink_nl_pre_doit(const struct genl_ops *ops,
+static int devlink_nl_pre_doit(const struct genl_split_ops *ops,
 			       struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink_linecard *linecard;
@@ -827,7 +827,7 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 	return err;
 }
 
-static void devlink_nl_post_doit(const struct genl_ops *ops,
+static void devlink_nl_post_doit(const struct genl_split_ops *ops,
 				 struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink_linecard *linecard;
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index f084a4a6b7ab..cb25e58e3882 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1620,7 +1620,7 @@ static const struct genl_small_ops dropmon_ops[] = {
 	},
 };
 
-static int net_dm_nl_pre_doit(const struct genl_ops *ops,
+static int net_dm_nl_pre_doit(const struct genl_split_ops *ops,
 			      struct sk_buff *skb, struct genl_info *info)
 {
 	mutex_lock(&net_dm_mutex);
@@ -1628,7 +1628,7 @@ static int net_dm_nl_pre_doit(const struct genl_ops *ops,
 	return 0;
 }
 
-static void net_dm_nl_post_doit(const struct genl_ops *ops,
+static void net_dm_nl_post_doit(const struct genl_split_ops *ops,
 				struct sk_buff *skb, struct genl_info *info)
 {
 	mutex_unlock(&net_dm_mutex);
diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 38c4f3cb010e..b33d1b5eda87 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -2157,7 +2157,8 @@ static int nl802154_del_llsec_seclevel(struct sk_buff *skb,
 #define NL802154_FLAG_CHECK_NETDEV_UP	0x08
 #define NL802154_FLAG_NEED_WPAN_DEV	0x10
 
-static int nl802154_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
+static int nl802154_pre_doit(const struct genl_split_ops *ops,
+			     struct sk_buff *skb,
 			     struct genl_info *info)
 {
 	struct cfg802154_registered_device *rdev;
@@ -2219,7 +2220,8 @@ static int nl802154_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 	return 0;
 }
 
-static void nl802154_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
+static void nl802154_post_doit(const struct genl_split_ops *ops,
+			       struct sk_buff *skb,
 			       struct genl_info *info)
 {
 	if (info->user_ptr[1]) {
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 43cc31fb3d25..23d3682d8f94 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -166,6 +166,50 @@ static int genl_get_cmd(u32 cmd, const struct genl_family *family,
 	return genl_get_cmd_small(cmd, family, op);
 }
 
+static void
+genl_cmd_full_to_split(struct genl_split_ops *op,
+		       const struct genl_family *family,
+		       const struct genl_ops *full, u8 flags)
+{
+	if (flags & GENL_CMD_CAP_DUMP) {
+		op->start	= full->start;
+		op->dumpit	= full->dumpit;
+		op->done	= full->done;
+	} else {
+		op->pre_doit	= family->pre_doit;
+		op->doit	= full->doit;
+		op->post_doit	= family->post_doit;
+	}
+
+	op->policy		= full->policy;
+	op->maxattr		= full->maxattr;
+
+	op->cmd			= full->cmd;
+	op->internal_flags	= full->internal_flags;
+	op->flags		= full->flags;
+	op->validate		= full->validate;
+
+	op->flags		|= flags;
+}
+
+static int
+genl_get_cmd_split(u32 cmd, u8 flags, const struct genl_family *family,
+		   struct genl_split_ops *op)
+{
+	struct genl_ops full;
+	int err;
+
+	err = genl_get_cmd(cmd, family, &full);
+	if (err) {
+		memset(op, 0, sizeof(*op));
+		return err;
+	}
+
+	genl_cmd_full_to_split(op, family, &full, flags);
+
+	return 0;
+}
+
 static void genl_get_cmd_by_index(unsigned int i,
 				  const struct genl_family *family,
 				  struct genl_ops *op)
@@ -519,7 +563,7 @@ static struct nlattr **
 genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 				struct nlmsghdr *nlh,
 				struct netlink_ext_ack *extack,
-				const struct genl_ops *ops,
+				const struct genl_split_ops *ops,
 				int hdrlen,
 				enum genl_validate_flags no_strict_flag)
 {
@@ -555,18 +599,19 @@ struct genl_start_context {
 	const struct genl_family *family;
 	struct nlmsghdr *nlh;
 	struct netlink_ext_ack *extack;
-	const struct genl_ops *ops;
+	const struct genl_split_ops *ops;
 	int hdrlen;
 };
 
 static int genl_start(struct netlink_callback *cb)
 {
 	struct genl_start_context *ctx = cb->data;
-	const struct genl_ops *ops = ctx->ops;
+	const struct genl_split_ops *ops;
 	struct genl_dumpit_info *info;
 	struct nlattr **attrs = NULL;
 	int rc = 0;
 
+	ops = ctx->ops;
 	if (ops->validate & GENL_DONT_VALIDATE_DUMP)
 		goto no_attrs;
 
@@ -608,7 +653,7 @@ static int genl_start(struct netlink_callback *cb)
 
 static int genl_lock_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	const struct genl_ops *ops = &genl_dumpit_info(cb)->op;
+	const struct genl_split_ops *ops = &genl_dumpit_info(cb)->op;
 	int rc;
 
 	genl_lock();
@@ -620,7 +665,7 @@ static int genl_lock_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 static int genl_lock_done(struct netlink_callback *cb)
 {
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
-	const struct genl_ops *ops = &info->op;
+	const struct genl_split_ops *ops = &info->op;
 	int rc = 0;
 
 	if (ops->done) {
@@ -636,7 +681,7 @@ static int genl_lock_done(struct netlink_callback *cb)
 static int genl_parallel_done(struct netlink_callback *cb)
 {
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
-	const struct genl_ops *ops = &info->op;
+	const struct genl_split_ops *ops = &info->op;
 	int rc = 0;
 
 	if (ops->done)
@@ -650,7 +695,7 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 				      struct sk_buff *skb,
 				      struct nlmsghdr *nlh,
 				      struct netlink_ext_ack *extack,
-				      const struct genl_ops *ops,
+				      const struct genl_split_ops *ops,
 				      int hdrlen, struct net *net)
 {
 	struct genl_start_context ctx;
@@ -696,7 +741,7 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 				    struct sk_buff *skb,
 				    struct nlmsghdr *nlh,
 				    struct netlink_ext_ack *extack,
-				    const struct genl_ops *ops,
+				    const struct genl_split_ops *ops,
 				    int hdrlen, struct net *net)
 {
 	struct nlattr **attrbuf;
@@ -776,8 +821,9 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 {
 	struct net *net = sock_net(skb->sk);
 	struct genlmsghdr *hdr = nlmsg_data(nlh);
-	struct genl_ops op;
+	struct genl_split_ops op;
 	int hdrlen;
+	u8 flags;
 
 	/* this family doesn't exist in this netns */
 	if (!family->netnsok && !net_eq(net, &init_net))
@@ -790,7 +836,9 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 	if (genl_header_check(family, nlh, hdr, extack))
 		return -EINVAL;
 
-	if (genl_get_cmd(hdr->cmd, family, &op))
+	flags = (nlh->nlmsg_flags & NLM_F_DUMP) == NLM_F_DUMP ?
+		GENL_CMD_CAP_DUMP : GENL_CMD_CAP_DO;
+	if (genl_get_cmd_split(hdr->cmd, flags, family, &op))
 		return -EOPNOTSUPP;
 
 	if ((op.flags & GENL_ADMIN_PERM) &&
@@ -801,7 +849,7 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 	    !netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
-	if ((nlh->nlmsg_flags & NLM_F_DUMP) == NLM_F_DUMP)
+	if (flags & GENL_CMD_CAP_DUMP)
 		return genl_family_rcv_msg_dumpit(family, skb, nlh, extack,
 						  &op, hdrlen, net);
 	else
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 597c52236514..250305061543 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16139,7 +16139,8 @@ static u32 nl80211_internal_flags[] = {
 #undef SELECTOR
 };
 
-static int nl80211_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
+static int nl80211_pre_doit(const struct genl_split_ops *ops,
+			    struct sk_buff *skb,
 			    struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = NULL;
@@ -16240,7 +16241,8 @@ static int nl80211_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 	return err;
 }
 
-static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
+static void nl80211_post_doit(const struct genl_split_ops *ops,
+			      struct sk_buff *skb,
 			      struct genl_info *info)
 {
 	u32 internal_flags = nl80211_internal_flags[ops->internal_flags];
-- 
2.37.3

