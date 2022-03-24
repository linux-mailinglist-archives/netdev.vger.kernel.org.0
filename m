Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9494E66B4
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 17:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347716AbiCXQOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 12:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbiCXQN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 12:13:58 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10086.outbound.protection.outlook.com [40.107.1.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB592E6BF
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 09:12:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrFK4qCZa4jcu2qRyaCW0C6LEybm05MTc+MBVcuL10RQuYnnp+RvtQxsz9jDTaKwhh1r/1b1BuquzLiQsNovcRjXTUHTbvWGojQXIOWxsY3FLOx+Syl142pxbOMs05oOaXAn75lJPvbxMzVAPZwBB8oDuaG8K+4hahltNVZiDIPjvMa5Sej8gens/ExS9QqNTZ2RvOhHyGq+Ff+lxOaH2D/Gwv6sxSo1eeAeQIX6aPVNKIShC2hkxrlvuMUld2WVegyKbv4P1mfPXksBBrMgRjRMvqH4vxqpEVJ7mF3asZ49OORPwrZKCz84zjBgM/HgzRk54IFpi2xs9EiMIFCQ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HQ+zxT0JO5OTSVfYubIadXSlyLh9Kck/qW73DYib+U=;
 b=hcfkztzlxJ9H6Fqxsyc4P+pmkpyGeHlGpt6/C5srJKQhc22x0dIfUvYs87Tz8iPPSZdLYApLmqrciHw4Q6XG/jZuyrxwZ5+PcDJFAWnSL4S8KM70nFgsmbNyWvaXzd7DKnXqfYp+z0JxwyjpDvZS6m3kBrAODVoUu0pzyN08JpgGeqAHKPye4Pgx9RboqwQO1rUWMf4MN4w74ujJ7PeyiE5AeleJTyMkjqsk/GOMpgMYU3mV70SMakt8eEVNerjQNwHFBeG7hzrVoyI48CPXOkDCpOeTOHzflhRiMUwjMdlq9c4cvUrbNQagldMIWMJKtj9DGaIWaO5pii/7b67HvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HQ+zxT0JO5OTSVfYubIadXSlyLh9Kck/qW73DYib+U=;
 b=f65JeBe7Fkp/Ok/Vo0znTVPlzsHOqN4+C4LZXbH0UibLPhIMMoqSFjfa5ar2K4NpBEfUMr+pXdAJgIyIclaoyvzDpTVxqt7quioq2ScoQRLRYCLHJTtPVtz/XQnvIClDQy9cbBPFdYQk9hHM03EU0IAKuQSsydjUg8qmB00tjSc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM6PR04MB6326.eurprd04.prod.outlook.com (2603:10a6:20b:be::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Thu, 24 Mar
 2022 16:12:23 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4502:5fbf:8bf2:b7bd]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::4502:5fbf:8bf2:b7bd%7]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 16:12:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net] net: enetc: report software timestamping via SO_TIMESTAMPING
Date:   Thu, 24 Mar 2022 18:12:10 +0200
Message-Id: <20220324161210.4122281-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0232.eurprd07.prod.outlook.com
 (2603:10a6:802:58::35) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f389001b-7946-4300-272a-08da0db1140e
X-MS-TrafficTypeDiagnostic: AM6PR04MB6326:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB6326A5A418BDA8F21B227F13E0199@AM6PR04MB6326.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 20ndCROUFHVEWkhfiSkNxdkYeUYojWzMdeFkBppVCoPbKf/NWXGvDw5rBKlPXhzUwivWuKIel0A5GNMLzyFsc4O1S8pBWFfY9JwQgLexk/v0mJmjlXPSQOKfcMeMj6SqfYrkoxTgq4rZ+fTHPu7l024bllWWPiTpFLIK2McOY2g+KVV25cKVMzMTd2xxl3hEvDXuY05jmgSWUjMqsNxc3MrSs/GN/SP1tQ3DtSPX4Ev6+0x219jdC1SpZyo0VhgJY1FBiHq9aRLChovZSp8Xfjhj3ezRdJ+VN0KCLh/XQfc/OxAkvoIBeHffDIhpj4crUr7/DuaZ9HREIR/hwq7yfYuKji9o2BFeUnDVGzGNoQ2XjZoE8QCw0pTFGYl7KGrOetFcsc7L+HbQ+P1YXjiOXIIX7te3xY83xpD6332HqvBtfi1obNUEnwBa7tVgU3jSF3lu4sRj9eYU8uyveJKIqMt//HaYZnSoYK61V2lPyHgSiKztiVdU69qQdI8RVw7xHl/B9bi+n1JFPL9eegBxd/we17E2gQouey9JUolUOGCBmYPdeZs2G7e208EDtcktQgku4hLLAmLGrd5uUBOsmEyyUPDEGX7NNYC5dv7b0HSuYpZ/4ICKOGhxE3UKAGI2JtEC/qS2+n+jjD8DcuYDbwkiHODvtLqHmqrMPExDOwt3E+inPsyxPqRB+qhn0jIZ6cOUYNCZAEJTNuRmNiDcgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(38100700002)(38350700002)(44832011)(52116002)(6512007)(2906002)(26005)(6916009)(1076003)(54906003)(6666004)(2616005)(508600001)(6486002)(66946007)(66556008)(186003)(8676002)(66476007)(4326008)(6506007)(316002)(83380400001)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0Pd4xOiuERI6AHI9tWM9L7B4FwgfApq+w2obP3wnQb8iil2I2ynPt/zRPlEg?=
 =?us-ascii?Q?8KQb3TmJ/+Bk6hA8hv42zSNGZ8jhi3BvmDwpR5y6P6kZOfxebbItSXA9keEl?=
 =?us-ascii?Q?FS4OCVmtlYQ507cRXlxaOUjgjx78bQ7EM4ktCmz1/lqW8qYwhKkFgQyJ35To?=
 =?us-ascii?Q?pYQVFwGnJKNuWyc5p+smnUGBfK4TMcw5vW23I+VO+56l/Vf9wFuXXHRrJ+zJ?=
 =?us-ascii?Q?AXrdQLAgu4RRQufgTAMJx6lR9wsKsEHxDhpbA9JHP7leK4T96WzsBPdFFWri?=
 =?us-ascii?Q?IASEeDKVCRPpENpYzhiBukf+jrGiccLGwBm/qXLmGyCQ3c9kSNWA4MKIgDIB?=
 =?us-ascii?Q?6YMTJTKU8PrVRDV0iZgcckJ9qcEran+HXqmkKq6tdVLEnZg11K5chTxnzrdg?=
 =?us-ascii?Q?Bje6CBXLgFjWbbz1IBdM/3k3if81Zo6LBOPYKXdGSy8etS3DZQCZcUWX9c6/?=
 =?us-ascii?Q?vHAVGyzOu+8PTIDFJUKJ2Lb+Wtr12yz10XHRuneVzlvZrj3Ma8YnC96F0Lq2?=
 =?us-ascii?Q?+AianCfdnenDRNh8UbCdhRG0hL9ldr4rR7vUWwXPNo0MEtXlLDIs1860fwSn?=
 =?us-ascii?Q?6abk6+v1VKiNnG6thLsf8qgMk2/WZRDEoIeAqpQvBkpxxj6LIZsuvAItZf4S?=
 =?us-ascii?Q?s2gAUnrdAfxHd3CGgmL8XYU6GSifXaYiTnBbkUJi3ywyVnFExGE4efx3laHj?=
 =?us-ascii?Q?hJkloxHbh9mjTZvIGyOzx84rYXPHX2+n6nA9yovmJ+1dhSpPlsHDo1O0SZv4?=
 =?us-ascii?Q?vxVSE1PIt5IYYw7xgrmkm+RzARSEKeh74QijeJFH5aZaVyY//5mbdQRXuUwM?=
 =?us-ascii?Q?6L5tMHtsbjdua5ptRBsyKuSUSw1lHCyW5SmZnh1Ma0pyyjI40igyBnO4LkTr?=
 =?us-ascii?Q?rNVv0+2Jerpm643drtuvJkV7umX5Wf6bYjoJUsgbq8PbFpWqOTeXVWY8QdFF?=
 =?us-ascii?Q?aVS+gvjZsAAl7TBRIuFSAmM0twn4LoMa8aanZYnnpUf8eDbAkFfnV4Oxf731?=
 =?us-ascii?Q?lC5NJNKng3znbhX6gaBL95nwlURL/cDEPYNTQxzqAd2QGSW+cRsv4OSOl+vy?=
 =?us-ascii?Q?67i7je37N3yIGISl2ForlY1P5y0Y/OofBrGzSoYGLgKJ44nm7g4VXfhVLcfQ?=
 =?us-ascii?Q?BccrHU8U7ndelS5xh9HBKsgCCZfZ7CmrTizaRwvAZsULL4DvUy8timGS6w59?=
 =?us-ascii?Q?BlvuzRV2r/CykMx0NL0TPw1UXGNlOPMUWYc9BUi6KUBXwejU4GIqPO+rCK3U?=
 =?us-ascii?Q?QAhh+CIBX2MirbfvaiN0ILnQOD1meMCeJx5mZPWC7FVUKTTQ427G50PRajHw?=
 =?us-ascii?Q?QuawB+yoieYWJD3hJahMS0r1nmYbTzVm+wxkh09Y+8RpK/mZd9o8wivB5V8H?=
 =?us-ascii?Q?RRukSQmn+wwSCdFAA1DuE1oDfI8agIkvxVm9+VR5PgcMVNJDZjlRd8L4woUv?=
 =?us-ascii?Q?my0kb2fcJzFSCZXbQX4K1ftd59hLb+j08yeBaB5NH3Wy3+dxsZpzi1x+WmC1?=
 =?us-ascii?Q?Ymvo9lvQltbaki2tHlcdQoTl3C1xoxzFOP0RsireDJ4KprOPrDD1RoDQyvgV?=
 =?us-ascii?Q?fR2jA65d6nOCs5o94e0D+9Puk7PSw28Xmu49khgHAFRwJx++P8XfdcewBinm?=
 =?us-ascii?Q?OGRJ3w2jmHQrvh+p6Pr0Gqkz3rTfZx67EcE2dPg+oF2/vHNGupBpMd74zB5H?=
 =?us-ascii?Q?uC4XGrC+n+IuVKOpPaYvOPa3y/+3Ti+UHiWYi2nd+68LDbSVt37VjP+3dxV7?=
 =?us-ascii?Q?mVAtKl0qjYXdHP4Qtjeijer1ZU65joo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f389001b-7946-4300-272a-08da0db1140e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 16:12:22.9909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FpG1YKiqwfC24UY2BmaMDsDP4Wa+eFc6gG19pJzefhNX4nhQQJKfoUWlAJ8mo8jZAk+EHorjHRKsXWjxb8qT+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6326
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let user space properly determine that the enetc driver provides
software timestamps.

Fixes: 4caefbce06d1 ("enetc: add software timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index fa5b4f885b17..60ec64bfb3f0 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -674,7 +674,10 @@ static int enetc_get_ts_info(struct net_device *ndev,
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
 				SOF_TIMESTAMPING_RX_HARDWARE |
-				SOF_TIMESTAMPING_RAW_HARDWARE;
+				SOF_TIMESTAMPING_RAW_HARDWARE |
+				SOF_TIMESTAMPING_TX_SOFTWARE |
+				SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE;
 
 	info->tx_types = (1 << HWTSTAMP_TX_OFF) |
 			 (1 << HWTSTAMP_TX_ON) |
-- 
2.25.1

