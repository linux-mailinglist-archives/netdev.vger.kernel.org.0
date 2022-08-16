Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6B3596395
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 22:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237388AbiHPUPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 16:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237182AbiHPUPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 16:15:02 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50082.outbound.protection.outlook.com [40.107.5.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5216B804B5
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 13:14:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHGzhVg9euYcfMZGdJrlwj6RvhX/TQ8+jmcJ0WeBA5bOlZcqVLB01ew6ruQQ1DN4Wawr/JsndlXmE1I/Cencn5TIDD6ma2jZMx3QKHhVy21lTYh9lRiCoL/AapTngyh3/e0n6+YP8y/Fk8Qo7EOs6Vn8Gxxj0qg9jz/IuFfCPl9DcYVWUlRkpG+Ql+qQkbYBbRxxWPY8+Rb3pL+pHPGCa6R4MSLJmtK6jl+OGKPEypNjqlmFWOAlax1tU2nu3+3fn7fmCUc5Q4/q1henDlgdBkVR1+8T7szcJeBMae4uyJZRgvciXC6L1Hd8EcvCOKw0ISJBk3ZQDYhuXBkY4iCvBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0RaefdsDfjtLb4mGg5gmW3Vy+sxz2sOg2mHTARbfj4=;
 b=WXe68kk0zReMsce0HrkKVakRCG6PPsbi42guUZCfG/5I+BXtJ/q9iJ7PpwHKMTUzJCmNm7hQuHCrfaqHwRHwIQGQc54tzZDkhhSpqtmKytisjmJ/c3AxaMcthNkk9qnwyhoy2obIeKxAZTMVd/yPCMkUqC8fGF7GqVQLSrdfdwqW0GBHwU5ejSUk2CvzoQ5nivB6aPHgsaXRCm4s7UoZ8o3ukU5sLLhBK2h5tICyoG2RobsICAQicxq2vB3OEIbt5jHphzphDIwx5Gae9dLSWu7Cyz4cyg4P7LpFmhyEpjnwfoHwnd0GAkTR6/9ozstf2NZIhtZ1FCmeuibqFfU+PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0RaefdsDfjtLb4mGg5gmW3Vy+sxz2sOg2mHTARbfj4=;
 b=S3zv+4spznEgMjkxREYxd+MI5doEu9TBy1YZ/ce2kGqX6u9JTgdb36Lnh/EqyPQozv9DyckTdZeigoCb+4Oz0UmYIbXqv7a81tvkbDZ3/Y95VmmHdZzpXA4RICHZi33pNuVgFoL1LZInUuhkukcippV+VSEXD9O+unUS1yXkM2Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6348.eurprd04.prod.outlook.com (2603:10a6:10:3d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Tue, 16 Aug
 2022 20:14:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 20:14:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH net] net: dsa: don't warn in dsa_port_set_state_now() when driver doesn't support it
Date:   Tue, 16 Aug 2022 23:14:45 +0300
Message-Id: <20220816201445.1809483-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0153.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 843867e5-0044-478f-af96-08da7fc3fc44
X-MS-TrafficTypeDiagnostic: DB8PR04MB6348:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u5V27K7JhKXjpZCCYwyMYIx31qW8/9zHsSNqbGqDCYrXSD+cicjZVonwrbsAuz1kTuO1UNcUtGF8JhCR30g6B7uWjBfGeu+X1OmD8CFhv8x5oe2RGZFD3Onzs/1/i02kYbP/Pbwwm3+eZe8UDUaV2hZIZvPTz4cMJjwI6uklCK5euXtz0AwcaXCCeAsUK9y/amXdRNJUvWrgYk21vntCva4ScopKP7kbZIugADVhacyzWkp/rrHXrQ0KClpCcrgq5qCIJLbu4mWyk5pdtfMmMJpMEks3ZCyVQxR+9rtmbxM6vHqMeCqTaWLK/1aVGmON8pHTQ9EBXFTKeha1iPdDlMGnPGpa4iN0ROgHS6zLChlF1CedA71mnMOvXIWEviD+KKi1+sxMOCMzOBQyq8BaOvANLfc3tF4iKZYxGaIEAl3sNcYqDxRUCS4M968RH/biMWldcufQntZC5q9BpMQRPY29IerzPJicxOgAtNjDSLnnPpmaUQY2UlaVCEjmU3jRBl9mkBUiKJGnumEpoXJ6EUeVBYPyNvJxy104cyjAP7BK+2yrDIdfOEFNJQThyYpVwhQF5xBB7HShABtlQsGb0ysrDGg/9VGSIT8tHbQKnROC+K72W9WwI0McddkFDLMdN/d9tNG5wdT1IOB9CDOCaKPjkZElPnSX4DFmox6qlMZhqhf8OEbcBll5mU30iwRQEodzQP/uf+glV0qmkqh1BRGm5e03FrNh5kEWeaR0ufz4irPEbVTGOqPIV8qCCLZ7zvDCb6+N3Gk6IP9rA8ADAAglua9Z7W4ED3/q5aIAInk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(478600001)(38100700002)(36756003)(6486002)(6506007)(186003)(26005)(66556008)(38350700002)(2616005)(41300700001)(86362001)(1076003)(52116002)(4326008)(54906003)(6512007)(8676002)(6666004)(66476007)(83380400001)(44832011)(2906002)(8936002)(316002)(66946007)(6916009)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rVHo6RWpbLZk92xrd0UCYAYskeDW0gg9kQa/UAW5HlnXu0P3qFHlYznWioa2?=
 =?us-ascii?Q?SGr6T7MwEuz53SGlI2Y9lQsFp2o6Ru5yeqXkhHMiTLzWq4YZ6IyPpYLCqvqX?=
 =?us-ascii?Q?102M2Q9g/XK6gqPwfqWqScjXVsEeunJVj0TZiy7ZBf3D8WsmbspRibcz0NO2?=
 =?us-ascii?Q?H2RyZkdUTTXX8yr+YWupMjoBR41KQjMYlv4Bnl5ITvcm7G1CuIBxS/KuHB5m?=
 =?us-ascii?Q?zJXeA9CW1sKvWZB5sGbB4lAs3Ga//XjPX8NsADE4pUtrKaKXyK3j4rMN4UMk?=
 =?us-ascii?Q?5qkgjK9/FrgSjVzZ+Rc5/l1Dxb+m3+PZwVwx4KrILmvm7XY3Sdf4zi6uFB/Y?=
 =?us-ascii?Q?+wnBSvHtPR0J0hJ3DOSCLkYlhd+bwIABUZ6/aKBF/5IVE3ov7pFnyrs3vIXT?=
 =?us-ascii?Q?sOA/ZUgY/o4svAtoeWWl24o78k4f5YiIDaJWBpiTf406vDcPXb8Rtg8GFLsx?=
 =?us-ascii?Q?0KqSDiGX0IMDBrmm2W0KIoE2PwPXnB00eQi0DMmwQtQw5mWUu0P6pD8bgXIs?=
 =?us-ascii?Q?eXG852Xjb9x4JRphs9Cp/sLvrH5i3/Ab8YSXAZ1hRGjgsp7rjuhf2HWeWc/j?=
 =?us-ascii?Q?xoCh3FPOH90Jd2uBos0itH26/L1YPUzX0Wycz9MwUgf0UMN/ZjdgFAOSV5e8?=
 =?us-ascii?Q?8PjSdQ1cvEqyWOjVhCKoILXiAlDIg5RK2mr4FX53Zs3J2QMOlpPpFfsB8fgg?=
 =?us-ascii?Q?oWNWoDnTXTDByYcltniSwDRYBJQT4SESMdhzqIhSSZZ0tKtrvAh4sCCM7sGB?=
 =?us-ascii?Q?vHAfC6TZY655PXA9KprqULMbJ4mcFLAaMvTRp9qt1dwZ21vglssKMt2zSgGM?=
 =?us-ascii?Q?q52+HTaCipXnb2YPhSJ2xXY3C1XNQkfdZvObBrVxJt7lij8QI3Dht3dOUJKE?=
 =?us-ascii?Q?rlGmJwENA9q931ovmhGr+O20cJGZ7vzPIxQvM0jWvb7jF8sXkWv2zTir3n+H?=
 =?us-ascii?Q?tlaZpQrt6XZ3PMRFR1bdYR2eQQk/kmtcxYymJFAjhLTvPT2OiVsAuV6MvIMk?=
 =?us-ascii?Q?R2vnFfG33B8PXH/9eJW7qFeMITcCh3K1xlTaYj4Ywk5uXYwFB1BwYi+lQdHB?=
 =?us-ascii?Q?nQnPVhv5YvJG6ysfBo8g1JhByFXvZoP7canx0E1qYxT3CbFn77nDzwXgTM9N?=
 =?us-ascii?Q?+D2BCpzUUe0TTMz/J4c3ht7u9Jk/FVn6XAvXDVjICey4LLkryvyLr/DrEwhz?=
 =?us-ascii?Q?FNxqwhumldC1Xzs72PTSg/xrnVJqbumfDj9pWdW4UGMngUhIMRFpIBy/o/++?=
 =?us-ascii?Q?YrIB0K6atYvHn4ZC1GsK0Oo/3kEnMXE70yprPutmtVNRDaffiy4doWZ50GP0?=
 =?us-ascii?Q?8zhlKCkpdVJNIbm8ilH5SOwVXM32fb+Ob5aBXB4YIqwfPFYgk4ldu5v9fZI5?=
 =?us-ascii?Q?qfXIKdDYClMEqPZGQgL5x/7bGYrVbCGs6XxTMmzhvaQ1eWZAvEVOFYM7aqMN?=
 =?us-ascii?Q?OP/XmVIS437NANId4sxeyr905ZiHUerFTqWjFshubJg2CVsrJuBHw4zYYzLe?=
 =?us-ascii?Q?J/j6Y9bd/kQZ8OV/eicm3oi69ganMpGYpB+YKKnTkJcqN5SDfvMTVu6dPdvs?=
 =?us-ascii?Q?d10+pXI4kpWRo1TDTedMXIR5ocq8/gcwJqwUuE9j7cW/2nmDNiWPVcDKbE/g?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 843867e5-0044-478f-af96-08da7fc3fc44
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 20:14:55.6868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J5P/E5NTgdMEUx0hMdylQco7I9+PHWqT8cufhBdSajsnciXiuVrK//qgq7wyxIxOesm2FAr9svrLYGbaz8YiDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6348
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ds->ops->port_stp_state_set() is, like most DSA methods, optional, and
if absent, the port is supposed to remain in the forwarding state (as
standalone). Such is the case with the mv88e6060 driver, which does not
offload the bridge layer. DSA warns that the STP state can't be changed
to FORWARDING as part of dsa_port_enable_rt(), when in fact it should not.

The error message is also not up to modern standards, so take the
opportunity to make it more descriptive.

Fixes: fd3645413197 ("net: dsa: change scope of STP state setter")
Reported-by: Sergei Antonov <saproj@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index e478b2ec13f4..2945819d0c7d 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -145,11 +145,14 @@ int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
 static void dsa_port_set_state_now(struct dsa_port *dp, u8 state,
 				   bool do_fast_age)
 {
+	struct dsa_switch *ds = dp->ds;
 	int err;
 
 	err = dsa_port_set_state(dp, state, do_fast_age);
-	if (err)
-		pr_err("DSA: failed to set STP state %u (%d)\n", state, err);
+	if (err && err != -EOPNOTSUPP) {
+		dev_err(ds->dev, "port %d failed to set STP state %u: %pe\n",
+			dp->index, state, ERR_PTR(err));
+	}
 }
 
 int dsa_port_set_mst_state(struct dsa_port *dp,
-- 
2.34.1

