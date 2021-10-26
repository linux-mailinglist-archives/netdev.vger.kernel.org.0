Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3ABD43B406
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbhJZOaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:30:52 -0400
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:7181
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236543AbhJZOal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:30:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oT33cRSsc94KMh/J22r9rlwX7T9GC4+dEpFmJ9rIacr8rNvZSRuTn4VFDc+fUevUQLBLHVRTp1ZH7kxuGEX6fKJ8ubr+ZTDVDTycWXxuSui31JEsbQJfJ6bf/F6tUqJo3c7ZDX76FpLlyGcJ87fbXlD/6nelNXvKmBRtHtPVcbrr5dbbRg1dNxDZO0+3DQhMZR1amNxkfz1qdNFjpAlwo2pggUgD0QXzdx5fJ/2EvQUPRqX+Sf8LoJW7BZ7W29ZkN08BisRIb5C3Jn42Hdxhsw6s4/Omq3s0wBgyAENhkWkvOoLy7/JONjkqLJ+6orK01wOnHVEE8CUx9FyJ7J76Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kHBvT8BxeXWGQ0empmTbvOfC3toGi8TqJViyJrKNAsk=;
 b=b2UBYlXxjtwHF23z3HHxeB/00u2aP3qgwKEKwC9JECLY/p94blLSqGX47qWapK8aYuW2+VPo1rGRrzwSzT1TALVDVPEs0zAf9ois6E+/VQdbyzFlH06AybmB1YWL3jg82NDfNzxNNwDyJSJuxeOUWN5hUvxCNGKOFgbdqqHS8vwDgTxK/aUSsaCUavr/n2nOItGN8T7BCGkiHowoS0u2hy+akeK5X9lMSrc5AU1tI5rXUTKuuVucL+MDS67SXhQuFLXirmnaL8SI4HuQmSgIpFaA/dduayhxwygGETIIcLL68DTN3ZEQhP/M/j9dwcHe9rjZvFYly5uM+FjUBlwv6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHBvT8BxeXWGQ0empmTbvOfC3toGi8TqJViyJrKNAsk=;
 b=S4dVo405mvpVzq9umIpsKroSNVUdilmLWP7ghoClHj82qeIbtBvQ0/0jX7qb2OM0Huyy/FbZCH5UtNHDLOhe8bkAh6TK7dYtk1U4tcvS6C3QakWM3FAM6xzJmTXAlLDxH0wDXb+IQsrzWVwvrXnHoqeyjzasbg4Hjv0oRpCPz6E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3965.eurprd04.prod.outlook.com (2603:10a6:803:3e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Tue, 26 Oct
 2021 14:28:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 14:28:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 8/8] net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
Date:   Tue, 26 Oct 2021 17:27:43 +0300
Message-Id: <20211026142743.1298877-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0113.eurprd07.prod.outlook.com
 (2603:10a6:207:7::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0113.eurprd07.prod.outlook.com (2603:10a6:207:7::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.10 via Frontend Transport; Tue, 26 Oct 2021 14:28:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71acd12b-2e2a-4aaf-db44-08d9988cd7ae
X-MS-TrafficTypeDiagnostic: VI1PR04MB3965:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39659D1A390D1CA0A87AF525E0849@VI1PR04MB3965.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gND1A0sKCnB3TX7Nn1M9I8gpvAYjI2VEHaNytharnMJOYNNufsQJS/ukP0UJrn2i+H1A9X16l1b1bumMv4UBtSaVWm9jiielewZak+7qULLsD291DL8FkGEYLtFAyJI5AAtpzIVdemihyGZbLcAPgDeXqJLYjg+/4sdvehvvVfjLbHsa7pYn17/MgZeDk0wAw2kKTsiVcEjpOG0R3tzg5bIKcGUK/NQtr5j89ozNNrEDkQyHW88HWpURFUlP4sSFsvxzpbKgORUR8Lny146TyVTgiS2rfNL3roWXFykBDgys9Ckac8N3GmTm++OU4KsVWEiI7AzdO0rFGswmaScgVCZM8N45leubGlYIsZgmZpFFf2rxyiODHq57ML2mhmfH5kXjUXNSk688ZrG6mVcmnf2ZI0kyZMxyqKxe4UaZVXoyn6b6EyboWaF0guq+pKVH4FuF5Ihx69+y5pxgYs+ETrA4VVJVxSr6Vznb+FglWSAJ/3OLOGwkG3HAQZB2TKb+vP9zmgSzeFfhqKxKWosmb1QEQQ+SSJ0EJGqq9AxxGNNERv6G+XF61p8iva0C5HHoPeTaYdKcvVKE2wIqdkr0gWmDhs0YOqA9TJySLEoeweWMW5ErkXWAXJdYYu+vfYngAJ9Mkd/IyLVONtbE2bt4q6awJLrx180dFjELZReobVts6PyvP75p0ydLISsbv0OueH43us3h8dPIggtvuEXU/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6666004)(7416002)(1076003)(6506007)(83380400001)(316002)(52116002)(2616005)(8676002)(30864003)(4326008)(6512007)(38100700002)(66946007)(6916009)(508600001)(26005)(6486002)(36756003)(44832011)(956004)(54906003)(186003)(66476007)(66556008)(86362001)(5660300002)(8936002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+tyiHobURhAU/0fmBV1iK7KzoV7Ax4fmsJwTHcbbIkyLsmBqF7E/vQvR9Viw?=
 =?us-ascii?Q?9fSC8/vuwtWWQUHtkasgv+Dptgk2aBx6I3rUbPmY5+uI8h6hZM/IDX7Ywor1?=
 =?us-ascii?Q?3HhmJgVKizNmuBr16SbtPYWiYpKKh15xUrzR0hHpxGNyb4LbFU7FiXKxNTB3?=
 =?us-ascii?Q?QPaE3JBWfnTLv26T/qzfHm0c3Kp4OtB2NqkKIvgQZH57UlYGs7gAwlylBgsi?=
 =?us-ascii?Q?0huWXscOGDHJP4GycDYIIvEp097iHqlMBPR4r6W0Qj96eBnSffKde938GKNE?=
 =?us-ascii?Q?IsVFrxXn7NtZHasdhDDnLquEBlRljJoBhtlbZHrqIANIa4z5H5y4pku7qRnk?=
 =?us-ascii?Q?LHCR0xMr4gEid9eFBIWgzONjkZqQS/txwz6gjKNIBY+XLjl9dVwCCXqeh5Se?=
 =?us-ascii?Q?0WwGRgUVIGFVUKueWaHw4bww/nHqrKQBsofxgdHpk/qKf0S+Qni3wQycBJie?=
 =?us-ascii?Q?dl33kuQFXEvM6plxpxZtGPbD3NYoor4oI49yBP5tPXgcmstwAUYKTUHUyPOX?=
 =?us-ascii?Q?NykgJbmGnSGEy4XnB2o4kyZeaqCoHX5UuxpVkeWuCdHW94Pynh0WZ0aZlnPt?=
 =?us-ascii?Q?yDust/QmfvC07Jmx9yE3BFAq+Xii24iqNXutEnx3pE/bN3c1QtIPmbFGAXzF?=
 =?us-ascii?Q?dMQu+7B8vbmrbMlgDVszWdqFbS9ex8EvxHSfAyn8NiBFmyEUVU2iUY4RNmay?=
 =?us-ascii?Q?pgJBJJ8hhhyTNa8ZUHKHnmGV/+xPo+/j58s1k29xaiYEG/l6VEoCsrO8KaQp?=
 =?us-ascii?Q?YzRpnUm8pYrUWoJFj39gNUgSxdhU/bg4JHWuZWt6kJpRnV++kep2UVLoN4IS?=
 =?us-ascii?Q?FafZCF/bmbtZ4nmAI2w3897Uo5gOlT3yJFmwHaiA43AL9ekpRM3jF3JLlw4J?=
 =?us-ascii?Q?kzo+2i7R4iffYANSzPS7QEFGQDjufm2h/Mtx0fjJUlGrujw9lf7VnGMA8iRb?=
 =?us-ascii?Q?Qw+Yn8ZnC0UVSzdHi8bMp/GSL67d+UWtJyFOOzmvOlWurzbE/5W/v0DH7gLA?=
 =?us-ascii?Q?F4Yi+JcK5+xG036FzzJh7EDQhDzDsl6Fetqh6J+5gZtAhmkGF4fCJgp2EpAj?=
 =?us-ascii?Q?Oz4EnVb8EVuLcjeYw6entXHpm6HRnR9tU/zjec2PGt7jqxcBiV+M2bk/Pkuw?=
 =?us-ascii?Q?tryeKLwQ+nAL9r0nB2fg8mhJvrRFHQSgyOykhTjzp67L2cHahnWy/vAfgrjn?=
 =?us-ascii?Q?xdfAwMwSEMlUzDGS57VKeV2n+91+HVjCNt2oycNI/RIW9mDVAU0sJacbRIS4?=
 =?us-ascii?Q?BVJLR47YUeky7zvHjQJgNEVrxYAqjdS3VAfr3NYlt7Bk2ssn7W/jCkOswIKK?=
 =?us-ascii?Q?zcWs5apLQNs3il7hj3Rco2yujZeUzsYm2mzBF/ZfMVzoehtEyC7J2MmfO3jC?=
 =?us-ascii?Q?LxlcK2VGmUVegG2Mc17O3WEceKjXflk1rF06XcQNDc9frOZNmfyZ12y98aM6?=
 =?us-ascii?Q?Yw4RpIKCWcwFJaUNg8BX7TGwbkSXGtSA9HBgbGkXkZeKnPNHgwfHsESabxPu?=
 =?us-ascii?Q?fXES72ylYhljultVZ9B4ZLs8Ek+rhuw+OdlXJ3c9SlkGOSBM1UtLcZruYzDd?=
 =?us-ascii?Q?ZArPyp5vQNjx+Sn/fSMbLHFvbjHnLgSxSSzWtYEqL2pLfPn24r2dTDNT3OmI?=
 =?us-ascii?Q?6n/v0jCSNPMqtke/O20uBVg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71acd12b-2e2a-4aaf-db44-08d9988cd7ae
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 14:28:14.0674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AuR8970PSHuqx+eurDHdeoBahoMFFfRXmtkqQ4N6x+n3KL7mPDT+BjbFtqqHCIr0cxQ9bIz0c2UEBrqzq23NkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3965
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To reduce code churn, the same patch makes multiple changes, since they
all touch the same lines:

1. The implementations for these two are identical, just with different
   function pointers. Reduce duplications and name the function pointers
   "mod_cb" instead of "add_cb" and "del_cb". Pass the event as argument.

2. Drop the "const" attribute from "orig_dev". If the driver needs to
   check whether orig_dev belongs to itself and then
   call_switchdev_notifiers(orig_dev, SWITCHDEV_FDB_OFFLOADED), it
   can't, because call_switchdev_notifiers takes a non-const struct
   net_device *.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h   |  48 +++---------
 net/dsa/slave.c           |  41 ++--------
 net/switchdev/switchdev.c | 156 ++++++--------------------------------
 3 files changed, 43 insertions(+), 202 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 60d806b6a5ae..d353793dfeb5 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -299,28 +299,16 @@ void switchdev_port_fwd_mark_set(struct net_device *dev,
 				 struct net_device *group_dev,
 				 bool joining);
 
-int switchdev_handle_fdb_add_to_device(struct net_device *dev,
+int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event,
 		const struct switchdev_notifier_fdb_info *fdb_info,
 		bool (*check_cb)(const struct net_device *dev),
 		bool (*foreign_dev_check_cb)(const struct net_device *dev,
 					     const struct net_device *foreign_dev),
-		int (*add_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
+		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+			      unsigned long event, const void *ctx,
 			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_add_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info));
-
-int switchdev_handle_fdb_del_to_device(struct net_device *dev,
-		const struct switchdev_notifier_fdb_info *fdb_info,
-		bool (*check_cb)(const struct net_device *dev),
-		bool (*foreign_dev_check_cb)(const struct net_device *dev,
-					     const struct net_device *foreign_dev),
-		int (*del_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_del_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
+		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+				  unsigned long event, const void *ctx,
 				  const struct switchdev_notifier_fdb_info *fdb_info));
 
 int switchdev_handle_port_obj_add(struct net_device *dev,
@@ -426,32 +414,16 @@ call_switchdev_blocking_notifiers(unsigned long val,
 }
 
 static inline int
-switchdev_handle_fdb_add_to_device(struct net_device *dev,
-		const struct switchdev_notifier_fdb_info *fdb_info,
-		bool (*check_cb)(const struct net_device *dev),
-		bool (*foreign_dev_check_cb)(const struct net_device *dev,
-					     const struct net_device *foreign_dev),
-		int (*add_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_add_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
-{
-	return 0;
-}
-
-static inline int
-switchdev_handle_fdb_del_to_device(struct net_device *dev,
+switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event,
 		const struct switchdev_notifier_fdb_info *fdb_info,
 		bool (*check_cb)(const struct net_device *dev),
 		bool (*foreign_dev_check_cb)(const struct net_device *dev,
 					     const struct net_device *foreign_dev),
-		int (*del_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
+		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+			      unsigned long event, const void *ctx,
 			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_del_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
+		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+				  unsigned long event, const void *ctx,
 				  const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	return 0;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index adcfb2cb4e61..f7675db09d2a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2469,10 +2469,9 @@ static bool dsa_foreign_dev_check(const struct net_device *dev,
 }
 
 static int dsa_slave_fdb_event(struct net_device *dev,
-			       const struct net_device *orig_dev,
-			       const void *ctx,
-			       const struct switchdev_notifier_fdb_info *fdb_info,
-			       unsigned long event)
+			       struct net_device *orig_dev,
+			       unsigned long event, const void *ctx,
+			       const struct switchdev_notifier_fdb_info *fdb_info)
 {
 	struct dsa_switchdev_event_work *switchdev_work;
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -2528,24 +2527,6 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	return 0;
 }
 
-static int
-dsa_slave_fdb_add_to_device(struct net_device *dev,
-			    const struct net_device *orig_dev, const void *ctx,
-			    const struct switchdev_notifier_fdb_info *fdb_info)
-{
-	return dsa_slave_fdb_event(dev, orig_dev, ctx, fdb_info,
-				   SWITCHDEV_FDB_ADD_TO_DEVICE);
-}
-
-static int
-dsa_slave_fdb_del_to_device(struct net_device *dev,
-			    const struct net_device *orig_dev, const void *ctx,
-			    const struct switchdev_notifier_fdb_info *fdb_info)
-{
-	return dsa_slave_fdb_event(dev, orig_dev, ctx, fdb_info,
-				   SWITCHDEV_FDB_DEL_TO_DEVICE);
-}
-
 /* Called under rcu_read_lock() */
 static int dsa_slave_switchdev_event(struct notifier_block *unused,
 				     unsigned long event, void *ptr)
@@ -2560,18 +2541,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 						     dsa_slave_port_attr_set);
 		return notifier_from_errno(err);
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		err = switchdev_handle_fdb_add_to_device(dev, ptr,
-							 dsa_slave_dev_check,
-							 dsa_foreign_dev_check,
-							 dsa_slave_fdb_add_to_device,
-							 NULL);
-		return notifier_from_errno(err);
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		err = switchdev_handle_fdb_del_to_device(dev, ptr,
-							 dsa_slave_dev_check,
-							 dsa_foreign_dev_check,
-							 dsa_slave_fdb_del_to_device,
-							 NULL);
+		err = switchdev_handle_fdb_event_to_device(dev, event, ptr,
+							   dsa_slave_dev_check,
+							   dsa_foreign_dev_check,
+							   dsa_slave_fdb_event,
+							   NULL);
 		return notifier_from_errno(err);
 	default:
 		return NOTIFY_DONE;
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 0b2c18efc079..83460470e883 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -428,17 +428,17 @@ switchdev_lower_dev_find(struct net_device *dev,
 	return switchdev_priv.lower_dev;
 }
 
-static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
-		const struct net_device *orig_dev,
+static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
+		struct net_device *orig_dev, unsigned long event,
 		const struct switchdev_notifier_fdb_info *fdb_info,
 		bool (*check_cb)(const struct net_device *dev),
 		bool (*foreign_dev_check_cb)(const struct net_device *dev,
 					     const struct net_device *foreign_dev),
-		int (*add_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
+		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+			      unsigned long event, const void *ctx,
 			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_add_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
+		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+				  unsigned long event, const void *ctx,
 				  const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	const struct switchdev_notifier_info *info = &fdb_info->info;
@@ -447,17 +447,17 @@ static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
 	int err = -EOPNOTSUPP;
 
 	if (check_cb(dev))
-		return add_cb(dev, orig_dev, info->ctx, fdb_info);
+		return mod_cb(dev, orig_dev, event, info->ctx, fdb_info);
 
 	if (netif_is_lag_master(dev)) {
 		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
 			goto maybe_bridged_with_us;
 
 		/* This is a LAG interface that we offload */
-		if (!lag_add_cb)
+		if (!lag_mod_cb)
 			return -EOPNOTSUPP;
 
-		return lag_add_cb(dev, orig_dev, info->ctx, fdb_info);
+		return lag_mod_cb(dev, orig_dev, event, info->ctx, fdb_info);
 	}
 
 	/* Recurse through lower interfaces in case the FDB entry is pointing
@@ -481,10 +481,10 @@ static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
 						      foreign_dev_check_cb))
 				continue;
 
-			err = __switchdev_handle_fdb_add_to_device(lower_dev, orig_dev,
-								   fdb_info, check_cb,
-								   foreign_dev_check_cb,
-								   add_cb, lag_add_cb);
+			err = __switchdev_handle_fdb_event_to_device(lower_dev, orig_dev,
+								     event, fdb_info, check_cb,
+								     foreign_dev_check_cb,
+								     mod_cb, lag_mod_cb);
 			if (err && err != -EOPNOTSUPP)
 				return err;
 		}
@@ -503,140 +503,34 @@ static int __switchdev_handle_fdb_add_to_device(struct net_device *dev,
 	if (!switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb))
 		return 0;
 
-	return __switchdev_handle_fdb_add_to_device(br, orig_dev, fdb_info,
-						    check_cb, foreign_dev_check_cb,
-						    add_cb, lag_add_cb);
+	return __switchdev_handle_fdb_event_to_device(br, orig_dev, event, fdb_info,
+						      check_cb, foreign_dev_check_cb,
+						      mod_cb, lag_mod_cb);
 }
 
-int switchdev_handle_fdb_add_to_device(struct net_device *dev,
+int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event,
 		const struct switchdev_notifier_fdb_info *fdb_info,
 		bool (*check_cb)(const struct net_device *dev),
 		bool (*foreign_dev_check_cb)(const struct net_device *dev,
 					     const struct net_device *foreign_dev),
-		int (*add_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
+		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+			      unsigned long event, const void *ctx,
 			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_add_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
+		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
+				  unsigned long event, const void *ctx,
 				  const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	int err;
 
-	err = __switchdev_handle_fdb_add_to_device(dev, dev, fdb_info,
-						   check_cb,
-						   foreign_dev_check_cb,
-						   add_cb, lag_add_cb);
+	err = __switchdev_handle_fdb_event_to_device(dev, dev, event, fdb_info,
+						     check_cb, foreign_dev_check_cb,
+						     mod_cb, lag_mod_cb);
 	if (err == -EOPNOTSUPP)
 		err = 0;
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(switchdev_handle_fdb_add_to_device);
-
-static int __switchdev_handle_fdb_del_to_device(struct net_device *dev,
-		const struct net_device *orig_dev,
-		const struct switchdev_notifier_fdb_info *fdb_info,
-		bool (*check_cb)(const struct net_device *dev),
-		bool (*foreign_dev_check_cb)(const struct net_device *dev,
-					     const struct net_device *foreign_dev),
-		int (*del_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_del_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
-{
-	const struct switchdev_notifier_info *info = &fdb_info->info;
-	struct net_device *br, *lower_dev;
-	struct list_head *iter;
-	int err = -EOPNOTSUPP;
-
-	if (check_cb(dev))
-		return del_cb(dev, orig_dev, info->ctx, fdb_info);
-
-	if (netif_is_lag_master(dev)) {
-		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
-			goto maybe_bridged_with_us;
-
-		/* This is a LAG interface that we offload */
-		if (!lag_del_cb)
-			return -EOPNOTSUPP;
-
-		return lag_del_cb(dev, orig_dev, info->ctx, fdb_info);
-	}
-
-	/* Recurse through lower interfaces in case the FDB entry is pointing
-	 * towards a bridge device.
-	 */
-	if (netif_is_bridge_master(dev)) {
-		if (!switchdev_lower_dev_find(dev, check_cb, foreign_dev_check_cb))
-			return 0;
-
-		/* This is a bridge interface that we offload */
-		netdev_for_each_lower_dev(dev, lower_dev, iter) {
-			/* Do not propagate FDB entries across bridges */
-			if (netif_is_bridge_master(lower_dev))
-				continue;
-
-			/* Bridge ports might be either us, or LAG interfaces
-			 * that we offload.
-			 */
-			if (!check_cb(lower_dev) &&
-			    !switchdev_lower_dev_find(lower_dev, check_cb,
-						      foreign_dev_check_cb))
-				continue;
-
-			err = __switchdev_handle_fdb_del_to_device(lower_dev, orig_dev,
-								   fdb_info, check_cb,
-								   foreign_dev_check_cb,
-								   del_cb, lag_del_cb);
-			if (err && err != -EOPNOTSUPP)
-				return err;
-		}
-
-		return 0;
-	}
-
-maybe_bridged_with_us:
-	/* Event is neither on a bridge nor a LAG. Check whether it is on an
-	 * interface that is in a bridge with us.
-	 */
-	br = netdev_master_upper_dev_get_rcu(dev);
-	if (!br || !netif_is_bridge_master(br))
-		return 0;
-
-	if (!switchdev_lower_dev_find(br, check_cb, foreign_dev_check_cb))
-		return 0;
-
-	return __switchdev_handle_fdb_del_to_device(br, orig_dev, fdb_info,
-						    check_cb, foreign_dev_check_cb,
-						    del_cb, lag_del_cb);
-}
-
-int switchdev_handle_fdb_del_to_device(struct net_device *dev,
-		const struct switchdev_notifier_fdb_info *fdb_info,
-		bool (*check_cb)(const struct net_device *dev),
-		bool (*foreign_dev_check_cb)(const struct net_device *dev,
-					     const struct net_device *foreign_dev),
-		int (*del_cb)(struct net_device *dev,
-			      const struct net_device *orig_dev, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_del_cb)(struct net_device *dev,
-				  const struct net_device *orig_dev, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
-{
-	int err;
-
-	err = __switchdev_handle_fdb_del_to_device(dev, dev, fdb_info,
-						   check_cb,
-						   foreign_dev_check_cb,
-						   del_cb, lag_del_cb);
-	if (err == -EOPNOTSUPP)
-		err = 0;
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(switchdev_handle_fdb_del_to_device);
+EXPORT_SYMBOL_GPL(switchdev_handle_fdb_event_to_device);
 
 static int __switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
-- 
2.25.1

