Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5195250ABC1
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 01:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392383AbiDUXES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 19:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392371AbiDUXEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 19:04:16 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10067.outbound.protection.outlook.com [40.107.1.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F7647ACF
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 16:01:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQLju82kcA6BvOCAi4cjqIlsdB8rGXrGHwYsoCtawA4zlurlXk0IY/5QcQScjuxl0XX/dIjtobom2hjXS4G9Engyp7nN7KZx+mi17s04MNNYm1asO8AiByT56BKfGZNNXIak9QvenbSjB7nukFp7EPDv8Z0P5FZd3kUQtxDQT7atA2Lt2oxbM1FmwFeqaUD1VV/uQLgnRWszLR3biAfgKYyl4C2Zg0Fvu13XjkXNBCKb88yEaAO9P/nwa23AwZ97mh4z89iNKCYco8NTRd1aU0hTAr7/KkSrUWdxyza6+PHMIVSJNdTOuhDi+M3yXzCptNQwmjtdd8gEGAAIV2xvFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5DAM2Rsc2mzcGeQ8J6iezYjcigP/ygWZSZAXX0fQksQ=;
 b=dE4Cjd33gAL3VmTwrYerBlawjwmkQ6Gxj/7/jpvhpbxZuoLhkLzkt1Y5pMSiVtSp5ttds+k6LXqWvWAzeWTQX2SaHA8KGuEEWafbblbnHLYR51fO8SWqrBmty5ZqI4Lip485ScYLe93gsoSN0aN5+8ESUP47aOcFXrWF5EkYU2ZU1AMaEVh7sfk06VnQ2FtwloDb5wxgGApxsViRpMS0BfypobZIMeRgSX5EgzR8iCR5aN6PIwD2cqoIIchObVo3ePoMEU/JOHjlsFqSrHM4xR61/51Gzpu55+NGWgTSCI/0yg6r4MIOk2bYNbU5F4ihVWTeoIrcXRRI2Yt6PDjttg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DAM2Rsc2mzcGeQ8J6iezYjcigP/ygWZSZAXX0fQksQ=;
 b=QyiMBrpZizrzJkVK6ilb5Voi50/aQzkqv7Rp1JrJsYaR0DHzSsz7Vhy7nn7m2j/Pf1qDje4+Qtf3TVdnqptUhHM5DgL/t9BTVTHqiObvnfNpelvsU7ncMw0ZZNCq7gYEeJ6OYSgO3nn+v0Sy2XNBahfRYGMYS+4Hyu8vTswjtWE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4077.eurprd04.prod.outlook.com (2603:10a6:803:4b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 21 Apr
 2022 23:01:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 23:01:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net 2/2] net: mscc: ocelot: don't add VID 0 to ocelot->vlans when leaving VLAN-aware bridge
Date:   Fri, 22 Apr 2022 02:01:05 +0300
Message-Id: <20220421230105.3570690-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220421230105.3570690-1-vladimir.oltean@nxp.com>
References: <20220421230105.3570690-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0081.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::34) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d067d9b3-8fa3-400e-042b-08da23ead8db
X-MS-TrafficTypeDiagnostic: VI1PR04MB4077:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB407716A82F54B8B006C2607FE0F49@VI1PR04MB4077.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HA7glQSM+x0w7tVwA9AXAo/besOeJ49L1uZJa8dN96obL285Hz+58hVFEl/uYrhdwTelL/fKBSaZcls2HAwa5p95epk69zLqslzw346BKZUBrTWgXBkUCxbJsUo2cO4190lRON/H9MF853JeR9cav7hHkmf+gge0d3gtBmfBN87nxrrmAv5oqX/gp+VE4VFCFmUzXplmO9CmTH+23/GaAlMRszxmP8yE9A+sbcmG1YzRAsXIU1iox4M5cvmZ3ts7kbBH4vYST3GVWB+lEYoNPe7daBxyf069kU9g7kYc2NuhJBbp/C+4w67uSlLZQfB60su33d1lcQuDIG3zczFOvXAzTlERFKvZjQUV4jYPlX4QYM3vQTTanaot2G9Gx3hKKEBVak/qUj9KzPxxWm/QyDkzKtxmutVBygAFWp5aBfL/QNTth2sGVdVb576ZEQtD50qQj0Ne6xFvz55au2lvoEds3sdek2/ptMBDdGMJGqLqQupsiI+Imvpx7IqqSLg1RPpKJSFGM6rPHhrTasl27bxhRwnWZVGh9xUdnzBGvmwBrjGZmQD2lAHlbmDPM4hUGzQhoCsHerZGA8M9dJRRh6NsIQkK+y/eYoRZL63dpqIvQmhqrSnO0ouEV7mHD4kaeekr/NV3WI2496lGOZcfJB7OFUh6gnYL2Cnxy5ICZ9Yyw3ryBEHY08hd1/zDZivfwbQS1qAbWADaWH3VYyLkpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(66476007)(66556008)(66946007)(6666004)(6512007)(6506007)(26005)(2906002)(8676002)(54906003)(4326008)(38350700002)(38100700002)(508600001)(186003)(1076003)(2616005)(36756003)(44832011)(5660300002)(6916009)(86362001)(52116002)(316002)(8936002)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sgrkD3LsHMsLIyf46Z64q+pfq5qT/PDi4VQ4K9tgUg2sz7ETLUqzwM70KnuK?=
 =?us-ascii?Q?bA15Ln/rrHIi22A7z4g1mrnz9tkWMpTIX65C6liM5t6omspxY0yzY4wQtI6a?=
 =?us-ascii?Q?fnHRcLNTpg4KlV5fyVWh1CSBFfUWHr22rD35x+5x77bY5iHNGH0vsJaAoYCQ?=
 =?us-ascii?Q?WXnm4gGyijrqCs2ZccNJrMf76Nx5dGbqq8sRoiCf4bZpQFdpTsYL0UOd/uxJ?=
 =?us-ascii?Q?gcD718DCnzAEbMcdJsqwAaa8siQvEYEOPvSwg5iKYtp+U2pLTLcc+vBWWGoh?=
 =?us-ascii?Q?HykLDQ+mnqUukPxW3VDFTvw8siH8HOy1KCajPsgj+Zp/0Gj1htrvCSvcR195?=
 =?us-ascii?Q?EcuEjuq6LClRJkd0z4owLYoD88jrQKIx/lKklPI2FDuBFtzJ24MFTg0uANEU?=
 =?us-ascii?Q?oQnGhifJUN24CiL/r7diENSPkIsjttJw5W52oqYRHtwUwRsJzk55uyf14KCH?=
 =?us-ascii?Q?Prs2L+g9LP8tanmj/2ohLGwU5tU6ohHbHcKyI/+LhKdQhmhxGOxy3fHoJMF7?=
 =?us-ascii?Q?j026/445YoZIM6yhkd1mGVPB9dywkOidnyaN3EhNqitwJpfoyviNO8e6RczH?=
 =?us-ascii?Q?hjji/J8vcyyXYr9pvCXB4iRepC+T3B7ak24+v0K9J9YR7I+4tBmmGKWBI+2/?=
 =?us-ascii?Q?/SMma3+mwiHPJKkpj1s3fnZtAlyM/bnJlg0io1LrPe5691JdpmuHxCYsywbt?=
 =?us-ascii?Q?PLiXv81sKaQeu9rT3QL8QxtiC7nDhJJ/hSRJLkn4QaVRhmCHBmuVxEsQuZR8?=
 =?us-ascii?Q?6t91pSu1+THIS0AMJ2szjpRW1jYnxwFGH0UmOcUul3nn8bOf4vko7tKkp2JN?=
 =?us-ascii?Q?v863vl/1ni6fBhVWyRvc1ZqzBd5ye8tRAoXwVrmmuwGCdoMe9b2+8dttMFAX?=
 =?us-ascii?Q?0gj0NXYARrxIoqBiL9fMZcQQ1GCpwiT0/mSdQSRvqFJd5YYWiwCUi4GxkBfu?=
 =?us-ascii?Q?/4wHXfAzxUPKvWGZSrKVSKfUXEoqNcjufIfyjmfSzjBxi5FQnuKiIIWwxSyi?=
 =?us-ascii?Q?OlsU80AgO5fHEokTBgBb9R0kj4G2mu3oMFI5kZkQBXOpHMCzB4sevQ5yJoXC?=
 =?us-ascii?Q?bAIK/U7zPwN36LpDzkTrgOdks2oUJILRTbJJs4fLjrZOazyW8wO5N4qH0QkG?=
 =?us-ascii?Q?LM2rEKfVjC/QOn2mKpy3jo2u/ELvWniv3RRcG7TfLYKmMVuZ5PxVNC58dfzl?=
 =?us-ascii?Q?T7uWNjmYQqcELWiSYOzNVBNPhpYROPIucAwQaldXY8AEsn7O8qVfywZWgeK3?=
 =?us-ascii?Q?pNt2dYWRi6ZWv++LTDnK0bgy+jNZufAIUZn5klgWxaVRFz9ZHB2SnFwSttrw?=
 =?us-ascii?Q?yVPGx0VuX+6DHhrfNWOjvA7nrswa1UF0HtjESFKMlLIe/KYjejeiEvb2TgXz?=
 =?us-ascii?Q?RjvIAgv3IOKF9rDj4iNQ8UbEFz0pqTj1cF3Y1ROGgsXa32YecswZsK+xsulh?=
 =?us-ascii?Q?NbAuUDa2tgoGRvKDONImNwz6PB/9U64AktSJ+ISYmB3CCUHthTQKxzSjPNCg?=
 =?us-ascii?Q?xyHRkAuyvI85h4rGzokRyWXzIg6USuJ2lWa9FKSP6LRFgO/31INIPuuBAmif?=
 =?us-ascii?Q?wMssLLJsCYFqwfiX/l8TAUCYSSNc2zLQTMbEa1yFoiBUJwac2l22AkGOxJXt?=
 =?us-ascii?Q?gqEe7bLtOAQAeW9eoJ7Z/YV7IPZO7BPu0DG8/3HCOx41dBy8a5vBtXepIoxd?=
 =?us-ascii?Q?zL8cHH1FVoDLd66JMrgHRqkD9bzzNmUYNtD1/7+0WETPUxMziho1yYl3wgTr?=
 =?us-ascii?Q?SQ/UgLt6sY/IZO1maOl4c+H+uz6nprM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d067d9b3-8fa3-400e-042b-08da23ead8db
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 23:01:19.5460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Pbb1p4ELnxONN9K1a3/c6Lo2NRdxnJCWWNsiQ5IogG/bWI3+bMdw3AHDTJeSjWUHB2hXEWwdzZqyz4p7fT3PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4077
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA, through dsa_port_bridge_leave(), first notifies the port of the
fact that it left a bridge, then, if that bridge was VLAN-aware, it
notifies the port of the change in VLAN awareness state, towards
VLAN-unaware mode.

So ocelot_port_vlan_filtering() can be called when ocelot_port->bridge
is NULL, and this makes ocelot_add_vlan_unaware_pvid() create a struct
ocelot_bridge_vlan with a vid of 0 and an "untagged" setting of true on
that port.

In a way this structure correctly reflects the reality, but by design,
VID 0 (OCELOT_STANDALONE_PVID) was not meant to be kept in the bridge
VLAN list of the driver, but managed separately.

Having OCELOT_STANDALONE_PVID in ocelot->vlans makes us trip up on
several sanity checks that did not expect to have this VID there.
For example, after we leave a VLAN-aware bridge and we re-join it, we
can no longer program egress-tagged VLANs to hardware:

 # ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
 # ip link set swp0 master br0
 # ip link set swp0 nomaster
 # ip link set swp0 master br0
 # bridge vlan add dev swp0 vid 100
Error: mscc_ocelot_switch_lib: Port with more than one egress-untagged VLAN cannot have egress-tagged VLANs.

But this configuration is in fact supported by the hardware, since we
could use OCELOT_PORT_TAG_NATIVE. According to its comment:

/* all VLANs except the native VLAN and VID 0 are egress-tagged */

yet when assessing the eligibility for this mode, we do not check for
VID 0 in ocelot_port_uses_native_vlan(), instead we just ensure that
ocelot_port_num_untagged_vlans() == 1. This is simply because VID 0
doesn't have a bridge VLAN structure.

The way I identify the problem is that ocelot_port_vlan_filtering(false)
only means to call ocelot_add_vlan_unaware_pvid() when we dynamically
turn off VLAN awareness for a bridge we are under, and the PVID changes
from the bridge PVID to a reserved PVID based on the bridge number.

Since OCELOT_STANDALONE_PVID is statically added to the VLAN table
during ocelot_vlan_init() and never removed afterwards, calling
ocelot_add_vlan_unaware_pvid() for it is not intended and does not serve
any purpose.

Fix the issue by avoiding the call to ocelot_add_vlan_unaware_pvid(vid=0)
when we're resetting VLAN awareness after leaving the bridge, to become
a standalone port.

Fixes: 54c319846086 ("net: mscc: ocelot: enforce FDB isolation when VLAN-unaware")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 951c4529f6cd..ca71b62a44dc 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -551,7 +551,7 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 	struct ocelot_vcap_block *block = &ocelot->block[VCAP_IS1];
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	struct ocelot_vcap_filter *filter;
-	int err;
+	int err = 0;
 	u32 val;
 
 	list_for_each_entry(filter, &block->rules, list) {
@@ -570,7 +570,7 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 	if (vlan_aware)
 		err = ocelot_del_vlan_unaware_pvid(ocelot, port,
 						   ocelot_port->bridge);
-	else
+	else if (ocelot_port->bridge)
 		err = ocelot_add_vlan_unaware_pvid(ocelot, port,
 						   ocelot_port->bridge);
 	if (err)
-- 
2.25.1

