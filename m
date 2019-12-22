Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C108912905F
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 00:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfLVXqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 18:46:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:55456 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfLVXqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Dec 2019 18:46:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 908B5AF27;
        Sun, 22 Dec 2019 23:45:59 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 43B21E03A8; Mon, 23 Dec 2019 00:45:59 +0100 (CET)
Message-Id: <ae163843d4df6ccbccd4ca24ae5d7c19c2e1909d.1577052887.git.mkubecek@suse.cz>
In-Reply-To: <cover.1577052887.git.mkubecek@suse.cz>
References: <cover.1577052887.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v8 09/14] ethtool: add default notification handler
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Dec 2019 00:45:59 +0100 (CET)
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
 net/ethtool/netlink.c | 89 +++++++++++++++++++++++++++++++++++++++++++
 net/ethtool/netlink.h |  4 +-
 2 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 7867425956f6..057b67f8ba8c 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -7,6 +7,7 @@
 static struct genl_family ethtool_genl_family;
 
 static bool ethnl_ok __read_mostly;
+static u32 ethnl_bcast_seq;
 
 static const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_MAX + 1] = {
 	[ETHTOOL_A_HEADER_UNSPEC]	= { .type = NLA_REJECT },
@@ -171,6 +172,18 @@ struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
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
@@ -494,6 +507,82 @@ static int ethnl_default_done(struct netlink_callback *cb)
 	return 0;
 }
 
+static const struct ethnl_request_ops *
+ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
+};
+
+/* default notification handler */
+static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
+				 const void *data)
+{
+	struct ethnl_reply_data *reply_data;
+	const struct ethnl_request_ops *ops;
+	struct ethnl_req_info *req_info;
+	struct sk_buff *skb;
+	void *reply_payload;
+	int reply_len;
+	int ret;
+
+	if (WARN_ONCE(cmd > ETHTOOL_MSG_KERNEL_MAX ||
+		      !ethnl_default_notify_ops[cmd],
+		      "unexpected notification type %u\n", cmd))
+		return;
+	ops = ethnl_default_notify_ops[cmd];
+	req_info = kzalloc(ops->req_info_size, GFP_KERNEL);
+	if (!req_info)
+		return;
+	reply_data = kmalloc(ops->reply_data_size, GFP_KERNEL);
+	if (!reply_data) {
+		kfree(req_info);
+		return;
+	}
+
+	req_info->dev = dev;
+	req_info->flags |= ETHTOOL_FLAG_COMPACT_BITSETS;
+
+	ethnl_init_reply_data(reply_data, ops, dev);
+	ret = ops->prepare_data(req_info, reply_data, NULL);
+	if (ret < 0)
+		goto err_cleanup;
+	reply_len = ops->reply_size(req_info, reply_data);
+	if (ret < 0)
+		goto err_cleanup;
+	ret = -ENOMEM;
+	skb = genlmsg_new(reply_len, GFP_KERNEL);
+	if (!skb)
+		goto err_cleanup;
+	reply_payload = ethnl_bcastmsg_put(skb, cmd);
+	if (!reply_payload)
+		goto err_skb;
+	ret = ethnl_fill_reply_header(skb, dev, ops->hdr_attr);
+	if (ret < 0)
+		goto err_msg;
+	ret = ops->fill_reply(skb, req_info, reply_data);
+	if (ret < 0)
+		goto err_msg;
+	if (ops->cleanup_data)
+		ops->cleanup_data(reply_data);
+
+	genlmsg_end(skb, reply_payload);
+	kfree(reply_data);
+	kfree(req_info);
+	ethnl_multicast(skb, dev);
+	return;
+
+err_msg:
+	WARN_ONCE(ret == -EMSGSIZE,
+		  "calculated message payload length (%d) not sufficient\n",
+		  reply_len);
+err_skb:
+	nlmsg_free(skb);
+err_cleanup:
+	if (ops->cleanup_data)
+		ops->cleanup_data(reply_data);
+	kfree(reply_data);
+	kfree(req_info);
+	return;
+}
+
 /* notifications */
 
 typedef void (*ethnl_notify_handler_t)(struct net_device *dev, unsigned int cmd,
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 3448029e3ea2..72df4ffefe30 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -300,7 +300,9 @@ static inline void ethnl_ops_complete(struct net_device *dev)
  * unified infrastructure. When used, a pointer to an instance of this
  * structure is to be added to &ethnl_default_requests array and generic
  * handlers ethnl_default_doit(), ethnl_default_dumpit(),
- * ethnl_default_start() and ethnl_default_done() used in @ethtool_genl_ops.
+ * ethnl_default_start() and ethnl_default_done() used in @ethtool_genl_ops;
+ * ethnl_default_notify() can be used in @ethnl_notify_handlers to send
+ * notifications of the corresponding type.
  */
 struct ethnl_request_ops {
 	u8			request_cmd;
-- 
2.24.1

