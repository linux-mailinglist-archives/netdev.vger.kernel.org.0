Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A9A59A4FA
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350376AbiHSR5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350887AbiHSR4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:56:53 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2082.outbound.protection.outlook.com [40.107.20.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DEF11522C
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 10:39:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOW6QUsyAOOFcoxPPaO4xel6/3dXV8cbjP8j+1SwL1xIKUDGnH2bfHsTdDSN3xvKerwQTnZq5nDyezBKIfcGufbvJgvjJ8H20ZbpDOPWoe4mtFh5gNo858qWkhlYd6Db5UWmrctIbF1HgpzSzk7uNjprHrNo7JCS1PlH/rifzVdrEWWQYrS8db1Kp0uJYWMZdmk2qfZ2F7HtJP2pWSg4Xog5LxQ/mRtlzoHN65eBLogFm37hno1Hy3+z1lrMYw1ld4gCeiTSOgZ9dP3seDve7XpN2EK/pusaky8R1ylC2Vu+OQcOzIXXs9ygHtG6fPUUvv7QKnru1LNiUxlb7lt8QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kh3o+kNVKlwn+KlGemMsiylfnp/S4r769KI46nZOAbU=;
 b=ZB5w2aZ2imQlPUeax8/nBGB87TCKGN0LYoIVVLr79lvzz0udQiCUelbsR0RzwiKtmTjX0iN6Qd/FpQQiE/1QyZCFp/ctIIGD3BFhYPxIcS7dRVr7W5CRcdJfBUT4zjTX/fltPD3wQlai+2Prkj8A3+EU3YV591kXLEkYuBTFalnKEvFp1VGFAqDtMpZK+IyR3UKjG1a0f6KylvoUDeQCEwBY/5CKeILhiSVZ+YzxnizdO0LdTz4FwDka8CEct0di5SYE3P+NKCOfvBzUxsKIi1UJr0K/WnkHsODiqAo2sUZ/IDJc9fQ85p2mnyee4CapsaJkKsPoo2/93V/xOmXYzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kh3o+kNVKlwn+KlGemMsiylfnp/S4r769KI46nZOAbU=;
 b=MNbhNjVM4suINum13vEcNCjbUgDgXFy0LE2YGLJjgVsbO69xCIBVlwpcJcT366K3qUOfTKi/oqx8R6TLNoEQdAD4PvdFtEh4zzm0kV6HdV5TTo+46kbBZovnVJtHa3e2yKjPXhP7/NdFfNBz2mjRFcycjuyJtlqHNqUW5qQQTUc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7435.eurprd04.prod.outlook.com (2603:10a6:102:88::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 17:39:35 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 17:39:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sergei Antonov <saproj@gmail.com>
Subject: [PATCH net] net: dsa: don't dereference NULL extack in dsa_slave_changeupper()
Date:   Fri, 19 Aug 2022 20:39:25 +0300
Message-Id: <20220819173925.3581871-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0107.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8499ce4-508e-4845-1794-08da8209c865
X-MS-TrafficTypeDiagnostic: PR3PR04MB7435:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zo8dN7yjGlZKYjuatdqGoDla5dKuZbJPra2YCRoqJeJMzuBdf8KBMqRWPOVoa5F54PV7m1XJWndjykWZR0+TA9v2rzHtJw3CYbc4LCA/B3QiW3G8bJk02Eec0WZ4dw9D15uAMtSB0XZVaB4hp3Dai/oG9PIs9JKdxIVEYoEW2TFyT339IECeI8SQUgEHM1y+3EBBPE9zuZ1WrfceNpG9YnhT+bobwNxbxpQgAXLcTIcaBj6UHiy4bftoGL/DlEkQ7X9JdYJQIwqyrJc+rRYxf05EgZ7oxLBZUzGyWjaYc5h27M5wcC2sdwg7mR/bX8BL5TU49rYg+8TkPeIq9KpKHn2vXQv5UK+wjdLyzf6tIPaIGp1zFG0DUmcV4a5419gFOabhcJ9RCMtDzDMrBYtRb4Bl9rZuwtb0K0JHMiF5W6xmeiGavtE59FdGSld0uSrvt+6ZCbZnLNEd4hJpgK0ZWXpCtKSme0hBR8+L6tuhvJG3KrxFKIWjXhGEg1C8I/cwD/homtF4VnvOjalTxKZuSNLK51HmEerYHxZr4W0R4sPxF7vqeASMKTSQcbWeobT06tW3StmOOSRkzrEsPP8CC9wXZykUjch5FGVReVYtcnof10NxUR7JE4ihFI0XiuUNBnq9XxsMDvVz4486txLB+oHsluTupoEURtTRxHGF/cUgGVQqcb9d0KAzJ/oR24yujx67BqzBrQ2lr/LEeCo3KPoUpGN4pdR+pnH2asF6RdayjpfD1hFz1skLlbcjPCLcryjZAr9OdSIMmAmw9K+ElKdc8JJA6DMAukoKSFubqf8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(39860400002)(376002)(396003)(136003)(86362001)(44832011)(41300700001)(478600001)(6666004)(66476007)(8676002)(4326008)(66946007)(2906002)(66556008)(6486002)(966005)(36756003)(52116002)(6506007)(6916009)(26005)(316002)(54906003)(6512007)(38350700002)(38100700002)(186003)(1076003)(2616005)(83380400001)(5660300002)(7416002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kw9/2y/Or4UGLq00Grtg9HEmh4Y42JvXpJL0SDXUVAWH/aP6WNho7pJForTt?=
 =?us-ascii?Q?BqNLEH2d2LzNWokoiPnib5/LL0I3tAmmcR2Ha/xVR3Bb5RiDBdQPGhhQ+CYK?=
 =?us-ascii?Q?84ahgzl0ZDoZ13mZoZAo2o4GtB2sQe58ZL3nWmiU3N9+CvIpOPlELM9tt9UM?=
 =?us-ascii?Q?a3oXuufIbYAh1frydHBDNkzfAfBp8Gzyd9bzTwLAvpM0Ujcb70H6Bit28YTi?=
 =?us-ascii?Q?ouvNF2Nc0qp4bvnSvsGXbWOZQWI6flfYFyQOHyR5OBzJiTbi44sY/kaXlto3?=
 =?us-ascii?Q?0wQA9IX60hcDgZWhURCi2u/SdGu0EB86h/Xl5QMO3U4UGg+uubW85rh9CdB1?=
 =?us-ascii?Q?99eX4ky7J3QKrSByWjGwh58c+2WOjIWr+Zm04LC+RPmI2D6JGL5S6N3mD2sS?=
 =?us-ascii?Q?aCpA6cX8L57zyd+0M8/FHQwmTrjyBrmRjYqGc8E3pa/oDvCamOCRbTAHA+La?=
 =?us-ascii?Q?iRML1fThKRlNC6hqLmh6K2UHXZH4JwKnxhtfo7Rx5cnp4BOsTudYDoxfHoYI?=
 =?us-ascii?Q?rltgbj7m7LB9pm/odEJJHNjw6uuLy4djLa6nKeWzGFoJ7b66o1NCE6Fh5YgY?=
 =?us-ascii?Q?eJNtvXt7b1226PaxxJEhANC5uroi37d+7VAgnreiTuzvXCQOBVRj8yNLd+EU?=
 =?us-ascii?Q?TqccwjgHf17KCFoLkVGbXeGET0pwUicciu3NW0XmUxB9rVyjvc2wwHgFPwEF?=
 =?us-ascii?Q?qaTnOTTBoI0YlPcFT7EthC9It5qtSk9MxBZkrm+lAVEkFkYiNr5AAYKi+4Mo?=
 =?us-ascii?Q?PnO7/uXk81Q48Dk7ebtiBx3G/j8BV3/DUS2mcX0BDt30VvxPNSb6LH3rt1Fw?=
 =?us-ascii?Q?rKxff0lR7emDWPkhUFa1HD2aD/X1JVAstlnM/GPzZ1yW61Mr174mBhfd+eCO?=
 =?us-ascii?Q?ARZU3l86kBg80E2S4hI7PXbhKlXpEisT7N/ZbPH/PszdpY8GEipJdDry7f4n?=
 =?us-ascii?Q?7Wc3cBW6Ulij+MUWfb4V4WXM9xoImwLlXGW6VG6gCDHNZqRfigITT2daaVF5?=
 =?us-ascii?Q?A+Rii+YTCIyEZ9fvycPAmHl3tkTVrWBXaC/4761R/VdlFPYPbbzqeI8LgYbZ?=
 =?us-ascii?Q?H63S3/crNk8qkQhbnpdrwhrjtbqVbc1lxA2LPxgcsyGE0wrIDmVM7pEzYiPG?=
 =?us-ascii?Q?e2h5oPoWTXZohuK76jHmmkisHjJFTdkvkEMkqZGB6wDH79I1PPQx4RjDS5M7?=
 =?us-ascii?Q?FxYR0PWG+LADzEzWddrrspH3/Qb9Ju+AM45rn/2+oSxJszosfOyapkXKhHCM?=
 =?us-ascii?Q?hgyXwddof5RTYnKzEOgVe+epSovZMGZRvgP6dBhZ2Egqfc3lx3Bzbsz7OHL/?=
 =?us-ascii?Q?If3hNsvlkc0jerF+ahTHSvTG3W+ebN9G4nYI8EtDU5e0P5Woj7Tb+MJDExc5?=
 =?us-ascii?Q?WhtULU7uJ5nkIzrrtE7V7unD6UOzFSAQZoXq8Qo+mf4hW+A+aSF02xXujNVs?=
 =?us-ascii?Q?8WO1aQ/qeD/0YSmZCiFKFuv1EFvn3CtQEM9gmZvUtNF3iDFhpLpOsuVU6EtI?=
 =?us-ascii?Q?Iw4zDoRQdKJLXAxQYX1bWsDqiC9kL5m09vjGWWv8p8Iz+8UpEZEF4HkwDaU9?=
 =?us-ascii?Q?eE6gV8LlKOD3NERlLvyHT0C5ZsUZBhKdaWOfIiWaBGebb7OHCYlbfrl/dWXp?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8499ce4-508e-4845-1794-08da8209c865
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 17:39:35.6762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Q2wdKU7Y2bANWOxeF2O+Y5VVkbNGm6v3ckNZyd1jjASTZaWjme3LLVddxM1f9qzJcjkr31BBYU3Up4pYZoLJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7435
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a driver returns -EOPNOTSUPP in dsa_port_bridge_join() but failed
to provide a reason for it, DSA attempts to set the extack to say that
software fallback will kick in.

The problem is, when we use brctl and the legacy bridge ioctls, the
extack will be NULL, and DSA dereferences it in the process of setting
it.

Sergei Antonov proves this using the following stack trace:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
PC is at dsa_slave_changeupper+0x5c/0x158

 dsa_slave_changeupper from raw_notifier_call_chain+0x38/0x6c
 raw_notifier_call_chain from __netdev_upper_dev_link+0x198/0x3b4
 __netdev_upper_dev_link from netdev_master_upper_dev_link+0x50/0x78
 netdev_master_upper_dev_link from br_add_if+0x430/0x7f4
 br_add_if from br_ioctl_stub+0x170/0x530
 br_ioctl_stub from br_ioctl_call+0x54/0x7c
 br_ioctl_call from dev_ifsioc+0x4e0/0x6bc
 dev_ifsioc from dev_ioctl+0x2f8/0x758
 dev_ioctl from sock_ioctl+0x5f0/0x674
 sock_ioctl from sys_ioctl+0x518/0xe40
 sys_ioctl from ret_fast_syscall+0x0/0x1c

Fix the problem by only overriding the extack if non-NULL.

Fixes: 1c6e8088d9a7 ("net: dsa: allow port_bridge_join() to override extack message")
Link: https://lore.kernel.org/netdev/CABikg9wx7vB5eRDAYtvAm7fprJ09Ta27a4ZazC=NX5K4wn6pWA@mail.gmail.com/
Reported-by: Sergei Antonov <saproj@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index c548b969b083..804a00324c8b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2487,7 +2487,7 @@ static int dsa_slave_changeupper(struct net_device *dev,
 			if (!err)
 				dsa_bridge_mtu_normalization(dp);
 			if (err == -EOPNOTSUPP) {
-				if (!extack->_msg)
+				if (extack && !extack->_msg)
 					NL_SET_ERR_MSG_MOD(extack,
 							   "Offloading not supported");
 				err = 0;
-- 
2.34.1

