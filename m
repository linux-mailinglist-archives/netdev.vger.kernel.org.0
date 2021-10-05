Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B596421AFF
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 02:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhJEASC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 20:18:02 -0400
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:30119
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229768AbhJEASB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 20:18:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Po7msqn9DWyXIOpKqxPNru6/xPcEsBTh+53TXriydcF7VOwDDomh5wexmHo88feugCGRFAPfJ4+W3kLTQovzOOesZ6W/hUX0wgWZYgQf9shnZLTqvpkXjdO0r1lRimqiVcRWiXPEfJmdMEKp7VnOo4XtgqhJ1BYB++UAY2VgE7ezrfEPNjyz3Hzo5OJ/lZk7RLeV/ZuzsUPlqMfq9EGGQCLLMjwMo6UKldFUeMObqQf91FSyVnzKIKZRGL7l2oErrdgeb7hk6Io5MSm5JX4HzRt56N5EHgxESw8JXnAJfyU1DAkUke/1b+YygOrh8hsASIOZxp0SPLxwKmatEyNjCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ts+2u/oNtk3+h2BBnoz+cNBwd/ECiw8DhJIaZDTQBM0=;
 b=Bh4MpJWPJr8G2VUw5LdGwdNf3O8DK2zpeeOhL7SFlPDH+nGVqFbn8b+op2b6NRpeTwbI/2//6+c4HoIVBMnFpxtXJLNFOxfdRyFHMmvRLpxPjEctFxHTlwvXBuO6Cbn21cIZIy/ChFUutYMMP6eRNsgWyPyK0JHwWveCpFQf6BfMfzaPGx0FtaZcQjdak9JCFNIW2dhJ6WzxnYpjCn1Tgh05k1COG9y7ew6IWbWiAPZvnXWALKVm+TbyCY4JpkBq2umB1cy23RCSZy8/PGwioGj2x+Gw9XTB/5ImZwDZU+yTgiXgRLriXrJ+14dXiJj9/GEd/zXvBVBesPJ0HjIQRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ts+2u/oNtk3+h2BBnoz+cNBwd/ECiw8DhJIaZDTQBM0=;
 b=cI0SSRQl3zX9urB/zuVlMuxMc03ujj/HjY9Z4kBSrKGyXJLSrMajpIsi9pxKHK0rmEvYI4QEK0KoFfoTHxTHjYvCTowtItyH7q5BMUC3IhMZ64eqOzAMG/So/JdTTj2OtQasnkcYdBULBO5jLC0sOXOW4DtsG70v6YDpl2LSNDg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3615.eurprd04.prod.outlook.com (2603:10a6:803:9::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 00:16:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 00:16:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH v2 net 1/4] net: dsa: fix bridge_num not getting cleared after ports leaving the bridge
Date:   Tue,  5 Oct 2021 03:14:11 +0300
Message-Id: <20211005001414.1234318-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211005001414.1234318-1-vladimir.oltean@nxp.com>
References: <20211005001414.1234318-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P192CA0107.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:8d::48) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM6P192CA0107.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:8d::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 00:16:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40507cf7-8c86-4031-1334-08d98795550c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3615:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB361536E74B1D291FD4588359E0AF9@VI1PR0402MB3615.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ppylv6qA67v1tNFNs3TxvSunBjqXTaPgQQpetG0UfHTldg+ji1/ossOLv4yv6xeVGNLkUa3akKHEBvIT8mrTBxzus1BhVD0tgLaDUIhuL4/D1V5xQgzuT/mFTB89ItALPlz/uDBr1sKu2ytGqleJC03K5JQJnrOXUM5Iygn3tEXENlgs8GNK8D80Oj4sAtqZUkry2/GrG0RhdcL60Kzr/Mo96We2foY1XCXT3WOE9kvNVdY0R7clHZPoIQ6Ten1qhGFOn/fRGeQGHcNIfD/46rHP0kkGIU3t3Je8YAikBbphV38hzucyM8grdVdGu20H4uneDUOylocLqrhGoK0C0PykjGFAbXzcviUgP7dbv4fsOlTE+pnLhbYYNbhshK1wl9Jzhkjm/7ql3wi3YrjkFZlA4fQrZhdqrIu7RkejMXoYNpRTEr9szO1LUfSty5IdtXy82Rg7yxjU4qesphzfcKT0vQ3Tc2jnsOzUZuLYmZW3hJcQkB1qbV4F0TIuqugIChs7frYcXf7uZBoBikUl7gTlefCrGfTwvKonPBBAi9fJP8MNqAfPgjasO9Wi/p7ZFuD286ZimhTazrUeIYlnLpCkUqzM7gi1TzGR/EPDpESoGCnjnS7KHcTbRJOFfc7RibB9lVdsoaRiTg3dw0JJ54LEteCoh1+BjLeHTvaUp3xINq/WR5IzVvDHd2lmmu/ZMWnlkX65ZvdJSfCDb/hjOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(38350700002)(110136005)(316002)(8936002)(4326008)(54906003)(83380400001)(956004)(2616005)(26005)(6666004)(5660300002)(6486002)(8676002)(6512007)(66556008)(52116002)(66476007)(186003)(66946007)(1076003)(508600001)(44832011)(38100700002)(2906002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pk7kOLBefLctsrh3MHZBJV+SH+ILFq2YZUx7WjJEcIWP2SmdjwAZjUVmBjab?=
 =?us-ascii?Q?EuL1YZ99sGT+OvAIfGv2MHnzzL2asFYAg+DsJT+zj+db9oogl5zz5H7HJCuC?=
 =?us-ascii?Q?euOx8iU7gG0FpaVOLVO4JTkwdSX44Q3t4sPdbyotmFpNNabiyGudQdDv0V3Y?=
 =?us-ascii?Q?WE6I0w7LOGN03lcHE16DDI1UkVN1cDPcaL36mFYSSC0MqauijY/w69nHeHpF?=
 =?us-ascii?Q?xAimRIIZJxhrRBNUTRo6f3l9JElghggwQ8yJZcrnQGuSuLkmpJVTjIjb81KR?=
 =?us-ascii?Q?ClxNis+QtRcKltPtaAANAceZwmHX2c5TW75o7mHlmueoOwxpyZwjJrEPmIil?=
 =?us-ascii?Q?nWcIs+iXClyl4VDo1igpfO5iHcjL9vQDI9k8w6HGUBzg2LbFdqoNJAMgx6yd?=
 =?us-ascii?Q?LADg7y01WK0SCmrxqN26KYW9rmVY1dnNOQFgTGBnv1GXJM3PaPUVUpTnTynC?=
 =?us-ascii?Q?bGM07YdFXycswcInLTXEYmXBRH8gorFiKJ4AH0MhYhdEpgBWpVKWwwVEVSub?=
 =?us-ascii?Q?iUceR1gFC1LH61foLWXwwZzb9/m4dSYtC7AEL9TzeIRN4tTz2wWhV/Cys9q6?=
 =?us-ascii?Q?t20QIjabkl6c4bOM73hn4XarKkwdLlniqpuZlcybf1cLLTW51jINQ6eT/6NZ?=
 =?us-ascii?Q?SVJT7gj++EnarFGq3BGa/N7NGfWeYTp/TcQVwTukXS9kuRQUqylXIkflgkLn?=
 =?us-ascii?Q?BUul6/9+5WxTypRG6yZ85imm5I8bYyb/HDUUseG/9nsI4CHpAw05ylp07ZYd?=
 =?us-ascii?Q?h4bLnfGpMtv6vsWEzifhm2haZuPvoSAlRmUuDtUyAiT2oxt7PHKFGJc/RMMy?=
 =?us-ascii?Q?4AXmxr/RxkfNljkfQ7h3dPUxNcEiaKc26wEYk1UxLJ1xXgHsXs32NZanIDBL?=
 =?us-ascii?Q?cygX7sGo7nZliuTTfMFDZyI8pqF1vXV3oZoPJMSmo0SJ0apyPTBmewWT1rnV?=
 =?us-ascii?Q?/KYeb7bdMcH1IITTpgVP1yjPPD9ipc1XuEQlPOto/X/tBr+u8vzsj3wRyfbp?=
 =?us-ascii?Q?Xtt1yumKUu7tfdFpUf8SQEMGMEShJeTU0qfYnKUICYhYfBksPTc9f+BGjYd1?=
 =?us-ascii?Q?jfzGsN+L4BGOHIe2MG3omZ8lsN0iO2r/7l9cXMeUUMBSo9RS2iLiCzm481bT?=
 =?us-ascii?Q?eAhiFF7egaDXzwI3RslUsLZqpgMpuly5eLnDUAi+Tof7JRoljWRHvZC3qvEY?=
 =?us-ascii?Q?ykzcvMFrr17oZ3KN1gBPosR5OfnEnrmq+YTNjmY4FvLtAsXI5HruYHxeDak/?=
 =?us-ascii?Q?YRmjBktL26rw5m3Bes4c82NH2lHINoIkz1f6RMVwJelgb+K3yqFGONfp7Zwb?=
 =?us-ascii?Q?Fdw527tM/G2pveQcvEA01RG9?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40507cf7-8c86-4031-1334-08d98795550c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 00:16:09.8696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hk/q/IK+lAy8DpT1B3ZKB5dz6JZ/9WedFJXLeKupdr7HczJ62GaPoPJVmcZ8JWHVz3EP4pLis1oTgXga8J/edw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3615
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dp->bridge_num is zero-based, with -1 being the encoding for an
invalid value. But dsa_bridge_num_put used to check for an invalid value
by comparing bridge_num with 0, which is of course incorrect.

The result is that the bridge_num will never get cleared by
dsa_bridge_num_put, and further port joins to other bridges will get a
bridge_num larger than the previous one, and once all the available
bridges with TX forwarding offload supported by the hardware get
exhausted, the TX forwarding offload feature is simply disabled.

In the case of sja1105, 7 iterations of the loop below are enough to
exhaust the TX forwarding offload bits, and further bridge joins operate
without that feature.

ip link add br0 type bridge vlan_filtering 1

while :; do
        ip link set sw0p2 master br0 && sleep 1
        ip link set sw0p2 nomaster && sleep 1
done

This issue is enough of an indication that having the dp->bridge_num
invalid encoding be a negative number is prone to bugs, so this will be
changed to a one-based value, with the dp->bridge_num of zero being the
indication of no bridge. However, that is material for net-next.

Fixes: f5e165e72b29 ("net: dsa: track unique bridge numbers across all DSA switch trees")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 net/dsa/dsa2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index b29262eee00b..6d5cc0217133 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -170,7 +170,7 @@ void dsa_bridge_num_put(const struct net_device *bridge_dev, int bridge_num)
 	/* Check if the bridge is still in use, otherwise it is time
 	 * to clean it up so we can reuse this bridge_num later.
 	 */
-	if (!dsa_bridge_num_find(bridge_dev))
+	if (dsa_bridge_num_find(bridge_dev) < 0)
 		clear_bit(bridge_num, &dsa_fwd_offloading_bridges);
 }
 
-- 
2.25.1

