Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5E53D41B3
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 22:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhGWUI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 16:08:56 -0400
Received: from mail-eopbgr130048.outbound.protection.outlook.com ([40.107.13.48]:38674
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229461AbhGWUIz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 16:08:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJPVqHSzo4wWPmZQGFjQ53++h6lRLXDEmbwssL4Ma8Kn4Jm2x0Sy7BSmS1MjXdPJsGXujAg4Z+BP4EbxFPFQyNO+YcO26Yp0NjUQXwQlCDFM8l4yr7YP1kb4FCEBC6lEnFFFMzSeEdsdmOPXmsXAtC5S7vNmVpKMjUeeoAQ5bY0lAjIOWRt9qg3YzWq5g1T0w081jweceDfXYQ9evs5sFkJCClggKQ2VYXhtAlwV3zU1EVsxPGQu67/tDtMu7RxD0oSn2MWeZBSuuNokQadRD2vysiMar8zvD8WZTWEGHVBWl58R2m3n2D86ihgYE1IJ4QFJZnUPWCqtaZH4ERnL9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmrlvSnXkakUKZ93sT1RJo8+DwxzGtFpOoO1S2GBF0Y=;
 b=G1pexCgx2WMburx789Bpu8UQUomkCPjt53WtGL2O+1HxSY6EP1E8PbGeLy9pURSmtmTj52+PJ0DX3ZkzyffplGrUZtqGBhYARxikHCkqfsZ9gsJtJFhiQx8DumPv7FEu3hAL3Y3O06JNFQLD9diDAjxwTK7wmNg6GNZEz+mObEKcX5QDMei4r3YX/4WituitXXngfYWGUZ86cclDjIJq21Ctc77aAe3jnHHD/P9+AFmrCPyRoOH7MhH0VC/01aIkKHpJqOv6xFCTLs6JFP+VYi4BqLe2ph2Mgm8m6D60GsYBjRz4Uc4hqU+UiNIY90LiDWjjPMeAWxXTtjZDs5tJfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SmrlvSnXkakUKZ93sT1RJo8+DwxzGtFpOoO1S2GBF0Y=;
 b=agu7M+GzO3q6bmGY2ZEQBUGDdw1EQ8KSpIPonHBhPzgWCoTzPUU0i6aMcs8UJ16P4wTEjU67Ms5mG35pJ9KugPuhy0ltqq0gFFEq3/jNb+WVFDU+TTyJ7bopRJ7DI175lB9OjaDYNuiPYsTEmRCFa3URnN2at20vZv4PwGOfiRQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2688.eurprd04.prod.outlook.com (2603:10a6:800:59::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Fri, 23 Jul
 2021 20:49:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.028; Fri, 23 Jul 2021
 20:49:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] net: bridge: fix build when setting skb->offload_fwd_mark with CONFIG_NET_SWITCHDEV=n
Date:   Fri, 23 Jul 2021 23:49:11 +0300
Message-Id: <20210723204911.3884995-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0095.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR06CA0095.eurprd06.prod.outlook.com (2603:10a6:208:fa::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Fri, 23 Jul 2021 20:49:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb4ed34b-5ff8-45ac-e180-08d94e1b5b3c
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2688:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2688910A8EEFD3AF0E71EA5EE0E59@VI1PR0401MB2688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qf7omc8fBVwC4izRF/ZkGvkYcSyxU2XWFQ7+np7tQ31R0KqqbRTKR15cjrZFH0bKiC/X3E0Mvif94CUXSW/Z4E9Xe24X7vI6/vc20trvLX3XzSGM7XSwV8IiBtP8+5c8SN8Njw9c/ljycIgI2tsNkKEh60Q3QT+c/XpOrYbHtdVp/GLL1K/LIxeHj9CuCu6356WV+8ExuT3jxFzreEGmREHiLVuBUFvH+Si+NYjq/Vm59zvd3nuD5alGyE1r4VBRL4UQ8jxRRq6SrO1/J+EQc1+eNM9g5yIcGLak/Ls+KwGoHo1v3e03KGF6N1fcsP2r8chUGrsXa5FQjn5b8SCebC8NS3U9XOwU9KKMCHLTAe8tIXv2ApTB8w5ig3o2rUL/MWtgUMI/iNqKjKA0wpfwZOHJBCsDI9c58wwnyZiprnu8QHjigONApcXAuznd+Gcanr6qOk8uRNYoEUs6vmjxxFKP3cmf/cpALEk7h9olLaykFXILnO7QYdZD6u0EXY8i8JGFH7N9H0aELkqxxZzG0qxhy83510S+Ch2vXFrZ0qjpGjtNH0N4T65WZxRXzDVyBwTWb4rP+/NDw6YtPZnXeOTssfQAxkXtT+rgG2I0S2G0Z3+7u34kygbRknNDP4fYjElCvVqfufJB5wIhcHZFaA1bGqvwSxbe8ubEX0DugEDArWptV0Cw8FZ+QACs7pDio0B5i+PXHdj5zJ164qd+cg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(346002)(396003)(366004)(136003)(956004)(86362001)(186003)(2616005)(83380400001)(4326008)(44832011)(6506007)(54906003)(5660300002)(110136005)(8936002)(6512007)(316002)(38100700002)(6486002)(38350700002)(8676002)(6666004)(2906002)(478600001)(52116002)(26005)(36756003)(66556008)(1076003)(66946007)(66476007)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GriPipstKaAlE8WrvaXk7lTrVWSrEEufH6dTDFMt9bs1FnApJipBypZqIfcS?=
 =?us-ascii?Q?bjSEoqEm80r/OcvDBf6wuSfYyY9zETu2VZQklWBMIwD92OzwCUO2/0ggoFyr?=
 =?us-ascii?Q?FmFm+TgvQpEbCWV7DAZ+NBEk4i8QjUELAFQtCvW4HI9vcMVdsLg2Cf8sq0gI?=
 =?us-ascii?Q?2iAW+yT22lDXajvlkKSzKtZd4thIwGW9ThC0iz7y0dEfL5QQfaKPqFFrpWKA?=
 =?us-ascii?Q?6iECJ3Chk474u0xZPg2UpGUe7Gw9EQ/SshLdkPgDJ5KrLoLLmHPrvzyD1Zuk?=
 =?us-ascii?Q?M8VVi5m876GjsglQT+/Mq8NEhO7RMsDujYWDL6VegmiH3ygawHR0Y76bTXo7?=
 =?us-ascii?Q?64W+boFKk/uixYsi+EDm8BZ65XmNmIOMUXHKNdnxykCCr7o63fh1uGiTI0t9?=
 =?us-ascii?Q?eZt5Q9EBn1NNZZITnopCroIv6s+Qx+fSubL2CDn6bUwaD6u85n362+d/FezA?=
 =?us-ascii?Q?o5GLbKT16HZqK8XMroij4HAoo8BiDvIyDQwwCmOgu74b4PuiZN/K1NjzFIFj?=
 =?us-ascii?Q?pwr7DSAZYnWmkb03+T4C11Gmt4jrNWvRdyrFVtMW/tSwr4naaZFYfvK4qX5r?=
 =?us-ascii?Q?ei05IBSRWoN9zlc3Bh/yODcGt1k0v45erO9+9fbca+lp7uowea0dWQt37zXl?=
 =?us-ascii?Q?tfEKVz9xgbLxZAzqYy8e6MliqEaasI05GM7yufW1TD0rm2Yz6FRll4wuDmfP?=
 =?us-ascii?Q?kCCDTk5TDQD85KIMOQxorNZsIoV31Z/scO6/dhNEwXH/v1Q4h+LWA42/1YGx?=
 =?us-ascii?Q?RR2zOEUHCuDHsszLRoAPIYzJkFnqQYjBs9w3t5JsY6QkX2Xi25Id5sHq+FMn?=
 =?us-ascii?Q?aJeQCqrXadIBPWVktT8OhENu0jIFag8x0AEOt7iaGYY+13n3izN3lJF+HnQe?=
 =?us-ascii?Q?0HmO/tvIZUcCIwZp3ocxxsQlCuaZ2Gy6Jh3RQp9n4P6Ub9ZjxzqSchjTUFwy?=
 =?us-ascii?Q?r06zO7NocMUOgms+VwrZjFXkVZWDB5dbUpcLIN+/FOaDGUbWFt8cIBLlE5w+?=
 =?us-ascii?Q?lAbu2CgjHR5M3aKwVOPtywgVzP2GfTL8VRHa0lo4DN9tHYXbv4q9qUXFoBFX?=
 =?us-ascii?Q?JFR1+S3/5E2Ejqqx8TmRgc97l4Y6nrTqnxCDNqLEPTZaaz5BzqpOr5Vv8h+z?=
 =?us-ascii?Q?0xe6F5IuR17n/Zmj6QIhcOrcBUZ184i9g7ik+PgocMWjT8TNnpfg4QqAbpgJ?=
 =?us-ascii?Q?aXNDc/Tund3u/X5VCntWNMQrkAjSZ12139bfd/YZ2u4LqUaeIV9DvV9G+bF/?=
 =?us-ascii?Q?N1oF/M5wfbBAtd65fHmRYQiV3MYBegpfMh8LSNctfyWidbb59GXo1IyEXKQn?=
 =?us-ascii?Q?XSiIb3MAP0gMJVLf+qWj+2fK?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb4ed34b-5ff8-45ac-e180-08d94e1b5b3c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2021 20:49:25.3574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPALsq6vQ9rujGYgEYB2zpyY4T+nC8Re1I1phXneSwogk8uvfP+PY7wQcKtfbBlXR2gsoQJ0hWKkwIQMnX/x1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switchdev support can be disabled at compile time, and in that case,
struct sk_buff will not contain the offload_fwd_mark field.

To make the code in br_forward.c work in both cases, we do what is done
in other places and we create a helper function, with an empty shim
definition, that is implemented by the br_switchdev.o translation module.
This is always compiled if and only if CONFIG_NET_SWITCHDEV is y or m.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 472111920f1c ("net: bridge: switchdev: allow the TX data plane forwarding to be offloaded")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_forward.c   | 2 +-
 net/bridge/br_private.h   | 6 ++++++
 net/bridge/br_switchdev.c | 5 +++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index bc14b1b384e9..ec646656dbf1 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -48,7 +48,7 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb
 		skb_set_network_header(skb, depth);
 	}
 
-	skb->offload_fwd_mark = br_switchdev_frame_uses_tx_fwd_offload(skb);
+	br_switchdev_frame_set_offload_fwd_mark(skb);
 
 	dev_queue_xmit(skb);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 86ca617fec7a..1c57877270f7 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1881,6 +1881,8 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 #ifdef CONFIG_NET_SWITCHDEV
 bool br_switchdev_frame_uses_tx_fwd_offload(struct sk_buff *skb);
 
+void br_switchdev_frame_set_offload_fwd_mark(struct sk_buff *skb);
+
 void nbp_switchdev_frame_mark_tx_fwd_offload(const struct net_bridge_port *p,
 					     struct sk_buff *skb);
 void nbp_switchdev_frame_mark_tx_fwd_to_hwdom(const struct net_bridge_port *p,
@@ -1910,6 +1912,10 @@ static inline bool br_switchdev_frame_uses_tx_fwd_offload(struct sk_buff *skb)
 	return false;
 }
 
+static inline void br_switchdev_frame_set_offload_fwd_mark(struct sk_buff *skb)
+{
+}
+
 static inline void
 nbp_switchdev_frame_mark_tx_fwd_offload(const struct net_bridge_port *p,
 					struct sk_buff *skb)
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 96ce069d0c8c..9cf9ab320c48 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -28,6 +28,11 @@ bool br_switchdev_frame_uses_tx_fwd_offload(struct sk_buff *skb)
 	return BR_INPUT_SKB_CB(skb)->tx_fwd_offload;
 }
 
+void br_switchdev_frame_set_offload_fwd_mark(struct sk_buff *skb)
+{
+	skb->offload_fwd_mark = br_switchdev_frame_uses_tx_fwd_offload(skb);
+}
+
 /* Mark the frame for TX forwarding offload if this egress port supports it */
 void nbp_switchdev_frame_mark_tx_fwd_offload(const struct net_bridge_port *p,
 					     struct sk_buff *skb)
-- 
2.25.1

