Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028991DB121
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgETLLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:11:22 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:4072 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETLLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1589973080; x=1621509080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C39MMHsI3O/BWeqgZ3MtgggX0ZxcDyUus7tnUs3PLL8=;
  b=hCPDQAXkE2XLeCCsDySNraZzDboJLNWRMw3pNqYvHp5W/el2l8EojwKw
   BMfZl1hG4godSTX70Yi3JZ2ZLhbvXXXVedyLw8gm22ANIbfdR2iA09bUG
   tKCmtuus62/+n/kwkjU4dvSTt2mIZeWFBgAHWBpM74mHLGCn/2jJShWc6
   TXEBHL4uxMjMlUw1aRb1o/Xo/eRiRWpCNH430/vzipJFaDVe/OdHTmz8+
   abPId47ZOhzQQktZH2Qo5FvzI14iIUePvPtowGnd2e/7MX/nYD5p2LAIZ
   63zlPnnA06RtM51OiAIzQMy8vRgyriEIwZNUh8bMbYBK8eZk8164crx3r
   Q==;
IronPort-SDR: jTTD4snNdQMebfH3I9RQA3ZKf1ZOvpCIsMuA1lKGlRshoxXqD+n5z9Rt+D+PDn5SIkojdlyLYd
 AQOlTfrs3rOOWczCvEUQUIf8RWCGaWenYt+BpLQ2CYuPvC+bzzb8dmJhLlx5c9D/FvYzsbOZkk
 18WtYBh+cwml4/Tgu57xEE5BfukcZoCcF5tXGUTWJbiN0UtEkm4OMkzrJI0mFC+NDosoQq6vPu
 VXNT6Bh9PI0d8T4jsyX5bygno9ErBD+ulPnV/Fadnq2ne7hmqEyxoM/Z6pu4lQ+Q1KPPvHRDDd
 njc=
X-IronPort-AV: E=Sophos;i="5.73,413,1583218800"; 
   d="scan'208";a="77278934"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 May 2020 04:11:19 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 20 May 2020 04:11:19 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 20 May 2020 04:11:17 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@cumulusnetworks.com>,
        <nikolay@cumulusnetworks.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH 1/3] bridge: mrp: Add br_mrp_unique_ifindex function
Date:   Wed, 20 May 2020 13:09:21 +0000
Message-ID: <20200520130923.3196432-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520130923.3196432-1-horatiu.vultur@microchip.com>
References: <20200520130923.3196432-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not allow to have the same net bridge port part of multiple MRP
rings. Therefore add a check if the port is used already in a different
MRP. In that case return failure.

Fixes: 9a9f26e8f7ea ("bridge: mrp: Connect MRP API with the switchdev API")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index d7bc09de4c139..a5a3fa59c078a 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -37,6 +37,32 @@ static struct br_mrp *br_mrp_find_id(struct net_bridge *br, u32 ring_id)
 	return res;
 }
 
+static bool br_mrp_unique_ifindex(struct net_bridge *br, u32 ifindex)
+{
+	struct br_mrp *mrp;
+	bool res = true;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(mrp, &br->mrp_list, list,
+				lockdep_rtnl_is_held()) {
+		struct net_bridge_port *p;
+
+		p = rcu_dereference(mrp->p_port);
+		if (p && p->dev->ifindex == ifindex) {
+			res = false;
+			break;
+		}
+
+		p = rcu_dereference(mrp->s_port);
+		if (p && p->dev->ifindex == ifindex) {
+			res = false;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return res;
+}
+
 static struct br_mrp *br_mrp_find_port(struct net_bridge *br,
 				       struct net_bridge_port *p)
 {
@@ -255,6 +281,11 @@ int br_mrp_add(struct net_bridge *br, struct br_mrp_instance *instance)
 	    !br_mrp_get_port(br, instance->s_ifindex))
 		return -EINVAL;
 
+	/* It is not possible to have the same port part of multiple rings */
+	if (!br_mrp_unique_ifindex(br, instance->p_ifindex) ||
+	    !br_mrp_unique_ifindex(br, instance->s_ifindex))
+		return -EINVAL;
+
 	mrp = kzalloc(sizeof(*mrp), GFP_KERNEL);
 	if (!mrp)
 		return -ENOMEM;
-- 
2.26.2

