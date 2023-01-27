Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83EA967EE44
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjA0ThN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjA0Tg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:36:57 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2106.outbound.protection.outlook.com [40.107.93.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED0682432;
        Fri, 27 Jan 2023 11:36:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jH19qLRaXb1gmchbHbZhCiuitNmkyOMDqGGfnnTen9PPe8k7FtlsOQUhwhyNyu2ySo0r9AxmGL7Q1bcrn+g4JeT6foW+Xjyd9iomeVmu5RG8qLlSdUX98Xg0hMb5CJB/6SGnaFCSzv0dTyH7LJ4JbO9O3/cLfBI7vihDeCDeuqeHcm6fkjmfMpNAbj6+GZy6HwgznTsUfYmfUEi6XqN9AYbpeyYaTL1BiEIvGvpq3X+E4StoEJnOESh469O6PhRGewBwmI59cVySttKTHy8/PZdFifXK+AGG0UEBRlm9WBI33ZmnM5ytpxYFAz5LaDvZ7DczlxzR7FuTjitwF4LAug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b3dhKwI+miiCdpD4QbyMsSUW0Fl3ZcaQv9YGDa1D0ew=;
 b=mZ4Jl1jXJOlnzdDfcKsMukB3P2nhmYYuoa17o5eUJzhpwO82E4ZEs0gL4ijuzixG/mUtWaCi4tzW6DoIiB/i/No5IZ+5lOPrjVejtNQvzp+gFjguVu+D1KuEsOotb5HQvWJzEycKSyoIIRhGUl+K+ZHvliUi2y4s3ES6azhqp/Bc0AG+n3rzbLO6+wojwFvKhu0R5y/VDBGBqQhBHSneVOOL6DeUdtUe9arTBd6inzFrnWHRkon3LaNavse7cqnAS1T37QCWz6S2NZsRZ9btlWTTNSGmiIXX9sdO1MBYwZoouroP2zG3+6nnvbzNon9s5zJrdPny0mqjii6n2tyLTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b3dhKwI+miiCdpD4QbyMsSUW0Fl3ZcaQv9YGDa1D0ew=;
 b=F5FSzmB98ZGOQraK6nz8kVWteDzHh8piunqs6OOdIK1vlhuWQTNJh8Ib420W5njWLQSEaPgBvH0WL0Uw1Rj/J7NjQHpMfl+OWvLTnWK8GCdN7fBkG/R5L9+kiHQlwJRTm8BhLLywYCtqN5yfIIuYrgALDclqfJibWxGDHmbEO9g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4636.namprd10.prod.outlook.com (2603:10b6:806:11e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.13; Fri, 27 Jan
 2023 19:36:21 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::221:4186:6ea3:9097%7]) with mapi id 15.20.6064.010; Fri, 27 Jan 2023
 19:36:21 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v5 net-next 06/13] net: dsa: felix: add configurable device quirks
Date:   Fri, 27 Jan 2023 11:35:52 -0800
Message-Id: <20230127193559.1001051-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230127193559.1001051-1-colin.foster@in-advantage.com>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::24) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4636:EE_
X-MS-Office365-Filtering-Correlation-Id: 239e9969-fb3a-4783-3705-08db009dc4d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tnFQQNA0nyur0Iw9JvnHG3Kzj0MeseVRcgAFQqf7wIHjfqAKnWCvbuQP6hy/SOMdsmtc5oshJrL0FFqWV3LoMFIb5A9a0XggIQR7KLPTfyjEujKZ4PRgPqGe+uvjlXTX8DQXojBhVz8JCYj0PVLKsOXjaaQlWZz9PAquVRXnxdLea06abh3T+vCCoxEDqv7lRqx/1oVT5khNTRIAno9QMoRpbBQJzpHx6L9DvCTBKyUspq4MxIQr3ItCAWX0yoS22fuuQDJokDZlNatFQeiMKPbdHx9ukvORmXw37bDCZgieZ7hRfJX0khNm1BgowyM3WAri+xXOOXtfc9QKTnZ6y+xsYuPYHzBXhRhWJnjV1sk7+QYLJNoM7uPUovkGo7BZLxeM9wHy+8UaIdFC4QdgT+pGzKmz+whfaT72rmCL1q3wz663eUJZvlFuIdHRYuwv2fN5kThQUtId0axJxdWT8th4RkycwZnaSBh+6QCjYQ4OZ3Qqg6PH/LkBShNdGar+w8wJrgibk6sZ5315aftihpe3lu4brVMooCnto4sX3ZmYjYGIzbNiOrT/DMCs/R4prCoMCZztUcI/Tk/8hCEaw7rtoIX9KmThmT+Zm8vqWV4fzHFAHsQ67xGJwQr1xWHCLSxLv6geIfGQ8Q33ryXvTp5dfAHpHTVsyVWi5xM1X8HwXThVj7lYoHBJTIGZ3uqOX8Ucy8ApkuKorveF79dQeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39830400003)(136003)(396003)(346002)(366004)(451199018)(36756003)(86362001)(2906002)(2616005)(6512007)(26005)(186003)(66946007)(66556008)(8676002)(4326008)(66476007)(52116002)(316002)(54906003)(6666004)(1076003)(6506007)(6486002)(478600001)(38350700002)(38100700002)(5660300002)(44832011)(41300700001)(7416002)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z9qcycOI1zEkx4fNVc9bsl4Hp4AECm/rRktAeZws6oLCd/HvEdlxzPNlWds0?=
 =?us-ascii?Q?w2lKoi6pVHhs/Ej6nejM4WrYYGzCYprQbYF0MggkQJNQoox0nhEXwqAswNN+?=
 =?us-ascii?Q?IHhd79dwIF0DjtN/Vfv3R/DGr7nfhtD1jaXGSW2FKAlyGnPf11ncHjO8O2rv?=
 =?us-ascii?Q?0JJU3lb6xI1nIIvdUDzXR4kWfCUL//+L88D+qA9FHSeM417rnwC7EDaS82TP?=
 =?us-ascii?Q?gEQukBK2Ky8rc8xj/qkoYqkL78zDMOkmD/TJhEwIEwc+S/F+PsiN9REWWeDd?=
 =?us-ascii?Q?BefxNEI028/6E9kY7noqji+Qet+dRdYVi0NIhy/Isaqo8oAm8uuwYdTx3/9r?=
 =?us-ascii?Q?3WvaHVQFD1+1FDAxCgDRCJ57tt7BukcPM/YlocsobaxwTZuT1x7akrVhKJ4q?=
 =?us-ascii?Q?bo6EGSXcUl8BRNjmj+ZcodS3AWZdkuXHoOAwxuZnEJBQhJBGU4x5/i++WheF?=
 =?us-ascii?Q?cAtGbPPNjJR/nxGe908ojnNs12WeszxG6YCBQaKeBpGzfAh9nxdhU1GQAHrD?=
 =?us-ascii?Q?gBrNvV+3a/Oi6cmuZCjkFXfc5JOYHlB8Ok0uTvYKTYQVJVTA8Eb8W2d+Yfkb?=
 =?us-ascii?Q?qTvq7bya5aQSCILpkBsVKC+RAUUAxr2ZeXixHoDnpaOK1nwRJL0bhe5WJSyM?=
 =?us-ascii?Q?VGK6GWgiPWCz2KD2ZH1AyWlF/lIQZrQ5KsA0yke7KCUwbOI8ogk4nPZlWm/u?=
 =?us-ascii?Q?da89K3EJmNRFkbLmDmUw3Vw+3RUBi8e7mEY0qUjUz7Gus1qiUFKRysnCMq6o?=
 =?us-ascii?Q?AdqX0ffalpjGjE0A3luAmiU6EyzdIyGHNeGMGrcanSoAriXnAF+day67hnyZ?=
 =?us-ascii?Q?lcS64bwCRE0q2cGHXjQv+3fLGJEe6Y5psuoa9I0mUW+doHjc6RUjxSZ57rXa?=
 =?us-ascii?Q?cNYYDKOEFyMR0p63E+QJ4+P6j4EgrWhSZfvHz7XO12w+uMyLJXRjBVjbTUhv?=
 =?us-ascii?Q?IBrTvPuQozBn6ulAXxeAQyp+m+76hdX/r+JgDC4rPANPzbcqOOyb7bEQZJqh?=
 =?us-ascii?Q?RmEC+Ivujq41Voin7EHC78XRJcpZ0qrpcHWnrbhzm7QM4JI1Uw466L174CgK?=
 =?us-ascii?Q?dVAutDKoata/HCaHccxBR4lpQJniYvNdk9d/K8Ngc491EghOQAvdgM1fGuGQ?=
 =?us-ascii?Q?1BS3ZKZA4RhzdbjABQffnqP4WrVyZq19So1ZhobYvqhIpGZBQ0MXxcNOXwbG?=
 =?us-ascii?Q?NhhNiNNaE8TXVp01kNnYEVCombG5n2zn7D/O4pUSyjR9HTOpy8GdwZyc8fWq?=
 =?us-ascii?Q?/N8vbriyjvBw/YUjJwd9iV5IO5XkvPKKK2nvAnze4DP8A1hveHJqMtE/oMAh?=
 =?us-ascii?Q?xETnOhzfRfbTthvVPdbJncJvrP3vDvQ3t8X5weoTrKTPNHEiGTs11FR7Ub5P?=
 =?us-ascii?Q?rnORTqxO1RbnHuqB/0X0DshEnSEWtVSibiTZWs57baUxjdhlHMHctgSnpGk0?=
 =?us-ascii?Q?qHw07KcT+8qIQE90ia4p1g1SZC5+CS+kEmI5XRYh5wrdTihMVWWlZ0b860bk?=
 =?us-ascii?Q?JMrXBk+76dQ7bznjK2tX32bIDOuVfc9aosR0PdAJq7R924E8wCPUoucWH/Zr?=
 =?us-ascii?Q?xK+Q/cj7dZ6yo8jDow9BzxdkUv1x9ApKLJI+RIhLFMO3EcLKVI7vWhHuI7Qw?=
 =?us-ascii?Q?WWzwJbt2EV0p0xohEnl0zGU=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 239e9969-fb3a-4783-3705-08db009dc4d4
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 19:36:21.6727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z4W8IBy+WaflT1t6VdPehmBkeGJ5WLdxqfpRn/04IkWu53kyTZdNBD0qK8wRworhEBitblXZh9kmWCHDB+cnq45abkEpccE6vJnnb/5ssCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4636
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

v2-v5
    * No changes

v1 from previous RFC:
    * No changes

---
 drivers/net/dsa/ocelot/felix.c           | 7 +++++--
 drivers/net/dsa/ocelot/felix.h           | 1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f57b4095b793..462a1a683996 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1075,9 +1075,12 @@ static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
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
@@ -1092,7 +1095,7 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 
 	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
 				   interface, speed, duplex, tx_pause, rx_pause,
-				   FELIX_MAC_QUIRKS);
+				   felix->info->quirks);
 
 	if (felix->info->port_sched_speed_set)
 		felix->info->port_sched_speed_set(ocelot, port, speed);
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index be22d6ccd7c8..9e1ae1dde0d9 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -36,6 +36,7 @@ struct felix_info {
 	u16				vcap_pol_base2;
 	u16				vcap_pol_max2;
 	const struct ptp_clock_info	*ptp_caps;
+	unsigned long			quirks;
 
 	/* Some Ocelot switches are integrated into the SoC without the
 	 * extraction IRQ line connected to the ARM GIC. By enabling this
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 43dc8ed4854d..354aa3dbfde7 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2593,6 +2593,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9959_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 88ed3a2e487a..287b64b788db 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -971,6 +971,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.vcap_pol_max		= VSC9953_VCAP_POLICER_MAX,
 	.vcap_pol_base2		= VSC9953_VCAP_POLICER_BASE2,
 	.vcap_pol_max2		= VSC9953_VCAP_POLICER_MAX2,
+	.quirks			= FELIX_MAC_QUIRKS,
 	.num_mact_rows		= 2048,
 	.num_ports		= VSC9953_NUM_PORTS,
 	.num_tx_queues		= OCELOT_NUM_TC,
-- 
2.25.1

