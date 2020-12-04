Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593C02CF366
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgLDRzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:55:18 -0500
Received: from mail-db8eur05on2080.outbound.protection.outlook.com ([40.107.20.80]:41024
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726021AbgLDRzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 12:55:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Up1+TuDBUXzibL5W+xKc3qgbm7iofD35fqlhAoA/J4Xo2cw8jPkMyUbZA156GZFnMANsd4g6DtZpHhk90IOwx52FEeuEO1Efb42aeZkj1+Apb42SexmUYf7J0c3TvGUqBA+SM3FR112HSHAt5vHLqkCPFpUUofImnEKD06HABE1UPs4WC45CbDXvuoXHQJTP75W90+ZLER8WAFQYRnUPtP1yK33F2fY0167lDDH+MPua8raT1HcSXnlXcq2TVWc6SWSKBXa9jVBYX6eVbI9bOWQxcVI/FSt69l7iwRB57VS0vG0uYtx/x/5lmBC9mlxfZYDKKwb2hZyXGnXYGHn7DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejZx00TmhPmoq72zfS+zsJtFaYpEtk10oYkkjM6HFTc=;
 b=L7zg7dFXWu8Cfqf8RtMgGOEcfvJg4I4MZ5iAIQRzQ55HhuT2oRtez7BYPXYz+6wBqSRU9ClqUc+IyDH7axTYB0A1wTYybWQzMEMkZ0jLoyzBFEIcYemCILnylxhnsX1O8tdPh8VvgsSO1E+xKHmvkEVDO5gRXDaL4DMw/JskU4IVYHg9dovKQTh1FYCDKuZPwXBYo2VrfYpCjfzGKxWrKyKM1vvsg/QRpQJjD5VD6aZRpFxyzejePpiTcI2+GFOYxGpZiOIdHyqC/q+SAlPIEKZ6VtZG1W4HiU+eOJobpwq89ggBOJOQqy3MBQGf1nYtbIT3PaR5Hue4PWn9FMldJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejZx00TmhPmoq72zfS+zsJtFaYpEtk10oYkkjM6HFTc=;
 b=YEKOVAY0dFx+cGTCcOkR40n1qGnPVxDqo3xkJuJZK4iE/L7668XhSryeabIE/PT+gxCxe7eoC8L3Q1MHq0E5zQpBDZmry65qaQqyfTAIsUYENU8MzKHfn+l9LrC6pcpmfXB7rHzGqqjK78PFPZVQrMQnqK/z06hIBLekltj7nek=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.19; Fri, 4 Dec
 2020 17:54:26 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 17:54:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: [PATCH net] net: mscc: ocelot: fix dropping of unknown IPv4 multicast on Seville
Date:   Fri,  4 Dec 2020 19:54:16 +0200
Message-Id: <20201204175416.1445937-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM0PR06CA0113.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::18) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM0PR06CA0113.eurprd06.prod.outlook.com (2603:10a6:208:ab::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 17:54:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ebb64eb4-541a-4bcc-6ce6-08d8987da438
X-MS-TrafficTypeDiagnostic: VI1PR04MB6941:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6941CED38F24D823AE82A6C0E0F10@VI1PR04MB6941.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IimZPFZd7GMH8TxgO9PnrX087CJJi0It6Pgw/yDYPYNHaVOj3oFlMUtY6wuaQRcwtBPiO/acmk5agVUTEhYfI1fufDFrHxMxUVNBNiGtYJly5DydtKSMFLkP4fBPHkIdB+Y60dYrhAbkrEdTCFxhZcviv5cAQyk7AKjeannjMFv/h/bbHGFldvH0zINxD3bd6fiv/RxyiUx1aarFqLlELE0xku/uW5mwyrWiVE6wTTZEVfC8OrUBsFLz3IDcMB3k6pxDpo8AgC2mdEOYZHTBSJceMnQGXxpvqDZH8rEZWAJVMra+qfheGCeyZiMiBBMUWhJnwKfbMl1l6s4EXPZ5aYSMbPIrKHKZ8YY7jYCV7v5NQKBVEPkuBd4/HXE9NZFU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(6666004)(36756003)(6506007)(7416002)(2906002)(86362001)(66476007)(66946007)(1076003)(69590400008)(5660300002)(83380400001)(44832011)(478600001)(54906003)(956004)(110136005)(52116002)(316002)(4326008)(8936002)(66556008)(26005)(8676002)(16526019)(6512007)(6486002)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?HLqH7E9EWU3l9P18X2oiFwtUGEddYJgm+dojKKz3jjNrkJ4F385DTtDPUlfH?=
 =?us-ascii?Q?GFKoU5+VfdrL8HSXuicSHkremawkoShDdXfJvkWdUpKymAmDothU2YrZAHEc?=
 =?us-ascii?Q?kpYEm2MK514xPlSQq8m+JdM1bcLb5eEyIzKI2GDzSsLuVdXsCEbOjZ5919bB?=
 =?us-ascii?Q?GSQkIv4Vz0vQNbMYFp/qC8rJB1CZDl4GAySJag4kPLrt5Ir9Mo3XISPQ8Au3?=
 =?us-ascii?Q?a1VQPCokR1F4VfHngcuIuhtMlwsH8fthA2F2g1AKdDA7lgKTf54xrhtr3GNP?=
 =?us-ascii?Q?H+GSMfz58KkuViz8rgYvOapVd/3D+znkq2EBmKnQx/X5v9q83owQipMMfH/s?=
 =?us-ascii?Q?nXN9pE4s5v0vKvEA0mIFjB0joZTRcX0GSON2NYX+YKtVBX0fGZQ5leUMHP+A?=
 =?us-ascii?Q?8zGSO0z5lYYG0VwrnLxXcod3x+UzdwVK+BRa57TX0IKxkw8bbVwGvIfRkVCa?=
 =?us-ascii?Q?0BeUDCxZgDG9czQgEetkiOtsasmhkLdErGdGIGNNHYdzO9qPkRD7ScS1ZMjW?=
 =?us-ascii?Q?XAHY24HAmCNwsd2MavxM4dd5lZM/LREP95KAy/UE3CQLTsj5l+AtHEXdGs/j?=
 =?us-ascii?Q?d0h7zQt6eSySkZTATSvgbZaIZRsYChCcPxvxZEyoO0gLzogMToGbI5AhuXIB?=
 =?us-ascii?Q?r0snqRK8UHLlBK7aFjA0Byki2rcX3lWI/0t4jiOO9zofIKPXYgR62GL0VxJw?=
 =?us-ascii?Q?Cxz66yPCPRkYF2QDCaEUegV5Njtfcxmtp73Dtw87yYBwGnDxqsNhfUWTaY+3?=
 =?us-ascii?Q?kIJQgiaR8MWPwe0OKyxB3XobJuGRgn+Lzsb71PmOROBD2jfPD+Khsj8AioZU?=
 =?us-ascii?Q?7mJo9XCpxH3dcoNJA9GNAlv3FiACRg0jrgr0TljqjA1LjJP8A0Iqudajit6c?=
 =?us-ascii?Q?cmhCsLnh4J05g7OWFUh3Er3Bxffk4i1dXsEi2UUQW66zVktSdxgniiZazlxR?=
 =?us-ascii?Q?XgYrXOCwco4gWBqEq2/IATf6agDx6QBbxgAEeA2i16Hwkh5FI6hFfoPY5vow?=
 =?us-ascii?Q?ak6G?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb64eb4-541a-4bcc-6ce6-08d8987da438
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 17:54:26.7999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BcNoFCZ3AHRSzbPqRH1EiDBrJVYPyr/wgkDwJrM3XqgXHDxYdfB27InJzspektuuZLZWYm6cnnTzCTwOJDlRhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current assumption is that the felix DSA driver has flooding knobs
per traffic class, while ocelot switchdev has a single flooding knob.
This was correct for felix VSC9959 and ocelot VSC7514, but with the
introduction of seville VSC9953, we see a switch driven by felix.c which
has a single flooding knob.

So it is clear that we must do what should have been done from the
beginning, which is not to overwrite the configuration done by ocelot.c
in felix, but instead to teach the common ocelot library about the
differences in our switches, and set up the flooding PGIDs centrally.

The effect that the bogus iteration through FELIX_NUM_TC has upon
seville is quite dramatic. ANA_FLOODING is located at 0x00b548, and
ANA_FLOODING_IPMC is located at 0x00b54c. So the bogus iteration will
actually overwrite ANA_FLOODING_IPMC when attempting to write
ANA_FLOODING[1]. There is no ANA_FLOODING[1] in sevile, just ANA_FLOODING.

And when ANA_FLOODING_IPMC is overwritten with a bogus value, the effect
is that ANA_FLOODING_IPMC gets the value of 0x0003CF7D:
	MC6_DATA = 61,
	MC6_CTRL = 61,
	MC4_DATA = 60,
	MC4_CTRL = 0.
Because MC4_CTRL is zero, this means that IPv4 multicast control packets
are not flooded, but dropped. An invalid configuration, and this is how
the issue was actually spotted.

Reported-by: Eldar Gasanov <eldargasanov2@gmail.com>
Reported-by: Maxim Kochetkov <fido_max@inbox.ru>
Tested-by: Eldar Gasanov <eldargasanov2@gmail.com>
Fixes: 84705fc16552 ("net: dsa: felix: introduce support for Seville VSC9953 switch")
Fixes: 3c7b51bd39b2 ("net: dsa: felix: allow flooding for all traffic classes")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c             | 7 -------
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 1 +
 drivers/net/ethernet/mscc/ocelot.c         | 9 +++++----
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 1 +
 include/soc/mscc/ocelot.h                  | 3 +++
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index ada75fa15861..7dc230677b78 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -588,7 +588,6 @@ static int felix_setup(struct dsa_switch *ds)
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
 	int port, err;
-	int tc;
 
 	err = felix_init_structs(felix, ds->num_ports);
 	if (err)
@@ -627,12 +626,6 @@ static int felix_setup(struct dsa_switch *ds)
 	ocelot_write_rix(ocelot,
 			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
 			 ANA_PGID_PGID, PGID_UC);
-	/* Setup the per-traffic class flooding PGIDs */
-	for (tc = 0; tc < FELIX_NUM_TC; tc++)
-		ocelot_write_rix(ocelot, ANA_FLOODING_FLD_MULTICAST(PGID_MC) |
-				 ANA_FLOODING_FLD_BROADCAST(PGID_MC) |
-				 ANA_FLOODING_FLD_UNICAST(PGID_UC),
-				 ANA_FLOODING, tc);
 
 	ds->mtu_enforcement_ingress = true;
 	ds->configure_vlan_while_not_filtering = true;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 3e925b8d5306..2e5bbdca5ea4 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1429,6 +1429,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, felix);
 	ocelot = &felix->ocelot;
 	ocelot->dev = &pdev->dev;
+	ocelot->num_flooding_pgids = FELIX_NUM_TC;
 	felix->info = &felix_info_vsc9959;
 	felix->switch_base = pci_resource_start(pdev,
 						felix->info->switch_pci_bar);
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 1d420c4a2f0f..ebbaf6817ec8 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1210,6 +1210,7 @@ static int seville_probe(struct platform_device *pdev)
 
 	ocelot = &felix->ocelot;
 	ocelot->dev = &pdev->dev;
+	ocelot->num_flooding_pgids = 1;
 	felix->info = &seville_info_vsc9953;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 2632fe2d2448..abea8dd2b0cb 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1551,10 +1551,11 @@ int ocelot_init(struct ocelot *ocelot)
 		     SYS_FRM_AGING_MAX_AGE(307692), SYS_FRM_AGING);
 
 	/* Setup flooding PGIDs */
-	ocelot_write_rix(ocelot, ANA_FLOODING_FLD_MULTICAST(PGID_MC) |
-			 ANA_FLOODING_FLD_BROADCAST(PGID_MC) |
-			 ANA_FLOODING_FLD_UNICAST(PGID_UC),
-			 ANA_FLOODING, 0);
+	for (i = 0; i < ocelot->num_flooding_pgids; i++)
+		ocelot_write_rix(ocelot, ANA_FLOODING_FLD_MULTICAST(PGID_MC) |
+				 ANA_FLOODING_FLD_BROADCAST(PGID_MC) |
+				 ANA_FLOODING_FLD_UNICAST(PGID_UC),
+				 ANA_FLOODING, i);
 	ocelot_write(ocelot, ANA_FLOODING_IPMC_FLD_MC6_DATA(PGID_MCIPV6) |
 		     ANA_FLOODING_IPMC_FLD_MC6_CTRL(PGID_MC) |
 		     ANA_FLOODING_IPMC_FLD_MC4_DATA(PGID_MCIPV4) |
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index dc00772950e5..1e7729421a82 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1254,6 +1254,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	}
 
 	ocelot->num_phys_ports = of_get_child_count(ports);
+	ocelot->num_flooding_pgids = 1;
 
 	ocelot->vcap = vsc7514_vcap_props;
 	ocelot->inj_prefix = OCELOT_TAG_PREFIX_NONE;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index ea1de185f2e4..731116611390 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -621,6 +621,9 @@ struct ocelot {
 	/* Keep track of the vlan port masks */
 	u32				vlan_mask[VLAN_N_VID];
 
+	/* Switches like VSC9959 have flooding per traffic class */
+	int				num_flooding_pgids;
+
 	/* In tables like ANA:PORT and the ANA:PGID:PGID mask,
 	 * the CPU is located after the physical ports (at the
 	 * num_phys_ports index).
-- 
2.25.1

