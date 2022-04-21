Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7259F50AB9C
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 00:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbiDUWp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 18:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiDUWp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 18:45:28 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150053.outbound.protection.outlook.com [40.107.15.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CD3433B9
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 15:42:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyRfm0+jD4B6JpFPq81bjqABSipHurH9NY/MgrJZaF0S429Rlj5emdx/RQZVlffhtTTlB0LSP0By2roVwCyMQFFiicx0+zoNW06Gpkt57k4fboeARImZq5LiM5gDT6YSEzMUXNqRaOH9TlFUsWlxufcU3Yl11ls8ojmHiBwCBvpl9PGnBNp0vIR6N54UohaXSEN62RApcnSn3SxUeb+6E6Nfy7K1FS60s04wcKTzPRehZffEKtiA1SAHvIKt5KYy0emgROUyjpIAqhuQw6AL8hfT7qHk1yNHUnurawalWB7GdIL4zvcVE7bRyzngmsCdl7tjRZV4R3ZvlKPbDXWS1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OzNwYl6cAo6kz6gF6cW1Umh8AQq9gqErICof5xN8pac=;
 b=jl1GQ+CiC2KI7C3zYEH0WEmH5x7ALzyj6uqFMeTnX6sebGkX1j0Af/vyYqQ5rAUOnB9SWlzuNkApYvQlQj20PDtF/c/gxAR6Z/v+Ds36PYbqlq+MoKCXLDv+pINID0NMwuDiMznkQpeSqcEEabjof0gAG1LKJ+MiO4N009bFy7KCE9UmhQIkXt96g0lGRr4QfrMTSZWVbuNRSyGrv21wvbihlOzfqCNVn1D95/vUzyNAR+uS+oNOqVwNY2NNvhKK/JjJDIcoTJgEl2B7GWi9F9o+ydG2ZOZiOm9EHvWdV4miNBsBEJDPKuTuwGT6GYziOIu19f2A7H0wrtfNWmOC+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzNwYl6cAo6kz6gF6cW1Umh8AQq9gqErICof5xN8pac=;
 b=ncHUiRxVOeoSxlq3PKi5ajTnYjFGwEa277BvTXJoct6U+XUC/Wqu1I1U2vXeuhGazBCquRcrCdWpRr/3QQ0jrNLWCle64v6IsXzNOtJEjH8wz8670hZfUXMqC38v/yfPDW0nN6rvGjvS3q67m8y8V7daqm/x+odKOKQ9R6PiRT0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4316.eurprd04.prod.outlook.com (2603:10a6:5:22::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 21 Apr
 2022 22:42:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 22:42:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: flood multicast to CPU when slave has IFF_PROMISC
Date:   Fri, 22 Apr 2022 01:42:22 +0300
Message-Id: <20220421224222.3563522-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P189CA0007.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:802:2a::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc7f8ee9-f3e7-4810-285d-08da23e83983
X-MS-TrafficTypeDiagnostic: DB7PR04MB4316:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB43163D9CABE0CC3E8740F374E0F49@DB7PR04MB4316.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HpN39LH95zM7Ns+IkiucC0ZrsVhSMr+fRJEZtQB/ommTIZMeZlwTTy9rig5uzwBhdjOTbWADquLLBGBRBHsFsCE9gUShCDbR1hRmv4vk7PPnleJh5MC4E6VWHoV43nYoQEEqe27zzT9bHWs/V+btyF45k1hjErER1+H7SABgOFO4jUvmf6TFSClG5EVJEE1vhxJc2O5+jMzfITENMpbgHJCkZ9AZBknBjLfWdx0AqKRhHzjLAioRjLevAkMuo0qa72KOQzKydsud5kNxrudIMOMqa9NOlrT48+2uliA56dLLVHMrpzK5G+tmmJL9MFmdmHKM8ZbDFTSuoLCO8MLrV1BeNWwJwCFkMLqRJ64Qygvv9Jgq/ndlpe1IwcGDmW3vuzD+87C8uxwSlN1XAjDkLMjef7Ayhf1Xw4wMhNfZxcvYdtyvacuYVkpP4At8+Mkhv+K6LOGtEQvABi4bh8zJvj9VHOyGDTK0iFx+ngYRg56zY3SxmXbRrF6hBKjcYoMwXlKS5ukrL1q3I7zMaCiqn7nYqgIrdo7vFQkN6LNboyFHUZUtBusWtdT0w4CBf0S2A8/b3dNMmrS2t7U2NV6iDJg/CQlamU1+DJIC1L3AhzWohcENxbwonS5g1R28FpAR1wYOzgCPLpHu3bC5F195uAVDqdff8GPWLCHGV4LF8wWCfbPGenoXfyhkFwPov4qEuygXux8eArIq6Y/MVK3ceg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(316002)(52116002)(508600001)(6506007)(54906003)(6512007)(6666004)(44832011)(5660300002)(83380400001)(26005)(186003)(1076003)(2616005)(6916009)(2906002)(8936002)(66476007)(8676002)(66556008)(66946007)(4326008)(38350700002)(86362001)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YDLosfuRVQZMzm/wboHagLQxCt7dZ03/x1jq6Cq2mC79Vwf2VnPLovfASc/6?=
 =?us-ascii?Q?Gxz8gNNkX3oyjCdUhw8HSDNoFxARRZEY6F8v49Sr5RCdcSpBdmWpj0s8SZVO?=
 =?us-ascii?Q?Bgy5rD4fNjNVbk+t3RF19QWm8As7mRIS/K2nZ2pMg/jAit5wGhgrV1+Srrbr?=
 =?us-ascii?Q?iEzjcJqSEsudXMGG+O48oEIonJHE/6Gz/KkD8OAbSgqlFOL+VVXcTnc+wGwO?=
 =?us-ascii?Q?gBSSH+7D2bJSwFjnpN8sg22r4KA37qNiTL7SlSnnz1OJbv4sFjHzvU+pqfZn?=
 =?us-ascii?Q?xVHqTHdvTHSJqdjaoB8eVFbxlXuNsYobKQC8loe7A8IwOtzE1P+3pW9hQI8n?=
 =?us-ascii?Q?j2ptDdmaJXWszWoOZm/JIr6t2jRS7Tv95Tv7Vdc7551GaNHLdgxBhXSl/yEl?=
 =?us-ascii?Q?AyqiRuw8ffD5z76Zz+4DH/jlYwMPCpw6bmVFH9Oerpk+Mfdjx9irfZUhpxyC?=
 =?us-ascii?Q?3AHvrJ+v6tbdnqS567GSj8kY+47OGbvlDyudm78StVMrhPwhBx+e2kMdpFCh?=
 =?us-ascii?Q?mvfRH4UNCOlN4nH8SNQG7WPGwJ06eJdZgO9xQV5IIN1yeSRwMml2ja0n2sMj?=
 =?us-ascii?Q?xBDTb9CYu0VnIjHtiIpWMVXD2GO+2SMWsNzxyH4B0njpdrottnXJYdyNS9hl?=
 =?us-ascii?Q?4PAkTT2gTkt1ByILMcUxobJWolsg6VtvHSOqz4psBEtXR61G38zIgl8gW0Py?=
 =?us-ascii?Q?IJLe2i41OGEeYzjTHETt4OH1GFq2ybbVOWFvuwZ2eOB9l1SXwq9yqgVQX5vG?=
 =?us-ascii?Q?nOGEAwB61QXlQiU9k8AOcGcpGSqCrS4Rw20rUpl1ag/Puh2rZ1Yp0TPxrmDr?=
 =?us-ascii?Q?l6C3W759/iOD3jy+87MREmUdBeCVyzMoAfLd56NSKjVSl7ewBI9v22MFg24U?=
 =?us-ascii?Q?s/7fte2GHiT8LHnQqCq7b/4bbX3sZtxV4Tp40JJlU7ozmD//mQWOKHp41yWd?=
 =?us-ascii?Q?hKm0jnWbB1pcoOiKDuCr8b9/HxpKbEYjewkkS4vRIAYTU9rwb80+NYOKvlnf?=
 =?us-ascii?Q?akSEgTZITyhdFEGNstwdruQv5SorJBkxyjqTQYixGmrhH/stjChc5hVh5iU1?=
 =?us-ascii?Q?kI3L3fO0WZFAHk3SfORH7/WcfQzhO7GD1Nu/BenzO/8R5WcqADAJ9U1AvPCk?=
 =?us-ascii?Q?X0N28ya4Sy4lyarrLvdPmfwc+aKc+1XvQuaArkpwsRqPJdiziSTuaFw6VTjj?=
 =?us-ascii?Q?PrYHdsUATvNt51uA1G3rvFK2QjvknA0JOTrLLpvbJUvf76+lpYwf7hxyPXJN?=
 =?us-ascii?Q?DmDBgR0XrmfEJuEovTv7PIS8M3bh51HnkWuzsp7SXwO42AQcQUhL89CqqAax?=
 =?us-ascii?Q?BBSWZAV2ua+JImEaaZvpGhoPDA62LHZYWTHhXHcXVFGA9fIWmPHkufx+eEKw?=
 =?us-ascii?Q?z7stGqQGFHCwpsOr42DNRIaqtVrY+yXEvEN/p5/ojq9Z0m9x+34pdnGF1Nxi?=
 =?us-ascii?Q?NmEZosN4AQ0i8G/vfqNscSutuUW6+NhV8hlLWz3OeuGhmMlCyo+wxT4sXDJ2?=
 =?us-ascii?Q?Mz7MWM9/XYuWgcHY4z42H+Ic25rSIGvT4ijTbtUM31vZDXNMPxdXwns4Nhjv?=
 =?us-ascii?Q?HfAhKKOn6E0+FDYHO1VCk5Kl/iEluiNBaHlSQJG+P+NKyznQfUvf7wY0sQGv?=
 =?us-ascii?Q?UT7YFGNjwFIz3vD3aZn2WihokCzoREJX3YhOi5pZY42lhGtnuFbo30vZnW+T?=
 =?us-ascii?Q?9D0L8IENbL0RhLYdweLRmPgejdLFUt7r+AwoAL+0MMPj5KyOLHaszC8CpijU?=
 =?us-ascii?Q?/O+q8hp1IRq7iycIzWBFnoCrJfyLiL4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7f8ee9-f3e7-4810-285d-08da23e83983
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 22:42:33.3440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kf7UhIYuI3ZJXg3V2Hh6kFWVjN3HlaFaBBXAwezASZzijtdkdqcYjxaCWjIg8RKe4UqVyYoz8zCPrRk6Pi5xnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4316
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Certain DSA switches can eliminate flooding to the CPU when none of the
ports have the IFF_ALLMULTI or IFF_PROMISC flags set. This is done by
synthesizing a call to dsa_port_bridge_flags() for the CPU port, a call
which normally comes from the bridge driver via switchdev.

The bridge port flags and IFF_PROMISC|IFF_ALLMULTI have slightly
different semantics, and due to inattention/lack of proper testing, the
IFF_PROMISC flag allows unknown unicast to be flooded to the CPU, but
not unknown multicast.

This must be fixed by setting both BR_FLOOD (unicast) and BR_MCAST_FLOOD
in the synthesized dsa_port_bridge_flags() call, since IFF_PROMISC means
that packets should not be filtered regardless of their MAC DA.

Fixes: 7569459a52c9 ("net: dsa: manage flooding on the CPU ports")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 63da683d4660..5ee0aced9410 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -285,7 +285,7 @@ static void dsa_port_manage_cpu_flood(struct dsa_port *dp)
 		if (other_dp->slave->flags & IFF_ALLMULTI)
 			flags.val |= BR_MCAST_FLOOD;
 		if (other_dp->slave->flags & IFF_PROMISC)
-			flags.val |= BR_FLOOD;
+			flags.val |= BR_FLOOD | BR_MCAST_FLOOD;
 	}
 
 	err = dsa_port_pre_bridge_flags(dp, flags, NULL);
-- 
2.25.1

