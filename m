Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAD4C24CD
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 18:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732194AbfI3QC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 12:02:26 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:57973 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730809AbfI3QCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 12:02:25 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTP id 9FA20324B63;
        Mon, 30 Sep 2019 18:02:24 +0200 (CEST)
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 2/2] netns/rtnl: return the new nsid to the user
Date:   Mon, 30 Sep 2019 18:02:14 +0200
Message-Id: <20190930160214.4512-3-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190930160214.4512-1-nicolas.dichtel@6wind.com>
References: <20190930160214.4512-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the user asks for a new nsid, he can let the kernel choose it (by
providing -1 in NETNSA_NSID). In this case, it's useful to answer to the
netlink message with the chosen nsid.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/core/net_namespace.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 8f5fa5d5becd..266d095296f3 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -810,8 +810,32 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = alloc_netid(net, peer, nsid);
 	spin_unlock_bh(&net->nsid_lock);
 	if (err >= 0) {
+		struct net_fill_args fillargs = {
+			.portid = NETLINK_CB(skb).portid,
+			.seq = nlh->nlmsg_seq,
+			.cmd = RTM_NEWNSID,
+			.nsid = err,
+		};
+		struct sk_buff *msg;
+
+		/* The id has been allocated, thus first notify listeners */
 		rtnl_net_notifyid(net, RTM_NEWNSID, err);
-		err = 0;
+
+		/* Then, try to send the new nsid to the sender */
+		msg = nlmsg_new(rtnl_net_get_size(), GFP_KERNEL);
+		if (!msg) {
+			err = -ENOMEM;
+			NL_SET_ERR_MSG(extack, "Unable to alloc reply msg");
+			goto out;
+		}
+
+		err = rtnl_net_fill(msg, &fillargs);
+		if (err < 0) {
+			kfree_skb(msg);
+			goto out;
+		}
+
+		err = rtnl_unicast(msg, net, NETLINK_CB(skb).portid);
 	} else if (err == -ENOSPC && nsid >= 0) {
 		err = -EEXIST;
 		NL_SET_BAD_ATTR(extack, tb[NETNSA_NSID]);
-- 
2.23.0

