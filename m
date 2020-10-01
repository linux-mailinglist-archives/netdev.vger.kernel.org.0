Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE5027F670
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 02:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731797AbgJAAFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 20:05:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731673AbgJAAFb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 20:05:31 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 559192137B;
        Thu,  1 Oct 2020 00:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601510730;
        bh=kKVmay3CrA7LeUAsMHWVjjp1SROxBi74nLA5we3ZAJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fxO931tO6kVK/91Oh5YComYFH6AHoKSjXtGz8pWj6zr/NVEAxr6zfgr1JOMKknRU
         U3xtciVaMSohSlAZwIIQ7GK4OA+6FuuDljknzMJtlrtocy4tldhx8xYcDQOu083TaA
         EkqjzacucGtY6u+KrqjRlNkc0SpDU7Nf+6VHlxnU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, johannes@sipsolutions.net, jiri@resnulli.us,
        mkubecek@suse.cz, dsahern@kernel.org, pablo@netfilter.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 7/9] genetlink: bring back per op policy
Date:   Wed, 30 Sep 2020 17:05:16 -0700
Message-Id: <20201001000518.685243-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001000518.685243-1-kuba@kernel.org>
References: <20201001000518.685243-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add policy to the struct genl_ops structure, this time
with maxattr, so it can be used properly.

Propagate .policy and .maxattr from the family
in genl_get_cmd() if needed, this say the rest of the
code does not have to worry if the policy is per op
or global.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/genetlink.h |  4 ++++
 net/netlink/genetlink.c | 18 +++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index d781f2a240b5..48bfd8308938 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -156,6 +156,8 @@ struct genl_small_ops {
  * @internal_flags: flags used by the family
  * @flags: flags
  * @validate: validation flags from enum genl_validate_flags
+ * @maxattr: maximum number of attributes supported
+ * @policy: netlink policy (takes precedence over family policy)
  * @doit: standard command callback
  * @start: start callback for dumps
  * @dumpit: callback for dumpers
@@ -168,6 +170,8 @@ struct genl_ops {
 	int		       (*dumpit)(struct sk_buff *skb,
 					 struct netlink_callback *cb);
 	int		       (*done)(struct netlink_callback *cb);
+	const struct nla_policy *policy;
+	unsigned int		maxattr;
 	u8			cmd;
 	u8			internal_flags;
 	u8			flags;
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index dfa8a00640c0..7ceb2dc92a09 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -116,6 +116,11 @@ static void genl_op_from_full(const struct genl_family *family,
 			      unsigned int i, struct genl_ops *op)
 {
 	memcpy(op, &family->ops[i], sizeof(*op));
+
+	if (!op->maxattr)
+		op->maxattr = family->maxattr;
+	if (!op->policy)
+		op->policy = family->policy;
 }
 
 static int genl_get_cmd_full(u8 cmd, const struct genl_family *family,
@@ -142,6 +147,9 @@ static void genl_op_from_light(const struct genl_family *family,
 	op->internal_flags = family->small_ops[i].internal_flags;
 	op->flags	= family->small_ops[i].flags;
 	op->validate	= family->small_ops[i].validate;
+
+	op->maxattr = family->maxattr;
+	op->policy = family->policy;
 }
 
 static int genl_get_cmd_light(u8 cmd, const struct genl_family *family,
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

