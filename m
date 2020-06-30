Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D6020F612
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388357AbgF3NqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:46:00 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:24581 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgF3Npu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:45:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593524749; x=1625060749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VjgLRTFAQQXiSnYU+FqcPS5U5gonGnZE5EKr2nGUPtg=;
  b=FEOMT7UW6LXvBHAK0lvByMdT9iyQJSMWxSeJN/fmiezwerLGkopUXqTs
   vIh+4o2yHw14GTGHdzj6ZE98FbpcpP6UVlRNJ5nbQU/4YqU0h7jAWpcJQ
   quunuU8wM88cCj0LxKC8zjNdd67kP9QyI8WV8SesAru3oxj1DhxSw90fR
   mvEoKCd3XKUB6gKmraAgo+7QA1f7Yoq/4h3BBSUQxR5ux+98rgvwIfJZO
   g4lVS3nzDN4nJ7rZVFIljO6rGXudgo23LkgUpw1tQ9nlcxOg+Z/ykkD1u
   TK90M9lwN0HIoIVjvn2NFP0LbJRavPU6s5PIHZZCN8ZtCz4pjWQBOH4Rs
   A==;
IronPort-SDR: 5ygEpwWPXOr7Wu4DXeUlN2lTcfdOUhKsXzVZRXphi76hYgwZQfN8mEvK+6tu5Igs+9YSqlHyHd
 Vn1FR/4QQXlFBPBT/s9AZmW9Xtqoxv0tduCD9L/9AkcGhtLPfm0cTOA6x/M/86gO/TUV5ktWbC
 CmvVAYmHCSSp9PZ2mTH6QoKsHmLRuDw3Z5U+cYCHPezdv7nk7gTDb6KzorjN6OdWD3Xh05S4/r
 w0IbANCcXxPq8ckh3QyME03AyQKNfGKv0mHFRBBT8hV5IFppTnt8+vTjH8Bfw7M9Yz0GIg4f6N
 Pyo=
X-IronPort-AV: E=Sophos;i="5.75,297,1589266800"; 
   d="scan'208";a="82064270"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2020 06:45:48 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 06:45:30 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 30 Jun 2020 06:45:45 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <roopa@cumulusnetworks.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <jiri@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 3/3] bridge: Extend br_fill_ifinfo to return MPR status
Date:   Tue, 30 Jun 2020 15:44:24 +0200
Message-ID: <20200630134424.4114086-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200630134424.4114086-1-horatiu.vultur@microchip.com>
References: <20200630134424.4114086-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the function br_fill_ifinfo to return also the MRP
status for each instance on a bridge. It also adds a new filter
RTEXT_FILTER_MRP to return the MRP status only when this is set, not to
interfer with the vlans. The MRP status is return only on the bridge
interfaces.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 include/uapi/linux/rtnetlink.h |  1 +
 net/bridge/br_netlink.c        | 29 ++++++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 879e64950a0a2..9b814c92de123 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -778,6 +778,7 @@ enum {
 #define RTEXT_FILTER_BRVLAN	(1 << 1)
 #define RTEXT_FILTER_BRVLAN_COMPRESSED	(1 << 2)
 #define	RTEXT_FILTER_SKIP_STATS	(1 << 3)
+#define RTEXT_FILTER_MRP	(1 << 4)
 
 /* End of information exported to user level */
 
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 240e260e3461c..6ecb7c7453dcb 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -453,6 +453,32 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 		rcu_read_unlock();
 		if (err)
 			goto nla_put_failure;
+
+		nla_nest_end(skb, af);
+	}
+
+	if (filter_mask & RTEXT_FILTER_MRP) {
+		struct nlattr *af;
+		int err;
+
+		/* RCU needed because of the VLAN locking rules (rcu || rtnl) */
+		rcu_read_lock();
+		if (!br_mrp_enabled(br) || port) {
+			rcu_read_unlock();
+			goto done;
+		}
+		af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
+		if (!af) {
+			rcu_read_unlock();
+			goto nla_put_failure;
+		}
+
+		err = br_mrp_fill_info(skb, br);
+
+		rcu_read_unlock();
+		if (err)
+			goto nla_put_failure;
+
 		nla_nest_end(skb, af);
 	}
 
@@ -516,7 +542,8 @@ int br_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 	struct net_bridge_port *port = br_port_get_rtnl(dev);
 
 	if (!port && !(filter_mask & RTEXT_FILTER_BRVLAN) &&
-	    !(filter_mask & RTEXT_FILTER_BRVLAN_COMPRESSED))
+	    !(filter_mask & RTEXT_FILTER_BRVLAN_COMPRESSED) &&
+	    !(filter_mask & RTEXT_FILTER_MRP))
 		return 0;
 
 	return br_fill_ifinfo(skb, port, pid, seq, RTM_NEWLINK, nlflags,
-- 
2.27.0

