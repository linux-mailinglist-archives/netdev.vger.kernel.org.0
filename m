Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753EE349D3F
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhCZAFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:05:38 -0400
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:16707 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230050AbhCZAFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 20:05:24 -0400
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12Q03GlF016081;
        Thu, 25 Mar 2021 20:05:21 -0400
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2055.outbound.protection.outlook.com [104.47.61.55])
        by mx0c-0054df01.pphosted.com with ESMTP id 37h14kg2rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 20:05:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QO3Oj6rTFBM4MXcOAgw4Yrp5coWdmQ8rDfg+btOgu2tF/DJZbbUQtawzD66fIQvzu9pCeU/+bzBgF4Ac8bmR0iwDdVK60AaUSfRsuYu2DOj6Ntm+D2EhGLNYQXHEr90ABFe7lhXSdx0ZXkwbiG0fSleZdDQkSY82YYyEVLGZAnKJ5pU+sfpsV79SHZYP+4zDGWRB+E08WWugUAyh6OwSp+FKeXZ2pwYQU11EgEZrlrwqeV4pwS/ir9YRJ+xllAuCpCaM+hAtslZfTdB1EPrJUpqKQOwRV1P/ZIDnqNrVI40EqBJwk7ldkRGp0okMTsuMjWHbSE5fOmfa14j5XmGL0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ayl5I131zrAVlvCSXK9ArD24wZUP7tRUHbCScetDGA=;
 b=Ey32jgbHhhL5onpua3bSkgf5WrkATPTXfvjTlkXeMNO78K3Q6jp+IgQgWQKBbPE3LZCGtIUbAdh15bB5Mf/g+FI5pRUQE/I0a15nSqCqdEpdubDNHa1WOjZzCIT5bEziaamrkn2wElAoam093hIWJEyhd8ssPXpeD81roYp0rKuiD8rLMwwdI9DFOzjA2vFSqBOCg2ULQw/EiED36nCVawpKQPfXh9ODg2Fh2LGrpHg9Hf1Oz+jXO2mSCzKw0N3gTllyg3FEk+qKqk++XuVIvhiFtrYNVaa3bRvIs78p2zNgLAx/EHjrRlhB8m5SDHEK0r1CNynZvGuvGoOXBvMblg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ayl5I131zrAVlvCSXK9ArD24wZUP7tRUHbCScetDGA=;
 b=5syeXu1t5zwVK5YneKkt2Egh0iweP4tbX/Ev5vMlOQAbxy7wIidj51Ui/ZYGZxj8iAmhra2LDEtvdJe4aSp17gQZ5jbcQEb5YqbZuFAjBThEXr2G8rblULauEWnONanpoHphlR+/D4SP2AeDjsefXMiVoPoYTHIB/yFQ2h7xFz8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT2PR01MB4302.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:35::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 26 Mar
 2021 00:05:20 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3955.027; Fri, 26 Mar 2021
 00:05:20 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     davem@davemloft.net, kuba@kernel.org,
        radhey.shyam.pandey@xilinx.com
Cc:     robh@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 2/2] net: axienet: Enable more clocks
Date:   Thu, 25 Mar 2021 18:04:38 -0600
Message-Id: <20210326000438.2292548-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210326000438.2292548-1-robert.hancock@calian.com>
References: <20210326000438.2292548-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DS7PR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::15) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DS7PR03CA0070.namprd03.prod.outlook.com (2603:10b6:5:3bb::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Fri, 26 Mar 2021 00:05:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efc11638-9445-43c3-09ae-08d8efead866
X-MS-TrafficTypeDiagnostic: YT2PR01MB4302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT2PR01MB430218506B32B9AA83AE6EA7EC619@YT2PR01MB4302.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VPD7v1/gPU2U2jpkwDt6goRizAdXpGY5O4+FP7isfSQORjKA3pkMXEnNXs98T6sc8ngezmB0FReMEXj8ozie46jT72qtLskr2BY3JbimFOQNSGiSfr0cQOMAPx57BX5kYoUoqde45sD9csUJUbzRef7JoZwmYzR8z+fuQHfx8ODEhD6BEszAq4WpuylmmJg9GuzAxZ+xI+c4NfhKUru50+t7ozsfKeq1v5uHvKB0w94hn0cQaUYNliw3nPOXhI5nu/fcBxiR188qwkY8U15nc7mF+uq5Wk/71d/COL52m8TeJHPL2SESsl4GgmuqNGhQceMfm2PMs6u8R0friPe9d22m1NbCo4YlqdW78pmJoCjT3sMlvBtLC0fl/JV720ptyiG4wX3bxuF/VWMFG2UcClnVyOjSIJwUWHbb4SyC5Ov6+RaHTyJmMUweBBLjcYiWv9YVTCLi3WO2Fghxafl3IH3YZ7886VNreeq+IYlg6Gd+hEN4cU52EP6qel1Rt7L7vxiR+S1Nhw14+/QEJZwr9IRPhCqfIcU6jCl2pLPgZ4R5oTpOCiY96uhwFF59cc1670E+rw97iuqEQhzOPe6oypTMMG8XbkWynTYBdbTRS36m3GJrHVtYNXLGulA3aBXZTB7eTg7bz6zHMvZXGGqJBISxD2yQQbVneMOkMDwc14XC+ZHTW8F2JAgY+TsqPUNt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39850400004)(396003)(136003)(366004)(6506007)(6666004)(316002)(66946007)(52116002)(107886003)(38100700001)(86362001)(36756003)(1076003)(956004)(6512007)(5660300002)(2906002)(44832011)(186003)(83380400001)(16526019)(69590400012)(2616005)(66556008)(66476007)(8676002)(4326008)(478600001)(26005)(8936002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?D1ifcMZjHGZORXzHb8FGxVJ5vIng0JUDy4n9PawSzHigbVnSpuCg1Zi31hS6?=
 =?us-ascii?Q?ytBgJmtGIoUuIifXSdk2qW2H0DrM/E86NoxkLUqJN1uPB3RUFxOHGTBiFoOy?=
 =?us-ascii?Q?quvJfowf5XNAi5hcR/gfFQdF/+gIyAHtIu3zK/H/HPjx9Q827V4N0pagFdic?=
 =?us-ascii?Q?oyeKuOd21N2d97YsmKI7EPIQ0R5pqpdsqZwO0CvLzfa0PA1r4oAiwRU2Z7LC?=
 =?us-ascii?Q?l+7QxbisXES/CDQ4K7IrFWA8NckeX6yX6xEECfefexq5e08rogBjxV8dt5S5?=
 =?us-ascii?Q?ae3weOlX8kdnQx2tlnWS3FDM2RmJHfBSk3VNtgFDFFkMUBAjgEYfcG7YvuD5?=
 =?us-ascii?Q?Ir5S61YYnYjC/OeGoGTE7jOg0fdTcu0ZawJsK9Z/dWPO7I41StxgkUczmllw?=
 =?us-ascii?Q?8tYhN7r0E0Ncxy4W/Hg42GeH7ak2HtT7o3Tq9U7rkjfsAN0lMwIqCQoYAYjw?=
 =?us-ascii?Q?B1VopU/obajoQgG9TkombA0tL79nmPneUjRd0+PTQqkng1p84C50kEUW+7eb?=
 =?us-ascii?Q?7uV+o8jkhex7SvDp3u2ONZQ5nK7ujUERI5RipgSwLtBG/LmqDp46AxCo3exi?=
 =?us-ascii?Q?KnxCH/0U3Mzr8IwXb9JwbArRCy1qmi8nWlqEZC3Ips+BxLPg8zk/OU/lsp7i?=
 =?us-ascii?Q?ps9QPNsmVyrhYiZKOhVDVvNAcgzO/6DSefkPXLIlgY9SC2XLXFKSmDcUtlqL?=
 =?us-ascii?Q?ncQeErFEBuIXkBPwJxJw/4k43vk+UVO7ghrOljlyaA5g+ApM1OqL+hEk+S02?=
 =?us-ascii?Q?CQFzUvrEfQ+GaZopfuYuoU87gwXf8C61TnGgI0CIuUcwcBvhBKMoH67AJEQX?=
 =?us-ascii?Q?CituWn50eDqFA9cqZDpE0QFtV3fcVwn1+NDzfOW0cfsIqKt+bYM5lR6kgCgS?=
 =?us-ascii?Q?sE4wQa4LIbeYiTH1ZkPCiHmy862v2RHWo+A/biA+GOz+YNc+wjTkcqGhL+sZ?=
 =?us-ascii?Q?UDGrw7kh0L/dJZP7MVaZwYqpeBMFfZkN84m/ZxnW2hXaioT+jPdhz+kiJY5H?=
 =?us-ascii?Q?zBBvdhmEvHCItj4xwQBYwcVhSIYR8yjFGryCySPMYaAp5ipmf9VDGxVRFzI7?=
 =?us-ascii?Q?ii5/Kgz4WICZZ5AO2QRHfcvVhqjCacl+QTpVIphW+IWmlprhFZsm7f9aqsqi?=
 =?us-ascii?Q?YQuKYrH+h8L/aH/xVwS3JGRCaYVmQG4Lc8yzopd5OoBajMzxB+2QDJrYO8jc?=
 =?us-ascii?Q?4JIh8HXyojGrV8GfjoalhhRqm+CYxSvdJTDQNCYZyxQRKDtNzQO1SSQzmeP0?=
 =?us-ascii?Q?pmzcv6gC3Pw9ljibR2Am6CY7P04h4Vxz/lx7RAoUXdAOkwEzBU2R2YAt5Z7S?=
 =?us-ascii?Q?5IvDyc43yU7yh1Y7e2NgleEj?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc11638-9445-43c3-09ae-08d8efead866
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 00:05:20.6285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IgqBVOqZ/8fLxjSh9gbbu0cgWtfUBq+DpdQ0pkWwkFtRts7CXKZ5k4ZrTODcS1+nLGJdpjhxsrHGdLiBBYlLKJs3rZuk5+GfHm7GKbbX1xo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB4302
X-Proofpoint-ORIG-GUID: bs7i6n1QXKSSl5jwHGpxz0EtSNRYa1nU
X-Proofpoint-GUID: bs7i6n1QXKSSl5jwHGpxz0EtSNRYa1nU
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_10:2021-03-25,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 spamscore=0 mlxscore=0 phishscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103250179
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver was only enabling the first clock on the device, regardless
of its name. However, this controller logic can have multiple clocks
which should all be enabled. Add support for enabling additional clocks.
The clock names used are matching those used in the Xilinx version of this
driver as well as the Xilinx device tree generator, except for mgt_clk
which is not present there.

For backward compatibility, if no named clocks are present, the first
clock present is used for determining the MDIO bus clock divider.

Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  8 +++--
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 34 +++++++++++++++----
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c |  4 +--
 3 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 1e966a39967e..708769349f76 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -376,6 +376,8 @@ struct axidma_bd {
 	struct sk_buff *skb;
 } __aligned(XAXIDMA_BD_MINIMUM_ALIGNMENT);
 
+#define XAE_NUM_MISC_CLOCKS 3
+
 /**
  * struct axienet_local - axienet private per device data
  * @ndev:	Pointer for net_device to which it will be attached.
@@ -385,7 +387,8 @@ struct axidma_bd {
  * @phylink_config: phylink configuration settings
  * @pcs_phy:	Reference to PCS/PMA PHY if used
  * @switch_x_sgmii: Whether switchable 1000BaseX/SGMII mode is enabled in the core
- * @clk:	Clock for AXI bus
+ * @axi_clk:	AXI4-Lite bus clock
+ * @misc_clks:	Misc ethernet clocks (AXI4-Stream, Ref, MGT clocks)
  * @mii_bus:	Pointer to MII bus structure
  * @mii_clk_div: MII bus clock divider value
  * @regs_start: Resource start for axienet device addresses
@@ -434,7 +437,8 @@ struct axienet_local {
 
 	bool switch_x_sgmii;
 
-	struct clk *clk;
+	struct clk *axi_clk;
+	struct clk_bulk_data misc_clks[XAE_NUM_MISC_CLOCKS];
 
 	struct mii_bus *mii_bus;
 	u8 mii_clk_div;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 5d677db0aee5..9635101fbb88 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1863,17 +1863,35 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->rx_bd_num = RX_BD_NUM_DEFAULT;
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 
-	lp->clk = devm_clk_get_optional(&pdev->dev, NULL);
-	if (IS_ERR(lp->clk)) {
-		ret = PTR_ERR(lp->clk);
+	lp->axi_clk = devm_clk_get_optional(&pdev->dev, "s_axi_lite_clk");
+	if (!lp->axi_clk) {
+		/* For backward compatibility, if named AXI clock is not present,
+		 * treat the first clock specified as the AXI clock.
+		 */
+		lp->axi_clk = devm_clk_get_optional(&pdev->dev, NULL);
+	}
+	if (IS_ERR(lp->axi_clk)) {
+		ret = PTR_ERR(lp->axi_clk);
 		goto free_netdev;
 	}
-	ret = clk_prepare_enable(lp->clk);
+	ret = clk_prepare_enable(lp->axi_clk);
 	if (ret) {
-		dev_err(&pdev->dev, "Unable to enable clock: %d\n", ret);
+		dev_err(&pdev->dev, "Unable to enable AXI clock: %d\n", ret);
 		goto free_netdev;
 	}
 
+	lp->misc_clks[0].id = "axis_clk";
+	lp->misc_clks[1].id = "ref_clk";
+	lp->misc_clks[2].id = "mgt_clk";
+
+	ret = devm_clk_bulk_get_optional(&pdev->dev, XAE_NUM_MISC_CLOCKS, lp->misc_clks);
+	if (ret)
+		goto cleanup_clk;
+
+	ret = clk_bulk_prepare_enable(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
+	if (ret)
+		goto cleanup_clk;
+
 	/* Map device registers */
 	ethres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	lp->regs = devm_ioremap_resource(&pdev->dev, ethres);
@@ -2109,7 +2127,8 @@ static int axienet_probe(struct platform_device *pdev)
 	of_node_put(lp->phy_node);
 
 cleanup_clk:
-	clk_disable_unprepare(lp->clk);
+	clk_bulk_disable_unprepare(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
+	clk_disable_unprepare(lp->axi_clk);
 
 free_netdev:
 	free_netdev(ndev);
@@ -2132,7 +2151,8 @@ static int axienet_remove(struct platform_device *pdev)
 
 	axienet_mdio_teardown(lp);
 
-	clk_disable_unprepare(lp->clk);
+	clk_bulk_disable_unprepare(XAE_NUM_MISC_CLOCKS, lp->misc_clks);
+	clk_disable_unprepare(lp->axi_clk);
 
 	of_node_put(lp->phy_node);
 	lp->phy_node = NULL;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 9c014cee34b2..48f544f6c999 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -159,8 +159,8 @@ int axienet_mdio_enable(struct axienet_local *lp)
 
 	lp->mii_clk_div = 0;
 
-	if (lp->clk) {
-		host_clock = clk_get_rate(lp->clk);
+	if (lp->axi_clk) {
+		host_clock = clk_get_rate(lp->axi_clk);
 	} else {
 		struct device_node *np1;
 
-- 
2.27.0

