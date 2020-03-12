Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3D39183A38
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgCLUHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:07:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:45050 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgCLUHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:07:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CA829ABE7;
        Thu, 12 Mar 2020 20:07:38 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 71246E0C79; Thu, 12 Mar 2020 21:07:38 +0100 (CET)
Message-Id: <0ecad4d21fab1c8aaef043a2dbf043c6f9680d6c.1584043144.git.mkubecek@suse.cz>
In-Reply-To: <cover.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 01/15] ethtool: rename ethnl_parse_header() to
 ethnl_parse_header_dev_get()
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Mar 2020 21:07:38 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn pointed out that even if it's documented that
ethnl_parse_header() takes reference to network device if it fills it
into the target structure, its name doesn't make it apparent so that
corresponding dev_put() looks like mismatched.

Rename the function ethnl_parse_header_dev_get() to indicate that it
takes a reference.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/debug.c     |  6 ++++--
 net/ethtool/linkinfo.c  |  6 ++++--
 net/ethtool/linkmodes.c |  6 ++++--
 net/ethtool/netlink.c   | 12 ++++++------
 net/ethtool/netlink.h   |  7 ++++---
 net/ethtool/wol.c       |  5 +++--
 6 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/net/ethtool/debug.c b/net/ethtool/debug.c
index aaef4843e6ba..87f288ee20c8 100644
--- a/net/ethtool/debug.c
+++ b/net/ethtool/debug.c
@@ -102,8 +102,10 @@ int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info)
 			  info->extack);
 	if (ret < 0)
 		return ret;
-	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_DEBUG_HEADER],
-				 genl_info_net(info), info->extack, true);
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_DEBUG_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
 	if (ret < 0)
 		return ret;
 	dev = req_info.dev;
diff --git a/net/ethtool/linkinfo.c b/net/ethtool/linkinfo.c
index 5d16cb4e8693..2df420068cbb 100644
--- a/net/ethtool/linkinfo.c
+++ b/net/ethtool/linkinfo.c
@@ -121,8 +121,10 @@ int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info)
 			  info->extack);
 	if (ret < 0)
 		return ret;
-	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_LINKINFO_HEADER],
-				 genl_info_net(info), info->extack, true);
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_LINKINFO_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
 	if (ret < 0)
 		return ret;
 	dev = req_info.dev;
diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
index f049b97072fe..cb29cc8c5960 100644
--- a/net/ethtool/linkmodes.c
+++ b/net/ethtool/linkmodes.c
@@ -334,8 +334,10 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 			  info->extack);
 	if (ret < 0)
 		return ret;
-	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_LINKMODES_HEADER],
-				 genl_info_net(info), info->extack, true);
+	ret = ethnl_parse_header_dev_get(&req_info,
+					 tb[ETHTOOL_A_LINKMODES_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
 	if (ret < 0)
 		return ret;
 	dev = req_info.dev;
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 180c194fab07..8eca55122ef3 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -18,7 +18,7 @@ static const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_MAX + 1] = {
 };
 
 /**
- * ethnl_parse_header() - parse request header
+ * ethnl_parse_header_dev_get() - parse request header
  * @req_info:    structure to put results into
  * @header:      nest attribute with request header
  * @net:         request netns
@@ -33,9 +33,9 @@ static const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_MAX + 1] = {
  *
  * Return: 0 on success or negative error code
  */
-int ethnl_parse_header(struct ethnl_req_info *req_info,
-		       const struct nlattr *header, struct net *net,
-		       struct netlink_ext_ack *extack, bool require_dev)
+int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
+			       const struct nlattr *header, struct net *net,
+			       struct netlink_ext_ack *extack, bool require_dev)
 {
 	struct nlattr *tb[ETHTOOL_A_HEADER_MAX + 1];
 	const struct nlattr *devname_attr;
@@ -253,8 +253,8 @@ static int ethnl_default_parse(struct ethnl_req_info *req_info,
 			  request_ops->request_policy, extack);
 	if (ret < 0)
 		goto out;
-	ret = ethnl_parse_header(req_info, tb[request_ops->hdr_attr], net,
-				 extack, require_dev);
+	ret = ethnl_parse_header_dev_get(req_info, tb[request_ops->hdr_attr],
+					 net, extack, require_dev);
 	if (ret < 0)
 		goto out;
 
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 60efd87686ad..961708290074 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -10,9 +10,10 @@
 
 struct ethnl_req_info;
 
-int ethnl_parse_header(struct ethnl_req_info *req_info,
-		       const struct nlattr *nest, struct net *net,
-		       struct netlink_ext_ack *extack, bool require_dev);
+int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
+			       const struct nlattr *nest, struct net *net,
+			       struct netlink_ext_ack *extack,
+			       bool require_dev);
 int ethnl_fill_reply_header(struct sk_buff *skb, struct net_device *dev,
 			    u16 attrtype);
 struct sk_buff *ethnl_reply_init(size_t payload, struct net_device *dev, u8 cmd,
diff --git a/net/ethtool/wol.c b/net/ethtool/wol.c
index e1b8a65b64c4..1d2bcabee554 100644
--- a/net/ethtool/wol.c
+++ b/net/ethtool/wol.c
@@ -123,8 +123,9 @@ int ethnl_set_wol(struct sk_buff *skb, struct genl_info *info)
 			  wol_set_policy, info->extack);
 	if (ret < 0)
 		return ret;
-	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_WOL_HEADER],
-				 genl_info_net(info), info->extack, true);
+	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_WOL_HEADER],
+					 genl_info_net(info), info->extack,
+					 true);
 	if (ret < 0)
 		return ret;
 	dev = req_info.dev;
-- 
2.25.1

