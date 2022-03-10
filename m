Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308F84D4C9A
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245473AbiCJPB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344011AbiCJO66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:58:58 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2047.outbound.protection.outlook.com [40.107.20.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC19D17DB87;
        Thu, 10 Mar 2022 06:52:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiBkXeINnxGkWlz2bN046TbwafMKit55BBrWP9n39wpgym3ErztldH0oWOcgnHZz7ruaK4ANPMjwmsamhiCahdFS1vfrICXx9mC0GxRakotemAjqXBVhgA9ik2p8ATGaXvoCIJ6CyVsFu87sDc+JOAgtmr+Gsru7+Isqlu2iKQriMXvA5zIzK0P+cTapeLWIhEFBaqcFtXC0k1P3iaKRcqtuPauAjz7VhoVsF2JnhwVxzuiNaa9j7pUmPWGaiy+kjVbIxe4xdfBb+bkEEbLBP/TLf3vbI3S/ZHQgmYTJwZParOd5+yPSRDl0NUOANuLYJer95O5JpaRwdcLH/FvOyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pv3gocVvvixSMvX0GbbeV+Q3zExO4FJ3EbUOi3Qh7MQ=;
 b=IsUR1IGkdErcsWlksSEV5ABRpiRU5YtVtJEPVZOtDeeI/9Xq9fmM0ki5SkOsxHytGMOOqNJrNa61rNvwxE0boZlLFoD9eVS8UQtEvHbQS3M8sBIZEHl8oplsL/EIdB41Ixkjoq1EivbCeTVey6Nic+b7bfM1iex8FewaMWMaT2BjRvQT5ezTi4GJjtM2lE9UBbSv/btNU5GpCiav3ldxLBcsnFG8kgZO+Hr7Ggp7xiWVay6RFnEaMwZHj/CKJL4CT7aIuRpC+KFVD8D6vf+hNw2KY4cweQ/0k4PzkDu/9MPrptrgXSfBxYQFy2AXhOEB38JO3FCHZtFE/Z2sQEdC+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pv3gocVvvixSMvX0GbbeV+Q3zExO4FJ3EbUOi3Qh7MQ=;
 b=RLWvBCudY7WHxsCcB5HaImvjdn46KbAx+mgC4rE5f2Y68M53vqnk+gmLehGuWwaGTu29eupcpsrhisTBTKCINsd4uq900/URl57x+s5iuQuejKjoPjDDLx7biNmnQxieRAVtxy+orpJp/uD+lpadT1u6lZCNySJTb+2ApTG2wBo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM8PR04MB7281.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.29; Thu, 10 Mar
 2022 14:52:25 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 14:52:25 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 3/8] dpaa2-mac: add the MC API for retrieving the version
Date:   Thu, 10 Mar 2022 16:51:55 +0200
Message-Id: <20220310145200.3645763-4-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
References: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0288.eurprd06.prod.outlook.com
 (2603:10a6:20b:45a::19) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d9c2968-805f-4015-25b4-08da02a596e9
X-MS-TrafficTypeDiagnostic: AM8PR04MB7281:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB72819D57F530185ED5FD7172E00B9@AM8PR04MB7281.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BmmCDpJxy8WH38OBfDbmgOxLRvzQCN9XvHCV/oVSJSSc2QdPTdtXO2GgY5Dlx2po3gAm1AxfrfQ0s8UOvRJLyNUQnmezFb6jIg04+PfmLIdOjvyWaNpP4y866U/uO1RKZE76zZojiha8tP7wDc3QrSVKqqkTbcLowdEyhJDRu1mUmRIZVIxkhaK4RM37iQORNTGNlk5q+8pE3wZdwKgM4EuIPJjKkBwwD4BT4fHIksZwRksnsj+DnsOUJF6ZdoxF4ZDHt273MbwXWh8yr7K+MB52bDM5hm4j48xXurUZPcg2Rcw86XuJ67skZK1LFJG/xpPtkzWgDugzul+4mAmFAUbLD3N2Kj0XrFCOgli98lNBsjhHIQFQWh+pVuNz09M55j9ZR5fR1/JCMWpkOy8qoiQ3aLVK8ETRLxSwFsO2H9NhvbL+ok3HcDnwwVUULVvG0HYTZm8YaJTEFiwfnA3Ewbn30ANYfr9dlrg+gWh+c4AmG3mI1AzrsUBhCeZn9fmfTJVZd7aVtH3VEnrrXBfKwB1qDrEl4WmpAd3isWgIqIRSYzPDI9Kh/MsqGMQpZ4GkX9mEAShSioevAAwe9E3m1nVOqyAo7r32UtvkrRH5nng49fS4hGzpEMXMmMN8iHrBwTt2brNF7woTdLOYl5of5stF8xoeT00c2HAf1gtCCYR7BWfIHGJt9Wd5Hg/QnCAT+EdGR7wqCi+6zBjsbWM5dQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(316002)(66556008)(6486002)(52116002)(66476007)(8676002)(5660300002)(6506007)(66946007)(4326008)(2616005)(2906002)(8936002)(86362001)(186003)(44832011)(38350700002)(38100700002)(6666004)(508600001)(36756003)(26005)(83380400001)(7416002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1UJafzpLbLhfQBiEsw4YNADFrTc7d3mUMaAlPFGgKqJtAynz7cXmeJHuFjKg?=
 =?us-ascii?Q?tXBHjjCi/OAqnW3VRlFZ91GAwVUjj9d5GUY1tDqokAqxkqwqM32OHHMoNc3u?=
 =?us-ascii?Q?o972lFkuyrfWomp2mvt9xeyUcvHUit11kGP88ko9FpBQEbykqW+8QoiB3GXT?=
 =?us-ascii?Q?rjJUSdw+bkUruzRrrOiIMLFKJRj0ji+XFNzf9X1PhhLHHLXOEbC7j1aC1lY4?=
 =?us-ascii?Q?P07qKr+KNVBH27gsizOvg6hbAfp23HYWe5vMh5m19K3kp0xLqBCE5qM4AslN?=
 =?us-ascii?Q?hpZ1RoiTFHgqeRC7kNTmhR9KbKvMU4qCaYZiBdCe1GWWA/EQ0BQX9qsM+gUa?=
 =?us-ascii?Q?UPA0E3C22q6WYAy8C2L+DAU1tDdPvHXTFqKAe1VErZOFLQMPEMdP43psJbCZ?=
 =?us-ascii?Q?UHZwQom1rla6bESNHiDK7M5V2p/O3IfZJiovUvo9KGeJ0tTPY1PnFv5ddOni?=
 =?us-ascii?Q?dIuiY0EdY+u0VGrfJuEaM/uiJC9bqDwd2gRuwZ44mrJRNJgdMA5+t+osd9cy?=
 =?us-ascii?Q?UA9GwbtTX3VVmaEzmBEsLMW2j+RXlbI6BnspuZam4hfUK1fW/RNGsfMss7Zf?=
 =?us-ascii?Q?vKia9GZwP3xGlLSmHJqHKf7el0OaMEZnni/12br538ygqndvbLKjfZCK0tZk?=
 =?us-ascii?Q?o+tWRNoLwZbLgN3qHegaz4YPW7BVDBFGCazZ87kS1gjr+CQ0ylcbBND+DGig?=
 =?us-ascii?Q?GQq5ZYqeuHOTRrBZrpR+EZW+84HqlPeeiz3dvCGzbqX0WahlYILaV/vEMMvB?=
 =?us-ascii?Q?dZZRGpY2S2mpyn005zQTd/fMkDDkvac/KFkUL1OTIRzQbed0e1Ia+bNSnQmR?=
 =?us-ascii?Q?FzPFVRuRVBTlhkLP5wUePrXV6PQgIrJHZ1Ac+CpK3F/KjRrvb/cwnY0hYrAm?=
 =?us-ascii?Q?5oDvPamqkaDjiitM2mDuKNjjNfG9nSxgu9mKUYecSV5TFiVbrptZUvD3oVjO?=
 =?us-ascii?Q?roxLPSFcEnYJb4QqnuFwlxeTg6TACBLAJL96td6khzJsUHMdD+uYj94fToSq?=
 =?us-ascii?Q?WYTnxBsaiSV9YaMTl6JR0xx4s93RJLmjFYnqMPvLzDyeBFf4dHjQL/ti84wK?=
 =?us-ascii?Q?iW1XZt+xcOaB0MKQgEfqtgU3hKZA/JvkwA3u87gZGtF+uxf3XE9IRaiLqsag?=
 =?us-ascii?Q?TYBSc2ZA6bAJFSjQqx5rvSkCypnf1Ir0Jcx1m8Utc9ReThJc4gsgaz5k4WWL?=
 =?us-ascii?Q?B2bw+8ZZEcL5oTiLpiy/Ljamd/w9Eti8e8Wg6/tYkxiBMpMQ3cSiZo22ZDe1?=
 =?us-ascii?Q?DnPbQqYkejrdLPrH3rct5kPwm4nF8lmrhf6Ou0MWrx128wirn1D6vEeMMsqm?=
 =?us-ascii?Q?qkiTpv2uwx+HQe6BzV/MPu6EceEbhso8QOMptskArPjZFyiMiM4YK6jxssai?=
 =?us-ascii?Q?hntt1zaQlmo/LGz09l/18Oo6fpDBw5YPEZKj+wBLwiKCJBfrHmFd5bE8kkBI?=
 =?us-ascii?Q?nmR1cgv5FK3aQcwE0LdlyqBbkO1Bv7IbFWE86dIRMUnYcdMsSvlxMvUrtiWM?=
 =?us-ascii?Q?pHEb8JAwcAnwUIqmu4YMlrMOluBARRziXvcYZuUaMI298SJAHtQxnZ4fOwDh?=
 =?us-ascii?Q?TuOPm1pBj1/LTPFOykFQdA89232cuOr1/LU7uDq/azzC4wV7YWXOrDLns8Bm?=
 =?us-ascii?Q?gqU05jyvzuOuPG61FfPndfI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d9c2968-805f-4015-25b4-08da02a596e9
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 14:52:25.2630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qMIMPIP7M3EszXb7uOx6TPvaieVMEo8UNA4tERauyvgYSFpd9aGPu40dJKAEAqRKWM8R+QSOJxq6i+bSPx1e/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7281
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dpmac_get_api_version command will be used in the next patches to
determine if the current firmware is capable or not to change the
Ethernet protocol running on the MAC.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none
Changes in v3:
	- none

 .../net/ethernet/freescale/dpaa2/dpmac-cmd.h  |  7 +++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.c  | 31 +++++++++++++++++++
 drivers/net/ethernet/freescale/dpaa2/dpmac.h  |  2 ++
 3 files changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
index a24b20f76938..e1e06b21110d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h
@@ -19,6 +19,8 @@
 #define DPMAC_CMDID_CLOSE		DPMAC_CMD(0x800)
 #define DPMAC_CMDID_OPEN		DPMAC_CMD(0x80c)
 
+#define DPMAC_CMDID_GET_API_VERSION	DPMAC_CMD(0xa0c)
+
 #define DPMAC_CMDID_GET_ATTR		DPMAC_CMD(0x004)
 #define DPMAC_CMDID_SET_LINK_STATE	DPMAC_CMD_V2(0x0c3)
 
@@ -70,4 +72,9 @@ struct dpmac_rsp_get_counter {
 	__le64 counter;
 };
 
+struct dpmac_rsp_get_api_version {
+	__le16 major;
+	__le16 minor;
+};
+
 #endif /* _FSL_DPMAC_CMD_H */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.c b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
index d5997b654562..d348a7567d87 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.c
@@ -181,3 +181,34 @@ int dpmac_get_counter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 
 	return 0;
 }
+
+/**
+ * dpmac_get_api_version() - Get Data Path MAC version
+ * @mc_io:	Pointer to MC portal's I/O object
+ * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'
+ * @major_ver:	Major version of data path mac API
+ * @minor_ver:	Minor version of data path mac API
+ *
+ * Return:  '0' on Success; Error code otherwise.
+ */
+int dpmac_get_api_version(struct fsl_mc_io *mc_io, u32 cmd_flags,
+			  u16 *major_ver, u16 *minor_ver)
+{
+	struct dpmac_rsp_get_api_version *rsp_params;
+	struct fsl_mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_GET_API_VERSION,
+					  cmd_flags,
+					  0);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	rsp_params = (struct dpmac_rsp_get_api_version *)cmd.params;
+	*major_ver = le16_to_cpu(rsp_params->major);
+	*minor_ver = le16_to_cpu(rsp_params->minor);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpmac.h b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
index 8f7ceb731282..b580fb4164b5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpmac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpmac.h
@@ -205,4 +205,6 @@ enum dpmac_counter_id {
 int dpmac_get_counter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token,
 		      enum dpmac_counter_id id, u64 *value);
 
+int dpmac_get_api_version(struct fsl_mc_io *mc_io, u32 cmd_flags,
+			  u16 *major_ver, u16 *minor_ver);
 #endif /* __FSL_DPMAC_H */
-- 
2.33.1

