Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2897598804
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344165AbiHRPuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344089AbiHRPtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:49:40 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50081.outbound.protection.outlook.com [40.107.5.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EC958B42
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:49:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeVnUPSA4Pynn4jcgveM1cTVlBmj863bpvrkiiOnFwsvmoIQzl/qAgTc+pFwGUUxzRTIR5gJKa8c9eWptkAbSdYjfJuk5KVaUKNDIdgNbQubPkt8HwmPEcmIRo3yKHJ30MBwc8CAu81wsF3ToV8WnfIS+jlp+wQc8yKn/ILN7e//by/Adnhnus4lUx2HIP/I0Jvs+tagcneNOUlP+EbQ/ETAg2scA6oViOCr3lptBcEmLkqXtPNyCsFkXvba2olxjVUFgfdd1k5A/IyKUmLtUkOB1lBqVNWeg0I2r0K4L+mKl8CQJdVxZAMnZU8oRnWRtkbX9xj3jgN7UxWt3tM02A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w6Wp+0JCB5kTvREHJCcnLZwFxDnEBu+ZtL2YfWLDr2E=;
 b=M/HeX4X6LYE8FuvaYg4rVgjaK5lKLoOYkAujma8ZckIhuy4eniNdjKHslvKD+pIDU9aGJnTYcTRCQzmFWLRRgeprZgDpeRJc6NwM770a8KISqdTxshqxh9aMUGOvvA7o/3T4XeSm686TdjneZQVqQIRG8m0OSLzZNp12pgbED8kIJqosdylsOKd3WubR8g3/5SG6IN0K1uTU6NoHIV1jJzdniWMRXbK5nIqALbb+wddrI2uDU2rx+3CkvJz1Mc+M2xdiJOi4/IEbTdwZ/CQ4MAhveKcWPEsy3lMEZIMXjhyimXIoCi1/9N9LGlJ+kPmdRs90oiBZiQXlauDESTXWOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w6Wp+0JCB5kTvREHJCcnLZwFxDnEBu+ZtL2YfWLDr2E=;
 b=W7LQz4sUcMhRYN64sRRM3CxscuL+N5xN6XK4/IuyREwYUT48T1sw1RkCvrst+JcVKOgUqmL4gHHUYZAuXsXCYiaTYkatYlQq7qlwwr3blsljysZXwUgffFuk9uJe/lj1XLlSPyvJVQ7lFAhwTem+bWYNr//ZXgb0rPsuXMzPfEA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6349.eurprd04.prod.outlook.com (2603:10a6:803:126::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 15:49:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:49:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCH net-next 07/10] net: dsa: remove "breaking chain" comment from dsa_switch_event
Date:   Thu, 18 Aug 2022 18:49:08 +0300
Message-Id: <20220818154911.2973417-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
References: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0074.eurprd05.prod.outlook.com
 (2603:10a6:208:136::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 555bcfb3-32b1-4687-d1ad-08da81314071
X-MS-TrafficTypeDiagnostic: VE1PR04MB6349:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cSExYigR4+dNbPNKd3C9UJrc7Sxk1HURVtQrdZn3fulFzUbvHaU1KD+eTqof+QuBgEJa1xHbMdy9AstRhGe96gDp4eYAfMZviUfK4zgrpVa72OVmDCMoAqKcE8bM/vyiI8Px2KZ/tVo1P6gHkvye/MXibv5Cz8mckmLariXXWNXjrMndbIuymvPPSqdsH18vCxxXGtyFTJQAor11TQGKHY5xi0yFpq4GZwFwIKVlPgt7OomqApk2nQ5U4c2Y+DlVwy/CZhYS8HVbVJTWWAh1g7v1jqjwGYX0YIBUbQHhfx+AYZEAvqsR2PwlnHs2l003EdYMMRXmuXM0fFFuOSH1CkcLpt6SnhVZDdfZSA3y7RizvvxTo49K20ymtPcxbah3Umt3mLwBAPxfvHYRJsu6Mqz81qRuJUNt22BKXVtbaK86CcRmbUWZlAwHX5gRhwsADudVXE97tndf2WllA0PHIPMPTfBjnQW3wpZVcOxm6tsOAKTtOyjv4sGnoLUlWUhYmhTOW/HtOpy0g7XxA2piMJaBcobei/eLJ+IgGrVdsXXQCyYS2pD4+mJB979Nhykohb7/50Kkfnl6ZlXvhrSCNnbh7827uwlOTLuFHP3Z9GJyqZMpDm2jqF29ansLIUBdispbq7iekFnrRZXStv9ruUt6+98fFv+rALdiKL1xjs5Ko2CdbeGfLEq2NwZzfyalcK0XbyjQCxzMMb0SQ2+9qqIVJ8RWhNAZAj7PrlOgNpHDVTgdFRDIGqHQMvNxO1AtsP4tN1DiZDDInIVn1p6zWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(52116002)(6486002)(478600001)(41300700001)(6666004)(26005)(6512007)(2906002)(66476007)(66556008)(6506007)(4744005)(36756003)(86362001)(6916009)(316002)(54906003)(8676002)(66946007)(1076003)(2616005)(186003)(5660300002)(44832011)(7416002)(8936002)(4326008)(38350700002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?osddddJydQOOHcbzQ8JemWk2zv3ZjUr+B5/sbWERH+J9kZlXwyz9hmBv/IYY?=
 =?us-ascii?Q?84TXcBRhJLcW2VyO5g0S5GVaLOBmiKVgemMy7HvXqMo5tR+DwXW2breHk1Rf?=
 =?us-ascii?Q?p2vvqnLFysY81OB5nIByltJ/QpeiYKGIMKWESt4b4k7ak7W+zozd3M8SuRyv?=
 =?us-ascii?Q?bahp6D524U1sQQtoq+XHcLxFN2EovoXRznPKCsXO6F9shX6PZWWIm+xL0vOj?=
 =?us-ascii?Q?COWOKiVw+kf/oLVtTPLyslPFJ7UW0Jqe72qkJaW3I6ClaXOIkBXUYLyGle6d?=
 =?us-ascii?Q?ld27BwmQh/opMbP/h/VkK3mp5wbFLsrcPMdusZ3MEustk6EI49OyAjqm4ZFT?=
 =?us-ascii?Q?DgZoiWfMJP8gKIJ2SgoXcfPSjPTCLNqyeutF0hh/FPR/8h/rdbFkO4zXWsfX?=
 =?us-ascii?Q?qcAgRzex+SaicgvH4chgCuIy/klor3OyjgBF9TijemHf6v6B+0zZwi74Rny0?=
 =?us-ascii?Q?fa+DwmgOojewZJDDf3trdDLXAsqfDUNIyVIc+pkdUTFnyM5gtNuDa+L4YC3u?=
 =?us-ascii?Q?w7vzHRtVxDcOonA7Y4NHZxBKo9FjgdvsAYs9jDvmY1fy6UBbZY0YSWPoOjh+?=
 =?us-ascii?Q?hMW9CAXtXujH6hP5XtcTofQHkbOfTXFzhbQyttZd66SoXQPeozV7JnqcRNwS?=
 =?us-ascii?Q?Ft9PW64YhyodWls+3Mfv/tvo0mckzCBo3j6D1Eswu2fxmzmqyOC6BKKPH9fO?=
 =?us-ascii?Q?45+3mA0Nkx1rxuWXC9sGPO9YbsGv7UM1hjSliulajPLjKfkzqMBYJBVUIPDZ?=
 =?us-ascii?Q?OIH3AIVDhRlUuFv75+xBGcDqpxRoXFkdaxhuBYqslSrNf6WSVmKcu1XleEac?=
 =?us-ascii?Q?iMGBZHkkx4MEr7GaCHFkxOd4xILrBXJ4MczTY/wHMEYDP11xhKuoUngWqwZ8?=
 =?us-ascii?Q?CEDgmGujLFjgHTBsA06//9vexIlYvb5oFvdrc1QAUY9mOyKTz4VRJtBJFqUR?=
 =?us-ascii?Q?5xu4ZYKlr/HnMiEBBNhPHEJvKaxX1X4en5t2UzInPUwwwffapFReu2Vh8E0Q?=
 =?us-ascii?Q?7rM7jJzwSNVvtUUyfBk/Z0vUOPn8no3UrfXUXqJVkpPTzPyv6zvwxav/4C7h?=
 =?us-ascii?Q?xkIp1/dwy5m3j7HfM31BHn9Xx0Z3Dbx5C5E5VEx55xmybMQrNgmP+U7Wo11W?=
 =?us-ascii?Q?4K91J90SLYsHfvMgSSyzOuskuBh+p7IjhMvI7WuZAnnjy4pcJpkow3NryaEr?=
 =?us-ascii?Q?3s2PUpBOo0wsCmjED8a+Rj7kS2n+rGM4z8mwlATEBkgxeVmycglUodCkqYWj?=
 =?us-ascii?Q?jl0I098lN+IXsGKiqr+pmXnpvTNAMNIiwfrADr3aE10uwrqrMKe2txEXPvTt?=
 =?us-ascii?Q?rCwiBvTeaW+t7WC/UDW+HVu0VJVtZrFo661P/UqloBb3M4PJ+hkbkS0lbCq0?=
 =?us-ascii?Q?rMLi9AeMEXWjWOSgMPbzaj4qD+tyLCUekfTyeW9iiYsi+MWi76315X/N+pRO?=
 =?us-ascii?Q?mBEGa+Fl1oYbCGH65Wf6+LuipTz/5FWVOfM5f01a9IgLpx3MI+ROc8eiD3CT?=
 =?us-ascii?Q?1tgvzxWEvaqSMiY+h8ZRgO3D5dTnmFpklojauAg06a/1Eh0JZyPEVswjEj0c?=
 =?us-ascii?Q?6WB1RWfamQYO0uDH3ItdCdgFw+rhflg+Jk0cGbDhft9RA6XxsDw9wQ6DpYf5?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 555bcfb3-32b1-4687-d1ad-08da81314071
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:49:36.2646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A74vDYoGRK5gdCj8gCMnTsMQwvyBTB4q7VdSTW1slC/G59in+D4lIp9tcsqL13hjqhXDniJ52k0y1LQ2tkMQug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6349
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of robust notifier chains, it is certainly no
longer true to simply say in dsa_switch_event() that the chain is
broken.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/switch.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index e3a91f38c5db..37875960d3f0 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -987,10 +987,6 @@ static int dsa_switch_event(struct notifier_block *nb,
 		break;
 	}
 
-	if (err)
-		dev_dbg(ds->dev, "breaking chain for DSA event %lu (%d)\n",
-			event, err);
-
 	return notifier_from_errno(err);
 }
 
-- 
2.34.1

