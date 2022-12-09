Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8136C6487B6
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiLIR2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLIR2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:28:33 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA8F15709
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:28:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TwLv/z2VxKMav4bD/z003wMwIqWcMuzlcLFLl2VvjCO4MPH1RFXtIhPLxXKxQDdTjUj/7Cf2qstig1O2d1EgL2XAiHIhrIxfJXSkD0bzzCLSIaCrafQDE693uClNBSM8+oB4gI/wmxC/HTcjbf8h/ci5lCTVKNELPyIaFe/Vb3u19ET74wpRswVNLh58IJQ2OeDgAEyHnGy1djNlz+DpbG/VHTGfVc0ycDEIaDZvStwxG//5s6gdIEUgrsSM0xkrIKFgxYmAxYwaO+UzD9KjK0Muo1wiewaIidF5++Hxw85u5MaZMCv/iwmJZCPyk8seFBfmvjINkx9Gzj9eqxYt3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v2Mi8f2JwIDuE+Fuvxw/lE2X9wuW3Nx+g2Hqs6LbD7w=;
 b=BVpeXM/LBhjPalBDfnQDZGoeyRWWctbdx2mTTT6nv0DA7CP4dupLh1/fl8/Yngndl18uQl0yXZG1wQfO2crXF7jhi7e568jpPWdkUIYIqmtP3WgBybWvmjnD44u7ZI07T4KVmggl+UVFSY+JjcNdBft3N1W5PdK1G6IMZGyIjn3c6BIH8CWChfleE4zjp2TwNVufk2jVamku7zFOyPnJvXtvVzH1XCPz8oaYpqZUqYqCsuHfKKaOZGvCcbsiLm5HK5MdtWRMzbYXTyhdtpBsIDgsF7qWjfvinKFdfKZogNCPkThvFeSrHQHZ1Shqhs+URHKKkjAcmJmx0CKTjrx1XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2Mi8f2JwIDuE+Fuvxw/lE2X9wuW3Nx+g2Hqs6LbD7w=;
 b=nJcjPVs5ogGPd5U3HVx2tnzvva16AZRmiEcm1y+7zCnMSAuaiuBTo9e5vkK5C4X4kIymTIuTBlTnGxgfCKCZG4WYQs+I7+p5vRXl8Jv/wcPbdOvD+Fi8KAG4L4+c2I0FIQHTYxzgZMqxj/10RhOFvPMEGZ7dfN5pvOaZUAf4PPo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7253.eurprd04.prod.outlook.com (2603:10a6:10:1a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 9 Dec
 2022 17:28:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 17:28:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Hans J. Schultz" <netdev@kapio-technology.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCH v2 net-next 1/4] net: dsa: mv88e6xxx: remove ATU age out violation print
Date:   Fri,  9 Dec 2022 19:28:14 +0200
Message-Id: <20221209172817.371434-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221209172817.371434-1-vladimir.oltean@nxp.com>
References: <20221209172817.371434-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0060.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DBAPR04MB7253:EE_
X-MS-Office365-Filtering-Correlation-Id: 61625e88-3263-4052-4b84-08dada0ac9c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IeilxyI2AAcfaRCpe+iQ7rI2olQ3erZw6cyjEkG7DsnUnZrZo6NtZ8LZKQWOQF6DfAQht3Pw8hC0WCrUfHzfi0Z+HA2LbzRyBwfsis8g11x389aBBtw0HWDsSdpK1ZSs4iOX0sP3oZDM4e+3LVf7xm+5uy+7jjYOpEHZnBHW2/75pgcrN8UqXO37eD70RXVj2iCHXc6Bq8gCpVjHJUJNjFJVVB8ccqpbUKd7zTUW4Y8YpR/TuwT6SU82b6aY1C1vAqTlriKNYH4KCRhMDqXf3S+QGPANw5Cm1Twq9Mqj6o/POqOxcig5+CxVeoCKHCTs/BpT94da74N/5a5AM2pI1d6UtKmHLBVrSCxNUZD3OugeukdGoBlhIWfYAGcLWtbqwlmJniXV6e8LygIntgZ0ApVwG0T3bPvrf8/MFmzho/7qPfPpEzoeAazl4zHyE5VEpk3z/AvMXBYzT70rISAliChAIj9uXkzGLHJtI9bcd1MeWtL0e1xfSMLohwnTgZCkF+xwMYHcYf1LR45eR3w6gUNVNkQwi9HCQI5P6SLckHJ3/2StUn2XKXuL4NvXpFDJs7BouqDnfQf7z4chYOLXR3JPBkXdzk2DJ59Z0n52LvF3+vHUtYxQhLohN/HXabvi13V2eNePmiXtCptTUFMNc9ijQ4lyr64yjOC13RWbC3S5SjCXHnKfl8k1+JljhQ9EPahG6j9EYUC85j2G//bItg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(451199015)(86362001)(8676002)(6512007)(26005)(6506007)(6486002)(6666004)(8936002)(52116002)(36756003)(66556008)(66476007)(66946007)(83380400001)(38100700002)(4326008)(54906003)(6916009)(316002)(5660300002)(41300700001)(38350700002)(44832011)(2616005)(478600001)(186003)(2906002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bhF7JAUYNy7qyOAyMy9hqYj4uYQjqODLaRQ4w8EU2NScDU9OvOkwjhIqrjKN?=
 =?us-ascii?Q?wYb7FejFszstczEwO8VxX6Hsuypk7iqyGX5ZLPglzIEca2547wSsqnw/xYsB?=
 =?us-ascii?Q?tUj+m5l/EPeD9wJysPGdIakGq+nTwfsiJckRndyI/GuJWq6asljTt2MT7sl5?=
 =?us-ascii?Q?lnRnDsKc3H599Cu7Y6olEFRfuSXvjJt2ZwF2cNS9yqZ9ypSIPqetozm2c/xa?=
 =?us-ascii?Q?l/OK01IGUN4yivopoUkzpVo541fEmj+0x2E2QhJnHeSTn9UBX+axKVd4uChe?=
 =?us-ascii?Q?KKZxqYwyXa3Va7W6PmgsguYVtGH0bqptJ6rNHLU43Jo8s92JNlxG51TAk3mv?=
 =?us-ascii?Q?9Thx8kyRl+px9WWJfLd8ftuFD+SIzicPr8d9ZOVbc6+v8dkT250lqawxktiW?=
 =?us-ascii?Q?H4ryYWID8x9ONsY+mFzH9yrjiB7EDhjf7i/EwtoRE4SNn5rb4+Vm+BnyGfAk?=
 =?us-ascii?Q?f89ojBcUUEYYi8aCf4p86u0Hmw0ZaP/lYCX+mNJ/MwXIzqcw7ug1UZBFMHJ9?=
 =?us-ascii?Q?o39J6uq7YenvIitbgQ/tAx63aU1iMMqRAQsBf+PBd1E3lqw6LJAat2E326KK?=
 =?us-ascii?Q?90JY3X5oeqjFiAaue5TyOx5BP/FzDlJMn4OUyVCQb/bhyDd7JQhH9RNmSDST?=
 =?us-ascii?Q?aGu4aTgZpu20f5//osN1gd4MXtwrhib9F34EflZAaE5yzA/SLxAuETaow033?=
 =?us-ascii?Q?FogpMpf+G6+rahmZa5ITYI53ap+e3MsWjEl7w4Au/zFUSKSy/BHC0U2YPem7?=
 =?us-ascii?Q?nqoYnr3DPxtT2ZNTGpdW2No976ukfxyFFtRp4zJZ0HXbgt+wByUG74C1Ulcp?=
 =?us-ascii?Q?ghRzRHPIgvU/YbOva/VN7PJ4/iMZLhf3/9uFr9s86+NDwuv1SOpkky+qO9pC?=
 =?us-ascii?Q?mSGxADAnSCMSoi1hIw8LFOa1POyT5HoEcbRL9o1rcoZP/lN8Z1cOai710chF?=
 =?us-ascii?Q?mAZPwmW70qd+RFzrONJncwZAr9TuyZe3NUaF8RHlv6jXAX69PCeDhklClkhS?=
 =?us-ascii?Q?DO9V4d4RBtmIl8XJb7F6e+r/NIuT09o7qKfvxUzZCN1qdpRgu1UoOtydUGCz?=
 =?us-ascii?Q?UZt805Eqsn+VMknKwqsnP+yNKkvjw3B+n9RkSZq5lXi3QKGtsfjEI+vlcvOu?=
 =?us-ascii?Q?3NDvpov0sZD8CK5H+slVSx/BLLhPFJ4HD8tCw7WKrG6vkNmxoo+7Wo3QF7CO?=
 =?us-ascii?Q?Ege0IRxEq/HbisPhqS4BUyIaXstLSjSKBtue2O3qrxnFe7WpFr3HzB17l2RN?=
 =?us-ascii?Q?tVarExLGyZTtJzOx9kuZ8HCwDIu3sIKHNBq6rPmYA3lqL/Lad18arErlvYjK?=
 =?us-ascii?Q?RLQtmj8BIqc0P1iP7ni8lcTZ8LPx3bc5JfX1Ob9tPcAbXKpfZHjWvQfkViJ+?=
 =?us-ascii?Q?oYKEaxVwgxQWtJbY7xc4cMFNNZhDpJXVZ2HieLF1+N1WjHOKVsMFxit9Ffhq?=
 =?us-ascii?Q?7klutkR/YBn3lMjYS0oa0uX1DTnMUXEUTrCsDnORSrxPJ5Ca42io/7rIkWml?=
 =?us-ascii?Q?p2I/36SIZhAYTWbIAgpDGIXeTW5A8h46vN50p6sHdml5dtslMBWdn4kJZPnb?=
 =?us-ascii?Q?d/B9uyPZ+POIhs0B2F/Tlh1fcz4oGZkj+lyaUt6+Rlc/OQhycSonw7gCnVLB?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61625e88-3263-4052-4b84-08dada0ac9c5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 17:28:29.8524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IuPml1bu6YX30XDSQ+A4MJSPScdWf63tcBaWZTU4iy6d0lvX5WDCENKW3XHC4V16LLx9TZJ8lfjQsDq13IR/ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7253
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the MV88E6XXX_PORT_ASSOC_VECTOR_INT_AGE_OUT bit (interrupt on
age out) is not enabled by the driver, and as a result, the print for
age out violations is dead code.

Remove it until there is some way for this to be triggered.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 drivers/net/dsa/mv88e6xxx/global1_atu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 40bd67a5c8e9..7a1c4b917339 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -378,12 +378,6 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 
 	spid = entry.state;
 
-	if (val & MV88E6XXX_G1_ATU_OP_AGE_OUT_VIOLATION) {
-		dev_err_ratelimited(chip->dev,
-				    "ATU age out violation for %pM\n",
-				    entry.mac);
-	}
-
 	if (val & MV88E6XXX_G1_ATU_OP_MEMBER_VIOLATION) {
 		dev_err_ratelimited(chip->dev,
 				    "ATU member violation for %pM portvec %x spid %d\n",
-- 
2.34.1

