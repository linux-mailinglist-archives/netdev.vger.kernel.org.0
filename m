Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9260D281DD9
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 23:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgJBVuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 17:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgJBVuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 17:50:08 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20D5221789;
        Fri,  2 Oct 2020 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601675407;
        bh=p88XMTSLleRTq4YmZ9b16ALciS2Sa9jjzAf28L4aHNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEnGAuea+FzqGAhUkaf5pQbvLDvRfXG0tOsjlW7kTm3FZM2q30M63WVBYVFkfEUyr
         x1FJjA20Q/3SqczG7xA1w6ERCtH/2qpFQ5qdxZVWJmA7ln5KopbcAAhmgwUzznFDr3
         4BqMJB86MwC4pITSS9XgS+QWa2wGQ939kdBRsEyo=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, johannes@sipsolutions.net,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 8/9] genetlink: use parsed attrs in dumppolicy
Date:   Fri,  2 Oct 2020 14:49:59 -0700
Message-Id: <20201002215000.1526096-9-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201002215000.1526096-1-kuba@kernel.org>
References: <20201002215000.1526096-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attributes are already parsed based on the policy specified
in the family and ready-to-use in info->attrs. No need to
call genlmsg_parse() again.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/netlink/genetlink.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index c3673d84d8b5..6f7cd5f577b0 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1117,18 +1117,13 @@ struct ctrl_dump_policy_ctx {
 
 static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 {
+	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
-	struct nlattr *tb[CTRL_ATTR_MAX + 1];
+	struct nlattr **tb = info->attrs;
 	const struct genl_family *rt;
-	int err;
 
 	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
 
-	err = genlmsg_parse(cb->nlh, &genl_ctrl, tb, genl_ctrl.maxattr,
-			    genl_ctrl.policy, cb->extack);
-	if (err)
-		return err;
-
 	if (!tb[CTRL_ATTR_FAMILY_ID] && !tb[CTRL_ATTR_FAMILY_NAME])
 		return -EINVAL;
 
-- 
2.26.2

