Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE9A4C14F5
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241334AbiBWOCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241337AbiBWOBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:01:45 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140050.outbound.protection.outlook.com [40.107.14.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DE8B0EAB
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:01:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gp7bmBj5Iw6lwrlhxVVVbIVQ0O8ntv+xS/qOna8xFdUUQ9soQOcOKYdRf+plbrYjV4w9PiVS+dNCAG2m5P63Kr5zv/91e7C9GJuuroaUn2aWLXC9m5u6Vs4x0KP/nM69n2LGPmFL3NHUS6qX/rK81WmMfLEC1PDqLULlSwCmTvliDlgTZTySpUQgnWuCqZTAJBI7jwqXYqNtICxYqNvLV0onen4PPcweX32hyyJnR+XWaqptLaN7orOuI8Ypkyy1twKOdJ3ZDZ6rYrJ57Dxu30ONdOW0Wlp0JSx5QQ/Ly/A158sfpNkpwx330+GvM6Vh9e7eQl1kdUzoD74hIctgSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqhAluN4osHaENOLgwAyaagFDicag40uNBAhI7pQ7ao=;
 b=SlCPB+hmmtXBI2GehUrOkSDikvSrKBlhjhc/VjWrrCMv+sxV47v3yNtNm3OKQ0zoWFo+g/2cMIxbSEy2EzKkmtIM/m11728Zj2LF/lX7I33eeHPh1kMq6TU5KFJoaixZpC2N1ETS9x4awVnEkRl6pd2xkPn5b0TMIEJsi/lBuRBgJKT6tXJVtI22aYNrmp/paONS7NCHtQm8ivPzv5USz2DMWM4VDrRTA5cWOl1BLOQEnmk4VxTeIaw+yXoV5ud8K1QzmslvEhkp6TsGoKYqxCM8yxgwv4Sh9mUP46rmPPNR01ZYc6B+g1tqT+ClGVx48t6tsFgwjQLE4OAx3NOvCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqhAluN4osHaENOLgwAyaagFDicag40uNBAhI7pQ7ao=;
 b=Ra8/kNQv96ogmGyrR7GfwX0s6bqlKogi08gSUKkCOYiI+JT3E01DO2tuYW5IO5rXAbGWAMpm+z2JrC/GcvjtoJrqSacbanUfIxfsoDMxr1aApkLMKo4idsbk075cAMxyvslsYHT8GFBDZ8n/qc1zxrrqP07FISFuezbnTT/x4dA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8701.eurprd04.prod.outlook.com (2603:10a6:102:21c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 14:01:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 14:01:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v5 net-next 06/11] net: dsa: create a dsa_lag structure
Date:   Wed, 23 Feb 2022 16:00:49 +0200
Message-Id: <20220223140054.3379617-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
References: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:207:1::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba986d1f-0857-4fae-92e1-08d9f6d4f37f
X-MS-TrafficTypeDiagnostic: PAXPR04MB8701:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB870196B942DCAAA5A0AF610DE03C9@PAXPR04MB8701.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +TfYzxbapk3qNzWwby/ecoSbJMbqgXtj5u8ynn2nDH5cUj7F5G9+VSL9Jvg4UaQO3nhad3dDS/k6jinQyTK2RjBWEh/D16ux54xn5VGtACp5TbKuRuCA6i/Or09ONDsWxiNFxoZiSKqHHqfYeZiwGXSKvlXDb93FxxwrYhJBooGFBK5FZdnhzANRqR3+w3O+82OOqK5vmSCpRl3Zc/dmWjbimhkJynMqWRQITx0O06hRdapadlP7SUcV1xeD83Wi3cI2HKQUNe9771y2cwiHKRkZrZPk09pkVjxrsGVUGn2Hny3F9RMNG//4yo/KxA8Z2H+l6w0nSN4n4KpBnpWJGLvqn5mp93rclJ7Jrx82YMXLT/nTb15AZDdZEDDQCCGA3pu/DGcxfYe3SgKvKtDz0Lb1aAimHbnDROYtTwLeAKzQfXa3iQFePOEFFjrNa4Hy0/APb30wElZjSikbrp92wcOmgOiCwCAKuctT10tR15PMlInnOOQeiKuFNukXS2FBpbTWOrU7mj5WNjbWr5dPE1HPFDFIq69QBaBPr4ukA99HpqCETz+UuLP1QUQ/peCWhuhyPH5xYtSsnO3A9S+Bu053CL4TEZOGduf0YXL0KTm4tSqw0j/KZWTabZ1QvSgbAzyOtcItl6wxtOtWYYD6aKVvMyxg87ZTeF7QHa/FiR/W0gk+3BZkjqd5YFFp42nLvUUMXsgAatYlWJnkkIIL/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66574015)(36756003)(83380400001)(38100700002)(38350700002)(6506007)(508600001)(52116002)(6512007)(6666004)(66946007)(6486002)(2616005)(4326008)(7416002)(44832011)(54906003)(66476007)(1076003)(6916009)(2906002)(316002)(66556008)(8676002)(30864003)(26005)(5660300002)(86362001)(186003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFNma2ppaE9hbFdtaFYzVmNXTDJIWWpVUnVoeCtUSS94cWY1OHFkNGZVUi9v?=
 =?utf-8?B?dSt6RzQybjhUZEVxcU92WGYya0FEU3dnN0w2NVdsdmdWclVmRUdHUlg2b0Ex?=
 =?utf-8?B?cXgrR2x5K0Z5RklRc3FDcFVjYitRdkxubFBlMWNtZEFhSTF2Rmt2UWZPeHFW?=
 =?utf-8?B?SkVGWE1SZjBFV3cvZ3J1MDVhNFhIeit1WDRKb1RyZ21iM2ZOQzNvYXo1VHJh?=
 =?utf-8?B?Q2dkSkNrSVh5cG1senBLcVFCVW1LVWthbzZ5ZnFBczFGbzhEc2h6ZjR6NnJo?=
 =?utf-8?B?Y2hPOE4wMXFWaXR1MGRGY05USGdLZE50djhQOGFPTVVhOVVkR1J0RXh4WXYx?=
 =?utf-8?B?OGUzVi9GdFF3QnJYeHJMb0VtUDYxaDBUOU5PWjRZMEF6Y2hQa0RtZTJtc1Br?=
 =?utf-8?B?Vk44UXNWSjNmOGRKNEhETUVYeUNCSFEzQitGdGd1bnMvN1F5QjI2WUJuK1NQ?=
 =?utf-8?B?LzFUVEJOZGFoaC9WanVySGZ2bWRYejlUYmlKSEd3YzZNRnQzMFJ2SUNXU3ZP?=
 =?utf-8?B?Rm15NFRmYllZYXNVR1NkZ1VMSUNhb042S1hHdDRIbW1rZ2ppZDdWdnFxU3NC?=
 =?utf-8?B?VTFwcHIyZTM4V2NURDl4Q1FqOEhrbyt0am43cUN0aVNPQ1dWUzBsRkgwSjdu?=
 =?utf-8?B?cnBZV0NMbi8zdzI3Nld1ZnFSZUFaV0JQMWVzQkZqSnFVSEozU1k1VGttMFhH?=
 =?utf-8?B?cEIvS2E5SHV6TlRLaGI2b1JCVG8vRmRjMzdHNVQwK3Q1aXZqQkVIVGtMb2Nm?=
 =?utf-8?B?aFpJUzBiaWlHQk9LSzR0VWhObCtkajM2Y3JYWU9JK1hZMjBlR25ZOXlMM0tL?=
 =?utf-8?B?OHJVRzcrWmNhWWxuWWx2QU02ZzFVVUtHdzc2Qm1JbHZNSEQwbUpISFFtekpu?=
 =?utf-8?B?Q2o0M3VrVmFGMXhIcHA0eVZiOUl0OWhrYkpRcnAzZ0FhMHBjbzJ2YW1FVEsw?=
 =?utf-8?B?WnROV1EyK25KOE9mcGQ1RUIyTnFpQ0JtZmZ5T2doZzBtcGhNLzZXUytjemw1?=
 =?utf-8?B?ODB3VzhuMlBnRG1Ub01EK0dJL2JobytEY050VjV0blZpMHhHYUo3UDM0VExs?=
 =?utf-8?B?SWNBQnk3TDIyTExCS3RFa3JqQnc1Y0YzSWpnc0w5bUJLSzkrU1M3VVA0ZitN?=
 =?utf-8?B?VmNBZXlOdm9nUUxpUkJYdGUrc2RYMjBENndDaTYwbEJyY2Y3Yk9RMTNpQjlp?=
 =?utf-8?B?a29MVTVIY1lrWTlyQm4yRTZaN1loMkNUNUhDd3ZhREtHZ25Sc05kZ0JQQ0JX?=
 =?utf-8?B?b29Fdi9LVlphNG9WUkRQdmM0eDg2TmU2ZXVUbW53clpDUU1JK0oybXREZTY2?=
 =?utf-8?B?bGVZdWVMci9DcE9NZ2tOdzcxV3QwTFVpUVZWM3JGQW9CQ09MZ2JBcnY5WVlX?=
 =?utf-8?B?MGFlWTNvbnhxcnJLWmJoVHhZRXRVVzhOdStKb1A0a2N1YmJwUjE2NXA0U2Vr?=
 =?utf-8?B?anNTck14Y0RRdmtobSs5ZnBUNnlCT2UzbVFqS2FJbFlXL1VwYWpyWWJxeUNp?=
 =?utf-8?B?TEhDbjdTNWxuVElnYWxheGhZL0FJZjBvRXlPbTd0T2p1SDQ3aXdBWUxpdVhY?=
 =?utf-8?B?clFuYzNaRnBnTFlrb0h3dWRENEl2Sk81TkVZVVN6Nk44YlZodXNJZm1tbG5a?=
 =?utf-8?B?eDJJdjM2Qis5dXNLZVVmeEpJRmRRM0hBNHp3R2JTaGZQbHRwUGIyMlJNTjN2?=
 =?utf-8?B?dHVSU0M2dmN4K09BMlJWdjNzVSs3RTg1cUszQ3RiMjVYNmYrZ1hCbkwvVTF6?=
 =?utf-8?B?R2JqcUdDS0pMazJyQUd3RDNVYXZBK3BMU0k1aXY2SC9EL1Jndk5PaVlHTlJI?=
 =?utf-8?B?MUxaTENObm8rTjM3TnppMnQyRXhKc3dTMk9HdFBWU2ZRSkZXemdTUXI3T2hY?=
 =?utf-8?B?MmMvL0JEcmRBYjRXUlpOTkpPcmpqWk9Cb1l4bzgzQ3cydk5kc0svTHBOZ3Jm?=
 =?utf-8?B?V1ZKbjJqanNka0FsMFY0WHI0Ymo5ckRWYVdOMGp6a1FWTXBQWnBTQkVmSmtF?=
 =?utf-8?B?dDdZVDR2WTB1OGpuVlE5RVRMRXQ2b0lzb1AzbUdtZ2M1NkNYS0wxR3ZBQ3Fz?=
 =?utf-8?B?RkZ0Zi90WjAyUE1IM3Q4YWxUNmJYUzhUNUdtYkRZb2lUNG1nckhvOVFKN2Nq?=
 =?utf-8?B?NUcxTVh2SjVYZFNlMXNteVlHeE8vT01JRXdBT1hIeFpVME1yRktKcENtM3dH?=
 =?utf-8?Q?xjARu6dhyz35F2gsfrbTENY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba986d1f-0857-4fae-92e1-08d9f6d4f37f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:01:13.1328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /SzT9/IN9XhHVpel1IpVvcVBHS1AIOuCd6BK6dEeTRhJjMo/aPfrIYyrSIUKGjMQMZMvHG++JSz5/3/cCDGX5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8701
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose of this change is to create a data structure for a LAG
as seen by DSA. This is similar to what we have for bridging - we pass a
copy of this structure by value to ->port_lag_join and ->port_lag_leave.
For now we keep the lag_dev, id and a reference count in it. Future
patches will add a list of FDB entries for the LAG (these also need to
be refcounted to work properly).

The LAG structure is created using dsa_port_lag_create() and destroyed
using dsa_port_lag_destroy(), just like we have for bridging.

Because now, the dsa_lag itself is refcounted, we can simplify
dsa_lag_map() and dsa_lag_unmap(). These functions need to keep a LAG in
the dst->lags array only as long as at least one port uses it. The
refcounting logic inside those functions can be removed now - they are
called only when we should perform the operation.

dsa_lag_dev() is renamed to dsa_lag_by_id() and now returns the dsa_lag
structure instead of the lag_dev net_device.

dsa_lag_foreach_port() now takes the dsa_lag structure as argument.

dst->lags holds an array of dsa_lag structures.

dsa_lag_map() now also saves the dsa_lag->id value, so that linear
walking of dst->lags in drivers using dsa_lag_id() is no longer
necessary. They can just look at lag.id.

dsa_port_lag_id_get() is a helper, similar to dsa_port_bridge_num_get(),
which can be used by drivers to get the LAG ID assigned by DSA to a
given port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v4->v5: none
v3->v4: avoid NULL pointer dereference in dsa_port_lag_leave() when the
        LAG is not offloaded (thanks to Alvin Šipraga)
v1->v3: none

 drivers/net/dsa/mv88e6xxx/chip.c | 60 +++++++++++++++----------------
 drivers/net/dsa/ocelot/felix.c   |  8 ++---
 drivers/net/dsa/qca8k.c          | 37 +++++++++----------
 include/net/dsa.h                | 50 +++++++++++++++++++-------
 net/dsa/dsa2.c                   | 41 +++++++++++----------
 net/dsa/dsa_priv.h               |  8 +++--
 net/dsa/port.c                   | 62 +++++++++++++++++++++++++-------
 net/dsa/slave.c                  |  4 +--
 net/dsa/switch.c                 |  8 ++---
 net/dsa/tag_dsa.c                |  4 ++-
 10 files changed, 173 insertions(+), 109 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8868110fcc9c..1b9a20bf1bd6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1625,7 +1625,7 @@ static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
 
 		ds = dsa_switch_find(dst->index, dev);
 		dp = ds ? dsa_to_port(ds, port) : NULL;
-		if (dp && dp->lag_dev) {
+		if (dp && dp->lag) {
 			/* As the PVT is used to limit flooding of
 			 * FORWARD frames, which use the LAG ID as the
 			 * source port, we must translate dev/port to
@@ -1634,7 +1634,7 @@ static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
 			 * (zero-based).
 			 */
 			dev = MV88E6XXX_G2_PVT_ADDR_DEV_TRUNK;
-			port = dsa_lag_id(dst, dp->lag_dev) - 1;
+			port = dsa_port_lag_id_get(dp) - 1;
 		}
 	}
 
@@ -1672,7 +1672,7 @@ static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (dsa_to_port(ds, port)->lag_dev)
+	if (dsa_to_port(ds, port)->lag)
 		/* Hardware is incapable of fast-aging a LAG through a
 		 * regular ATU move operation. Until we have something
 		 * more fancy in place this is a no-op.
@@ -6176,21 +6176,20 @@ static int mv88e6xxx_port_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
-				      struct net_device *lag_dev,
+				      struct dsa_lag lag,
 				      struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct dsa_port *dp;
-	int id, members = 0;
+	int members = 0;
 
 	if (!mv88e6xxx_has_lag(chip))
 		return false;
 
-	id = dsa_lag_id(ds->dst, lag_dev);
-	if (id <= 0 || id > ds->num_lag_ids)
+	if (!lag.id)
 		return false;
 
-	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
+	dsa_lag_foreach_port(dp, ds->dst, &lag)
 		/* Includes the port joining the LAG */
 		members++;
 
@@ -6210,8 +6209,7 @@ static bool mv88e6xxx_lag_can_offload(struct dsa_switch *ds,
 	return true;
 }
 
-static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
-				  struct net_device *lag_dev)
+static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds, struct dsa_lag lag)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct dsa_port *dp;
@@ -6219,13 +6217,13 @@ static int mv88e6xxx_lag_sync_map(struct dsa_switch *ds,
 	int id;
 
 	/* DSA LAG IDs are one-based, hardware is zero-based */
-	id = dsa_lag_id(ds->dst, lag_dev) - 1;
+	id = lag.id - 1;
 
 	/* Build the map of all ports to distribute flows destined for
 	 * this LAG. This can be either a local user port, or a DSA
 	 * port if the LAG port is on a remote chip.
 	 */
-	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
+	dsa_lag_foreach_port(dp, ds->dst, &lag)
 		map |= BIT(dsa_towards_port(ds, dp->ds->index, dp->index));
 
 	return mv88e6xxx_g2_trunk_mapping_write(chip, id, map);
@@ -6269,9 +6267,9 @@ static void mv88e6xxx_lag_set_port_mask(u16 *mask, int port,
 static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	struct net_device *lag_dev;
 	unsigned int id, num_tx;
 	struct dsa_port *dp;
+	struct dsa_lag *lag;
 	int i, err, nth;
 	u16 mask[8];
 	u16 ivec;
@@ -6281,7 +6279,7 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 
 	/* Disable all masks for ports that _are_ members of a LAG. */
 	dsa_switch_for_each_port(dp, ds) {
-		if (!dp->lag_dev)
+		if (!dp->lag)
 			continue;
 
 		ivec &= ~BIT(dp->index);
@@ -6294,12 +6292,12 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 	 * are in the Tx set.
 	 */
 	dsa_lags_foreach_id(id, ds->dst) {
-		lag_dev = dsa_lag_dev(ds->dst, id);
-		if (!lag_dev)
+		lag = dsa_lag_by_id(ds->dst, id);
+		if (!lag)
 			continue;
 
 		num_tx = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
+		dsa_lag_foreach_port(dp, ds->dst, lag) {
 			if (dp->lag_tx_enabled)
 				num_tx++;
 		}
@@ -6308,7 +6306,7 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 			continue;
 
 		nth = 0;
-		dsa_lag_foreach_port(dp, ds->dst, lag_dev) {
+		dsa_lag_foreach_port(dp, ds->dst, lag) {
 			if (!dp->lag_tx_enabled)
 				continue;
 
@@ -6330,14 +6328,14 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 }
 
 static int mv88e6xxx_lag_sync_masks_map(struct dsa_switch *ds,
-					struct net_device *lag_dev)
+					struct dsa_lag lag)
 {
 	int err;
 
 	err = mv88e6xxx_lag_sync_masks(ds);
 
 	if (!err)
-		err = mv88e6xxx_lag_sync_map(ds, lag_dev);
+		err = mv88e6xxx_lag_sync_map(ds, lag);
 
 	return err;
 }
@@ -6354,17 +6352,17 @@ static int mv88e6xxx_port_lag_change(struct dsa_switch *ds, int port)
 }
 
 static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
-				   struct net_device *lag_dev,
+				   struct dsa_lag lag,
 				   struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err, id;
 
-	if (!mv88e6xxx_lag_can_offload(ds, lag_dev, info))
+	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
 		return -EOPNOTSUPP;
 
 	/* DSA LAG IDs are one-based */
-	id = dsa_lag_id(ds->dst, lag_dev) - 1;
+	id = lag.id - 1;
 
 	mv88e6xxx_reg_lock(chip);
 
@@ -6372,7 +6370,7 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 	if (err)
 		goto err_unlock;
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
 	if (err)
 		goto err_clear_trunk;
 
@@ -6387,13 +6385,13 @@ static int mv88e6xxx_port_lag_join(struct dsa_switch *ds, int port,
 }
 
 static int mv88e6xxx_port_lag_leave(struct dsa_switch *ds, int port,
-				    struct net_device *lag_dev)
+				    struct dsa_lag lag)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err_sync, err_trunk;
 
 	mv88e6xxx_reg_lock(chip);
-	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
+	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag);
 	err_trunk = mv88e6xxx_port_set_trunk(chip, port, false, 0);
 	mv88e6xxx_reg_unlock(chip);
 	return err_sync ? : err_trunk;
@@ -6412,18 +6410,18 @@ static int mv88e6xxx_crosschip_lag_change(struct dsa_switch *ds, int sw_index,
 }
 
 static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
-					int port, struct net_device *lag_dev,
+					int port, struct dsa_lag lag,
 					struct netdev_lag_upper_info *info)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (!mv88e6xxx_lag_can_offload(ds, lag_dev, info))
+	if (!mv88e6xxx_lag_can_offload(ds, lag, info))
 		return -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
 
-	err = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
+	err = mv88e6xxx_lag_sync_masks_map(ds, lag);
 	if (err)
 		goto unlock;
 
@@ -6435,13 +6433,13 @@ static int mv88e6xxx_crosschip_lag_join(struct dsa_switch *ds, int sw_index,
 }
 
 static int mv88e6xxx_crosschip_lag_leave(struct dsa_switch *ds, int sw_index,
-					 int port, struct net_device *lag_dev)
+					 int port, struct dsa_lag lag)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err_sync, err_pvt;
 
 	mv88e6xxx_reg_lock(chip);
-	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag_dev);
+	err_sync = mv88e6xxx_lag_sync_masks_map(ds, lag);
 	err_pvt = mv88e6xxx_pvt_map(chip, sw_index, port);
 	mv88e6xxx_reg_unlock(chip);
 	return err_sync ? : err_pvt;
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9ffd5491bf2d..6d483887af04 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -677,20 +677,20 @@ static void felix_bridge_leave(struct dsa_switch *ds, int port,
 }
 
 static int felix_lag_join(struct dsa_switch *ds, int port,
-			  struct net_device *bond,
+			  struct dsa_lag lag,
 			  struct netdev_lag_upper_info *info)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_port_lag_join(ocelot, port, bond, info);
+	return ocelot_port_lag_join(ocelot, port, lag.dev, info);
 }
 
 static int felix_lag_leave(struct dsa_switch *ds, int port,
-			   struct net_device *bond)
+			   struct dsa_lag lag)
 {
 	struct ocelot *ocelot = ds->priv;
 
-	ocelot_port_lag_leave(ocelot, port, bond);
+	ocelot_port_lag_leave(ocelot, port, lag.dev);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ed55e9357c2b..6844106975a9 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -2646,18 +2646,16 @@ qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 }
 
 static bool
-qca8k_lag_can_offload(struct dsa_switch *ds,
-		      struct net_device *lag_dev,
+qca8k_lag_can_offload(struct dsa_switch *ds, struct dsa_lag lag,
 		      struct netdev_lag_upper_info *info)
 {
 	struct dsa_port *dp;
-	int id, members = 0;
+	int members = 0;
 
-	id = dsa_lag_id(ds->dst, lag_dev);
-	if (id <= 0 || id > ds->num_lag_ids)
+	if (!lag.id)
 		return false;
 
-	dsa_lag_foreach_port(dp, ds->dst, lag_dev)
+	dsa_lag_foreach_port(dp, ds->dst, &lag)
 		/* Includes the port joining the LAG */
 		members++;
 
@@ -2675,16 +2673,14 @@ qca8k_lag_can_offload(struct dsa_switch *ds,
 }
 
 static int
-qca8k_lag_setup_hash(struct dsa_switch *ds,
-		     struct net_device *lag_dev,
+qca8k_lag_setup_hash(struct dsa_switch *ds, struct dsa_lag lag,
 		     struct netdev_lag_upper_info *info)
 {
+	struct net_device *lag_dev = lag.dev;
 	struct qca8k_priv *priv = ds->priv;
 	bool unique_lag = true;
+	unsigned int i;
 	u32 hash = 0;
-	int i, id;
-
-	id = dsa_lag_id(ds->dst, lag_dev);
 
 	switch (info->hash_type) {
 	case NETDEV_LAG_HASH_L23:
@@ -2701,7 +2697,7 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 
 	/* Check if we are the unique configured LAG */
 	dsa_lags_foreach_id(i, ds->dst)
-		if (i != id && dsa_lag_dev(ds->dst, i)) {
+		if (i != lag.id && dsa_lag_by_id(ds->dst, i)) {
 			unique_lag = false;
 			break;
 		}
@@ -2726,14 +2722,14 @@ qca8k_lag_setup_hash(struct dsa_switch *ds,
 
 static int
 qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
-			  struct net_device *lag_dev, bool delete)
+			  struct dsa_lag lag, bool delete)
 {
 	struct qca8k_priv *priv = ds->priv;
 	int ret, id, i;
 	u32 val;
 
 	/* DSA LAG IDs are one-based, hardware is zero-based */
-	id = dsa_lag_id(ds->dst, lag_dev) - 1;
+	id = lag.id - 1;
 
 	/* Read current port member */
 	ret = regmap_read(priv->regmap, QCA8K_REG_GOL_TRUNK_CTRL0, &val);
@@ -2795,27 +2791,26 @@ qca8k_lag_refresh_portmap(struct dsa_switch *ds, int port,
 }
 
 static int
-qca8k_port_lag_join(struct dsa_switch *ds, int port,
-		    struct net_device *lag_dev,
+qca8k_port_lag_join(struct dsa_switch *ds, int port, struct dsa_lag lag,
 		    struct netdev_lag_upper_info *info)
 {
 	int ret;
 
-	if (!qca8k_lag_can_offload(ds, lag_dev, info))
+	if (!qca8k_lag_can_offload(ds, lag, info))
 		return -EOPNOTSUPP;
 
-	ret = qca8k_lag_setup_hash(ds, lag_dev, info);
+	ret = qca8k_lag_setup_hash(ds, lag, info);
 	if (ret)
 		return ret;
 
-	return qca8k_lag_refresh_portmap(ds, port, lag_dev, false);
+	return qca8k_lag_refresh_portmap(ds, port, lag, false);
 }
 
 static int
 qca8k_port_lag_leave(struct dsa_switch *ds, int port,
-		     struct net_device *lag_dev)
+		     struct dsa_lag lag)
 {
-	return qca8k_lag_refresh_portmap(ds, port, lag_dev, true);
+	return qca8k_lag_refresh_portmap(ds, port, lag, true);
 }
 
 static void
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 3ae93adda25d..81ed34998416 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -116,6 +116,12 @@ struct dsa_netdevice_ops {
 #define MODULE_ALIAS_DSA_TAG_DRIVER(__proto)				\
 	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS __stringify(__proto##_VALUE))
 
+struct dsa_lag {
+	struct net_device *dev;
+	unsigned int id;
+	refcount_t refcount;
+};
+
 struct dsa_switch_tree {
 	struct list_head	list;
 
@@ -134,7 +140,7 @@ struct dsa_switch_tree {
 	/* Maps offloaded LAG netdevs to a zero-based linear ID for
 	 * drivers that need it.
 	 */
-	struct net_device **lags;
+	struct dsa_lag **lags;
 
 	/* Tagging protocol operations */
 	const struct dsa_device_ops *tag_ops;
@@ -170,14 +176,14 @@ struct dsa_switch_tree {
 
 #define dsa_lag_foreach_port(_dp, _dst, _lag)			\
 	list_for_each_entry((_dp), &(_dst)->ports, list)	\
-		if ((_dp)->lag_dev == (_lag))
+		if (dsa_port_offloads_lag((_dp), (_lag)))
 
 #define dsa_hsr_foreach_port(_dp, _ds, _hsr)			\
 	list_for_each_entry((_dp), &(_ds)->dst->ports, list)	\
 		if ((_dp)->ds == (_ds) && (_dp)->hsr_dev == (_hsr))
 
-static inline struct net_device *dsa_lag_dev(struct dsa_switch_tree *dst,
-					     unsigned int id)
+static inline struct dsa_lag *dsa_lag_by_id(struct dsa_switch_tree *dst,
+					    unsigned int id)
 {
 	/* DSA LAG IDs are one-based, dst->lags is zero-based */
 	return dst->lags[id - 1];
@@ -189,8 +195,10 @@ static inline int dsa_lag_id(struct dsa_switch_tree *dst,
 	unsigned int id;
 
 	dsa_lags_foreach_id(id, dst) {
-		if (dsa_lag_dev(dst, id) == lag_dev)
-			return id;
+		struct dsa_lag *lag = dsa_lag_by_id(dst, id);
+
+		if (lag->dev == lag_dev)
+			return lag->id;
 	}
 
 	return -ENODEV;
@@ -293,7 +301,7 @@ struct dsa_port {
 	struct devlink_port	devlink_port;
 	struct phylink		*pl;
 	struct phylink_config	pl_config;
-	struct net_device	*lag_dev;
+	struct dsa_lag		*lag;
 	struct net_device	*hsr_dev;
 
 	struct list_head list;
@@ -643,14 +651,30 @@ static inline bool dsa_port_is_vlan_filtering(const struct dsa_port *dp)
 		return dp->vlan_filtering;
 }
 
+static inline unsigned int dsa_port_lag_id_get(struct dsa_port *dp)
+{
+	return dp->lag ? dp->lag->id : 0;
+}
+
+static inline struct net_device *dsa_port_lag_dev_get(struct dsa_port *dp)
+{
+	return dp->lag ? dp->lag->dev : NULL;
+}
+
+static inline bool dsa_port_offloads_lag(struct dsa_port *dp,
+					 const struct dsa_lag *lag)
+{
+	return dsa_port_lag_dev_get(dp) == lag->dev;
+}
+
 static inline
 struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
 {
 	if (!dp->bridge)
 		return NULL;
 
-	if (dp->lag_dev)
-		return dp->lag_dev;
+	if (dp->lag)
+		return dp->lag->dev;
 	else if (dp->hsr_dev)
 		return dp->hsr_dev;
 
@@ -968,10 +992,10 @@ struct dsa_switch_ops {
 	int	(*crosschip_lag_change)(struct dsa_switch *ds, int sw_index,
 					int port);
 	int	(*crosschip_lag_join)(struct dsa_switch *ds, int sw_index,
-				      int port, struct net_device *lag_dev,
+				      int port, struct dsa_lag lag,
 				      struct netdev_lag_upper_info *info);
 	int	(*crosschip_lag_leave)(struct dsa_switch *ds, int sw_index,
-				       int port, struct net_device *lag_dev);
+				       int port, struct dsa_lag lag);
 
 	/*
 	 * PTP functionality
@@ -1043,10 +1067,10 @@ struct dsa_switch_ops {
 	 */
 	int	(*port_lag_change)(struct dsa_switch *ds, int port);
 	int	(*port_lag_join)(struct dsa_switch *ds, int port,
-				 struct net_device *lag_dev,
+				 struct dsa_lag lag,
 				 struct netdev_lag_upper_info *info);
 	int	(*port_lag_leave)(struct dsa_switch *ds, int port,
-				  struct net_device *lag_dev);
+				  struct dsa_lag lag);
 
 	/*
 	 * HSR integration
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 4915abe0d4d2..030d5f26715a 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -72,27 +72,24 @@ int dsa_broadcast(unsigned long e, void *v)
 }
 
 /**
- * dsa_lag_map() - Map LAG netdev to a linear LAG ID
+ * dsa_lag_map() - Map LAG structure to a linear LAG array
  * @dst: Tree in which to record the mapping.
- * @lag_dev: Netdev that is to be mapped to an ID.
+ * @lag: LAG structure that is to be mapped to the tree's array.
  *
- * dsa_lag_id/dsa_lag_dev can then be used to translate between the
+ * dsa_lag_id/dsa_lag_by_id can then be used to translate between the
  * two spaces. The size of the mapping space is determined by the
  * driver by setting ds->num_lag_ids. It is perfectly legal to leave
  * it unset if it is not needed, in which case these functions become
  * no-ops.
  */
-void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev)
+void dsa_lag_map(struct dsa_switch_tree *dst, struct dsa_lag *lag)
 {
 	unsigned int id;
 
-	if (dsa_lag_id(dst, lag_dev) > 0)
-		/* Already mapped */
-		return;
-
 	for (id = 1; id <= dst->lags_len; id++) {
-		if (!dsa_lag_dev(dst, id)) {
-			dst->lags[id - 1] = lag_dev;
+		if (!dsa_lag_by_id(dst, id)) {
+			dst->lags[id - 1] = lag;
+			lag->id = id;
 			return;
 		}
 	}
@@ -108,28 +105,36 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev)
 /**
  * dsa_lag_unmap() - Remove a LAG ID mapping
  * @dst: Tree in which the mapping is recorded.
- * @lag_dev: Netdev that was mapped.
+ * @lag: LAG structure that was mapped.
  *
  * As there may be multiple users of the mapping, it is only removed
  * if there are no other references to it.
  */
-void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev)
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct dsa_lag *lag)
 {
-	struct dsa_port *dp;
 	unsigned int id;
 
-	dsa_lag_foreach_port(dp, dst, lag_dev)
-		/* There are remaining users of this mapping */
-		return;
-
 	dsa_lags_foreach_id(id, dst) {
-		if (dsa_lag_dev(dst, id) == lag_dev) {
+		if (dsa_lag_by_id(dst, id) == lag) {
 			dst->lags[id - 1] = NULL;
+			lag->id = 0;
 			break;
 		}
 	}
 }
 
+struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
+				  const struct net_device *lag_dev)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_lag_dev_get(dp) == lag_dev)
+			return dp->lag;
+
+	return NULL;
+}
+
 struct dsa_bridge *dsa_tree_bridge_find(struct dsa_switch_tree *dst,
 					const struct net_device *br)
 {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 0293a749b3ac..8612ff8ea7fe 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -76,7 +76,7 @@ struct dsa_notifier_mdb_info {
 
 /* DSA_NOTIFIER_LAG_* */
 struct dsa_notifier_lag_info {
-	struct net_device *lag_dev;
+	struct dsa_lag lag;
 	int sw_index;
 	int port;
 
@@ -487,8 +487,10 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 
 /* dsa2.c */
-void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev);
-void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev);
+void dsa_lag_map(struct dsa_switch_tree *dst, struct dsa_lag *lag);
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct dsa_lag *lag);
+struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
+				  const struct net_device *lag_dev);
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index fafe019dd02e..774ac3f9c9d8 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -422,7 +422,7 @@ int dsa_port_lag_change(struct dsa_port *dp,
 	};
 	bool tx_enabled;
 
-	if (!dp->lag_dev)
+	if (!dp->lag)
 		return 0;
 
 	/* On statically configured aggregates (e.g. loadbalance
@@ -440,6 +440,45 @@ int dsa_port_lag_change(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_CHANGE, &info);
 }
 
+static int dsa_port_lag_create(struct dsa_port *dp,
+			       struct net_device *lag_dev)
+{
+	struct dsa_switch *ds = dp->ds;
+	struct dsa_lag *lag;
+
+	lag = dsa_tree_lag_find(ds->dst, lag_dev);
+	if (lag) {
+		refcount_inc(&lag->refcount);
+		dp->lag = lag;
+		return 0;
+	}
+
+	lag = kzalloc(sizeof(*lag), GFP_KERNEL);
+	if (!lag)
+		return -ENOMEM;
+
+	refcount_set(&lag->refcount, 1);
+	lag->dev = lag_dev;
+	dsa_lag_map(ds->dst, lag);
+	dp->lag = lag;
+
+	return 0;
+}
+
+static void dsa_port_lag_destroy(struct dsa_port *dp)
+{
+	struct dsa_lag *lag = dp->lag;
+
+	dp->lag = NULL;
+	dp->lag_tx_enabled = false;
+
+	if (!refcount_dec_and_test(&lag->refcount))
+		return;
+
+	dsa_lag_unmap(dp->ds->dst, lag);
+	kfree(lag);
+}
+
 int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *uinfo,
 		      struct netlink_ext_ack *extack)
@@ -447,15 +486,16 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.lag_dev = lag_dev,
 		.info = uinfo,
 	};
 	struct net_device *bridge_dev;
 	int err;
 
-	dsa_lag_map(dp->ds->dst, lag_dev);
-	dp->lag_dev = lag_dev;
+	err = dsa_port_lag_create(dp, lag_dev);
+	if (err)
+		goto err_lag_create;
 
+	info.lag = *dp->lag;
 	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_JOIN, &info);
 	if (err)
 		goto err_lag_join;
@@ -473,8 +513,8 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 err_bridge_join:
 	dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 err_lag_join:
-	dp->lag_dev = NULL;
-	dsa_lag_unmap(dp->ds->dst, lag_dev);
+	dsa_port_lag_destroy(dp);
+err_lag_create:
 	return err;
 }
 
@@ -492,11 +532,10 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.lag_dev = lag_dev,
 	};
 	int err;
 
-	if (!dp->lag_dev)
+	if (!dp->lag)
 		return;
 
 	/* Port might have been part of a LAG that in turn was
@@ -505,16 +544,15 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 	if (br)
 		dsa_port_bridge_leave(dp, br);
 
-	dp->lag_tx_enabled = false;
-	dp->lag_dev = NULL;
+	info.lag = *dp->lag;
+
+	dsa_port_lag_destroy(dp);
 
 	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 	if (err)
 		dev_err(dp->ds->dev,
 			"port %d failed to notify DSA_NOTIFIER_LAG_LEAVE: %pe\n",
 			dp->index, ERR_PTR(err));
-
-	dsa_lag_unmap(dp->ds->dst, lag_dev);
 }
 
 /* Must be called under rcu_read_lock() */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f61e6b72ffbb..e31c7710fee9 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2134,7 +2134,7 @@ dsa_slave_lag_changeupper(struct net_device *dev,
 			continue;
 
 		dp = dsa_slave_to_port(lower);
-		if (!dp->lag_dev)
+		if (!dp->lag)
 			/* Software LAG */
 			continue;
 
@@ -2163,7 +2163,7 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
 			continue;
 
 		dp = dsa_slave_to_port(lower);
-		if (!dp->lag_dev)
+		if (!dp->lag)
 			/* Software LAG */
 			continue;
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index c71bade9269e..0bb3987bd4e6 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -468,12 +468,12 @@ static int dsa_switch_lag_join(struct dsa_switch *ds,
 			       struct dsa_notifier_lag_info *info)
 {
 	if (ds->index == info->sw_index && ds->ops->port_lag_join)
-		return ds->ops->port_lag_join(ds, info->port, info->lag_dev,
+		return ds->ops->port_lag_join(ds, info->port, info->lag,
 					      info->info);
 
 	if (ds->index != info->sw_index && ds->ops->crosschip_lag_join)
 		return ds->ops->crosschip_lag_join(ds, info->sw_index,
-						   info->port, info->lag_dev,
+						   info->port, info->lag,
 						   info->info);
 
 	return -EOPNOTSUPP;
@@ -483,11 +483,11 @@ static int dsa_switch_lag_leave(struct dsa_switch *ds,
 				struct dsa_notifier_lag_info *info)
 {
 	if (ds->index == info->sw_index && ds->ops->port_lag_leave)
-		return ds->ops->port_lag_leave(ds, info->port, info->lag_dev);
+		return ds->ops->port_lag_leave(ds, info->port, info->lag);
 
 	if (ds->index != info->sw_index && ds->ops->crosschip_lag_leave)
 		return ds->ops->crosschip_lag_leave(ds, info->sw_index,
-						    info->port, info->lag_dev);
+						    info->port, info->lag);
 
 	return -EOPNOTSUPP;
 }
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 26435bc4a098..c8b4bbd46191 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -246,12 +246,14 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 
 	if (trunk) {
 		struct dsa_port *cpu_dp = dev->dsa_ptr;
+		struct dsa_lag *lag;
 
 		/* The exact source port is not available in the tag,
 		 * so we inject the frame directly on the upper
 		 * team/bond.
 		 */
-		skb->dev = dsa_lag_dev(cpu_dp->dst, source_port + 1);
+		lag = dsa_lag_by_id(cpu_dp->dst, source_port + 1);
+		skb->dev = lag ? lag->dev : NULL;
 	} else {
 		skb->dev = dsa_master_find_slave(dev, source_device,
 						 source_port);
-- 
2.25.1

