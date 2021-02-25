Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E01324C78
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 10:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbhBYJIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 04:08:01 -0500
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:57269
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234634AbhBYJDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 04:03:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eCMOe9mcfOgq/nU9ExCqkCYqXurlI+NHAhLEbw8gdJk7s1PYjeubi9TJUuv59SLupu6gWrcgF58DP/p+L7JZPbcAvAmqXCh4GYIVO0iMa9tFyhHewh1xGOKvz41OWBbdCuWXdL4IBNjIFi9K2NfB+phJOhds74+P6ODMey7SWqQWZA1QYwt626l8xzhz2KoG84H9eDPnT8XryqGCJn0qtpEG2VR0+9NwDV+7tWHKISgr5RhDDYY/+4MSxHFADDA5youEa8WId++9t34y0Tj9H1AFTqlC6L+hcGOOHfLDezX3urFgDD8hJxf3Rnpy81P0xJRJZosH/sHdMF+hCpOklw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hemv1yRn6VRH46tZ1jruZaVIT7iNVVj2zqe0lzSWxYY=;
 b=JOUE2LZKcRtz7QGLhHei+WlP79dhUvPZvVqcn0Eprqi4fbiNFG6MfSSZKzZ6AwIYcUFCfKd9nE8oTSN9ZvYlBp8ygvw1jnEqiU4aEo5aB4VlqQguLa0XZbi5Qq/+sQ5fqydDWEgOAOJ9oJa0SJQBpcR8Lb8PfHLMNO4BgC4mqggOSXAEAY/NVmvJqhx/PRKY5x9z/HCAzqXBhSkXQkEzB1MV1hchwoELOoEqxMvvI/sq7+1Aoa5tI1X/turIHEfM8Bum599WJLIM+QAbqqzp3IrPXRK8S3wXY6HYbVI4F2XGEaZ+lEZoCvr6iSuJbTT8HbVb6iM67mivCuqjOweTtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hemv1yRn6VRH46tZ1jruZaVIT7iNVVj2zqe0lzSWxYY=;
 b=PCWnX2cwGznnid9SpzH8DXxNfH5gmI8H26UDn/eYCxG1gFyizHgrHuiwx+UkhR6xYG0CM9LVR2p+Wd/BuhGFd8LE0D8ZGyWNgCwOhfb+1IBufe2hBEHl9nlQ5EDX9ggPEwOl19oVsdZSqEEI8I7LMfqyUcsXnq2xqiSrDAkAXzY=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7430.eurprd04.prod.outlook.com (2603:10a6:10:1aa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Thu, 25 Feb
 2021 09:01:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Thu, 25 Feb 2021
 09:01:35 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V5 net 2/5] net: stmmac: fix watchdog timeout during suspend/resume stress test
Date:   Thu, 25 Feb 2021 17:01:11 +0800
Message-Id: <20210225090114.17562-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210225090114.17562-1-qiangqing.zhang@nxp.com>
References: <20210225090114.17562-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR0101CA0036.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::22) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR0101CA0036.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Thu, 25 Feb 2021 09:01:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f277a987-87c7-464e-e61e-08d8d96bf3d4
X-MS-TrafficTypeDiagnostic: DBAPR04MB7430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB74300730342685558D841816E69E9@DBAPR04MB7430.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2rgQa/AYuVCZUly8gHIDqi5KifaQ1aYr6doMfc7RakWdiwVHgSaZNA0vy3MdsIZYnwEVZkE/+c5svZf2z6KqftSh/woCmeYhciyiA9RQJrXC+0HwRhXjHRGRhEzJsBjffXllqchVLBlhDUjxMvwopq2NHftRnnox90cmc4cxy9uYnn22mSdn99Qq/6+tZJSj5hllmB5mvZbWsRlZOleseTa6jBFx92HBP0aAMfkEs6avnYUGOwGxhV2kbT7uaGZK62HeQJFXel6JHd9GjTHP/wdCzPk1wWyTXWbLMbA6pJYoBjF/U29Y5x//glXxdZ0ulik0pPJ/8EVXyTQ7J31SXnzaO5j2W8fKG0pMyh6MMVCfrY+nly3GNdET0D5IaJc2FUXbOnbtjWI1oXUQIdeYv+nKaUXK200jy1wVsFSBj1N92e6Unl7rm1z6sK4agHuwNpU/mryPpK4Nnw9R8lLG0xU/I45JbZ9pp1/3RYDJKJvvs+WUuvhrH8lNF/B7DNV/JF2g7NY+drQmdyW0vOnZQYy9S7ObQh56LNVwxNwzeg/yrcAcYYW5zpYU1MIMy3qXwEo5AOx6lvwZnyzEHzqA8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(69590400012)(2906002)(86362001)(186003)(8676002)(66556008)(66476007)(83380400001)(15650500001)(8936002)(36756003)(66946007)(478600001)(2616005)(6666004)(6486002)(1076003)(6512007)(316002)(16526019)(6506007)(52116002)(4326008)(5660300002)(956004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RGdxw/LtAWtysLkQ10nvM1IGMnpnyaOXA0hOyiFS+sCEqqr/SrmVUkvT44CF?=
 =?us-ascii?Q?2gmBX+yDCnkaf4vzzlrLZkH7GPzhwq1pKlqzRjjOFccK/HCoEDHA5Cqu2duj?=
 =?us-ascii?Q?PPenqdsev+kjC8HcCVso4ldw9571MAT1Am7fgqF6TXIY33TonKM5MCS6lr8V?=
 =?us-ascii?Q?BJ04Ghsf34fK0h+bpIS+o4KiHCPuJtv0WMi/tU2lPrOrn5v0Mw+blOXORqIb?=
 =?us-ascii?Q?SZseCMHS4YLYv96tGsvJUFm4oCbJuu1hGPIEtw19XuSQiap6DTJiVa6KKv9e?=
 =?us-ascii?Q?EwuU9P9cF270zevP+a+4sOSlAlTurnyDvTp3QmNWVrT4rF32W/fqasy9/gLC?=
 =?us-ascii?Q?jcgIRZw+FGjmNER0DmNhbgZ0UqRiRFS1G858XCjh/YJGWNAILWkAzz72dIuw?=
 =?us-ascii?Q?kWs5hVcUwtxGgan/3x7rEr2puAbKGRSoYNafkMrvpSlSy+7YSzLokwTTUnzR?=
 =?us-ascii?Q?/UZPysnu4Z9cFoNRzAm1Rb0qX2po6xQcuqnh0/6Deem8Yn6f5cc6sJtsrS7h?=
 =?us-ascii?Q?+QC1032LJpdd/062mwjhrZ7dQnK0+XQXt9PpjoAhoEJIub4eundA8Hs1x4oH?=
 =?us-ascii?Q?jvDPtu44ztIuahbOxodALPNzl72n6JV25x363Gh5WSJdfVhIuKyWpDu8vwu6?=
 =?us-ascii?Q?eEiNhbrVB0fQNzEUH2cVr8WKK2Ifff3QO78xjm6ciKvFDiYFRMihUCG4fA+X?=
 =?us-ascii?Q?mhbRMgbSl8iRzzitMIGBvWYzNuBl/a43ydNw/X5dJ8pwp42+KT4kzkzYGON/?=
 =?us-ascii?Q?r9oCRCtqpR1CeP4byuovWm40mV1gHt6TwIbBPz/XwKu1ywK1Pg4jpufKGI3T?=
 =?us-ascii?Q?Xp/WyLty03GY7ae1YUhwwZICmhMr+0STogHAMcLq0KMKRbEVKr/xIpNe/NdX?=
 =?us-ascii?Q?06RwdhvCbiSyTi89SNZdsHQ9YSXJlg2Vs1s1elRhmnTgZ8wc/EXoY0bWxuT+?=
 =?us-ascii?Q?fe28XMeEYACSoZ8YQhR2tb83jz7ioCDJwCekJ+wW2pFIfyC5enAmaUKVg5UX?=
 =?us-ascii?Q?NXlFTE4ama9toqoGSpeFNqLTohhG4ZMbOwvkuz1LmnJYugd+0NF732yV8s/C?=
 =?us-ascii?Q?WyxMd60uYcf/yyQlQ3ZR2UKSJrv8G7mS06afUY7hPnxjA9uE1QwXlR92b0Tx?=
 =?us-ascii?Q?NvGizeNwqhGaaDL31CWNB5cKl7QbsWIrRNvkNzee14waOSGwRcXva8ziUngw?=
 =?us-ascii?Q?AccaWq4Qwljl19SgRMg1XTki2Aa/T3TeeoSki6vcO4asRVliVXdZ2L6yIHlf?=
 =?us-ascii?Q?1IwxG6zczLg+CxkIPW3MZYfDlb6EAN8hln85Qn40QaCNeq+8wav8Db6xvFod?=
 =?us-ascii?Q?B/OriyVKUnGnxK3ckio3C3In?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f277a987-87c7-464e-e61e-08d8d96bf3d4
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 09:01:35.1436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JuL7ilwtieBFOup52XoWA03VUjJKbo5CCL8aaF4JURuUGRGnexEW3M7R32rdnwAUxVV7RrkecyKPIBWD5Hf1sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

stmmac_xmit() call stmmac_tx_timer_arm() at the end to modify tx timer to
do the transmission cleanup work. Imagine such a situation, stmmac enters
suspend immediately after tx timer modified, it's expire callback
stmmac_tx_clean() would not be invoked. This could affect BQL, since
netdev_tx_sent_queue() has been called, but netdev_tx_completed_queue()
have not been involved, as a result, dql_avail(&dev_queue->dql) finally
always return a negative value.

__dev_queue_xmit->__dev_xmit_skb->qdisc_run->__qdisc_run->qdisc_restart->dequeue_skb:
	if ((q->flags & TCQ_F_ONETXQUEUE) &&
		netif_xmit_frozen_or_stopped(txq)) // __QUEUE_STATE_STACK_XOFF is set

Net core will stop transmitting any more. Finillay, net watchdong would timeout.
To fix this issue, we should call netdev_tx_reset_queue() in stmmac_resume().

Fixes: 54139cf3bb33 ("net: stmmac: adding multiple buffers for rx")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 26b971cd4da5..12ed337a239b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5257,6 +5257,8 @@ static void stmmac_reset_queues_param(struct stmmac_priv *priv)
 		tx_q->cur_tx = 0;
 		tx_q->dirty_tx = 0;
 		tx_q->mss = 0;
+
+		netdev_tx_reset_queue(netdev_get_tx_queue(priv->dev, queue));
 	}
 }
 
-- 
2.17.1

