Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AB63598B7
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 11:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhDIJIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 05:08:05 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:40854
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230181AbhDIJIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 05:08:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DzLRDogMHy+fgIicAfM5/V34L3s8+jmPRQW0/r1AbYaVgaIkzHe9Q5epqtCKklBKvSAwsLWG8vjxnh1pecfv9sjBxp+E0lR3ieW96UdMsbvZBb3Ew3Ahkj0EwbUg1jT9MbL+zQd/az87bycwrhSjCQm6Vpi9ljiPatE3u/aVMB9F5eF8teYlyKXUsY7a1x+eJSmFTL+WP9iFBkZ9o8bbEJgqnIhBVs+Hmt39jBteTc2d7G9QzO3TLgYBPEai+EUvc19BbVIaWuuyzNmVhMcXhKZhlAK8iWuTc113UgusZHr40jv/6bHpGKUfZ8GkbBSGLOc6Eavrx4gm7hZubpjMRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iB9kddQliaUKAkoLWowI2Km+Ju0958c8++EXuYyz0Y=;
 b=ktREzrNvxKmFyIdNdaJRrK3NjnK/Uplimt2VaehZC91RUcJv+2G6qODmyDpT/GdjbiFhknJWsMIT64b68NArZImiOx/sGE/KcQCEsdmHU4pc0rbkDiy1xE+WrqGnXUm7ylbe9o6gWeUKJneZ2xLi9nJtnihK5dI6o/avt+1nWA+VQx/c7ZhVHs3lVJWm9lcK5ZnaIn+tJBMaiFLH2+9fiufwIcML8COoIZ9av70EbulmKq6/GrFKL4q6wNlpClxNsMxDRYp1hKzZZNXRnTgckauYiXCrJelvzVtnOK5234Ypnq2XLwBPIqwS4LQdjin8+qfFMmTHUHbEA8enugYYHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iB9kddQliaUKAkoLWowI2Km+Ju0958c8++EXuYyz0Y=;
 b=S7/23Th/TfepDSrPjPurgsXlaO0lltFYVoFSx1VisIQE/qIDqSZ9Gp0Oufx7NEs8+BJXYoa/htyAQYggbI6DdjI5Vkel4jzNYKNSwvRTAylvLdqaSuBhkm986sHMvao3IB+2bFh5MXlzyovmzG+fB5pfvBrswl4C8j/slVhvKSo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7336.eurprd04.prod.outlook.com (2603:10a6:10:1a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.20; Fri, 9 Apr
 2021 09:07:48 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Fri, 9 Apr 2021
 09:07:48 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        frowand.list@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH net-next 2/3] net: ethernet: add property "nvmem_macaddr_swap" to swap macaddr bytes order
Date:   Fri,  9 Apr 2021 17:07:10 +0800
Message-Id: <20210409090711.27358-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210409090711.27358-1-qiangqing.zhang@nxp.com>
References: <20210409090711.27358-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR02CA0184.apcprd02.prod.outlook.com
 (2603:1096:201:21::20) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR02CA0184.apcprd02.prod.outlook.com (2603:1096:201:21::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Fri, 9 Apr 2021 09:07:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d53f914-1fdd-4061-51af-08d8fb36f234
X-MS-TrafficTypeDiagnostic: DBAPR04MB7336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB73369E412B165A58C6517FA0E6739@DBAPR04MB7336.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GO5fSCTiHMqkEZ/b7BbANPYSrFlw2q/HU2Kpfq8jBL+SqVFIT3OxR7M0nMKHslJDDMNxv0mVFiZFMwma2C9ITx/V0reS2bKQXBv94dWf0/XmviWykFCwEhJ40fon9ILiuqSLbvXb0dj1++B15AV/Ygz1ENQZkUqnjLgkArhiHMTF6HSEXb50AWPbPgvKgNKuxiiArs1UWMHHQKnhAk7t1Z7frZRhd+MfxDUlUvIqdxgJJ9jqQqxxqf/9BJG4mOw7J6KrUEBvMY0P8T5+H9LKiZWspXefmkWX+wVPFCdX3TWPvNohj9BxF8hk3i+aW/d4BaDWFoPaqXvH/z8orYP7WPwYl3XNrLGRAkBFBs/OzVeUVwhN3V0HEHblj93PKxYWfndsEbuFhomdE84V/ghSF7dd6FSd0zMp9ldNrvgyDUOWlcfxy9HG9q7/cQWy9zZPm8kXJbHZavFDodxuraYO6pASet5Rk4iLaNvxv/c9LAkFT92Atidwmxp1+rM8bymblU1vTt6HRefgwYhg34R1r43t01OBmAcLHv/22dxV4ZG5fOEZPm9Cs6waEN6XU6M0XLpY4hGlimQtD45gpZQH75D1OXApcJUet+0ec0CW4reaNcgvsAUiBQps93nQaesNBn2IUipdqXegF+4qh6oodK3tiAtgAuYXWcVI3kF4RYc7VIvwgN5y+ECo16bT/Lfhprm9zzZjzBQTP7Ln9abvKL4NntJi7AnYpai4jQlh2GY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(316002)(36756003)(6506007)(8936002)(8676002)(6486002)(52116002)(6666004)(6512007)(4326008)(956004)(66476007)(38350700001)(66556008)(5660300002)(69590400012)(2616005)(38100700001)(83380400001)(478600001)(7416002)(16526019)(26005)(186003)(2906002)(1076003)(66946007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rqAuksSF7/L+Xm9O/AR8gju+uUNECehuea1ki+UYXzxjwJ2WSawVfo6LofLY?=
 =?us-ascii?Q?aMOFGf2l9Hk9FiEPpc1w4a9gfv/vxdHvjeaNL4G7vFfwIThYO7OiskSU9IU+?=
 =?us-ascii?Q?bmDpH1Zw27rCSUSvoNc4jFkBpw/ZFIue9aZ1XaM4l+Ee7mwOiBrT8F8HTkU1?=
 =?us-ascii?Q?3SjllLJoPuQotY5P4TVtKcCXJ/Uihs0rlUfZWs8oOhGhn3InyZRyD1eok3Vz?=
 =?us-ascii?Q?msVwaiuffyDoW4aIZwl+vVfqDqj87dLAZbMReuQxStjjKKLqUcM1to1XoE59?=
 =?us-ascii?Q?VtvL2UJH36P4LcYrvkF62RoTO2ywI14jB2eSVIf5sliRfCAZE5qK1LjHE995?=
 =?us-ascii?Q?VjFYsm2VBktw9R4WAf/i4wEjpAoidOXNEYNmiC3djusKCepMsRnoAw3aQ4XP?=
 =?us-ascii?Q?eOwVqV5E55uNOyDMpPD4ONSJxMpU/MeZc7Msa7HtxawR2XJbT3jHfnZf5ROE?=
 =?us-ascii?Q?jm0fHhgrSklMY0CRv24C6qS9TL8LS3FkoYpVaZPM2G2OoSLpF5z72CMY4ftH?=
 =?us-ascii?Q?K7lPDPWahiSmcxIGKj4NQV18CzRTweovZKQWnMzbJKcPDM1KiZ9XS1raIX94?=
 =?us-ascii?Q?ikeYkGfGYxfitWhV4wzAS3hw34re5KwRwPUf898I9UQ4TGzoCxlwOd/p8rU7?=
 =?us-ascii?Q?ccl+FnXzszzF/Q3vps8uPD3yVedIgm7iIJcbkHCxPkv/MYnCc5k7+0ljiUWM?=
 =?us-ascii?Q?1h3DFn2bfzbqTZxq3RQMbD4uFsJfWXx8bbKl5bO2F4acxixqDzrQkV2gej7a?=
 =?us-ascii?Q?YlICqRABonyjQdwgAwEwiAKo07OiaA62FQiNhXKH5ZtN0rqhI8ygyp44PsMS?=
 =?us-ascii?Q?CYq1Zk/uZ6JYU5pQSpqt/Axx8BRCGlWck2q0eJkcA4+Wegw6eMo2jQVif4WX?=
 =?us-ascii?Q?RHj59CgNB418JZjpmbIvUx5bqZC4rT/LP+HZtsa9o5fyAd3/NMz6YhXCG19h?=
 =?us-ascii?Q?gX4roicttqsMKpz5ZFDiDoZKpStfcqA93L13xKjpZqWkMxwNB2hqOXcRhhoz?=
 =?us-ascii?Q?XgnebPMCNpjVLqqO3ohg2d4ARWYIIacyKY6vM9BqVbNbl5sJM6QARrjq1iCZ?=
 =?us-ascii?Q?g90aIn08g/yU089sRQWxML78tQ5Be7EFxKGzHEFDyhdqLEUsafLosS723cVT?=
 =?us-ascii?Q?wr8wXnaUBj/ZwgoWKDPH/R2jwd4UF8e4YIIeqeGziTqlnuw+8fmSDP3yATG/?=
 =?us-ascii?Q?HH9WhOeboWqvjePFB4/KyDriCg5D6cleaHjlbcADYkntnh5lnz6u7q5h3PKX?=
 =?us-ascii?Q?+ZZGLIeBGJ9lI8Z+7IPf0LmF0ViJlFwkYwPkYKVzs55IP5cQlNbQ3T5fMJgc?=
 =?us-ascii?Q?1UCOxTy6+P/kp7Qx8ORp39bu?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d53f914-1fdd-4061-51af-08d8fb36f234
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 09:07:48.4829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CtJyJ6RHQSRsGke3gKBeTcSOBMuEtmVZYHI76jo8Zvt43TWwUyH+hNiTIhXN4Hv40yH3yS9XQB4Cz4iJscxxpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7336
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

ethernet controller driver call .of_get_mac_address() to get
the mac address from devictree tree, if these properties are
not present, then try to read from nvmem.

For example, read MAC address from nvmem:
of_get_mac_address()
	of_get_mac_addr_nvmem()
		nvmem_get_mac_address()

i.MX6x/7D/8MQ/8MM platforms ethernet MAC address read from
nvmem ocotp eFuses, but it requires to swap the six bytes
order.

The patch add optional property "nvmem_macaddr_swap" to swap
macaddr bytes order.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 net/ethernet/eth.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 4106373180c6..11057671a9d6 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -534,8 +534,10 @@ EXPORT_SYMBOL(eth_platform_get_mac_address);
 int nvmem_get_mac_address(struct device *dev, void *addrbuf)
 {
 	struct nvmem_cell *cell;
-	const void *mac;
+	const unsigned char *mac;
+	unsigned char macaddr[ETH_ALEN];
 	size_t len;
+	int i = 0;
 
 	cell = nvmem_cell_get(dev, "mac-address");
 	if (IS_ERR(cell))
@@ -547,14 +549,27 @@ int nvmem_get_mac_address(struct device *dev, void *addrbuf)
 	if (IS_ERR(mac))
 		return PTR_ERR(mac);
 
-	if (len != ETH_ALEN || !is_valid_ether_addr(mac)) {
-		kfree(mac);
-		return -EINVAL;
+	if (len != ETH_ALEN)
+		goto invalid_addr;
+
+	if (dev->of_node &&
+	    of_property_read_bool(dev->of_node, "nvmem_macaddr_swap")) {
+		for (i = 0; i < ETH_ALEN; i++)
+			macaddr[i] = mac[ETH_ALEN - i - 1];
+	} else {
+		ether_addr_copy(macaddr, mac);
 	}
 
-	ether_addr_copy(addrbuf, mac);
+	if (!is_valid_ether_addr(macaddr))
+		goto invalid_addr;
+
+	ether_addr_copy(addrbuf, macaddr);
 	kfree(mac);
 
 	return 0;
+
+invalid_addr:
+	kfree(mac);
+	return -EINVAL;
 }
 EXPORT_SYMBOL(nvmem_get_mac_address);
-- 
2.17.1

