Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028E951EE91
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbiEHPb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbiEHPbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:31:25 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10053.outbound.protection.outlook.com [40.107.1.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF20B87
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:27:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exifFNlZvXdXib3PD8hK4sYcSWB1VDuZZqnmpEGWh3xosA5MZGe4/zAtIA1EuxnogvObE7l7f32eLwiyHvPcsXI4MDgYex2+74uZQFV7vXqs2JRjKbsFBuMfgK2LW+I9BbRDAyjhjT4RQoeMZ7X0sP5D72koGoe0qmalptyYBb0P1/SdT5ExQDNeb/206DgTbpHG3re4FMgIM0qOH2YSZzFSAuIZJlriILSrW9YIcKeh2Yae/vilCOuZ3A6KqM+Jb5Pi/6Fg/os+fy2n91ezlYLvz8joKf7fSdNdrI++2X+E1jTGXK1mBVJyIU+M+Fz+NZ8J+9+Jo2mw+2hRM19QBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AhMAaUAB9+9Qk52tpPzNMru4aABXxrKLdEA8+dKytM4=;
 b=KAX7Bu5aWiuAPBddujrqp0BOzhLrqXEzHMMb49TShSBHkZgZI4aSEs8JSdlvSDAo20eOoNkjuHb+Q0N/97jOr3O1dNvdnjT3clgCQFawn8S0pcMG1G0qIm6uq9ss1tAIqpbxgliwJlBFh20Z0dbGSUTGRhe/lFl0uwdL53SDpwe7pt+nBZ7eqiBI/Hv/ZoVVUln+9HD6ZLFq/WVOEquFSgojsjWjjFApZU3J2nmhh6nlBJ/K3yMd2aPCH/84LJeijVRmTXHp5Wpo2uDQoD2fD8xJ9VjDoD006x+BMjwUYmO96rfS8F8o5DIjqdbKOKqZakHLYNl+CzF3sBLjFr1lYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhMAaUAB9+9Qk52tpPzNMru4aABXxrKLdEA8+dKytM4=;
 b=RcDZCPyWDRuvSVEthjBT171cabZmg4oykBiRr/Mx3ToBbkiFZ0sN7WkN1lWSB8wDJGHjRM/wJ6ab8rAv/3wlQutCazR6SHSWSCO3LOr/F0/eXI54xzcKpmIT7HfFA0RmhE+OoRkmD16Ve8bzBgcTHrCbojLXImN6nNcgWAxGU6k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB6PR0402MB2806.eurprd04.prod.outlook.com (2603:10a6:4:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 15:27:31 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Sun, 8 May 2022
 15:27:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [RFC PATCH net-next 2/8] net: dsa: felix: bring the NPI port indirection for host MDBs to surface
Date:   Sun,  8 May 2022 18:27:07 +0300
Message-Id: <20220508152713.2704662-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
References: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0205.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::30) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00d0e2fe-fde2-4026-54dc-08da3107448a
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2806:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB28060DBB108553F1141E90DBE0C79@DB6PR0402MB2806.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WJxu3NQiarLYs0izTAWp58EsZXNyW0AfcecrpshcKlVzPjg6EbyU//la3cpOfNL3qztSepJ5ORP/fnwpIsmqneimE+op3bC34RE5rkZBAmwOELNxTDH6txkLJooKm1umv3ev1s0u6LLuIBT7/ootRz826T6q/mMGQvrp9NsG7wz+hk61HItvQomfewDM5tlkqHTR5722UJ1genNhI40CUjL/3AzaT2Cy9jA7+FPFF9eWyezayO3Qo/kqWEWLtJQh+FYoOpjywtMhQWZZzPvA41tf38jeL+ZjUWNDS4WQvIO60WIfRG+40za04Ye4wGQYPu2tU6Y1dhd3sfBjZDJ70S3t86OrbDcDIzHTswbecFZQbEEQCeORqTFzHWEbvxcEK47K5M0+JYUCjtP+JhVTAcK7N/wlsjOPBjaMmGRYdB2TEdx5CuyhpxaNk/muQcGNkl54Ht+NM/ZRaBfnzwfY/XTEU0ImqPPCZKGTrf7j1PsG7mT2XK0Gu6X5WaIQYLo4PYUGIbrs72h6Dfm9XFJ6bc4/8xSHASeTGzToYhjGUkz3V1Gy5prE040H/pUKLFocfIKXpAV+a/U2ge/PsCl+eAyTUGa1T0uwOUojgOjwbEshXStfmwv6+jUklJXcyzvRvSJVZzCmjGleoZyColRi6iKIT0S6JgFQHvHi8IrYOP3Oh/P6JCzNEF7ppNBz7QeE16zCEC+YF/QU/gRyXzEiog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6666004)(6506007)(36756003)(186003)(508600001)(6486002)(2906002)(38100700002)(38350700002)(5660300002)(6916009)(66946007)(26005)(1076003)(44832011)(7416002)(8936002)(54906003)(66556008)(8676002)(4326008)(83380400001)(86362001)(66476007)(6512007)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zEtSW1mZAWpR6a8BaT4/S9PtfLDdi+okGP5HbRhrQug4DwSiZhHKmpkSkIbx?=
 =?us-ascii?Q?Jb323UWtAK8/BVkdfIoDS2UAWx0vMJbUBzdy7yV/wL98efw/sTfMYFZ3Z8nI?=
 =?us-ascii?Q?USaZwjiRJPuXyHT993LSogc5OYOzaA9CY1unqaB/LU8al8TsD67E5a6lZv0H?=
 =?us-ascii?Q?yY537g+g+qD2f0q5WrT8tD8xKDmEZE24oyZKIs6OA20bOvM6iz8KGs7uP6af?=
 =?us-ascii?Q?aJY6FSbpn4Ypx1LC1oHD/FYjSb+ymrYDSjRWg/RXINtJ6/bS/JK5uLn8rXNY?=
 =?us-ascii?Q?9oilPIGEp9XBrgbi24aIk4meiF1GxnSy0BMBTu+SM1b05em+4l8Pl7Vfbl7+?=
 =?us-ascii?Q?WjkcaeWMmhICAMAAcxeOwDVoJEr2JKrxteSRCiQMOrdXitZDh+CN2VL3icq1?=
 =?us-ascii?Q?OM2U05FYOht6KtOWTzAaoQ5sdLTggB9gZT7Qak0w/cGPz/SC/NxaUcIs685d?=
 =?us-ascii?Q?uxgLAaQWKGcl1fvsttlUssYG2GcEhT0P6fjfcA9OAnDpC64HpIWMZkDiLFsf?=
 =?us-ascii?Q?le+OCE5qqJJK4AU3qlwXu4EMlHYrOq5VyjkhruTdMDCTmKZ3SgEohHBGSq9X?=
 =?us-ascii?Q?km8++wEDxBy9Ua2RcEGp77H3vz9/q5xmJfAWKsnHoG2arL+RPpjcKq6tHtDF?=
 =?us-ascii?Q?g0mLxuChqiXM7b0KhRwI8GPinzMxLcotBLQCfikWuw665a1ybp7wC9WrWYJj?=
 =?us-ascii?Q?M0cKVItq7PJH335FBecjEfX54Wl3gjfBfbzOdZ7K4RIqRZ7VT48cQ5ZogvOn?=
 =?us-ascii?Q?ul5256q2FtARbIdJ1eEXZBOdBa6nJ1qqPpf/otSqSvHEFLxhfxVWyyeT24eA?=
 =?us-ascii?Q?RlRCfEi0S/Y8ek4iWtg5fWK6JOet6aSgiAw2W0X2VjSbVMIYIiQJKmG0OOS/?=
 =?us-ascii?Q?GbJYSPtC4W+blGNyZhWJQeuaEQ+Tj0teqEJN7ID5gGUF8S6PK9Gv89VDhKHf?=
 =?us-ascii?Q?UOr8XX3rkITOuBZ0WiJyYoM+R0qk9WuOA+L47P1iCq+Ymqgq7QCwdXiwDCGv?=
 =?us-ascii?Q?YH/JDeum/weLK0xnJYSRHfVmAZbwjkwL2Jf2Or5YdOfp9cFYuLa397hGtjpH?=
 =?us-ascii?Q?PDjXhGFlKzMFpwJoXhfmDT9wOymuLA5BsIejsZ9pSkviv1ZO7SeW2d1WGBcS?=
 =?us-ascii?Q?sloLsITj8LJ2FWwlTjmGzLU/PUW2Rry1xquMHz81Ei63uFsDehfdLZlQxs3H?=
 =?us-ascii?Q?eTKUHcrhCGYMeOu4n4kFe3Hu4K/bdrldpMcnGJP6h/mkl7Yv4HWodh2a/8Y7?=
 =?us-ascii?Q?SkzHdjv9/iMICUD7HcUl5MuqmjLdqr1kyRZwkSumhpcujc+ABnjdqVNBIkni?=
 =?us-ascii?Q?MFRDPipKZKi4wWwO2hWh5D6T4lb8C0WkTdMmLphALF3wSq/NDe1DQ6hVylMM?=
 =?us-ascii?Q?LZgaiIe6Wlr5CsXJw9A7r5l8K/Cc3hkk4b0gm8HX5/cKojkLyuYi9Ien4Fzz?=
 =?us-ascii?Q?kgjJRIChPbVYPEPNEeFDWnGhsYo7Zph2zLQ49UGHNrJEDovMepbiltyUmva+?=
 =?us-ascii?Q?xPjoi2RkflQLrhhaaMHU87Scd/ftzNX5E51aRDeQ/mmD2a7pgfIuZwcZ/b0H?=
 =?us-ascii?Q?qGtlAVKFiSB77wpnO8z4EjDBhUf+r2G60mPKR+loYl2fi4+uFiIeO0ag9+X/?=
 =?us-ascii?Q?vDPb02ZLaWb7P6IeuG+dLQ6Qch50dwP68UoQmfhFA8Wjr94jA1k+ZAg+JISD?=
 =?us-ascii?Q?Vm328vOwcWAcsv46OUQgNZI59Ko9ldSrJEeBYEyZbHArvz8STto3DY4hrUKv?=
 =?us-ascii?Q?p97JxXvKKXyuzJnZ5jHNwpy65cFZBGE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d0e2fe-fde2-4026-54dc-08da3107448a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:27:31.2201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y5Kxa6QD23i+inMIMTorAca2I+V9+JrOGoKRPemCDSjIYi1popFHrM/sFwHYQKSc8sNinLMyB9eaJIIcb3qWsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For symmetry with host FDBs where the indirection is now handled outside
the ocelot switch lib, do the same for host MDB entries. The only caller
of the ocelot switch lib which uses the NPI port is the Felix DSA driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c     | 6 ++++++
 drivers/net/ethernet/mscc/ocelot.c | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index d0105a11bc4f..3f23a6093b27 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -745,6 +745,9 @@ static int felix_mdb_add(struct dsa_switch *ds, int port,
 	    dsa_mdb_present_in_other_db(ds, port, mdb, db))
 		return 0;
 
+	if (port == ocelot->npi)
+		port = ocelot->num_phys_ports;
+
 	return ocelot_port_mdb_add(ocelot, port, mdb, bridge_dev);
 }
 
@@ -762,6 +765,9 @@ static int felix_mdb_del(struct dsa_switch *ds, int port,
 	    dsa_mdb_present_in_other_db(ds, port, mdb, db))
 		return 0;
 
+	if (port == ocelot->npi)
+		port = ocelot->num_phys_ports;
+
 	return ocelot_port_mdb_del(ocelot, port, mdb, bridge_dev);
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7a9ee91c8427..29e8011e4a91 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2339,9 +2339,6 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 	struct ocelot_pgid *pgid;
 	u16 vid = mdb->vid;
 
-	if (port == ocelot->npi)
-		port = ocelot->num_phys_ports;
-
 	if (!vid)
 		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
 
@@ -2399,9 +2396,6 @@ int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 	struct ocelot_pgid *pgid;
 	u16 vid = mdb->vid;
 
-	if (port == ocelot->npi)
-		port = ocelot->num_phys_ports;
-
 	if (!vid)
 		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
 
-- 
2.25.1

