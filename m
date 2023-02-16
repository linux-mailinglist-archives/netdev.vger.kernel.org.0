Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F51B698E13
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 08:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBPHxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 02:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBPHxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 02:53:40 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2137.outbound.protection.outlook.com [40.107.237.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC2710269;
        Wed, 15 Feb 2023 23:53:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzuogHaDZ6Cf7oJF5jA3nrjmeVfEDmKkygfLsTKE3ERuw4cJoIftIUfxWrGJR9ORdrDth/ex/n7ONtJteb+gdU+E4dX+a+XAlpCg1odCdpCHyKNik6fp3YV4jiVkorBRSaCLcIaTh5vzlkwfHYCwkJx9H4IOpHj8LaY2fkksxHgRcSLgZPkjrQPx1mJjl3djYIm+PUW4bFQTJjdXXiIJ0fewHitP4Cjv/+jSgN4+xYUnzbpUyqtL+IV3Bt1UUspsLZdRCA5pszbC1T3tFrNC6r1Uz5s0ZcCdRzyRA7j8F4PRv7WD+xLbNDP/5tkQzHZRqp4E4S2SQj+NNXP6ZoLo/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yafxM1/CB0aCxPETKJ6jtM23tTP4MoVm6c9+ddOt0lQ=;
 b=Xl9J/YK3naaAVkwc3Pq7RVisw0CrQmzvKfV1QJZT0KUnNdr/mrcjBqqIu4MM1GbIHRk1WS2n/2ojg7EF2YNKWtijgiMmAvcTqWV9BSjDORAJan5wTCCit7DHGEHKAQxBcgVFL3fFIPF1teR9clk5Q13xmxu1HYYnABYJscyiUvLVXp/DHOUNGXKGPOxrxz5KuGY/bOcvA/XkUTAH2DS/IsVrADApj8E5zaOT6deXFiT/DNoBbBdNaSdSn6vpeLRReljmYsDuEVsiHVum1vbBgOq+fU0LUi64igCRmcP5/rUSpT10coRObqPot6ofKaEyBXaL9dJV4PcM6nTmNxpajg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yafxM1/CB0aCxPETKJ6jtM23tTP4MoVm6c9+ddOt0lQ=;
 b=aC2MmNp0hoSCgGZa3MWfFxQC0OqAjRnyWh+WL+VL/YzpImrQNro+WHOtDpDABtIfWwwEYOFHugpNJUFz8SerjA4v7zWaNu/2t/6NBOuGule7S1YgenpRNjTv0vSNG9GVkRb0obPpHoKiwOBUjmIIV8fDfQ6kF81nrmKHaIMObD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by IA1PR10MB5993.namprd10.prod.outlook.com
 (2603:10b6:208:3ef::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Thu, 16 Feb
 2023 07:53:36 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6111.010; Thu, 16 Feb 2023
 07:53:36 +0000
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
Subject: [RFC v1 net-next 1/7] phy: phy-ocelot-serdes: add ability to be used in a non-syscon configuration
Date:   Wed, 15 Feb 2023 23:53:15 -0800
Message-Id: <20230216075321.2898003-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230216075321.2898003-1-colin.foster@in-advantage.com>
References: <20230216075321.2898003-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:254::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|IA1PR10MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: a02f608d-293c-419f-a121-08db0ff2e87a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YpTsvfcufPCGXmqdLdNRbKpAECrbva50ThN74at7lEdR7nK59aRmTNcj0wpF4pEbDtjsooqhwMMiQEDEwWpg14VHlf63OEbh+EhG7tqWbGy1zt8WeUz4LxykNPmEWQuK9dUeJAu91mWpxnDTp9eWtdK0T3hAiFnRa44mKJy0zfFX2GWyEUeRISQBT1kkISgOoo2rd4CX1c2+OgudSL+F3NuurNKqEvkhGCLc26/Yjm9rgzSnFbyeSXjRWpCoV1jNOb76nbxQy7z4rbVDLsDUJxu62nAzX+a0JCT6T4E8ZdmV8drImy5ESXrx/ulSDLynfFXLf7+/KJZ1HC0r1BXexsuGFE/yOaCci+5QdszNHb+fgvWhO0w4IGGms0reH4kGwWW2OPKLdEUpuKbNqaBnryo00afdNo0vujL07SdsIW5CyQzz1CTVgTi1HI6xW18Ye80AbvOe2Db1trLZYca5A4pEdiYdWQCMcBKG2GeyI/7UeOnhE8niVZxUeX9AiO7tKaZ+BS3uBFQfOepsl2Re0+Y5oebjznmF32xhC/vNk7tzEGjS8DOPZONW59Omrl1cOq6Z5BBwZvzTiX0fVaUd6896ntK2tnro1ItcnU9Wc44yhweJb2sAmJfMhzVcHgYu7elutrLfSuenKukILLpVLXUiGNxA7ITTPpOM12hn1rxHbc8HtevJFEyMi+aDAzLO8vZsuFR/cCbM1Q4atasuHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39830400003)(396003)(366004)(346002)(376002)(451199018)(5660300002)(38350700002)(41300700001)(2906002)(8936002)(38100700002)(2616005)(6506007)(26005)(6512007)(186003)(6666004)(478600001)(52116002)(6486002)(44832011)(1076003)(86362001)(316002)(66476007)(66946007)(54906003)(4326008)(8676002)(66556008)(7416002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YlfRWrYo+cTsf5sNMc+Pb0+tq60+jm384Hewe0vVmSwh2KjvRe0J8UaoF+QB?=
 =?us-ascii?Q?oWl6VGz8/CFsvOua60zOufprnUBSSE3AVDv/5OGtuQJkCuvwoc1FmKe+f7SV?=
 =?us-ascii?Q?Kys/3npDAGw/BdH4j3lqqPI6Td1X5QUZ89kOdIDMrAYEm+vSNthOmfgVaDME?=
 =?us-ascii?Q?K5uHNpxr3E9iS9MOpF9mXNYPkl34cdQpnFI/j4BmbWkzV5jaPWd8FWGX/RuF?=
 =?us-ascii?Q?n2jWJHS5YbJ7HIDo6GpK3jOoENozeVUIJa3BlnBTrC52H4HtDr+OKZ/ZOxsl?=
 =?us-ascii?Q?543KrKUv/Xx1PZJkixEpTlsVJ//Z4EHYDmSdG/BiRCPEsQw+/377WgqPOVh5?=
 =?us-ascii?Q?ig370sZwSfrvwsSJoBPSP45iPFeQu/dyCUI/Zuw6xY87+ZKESoqXuTji+Xge?=
 =?us-ascii?Q?CqvM9+JLmpjR7IxCwjIgBjkUpQR1+kQBuwBKMvVEwGcnrfF8+8uEPTXq/LcD?=
 =?us-ascii?Q?x+f18LqdOJjoPFvjpuLOfWdHcuPtf3AVxGS+OeQ8s1FuVyPtPE0I9nsPBfPg?=
 =?us-ascii?Q?VIjSTvnnWQLpITMbHDNK6ZKaXzVtiIHpdz8Mvemxek6AyuOUrMgdFgqIuRzL?=
 =?us-ascii?Q?2Dv2K223EFj8wnpIRJHXnj8CtaflbCES5BVEO8llAcsR+MuCHfHPKIgNk0HU?=
 =?us-ascii?Q?k4oloivuA19951YOtxhux5DNqlAEEO+uJaBQOBNpOF+NXkVPULmfIdG+e2E+?=
 =?us-ascii?Q?hzOuexxV8rEMYI/XoU8DoJtW3ZSMxey63HkejJgeb7gkb/etruAdz/WvrWxq?=
 =?us-ascii?Q?24yLWTKvoZJ7CgS4qWq82wx3Do3gd4o0Pdn2tnE1T6Liu8wdPCmdx7FCpPRv?=
 =?us-ascii?Q?a/xutBf5y9TeVJNEFC8EYku5xwAdHnvwdofP+uAalpVAMhIlVZW8yEDqsWrO?=
 =?us-ascii?Q?e2hxipwU40U9IOdh6f1GwolS9PqFKnMBo+SLiewgl2r23VOHysQsSDxG5mia?=
 =?us-ascii?Q?KBnexWFiIUadBNXNpTegsduJM7GBXX2lxmX0XQjslaZlZaP8diL+utBw73Kk?=
 =?us-ascii?Q?ODqSQhexLkNuqjfR5E0SXPIkvF/kyOa1jjqQpNOK9wXTyaJ+yFKwH8K2NCpU?=
 =?us-ascii?Q?S9KPxi+KnGiUXIahhzTFBlyiGJxu/SQRlM/W5S5U3ZVTj20AoXHynYbOKXP9?=
 =?us-ascii?Q?CMugWUtumqfj1HoxxosJwWDdlwsKJpzKQ+mnIv3QR7oiNTpwB6/8H4vCu/rn?=
 =?us-ascii?Q?v7lz1M4qscVmUfRccjrb9spb4961Yahl4dWq9eQi+ZGmnJ44nE3KjDZCNOUk?=
 =?us-ascii?Q?RBsM76YbksTmqt4ePJ01R1q0WLEZrot4xxcurITH7cZig/dGUQgq9CMvzsUb?=
 =?us-ascii?Q?dVZ6afoWPAI8yT5o9iTs8xifrRFZCSqLc+NZS11pYUfMsHqX8uwk39KjwsJn?=
 =?us-ascii?Q?t+AfBa4q6B5uGb5NAk5/AB5sn7Ao0HD8L51ksBhzdr9JbGG9v518QaOX9+Vy?=
 =?us-ascii?Q?Fv80q2Qm8sBg0jTAD1Zt8xLPdQVA2v25ppZB1a8biPipzZBINIGzxH2ueigP?=
 =?us-ascii?Q?/y5FCiKjdx3qvINNNl6+AGmoOhvYf0wM8cO4PRaKg4Wr5NiTYmTYp53E17U0?=
 =?us-ascii?Q?ijZ67qwtRStO/6Yge8VB11wGn3NSeJd7W1CEPky5pH9yOQ4z5I96k08ceNq3?=
 =?us-ascii?Q?C6Wy73s1kJnRSCLjyJV/DGc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a02f608d-293c-419f-a121-08db0ff2e87a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 07:53:36.3191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3ICbx8N8LzoE+VrlWO44Tkq1Lxkls+mzXXShz0mxNH2O1q889nRrjYesV+A7JmTiw33VuNqIfVO7oCH9VOYVherlJVAErv/iR+pcknY6xU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5993
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

