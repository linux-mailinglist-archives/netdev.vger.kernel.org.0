Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BFC280AA4
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 00:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733194AbgJAW7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 18:59:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733120AbgJAW7n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 18:59:43 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22B8720848;
        Thu,  1 Oct 2020 22:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601593182;
        bh=RqGwQgMBRsPPfyV9SqR82PwvvtXcQaIrWjN40eVEUFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9TCmHjiwoEXUmTU9wkn+RFb31LQZSeWUleF8W4l3JMzJNl/ufkqbiWTFFVWeS4rA
         Xf5FDuR/7Q2jxnraWs5i8KfCUiFCTAeGcv0KuXC6IRsX6Z4WK2m5AElTm0sDxYdCTs
         DQqeeeZHAzn0zEPvIWbF5GUQK7kra/HypqkE1bPs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 01/10] genetlink: reorg struct genl_family
Date:   Thu,  1 Oct 2020 15:59:24 -0700
Message-Id: <20201001225933.1373426-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001225933.1373426-1-kuba@kernel.org>
References: <20201001225933.1373426-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are holes and oversized members in struct genl_family.

Before: /* size: 104, cachelines: 2, members: 16 */
After:  /* size:  88, cachelines: 2, members: 16 */

The command field in struct genlmsghdr is a u8, so no point
in the operation count being 32 bit. Also operation 0 is
usually undefined, so we only need 255 entries.

netnsok and parallel_ops are only ever initialized to true.

We can grow the fields as needed, compiler should warn us
if someone tries to assign larger constants.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/genetlink.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index b9eb92f3fe86..5cd9ab0c6bd9 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -48,8 +48,11 @@ struct genl_family {
 	char			name[GENL_NAMSIZ];
 	unsigned int		version;
 	unsigned int		maxattr;
-	bool			netnsok;
-	bool			parallel_ops;
+	unsigned int		mcgrp_offset;	/* private */
+	u8			netnsok:1;
+	u8			parallel_ops:1;
+	u8			n_ops;
+	u8			n_mcgrps;
 	const struct nla_policy *policy;
 	int			(*pre_doit)(const struct genl_ops *ops,
 					    struct sk_buff *skb,
@@ -59,9 +62,6 @@ struct genl_family {
 					     struct genl_info *info);
 	const struct genl_ops *	ops;
 	const struct genl_multicast_group *mcgrps;
-	unsigned int		n_ops;
-	unsigned int		n_mcgrps;
-	unsigned int		mcgrp_offset;	/* private */
 	struct module		*module;
 };
 
-- 
2.26.2

