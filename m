Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8665E59CD
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiIVEBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiIVEBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:01:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA54ABD68;
        Wed, 21 Sep 2022 21:01:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gp6xCg+WXfqRZOt48bipj/nKBeHz64XF/VxaPQFRCTFsgRL8dGltW24pEpzKQE/vGkFh5yxDsjUxvzr+asUSIQ/vhT5CkmXpJJTewY9gotJOj/bxF0SdWiHpqWJMTUSj4sBUr9iH2wPB6GNmn+acSqKzYo3zLZe7W7bahrcpbTFR89ihl52I/pIH2UVrAqNC1fQ0RxgSQ6gMwGoS+Kexs3QWhZEAMdXCHRUoyaFTu/qoxcRwnpR0BrbSGhgn9JgqArci0qgtMGXKyjoRZNvfvAH9vC7tszeDSG412tvJw7AHqAYlEtgWPAtKvQzLR8VceXWv4rPn9OuGyorhAXr06A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OH7PDXeOu/oAycNZzrDod17exL2vm7gJso58+xKZCTM=;
 b=KcPyOTCKU23CPSxsS6reSgdCksTOAwMfpedEvZGvM7+AF+qGhr1Q9rODqatN8LTVvEwi6pUrXU29YvO4et026xEiFb67WUyZqQUBQJNWb+rwICFewY1rhkTBPZM4S+NvHlbc8kwD1a47ugi/xK7AnYr/sELKIOWa7L2I6Ip3T6NoT3N3OtN0Cu3ykbSFiZ0rGTaC1DNlWJozBgeVYX3+/CCrSc1bwNTJl2+VCXgn1ZY1xjoqsrjgnbS85O+O3hHY9DvfYzoZ+GYkqmBt14wU7j3rIiEvIW5X49wfIXlIC7jI9YtwKGFuN6IoPLj6JfbLBEO0U6gfpOX8AGA0GXaH8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OH7PDXeOu/oAycNZzrDod17exL2vm7gJso58+xKZCTM=;
 b=cXJ0TpCjZ8G4a8u3HtLQloptTrJH37eBVCywqNerbRYrH2X9bA0fqHNRNOosD0lvR0ZAkMCh8q943n/NEPiaTqxIppvYfg9vGK4zqVH7ZYMKtGUeWdk1RWerVfgFFUsNy5vBSrxVuTFcaX5mv5LDZgY3W9Anuwpq+ozi9cw/hFY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN0PR10MB5158.namprd10.prod.outlook.com (2603:10b6:408:120::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 04:01:18 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:18 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 01/14] net: mscc: ocelot: expose ocelot wm functions
Date:   Wed, 21 Sep 2022 21:00:49 -0700
Message-Id: <20220922040102.1554459-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|BN0PR10MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d467d56-18f9-4afd-6f56-08da9c4f1a04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 34ZFQPZkxzqm3iUJUKBvwd3x8trLsaxTTPFWgx90aA9fIAJUqYI85q/CVA12xyEnQuA4UOma0ZkJFe0pLuWy+vYDAo59P/UHwAddkUy+q0ZOzBnDBPdf/gEmSaW99o6OMfPFDweDZOifksmyQovnOiW51MqRhNFIyia1PpawhYHjZ+nc+vkK0hCmnVoIoL3ygUrvFWzCf8AUfJ8F6bkHG8BfR7hratVupEJSIHDeouHJsSysOh388dqxrH6+zyKEMdPua8URogVuBGHHxgcTAIx2S/14Wdq7RzTLDkzBA8A/sSYyGvAxBIRc+Lwx79cxRIsm/Bf2devRoEZmuRCZVpq1c3X+Vzyxr6ETlQX+gNsLhTNQ3s6252zkTQAIrA3AS1GLBCr6DurCZZrIhuNMcAdJZVceRjjxHhdfEJoQjd/J9fMRz3Lkicc/OEd3DB3erDbQBfpVTJfGTMCAeo0WEzwj6ZAQnG8PqSwqPWy19KFnlJCUJUgJpLa5fjg/z8koabFJgx4NL786EPFvveHh3PdHBDiD3wdQeshqjOwMjAl/HUq4LyTGxDupS/Cn6Bcbl+3XZW5qp3shMgnil3+Q4xEybgTyZQs2BDEhWsQfRceCIvr+fDVIU+uWFg6H2y4JFC1eOUlrVdV0hhWkcx4MXjJ9MalKI1zejZXRudQu7kfxt+G5JvIcpK3tRWvfsBHYNz0Vqjt7EyTGKTBuH2CmdD1rHBSrORuufETImq32ZmueF8Tfrd117uLoQVg51fF+ZGXT4EtUfSpOc1r1KlxxSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(6666004)(36756003)(41300700001)(8936002)(44832011)(26005)(6512007)(7416002)(6506007)(5660300002)(316002)(478600001)(54906003)(6486002)(38100700002)(8676002)(66476007)(66556008)(38350700002)(4326008)(66946007)(83380400001)(52116002)(1076003)(186003)(2616005)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c9jGtDw/WmPg1ynUWadzK8rdbF7JIdtU8qsPuXM5fo/q4qaDGh9rcE+bOnI3?=
 =?us-ascii?Q?4UoEmkPRtZruh11e9wgx/Mi1kadJdtUhDcX1Ao43E3VoSzZiaKxRhvflWjZi?=
 =?us-ascii?Q?EPiBhpkgzn8ZpMXDe/0PC+FCwMZQvcGfvmoNRINnyUhHgXo/m8Wqjpk/vNHA?=
 =?us-ascii?Q?bFR5jz5aHfsiXT75il4ttMz24VNbNzyghpZxI8BX2Zxn5WPzFwdIE8RAkiEG?=
 =?us-ascii?Q?WU+XQdzy1kgiHySDKbGV4FNQZwwyuxEfYEyDSOYXdh8ny0GXbs4w2hASj5UA?=
 =?us-ascii?Q?8Nw7xoGUcxuLEygVLXFg1EXxNoX9L+hGkFPivNtacWLbRtYYETy9Rycw0fAu?=
 =?us-ascii?Q?YDU2//tojPwXkc3LtfSLXr1ofPbRrf6uipqzSMA+MwfGs4gBt2fZCMICJl3V?=
 =?us-ascii?Q?Q7V1OiSG0kzg16F9cpNNP5GkHklIyZGZeU8x9N/Oaxl6Sd+4c7iSCakAiNEK?=
 =?us-ascii?Q?DOBy3sIF4mx9h/g5xzu5Z6R+109j8GpAeTPDS2NZ4aOVRgql0lSOxREc9Nvx?=
 =?us-ascii?Q?b/fXGKZv9e+eEqdKutAlNwne1ywfa1t23eQC6S/3LTrPplfCgS5rb8sSPu6g?=
 =?us-ascii?Q?NTaqpV583IrwHwiQBL1sp56F86Qksqgzs/VpXcnMwQ3zbpBtbHzfJYl0Vhrq?=
 =?us-ascii?Q?JR8VsA5raXR0ghmcSQe5CUwmeS1I4Oo87Y8V2BigAfLbO9HwvnVZCvQ6/ngA?=
 =?us-ascii?Q?xUe6+r1QSwnbMQ5HWiL9HTys1xAj+zxZToINXNiQj7QZvhgdvEh/ETiiBcmm?=
 =?us-ascii?Q?fTlhcEyQHwZPvBK8LBCTq/kuIkS5xZYFJwUzlR2ef6C81owZX8Ux/04EPyVK?=
 =?us-ascii?Q?T4jOP1TgEb3Xi2+wv6DASmiPyEJRA9zdimn/c2Kk/u0TNi+Ikn8Q9cS/12xN?=
 =?us-ascii?Q?DYyjMaljXbZlTAlggPRVtvY+Giz7JxLh+yEoNL7w5wrIYdRFiLmKirTnmna+?=
 =?us-ascii?Q?eDYvFBnteghy0k/ORfC3frxR/cXm1lygPSN1n4YdFD2NuhSjtZjFwa4TUtOy?=
 =?us-ascii?Q?pUXotIFzvKzbIUaG1+Xh1QQK8FV6ZQ0SJI/lW8H+ZgzX2oI00kboYlf53ril?=
 =?us-ascii?Q?EiMl1+zLWh0Xg2VSweGhVwiooCp9BRJrgI2se5Clnr30iiism1O2fsUlylcE?=
 =?us-ascii?Q?WHKWS22Gm5P+pWODGpwX0piRE5c7aGW8zlKyczEY2IP6qWtajJOkY3g/nniI?=
 =?us-ascii?Q?leyGRbOtI830L+4Ri5cVutyN4w/LFVE6saqUWzBx3jTMkzmSSOZ7hnELneNj?=
 =?us-ascii?Q?IOh42skEjckl9HikvEpVcGJulGhPiQfnfo1B6dDV8tM+uh9iLFDQ5HIV/Op2?=
 =?us-ascii?Q?YfeG/eR9WrSIDeBAKD37HzSBuiJYVjENLFLxVh0EsJpTsLVtllQfS7KHAlnm?=
 =?us-ascii?Q?MLD8rp1IhlCCBrXFdWc3rFvp3yTw7LHFabGaO8qu5e8ztqUNVejH4ZcvPRyZ?=
 =?us-ascii?Q?KTa+s41DQEoLqNJPNr0KIuaD6s7QTkZtZ7JVFZ3v4oNg3RN0JQZJQZ2n0FFc?=
 =?us-ascii?Q?+9mGoWJniZNGCEDKFE5vitiaihfWU/Hzo7HvMLThbdlTEKJYCk6xU2QfknGO?=
 =?us-ascii?Q?E4t8aGJAbCyvlo/2aCg7m6Gyb1F9qgE/Xl4BCu53Kp/PT0igTXBeTGG8Q4hu?=
 =?us-ascii?Q?9EW47zpDjsiJTCukoieUyIA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d467d56-18f9-4afd-6f56-08da9c4f1a04
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:18.2162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o5GfjymCMwtjyriMMWvxy1JbCMJN3BgMxw1l12K1FHfix0Kb31+FXUba4Zpubrsn32iR9zwHwe28+e8hBmGsgnMaQs4i88hziCDZVf5RhsA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose ocelot_wm functions so they can be shared with other drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v1 & v2:
    * No changes since previous RFC

---
 drivers/net/ethernet/mscc/ocelot_devlink.c | 31 ++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 28 -------------------
 include/soc/mscc/ocelot.h                  |  5 ++++
 3 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_devlink.c b/drivers/net/ethernet/mscc/ocelot_devlink.c
index b8737efd2a85..d9ea75a14f2f 100644
--- a/drivers/net/ethernet/mscc/ocelot_devlink.c
+++ b/drivers/net/ethernet/mscc/ocelot_devlink.c
@@ -487,6 +487,37 @@ static void ocelot_watermark_init(struct ocelot *ocelot)
 	ocelot_setup_sharing_watermarks(ocelot);
 }
 
+/* Watermark encode
+ * Bit 8:   Unit; 0:1, 1:16
+ * Bit 7-0: Value to be multiplied with unit
+ */
+u16 ocelot_wm_enc(u16 value)
+{
+	WARN_ON(value >= 16 * BIT(8));
+
+	if (value >= BIT(8))
+		return BIT(8) | (value / 16);
+
+	return value;
+}
+EXPORT_SYMBOL(ocelot_wm_enc);
+
+u16 ocelot_wm_dec(u16 wm)
+{
+	if (wm & BIT(8))
+		return (wm & GENMASK(7, 0)) * 16;
+
+	return wm;
+}
+EXPORT_SYMBOL(ocelot_wm_dec);
+
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
+{
+	*inuse = (val & GENMASK(23, 12)) >> 12;
+	*maxuse = val & GENMASK(11, 0);
+}
+EXPORT_SYMBOL(ocelot_wm_stat);
+
 /* Pool size and type are fixed up at runtime. Keeping this structure to
  * look up the cell size multipliers.
  */
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 6f22aea08a64..bac0ee9126f8 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -234,34 +234,6 @@ static int ocelot_reset(struct ocelot *ocelot)
 	return regmap_field_write(ocelot->regfields[SYS_RESET_CFG_CORE_ENA], 1);
 }
 
-/* Watermark encode
- * Bit 8:   Unit; 0:1, 1:16
- * Bit 7-0: Value to be multiplied with unit
- */
-static u16 ocelot_wm_enc(u16 value)
-{
-	WARN_ON(value >= 16 * BIT(8));
-
-	if (value >= BIT(8))
-		return BIT(8) | (value / 16);
-
-	return value;
-}
-
-static u16 ocelot_wm_dec(u16 wm)
-{
-	if (wm & BIT(8))
-		return (wm & GENMASK(7, 0)) * 16;
-
-	return wm;
-}
-
-static void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse)
-{
-	*inuse = (val & GENMASK(23, 12)) >> 12;
-	*maxuse = val & GENMASK(11, 0);
-}
-
 static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 	.wm_enc			= ocelot_wm_enc,
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 967ba30ea636..55bbd5319128 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -1145,6 +1145,11 @@ void ocelot_port_assign_dsa_8021q_cpu(struct ocelot *ocelot, int port, int cpu);
 void ocelot_port_unassign_dsa_8021q_cpu(struct ocelot *ocelot, int port);
 u32 ocelot_port_assigned_dsa_8021q_cpu_mask(struct ocelot *ocelot, int port);
 
+/* Watermark interface */
+u16 ocelot_wm_enc(u16 value);
+u16 ocelot_wm_dec(u16 wm);
+void ocelot_wm_stat(u32 val, u32 *inuse, u32 *maxuse);
+
 /* DSA callbacks */
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data);
 void ocelot_get_ethtool_stats(struct ocelot *ocelot, int port, u64 *data);
-- 
2.25.1

