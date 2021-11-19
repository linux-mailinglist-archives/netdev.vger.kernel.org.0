Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC664578EA
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 23:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbhKSWqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 17:46:36 -0500
Received: from mail-co1nam11on2117.outbound.protection.outlook.com ([40.107.220.117]:22881
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234108AbhKSWqb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 17:46:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VE/9Avc/9XKxne1f4hXcE7chcGJkq11JVsm8/pL+82KA8IPKTvamx+LHocGmt7lVY1futEEfbzH34lQiyPYX9jlBOYAoe/vkUEI1iawfn/rrieoAsyM3maG+a8KjyhZYPn9Ta4Gkgm2yaT9SKchiqbxcnSbepvw96bitPYeIXYKTwHnpXYinkAzQjF1gWiogXEooIHRoW6gZJz9AIJpb3PeOjAgVTrxRSZcHHpq9w/gIlUfYHUDrIoMAAWF6fCTszUQzWr+zFj78N3uAWX55y+FNPRTK9zBlkEV41Ok9qtGkQXsHVGXhQUJNptMuvj2jcxGUiJEM9Ng8bjEbwJ4A7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g/3n1kVpGWtmRt10JmKA8tKhdumj6BrhX0aWQ31CSUg=;
 b=kGI96Je/EjOQHBl4bgQGO6Hu7D9j49kXKpX/8n+EthuLikqON7yiUCFd+lZ5lOvxkcYkZRm3gp8j9dEN66w0PkkSIrV27Y9TCiEJNkRMyYrYqBiGFlMxUEjfYADPHPAvGB9radkLugENqqyYrCC7ysDRidD2ytxpGnFY80lWxEJn6zIyr2ztFp2VdOcMPHHhInJNa5vdVaBiTHOX6WJTmQEhweSmhC4RIFTazejQF2G/3IyAjAR5CyBY6COgpK5fG8vg7HZhutVNKQHy8iDNezF4F2J6l2p/PXQ1K8mnK9hGiR0gnwqZvaMrklqgyHHi5ZmaiWAVPjH/yUxfixG5Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g/3n1kVpGWtmRt10JmKA8tKhdumj6BrhX0aWQ31CSUg=;
 b=U6JiFmZBPfvnBj4rPXTsQkbHkboXC4nb7QrcbO+v19UjmMNNbITxGvTTqNWWj7Ub4i5Ja6gzM+F5oDW56hprJ+qjEGiCDmlbvFNU7BHk6i4V8MZMDzYeSGK3VuKP9N2QwNWJmDvFsKefoCEXLY8BJAmatWHhWvyemtCj4vWUV8o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5701.namprd10.prod.outlook.com
 (2603:10b6:303:18b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 22:43:25 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Fri, 19 Nov 2021
 22:43:25 +0000
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
Subject: [PATCH v1 net-next 1/6] net: dsa: ocelot: remove unnecessary pci_bar variables
Date:   Fri, 19 Nov 2021 14:43:08 -0800
Message-Id: <20211119224313.2803941-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119224313.2803941-1-colin.foster@in-advantage.com>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0061.namprd19.prod.outlook.com
 (2603:10b6:300:94::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR19CA0061.namprd19.prod.outlook.com (2603:10b6:300:94::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 22:43:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7b2076d-168a-4367-115a-08d9abadff20
X-MS-TrafficTypeDiagnostic: MW4PR10MB5701:
X-Microsoft-Antispam-PRVS: <MW4PR10MB570123424BD88EAF9EB84F83A49C9@MW4PR10MB5701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WnLWY1VhuANTq5s8GdRdUr0RW6EMVxV6BCpIHYYjiodPTQ942yOTjc3cuahhO5NQxhAUWe9YrHcT8OvX8wL5+rQQBlaAwER1QueKMOynsX6jozBKLZu3p5tHMw0JTK7Wf2VjMsB99a1kw6DK/vrPgnzca7cMtLIXOGipJp4NzGYXiD6c+FaLAII9ifSjjv4QdAU8oOZ6Nq3gdPeC8rG2+oKt/Y6iWHicwtof5udW0glnqTw865J8z4+Dg6JsxXFWAzWZZMK3kFYqilIDXpdGfnrhUpfonWBX5INOB4HB3NBr3/zsY1YjAaAC2xuOwunmQN1X4o8jc1tQbOJKsJeKw+lx1g/tZ9wkLGwULeZzUsB+0c+hG1O2SRcOHfZbhizatV+4/eB7kXkwZbMx1qhz5bgjhQf4cvqyd7L10srMrLwi261Fxk1ZzqPcHR4zA3RxtJAkww4qMD1h59jBUeXigXinA/e32J0RW836ZFc/zYDBro0GIUZbpYje2kADZrXAqWyLIwnDcKyX0GT4poI4XIKDudBxeD5OLRiITaGsjE6o6Rkvtkz00X8DEpH5zMw3pHl0lS0qbU/OE6YxocM2/R1vg6Z65DnrR6m5bEgIKwsHOFn1V1/lnxRepyxP6bOZhfSaSxPWQMINVPLKJtfkXOi2LOb4/Ub7KYes7A7W2rhzToO7loamXPHKc59tX3LYimzGJSpMiIjNO4N7xGNY4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(396003)(136003)(346002)(376002)(316002)(36756003)(44832011)(8936002)(8676002)(6486002)(4326008)(6506007)(508600001)(956004)(2616005)(1076003)(7416002)(6512007)(26005)(86362001)(66476007)(66946007)(66556008)(83380400001)(2906002)(38100700002)(52116002)(38350700002)(186003)(54906003)(5660300002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uN+LIyuF2EtnQC6wW1lNaWkkqaT55mao1ovWWhRQ5jScOe15WJF1AxChZnWO?=
 =?us-ascii?Q?yBiB6Gmr0LM82GgC15e3yG/57lu/YQ+kk7n3czYVfYj3uTi3X2jbZYtfdECx?=
 =?us-ascii?Q?ijubBQ3Or7tg0kpRqFlFIcn1FFobMBlcV78l1QynG6SDzN8qAlQlgC1l0ld2?=
 =?us-ascii?Q?U+xn86H3jFWCsEFnDfvevdZA2aRxrm3wkZ1w4ulrYBysGzMN+fNpSDlmBE6Y?=
 =?us-ascii?Q?oJiRtv5KNTnXdnmsJmkSIGqEXN02MLdTpbrHM/s4sFAkxNObNNKwYr3KWdHY?=
 =?us-ascii?Q?hjz03i3UbZdvBmUqfGmhwqHyBtagGuUfXe42sIWhEIzJgzoGYiAaUNSQi+X4?=
 =?us-ascii?Q?+BMAnFa5HmC9Y0WIoouCEHy54Ii0uR4RN/zW9fuL/9hl8RRfKUg/Ni01L0NZ?=
 =?us-ascii?Q?Uy316t/+aHr4HoMF7PdudtFzfGpbZW9GERMS3D/UYsRPxnNBGbAKtjgPPrGB?=
 =?us-ascii?Q?ZAbnSp1r97n9vZ5gu6R786RTCFYgQn5Udm6tE+cZ57V4wgM+xwAOEkrbLyDH?=
 =?us-ascii?Q?TDKel6/hp7+FafMYs0AQh02EZA6ZQV0cl+NgMaHUILJcpT6t1LbB69v7lpUu?=
 =?us-ascii?Q?g+FZuZEXMpyCSRYzlWGPR+W6iPTltrnVITTgiM9q99fPFflM687FOEzt3rNl?=
 =?us-ascii?Q?CsLRMlHRkRMqrgGKAI+llCerL5m0JRXiFdpWtSHCzzn0L41VVwLGXOMT3kIS?=
 =?us-ascii?Q?/hizcNLQfOm+5tCBc2t004V8evafM8HD1ivFryYCBOOrlJEl0ctoFKwT9KcS?=
 =?us-ascii?Q?wY5HWWJ15+5G2jCaCK6LHH+rz3M+gRceuAIuTtCv+kAAYQvd55+Kvypwv1mD?=
 =?us-ascii?Q?EmZKSan5HWHyYeeabbbXaBx7sXLPw+XbI81REfxn2lGNejhRfTNgH+RAlDhC?=
 =?us-ascii?Q?H6hMyOq5IeghCGgwEuxcS8azwKM6Ph6CkHSYOwp4+KTLtXCreF0Lp2LtGoqh?=
 =?us-ascii?Q?HClgscuc1HJQAzPaekjkPuR/rICQM5JGxPoHoWlvHX67yntf3VjXBYLT647f?=
 =?us-ascii?Q?gA/5eLKePpKcH/1attdYcy8M97MZwrhnfFyGNOJKdiMGC5zMajv+l5G7r0jY?=
 =?us-ascii?Q?DxH1NZyboZ4efyCRQ9H4sHz1j2oaXxc//saHc5W25hqmlYUfmH6LLwE5U1pg?=
 =?us-ascii?Q?O49J0y0E/Nn93mT6lGpW9TPj5mxxP8+JHOZjuI5jMqTCq+4ZHq5/GNWzPhF5?=
 =?us-ascii?Q?FtXPMCfE8KR/cUTNakqiVlklpTIFN+0GFos7No/I+CSUz5LK3rI9uSKAaRjh?=
 =?us-ascii?Q?OIZJnhRBSQNtmhorGZv3iPHfpY4eDW+8klYeoAkFhb+tC7tVUp9XR3PtAcpF?=
 =?us-ascii?Q?bYET9MQUQqn5Dm/e2DMQuldY2xU3I41CGOQ/NpCYzD4G9HMpf1lxOLKKAMzo?=
 =?us-ascii?Q?NQecGCNL24TPLxwRTKzzB8Okut6sk8lAnBNXj/DQI58v34NSK9B0y2WGq9/z?=
 =?us-ascii?Q?auPK9Qk2jT1r+4HrSfea0n2jSXdc5k0BsKU8ir9aoyviamXRVhbXrgfNjJ5N?=
 =?us-ascii?Q?Lv0pr9P+a9HHy5rrbfvai4fQKKhngVTxOE6TC5Z55DxS0mWx6H2ddJcEksCu?=
 =?us-ascii?Q?0Ih6EzkVgvzFWp8NJtlZoiezcUxSGwDE1p96EoQO2KjdTD7Et6HGXLuQcc/0?=
 =?us-ascii?Q?qCNBJtAMd6UPHOlzcAVKwttvatH+M4DxQ0qTPZc5Klrgcw4CC2u7ma4CGX50?=
 =?us-ascii?Q?j/lG0khGlzxQaUSlAtXiQCM4Ecs=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b2076d-168a-4367-115a-08d9abadff20
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 22:43:24.9768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YCwNJUX8xVn5CHTnpA/B7II+Yw+nKGQYce1K3qw/J/KqKiOox2nSRy2kqHR2m2KRs/E6ykUbDodn54CYRqGwWxsYrFDCfrW3T369Wr4ybo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5701
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
index 42ac1952b39a..9a144fd8c2e3 100644
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
@@ -2155,8 +2157,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.num_tx_queues		= OCELOT_NUM_TC,
-	.switch_pci_bar		= 4,
-	.imdio_pci_bar		= 0,
 	.quirk_no_xtr_irq	= true,
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
@@ -2215,10 +2215,8 @@ static int felix_pci_probe(struct pci_dev *pdev,
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

