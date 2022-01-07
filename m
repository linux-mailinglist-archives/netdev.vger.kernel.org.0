Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2D848789F
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 14:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347751AbiAGN64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 08:58:56 -0500
Received: from mail-eopbgr80052.outbound.protection.outlook.com ([40.107.8.52]:57533
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347748AbiAGN6z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 08:58:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brodfb7xZktkSFTdjE1WGmR1EXfWrKLXKtl2eJ0pp9KQ/RTQLtpq96UkSEYMQNnoD8+cHB0gvaBWIt25odwJTp2W3Wj7UNk30edAbg9c1SW/6EVnYfZir4GQ7kEIx3YZTjE7GTVlzWE/r4lt2hqJWaZbRcf/n5DZrmr6ymmatQ7nnVtbg5rfsbVv2vM9EQ0dmlAObuUlUn2aQhRArJsBYW8YYzdtz14HYrT2iUggZCey+JxTtxydbNONTkFgokeSr33mlv5AupSSuQlvz4yXzUs2kWbhZpA3Did+ciDiOSRhLfGH/QY7bhzk08Q7aWGzMrX5G5JFX3KXLLC3bO31tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sf5sfJY/m1WlXfFrsOWtw4cHIYVq6+kr4DfGgUTUHB4=;
 b=mTDJrxl3GeicOJQEyHOG0Jib+v/erUw19FZ1Lb+M2MCNP/+anQD+myDkNlHuWJQbDVeHUzUHR+HmrxrenB7FuhAyPpnmY9HYNgi2nUkDnDLgibo9rQNs8FAXb5lB45kdRdgVu1Fmgucl9w1DBeKpLY86bjAN40ix7TQuyYlYDlzlKYA3UjjgeLty2uZZTgmAb8V53mHqNgw0/Mmdh25KROsiYAHyHOCQ0ITHbqHaaI6/Uq5bt1L3l3ql7LjDgsUBMiH1UFTL3qJt2TtmXzbQMjDG0/9vjW+FHR75/PKQktdLpOwFeAyv+3EFJasHDwbglASaeQMDghm1lwMLEmqatQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sf5sfJY/m1WlXfFrsOWtw4cHIYVq6+kr4DfGgUTUHB4=;
 b=c9ormBkwU5UerloDzJA4tLJ/RysOK/LAJKQ3jh6e9vHCEoKg974S2jiasZjOv4s8bb4vBzm3yH7xihvfLhadX1D99aPPkAWxXXb7DPVodtQRv4TYiJOPCIWrDNFsFagLmyLMS6SVs0wy1eJsahL44NxLAqxnf2r9oCQHfqAaVMQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3840.eurprd04.prod.outlook.com (2603:10a6:803:22::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 13:58:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 13:58:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net] net: mscc: ocelot: fix incorrect balancing with down LAG ports
Date:   Fri,  7 Jan 2022 15:58:39 +0200
Message-Id: <20220107135839.237534-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0008.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec33d83c-0c57-4f79-8d10-08d9d1e5d670
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3840:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB384051A62D9AD220544851F7E04D9@VI1PR0402MB3840.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qqTD8pnDfSYqFoJ4uowa4X1pB7AgziQLzoj9RHnfZu2NKujgGKpQHgU/yp4PwjaSzLHHgd1C2JNutbjlUWoORlG0HLpJnT8hcX0E5EZz1+aMrSMfiGTiALYEUpxT1w0H9eDzroaG6MKEXo6CCN3d0B8mJoRGq7SBZz1il5gMp1vqf0bunYFkJ+3X99HsA0jYpZjVWsPSUKf3t5XS22kgOHVrRhtqyvxGxlrye3HWmp+F55zi6z//707FYwL43CJm5n8tQU8u2SEWoCsw60rAqHe34nd7CAtRG/CYqUOPbp9niTdT9C67dJSG/PCjr7p7wnlZwqqrFu5D0Ai6EvAmUtFxQOVkqQovngY6QBG9AxBNStInbohQWJPhW1uuPw9Y7/5fVlC4q2zFHysQA+P1ACPukmuTkDuaVHSem2ENeG2nHB7qNT64t+VQL/p/wH+0SHRDLVQvlyYWERCATGazDGHqY64p4WamZX9+ab7GLRlJXT7XiYsW4C7Se56YfS4/c2OmNsxfKGkn3LxOuOV++lMLuZ11TB1sUaR3vZCMsZHl4ecNfhC+vw1apmXmJLxGWwHM7i7+t9ESetFTOmpVaZr7A4XjEJ+BB0YBthe7AVpRrIMDzF8YOTVZUDEdeBwQmQNHxdGBfJPSHJYN4XHTRgw8a/yIr9WKf2lFR0eGsvtsbyGZYBiUrIL9pI+9xXSHnaxh6B+dzMPTr/FLIuXgaOJ+XMQ0ALUi660chOp/zW9QJxdM3LuyL1UFKKoZKvvW4xZBbGUNxR/OkKBrb1+dc/yYZnLuK0utwe2glfOjEL4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(38100700002)(38350700002)(44832011)(5660300002)(36756003)(966005)(8936002)(2616005)(2906002)(86362001)(54906003)(8676002)(6486002)(6916009)(66946007)(508600001)(26005)(6666004)(83380400001)(186003)(6512007)(4326008)(1076003)(66476007)(66556008)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WAWO6icVw1l/rkkXqUhrZAuHRhTYe3up78w2Endok3HmyAiEDmjb97CkOWOR?=
 =?us-ascii?Q?zLm+6/EgMpLyY++sEHbK/wuZiK9XKq1WxP589NcljRJSV/tiXG/8OjB6cmN7?=
 =?us-ascii?Q?zG8hDkVDxKmXAZ3u6utygoqwH2bonwfFUydLOU1KmCvESjPmwgnI2AxhKq7M?=
 =?us-ascii?Q?kuQMBSvPS0V4nLliw/1Xr3o2LPwL6TU03ydDlpEJZWLYG7SWYdvg1fgu+Egd?=
 =?us-ascii?Q?NwvYasNwutCJzSt9nBGra8zvOecgOnEDLKEdDHao0xLC0gC50aK/SpSri7Hx?=
 =?us-ascii?Q?XSxD3waoZ+2l1GcYBifx0/7BUEH236FomdOZ4HBNLdlJd9bfeaXpfBXgcs8v?=
 =?us-ascii?Q?2drKN6HSQfLPinJ7lnctVMxhUylRbbhxzd6PlOYnJwNHyV/Bysg5ggmlN1aZ?=
 =?us-ascii?Q?45eAfAEaeOYJNM1+nMUdpFlkCAa13T+b+0cJFX8BTbb7UZXLTS1YcZ9QYE/o?=
 =?us-ascii?Q?4Fa2Ek2kzIM88b9zO/XXcctkazB3fmjTQISAtqs2cikdrzY3qNfGw913Inuc?=
 =?us-ascii?Q?/t5njKiMgD3W5cAG3n3ZyLpv5n0Z+5bT/vR7sgZVAFdIuyxOT8cv0ykDChoB?=
 =?us-ascii?Q?Jhjx4rMmd9jaWXEqMs9C0R4VCuiqZ7GPIE+T39Ceveehg8IqvVATXmYzybaY?=
 =?us-ascii?Q?Fv5IiMgIzBzuu7/JtlLmaoF+RkhcotCganETjThROZpPvYYtfzzHIDKXJqkI?=
 =?us-ascii?Q?Bn/fSsHPMW2KBxNjL/BH3BQacOMaOocfz4HXxV41BCzE3bXNmL6olXq+8Qoo?=
 =?us-ascii?Q?2r4HuVFKyopjFyRYn8pK/4bvyud80mKGGaJHIyPjdtZ9bSpngLNvdveoeOrJ?=
 =?us-ascii?Q?JucwOTy7sc2eSoaf5fWtCi+H62zi2NBsRa3yOXzYalSdqJw1Mbact09XQ/qs?=
 =?us-ascii?Q?AVrHtEW3mAd+AoNKoIx/yHGGNUl7iwGK3PrvUiJ42mRqNRkhSQC3WnwErYOt?=
 =?us-ascii?Q?CVZav3celf2swkElP2skBMsbpxFXByN8Fr54zpPh2gevn5wtLNfahPTDTsQH?=
 =?us-ascii?Q?CdsYJEqmy3iE1aAg7CVe8IEJS5dfYXDxom2uOfQDF2E7RIxFRqqoyVwRHiTd?=
 =?us-ascii?Q?nEkYyjJ9ZVDGjmwvs3rfCh7dDQRrJljQTsZs0fX7JcbWVND56BRSHC5P4rTE?=
 =?us-ascii?Q?5HH02JHbIm+GxVjiMVZ6IRfNY7xDge7ACU0hqAIS5JLFuBwD57JqITMtQEko?=
 =?us-ascii?Q?fmh9f4Se+78R3pdhIITn4LevVitxohbcaC6kooMXWeNmu3356iXR9yF1P7X1?=
 =?us-ascii?Q?Y4+a2BWhQa5z2XJgGI13gvAhPO1VZaGP+eZBsHgtFhohpeEbwUhJG2IHSqKi?=
 =?us-ascii?Q?2KhHi4iH3T+S0sED/OVtX2WNC4HaJR4NON6dfVyf1rK7Rif7mLfBvT+J4Kdj?=
 =?us-ascii?Q?uHo6wFz2O3RzZtuYbVFjp2qdaUbnYL7hojdL3Pi1+j71lCr0HqIHSIBfQEzk?=
 =?us-ascii?Q?kXvahJwgPoKS9wQoeKesW3ZE2ppcLvgYyICdY0iwfme8GJHuXHQ32TJJKmBX?=
 =?us-ascii?Q?NfSnCtCWSGkcSd+wB486Bz7BGXxOdmeMeHSdDTdVfSZK9OdaWqh6Neg6yfSU?=
 =?us-ascii?Q?GrQaIENAGFaf0uCAweUp3oPkRFXyGMHuyIta3vefnzg/vB2EV4DPihhamh60?=
 =?us-ascii?Q?63dGCQNRhsv8u80oEsOuuBg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec33d83c-0c57-4f79-8d10-08d9d1e5d670
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 13:58:52.6927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2NQZ+HSBLWdogVzmMB7BIX8So4diwy9ohqhr6+S6SPuYtjBifIeX490MeFbmPgSuAeoNl5dTdhXlD184FR03Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3840
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assuming the test setup described here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210205130240.4072854-1-vladimir.oltean@nxp.com/
(swp1 and swp2 are in bond0, and bond0 is in a bridge with swp0)

it can be seen that when swp1 goes down (on either board A or B), then
traffic that should go through that port isn't forwarded anywhere.

A dump of the PGID table shows the following:

PGID_DST[0] = ports 0
PGID_DST[1] = ports 1
PGID_DST[2] = ports 2
PGID_DST[3] = ports 3
PGID_DST[4] = ports 4
PGID_DST[5] = ports 5
PGID_DST[6] = no ports
PGID_AGGR[0] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[1] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[2] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[3] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[4] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[5] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[6] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[7] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[8] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[9] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[10] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[11] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[12] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[13] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[14] = ports 0, 1, 2, 3, 4, 5
PGID_AGGR[15] = ports 0, 1, 2, 3, 4, 5
PGID_SRC[0] = ports 1, 2
PGID_SRC[1] = ports 0
PGID_SRC[2] = ports 0
PGID_SRC[3] = no ports
PGID_SRC[4] = no ports
PGID_SRC[5] = no ports
PGID_SRC[6] = ports 0, 1, 2, 3, 4, 5

Whereas a "good" PGID configuration for that setup should have looked
like this:

PGID_DST[0] = ports 0
PGID_DST[1] = ports 1, 2
PGID_DST[2] = ports 1, 2
PGID_DST[3] = ports 3
PGID_DST[4] = ports 4
PGID_DST[5] = ports 5
PGID_DST[6] = no ports
PGID_AGGR[0] = ports 0, 2, 3, 4, 5
PGID_AGGR[1] = ports 0, 2, 3, 4, 5
PGID_AGGR[2] = ports 0, 2, 3, 4, 5
PGID_AGGR[3] = ports 0, 2, 3, 4, 5
PGID_AGGR[4] = ports 0, 2, 3, 4, 5
PGID_AGGR[5] = ports 0, 2, 3, 4, 5
PGID_AGGR[6] = ports 0, 2, 3, 4, 5
PGID_AGGR[7] = ports 0, 2, 3, 4, 5
PGID_AGGR[8] = ports 0, 2, 3, 4, 5
PGID_AGGR[9] = ports 0, 2, 3, 4, 5
PGID_AGGR[10] = ports 0, 2, 3, 4, 5
PGID_AGGR[11] = ports 0, 2, 3, 4, 5
PGID_AGGR[12] = ports 0, 2, 3, 4, 5
PGID_AGGR[13] = ports 0, 2, 3, 4, 5
PGID_AGGR[14] = ports 0, 2, 3, 4, 5
PGID_AGGR[15] = ports 0, 2, 3, 4, 5
PGID_SRC[0] = ports 1, 2
PGID_SRC[1] = ports 0
PGID_SRC[2] = ports 0
PGID_SRC[3] = no ports
PGID_SRC[4] = no ports
PGID_SRC[5] = no ports
PGID_SRC[6] = ports 0, 1, 2, 3, 4, 5

In other words, in the "bad" configuration, the attempt is to remove the
inactive swp1 from the destination ports via PGID_DST. But when a MAC
table entry is learned, it is learned towards PGID_DST 1, because that
is the logical port id of the LAG itself (it is equal to the lowest
numbered member port). So when swp1 becomes inactive, if we set
PGID_DST[1] to contain just swp1 and not swp2, the packet will not have
any chance to reach the destination via swp2.

The "correct" way to remove swp1 as a destination is via PGID_AGGR
(remove swp1 from the aggregation port groups for all aggregation
codes). This means that PGID_DST[1] and PGID_DST[2] must still contain
both swp1 and swp2. This makes the MAC table still treat packets
destined towards the single-port LAG as "multicast", and the inactive
ports are removed via the aggregation code tables.

The change presented here is a design one: the ocelot_get_bond_mask()
function used to take an "only_active_ports" argument. We don't need
that. The only call site that specifies only_active_ports=true,
ocelot_set_aggr_pgids(), must retrieve the entire bonding mask, because
it must program that into PGID_DST. Additionally, it must also clear the
inactive ports from the bond mask here, which it can't do if bond_mask
just contains the active ports:

	ac = ocelot_read_rix(ocelot, ANA_PGID_PGID, i);
	ac &= ~bond_mask;  <---- here
	/* Don't do division by zero if there was no active
	 * port. Just make all aggregation codes zero.
	 */
	if (num_active_ports)
		ac |= BIT(aggr_idx[i % num_active_ports]);
	ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);

So it becomes the responsibility of ocelot_set_aggr_pgids() to take
ocelot_port->lag_tx_active into consideration when populating the
aggr_idx array.

Fixes: 23ca3b727ee6 ("net: mscc: ocelot: rebalance LAGs on link up/down events")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9b42187a026a..79e7df837740 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1787,8 +1787,7 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
-static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
-				bool only_active_ports)
+static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 {
 	u32 mask = 0;
 	int port;
@@ -1799,12 +1798,8 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond,
 		if (!ocelot_port)
 			continue;
 
-		if (ocelot_port->bond == bond) {
-			if (only_active_ports && !ocelot_port->lag_tx_active)
-				continue;
-
+		if (ocelot_port->bond == bond)
 			mask |= BIT(port);
-		}
 	}
 
 	return mask;
@@ -1904,10 +1899,8 @@ void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot, bool joining)
 			mask = ocelot_get_bridge_fwd_mask(ocelot, port);
 			mask |= cpu_fwd_mask;
 			mask &= ~BIT(port);
-			if (bond) {
-				mask &= ~ocelot_get_bond_mask(ocelot, bond,
-							      false);
-			}
+			if (bond)
+				mask &= ~ocelot_get_bond_mask(ocelot, bond);
 		} else {
 			/* Standalone ports forward only to DSA tag_8021q CPU
 			 * ports (if those exist), or to the hardware CPU port
@@ -2246,13 +2239,17 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 		if (!bond || (visited & BIT(lag)))
 			continue;
 
-		bond_mask = ocelot_get_bond_mask(ocelot, bond, true);
+		bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
 		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
+			struct ocelot_port *ocelot_port = ocelot->ports[port];
+
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
 					 ANA_PGID_PGID, port);
-			aggr_idx[num_active_ports++] = port;
+
+			if (ocelot_port->lag_tx_active)
+				aggr_idx[num_active_ports++] = port;
 		}
 
 		for_each_aggr_pgid(ocelot, i) {
@@ -2301,8 +2298,7 @@ static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 
 		bond = ocelot_port->bond;
 		if (bond) {
-			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond,
-							     false));
+			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
 
 			ocelot_rmw_gix(ocelot,
 				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
-- 
2.25.1

