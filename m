Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36D3A5CED9
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfGBLur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:50:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:39218 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727229AbfGBLuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:50:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B4D82B132;
        Tue,  2 Jul 2019 11:50:44 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 65292E0159; Tue,  2 Jul 2019 13:50:44 +0200 (CEST)
Message-Id: <1a630b1e890064056feb3ccfe093a501704e8aed.1562067622.git.mkubecek@suse.cz>
In-Reply-To: <cover.1562067622.git.mkubecek@suse.cz>
References: <cover.1562067622.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 13/15] ethtool: add standard notification handler
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Tue,  2 Jul 2019 13:50:44 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethtool netlink notifications have the same format as related GET
replies so that if generic GET handling framework is used to process GET
requests, its callbacks and instance of struct get_request_ops can be
also used to compose corresponding notification message.

Provide function ethnl_std_notify() to be used as notification handler in
ethnl_notify_handlers table.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/netlink.c | 74 +++++++++++++++++++++++++++++++++++++++++++
 net/ethtool/netlink.h |  3 +-
 2 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 6c0cfa9001a1..9ff17ef05023 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -7,6 +7,7 @@
 static struct genl_family ethtool_genl_family;
 
 static bool ethnl_ok __read_mostly;
+static u32 ethnl_bcast_seq;
 
 #define __LINK_MODE_NAME(speed, type, duplex) \
 	#speed "base" #type "/" #duplex
@@ -258,6 +259,18 @@ struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
 	return NULL;
 }
 
+static void *ethnl_bcastmsg_put(struct sk_buff *skb, u8 cmd)
+{
+	return genlmsg_put(skb, 0, ++ethnl_bcast_seq, &ethtool_genl_family, 0,
+			   cmd);
+}
+
+static int ethnl_multicast(struct sk_buff *skb, struct net_device *dev)
+{
+	return genlmsg_multicast_netns(&ethtool_genl_family, dev_net(dev), skb,
+				       0, ETHNL_MCGRP_MONITOR, GFP_KERNEL);
+}
+
 /* GET request helpers */
 
 /**
@@ -597,6 +610,67 @@ static int ethnl_get_done(struct netlink_callback *cb)
 	return 0;
 }
 
+static const struct get_request_ops *ethnl_std_notify_to_ops(unsigned int cmd)
+{
+	WARN_ONCE(1, "unexpected notification type %u\n", cmd);
+	return NULL;
+}
+
+/* generic notification handler */
+static void ethnl_std_notify(struct net_device *dev,
+			     struct netlink_ext_ack *extack, unsigned int cmd,
+			     u32 req_mask, const void *data)
+{
+	const struct get_request_ops *ops;
+	struct ethnl_req_info *req_info;
+	struct sk_buff *skb;
+	void *reply_payload;
+	int reply_len;
+	int ret;
+
+	ops = ethnl_std_notify_to_ops(cmd);
+	if (!ops)
+		return;
+
+	req_info = ethnl_alloc_get_data(ops);
+	if (!req_info)
+		return;
+	req_info->dev = dev;
+	req_info->req_mask = req_mask;
+	req_info->global_flags |= ETHTOOL_RF_COMPACT;
+
+	ethnl_init_reply_data(req_info, ops, dev);
+	ret = ops->prepare_data(req_info, NULL);
+	if (ret < 0)
+		goto err_data;
+	reply_len = ops->reply_size(req_info);
+	if (reply_len < 0)
+		goto err_data;
+	skb = genlmsg_new(reply_len, GFP_KERNEL);
+	if (!skb)
+		goto err_data;
+	reply_payload = ethnl_bcastmsg_put(skb, cmd);
+	if (!reply_payload)
+		goto err_skb;
+
+	ret = ethnl_fill_reply_header(skb, dev, ops->hdr_attr);
+	if (ret < 0)
+		goto err_skb;
+	ret = ops->fill_reply(skb, req_info);
+	if (ret < 0)
+		goto err_skb;
+	ethnl_free_get_data(ops, req_info);
+	genlmsg_end(skb, reply_payload);
+
+	ethnl_multicast(skb, dev);
+	return;
+
+err_skb:
+	nlmsg_free(skb);
+err_data:
+	ethnl_free_get_data(ops, req_info);
+}
+
 /* notifications */
 
 typedef void (*ethnl_notify_handler_t)(struct net_device *dev,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 27832a3956c8..6512d9d508bf 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -265,7 +265,8 @@ static inline void ethnl_after_ops(struct net_device *dev)
  * infrastructure. When used, a pointer to an instance of this structure is to
  * be added to &get_requests array and generic handlers ethnl_get_doit(),
  * ethnl_get_dumpit(), ethnl_get_start() and ethnl_get_done() used in
- * @ethnl_genl_ops
+ * @ethnl_genl_ops; ethnl_std_notify() can be used in @ethnl_notify_handlers
+ * to send notifications of the corresponding type.
  */
 struct get_request_ops {
 	u8			request_cmd;
-- 
2.22.0

