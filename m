Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E23B26CF37
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 01:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgIPXEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 19:04:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:42266 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbgIPXEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 19:04:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EF587B3E0;
        Wed, 16 Sep 2020 23:04:25 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 34FCE6074F; Thu, 17 Sep 2020 01:04:10 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net] ethtool: add and use message type for tunnel info reply
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Message-Id: <20200916230410.34FCE6074F@lion.mk-sys.cz>
Date:   Thu, 17 Sep 2020 01:04:10 +0200 (CEST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tunnel offload info code uses ETHTOOL_MSG_TUNNEL_INFO_GET message type (cmd
field in genetlink header) for replies to tunnel info netlink request, i.e.
the same value as the request have. This is a problem because we are using
two separate enums for userspace to kernel and kernel to userspace message
types so that this ETHTOOL_MSG_TUNNEL_INFO_GET (28) collides with
ETHTOOL_MSG_CABLE_TEST_TDR_NTF which is what message type 28 means for
kernel to userspace messages.

As the tunnel info request reached mainline in 5.9 merge window, we should
still be able to fix the reply message type without breaking backward
compatibility.

Fixes: c7d759eb7b12 ("ethtool: add tunnel info interface")
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 Documentation/networking/ethtool-netlink.rst | 3 +++
 include/uapi/linux/ethtool_netlink.h         | 1 +
 net/ethtool/tunnels.c                        | 4 ++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d53bcb31645a..b5a79881551f 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -206,6 +206,7 @@ Userspace to kernel:
   ``ETHTOOL_MSG_TSINFO_GET``		get timestamping info
   ``ETHTOOL_MSG_CABLE_TEST_ACT``        action start cable test
   ``ETHTOOL_MSG_CABLE_TEST_TDR_ACT``    action start raw TDR cable test
+  ``ETHTOOL_MSG_TUNNEL_INFO_GET``       get tunnel offload info
   ===================================== ================================
 
 Kernel to userspace:
@@ -239,6 +240,7 @@ Kernel to userspace:
   ``ETHTOOL_MSG_TSINFO_GET_REPLY``	timestamping info
   ``ETHTOOL_MSG_CABLE_TEST_NTF``        Cable test results
   ``ETHTOOL_MSG_CABLE_TEST_TDR_NTF``    Cable test TDR results
+  ``ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY`` tunnel offload info
   ===================================== =================================
 
 ``GET`` requests are sent by userspace applications to retrieve device
@@ -1363,4 +1365,5 @@ are netlink only.
   ``ETHTOOL_SFECPARAM``               n/a
   n/a                                 ''ETHTOOL_MSG_CABLE_TEST_ACT''
   n/a                                 ''ETHTOOL_MSG_CABLE_TEST_TDR_ACT''
+  n/a                                 ``ETHTOOL_MSG_TUNNEL_INFO_GET``
   =================================== =====================================
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 5dcd24cb33ea..72ba36be9655 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -79,6 +79,7 @@ enum {
 	ETHTOOL_MSG_TSINFO_GET_REPLY,
 	ETHTOOL_MSG_CABLE_TEST_NTF,
 	ETHTOOL_MSG_CABLE_TEST_TDR_NTF,
+	ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
diff --git a/net/ethtool/tunnels.c b/net/ethtool/tunnels.c
index 84f23289475b..d93bf2da0f34 100644
--- a/net/ethtool/tunnels.c
+++ b/net/ethtool/tunnels.c
@@ -200,7 +200,7 @@ int ethnl_tunnel_info_doit(struct sk_buff *skb, struct genl_info *info)
 	reply_len = ret + ethnl_reply_header_size();
 
 	rskb = ethnl_reply_init(reply_len, req_info.dev,
-				ETHTOOL_MSG_TUNNEL_INFO_GET,
+				ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY,
 				ETHTOOL_A_TUNNEL_INFO_HEADER,
 				info, &reply_payload);
 	if (!rskb) {
@@ -273,7 +273,7 @@ int ethnl_tunnel_info_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 				goto cont;
 
 			ehdr = ethnl_dump_put(skb, cb,
-					      ETHTOOL_MSG_TUNNEL_INFO_GET);
+					      ETHTOOL_MSG_TUNNEL_INFO_GET_REPLY);
 			if (!ehdr) {
 				ret = -EMSGSIZE;
 				goto out;
-- 
2.28.0

