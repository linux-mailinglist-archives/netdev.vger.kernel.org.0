Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADCD646C136
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 18:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239699AbhLGRER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 12:04:17 -0500
Received: from mail-bn8nam08on2122.outbound.protection.outlook.com ([40.107.100.122]:58464
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235096AbhLGREP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 12:04:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCWQSJj0P15o0rnEaHYYzkI5DDwN96uUpzhoAV6PPU819R7LJEU9UMgIZmqbmBnTL4AgcywyxvSw0O1Mct4oi7xhnvVOlxy/gYJWJuzJQxmhbmQJtpKBOTTWSjahJzAgA3EHAsNvlZhcaUTtJoWxuVltrkAO5CyLGoIjzeaTmK0LkVCUpJutX1PvG83R0NrHbzmlt0b9crVleWEgM0eJxyBAjj7I8tQOAejTmKV/OZc0MCG1sDta/EhFvRRwZeaJvyP7c6tzz8pOQOdbi4nDVMD2nzNgZHkQ9a3H1x9gnA5ZtDqbyVT+Y2Lxp9H+ktKI8LiIHqECHUlBG2HUw2BRKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJHikKGjzYL3zY3aXozgnTIg6hgegdf2xZxHKjteHdk=;
 b=WpPifyq75UrT/VVVRSzADdaDLgHMB6cI/TO8V5MPZnif06t+PjUrsaMouRhjNdbUiT0BhNvfO7gy9AG4kfDg8mwfiADG1kYcSceBdpcR2YRJfAg1w2gu+VctaDWB1SiMrTVAI5Yl9fKLhPYK0ae93gpWf73ZjU8taOVVTxr/nzA4QJB0k1ab046aPdmEMPVEWmg09mgOJQ+xXjho7eQqkDUeSXBB5uA8vJOevFpVLTSORBFAPaD/9W/FBiQTDJiNQepIUqNJShS0qp0FDlDO5TnLzAm5zf+6IzmTzdzNN8BaKqK96eunQSNNGRIJATXXyuWt+zEWNYNKAuvH/EFZvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NJHikKGjzYL3zY3aXozgnTIg6hgegdf2xZxHKjteHdk=;
 b=wtUtaLkpAW3R3rnPx1rc4ybO+lUpl5GWJfgAKLZEtSCIjep2INWlDqTQx9Ll3AO7MlvqPP+y8fZoJo9zVf3Ho+0BiEGKakE53BVrj2JQArZVUAR4AMandUipDnaNjEekFRpxvWdPO6KaJ1qGcySnfQUkvfCiPjVnupLj1I76u9Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5441.namprd10.prod.outlook.com
 (2603:10b6:5:35a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Tue, 7 Dec
 2021 17:00:41 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 17:00:41 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v5 net-next 1/4] net: dsa: ocelot: remove unnecessary pci_bar variables
Date:   Tue,  7 Dec 2021 09:00:27 -0800
Message-Id: <20211207170030.1406601-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207170030.1406601-1-colin.foster@in-advantage.com>
References: <20211207170030.1406601-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0059.namprd16.prod.outlook.com
 (2603:10b6:907:1::36) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW2PR16CA0059.namprd16.prod.outlook.com (2603:10b6:907:1::36) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 7 Dec 2021 17:00:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 522f664e-992a-4102-8416-08d9b9a319db
X-MS-TrafficTypeDiagnostic: CO6PR10MB5441:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5441D4738C1526F866394D0EA46E9@CO6PR10MB5441.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L+2OUoZoQscUpwDhY8lQcMRHsarCTizdIVdwxKmukI8gqMSUrPlwX91yLrlckD/Fo7yLeu5llYLX+SwGPmZt6iQFdxPeqzuIJTZRWfVt0o/0OkpbJEvsNoAtpxJJrMJHBd/qdtqFvLsmQCZ0FNk9hztXJVnNzJ8tbeG+zL0a+SgmjqrS1yYbG0ttgi1ADEmqTOf8k/MhiVT1qYcK0Ig/7R0FycFeof5C3etu/djTi7qNWb1L4TKTxJx126CaSjnD6C6Urt/dGBnxJqdIy0/rR3omQtcuEM1ZJUCwDMcXPVAph+Thl2D1o+hqyOq07EvmTIxHTzMQeWu2UCEc5GLeDOu18XBe5/rUSh2XTmfZuknpi8/tkYCzKOXJLevbuE/s1S48iu+6AxLLhgZQvXpcDCo/02P3crdP1ammEUE1PcKhgmkyaFFMSPe7BoaVoSfNHqa3TsCO0BF1qDZlcDWGIbFAkM8SODxZkO5U2k8SyjbNER33xomCu6+4sF8T84Dh16hQft6IfjU7dOPVPgI3Y3D+cwhu3OizOej0FgsLil7vi9Y5VgY6RYMSGvCWJlGPcnLdwd8NNJgKf//hLpb0C2qpF9x7s4Sn7bdRuejl+j5iQCd/Kjt8BobLRNRJ1TsL/CKtTdFupz3sy4Jq7K6pZFWZ0emVKQR0OkdhszU6SUFJqu2cBm68PPgYBjvvc6Tx9P8GnurViormL4bBmtWFtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(366004)(39830400003)(376002)(508600001)(316002)(7416002)(5660300002)(8936002)(8676002)(83380400001)(1076003)(54906003)(186003)(4326008)(66556008)(6512007)(66476007)(66946007)(6666004)(86362001)(36756003)(6486002)(26005)(2906002)(52116002)(44832011)(6506007)(2616005)(38350700002)(38100700002)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QsCrP1xLODCAZTwQFfx2/ryRdFtFiZ1SCMGkioe5v+JB1qnIdXg3BSoEgIBw?=
 =?us-ascii?Q?Pwlq04uH0rHSUa1RY8uVJ+dqKmhDS9W49pTQVe2Wl3CyXdOO3/3kAXkELVRk?=
 =?us-ascii?Q?jeZxMbTelewnocd45ozE6LlN/bkUQ7cx5WbYkb4awvG2M0mAE8aP7biNlQuj?=
 =?us-ascii?Q?y/whjevQ30hikBdATaCX2reO+e4g6hrjLRG6naVSy840U7QmEm8xkHfdNB9r?=
 =?us-ascii?Q?XH4ogQJdNCuS2P22tANPyc/DTYX2mc+PEEPLmqVEAjbQTFMOL18Xg0KacC+h?=
 =?us-ascii?Q?Oq4BnT5JAm3Q4ksILhbiQZlJ4B8y97ESNfo6KpUqZsg7YLJAmzc2UMmuEQty?=
 =?us-ascii?Q?V3Yo2PUdHyXptJWXEQxvMC+p3DUCZ5YHz7YD/sSv+5AoWNpj0xYRwBUYyAhJ?=
 =?us-ascii?Q?CdnQPf+TKwT+OcvFIdcN1u5cNmj4bmCHFZYPGftApzrhyKP2OfnypQXVtq5F?=
 =?us-ascii?Q?0Hk9TJE8SlTr4oa3wXxpNnG8iVJypj6tK2yk/y7ct2vl8lQZxqdSJJogdzy7?=
 =?us-ascii?Q?p0o9nmGILN81LaNTNPur3UM7C6XZ3Wlzev2uIseveCZ5Bu5k4Dniq3kselTd?=
 =?us-ascii?Q?Q0lRssZF+loEZfyo1hyDt2i+DNtPH41oVuTLqFBJ89YsUKBUbQCjjiI4e15Y?=
 =?us-ascii?Q?XIC/i44L8F4l3ly+NcUoeg3sav1Opj++lVsI7DsGzq8KFswqWoXQEzV5hEVF?=
 =?us-ascii?Q?oi28VSk46cYLq2J9P9s4g3CsvNJUt/k0stWF9vwsYpa6YikU7Mzg5RMRPTVY?=
 =?us-ascii?Q?aT8rKIsqEQdiFO/GMHJRsBBJ9d2bzXUcmQ4/i2MMlDTl1kfwyqUPNZ9ypvOh?=
 =?us-ascii?Q?w34pdz/m7Gj+PcihsKYY8CU1EfTTw0HPgnxSCf88iDPKGXHnHny4ZMFgipI9?=
 =?us-ascii?Q?UYMBMgtJP4JoWQCh1vx82x+KqFFYtidZkbxpfI5kkTJ8W0RsXEiuSY49ivIp?=
 =?us-ascii?Q?PPZmVSRXS834n8fnefKZ9YZwbmZ5nS9CZ6uuKUjlGg5mk3givJTri5Hhxjed?=
 =?us-ascii?Q?BraXS/xKLqtUapaLphbydJVWEfc/8TV7pZiMGuwqW6EV1xr0U8RrKqhCda+G?=
 =?us-ascii?Q?hZ/eAhKqpx8G9UDH7fQd2Mr8jeVRp1nLP/oUb9njlyXNAoIVTrHG+gO4q2ZH?=
 =?us-ascii?Q?U0So2KAJpUU6QZ7RiPWSgsYcDEZRmLv/MWisZHIzuF2mB7aIVEyTGMMxRjbn?=
 =?us-ascii?Q?MT0ajKxWBim/5qi6J7f5bUSE6wMDgwigjV+qRyNoici9c4VOcBNqNKeu2Upu?=
 =?us-ascii?Q?U1rhTHsIrrWqIe8WckftKYEvHrKd33nQP9rFgFtXbQzBIjFkyJkEHJIRcdgG?=
 =?us-ascii?Q?dmveL5PHboGSt/QH8O5vYW61qk+njAhccSVZvmPn/IHbguO5xZwRqupkd1as?=
 =?us-ascii?Q?DNXAPZVTus24ESH/VAAl6bkISUQD4nxPwZDMaI5guKZlC01g4Am+ojoins8H?=
 =?us-ascii?Q?bgyCROOrl4VvrxFb3PPdLC5AoiopJ+/LcHVC+L99vAze7LQ52pxQML5QPwNZ?=
 =?us-ascii?Q?u1Jpqj5BXvDphvoc0eUG/myNA7Gl5svzX9fMia/5SZoWXqxYsWZFd4OQhzkU?=
 =?us-ascii?Q?8aNYmVFV+DMVh4OOID6jevOFiVdd1TI7owBAuUTPXVpi/FNuIrxSS/pCE5pN?=
 =?us-ascii?Q?0hndbFjJfkbqmXaTaGQ+JJe11bAzlITqgeDXM8/k7uAgqeThGrgAPb48MDOR?=
 =?us-ascii?Q?I/Wzqg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 522f664e-992a-4102-8416-08d9b9a319db
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 17:00:41.6438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yk3SaHEIOgpZasBZE86SvEh46JOWVuXe6o+IQcrUEhnLaO0BPKUQy2f/f95BLpXontlmIm2J3G0+IlWvtyOQ+yrvxL7sBL/+1vw8iy4842Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5441
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pci_bar variables for the switch and imdio don't make sense for the
generic felix driver. Moving them to felix_vsc9959 to limit scope and
simplify the felix_info struct.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/ocelot/felix.h         |  2 --
 drivers/net/dsa/ocelot/felix_vsc9959.c | 10 ++++------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index dfe08dddd262..183dbf832db9 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -25,8 +25,6 @@ struct felix_info {
 	u16				vcap_pol_max;
 	u16				vcap_pol_base2;
 	u16				vcap_pol_max2;
-	int				switch_pci_bar;
-	int				imdio_pci_bar;
 	const struct ptp_clock_info	*ptp_caps;
 
 	/* Some Ocelot switches are integrated into the SoC without the
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 9add86eda7e3..0676e204c804 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -21,6 +21,8 @@
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
 #define VSC9959_VCAP_POLICER_BASE	63
 #define VSC9959_VCAP_POLICER_MAX	383
+#define VSC9959_SWITCH_PCI_BAR		4
+#define VSC9959_IMDIO_PCI_BAR		0
 
 static const u32 vsc9959_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x0089a0),
@@ -2230,8 +2232,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.num_tx_queues		= OCELOT_NUM_TC,
-	.switch_pci_bar		= 4,
-	.imdio_pci_bar		= 0,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
@@ -2290,10 +2290,8 @@ static int felix_pci_probe(struct pci_dev *pdev,
 	ocelot->dev = &pdev->dev;
 	ocelot->num_flooding_pgids = OCELOT_NUM_TC;
 	felix->info = &felix_info_vsc9959;
-	felix->switch_base = pci_resource_start(pdev,
-						felix->info->switch_pci_bar);
-	felix->imdio_base = pci_resource_start(pdev,
-					       felix->info->imdio_pci_bar);
+	felix->switch_base = pci_resource_start(pdev, VSC9959_SWITCH_PCI_BAR);
+	felix->imdio_base = pci_resource_start(pdev, VSC9959_IMDIO_PCI_BAR);
 
 	pci_set_master(pdev);
 
-- 
2.25.1

