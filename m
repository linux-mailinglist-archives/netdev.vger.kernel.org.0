Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F474CBF60
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbiCCOCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbiCCOCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:02:38 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80058.outbound.protection.outlook.com [40.107.8.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56711188A08
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:01:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9ezQdSbZW6gDmspb7gY3u+aKqvWmPgSHdkXp+hIiDSqyk5Alf3Xh9Q6+MHFZvxNqqbDDdrI0b37+Yftn8GQCQdrfULC7RFxxei8TlIvbZQOj40w6erYD7wpk7P+Q0keIdGbVJioXmkS5ir4a9J5qrTCx7S7phpbskRbjgOcS2NJx/yaEolbzUmEWRoy3bdhk5unMV7vRWsjcVGCaodZsXZEPIWmaPP6dtnbgP74tgv02EKhuX2Uh4ahUGR4nRqHMiwkW2tf/U52mstz0f6bcubkaxPrc1ys/iLVgBuT4GF4ktpvp3uk3JL//8j9qqs7F4C5sbCgP8lt6S2mSzOMeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8XEfFJdsJM1tsMUa7vJNpdMZeWBlaLN4RYyR3JY46GU=;
 b=jH+Mb1V10KHyufM5SG3tsVJPeQ39vlUCpGLRpTiQDxdDHYHPgmBq7zHxXySFb4uOd0AmnA787LQjCxGIMNW2KVGg8Ijc9nsdxEjJYODtwojaUwkI7Wqms/4Y08aBzxXzVbWX22+uySoAkLo+OtP1iysuBabHtdsvoGDY5P4WNlvEDNTFnWPAQqqaC2Og1zYMS7YhcKMCukebzCW6BU5P6qhjWZGMnfpjaXqchGNjyayB88Uea1TNojUtI3hhIj1fxoT/fOOvtAcvnq4sTzlJaUooMU39FZiccAqomf2F2rY6KKJWeJZp75XwUKi4gtXAl4G3tvpNTHu9vZt5TuFxRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8XEfFJdsJM1tsMUa7vJNpdMZeWBlaLN4RYyR3JY46GU=;
 b=gPyQUf6H5wz1TKxDejoulXJ7d6hJA5AbYQi8al8Bw4hcM1nOxvILikVT43hTdi65x0u2oodboIq16rbHe2Nhcx9MFSB+D72gM6u6SwFg8+8HJ0pzN5YZY4oqNG3AAaXUD3juWc+IfGccQM2tKOa3QFGdYXsYWKb+2MaCsBWt+Ds=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8879.eurprd04.prod.outlook.com (2603:10a6:102:20e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 14:01:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 14:01:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 4/7] net: dsa: felix: drop the ptp_type argument from felix_check_xtr_pkt()
Date:   Thu,  3 Mar 2022 16:01:23 +0200
Message-Id: <20220303140126.1815356-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303140126.1815356-1-vladimir.oltean@nxp.com>
References: <20220303140126.1815356-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:803:64::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7a8f2d8-a2b2-432f-20b3-08d9fd1e5a1c
X-MS-TrafficTypeDiagnostic: PAXPR04MB8879:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB88798593616FF9C521CD151DE0049@PAXPR04MB8879.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SmYU5RqVZ2Rm7QLovnoLsxasUQYJ94Q8Ow/5rdcnRVuZnCxuPFXQxiaLGetx7pEb2EAUA3k6CKBfB1m17o7YkV/bDSuN32t9DIdKF60IsQij/V7abuMNcTW5dmuBMTeGVmqsTive1LLEYlPIBjDY2RG7MATtfyX1ixGqClshAHsNTrXb475fNgec3azTVrBGj94gYYnfwDfd7ub3Srx4Bkk1pVFOejUy6RanPfR/l80gPDcHKEKl8qkDLSEeF/V9+sH/N3KlDBbRD2e3GcMI1BlY1cIq7/SX4J46UlvlpYC+En/qSmwlV5bWosvQ81Qz2dDZfVnOBwCXstsOaqyyrFrGGfq3Jnakf0PaO1YxtGGMuklo69cX+xHR9I1uZ2we1i9KsFEmkdpR8/202QOVUf7K/xcJuwJDylm09hpICDuyxhV1rSPrmElJk84BV45dxuhonuI055ZWSFXxTD4R5PoIY138hJrCb2R0RX7UThLXReFnBVAhfij2YBKkhrpMKlOe9k+PvPviESujeOUSt6mYnipMCnJdN6p03fOD+wms8I4k6nNU4VSA8cu+VSm2gRIFJrmU62g19Tsq/3eLqzwW2nJHeij1l5laBuuEeiF1eXWCbp6Qs/TfLi0pVDiyYiccf1KV40F2BVGkR5ZhjTIN9AfpcL8HXdFBs7NEeMxT+IRAHAVKLGHGaQSw4vBAWBZbw5lagQC1gHakMpGyKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(186003)(26005)(6916009)(316002)(54906003)(8936002)(2616005)(66556008)(52116002)(6666004)(6512007)(66946007)(66476007)(5660300002)(44832011)(4326008)(6506007)(8676002)(1076003)(508600001)(86362001)(6486002)(83380400001)(2906002)(38100700002)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ScPGD2u0/aFYHJEsJ95aeOjobECX6HMZyxrWvmoFBRSxyynJ2AL9gXEBIbWe?=
 =?us-ascii?Q?A0DTAKwOG4jV9JT7WN46ESbLez/eQCV0i4zrqpIh6UzgX6lyd3L2IfubjiAv?=
 =?us-ascii?Q?rYODwAb+tlNNKWyQe0hHJQvBEJtFfb2WOBWKWwkS3JF+x0OBlCjxcnbPfXU9?=
 =?us-ascii?Q?yPairF4hRBMMMYQnRGYQRYoYJMHizN/eQ9niJ3g8M6AjOz1+LRm7whRi2dp1?=
 =?us-ascii?Q?AwCi0iItUEbq9vaup0IxX2cMBSdK2CxOhmjJI8fBWYgWBRGbz0Jsg+Eqa9XX?=
 =?us-ascii?Q?fm564euJimEj40DueSFZQZzJS3M9f/Wol7xoauXIg0YDKPgQ67gCMrcdK/9p?=
 =?us-ascii?Q?ZPyxCsadSSlji8jxpDCzKckBbTVP1AEeHIDrhFSGkOF99tBv/Lucp3TJjPun?=
 =?us-ascii?Q?bErT2fCFGfKv2pOADNRtlMXI0I+I9jzuwpnoVvkQqjVMVrucaYxuq5T6DP72?=
 =?us-ascii?Q?2ySYz/2TigsmOO3jwtCtVlFOvC3CJNN+/7ZDm7HEWOXKty04oXcRM87f+iOw?=
 =?us-ascii?Q?UdZP0iFR2z8XqI/FyC3OOy8ltgeUhRjMYlJLvjObBVcgpuP3lYuSQGTNeQ52?=
 =?us-ascii?Q?iQgDQKYFZ5XE1nPTj9V/UrviEQs1l4anYyYHFm/iVCOoY5LrFsRlAgH4RCT7?=
 =?us-ascii?Q?+mcBnPHb4ggr4q6u7H/V5Imswq+GAU4GAIxzYXjXDUIzN79s/dHxDmpWbN4f?=
 =?us-ascii?Q?t+2P4wJPkfbJjNQZpkzef/CdZnog5oDtKoa1xe1PWWjQTGt0vhCCA/ycQyTF?=
 =?us-ascii?Q?7kY6dZm70hOH3uk4WWyxjKS0X6tN/xUuJFaOj/KRRJNFlDoSJCOinLAduPIm?=
 =?us-ascii?Q?QQKqRADrODhP27B0APnoE+HqD92jWzjZXsGJC16Dxh8F2ob1HNUUmtK6OGLt?=
 =?us-ascii?Q?AVNpVJKgK7ZGj7ZDqXMbXXcPnt46kWsNfMvS4sEmkGvzCQw1MYhWjA86FXij?=
 =?us-ascii?Q?pkxzqo6G9FKW2JRDm/TbcOm5pQc+0QAZcrMHnF+soES3dY6iThtK+/YCE1T/?=
 =?us-ascii?Q?mZNlCbN3D4I438GLh1O6leS6DrUySUrRiH/0KQvO4rUR1elIwAQKThjbp0+o?=
 =?us-ascii?Q?Aw+dqwTf9ieJWYDKaTCUsQoXC0RP0zpbsvDHWd87IKxMLlNahY50oha3kuy6?=
 =?us-ascii?Q?9ikOpv3SJJgdW1K9gtDnk1NFybdAXy2kD1Grudu1KacK5dIUQg5Ly4pNuBzF?=
 =?us-ascii?Q?oj4u/b4nPJ+AIz0wmrAI8HPtqxUwfS2fX3lwhPaWhfx1qeglFLUVO1b/+ZZh?=
 =?us-ascii?Q?BIygLP+FLBBAd2OZrX5AM5pac4gseJQ3pbVWXfX7bNohb8/gmSdubWi4D1yF?=
 =?us-ascii?Q?7WGc4ggPHDOWp/wj7TS5OcZ4m2GkXv6FBjuIQGOmjW/TzsxsBAO9sqsPPLag?=
 =?us-ascii?Q?vAqYonItpV6sHaWmcV9RbWXAmzRH3NaLKtA8obuxhhxEDxztauAPllS1SQb0?=
 =?us-ascii?Q?2dKIovUv/OEphIgds2F5gW1zij8zhSXrJTAwE0FAfDGktBUruu5HwpAnUfre?=
 =?us-ascii?Q?sdZT59QkNmr7I+O2dkPSyxSXIIwKQ5+2Tfv+fnczJ8LH926a8v5fVulvo3u1?=
 =?us-ascii?Q?pg1LhjAXPj6J3eWycbcNduV0mrDLDZ8Gi/olPuWqymu9oHyngj3cvVPOaQAy?=
 =?us-ascii?Q?uJGWYFak2w4eoQ8wlJ8y3b4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a8f2d8-a2b2-432f-20b3-08d9fd1e5a1c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 14:01:45.3681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8V0h4uGaanbizH0+RDuKEAsvrnn8FAmdEXSzCYBLA8tes6YamCS0kWb8nNvTQh+zZ1bQFZ3ZkLUAn5wkfxcF5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8879
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA ->port_rxtstamp() function is never called for PTP_CLASS_NONE:

dsa_skb_defer_rx_timestamp:

	if (type == PTP_CLASS_NONE)
		return false;

	if (likely(ds->ops->port_rxtstamp))
		return ds->ops->port_rxtstamp(ds, p->dp->index, skb, type);

So practically, the argument is unused, so remove it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 6ddfe6fb43c0..24963335f17e 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1331,7 +1331,7 @@ static int felix_hwtstamp_set(struct dsa_switch *ds, int port,
 	return felix_update_trapping_destinations(ds, using_tag_8021q);
 }
 
-static bool felix_check_xtr_pkt(struct ocelot *ocelot, unsigned int ptp_type)
+static bool felix_check_xtr_pkt(struct ocelot *ocelot)
 {
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int err, grp = 0;
@@ -1342,9 +1342,6 @@ static bool felix_check_xtr_pkt(struct ocelot *ocelot, unsigned int ptp_type)
 	if (!felix->info->quirk_no_xtr_irq)
 		return false;
 
-	if (ptp_type == PTP_CLASS_NONE)
-		return false;
-
 	while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp)) {
 		struct sk_buff *skb;
 		unsigned int type;
@@ -1395,7 +1392,7 @@ static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 	 * MMIO in the CPU port module, and inject that into the stack from
 	 * ocelot_xtr_poll().
 	 */
-	if (felix_check_xtr_pkt(ocelot, type)) {
+	if (felix_check_xtr_pkt(ocelot)) {
 		kfree_skb(skb);
 		return true;
 	}
-- 
2.25.1

