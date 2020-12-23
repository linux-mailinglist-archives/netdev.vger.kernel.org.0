Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B702E1D8E
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 15:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgLWOq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 09:46:56 -0500
Received: from mail-eopbgr00126.outbound.protection.outlook.com ([40.107.0.126]:61785
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727207AbgLWOqz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 09:46:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKy/+dUC3+YTvLS5UTybgC0Ly0qcAtHgoHh49hNa1ndEyd6zOY4MfD+mTh/fpa9WFI8WerNdDYro4D7GtyNyVSI5OtPuutGa/AEEZ0JKhCcXTiGXTn1TB02qZmDcP5Bx7RgkL0i9BWLORUP8/8Dc57U83tMczC9bEidNvT55d4HX5sirASHBHrstik42C9XnMryY2gwccReQ735JYS2P2qWePasP2+JjBW/YIM+6EhDGYhmW8qKmyAZYZdxDV/Q0YVBjcGxp2jaXzv0Lvx46zUkeGLEd/tDfcqKS2+9E3dn33TlaoCwmdGDyT1TEuwsBzGHw9rHftBlV7JrFOXsnzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bsz2QdlwY8mvIdkvF48A+vw7nVfJnuGotMo6dZ2v9CQ=;
 b=WtHdHZe6XtfLbZdSEKREw5bZZhFhejiKhBZZIu81TZfYxK0y4ShZTLKAewnU0Nrvtw2OCVTAHZrwmnDivmqFO5h7rOwl3HKSErbCCTt0FZZPxqJ0BERAZJaC3JPjWYwEKSjl/SNbQ+4wlxf1Bjpt3d4QPoNMW4lWryBuU9Ei50lVR1eXBWpLJ9P6O29ykVxI17ke5tIkgleAB+otG6Qn8hng7K3ZhJCJSTygKls4zJLcLBaroy8EzgJ9GSnG2hXTajWhSvYUsGdrSwfbmgXBEogS5eD7mAQNPRp4za9gwyCg9rU2S89iH5GYIzp1QcQX5kofbEG3bUAjtiBNaqSkww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bsz2QdlwY8mvIdkvF48A+vw7nVfJnuGotMo6dZ2v9CQ=;
 b=kQC/kuvDLB3Jq1/eaAdPj19q1U6Vm9+OOfyXYhq2UeP06WyZODHyI99/Be5Og9LO0fn77NWOUZT1gCLs2ZRNtGMEmnAj4IrheWuBlrO+aa1u/SCWsrvqnpK6gxjPpsSv6PAvoQOlJ5E8T37SWMgYzOehLn5018MoeeA9OyEtnkQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3057.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:162::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.33; Wed, 23 Dec
 2020 14:45:45 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3676.033; Wed, 23 Dec 2020
 14:45:45 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net 2/2] net: switchdev: don't set port_obj_info->handled true when -EOPNOTSUPP
Date:   Wed, 23 Dec 2020 15:45:33 +0100
Message-Id: <20201223144533.4145-3-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
References: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AS8PR04CA0142.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::27) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AS8PR04CA0142.eurprd04.prod.outlook.com (2603:10a6:20b:127::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Wed, 23 Dec 2020 14:45:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c23f2c2-eb75-4082-e676-08d8a7516dea
X-MS-TrafficTypeDiagnostic: AM0PR10MB3057:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB3057E9E9266EC76656A9F51193DE0@AM0PR10MB3057.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EnuZOFsbU/AwBRACNeZITmeGh/6PWotF9gN9iEzwGJ704zqrYSmBJo+tJP4wkdWO8vDNvGfdTHjbwlEcM5YBAoU9AohirVeg8QAOIW16EHdCFHeBWUc5Vpc7YIg2QNGWopa0GwbTA5M+Ya8lUXYspVB5EMTNE1qwIzGxAbahX4+Exis+wGJMDI2zQoM6zpT/GPmNu9yfErkz6ZkrtynjvA6gYiD6EGeCSzyPUvGOI1AlTGwv2NVIWDlViKL85uXd9s4RjhByk30tpjE5/YTuNDU28qjQXKp6C02y4Ji2iufMfg0QuKvC38SNFUj56e6EM+8H8IlOrgJhTW2SZDKSq1Uqkwc/Dn39bI6V5DhC80lPfSIAPczA5PLkHxGLiovTWtFRBpbqhWyEcKAg4hBQfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39840400004)(376002)(346002)(54906003)(4326008)(6512007)(6486002)(107886003)(316002)(16526019)(5660300002)(26005)(66476007)(8676002)(66556008)(6506007)(83380400001)(66946007)(186003)(52116002)(2616005)(6916009)(6666004)(44832011)(1076003)(86362001)(8976002)(36756003)(2906002)(8936002)(956004)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/qcgJVilanVLVsp0fObxz6qXkeSsKkizvhRctMAJFiP/GclyB9d9I9zHxTS8?=
 =?us-ascii?Q?apO+4MqczuoShg2SY5P5M0Oxf3TyNZK7Es45IuY8sH3kAApA+4ht29XXMslB?=
 =?us-ascii?Q?YWO+l23ABVMEQrsjtcfSI9rR9AKHfSYl4DWJU7cYgfl+iZ2TY8AKDYpnAgSh?=
 =?us-ascii?Q?UwTRgmQZ10Yw+OcFdxRz8hbRN/tla8nduQ4XNwYaqE3VC0E/F3RTe6BYUPxt?=
 =?us-ascii?Q?Os5XTfWh+/5vMQLS8SMcC0E1rSoFUT/fzBN7+yUhrV7r/6n2B9EqSWvxm3ME?=
 =?us-ascii?Q?GfvIjkNQ5bDfmH5+mVKVUM22Vz6CrGTEWCugjYDuEkHYm4aQ9bThb6/8dISn?=
 =?us-ascii?Q?XSI7CPFM5CAMCW95I+Kfi9HtZXyTSGNQMgTW1X9F3J77DxfDkvhb66CWjfc6?=
 =?us-ascii?Q?69A4x/Rc10McSdsB1pdKkSUfApU59Q2laZ4W9f5Zsw3q6ontj2RrO7ilM4t5?=
 =?us-ascii?Q?8cv38iN96sfeQM+w1AIU5HJjNBukMndHf3kyyYCCeYw3IYHGfSU4a/5DXo36?=
 =?us-ascii?Q?4KMeAP5YC5RsooPJIY2aT7/tUHED4p36/CioGaW3IVBxM2ypb6jWHLU8BClC?=
 =?us-ascii?Q?jx/4ZZ4iDU4pf/+SsGFz2Nz76kVSeGsX+IkRDjKpP2Ffy5dHyU/T06uUAOXe?=
 =?us-ascii?Q?MV7ADxEGqLVWC8uBFRbrwAO3WfOjdB0+AChlJb3Aepv5FV/vzuph0kmsUi/g?=
 =?us-ascii?Q?9j7pZOjq0oEH/VMuIRKRXDm6xgbF1EqPBQNfROZuh+PRobqKDi3fCKjCaVq4?=
 =?us-ascii?Q?RJ1jltE+f82qjkdSvA17mVudRdwk3cxmAqImuc+dXe8hawZkrW5lbmKmU9jb?=
 =?us-ascii?Q?gQ1yQ4l7vW0HS4N7OXn6IrALHhpPPYTK09kUwtajiaYq+GCkqURN5PxBr2ul?=
 =?us-ascii?Q?g+Qfg9fBIhSYzFEwSmJWSl4KFavQUp8n3lFL8WUySjDgCgp8+TYLdPuMMCgJ?=
 =?us-ascii?Q?CPWJ/3LDI5lOF9L6HIaX8CYxQF/gRJ0sAqB+ec1J8fENovdQEvymXBGO+F2j?=
 =?us-ascii?Q?jvmp?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2020 14:45:45.0476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c23f2c2-eb75-4082-e676-08d8a7516dea
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sWcwvSGisxj2xt0P48t9NDjpn2P9Fig6N2XheE2Vy4B05LyFEQ+/9fM6mq+K9Vh6biUzTVrlxJ4WhkwkGcLCe3/1eu56qc7g0EKg8rSkPB0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3057
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not true that switchdev_port_obj_notify() only inspects the
->handled field of "struct switchdev_notifier_port_obj_info" if
call_switchdev_blocking_notifiers() returns 0 - there's a WARN_ON()
triggering for a non-zero return combined with ->handled not being
true. But the real problem here is that -EOPNOTSUPP is not being
properly handled.

The wrapper functions switchdev_handle_port_obj_add() et al change a
return value of -EOPNOTSUPP to 0, and the treatment of ->handled in
switchdev_port_obj_notify() seems to be designed to change that back
to -EOPNOTSUPP in case nobody actually acted on the notifier (i.e.,
everybody returned -EOPNOTSUPP).

Currently, as soon as some device down the stack passes the check_cb()
check, ->handled gets set to true, which means that
switchdev_port_obj_notify() cannot actually ever return -EOPNOTSUPP.

This, for example, means that the detection of hardware offload
support in the MRP code is broken - br_mrp_set_ring_role() always ends
up setting mrp->ring_role_offloaded to 1, despite not a single
mainline driver implementing any of the SWITCHDEV_OBJ_ID*_MRP. So
since the MRP code thinks the generation of MRP test frames has been
offloaded, no such frames are actually put on the wire.

So, continue to set ->handled true if any callback returns success or
any error distinct from -EOPNOTSUPP. But if all the callbacks return
-EOPNOTSUPP, make sure that ->handled stays false, so the logic in
switchdev_port_obj_notify() can propagate that information.

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
 net/switchdev/switchdev.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 23d868545362..2c1ffc9ba2eb 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -460,10 +460,11 @@ static int __switchdev_handle_port_obj_add(struct net_device *dev,
 	extack = switchdev_notifier_info_to_extack(&port_obj_info->info);
 
 	if (check_cb(dev)) {
-		/* This flag is only checked if the return value is success. */
-		port_obj_info->handled = true;
-		return add_cb(dev, port_obj_info->obj, port_obj_info->trans,
-			      extack);
+		err = add_cb(dev, port_obj_info->obj, port_obj_info->trans,
+			     extack);
+		if (err != -EOPNOTSUPP)
+			port_obj_info->handled = true;
+		return err;
 	}
 
 	/* Switch ports might be stacked under e.g. a LAG. Ignore the
@@ -515,9 +516,10 @@ static int __switchdev_handle_port_obj_del(struct net_device *dev,
 	int err = -EOPNOTSUPP;
 
 	if (check_cb(dev)) {
-		/* This flag is only checked if the return value is success. */
-		port_obj_info->handled = true;
-		return del_cb(dev, port_obj_info->obj);
+		err = del_cb(dev, port_obj_info->obj);
+		if (err != -EOPNOTSUPP)
+			port_obj_info->handled = true;
+		return err;
 	}
 
 	/* Switch ports might be stacked under e.g. a LAG. Ignore the
@@ -568,9 +570,10 @@ static int __switchdev_handle_port_attr_set(struct net_device *dev,
 	int err = -EOPNOTSUPP;
 
 	if (check_cb(dev)) {
-		port_attr_info->handled = true;
-		return set_cb(dev, port_attr_info->attr,
-			      port_attr_info->trans);
+		err = set_cb(dev, port_attr_info->attr, port_attr_info->trans);
+		if (err != -EOPNOTSUPP)
+			port_attr_info->handled = true;
+		return err;
 	}
 
 	/* Switch ports might be stacked under e.g. a LAG. Ignore the
-- 
2.23.0

