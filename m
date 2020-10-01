Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2BD280698
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 20:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732836AbgJASbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 14:31:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732702AbgJASbk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 14:31:40 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E504521D24;
        Thu,  1 Oct 2020 18:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601577099;
        bh=0tZuVw3aih5eX5+VgGDDMBSqV0wwhSggok/lMsHVLHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjW/2uoAGkoFvCBH2S0cu8AqtkmhEBFd9Bo3FCjrskenfPPhA7JcahlJr2XWtjmrQ
         coiqXLcc3kt3w+2gsq4camuKbRq6rUSYwK9agKGbAoC+zcI8xYrwt0Wp5I7xcwLRZh
         2RgGcsV+D2AqN1NOJMhZ4hW6HVLbRQCMFBTIbzbY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/9] genetlink: bring back per op policy
Date:   Thu,  1 Oct 2020 11:30:13 -0700
Message-Id: <20201001183016.1259870-7-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001183016.1259870-1-kuba@kernel.org>
References: <20201001183016.1259870-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add policy to the struct genl_ops structure, this time
with maxattr, so it can be used properly.

Propagate .policy and .maxattr from the family
in genl_get_cmd() if needed, this way the rest of the
code does not have to worry if the policy is per op
or global.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/genetlink.h |  4 ++++
 net/netlink/genetlink.c | 18 +++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 8ea1fc1ed1c7..cb35625d001e 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -137,6 +137,8 @@ struct genl_small_ops {
  * @cmd: command identifier
  * @internal_flags: flags used by the family
  * @flags: flags
+ * @maxattr: maximum number of attributes supported
+ * @policy: netlink policy (takes precedence over family policy)
  * @doit: standard command callback
  * @start: start callback for dumps
  * @dumpit: callback for dumpers
@@ -149,6 +151,8 @@ struct genl_ops {
 	int		       (*dumpit)(struct sk_buff *skb,
 					 struct netlink_callback *cb);
 	int		       (*done)(struct netlink_callback *cb);
+	const struct nla_policy *policy;
+	unsigned int		maxattr;
 	u8			cmd;
 	u8			internal_flags;
 	u8			flags;
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 183f01e62ae9..2a3608cfb179 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -116,6 +116,11 @@ static void genl_op_from_full(const struct genl_family *family,
 			      unsigned int i, struct genl_ops *op)
 {
 	*op = family->ops[i];
+
+	if (!op->maxattr)
+		op->maxattr = family->maxattr;
+	if (!op->policy)
+		op->policy = family->policy;
 }
 
 static int genl_get_cmd_full(u8 cmd, const struct genl_family *family,
@@ -142,6 +147,9 @@ static void genl_op_from_small(const struct genl_family *family,
 	op->internal_flags = family->small_ops[i].internal_flags;
 	op->flags	= family->small_ops[i].flags;
 	op->validate	= family->small_ops[i].validate;
+
+	op->maxattr = family->maxattr;
+	op->policy = family->policy;
 }
 
 static int genl_get_cmd_small(u8 cmd, const struct genl_family *family,
@@ -529,16 +537,16 @@ genl_family_rcv_msg_attrs_parse(const struct genl_family *family,
 	struct nlattr **attrbuf;
 	int err;
 
-	if (!family->maxattr)
+	if (!ops->maxattr)
 		return NULL;
 
-	attrbuf = kmalloc_array(family->maxattr + 1,
+	attrbuf = kmalloc_array(ops->maxattr + 1,
 				sizeof(struct nlattr *), GFP_KERNEL);
 	if (!attrbuf)
 		return ERR_PTR(-ENOMEM);
 
-	err = __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
-			    family->policy, validate, extack);
+	err = __nlmsg_parse(nlh, hdrlen, attrbuf, ops->maxattr, ops->policy,
+			    validate, extack);
 	if (err) {
 		kfree(attrbuf);
 		return ERR_PTR(err);
@@ -845,7 +853,7 @@ static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
 				op_flags |= GENL_CMD_CAP_DUMP;
 			if (op.doit)
 				op_flags |= GENL_CMD_CAP_DO;
-			if (family->policy)
+			if (op.policy)
 				op_flags |= GENL_CMD_CAP_HASPOL;
 
 			nest = nla_nest_start_noflag(skb, i + 1);
-- 
2.26.2

