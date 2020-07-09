Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0F3219D1F
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 12:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbgGIKLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 06:11:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:58286 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgGIKLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 06:11:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 738F3B04C;
        Thu,  9 Jul 2020 10:11:50 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 65DBB60567; Thu,  9 Jul 2020 12:11:50 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] ethtool: fix genlmsg_put() failure handling in
 ethnl_default_dumpit()
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Message-Id: <20200709101150.65DBB60567@lion.mk-sys.cz>
Date:   Thu,  9 Jul 2020 12:11:50 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the genlmsg_put() call in ethnl_default_dumpit() fails, we bail out
without checking if we already have some messages in current skb like we do
with ethnl_default_dump_one() failure later. Therefore if existing messages
almost fill up the buffer so that there is not enough space even for
netlink and genetlink header, we lose all prepared messages and return and
error.

Rather than duplicating the skb->len check, move the genlmsg_put(),
genlmsg_cancel() and genlmsg_end() calls into ethnl_default_dump_one().
This is also more logical as all message composition will be in
ethnl_default_dump_one() and only iteration logic will be left in
ethnl_default_dumpit().

Fixes: 728480f12442 ("ethtool: default handlers for GET requests")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/netlink.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 88fd07f47040..dd8a1c1dc07d 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -376,10 +376,17 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 }
 
 static int ethnl_default_dump_one(struct sk_buff *skb, struct net_device *dev,
-				  const struct ethnl_dump_ctx *ctx)
+				  const struct ethnl_dump_ctx *ctx,
+				  struct netlink_callback *cb)
 {
+	void *ehdr;
 	int ret;
 
+	ehdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			   &ethtool_genl_family, 0, ctx->ops->reply_cmd);
+	if (!ehdr)
+		return -EMSGSIZE;
+
 	ethnl_init_reply_data(ctx->reply_data, ctx->ops, dev);
 	rtnl_lock();
 	ret = ctx->ops->prepare_data(ctx->req_info, ctx->reply_data, NULL);
@@ -395,6 +402,10 @@ static int ethnl_default_dump_one(struct sk_buff *skb, struct net_device *dev,
 	if (ctx->ops->cleanup_data)
 		ctx->ops->cleanup_data(ctx->reply_data);
 	ctx->reply_data->dev = NULL;
+	if (ret < 0)
+		genlmsg_cancel(skb, ehdr);
+	else
+		genlmsg_end(skb, ehdr);
 	return ret;
 }
 
@@ -411,7 +422,6 @@ static int ethnl_default_dumpit(struct sk_buff *skb,
 	int s_idx = ctx->pos_idx;
 	int h, idx = 0;
 	int ret = 0;
-	void *ehdr;
 
 	rtnl_lock();
 	for (h = ctx->pos_hash; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
@@ -431,26 +441,15 @@ static int ethnl_default_dumpit(struct sk_buff *skb,
 			dev_hold(dev);
 			rtnl_unlock();
 
-			ehdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
-					   cb->nlh->nlmsg_seq,
-					   &ethtool_genl_family, 0,
-					   ctx->ops->reply_cmd);
-			if (!ehdr) {
-				dev_put(dev);
-				ret = -EMSGSIZE;
-				goto out;
-			}
-			ret = ethnl_default_dump_one(skb, dev, ctx);
+			ret = ethnl_default_dump_one(skb, dev, ctx, cb);
 			dev_put(dev);
 			if (ret < 0) {
-				genlmsg_cancel(skb, ehdr);
 				if (ret == -EOPNOTSUPP)
 					goto lock_and_cont;
 				if (likely(skb->len))
 					ret = skb->len;
 				goto out;
 			}
-			genlmsg_end(skb, ehdr);
 lock_and_cont:
 			rtnl_lock();
 			if (net->dev_base_seq != seq) {
-- 
2.27.0

