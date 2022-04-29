Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF00F51592E
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 01:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381810AbiD2X6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 19:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381688AbiD2X6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 19:58:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0C22C13B
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 16:55:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DABB9B837F2
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 23:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E100C385AE;
        Fri, 29 Apr 2022 23:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651276522;
        bh=e/r6o2gwPkEhyF5kWovUegh4dL1Jp2DLqzg5rr8UeAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQLeoiiwAuJpmYDA/RIW9l8Bd/fUCEQJt30iCNcC86FSEZ40vOop+Y9OmIGlUxE1k
         whvlbIodkzA4Fh9xCReG32cn+HENk1eVPNH5VPLkDsQuzz1tGg9+DDgRK8xdmzq7/G
         wpodcCfe0K2p/O4C1AFXe6fvoMXEHQmT/sjESDAkqcRto6QaxjQtlMry8o0c+fSNIB
         aUeAIlVNXkjrvXfR30BZ8bUg2Gm0P1XS22Wnkw7Fdhp0qF5qmJZ+gwJwwxw81Wee6X
         kjL2yRY98l0T9z8WQd6AxR10su7Trlncc1ch0oZGIEr3+Ckw2ju0QvU6FLR4Y33jQm
         0FMivm6S1Q37w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        petrm@nvidia.com, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH net-next 1/3] rtnl: allocate more attr tables on the heap
Date:   Fri, 29 Apr 2022 16:55:06 -0700
Message-Id: <20220429235508.268349-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220429235508.268349-1-kuba@kernel.org>
References: <20220429235508.268349-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a293974590cf ("rtnetlink: avoid frame size warning in rtnl_newlink()")
moved to allocating the largest attribute array of rtnl_newlink()
on the heap. Kalle reports the stack has grown above 1k again:

  net/core/rtnetlink.c:3557:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Move more attrs to the heap, wrap them in a struct.
Don't bother with linkinfo, it's referenced a lot and we take
its size so it's awkward to move, plus it's small (6 elements).

Reported-by: Kalle Valo <kvalo@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/rtnetlink.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 73f2cbc440c9..33919fd5c202 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3302,17 +3302,23 @@ static int rtnl_group_changelink(const struct sk_buff *skb,
 	return 0;
 }
 
+struct rtnl_newlink_tbs {
+	struct nlattr *tb[IFLA_MAX + 1];
+	struct nlattr *attr[RTNL_MAX_TYPE + 1];
+	struct nlattr *slave_attr[RTNL_SLAVE_MAX_TYPE + 1];
+};
+
 static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
-			  struct nlattr **attr, struct netlink_ext_ack *extack)
+			  struct rtnl_newlink_tbs *tbs,
+			  struct netlink_ext_ack *extack)
 {
-	struct nlattr *slave_attr[RTNL_SLAVE_MAX_TYPE + 1];
 	unsigned char name_assign_type = NET_NAME_USER;
 	struct nlattr *linkinfo[IFLA_INFO_MAX + 1];
+	struct nlattr ** const tb = tbs->tb;
 	const struct rtnl_link_ops *m_ops;
 	struct net_device *master_dev;
 	struct net *net = sock_net(skb->sk);
 	const struct rtnl_link_ops *ops;
-	struct nlattr *tb[IFLA_MAX + 1];
 	struct net *dest_net, *link_net;
 	struct nlattr **slave_data;
 	char kind[MODULE_NAME_LEN];
@@ -3382,12 +3388,12 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return -EINVAL;
 
 		if (ops->maxtype && linkinfo[IFLA_INFO_DATA]) {
-			err = nla_parse_nested_deprecated(attr, ops->maxtype,
+			err = nla_parse_nested_deprecated(tbs->attr, ops->maxtype,
 							  linkinfo[IFLA_INFO_DATA],
 							  ops->policy, extack);
 			if (err < 0)
 				return err;
-			data = attr;
+			data = tbs->attr;
 		}
 		if (ops->validate) {
 			err = ops->validate(tb, data, extack);
@@ -3403,14 +3409,14 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 		if (m_ops->slave_maxtype &&
 		    linkinfo[IFLA_INFO_SLAVE_DATA]) {
-			err = nla_parse_nested_deprecated(slave_attr,
+			err = nla_parse_nested_deprecated(tbs->slave_attr,
 							  m_ops->slave_maxtype,
 							  linkinfo[IFLA_INFO_SLAVE_DATA],
 							  m_ops->slave_policy,
 							  extack);
 			if (err < 0)
 				return err;
-			slave_data = slave_attr;
+			slave_data = tbs->slave_attr;
 		}
 	}
 
@@ -3559,15 +3565,15 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 static int rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
-	struct nlattr **attr;
+	struct rtnl_newlink_tbs *tbs;
 	int ret;
 
-	attr = kmalloc_array(RTNL_MAX_TYPE + 1, sizeof(*attr), GFP_KERNEL);
-	if (!attr)
+	tbs = kmalloc(sizeof(*tbs), GFP_KERNEL);
+	if (!tbs)
 		return -ENOMEM;
 
-	ret = __rtnl_newlink(skb, nlh, attr, extack);
-	kfree(attr);
+	ret = __rtnl_newlink(skb, nlh, tbs, extack);
+	kfree(tbs);
 	return ret;
 }
 
-- 
2.34.1

