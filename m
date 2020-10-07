Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E31285EC7
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 14:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgJGMJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 08:09:01 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:4619 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgJGMJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 08:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602072540; x=1633608540;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=A71AhQGOkyGRAStPfAC/MBymcrQUUaFkVYzBRt+XfEQ=;
  b=kTU7lhXA3LOq3XVwjI40xKX70G+yx4xIEdewrNMe8MftvT+i5JPu3Uq1
   Hi0v7cw4MqQYSVQgUorfSXh6gCDKjFPXP11hwny7XaSDFh73c9B2NTLnA
   uFZHhjKltHQs4RmgM4HQtJedLEnEyZCBUmev+34iZQ/WAYYn7RTihhdDf
   wgUZsrG9m0Hu32N+4i87YSjPBCTqewobzuKI4zIYCi8qmHUyusfX6GK1f
   p48sz500t8dMy0Kmd14kdRxaDKrX0WGwduIzJAlA+wR7zdN5hooJ+U5tW
   9u426z5VF13VBv/eC4C1XClxzS8EyK+l4iRfjPws1sokKX2rsuHeAGkwR
   w==;
IronPort-SDR: MVED8K5dwWFYbf9sRKQTR91Se/3uRplPnp+38da0V067VpLPRobQtbGObD2D6ehn0ClM1GFDcm
 MrGimQf7ho+22YM7iRE7KCamo0SMyolwhM/E1rCO+oRK+UkK8FokafsbmHwxlUwIaQ9Ah2pY8n
 pu6Fgs0m5U7ZueNG+sttMQyPPFSosIocCwKZAeFzx9GkKbnE4orOCmeaApyUja5OwGNqspQgw7
 /shmV8/l3FQc9diU/pBw46SH7cJdoOgTIua+uClgBeBXybpCv9defpmbqaz3srX7X/VC6EQ3/6
 fSc=
X-IronPort-AV: E=Sophos;i="5.77,346,1596524400"; 
   d="scan'208";a="29045901"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2020 05:08:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 7 Oct 2020 05:08:42 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 7 Oct 2020 05:08:39 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <kuba@kernel.org>, <bridge@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net] bridge: Netlink interface fix.
Date:   Wed, 7 Oct 2020 12:07:00 +0000
Message-ID: <20201007120700.2152699-1-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit is correcting NETLINK br_fill_ifinfo() to be able to
handle 'filter_mask' with multiple flags asserted.

Fixes: 36a8e8e265420 ("bridge: Extend br_fill_ifinfo to return MPR status")

Signed-off-by: Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Suggested-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Tested-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_netlink.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 8a71c60fa357..92d64abffa87 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -380,6 +380,7 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 			  u32 filter_mask, const struct net_device *dev)
 {
 	u8 operstate = netif_running(dev) ? dev->operstate : IF_OPER_DOWN;
+	struct nlattr *af = NULL;
 	struct net_bridge *br;
 	struct ifinfomsg *hdr;
 	struct nlmsghdr *nlh;
@@ -423,11 +424,18 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 		nla_nest_end(skb, nest);
 	}
 
+	if (filter_mask & (RTEXT_FILTER_BRVLAN |
+			   RTEXT_FILTER_BRVLAN_COMPRESSED |
+			   RTEXT_FILTER_MRP)) {
+		af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
+		if (!af)
+			goto nla_put_failure;
+	}
+
 	/* Check if  the VID information is requested */
 	if ((filter_mask & RTEXT_FILTER_BRVLAN) ||
 	    (filter_mask & RTEXT_FILTER_BRVLAN_COMPRESSED)) {
 		struct net_bridge_vlan_group *vg;
-		struct nlattr *af;
 		int err;
 
 		/* RCU needed because of the VLAN locking rules (rcu || rtnl) */
@@ -441,11 +449,6 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 			rcu_read_unlock();
 			goto done;
 		}
-		af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
-		if (!af) {
-			rcu_read_unlock();
-			goto nla_put_failure;
-		}
 		if (filter_mask & RTEXT_FILTER_BRVLAN_COMPRESSED)
 			err = br_fill_ifvlaninfo_compressed(skb, vg);
 		else
@@ -456,32 +459,25 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 		rcu_read_unlock();
 		if (err)
 			goto nla_put_failure;
-
-		nla_nest_end(skb, af);
 	}
 
 	if (filter_mask & RTEXT_FILTER_MRP) {
-		struct nlattr *af;
 		int err;
 
 		if (!br_mrp_enabled(br) || port)
 			goto done;
 
-		af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
-		if (!af)
-			goto nla_put_failure;
-
 		rcu_read_lock();
 		err = br_mrp_fill_info(skb, br);
 		rcu_read_unlock();
 
 		if (err)
 			goto nla_put_failure;
-
-		nla_nest_end(skb, af);
 	}
 
 done:
+	if (af)
+		nla_nest_end(skb, af);
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.28.0

