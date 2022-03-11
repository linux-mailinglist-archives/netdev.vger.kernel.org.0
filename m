Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6914D6A52
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiCKWsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiCKWsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:48:22 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1F515695F;
        Fri, 11 Mar 2022 14:23:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bB+ktpzn2NaOT0uWpZs90gQP+610sihAWnr09hxQRAJ2TjcxptvOYs1YlCkm8BnZ+L8SgRuuSCQ8/SfWTm9CYpPUFCLwPj7+7EqOwk6mtVa4COnxvd+6RoMw8+kWNTwfhn9f3GMyEK2l3kKevf5Kxd63Fn9mDM5l1tiQ6zaW4ILRW5tfEkIsP7Pd/V8TibKHTig2aCpumBqYhuvWMbcbuxPLcj07Kqu1BeQGkGPqS6w2OUCziEU0qghHswSHJRj4Owaf7W6/vdlBiVbbouaMqILdRwrXt2UnuaR/ds+eUB8QQfFNUPTtHJgMfFKst2Fmt72mTRrmngY1Nl6XFtLsaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBvH4VfalBCth44HVzGEG8qKFckjzwtji84e/vDYUpA=;
 b=ZX7hZ9ska7kKnDqGZjSFDS4onJ9B24/EYBFzU2rgutyvHOPjgXnEfqoySPflt+jaO+anEplJd6rhVfr7YuysnFczMpqk0oC2i3jgTMM7ZSv4xFBp5SJ9XA7GbxkWskSVwdfKZ26tLENBrTOD+FQMgiczw+kO0U6y2EbT7WqEuMJyHUyi9vRM80nUqwed53EptEOntfc8fbiQDMUQC/1OnjbfhvFOhr97Ocydp8CMT9FLM4IfrzFhPZckovEmedIsdrve4nnYs1D/rd2Gmj3QiBySAWpPo/AQl2Peb9b65dsRyPK1RRY/mr+zbHurJjxqQi8W6ZxeN+65Y3JHPwOvPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBvH4VfalBCth44HVzGEG8qKFckjzwtji84e/vDYUpA=;
 b=Cp/+pZrs7w74WD60aUsuScmgMG18nfieWgOS3Kjal7Ffwfp4xmyeI+z5sauanEfex7Bc3Xv08Jymjkx8jng3ej+b/DWrEBD9odVnAZJiCeXDQX9qE3OMc/LUSvz0E1Z+NDx6e5YnVU4uNbjjCBSrvEzpH+Z2S0dg3AQDUXcoTJ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by DB7PR04MB4713.eurprd04.prod.outlook.com (2603:10a6:10:17::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Fri, 11 Mar
 2022 21:23:34 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%8]) with mapi id 15.20.5061.025; Fri, 11 Mar 2022
 21:23:34 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v5 4/8] dpaa2-mac: add the MC API for reconfiguring the protocol
Date:   Fri, 11 Mar 2022 23:22:24 +0200
Message-Id: <20220311212228.3918494-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220311212228.3918494-1-ioana.ciornei@nxp.com>
References: <20220311212228.3918494-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0057.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::34) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f159d7e-1f27-4042-2673-08da03a565e4
X-MS-TrafficTypeDiagnostic: DB7PR04MB4713:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB471383FB298FDA01924976AAE00C9@DB7PR04MB4713.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: imFDR7+HR8wbzh/nX15jNpXORD/4v3Iv/8ZaeQ0jDjEM00vhP4OK1qpAQqmrrq3Ln9UcvkxexKX2UJJbLl3My21/COioi2v4BMG4DoQimK4YFTBI1hAubwII1U77k6NDZvhLu8DqvsBFV8njLHsasXQ8jCmA72oqe6haqIzRsu1NgNFwX4aBDpeHQMhBIStJvY+MX7ONUKCJTvFo9Zdi9MesHZ3OqxNsdrMiluUEGeQwdvtIhGGT74j6oyykef+B1AHyD6DiHaNc0cVZO6DaLklgN3g0rRSs90H2U6epliDZDK8JEaOHZUWSzYyS6+4DIkiaZq+BmTCgGofHKprBV2ef5rmfE/EaF+s8Gh/NdfJO95PDi3HcmYp4VNUdA6K2gxojYtouccwkHdZxlAHLTFSfDEFj/GbPBJfXOIT/TqRRWY75grodTDfNCouo1UPSEdFh1Nafa6K9N+7BUAkAfHGXIdwCtyImeoLZeh2iqaax5G2j/X5UDB4QfBzw+fp8dSu5UnH1ZYpKe/y20mLQpkT555rZfTeUHOddzzv8eBSiShoY5tD1XuX1M3oFwjx0wopb9U+RFkCrl+aFKQwsE+lF6/u7C3bakWa/6lmBndlKtelQ/SoDbxNsOE+GDuBj+EuXzgEbE6XWbQ+q8c4ExAmpBmCk4lJF/Qnv6u8MN+Ja8m0bOUxdH4ynp1sHbEP9EweR1Y5XXlcU3RfQ42ICWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(8936002)(7416002)(38350700002)(44832011)(8676002)(6666004)(66556008)(38100700002)(5660300002)(4326008)(66946007)(36756003)(6512007)(6506007)(52116002)(186003)(2906002)(2616005)(26005)(6486002)(86362001)(498600001)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BsOD3ldzLR9MRz2jeeI5yuvQPnE8D39Z0xDH8MqnfXx0iri9DzIbqFLVeJNH?=
 =?us-ascii?Q?cDGJMJEJtY4VogvCwcyTt1B+MGMoGtY8bIymP8d3sdeead5cRufqUcj710xW?=
 =?us-ascii?Q?pHhcWzzP82w3CdJ2L/RwUzb1pBmZmg0vpc6bwGFH/mWyZ8jl2fuSRH+IXwpa?=
 =?us-ascii?Q?SHuPLuJpAQfWyNFN6yuHaZDENhSkc1y6Nys+Lfk2vq0b4s72zztvvH9GZMwF?=
 =?us-ascii?Q?ShNAEqfMxwZPGzDx8jcbXszLSooR7PXwAej6GmuQ2CQ09LiU69tqrn/ek9qN?=
 =?us-ascii?Q?Xm+pm3KG1OYAcMD7Q9uyMKaMX/EhCINDbSGOpMDebD370wR3ht2lKeOFtKv+?=
 =?us-ascii?Q?wM9hRY6Wp9SOhfs7cuKouuhMe4TcTwWnrJfyyxGG8Uq08ucVdiDZTBi6S7st?=
 =?us-ascii?Q?JiacxzsyzuVAG5MMd6JLgwktFxAZKEn0VQUu3RA34HftTzYkq1hSJkb/8Jox?=
 =?us-ascii?Q?MF4iW65gfatbZF2LZM4yrE7utjhyI0nCq2JB0l4Z9h2sYI5oxR4Nv6Oz1MeU?=
 =?us-ascii?Q?MvG2kisWC9U7EAXhTK0n2/THtG4UjO8NPqKbWWA7mtJeTSrDsMMzpargY8+K?=
 =?us-ascii?Q?YblY5RjixiQnNRdd5gcZiUod2GsdCtKKEMF8X8dooc2onSiCgor9sA0OuQF5?=
 =?us-ascii?Q?qqKGdU1+gABYrhOlUN3PByUt/J/nktISpruZ0G7N5hAJ0U9mWNa1rEIKfXfp?=
 =?us-ascii?Q?z9fZv/Xnnl5oPM6F2d3dRXKjvLUKwrwb4eueiE0L+yX/OeNi+T2HBfH4bDuL?=
 =?us-ascii?Q?DlmR+vZ1mZgw9zJL7zfSHddomc9CUChOwTjmvxHeVnzd5tpCWFfKavv2ibGo?=
 =?us-ascii?Q?J+cjb7pPfXx5S6R/SgrZQVBTCJdOI1ZaDis2j7RxZGpI83DAZU2ehEoiDBUb?=
 =?us-ascii?Q?pr4bJC+hdJfppIaHtyOLODz4QD1rOLMKwNRV0fqDEPRUYjqTQ6dfsQ7fXPDW?=
 =?us-ascii?Q?20uZQd/KIRBqiGGvV7xlWFI1DbB8MA4FC6iq8fxBu3NpAGkHYfjAkC4+LG7Q?=
 =?us-ascii?Q?vaE5aBojQU7SUHw0Sae3+Dm1sOy3o5FiLUqDm+9neOp0Ar1pvraB0NzhkAZ+?=
 =?us-ascii?Q?cesZLibuwnqF3qI373VQUd2L7/oOwtKRzXsHelZvYzw6w6n2BQ9qsCcBEXwF?=
 =?us-ascii?Q?S8yKLzajD3xYpm80Iq4Se9xBiqXZ8relTTg4154548ekyVtSYSjKIKkd1Z5S?=
 =?us-ascii?Q?+LVPSIJ3wfNrjILRElUry8Vu67crWqk6sfcbjyfVFZdIstGuo7Eu/0H0AttV?=
 =?us-ascii?Q?1cAQlsk9/mKv1uo83/qFl83q8sbg6IpLKcDJz1y5LnNcski3/ddxJdUcozll?=
 =?us-ascii?Q?VAN4LrCqDl6Ep0qiQSYF09S/c05VSjg5bUhrjgu/NrnaihHY+tnGUMqGXO5f?=
 =?us-ascii?Q?3lJYb0p594QYtchyIKdFfupiCs3yDEsY+qMF3hSwWNUWIlqkRGmnGbqwOFA/?=
 =?us-ascii?Q?cP8UnR7LqNkhaezY4/Fz5Ck+B/ECQt+GqYsHQTDHsCbjmZJ+ZvTRX8PZHZB+?=
 =?us-ascii?Q?h2GalklCNbVscTznY043BHXiEeh8hvKoKtawjXTek0sj5nUJS0kkbBmmkxWN?=
 =?us-ascii?Q?GF0SW47CinWIM/OeA0Bs8LLqoe1HPGFLJL0p1oijFMtElhJTNLmadeYi598Z?=
 =?us-ascii?Q?HDG8i1EDRNBG0WwqODPYqtk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f159d7e-1f27-4042-2673-08da03a565e4
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 21:23:34.1847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uMZm0vSQlD0H9VOfQyGuX2mN5yh/7YDegfbIeNz74VtbbHNqEo0t33e7RwWt7sa9//7ZWn1OszXA1hoRZcJ26A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4713
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MC firmware gained recently a new command which can reconfigure the
running protocol on the underlying MAC. Add this new command which will
be used in the next patches in order to do a major reconfig on the
interface.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none
Changes in v3:
	- none
Changes in v4:
	- none
Changes in v5:
	- none

 .../net/ethernet/freescale/dpaa2/dpmac-cmd.h  |  5 ++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.c  | 23 +++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.h  |  3 +++
 3 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
index e1e06b21110d..e9ac2ecef3be 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
@@ -26,6 +26,8 @@
 
 #define DPMAC_CMDID_GET_COUNTER		DPMAC_CMD(0x0c4)
 
+#define DPMAC_CMDID_SET_PROTOCOL	DPMAC_CMD(0x0c7)
+
 /* Macros for accessing command fields smaller than 1byte */
 #define DPMAC_MASK(field)        \
 	GENMASK(DPMAC_##field##_SHIFT + DPMAC_##field##_SIZE - 1, \
@@ -77,4 +79,7 @@ struct dpmac_rsp_get_api_version {
 	__le16 minor;
 };
 
+struct dpmac_cmd_set_protocol {
+	u8 eth_if;
+};
 #endif /* _FSL_DPMAC_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.c b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
index d348a7567d87..f440a4c3b70c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
@@ -212,3 +212,26 @@ int dpmac_get_api_version(struct fsl_mc_io *mc_io, u32 cmd_flags,
 
 	return 0;
 }
+
+/**
+ * dpmac_set_protocol() - Reconfigure the DPMAC protocol
+ * @mc_io:      Pointer to opaque I/O object
+ * @cmd_flags:  Command flags; one or more of 'MC_CMD_FLAG_'
+ * @token:      Token of DPMAC object
+ * @protocol:   New protocol for the DPMAC to be reconfigured in.
+ *
+ * Return:      '0' on Success; Error code otherwise.
+ */
+int dpmac_set_protocol(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		       enum dpmac_eth_if protocol)
+{
+	struct dpmac_cmd_set_protocol *cmd_params;
+	struct fsl_mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_SET_PROTOCOL,
+					  cmd_flags, token);
+	cmd_params = (struct dpmac_cmd_set_protocol *)cmd.params;
+	cmd_params->eth_if = protocol;
+
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.h b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
index b580fb4164b5..17488819ef68 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
@@ -207,4 +207,7 @@ int dpmac_get_counter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 
 int dpmac_get_api_version(struct fsl_mc_io *mc_io, u32 cmd_flags,
 			  u16 *major_ver, u16 *minor_ver);
+
+int dpmac_set_protocol(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
+		       enum dpmac_eth_if protocol);
 #endif /* __FSL_DPMAC_H */
-- 
2.33.1

