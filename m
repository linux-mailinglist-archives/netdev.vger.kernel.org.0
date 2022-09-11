Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944965B510C
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 22:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiIKUDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 16:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiIKUDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 16:03:24 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2121.outbound.protection.outlook.com [40.107.243.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCBA27FD5;
        Sun, 11 Sep 2022 13:03:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHjdnkvsAWU4bpNi5X8jfDUgpN1v5JdlDYiPVZdp+mWjvYr6El5Z2MwMEJ18AaAYkcmtBhd/L0jlwXIvIOD27ocnizZNfHZCYNsyTxrJa3U7kILiMJTT3EVTZxdMY71RV1nEI/Uwr1JX4wwVZanLGXwoAfO3h4t6vzUZPkAAYPmWwcO5xnD9Hum9Ok9p/kCori33ZpiycHXd5L8hSQIJl4YvT2RSrfQ0RCap0fdWmYfB75f8St50jCgIAEQurtgIg1mcStENNJhsHwdOoHkwxPcq0XiSgYqxlLIHpR9BHbp66HBj3qQlmRb9LX0QiG+2c7S80wd3foplEKi6e+zT+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HViFjZUYBhJdDRqMdRSOv+hUz8MatZx/Gql5ZewmlA=;
 b=n4I+jDpGazWf58xiC3awTpe14m/u1nFeIdGIZtjKp9TgY/y64cxYpwkG5gCyPP4JhLHdOy05QYv7zxO9NHucrt8pnV7+sa2/4PXTgwGrsP7EBHXOq3Fwdb+Yl13+5a6wylday24ePEeBDKAH07BGPAyxPhb8eQdwlSnrlyJupd8rlCdJ8B2aP4Bf6xKAjoRAnSuAtAvZnVBugyYhxT+0hsiSbLQsNUr/VMLFpAUij1vhcf2/JYbohkd2VjMH22VoBinE4NMU0y9W+lJef2U42QiP8U5xPXNgQt2kOTRM959Qfk79GKGPz/5CsnhFwFgYdzarta5oEhz2g2wTZPJ1uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HViFjZUYBhJdDRqMdRSOv+hUz8MatZx/Gql5ZewmlA=;
 b=QFEDnM3318yt5kczdQQVKwPSxRz6OEM9MfF3ULP6INARgkcCa/htSW+L7k1FcLOK+swNHnThPb4hGPw0GmPKniLR/SbwNqsDBbFA7lYCooYZZqdHkrd4eILbcHYQUq5HwRo6h/VY5Z0QiW1DIb2lPKHZJdYgzWAPw4OXvHH73CM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB5335.namprd10.prod.outlook.com
 (2603:10b6:408:127::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Sun, 11 Sep
 2022 20:02:58 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Sun, 11 Sep 2022
 20:02:58 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 5/8] net: dsa: felix: add configurable device quirks
Date:   Sun, 11 Sep 2022 13:02:41 -0700
Message-Id: <20220911200244.549029-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220911200244.549029-1-colin.foster@in-advantage.com>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0318.namprd03.prod.outlook.com
 (2603:10b6:303:dd::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 771bf3a1-1db8-446c-b84d-08da94309ec1
X-MS-TrafficTypeDiagnostic: BN0PR10MB5335:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: REJQzG+N8flTZvNvLm80Jx6OBH2O+Y5fXB4d79IQ9Emc71nWNFmYt8gAAWqMD27ZBdfYSXmh9i1kMs/66QyqqUJQmScAzT3RyNjXzXN5WuH8k3EZFOW8GyCpX+g+tUg0PtOrcaTzujydis+PAkc9GOH71Z90FNaaEqtERxpgUKPC5w+RFEWwVJPwQQdFutKLhAZjhcpUK+9TQNyvxTJVcNISsiVE3xKgWnT4uX/Pn+tiC4eNlzZhfn8Or/kCEm84QW0oH5Wa9Cwy86+tGu4TuBJm5X9V/nnpdhHsl5ybZMnJ4xHN81+/FEFiK4W914F5AoC3DteN3uhVTZz/PNUqZQa6WIQyyWGf4Qc2mnuEX+ezclEjmKjn5AweFq8ntOGrJoE/NsDA384qY9HQ8UpJ7ksebd1m3aIIX3XBJnCEl2RntuV7t27N1UiOLrkAVxaSf4EIUSrD6cHj7lbGDDoQ8h9eQcA2YZYWkH8NTsqG/7hL8wnaDjdWxII1y7g1FPwWmxC3N/qztliHR5oCIRVFKGSqlImgqfQZ68pRY0M9vfn36iuB5RXxnnITZ3kN5YgjaLwmVWq3zB7lTofTtYhCjtvjjAFVFMhezd/ZOyr8CQ2kPHEKYMNvgPV8oWl28aooMDdKZloK7kIx1ArjY02d6s495UEWdBaDrY8GACsmzupEICtj8BDta8TUSihmBZco2KOnZgFOeYUpCJlDnkJBHgxZYjPWNA0OYmoaJdd+4cjAjPefW9bfHxHoVdY9kVgt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(39830400003)(376002)(346002)(38350700002)(38100700002)(8676002)(4326008)(66946007)(36756003)(86362001)(66556008)(66476007)(2906002)(83380400001)(186003)(2616005)(6512007)(6506007)(1076003)(52116002)(478600001)(6486002)(6666004)(26005)(316002)(54906003)(44832011)(41300700001)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q4+kIZCCsZjQngT2Yz5ZwM1OKObn5lN4HykC1YO90ui6YCCp44Z97vodu+i/?=
 =?us-ascii?Q?NjTyER22RDstLBaH+g2c4BXfBrfydRjAFngpoEVeo8vG4ixlH/qNI7hDBHrr?=
 =?us-ascii?Q?dT70eYSALxMDAkxnPoQDXI5ycNloA7ehfqyM1qkO3/A2Bmu2ctHDRrHXPAkh?=
 =?us-ascii?Q?YciVZCvJr7AqX5WgvRJqHlOsJmmOLHLQtXZuDY9f03UmuvKnAnI+1A3uwT7l?=
 =?us-ascii?Q?u+1zrSEMU5V2FwQRMQnSPlHEL1aviszxDqZrCHCt6jYSdoOsgjS03ilrE8ub?=
 =?us-ascii?Q?oQTNdemllnqOjLjSnPWhejD5nlwxV4h3ha1vQhfPuSd9OFgmpwkRXhAaJE0K?=
 =?us-ascii?Q?mEUwX/MrUHMAZ5sv+B3261+vtdFzP72BiEFlpwIaQvS24zOpLqlf8+xGtwne?=
 =?us-ascii?Q?YIX8rRhlEXL+FCdO6noLFQ6fdv5h2WerJkW76LYprWPT8EpQcfnfsz4V+ZO7?=
 =?us-ascii?Q?C3RMheKb5G6saK4joyAmR+l2awWEeqThb+QGDqR4H4dBLvZqxM7x8v7Fg17O?=
 =?us-ascii?Q?C9XTKeL5bYdbuPQ1bdKyFVF5pWwsaajXxNzdd0Xo0ADVEdjia5UDN2klg4AS?=
 =?us-ascii?Q?WgtJGFZJRrhuwhOcSltrpOfrqKKLyzSodunW8KjEzrCdZQhEgrOhS4qux38T?=
 =?us-ascii?Q?nVJG72NtpW9MzZZWppUmoXphZEYLY70UwJrmqiBvC13hOnGQlrsKN5hXFB22?=
 =?us-ascii?Q?qT5gcuhvKUiLn/MYPol4nW3WwvcjDmFsz5LD+25YEyOgAXMlsQfp3aNC3VAf?=
 =?us-ascii?Q?hzqGFvGZe6Ex5DxWwU9dZQUEeUYWUbu8emW6pjRgzmi96UqjNtUUqx/CZYf3?=
 =?us-ascii?Q?2d8r3J6sPybo8nQtJMDpaQkCyc3OaoCHy2YcapzrB0pbvUkhjvna8Oil/XzA?=
 =?us-ascii?Q?67VvMmFdBJKRqgyO3PnlMvyz57WZOJsgOWJfMZGc7M9AEdjgzALmkXIXg9fU?=
 =?us-ascii?Q?Kgn6MNn5I/ceS2UJIqvrdAtq1qMEUsQpsW2oEN2Hhb4ZsebqjRjIFR0a09tl?=
 =?us-ascii?Q?XzGFPEHGJHkBRALBqMhIzX7vDA5iSZimbk7nzwuP+gsykCg33HaL/I6Ee7l/?=
 =?us-ascii?Q?NLQUgKMeKzlg4gwkSBdINkJSm1dQaswD3qP8c76kgZz6J7FgeV9XLM/CadaJ?=
 =?us-ascii?Q?IRO7qJehymVcow3gLeGhtYACex12/4zOsO7DIaw7/V7PtXM5/5UfIRD5em8t?=
 =?us-ascii?Q?s3zfMFryoCq5SdmVMQZZGNqmFWb3tMqvqPf4qk2pq+UAWlae+4TdLnv9EU3t?=
 =?us-ascii?Q?Y626kPWsG/uOtcVvfjgNFTQ3r4othF4Nz3SEw7tDc7UJtj4X/7vfeMTIN3H9?=
 =?us-ascii?Q?0vVpHjgP1FRqVSy7ix9JzzDnnD+MJfcXY4BtV7yfQ9FRgy6ofo3jxGrbW9xh?=
 =?us-ascii?Q?aK0pA3uC7CLc80K+DKqzOQC8zVKSSISsfa8pkfXVahPwI78jcn6CSi1qHxPm?=
 =?us-ascii?Q?MA+qNxBTJNpHbdqO8enTwER0ll4qPviWLg6p7bxBDV6Ilqn74rxdbxprwxX9?=
 =?us-ascii?Q?29v4UgiXzcbiGPC5WjeCPOu9h9/B4AE5HUCea/ztRzN+eoFRGtnyGyXfeyWr?=
 =?us-ascii?Q?/lZKPWL2qyC4/C5/bAf+aRL0CzOAOWBHBu05blwVv+fk+41GMNUq/NpsZTL/?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 771bf3a1-1db8-446c-b84d-08da94309ec1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 20:02:57.0589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgJStR4GAHNHlQwXszcFvTq7i/CW6nBrmr9ptZVmeCsKWFyms4Ifh9tx6dCMhajfaHzngTNjBm5d1XGQxI4+onFNPRFVgTcWCV23X8tFyaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5335
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The define FELIX_MAC_QUIRKS was used directly in the felix.c shared driver.
Other devices (VSC7512 for example) don't require the same quirks, so they
need to be configured on a per-device basis.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v1 from previous RFC:
    * No changes

---
 drivers/net/dsa/ocelot/felix.c           | 7 +++++--
 drivers/net/dsa/ocelot/felix.h           | 1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index c73ef5f7aa64..95a5c5d0815c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -990,9 +990,12 @@ static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 					phy_interface_t interface)
 {
 	struct ocelot *ocelot = ds->priv;
+	struct felix *felix;
+
+	felix = ocelot_to_felix(ocelot);
 
 	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
-				     FELIX_MAC_QUIRKS);
+				     felix->info->quirks);
 }
 
 static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -1007,7 +1010,7 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 
 	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
 				   interface, speed, duplex, tx_pause, rx_pause,
-				   FELIX_MAC_QUIRKS);
+				   felix->info->quirks);
 
 	if (felix->info->port_sched_speed_set)
 		felix->info->port_sched_speed_set(ocelot, port, speed);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index deb8dde1fc19..12a1c03bfeb8 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -33,6 +33,7 @@ struct felix_info {
 	u16				vcap_pol_base2;
 	u16				vcap_pol_max2;
 	const struct ptp_clock_info	*ptp_caps;
+	unsigned long			quirks;
 
 	/* Some Ocelot switches are integrated into the SoC without the
 	 * extraction IRQ line connected to the ARM GIC. By enabling this
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 459288d6222c..4adb109c2e77 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2605,6 +2605,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9959_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 3ce1cd1a8d4a..ba71e5fa5921 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1071,6 +1071,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap_pol_max		= VSC9953_VCAP_POLICER_MAX,
 	.vcap_pol_base2		= VSC9953_VCAP_POLICER_BASE2,
 	.vcap_pol_max2		= VSC9953_VCAP_POLICER_MAX2,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9953_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
-- 
2.25.1

