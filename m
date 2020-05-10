Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711171DD83E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 22:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgEUU06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 16:26:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:57448 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728365AbgEUU06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 16:26:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 02CC1AB8F;
        Thu, 21 May 2020 20:26:59 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 95971604F8; Thu, 21 May 2020 22:26:56 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Date:   Sun, 10 May 2020 21:04:09 +0200
Subject: [PATCH net] ethtool: count header size in reply size estimate
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>
Message-Id: <20200521202656.95971604F8@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As ethnl_request_ops::reply_size handlers do not include common header
size into calculated/estimated reply size, it needs to be added in
ethnl_default_doit() and ethnl_default_notify() before allocating the
message. On the other hand, strset_reply_size() should not add common
header size.

Fixes: 728480f12442 ("ethtool: default handlers for GET requests")
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/netlink.c | 4 ++--
 net/ethtool/strset.c  | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 0c772318c023..ed5357210193 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -342,7 +342,7 @@ static int ethnl_default_doit(struct sk_buff *skb, struct genl_info *info)
 	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
-	reply_len = ret;
+	reply_len = ret + ethnl_reply_header_size();
 	ret = -ENOMEM;
 	rskb = ethnl_reply_init(reply_len, req_info->dev, ops->reply_cmd,
 				ops->hdr_attr, info, &reply_payload);
@@ -588,7 +588,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
 	ret = ops->reply_size(req_info, reply_data);
 	if (ret < 0)
 		goto err_cleanup;
-	reply_len = ret;
+	reply_len = ret + ethnl_reply_header_size();
 	ret = -ENOMEM;
 	skb = genlmsg_new(reply_len, GFP_KERNEL);
 	if (!skb)
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 95eae5c68a52..0eed4e4909ab 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -324,7 +324,6 @@ static int strset_reply_size(const struct ethnl_req_info *req_base,
 	int len = 0;
 	int ret;
 
-	len += ethnl_reply_header_size();
 	for (i = 0; i < ETH_SS_COUNT; i++) {
 		const struct strset_info *set_info = &data->sets[i];
 
-- 
2.26.2

