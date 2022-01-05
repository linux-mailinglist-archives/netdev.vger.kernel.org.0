Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14087485359
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbiAENSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:18:30 -0500
Received: from mail-eopbgr40062.outbound.protection.outlook.com ([40.107.4.62]:24383
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237058AbiAENS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 08:18:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N3aDA3pjZRIk6mIA1qTmSnH9GAifQ6AuWL3Pcg+vTCpMyS3sDibEAfmbVtK1/RMKS9cIgmt+e00LTg/u0rA0zxFKWp05Bp13EXvr03RuWDAW35RNoGUI78Vm0pNaK0nF5AuKsAYS2USzymsLLBduM74sOZqMNJSLYzmcrWqFsjCnCR7yQ1oKTwKHn+Bne/R6/0HXlZF/c6NoZKbjDzplbWNHow2X0ViCQSqbywPdfujeYSipjhovmwpHa/cGg7GZsdFd5FYa5UtDbmBuFSO5Y/Uod+p4FSO4uJvD17g+nTS+FnzdsvefNA3zlPJCSqa/hBbxjf0gIUJ+37zuOTs7rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qxt9uz6moe8ELzNcgditIjjctbZWzxS81uhY+a5RhFA=;
 b=HHW8B2q8j0d8vSMqHGPaZXXlZmK2VLI+C/8AjZipeVozHlr1Hlr75tv0f7F3UrSdxxrdVTztkaR+pCYokLVVpe5QPcLAaXrhWd1i6TCPkNl9Biu56puKhwW2FdGOSeog+KfFPX2s+dOazNDnmo4eZoAraUcKfVdEXdt7UKi8Hmpn8ZdcB83le1gQxyTBdq6CazG1DXEoZ+xkyU02BYo10z1lw3GLDduwisWkvjMTBZtEHee01NKCyyki+sQxNDsYgi5XnHi7x+8xn/BzqVWGk/Z0ZRf6EAyh012m0rVJcKUYIiWuyBPTqKBIT59O+nX6ddvCsr8BHDHctaF+FZExNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qxt9uz6moe8ELzNcgditIjjctbZWzxS81uhY+a5RhFA=;
 b=n9VANzjjStbX9RwZskVm0/M1/sAOrz5MIc/NNnsdN+2XIpm8lGPcw/BGNbAvxlT1Lz1Xqgvg5n7ghqOM+XpkfvEfAU/A/ZEZ46ZZk8BBDQjik4ctgwMaTxgT2ktSB9DjWcwXVCiGijwug/qkq9arlzF3Ia/BvbBxoXz3CWxq89s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 13:18:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 13:18:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v2 net-next 1/3] net: dsa: fix incorrect function pointer check for MRP ring roles
Date:   Wed,  5 Jan 2022 15:18:11 +0200
Message-Id: <20220105131813.2647558-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220105131813.2647558-1-vladimir.oltean@nxp.com>
References: <20220105131813.2647558-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0106.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::21) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2794fc7-11d9-4dd1-d91b-08d9d04dd9f0
X-MS-TrafficTypeDiagnostic: VI1PR04MB6942:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6942AC44049CA7381BF29744E04B9@VI1PR04MB6942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BNCMudYolFxAEcHIOYsMCbBoYRM6HECsekPCR+EvvYGjPcErQFV4jokIvOeJI6GNOGFAQaIPRe8wkc/E3huQ1+MrWlKyQSRlWcVcqKD3/X71qfN/GP/Gsa9kKZYe53RtdcSd1zUQ3Gm+aFWBm019GPj6ja4E5r7sRiFnVVHry8oXtf76u/flEQNRdT132OjdiXkRQWAq5DIJlcTmkyH9KSLFJkoJjzltc7mtTpJML7B7qocIWFBewnuXH+n85GQ73OM8g86J1PZe8DZZurtdChhimVU+BHO/obA8K5C1DVphuZPB3hpGNCsCm07qy9tdnByiZ6CYMJN+LsMQBL+7Es46DBb5wX8eAS8XS47tJonDU1eDRYhp4nlITYSsKjrF4hmta2tKkx935XsmiGZ4TEnb2Y0Qs7o5AcEOPdAkrbzkPV34lSTPUMfZM6VH6wk31hJBh9sOV0zLWsRsz/YglgnJoOIbvDt4JOBlux7Yz5IOSTXN5alvlxtuxp9mruWKEQ0JUyIN47uH+poe5fzjpi8te4FF7HLUArFtV3YBX4oVk3reCWNQQruFxS+3KsS8ZF86H9+g7Ocv2F8cgL8JoRQDAgU0y9sKs3xrpbv2h5d+J6xumpQ92wZOtOZDkUEgLjP2HnYOyXLwKjfTKItiEDPU6uI87kxAF7FsgLq5GcFTV36j2gLWQU2Qg+g8ZNEZD9xB8fyYs3Ppb/E4khtP9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(8936002)(6512007)(83380400001)(508600001)(2616005)(6506007)(36756003)(5660300002)(38100700002)(38350700002)(1076003)(6666004)(4326008)(44832011)(316002)(66476007)(66556008)(66946007)(86362001)(186003)(26005)(8676002)(6916009)(2906002)(54906003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9QIc7zeQpAB1xVrkB6Tv+BXSrZ7R6Y2PC5+oyJUnEsMqXi9OCPseJHHsK1JX?=
 =?us-ascii?Q?po0o2QOVAay60AMlvSLolyK6jGHOD34ffzo+jiFD5OcAULH0wdiUfE+ZS26k?=
 =?us-ascii?Q?PvS+fH0uYkF2qkf2MZL7/lxTpiY1oAa6+Dgahin0g2mBIbJBFHe2XQs2v3+O?=
 =?us-ascii?Q?euMUFGQRBolhU3BSBrA04+5beB9dUPScLGrtVArdglZF6lD07PjDUN+lBOm3?=
 =?us-ascii?Q?SOPLvkp8N0vOXBQS68H6/0nYgc/CCa/4Yei6aylujlXFsr5a1U6c5RlzEn0F?=
 =?us-ascii?Q?GJR1zXTReIJbTSOQsJ89AC+iDF1AN6AQLfvJ6EjrFac9NJL2JAlxk8yVr1aZ?=
 =?us-ascii?Q?VaHLCGNmwZd7qJC13U5Q3EfI+/2yun5vVuYuxOFTfQaV/CmoSSzVejfmDW5p?=
 =?us-ascii?Q?i5pj0G2dleRX7R4L+Q2fYgjHJNoOVcLycpkt6sn97Jf4IZEIWuiDXxYLxJWC?=
 =?us-ascii?Q?OxiwoSSfEI6obKxkB4DDSJ/pxUuHjUCs2Lmyy5kudvT1f1MqUQ48IQDOCp6e?=
 =?us-ascii?Q?qY5a8Uc66Cq/Nwp7Q9fII1/dYXDbdTSI/OqApqWp9zK5C9LrJmsS/8gCd9Yy?=
 =?us-ascii?Q?o5x2grcBuPuC9BuJRWqWGr0qAs3iR59PNhVhjjymnvLLseQVXmj2D37RDTLn?=
 =?us-ascii?Q?Fsppyvaor/tPG7568jSQH065tnBeO7MU6micuNTqoKutTqVOX9bUlaxzrrDM?=
 =?us-ascii?Q?OD+kTUXEpKQH2v9zt1BiASmNLSwMQjgPg868Jg3f7/35AqR9lBibRq4pDFoe?=
 =?us-ascii?Q?hGVyjWHfBPgYXmPlJhYO2FTDbof+RCjiqI0l31VZEL5hJS/mPa0cGzkamQia?=
 =?us-ascii?Q?RuTscteM47AP8qhP2+A9gAUyiGNCN/aTGNZg7J3yGQEQdbEiX/D3S4Bi6Omo?=
 =?us-ascii?Q?9GvfTyMXmLzXhBklw5lfdwu2LbAF+SlacKnMaYyOphSiWjqWl/09zGV8nd5V?=
 =?us-ascii?Q?iiscFbNc/Pnw/ITg8iR/Qy+vbkJj3bfIbuHFgG9PhXNmCApsSntlTTfVaqoy?=
 =?us-ascii?Q?q3u/0mkQO2MHP26Fia0nXeMS72eaR0JTCJ/qW3hDXnWVSTzK1fB+F1xrHacL?=
 =?us-ascii?Q?9NHa3SY9JtlsJHAzme5OPJooxXkr8Dwx6tpDR9IaCVql/L8aHPLLredL8v1I?=
 =?us-ascii?Q?bIsg2b+mNgxNbjI/9C4pgM0eR7L6d7/px9/VbRgPMMaOQITWIHz18ZB43yqu?=
 =?us-ascii?Q?wcpY4LJsRB8gip+9mZ3+vvYOv0HPPOwxyHtewh9eRZVn5N59epGjPYzXj2yg?=
 =?us-ascii?Q?74PmJAeZV4NJgGlpXnIlKBpeiq0zwAVOmbyNCNgv9vKDpoMcnXoUkViXRSiZ?=
 =?us-ascii?Q?Hr8cFFs8eKOWK/LnnaRfHsxOxzEOW0FjQlqUBOggaHVQJlnZZVf92XKw0vIt?=
 =?us-ascii?Q?c+WJL5g7NnkgK11uEwXBDlC6NITR8Er3Hf+yDulNoC4gZzIGmHqmuaP3UnLt?=
 =?us-ascii?Q?jGqo8GOS1KbKV8OQI5S+YZq8q+l1/oHvkgMZ4WXNHayrV979bSBRngQOA4Pq?=
 =?us-ascii?Q?fTEiKz31ECydBr0nT1vDWJMEssdqLQSI/1SnfDar8Npoz59OZpcmSK/akrSC?=
 =?us-ascii?Q?+FRpdlAlupzcGI1vS2dlSOO5+C2AVGpu1JVmxY34EY5yZiSe7AiOqJIkJi/6?=
 =?us-ascii?Q?LaUCiIMaeJ3r2NS9jFZuEl8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2794fc7-11d9-4dd1-d91b-08d9d04dd9f0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 13:18:23.8853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gxgJQ4MRYJuJmOy8T9j8nt7I9WRDVH/eOXQQOfKRnEmGHNOpe57PQLVbEs2MSdJEtFDkZWf3WcSxnN14MMg/NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cross-chip notifier boilerplate code meant to check the presence of
ds->ops->port_mrp_add_ring_role before calling it, but checked
ds->ops->port_mrp_add instead, before calling
ds->ops->port_mrp_add_ring_role.

Therefore, a driver which implements one operation but not the other
would trigger a NULL pointer dereference.

There isn't any such driver in DSA yet, so there is no reason to
backport the change. Issue found through code inspection.

Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Fixes: c595c4330da0 ("net: dsa: add MRP support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 net/dsa/switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 393f2d8a860a..260d8e7d6e5a 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -729,7 +729,7 @@ static int
 dsa_switch_mrp_add_ring_role(struct dsa_switch *ds,
 			     struct dsa_notifier_mrp_ring_role_info *info)
 {
-	if (!ds->ops->port_mrp_add)
+	if (!ds->ops->port_mrp_add_ring_role)
 		return -EOPNOTSUPP;
 
 	if (ds->index == info->sw_index)
@@ -743,7 +743,7 @@ static int
 dsa_switch_mrp_del_ring_role(struct dsa_switch *ds,
 			     struct dsa_notifier_mrp_ring_role_info *info)
 {
-	if (!ds->ops->port_mrp_del)
+	if (!ds->ops->port_mrp_del_ring_role)
 		return -EOPNOTSUPP;
 
 	if (ds->index == info->sw_index)
-- 
2.25.1

