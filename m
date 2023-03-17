Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946A76BF124
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCQSyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjCQSyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:54:43 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2108.outbound.protection.outlook.com [40.107.243.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9929510EC;
        Fri, 17 Mar 2023 11:54:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAOhMrmooQTIfYqwxfp2O7MdI5qR8LSNp12QtnKgO+ET4u/68I/ejsy/jVBk3QpOGM/ol8qzmU42YtbRm8Dpn7FUULsZ1BnUyraC72LnbdExzYXqQR1WUKKqXIBD+7qVQG2aXzjo3uoEhn7VtkS3H4rxZpOlUejZff3h9MgHmCZCVLey0wkLpXF2BsS95tT9IRo+i7/5yxiQy+N2ZKao+ydrX4AThDjUXRwEKvRjCuZnXUj/FlTwhmLzwlpU/MiMcCD58yxYq/LsyVjiTl/+RJU1hC309DetbZM8irsKCy3ZghGi+fnPPkiyRfahdui6enldPbtXyVaZ8s+k1UjMDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9XmS4W4XcXKLTaWLZDu9UZjtQ1auKAN3lUz+O+ZHaW0=;
 b=KEQpJCfTGI+RGgA58APZ4fLAK+nHZsUkCR1tpDT2H3Rmzq35rvHgumxh40e8not/632qgwVBIdX5QqBD1hCt3sv29UtRS0fsNDqyAtrsCS4UitMDlYLMOYlT7DLIqz8UwzEY+b23AoIGCXVvul0x12yx+5beohQJkHg9RxoJHSXSQGwhLuh3nN4/ZoDiysFf6fzDHWu+SZmOQXq2Vq4rrjlfXv1E4XG21VLhQKwcx8CfBmHgUB+mjFiHNGyciPj58XpaVLeHl2bvoREC2m9BfcHwZt+viJinY9Bt1i04mlCw/jC3ZkxZKJ9E0Pxv/E1NhCd0w962hOUaw8+5XPVRiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XmS4W4XcXKLTaWLZDu9UZjtQ1auKAN3lUz+O+ZHaW0=;
 b=wSZR5Z0ToCL9bh5TF+/ZRU1Y+58071EUk4zl9hf7sm/krh3bG9N2yiG1TP8BHLcbUnSK7BiT2UHW3Np0uu9VTNQfQaCwxHXEAC9Ql5vWP6pMplP4V/pVbCZG9htAZIUjSGG4p/Cl2p9DBIfHy9LHDn43ty7ziUb+sGa9rqweyD8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN0PR10MB5959.namprd10.prod.outlook.com
 (2603:10b6:208:3cd::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Fri, 17 Mar
 2023 18:54:30 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 18:54:30 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [PATCH v2 net-next 1/9] phy: phy-ocelot-serdes: add ability to be used in a non-syscon configuration
Date:   Fri, 17 Mar 2023 11:54:07 -0700
Message-Id: <20230317185415.2000564-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317185415.2000564-1-colin.foster@in-advantage.com>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|MN0PR10MB5959:EE_
X-MS-Office365-Filtering-Correlation-Id: 459f9084-d41f-477d-e07e-08db27190a04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TtwkO2dk/E2z1C6qXkhY0NrR9opxtcbPBtdYgnMk+aktuHDAySgDe7mkGMbo6zNKhnEujQE5x5jS4GcLNnVNWQ0cI6wAc0/8AndzpGtlykAbAIfgTwKLw+QWJ9fPKi9qSy09+FR074FubLratdfnctnDZcmBuvCEAk2lmV3pAhvwxF9Z/3eR5IfHHBeZ9dMshFkVZCRuBElgi3fEhIbqnDkC7olAOIpBRCwnv2S610G6/yRhuClXsibn/vlJkuzCWT5Dls/UisO8qd1E5KG2FypIF6K7hzTdQuABeL94C528DvgvuBtP5qwWopoabQWBllwF5P57Nl5P03B6rPaAmn0xH/5fIwcoN6TXEI5IZ+RokKZDj7FznhAxONsbUY/WDAF2wHJX3aMZzu1W8HiKi2OhcUC6AdH6gRGKWMwUU/pmFbZ2kf1hAOVwKSrcjo9Vl0zuCoGMkPw4AoYmBadTAVPwmsDNeNN2hHe4fxSFH2jFxwWqp/AeEuLp36DJ3Y2h/uKs8/DfZJr4lGg7DlO1hfzXNBi4K2VHRxYd6acsdBR0E/jztDHyCpS9b7iTLSAp/VXNTY+0C6oZDKUed3eSm0cMdbGodxnYfyvdngDGnwjGKJX6eyp+lGp362U2jLnz2pJXMg9oK4QLPYJuISTr/9GAWgInR9A4//VORF9Kxej2XAJfdZusmTt2iutWGzJiBWCK1OfvhlmfV11GeOcBmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(376002)(39830400003)(136003)(366004)(451199018)(8676002)(86362001)(5660300002)(44832011)(7416002)(478600001)(66946007)(66556008)(2616005)(52116002)(186003)(38350700002)(6486002)(6666004)(2906002)(6512007)(1076003)(6506007)(26005)(36756003)(66476007)(38100700002)(316002)(41300700001)(54906003)(8936002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KL41bgeV0Qse0KWxPaYRQHZNJXKORXa2OuiM8GA03uufeRwuRCBZHmMuPMiS?=
 =?us-ascii?Q?pOeghW10dhEUaBU1p6GJg6D01pDcUvK7QV8mQVEfikxHtgAxWVrpr4Wn3Nhu?=
 =?us-ascii?Q?AISIyMuX+IkzYVCOWoQXamvMAkNl1lDqXwRdotpxfhJF0V5WDQT6lrTWxYrD?=
 =?us-ascii?Q?gxk12cJcNJok+jBAKAq6iXpKP6dNU2pDT06Z0aKxkCjpWCameBlzZfAlmy9u?=
 =?us-ascii?Q?CaJ/0YwMbCiII7QuiTEiD+0wnaIITnlWi00JzBTF/bFRggxzmCTx35zjk6QS?=
 =?us-ascii?Q?55jDVzw36qgqW5s/G6biVBR4whEhP3VxinCyFtE5Bk/IfzzhLg0vet3DLpF5?=
 =?us-ascii?Q?KAQqY5EluA6uwPOnZuw9fIPi361CcA3tdVe9MgAOphquXPV+jtDTECWkSgSL?=
 =?us-ascii?Q?qB+wfk7g5ETlI9aFjhZxYFp76WttVUyDiCzb/G40tp22h0FL4S04V2MUGD/C?=
 =?us-ascii?Q?xRU2UyB5z9LhMMAXfKWked88toxLRpLcHSwKtoZAExigFGMCk4aE3LFYvd05?=
 =?us-ascii?Q?d/Zwh/4QoyzX4AZ6qKlomzhKsfgB6cl486uT1GbYTaT+OVZi0u+LyGrYkDwP?=
 =?us-ascii?Q?tbgtqXFSyfvdn/2Ki1BK8BLxbExC+AUJ4zO3TtxZzW3fCvmGSna5WNVOT5/n?=
 =?us-ascii?Q?2BqFxjhtzD9mZ0NNnUSFTiZ6FfOdX+0MIessGwz8bd04rXe+Js+SI3f55jZa?=
 =?us-ascii?Q?UecQEOmiwphLZf2GtDh6ybw2jNf3vKK0VdE3unB21RAcnPu4rPZGvnHqWaDo?=
 =?us-ascii?Q?dXySylz2PyL0hnf+YjeDSjPHGBJ03jogxqvtQbJtUa9NUoX+bGRAveWmqP6N?=
 =?us-ascii?Q?9pJh7E5KKguTKGwsh2oPj7j/kY2lHEtvpFXqQxU+RHCUSSACgNViBfrd3/VQ?=
 =?us-ascii?Q?vKAYyACU/D+0RZZj7VtKt03ZUsbRwZ09ODgIXQ3oxuyfVNGOyVLONEG0ZMBO?=
 =?us-ascii?Q?cFoBN4T9ThiR9ZEWW+aObNWulA27hB9dRG5uN7QD+YVHfJgqwEQMc+ULRVRF?=
 =?us-ascii?Q?uLEk6cHEzDH3lsHhEDUv8jTrO7msboRKt3gUddGVL3UqGImTmEltHh4WMrsQ?=
 =?us-ascii?Q?MActOI8UBED9g+HT4eX6wIPyZcGy6gile6RKvrxkID53vN1444ccEa2xCI9K?=
 =?us-ascii?Q?QNkIxHR5rIGPJWXUL8tcY9WPJXy5oH4paAyxcK0H1/4CoRN09+8STAENsjwt?=
 =?us-ascii?Q?JBXTekAw7dB2TNPwmy+mFEEYHvQOtnTHN/GE5oVdqQRsuwZ7+m7CpegfeJHk?=
 =?us-ascii?Q?vy/skuQe52T3G42b60VI7mUubu2RX1/ozbLDGB/mSuSepM39ABBGBFcbswC0?=
 =?us-ascii?Q?3z+Etx0ZNQOz1Q55G+UKwcBaVsM3DMApgtEnepcDbofADsNirZiQSrbDfxla?=
 =?us-ascii?Q?Z9sV/ZAPLoOuAUxbaJuVmYTnI06HVEu+SFq0kvXzFvChtnqpDUvw8EiEKrf2?=
 =?us-ascii?Q?WVtychcj23I16kmGVluZ+klBIFw4556gFNtQknbsNS5GMqMGuSALloZRTbTU?=
 =?us-ascii?Q?uPtli43qvHCvzosdwtPL79HMPeXKNxvetyGmcfhnAQGdJo0siDBtSU3jw3xO?=
 =?us-ascii?Q?UCsDJo3TLjfxgFetTV1BWk1ygETgXw2fMiwnII9FPalbolYdLi1JyyEWYOkA?=
 =?us-ascii?Q?X7JVOj7lqm2D+ZPRHWBWQgQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 459f9084-d41f-477d-e07e-08db27190a04
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:54:30.3657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rEXPcjF1HnD03HoxqaRpACb5RWhN4o0Le/Ha58Al8vzftE5RPHyavQKQ57M94wnGmE48elZT0RWiFEUuZiKP1yXB+hjPcNO6OQlvKLWZozs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5959
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phy-ocelot-serdes module has exclusively been used in a syscon setup,
from an internal CPU. The addition of external control of ocelot switches
via an existing MFD implementation means that syscon is no longer the only
interface that phy-ocelot-serdes will see.

In the MFD configuration, an IORESOURCE_REG resource will exist for the
device. Utilize this resource to be able to function in both syscon and
non-syscon configurations.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v1 -> v2
    * No change

---
 drivers/phy/mscc/phy-ocelot-serdes.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/phy/mscc/phy-ocelot-serdes.c b/drivers/phy/mscc/phy-ocelot-serdes.c
index 76f596365176..d9443e865a78 100644
--- a/drivers/phy/mscc/phy-ocelot-serdes.c
+++ b/drivers/phy/mscc/phy-ocelot-serdes.c
@@ -494,6 +494,7 @@ static int serdes_probe(struct platform_device *pdev)
 {
 	struct phy_provider *provider;
 	struct serdes_ctrl *ctrl;
+	struct resource *res;
 	unsigned int i;
 	int ret;
 
@@ -503,6 +504,14 @@ static int serdes_probe(struct platform_device *pdev)
 
 	ctrl->dev = &pdev->dev;
 	ctrl->regs = syscon_node_to_regmap(pdev->dev.parent->of_node);
+	if (IS_ERR(ctrl->regs)) {
+		/* Fall back to using IORESOURCE_REG, if possible */
+		res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+		if (res)
+			ctrl->regs = dev_get_regmap(ctrl->dev->parent,
+						    res->name);
+	}
+
 	if (IS_ERR(ctrl->regs))
 		return PTR_ERR(ctrl->regs);
 
-- 
2.25.1

