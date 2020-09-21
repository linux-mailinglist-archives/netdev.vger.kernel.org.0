Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7EF3273573
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:07:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgIUWHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:07:43 -0400
Received: from mail-am6eur05on2049.outbound.protection.outlook.com ([40.107.22.49]:44480
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726452AbgIUWHm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 18:07:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HElNu757BH+1Pv4zqhGcUMCBY9N/UX7ye+E3c5tef5sUC1BZD7M+9ktYdSPnyidCNwLs/e/YsfPrli+1v58xh3r0mJwY8xtp3veoT5WcnKlxCAAxz+V0Qfgj1Vun7z+xCYhzD11n0ItXM+2fWOcsCNPw8QQlXXUhIyYQvZ8SuHwJetiSv49FWpftuQfF65a5ndXUulDwhjQt5RWCiOYHO/DqdYi2hoo4QS8r+SIHShEJayF6H5WRosAeb+E2JCbjDw2jp678CQ4OBbq0KhyvCTaoqYWsjyC5W/apW2Tt47gT0cFiSl25HWWd0wZrRwE315d91HCidDzXUFQOtTm3oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyqYoIKcaZJUCaGHa3FACxigWAPdwdV78l+9+Do5NwU=;
 b=S+ObP38gbafN4sGQl+7kIk8nFblj+R3cpXvhWeDzoTv3vSCe4RcrFiPNdFTA7NTkBt+Wzj2pqFC9RzxAeFJETsJjcvWQfkSdjVWGqmvcr6LhujLO56Wqacv0GLpzdGb1FMNUyKvUcy2fntuMoLUg/MnQf57IsAufJLAoY2FU+KB7Vje5rufYYc83GpQQEtmkVD0Czb6w6HRwYqQyPXHkUldwSjpBkMCK3UvvcF37MvZ/LZRaKprr/6WC3M40vBGdI0EQnyu/MW8XCNR6IIXcD2VVk5eEz6VExqUclcRqSjRMPtzh9+YBudiPZk03t/1nQS4O0s8v8aSAqKyQqW4i3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyqYoIKcaZJUCaGHa3FACxigWAPdwdV78l+9+Do5NwU=;
 b=PfA7IZhwibCMwS3Mgyd8nu1LGzGCh3rkN8/lCOa9q/RQMnzAUZo3B2oeFRttsWgNb7bjeG7w5WX2/FCJb9+wbDfVR9vmWeP3/AUmWBDnHLIxsL60UBUkukaAXGyA/Gg43tSSYcEfdRbZqxmMoaenzCWpwXLrWVGfLIebT56eiEc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Mon, 21 Sep
 2020 22:07:38 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Mon, 21 Sep 2020
 22:07:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net
Cc:     kuba@kernel.org, roopa@nvidia.com, nikolay@nvidia.com,
        pablo@netfilter.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: [PATCH net] net: bridge: br_vlan_get_pvid_rcu() should dereference the VLAN group under RCU
Date:   Tue, 22 Sep 2020 01:07:09 +0300
Message-Id: <20200921220709.96107-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0204.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::34) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1PR08CA0204.eurprd08.prod.outlook.com (2603:10a6:800:d2::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 22:07:37 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b7001825-ba84-49a9-9f8c-08d85e7ac080
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6941F31098A7A07658D5216EE03A0@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:421;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ak81YeU6oARzRi+HshEA+hjyP7qma5bgKfYze4fhZEU4oUl1PzYAi78hXgp2MizpCHaDaIAmX5pVerHWt8Rk+/iXe47Ibf4aesdaANyAnJptAKVrDu+K8JzLYvKAvPYfxeRHGAPPd8Ol7WJ+GbC2YpjU+6LzUl/nT5UBdsWkpdF4B2iWLW/UiE27tWmY+7j6up7H3j7XLg2vXGE68H54daCDxFg71dRWSsqSaE9am6SELyNYJ+IpvQaraysVBO5O9o469oo+NAjs9opWivOr+kq0LuVEZOvFSOkujpXFpHebXoUOyKJSgRV0xydzmLgGB9kwjSD2Q8Xx5jaZ4OLKp7JD63uWqVMFlYDnF5ioG2FtNTFfPaxwf6Xxjjpes0Xg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(8676002)(316002)(36756003)(83380400001)(8936002)(52116002)(5660300002)(2906002)(7416002)(6512007)(1076003)(478600001)(66556008)(66476007)(6666004)(956004)(2616005)(44832011)(69590400008)(6486002)(4326008)(86362001)(16526019)(66946007)(26005)(6506007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2ijqeiFRuIX/YxNwIywegbVcq8+EfhSqAfyqXBJY98mN5Hbf0efkx89BmJEJfFzccQnffCjIXi8anJqEuhjItIrmWRzWu5H8ksdMz0S1mLEc5TzfZRlIxqod2XBQ/064gPb/Ap70rs16ImtDB+Q4W94yBcoGg1cYqdI1dBptXiWkTqfoI/BnyUrYYJXl6gyFjc0P/EI7TZk6hZxQn85S44d+5PcRDoUKs8mj9TbagODl8YRPK7NAEB782eCnxPy3AbX/4q7+d4KTRp5fFnd/e1KQGnSGu5IL+EI2sQO6Cyn+vjDQPNbBtki6qCYOHfifE/+DpoHMhdRYtGltYA3me1xnkb5KLeAtj+FzUFYz5xr0jgnnDe/ZMyyav2xQVx0IPET/2gu9FyspeYU+3+hTz7g9tfqTFJoDmz3pZOPJn2d2V6NUOZ4eiEjxv59nzt70+CvWkrGfJqZVUimKnaXvZ3uA+UlRBXDDJRF9VM5Ec1MOcF5AsVvphe8NY92ZMHAbb0RHnUsLtxu3JkBMqYBME/R9FGSnFq+71r4ke992lEWGPmF+PRPoE5igGi2w7Uq8FPVhAWEOaf159z8wPcPqdHpTk6keTSV3ir/w/EAm4tFxkORDs39g43Sc5TsTjp+yFLuiq6ICAjqdiRlCfcr5ZQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7001825-ba84-49a9-9f8c-08d85e7ac080
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 22:07:38.3180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7sKpD27ib5P9kmyvU0JCl8BcZ2x/d7DW33KdSQS0rxjPTz44uA1Adx0F+DKre5XdxhWNCWVAbZhygo4YmQ9AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling the RCU brother of br_vlan_get_pvid(), lockdep warns:

=============================
WARNING: suspicious RCU usage
5.9.0-rc3-01631-g13c17acb8e38-dirty #814 Not tainted
-----------------------------
net/bridge/br_private.h:1054 suspicious rcu_dereference_protected() usage!

Call trace:
 lockdep_rcu_suspicious+0xd4/0xf8
 __br_vlan_get_pvid+0xc0/0x100
 br_vlan_get_pvid_rcu+0x78/0x108

The warning is because br_vlan_get_pvid_rcu() calls nbp_vlan_group()
which calls rtnl_dereference() instead of rcu_dereference(). In turn,
rtnl_dereference() calls rcu_dereference_protected() which assumes
operation under an RCU write-side critical section, which obviously is
not the case here. So, when the incorrect primitive is used to access
the RCU-protected VLAN group pointer, READ_ONCE() is not used, which may
cause various unexpected problems.

I'm sad to say that br_vlan_get_pvid() and br_vlan_get_pvid_rcu() cannot
share the same implementation. So fix the bug by splitting the 2
functions, and making br_vlan_get_pvid_rcu() retrieve the VLAN groups
under proper locking annotations.

Fixes: 7582f5b70f9a ("bridge: add br_vlan_get_pvid_rcu()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_vlan.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 199deb2adf60..002bbc93209d 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1288,11 +1288,13 @@ void br_vlan_get_stats(const struct net_bridge_vlan *v,
 	}
 }
 
-static int __br_vlan_get_pvid(const struct net_device *dev,
-			      struct net_bridge_port *p, u16 *p_pvid)
+int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid)
 {
 	struct net_bridge_vlan_group *vg;
+	struct net_bridge_port *p;
 
+	ASSERT_RTNL();
+	p = br_port_get_check_rtnl(dev);
 	if (p)
 		vg = nbp_vlan_group(p);
 	else if (netif_is_bridge_master(dev))
@@ -1303,18 +1305,23 @@ static int __br_vlan_get_pvid(const struct net_device *dev,
 	*p_pvid = br_get_pvid(vg);
 	return 0;
 }
-
-int br_vlan_get_pvid(const struct net_device *dev, u16 *p_pvid)
-{
-	ASSERT_RTNL();
-
-	return __br_vlan_get_pvid(dev, br_port_get_check_rtnl(dev), p_pvid);
-}
 EXPORT_SYMBOL_GPL(br_vlan_get_pvid);
 
 int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid)
 {
-	return __br_vlan_get_pvid(dev, br_port_get_check_rcu(dev), p_pvid);
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_port *p;
+
+	p = br_port_get_check_rcu(dev);
+	if (p)
+		vg = nbp_vlan_group_rcu(p);
+	else if (netif_is_bridge_master(dev))
+		vg = br_vlan_group_rcu(netdev_priv(dev));
+	else
+		return -EINVAL;
+
+	*p_pvid = br_get_pvid(vg);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(br_vlan_get_pvid_rcu);
 
-- 
2.25.1

