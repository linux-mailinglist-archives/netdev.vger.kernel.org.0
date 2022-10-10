Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF6C5FA68F
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 22:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJJUtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 16:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiJJUtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 16:49:20 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2064.outbound.protection.outlook.com [40.107.105.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7059175FED
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 13:49:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtH6cIj+IgTmMj2PkZja1t91PkB3vqqjSaFD3fgtuRaVk6OeTX57CU6wL90ICU7xjdmOOKb2oMvPokBRoHfXG7su4ztav/83EKrnW6vozY2o3eGSX+y09v2evpfhJcSFsR2YRKf0UQJleUaNgWpTF5Bvp80kXPGDSNFlbKpvLi6SpljC1P00TZfA7vu43bO9AZYYZfQ/OhBOXt9XgGNkgSiHCsQMEBVRoXevBC1Zl7eHxsy2eugzys1eXKxp4aLcAKkUp0B3nHNMi8PfD+DMeRyj3/kFvtt+vcd53hxNa8T9+hmyk+Cllh+Usv/sz9K6U+VMY28uIp5znBpqpq187Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXbZEbsRu4n8mowJtawgrefzAQObySrKiO3WI8WyQT4=;
 b=l0J+ms5vh+Mc3iX018RXB6ksuaA1nlJ1mCLhzGC1ZrMlI2X7VAiwZVAvJOdt4WKNsmjBGagTMzc0XYM9A4eap86Owq1honTuFV8uMqAiF+5G8F7NmCwU8a2iqWyXOwWgG34276EzOgR0CG0gVM5a1DiaaugXLK68G6hZleY0Qox8ATiSSpG/p6y7ov7UkooeiVwyBxnQT5IhAVCRE8KnczV0yRgdJWWMpPtzeXy5rXC07KxVS5By+9od9Q30umGVxkrqtt3Xk/fccMq/jbgLD6x0bS5Xq+4DxuXXicBH5UQUxvIU/LU6SN+d+5QT6dZg9NXtKNLvXK1zjo3JjlbkXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXbZEbsRu4n8mowJtawgrefzAQObySrKiO3WI8WyQT4=;
 b=OnBIOPTTO7SuqPd2ekYk4PPuq1pTBTzsUMQoCOSO04FRqA1l0e1LPVglw375cGhtwBz4nWl73wO2eb4IhyuMrTV5brceeemLJhx7W9vtnikF/K/Drj2BU240dlZgmkO1fSCBbSKM8aRCAlxDT6q7IRyCoYHFKepvFfWZ2RIYvMw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB8686.eurprd04.prod.outlook.com (2603:10a6:102:21d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Mon, 10 Oct
 2022 20:49:16 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4d83:404:c74a:7563%5]) with mapi id 15.20.5709.015; Mon, 10 Oct 2022
 20:49:16 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH v4 2/2] net: stmmac: Enable mac_managed_pm phylink config
Date:   Mon, 10 Oct 2022 15:48:27 -0500
Message-Id: <20221010204827.153296-3-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221010204827.153296-1-shenwei.wang@nxp.com>
References: <20221010204827.153296-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0102.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::43) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|PAXPR04MB8686:EE_
X-MS-Office365-Filtering-Correlation-Id: 0053159d-82e4-44db-50a6-08daab00e55d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: spnwz6jt1H4hDi1JohzBxFgDlvtsKEVM5ZsCOn7d6vW1dMUkYiHvE8ipnVPmXgafyw/Eb4+mrqDvnkBM5Oui6TqG9JqSm0wcPl6oGaSANzRO4ltMRkZ9O3aNNHuMq0HSVdoHYzhwKH6DTvRkxoZULS7qw/e/U+EYbV+3i7aEgbLErBN9KH5puOLH6hUEKgUtQnxs/pvm9Wz7be2g++kV4qkzBSNcKy9LMLzrKi0jq6Z0XS1X6MZI8+Ri5+7FdIwSd2XEoc8FHlBTk2hXOSo1bTF4Vd0M0dqDYqmJx5JKjqOyfjx/0HAz8sF5NXyFiBOt2iGtwnE2HiOOBnbFGh+X9RxDZLNypZ1brJIQVgzJAcMkTZUOny+/AV7jgC9W66oWBJKiiHk3ZHzHn5jm3/z/49dM3cuJbRFKCnVMpFXUwytYC7PG5zLcNtGTa7l86A4uM+Zjs/5zTJzhSBXWzkSCbutcuyk0sNh+EkB9M76EjSDRgYJlU603UiSmgNMJBvq6nsKMVosckz2YK7c9omOsSN0/rlY1KYF4RfU+RMWfQzLwA/QfhPMOhJEsv3fJ5Aa9VouBf1cC/ZEYlhn377JhhkIiFNY8ZD57cevhFw/tgItGsZ17AXCzgMSEq11QJo+vE9LQ+jEV4KspBDATDIJfDXNZvtFz/2M/OUkXsIhQXQVAY/sgkU/W1hiB8Yf+lPm/LAIIExgEwt4Kmu8htoO/WCxdwL5QxMvjAqTCe0KuDDCJM0NxqMhKxwjpamGyhnjryCo/XsHlSuI0svQJE9UlHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(451199015)(66476007)(36756003)(38100700002)(66556008)(38350700002)(4326008)(66946007)(316002)(86362001)(8676002)(54906003)(2906002)(7416002)(6512007)(41300700001)(44832011)(4744005)(5660300002)(8936002)(110136005)(186003)(83380400001)(1076003)(6486002)(2616005)(6666004)(478600001)(55236004)(26005)(52116002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lkjJEVMqMfxI2qeIrpx6lW+TCrNh1pFEnxvfa+frHJvPjDx7tEFS9Va48WIX?=
 =?us-ascii?Q?YAwyRWJZeBTUKLIZH2nwww3BATahWcBKK47OPDXiZf3mdUpsQgn/97l2N6Mo?=
 =?us-ascii?Q?QEz4xjqS9xpa/OT7Lx4xdTh3wD7tO/ymmZ4K8qzkw7oL0g34QlVJdjgYrasp?=
 =?us-ascii?Q?nKei1U9cxMYVkdWZleEdc5k7B9xiRDNScc+e4E7KA761d98CyDMNdY7YemyQ?=
 =?us-ascii?Q?lO6nPR9eTUIQBjodScqx8k/dxRkfB3TPsHBzW2Uwv3QfHxFDjLLBTEv5KjH3?=
 =?us-ascii?Q?LbHa5qhcgnQ098zD2w/OvGOIHokVXEkb+UsaKTBYQLzeT6DT7/tNPGnzRmv2?=
 =?us-ascii?Q?+pBUnR7jWvK3OuoN/v91HhjUnW5WhpM87inDeqP4WNDX6+1d3SvJHHRFNKnV?=
 =?us-ascii?Q?kzfFsRfHHCF71AO6enGmT9KdcGH+fHJkjSj9qt2YwCPFD5T7QAfwYvynlB2Q?=
 =?us-ascii?Q?ehLbKziisJm1Ue0sdGsC6pzcd2NfRp9sYAwzHNWaSb5uDzb6jd5k4FPp2jSy?=
 =?us-ascii?Q?ktt0wlWtW60rAxww6Ls/1pJ5g4Qga5AObfXheXrzGTUePemvrEx7PgHwRhT6?=
 =?us-ascii?Q?Wn0um6vvZD4obEhY0f5q/ZEtFcNMncvJYaruNKmUcDwlcAam4kAnckw6SlOf?=
 =?us-ascii?Q?tF5Uz1S2nKNLCcdGGtzXHs8S3vLKBGh7A8gLpAaXby6BnqntkMQrH2gffabo?=
 =?us-ascii?Q?F/u9WHEXuv7s883K3ZYDMl4dXhCgjAPIlGUoqjwf1o/E6qmblJLZyAEHRgzT?=
 =?us-ascii?Q?0Elm6D6N1wOdWLM72IiNNSxuHUmCbQ7Gb29xggQERxyxQU0YhER8V8/lxQLN?=
 =?us-ascii?Q?qG7fhJVsYvYsGwfqpX9ga1EgJ1vcWkctkmzVm9qzqOmNkPJ/g/LjZ/TfayNE?=
 =?us-ascii?Q?7nhjS0fDWKB0xpvNwng2EJaEzjd3/O+A2yCD1IRpkxE2ubjstkUWXwcKoHGQ?=
 =?us-ascii?Q?b9vs1liepV6VMxounpGLmQhwDuVapKeHrGRxHwnAgTDA0h7kDiDUbDcMA5gy?=
 =?us-ascii?Q?4aVcfLh0VtmgwxiSYfA5IEoE8PO0IEhkkjvEOR/tTIaDsQPfpadiNTM4AXN3?=
 =?us-ascii?Q?8eDzAhnSB0c2YO6IVo4d+KMQ76ovmdqSb61XdHw65i8/JrV7DbKuVIpMFU6+?=
 =?us-ascii?Q?LNtHzRTVw9WbiL3ErzWvXx35E2cwUEgOufaoJPaMUL4n2giQsTOlI1VIiMud?=
 =?us-ascii?Q?jXtQgufJl9Qn5mtoCN3+DwY88YNUX5MMuMBEaeyVicqImmPC71cb7sSabFJJ?=
 =?us-ascii?Q?d26N2I/C38sBfIC8k/bwoWhU1xvT+5vSBN/ME5zW2xj1uIcpXN5usIjhmuT0?=
 =?us-ascii?Q?ENZ6wxk81dO2mEBEiu3x6bWQkaJOTzRqLYtoVlHyhL14yXcb07m2crn66oNH?=
 =?us-ascii?Q?4aJ5OUHYH6WI9iYK64qKYxXlyc9PsMtt1BgwSmguMf/pz64J0/GVGwMH1Eco?=
 =?us-ascii?Q?ehkM7kEiNc6kJyn3557ZbX3t6Dr0Kgy0ePjjF8PogpgzXc06hoWig7ntmVlZ?=
 =?us-ascii?Q?OuWHTkcQ1SjXzXmED4P+Y+TYYFmhAGQfTn9y+BXmb/Iabu+MpvvOPjet6Wrg?=
 =?us-ascii?Q?gma2Z1qNKjZRQDFwv4FiNM7gWKmg7KOU+JDxX087?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0053159d-82e4-44db-50a6-08daab00e55d
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2022 20:49:16.3575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FuVkSyUIaijJlou//BhcDzLw7PxTNs7yXQHxdzpjoOIbyyLpI2UYSZDzrhsAcVjAROppjddi7lm/574l6Ry+5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8686
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable the mac_managed_pm configuration in the phylink_config
structure to avoid the kernel warning during system resume.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8418e795cc21..537e8e61bb97 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1214,6 +1214,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 	if (priv->plat->tx_queues_to_use > 1)
 		priv->phylink_config.mac_capabilities &=
 			~(MAC_10HD | MAC_100HD | MAC_1000HD);
+	priv->phylink_config.mac_managed_pm = true;
 
 	phylink = phylink_create(&priv->phylink_config, fwnode,
 				 mode, &stmmac_phylink_mac_ops);
-- 
2.34.1

