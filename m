Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D504F7EFF
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245095AbiDGMbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243303AbiDGMbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:31:05 -0400
Received: from olfflo.fourcot.fr (fourcot.fr [217.70.191.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE18ADA08F
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 05:29:04 -0700 (PDT)
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, edumazet@google.com,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Brian Baboch <brian.baboch@wifirst.fr>
Subject: [PATCH v3 net-next 3/4] rtnetlink: return ENODEV when ifname does not exist and group is given
Date:   Thu,  7 Apr 2022 14:25:58 +0200
Message-Id: <20220407122559.27515-4-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220407122559.27515-1-florent.fourcot@wifirst.fr>
References: <20220407122559.27515-1-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the interface does not exist, and a group is given, the given
parameters are being set to all interfaces of the given group. The given
IFNAME/ALT_IF_NAME are being ignored in that case.

That can be dangerous since a typo (or a deleted interface) can produce
weird side effects for caller:

Case 1:

 IFLA_IFNAME=valid_interface
 IFLA_GROUP=1
 MTU=1234

Case 1 will update MTU and group of the given interface "valid_interface".

Case 2:

 IFLA_IFNAME=doesnotexist
 IFLA_GROUP=1
 MTU=1234

Case 2 will update MTU of all interfaces in group 1. IFLA_IFNAME is
ignored in this case

This behaviour is not consistent and dangerous. In order to fix this issue,
we now return ENODEV when the given IFNAME does not exist.

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>
---
 net/core/rtnetlink.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 33dbeed7e531..d2164bc635d3 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3283,6 +3283,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct ifinfomsg *ifm;
 	char ifname[IFNAMSIZ];
 	struct nlattr **data;
+	bool link_specified;
 	int err;
 
 #ifdef CONFIG_MODULES
@@ -3298,12 +3299,16 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return err;
 
 	ifm = nlmsg_data(nlh);
-	if (ifm->ifi_index > 0)
+	if (ifm->ifi_index > 0) {
+		link_specified = true;
 		dev = __dev_get_by_index(net, ifm->ifi_index);
-	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
+	} else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME]) {
+		link_specified = true;
 		dev = rtnl_dev_get(net, tb);
-	else
+	} else {
+		link_specified = false;
 		dev = NULL;
+	}
 
 	master_dev = NULL;
 	m_ops = NULL;
@@ -3406,7 +3411,12 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	if (!(nlh->nlmsg_flags & NLM_F_CREATE)) {
-		if (ifm->ifi_index == 0 && tb[IFLA_GROUP])
+		/* No dev found and NLM_F_CREATE not set. Requested dev does not exist,
+		 * or it's for a group
+		*/
+		if (link_specified)
+			return -ENODEV;
+		if (tb[IFLA_GROUP])
 			return rtnl_group_changelink(skb, net,
 						nla_get_u32(tb[IFLA_GROUP]),
 						ifm, extack, tb);
-- 
2.30.2

