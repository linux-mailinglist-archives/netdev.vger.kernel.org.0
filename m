Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787E34ED9C9
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 14:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbiCaMqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 08:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236259AbiCaMqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 08:46:31 -0400
X-Greylist: delayed 447 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 31 Mar 2022 05:44:44 PDT
Received: from olfflo.fourcot.fr (fourcot.fr [217.70.191.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0F8207A18
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 05:44:43 -0700 (PDT)
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        Brian Baboch <brian.baboch@wifirst.fr>
Subject: [PATCH net-next] rtnetlink: return ENODEV when ifname does not exist and group is given
Date:   Thu, 31 Mar 2022 14:35:02 +0200
Message-Id: <20220331123502.6472-1-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
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
 net/core/rtnetlink.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 159c9c61e6af..3313419bbcba 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3417,10 +3417,15 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	if (!(nlh->nlmsg_flags & NLM_F_CREATE)) {
-		if (ifm->ifi_index == 0 && tb[IFLA_GROUP])
+		if (ifm->ifi_index == 0 && tb[IFLA_GROUP]) {
+			if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME]) {
+				NL_SET_ERR_MSG(extack, "Cannot find interface with given name");
+				return -ENODEV;
+			}
 			return rtnl_group_changelink(skb, net,
 						nla_get_u32(tb[IFLA_GROUP]),
 						ifm, extack, tb);
+		}
 		return -ENODEV;
 	}
 
-- 
2.30.2

