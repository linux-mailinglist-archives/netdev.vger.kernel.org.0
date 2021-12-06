Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F7C4691F3
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 10:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239940AbhLFJJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 04:09:32 -0500
Received: from mail-eopbgr150085.outbound.protection.outlook.com ([40.107.15.85]:56194
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239928AbhLFJJc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 04:09:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbJ1a0CBDodo3KkIWT/v20ja0pKyLfxYqos3SeDHyaXI8pjHtZqSt7vJSrImDE6kZWB9rCrjJqc7vZWpZCubfx6dr3MztSA2kpa4/s5ACPwV72M0dXpX84AVG6Lo/1waS9yNSvP9h/TNYGML36zBOnlYRJJxQnsdkGq+W+XeYBEN0ZYJUuDkjtbHvi+clkTlSsf+soOCG0PRN4/M0bcGpMnABb0k7okALdK0uxZKJHOrFilbTaj2gV5N7nMOKNpVEJarYY0APVuLLPFS/wRQY4+efPdP23J3EZ1kwrBjMx617QdXqP1bBg3+DQsB9bKMS8TxxRKWi/hRgCCLAqzQnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4xtqTgBIq1cN/KwONR+DKFc694QaG+fI5GilpKBq/5w=;
 b=AcDKfa5HpoFnD3tFOm380mxb+3NZ29OcSIeiyKctlP7NQp+sAiRaIXuqx6pH5HrPofoUYg04RAVR87fqIuOayP8+ETJzvndv2yhYfZz3IShxYBhHho8vKWzvDae81wRNQtF7B4S7xLAoo96eiBqUoLYzdGklw2kENDxcE+W1yakmlE3QbpW0Lkbk/kb9bf5SpqfdBilV0ETBlBsb93ZrSbC3ZeM+kwS+WUVSkbCHivKzd39yAmbmcfC9sWrbhn+zV5VOZQqZaRLy74c0fe7PUtVKGlTw0mdrIj3tZ8uExvi5X9wFJ1DU8uF8DrspztMjrZtONNzcy13/aJLN0WKl4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xtqTgBIq1cN/KwONR+DKFc694QaG+fI5GilpKBq/5w=;
 b=ZjKVBCDgQavjOdsKi8FI8NQIzoFSBODrxNi65do/bnVNi1zPUGxttIpcxm6QcMwC+cwohxyA/T1mKZI6kXIAWUAcNRLE6AI+cGMCvw09a2YEE9QQtNA/K26bqh5oHFS/VaeXvWnMXmR+EExDFbrA+4doXpFIdsEpsBDN5VFewsA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7836.eurprd04.prod.outlook.com (2603:10a6:10:1f3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 09:05:50 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::c005:8cdc:9d35:4079%5]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 09:05:50 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, nicolas.diaz@nxp.com,
        rmk+kernel@arm.linux.org.uk
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, andrew@lunn.ch
Subject: [PATCH] net: fec: only clear interrupt of handling queue in fec_enet_rx_queue()
Date:   Mon,  6 Dec 2021 17:05:53 +0800
Message-Id: <20211206090553.28615-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::25)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Mon, 6 Dec 2021 09:05:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b0af4d4-7600-4e26-903c-08d9b897997e
X-MS-TrafficTypeDiagnostic: DBBPR04MB7836:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB78367B83E26F242CD721BB3AE66D9@DBBPR04MB7836.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yo7KkeFeUDI3Vl24e3TVP3+SD5Kfh3ARrBzwRASLKpsv3gD+4yaLYCikC+X8EVAaRHFdzQiYipstYAwZ5TYQqIpXZ6X8r7wlqbWei7ypnRvdKyRGf+/QfjYA0khdZFmJR2w1gXrwggx7r6txXE1WkMKEqmeDg9zUUQcUsCmj+8huA8Ibg7LmZ3d0G9+qwpy9EDj2KUzFljeuyeOYMe//q5WI9Prtfhcb6ILnAxQpyL0T/OnqT1WwMSq+ozPAA9mool8Wcksjg3saYFNZyL2pTH7/zeI4i2Of4ytZIB7ETRb57jZ9JEOO/qEZcoA/gY1ExBJ830Z61SR3uZK3njDLUmk2hj9Gga4QTLfO8Q9145f3JiRs6fv4fEU1NZiUkeCWzdiCETVzaezDhnaT7LRSD3V1Ml63AprmKZ4eHp2Mz/kHRr6i6dbMfBZjT4j6OlL1je9EfPcu0PA/kEw+8v1ROFI9/Fk/gdXl0/oDhLFSpSFAi73MpPePZnqdYK29xf+MS+uQhkSd/INEE29TaoYFqMueXK67g6Ybw2QOfARHZsJrj4mGgs4vlYBjeNEvKzbtWY5uwPd1DXVh0u2tRj2zfHZtPT2FhnC5yo7W7VYv7lwdI9x45fMcfO5ZXn8d8kf0zqv+Z0bMJXLgnUyHoTDs16DiUBL38JzDd9znU3E+EyDIVXX2oBYkmhlICmwTEQft8RwVdfoETHDPqJsmPtxOvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(5660300002)(186003)(508600001)(26005)(8676002)(36756003)(8936002)(2616005)(956004)(86362001)(316002)(6666004)(52116002)(2906002)(66556008)(66476007)(66946007)(6506007)(4744005)(1076003)(38100700002)(38350700002)(83380400001)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vyJgvx+AkscH2Brjs+q2oAr9WN26YK1PXfNUJU+SaQiGlW0NmSpp3FxEYZ+S?=
 =?us-ascii?Q?dm9VzgBQtYH4DH5ijwxJp0TsTXwij6OPmPlZrybvVM7Q098gudMDgxX+I1+C?=
 =?us-ascii?Q?zjx/4TFggBfNPM6HxofLxxed5mlLZ/LYPAPIdKIMFwSGYui9sA91HW5rnNqe?=
 =?us-ascii?Q?xZjux+1KHJfHfufx1YDl4bm49BLKNM6M8x+mGWSXm6RREfqd57kjC0QX4sDn?=
 =?us-ascii?Q?aSkFY2XcjL2tUHPE31EZyiJpT6ZiyBH/Ly/3JgvQY9zj+9PNNDoeyb8QtKo8?=
 =?us-ascii?Q?RBh22xmbWl/FvY9AXqNulEVSXWvWQGrPC+Nr2z/08Z8FCPhHrk/L9/joe4zH?=
 =?us-ascii?Q?5ddCtaVnW4g1jy3ayySf+MC/H2tYCI+QllVfM4IWLOkz3FHMrdpS1zYteVlS?=
 =?us-ascii?Q?ZkuvX8ABms+4as9NM0ZRYsyd/h6MQwUDRtLmcWv6R7I96MJFFCwbGNp0IT5J?=
 =?us-ascii?Q?2u85O5JEmxKsYngSKPWpTU37gMg0vKMzgw8pT6ghZF5/lO5lSv/Qe19wilse?=
 =?us-ascii?Q?uat6Efbr+NWovlBoudLUdFU76RyPlhiBvygi8AwO6x0bFwe1yXjKlDND03LB?=
 =?us-ascii?Q?LFdtpJmHEQMprmlhm5mwrEMXn1Bp3zi3UbC7qUKu4uTfyDPVujwF1bFlFoRF?=
 =?us-ascii?Q?vcF9/KPgpEc6+MVfEArMne6fS/Es79XvqLCgcOyQx05WaRPpbbQjTK1wHdeW?=
 =?us-ascii?Q?sAu6xwK7lvBBDY5mWlM2iFRPTJCBh86uZc3Zp5tAT20XOYP7eGWcyYLW6qGI?=
 =?us-ascii?Q?0ML5rqdg4rb5svYy1crMznyPyapHyL7yUAIWImXw5hF+DPWuYkGem76NixNp?=
 =?us-ascii?Q?ao8LfSjddwL4Qocb+hQRRjKVDYUjbArUG6IdYB2CVUVaw8BM1TdqZN6i/Try?=
 =?us-ascii?Q?YwspWlyoY8EfOIeJCWbYTJXhZ9FBFeHZ3an4xxbEncah2dVZJ3y4jtvMgAq+?=
 =?us-ascii?Q?X0r06t9WbVVSd5s9L9kdAQzo6o8VsyEmBeHKpVJEOWYxfyztKRV7KVfYcV01?=
 =?us-ascii?Q?EJcLvbyvgQZcgIgVQBerzbPfPLFglbuh4ZMtbLURfmD6XD9Blpap4d+U2P6Z?=
 =?us-ascii?Q?IJE30V1l3XKuVPmMftLEJZJZ1XXbyqTMAtQyiphDzwWq/c7pGdyuiQ70hfFr?=
 =?us-ascii?Q?nX6JG5UqYKGDLXX0ObuaXJYo+sm071zo/ugHquHae+j5QKuWSTiJ5bq5HObI?=
 =?us-ascii?Q?6wk7RzVuksdXKVtVwDXhQf62R/jvY0yNQRDju+b0N68oVGjkKC47RBZXtCP9?=
 =?us-ascii?Q?b318Bszmt4HqHrr6Uuu2U0GyqhzHwEqLoruATLG1AaT8CgzZ3D0qLCaBx+P7?=
 =?us-ascii?Q?wk2c2D3LaifNMypU5EhlwSkLOnxD+9bx+Nr0TDosN+6/hOU9OsQoZsPwl5zh?=
 =?us-ascii?Q?duiVOp4t0vyiaJOW/rbho9jCGwX36Rp/ASsYjs1YFvCPOrbUxg9C8vK1/dIR?=
 =?us-ascii?Q?6/KzPD1v38GFyc+bWpAE9FKbeOK7+QuN+X5rV0Vn4rQ1ijJKBnz3LHID1nEm?=
 =?us-ascii?Q?GWutIFn49JkxT4LJpgqjgfc4xKp3f/t6ZwL5wjQ4seumc0ZAidReNEmGIC/k?=
 =?us-ascii?Q?IXp1mAvFSmeL5F6SYDW3VtJKTPXHVVwZ+bnJz8jgzrsdfRuDOQxY6e7eMj7J?=
 =?us-ascii?Q?CBDXQPPxWExTplZmfCQFuUs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0af4d4-7600-4e26-903c-08d9b897997e
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 09:05:50.7453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUtghgM0hQIyojs9CnikNouqVWQX9xSTJ/nzq17apo+JycJI8QFS/vXnu/uUY9PaP+ssRtEG3ubYIYX0BjpYHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7836
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only clear interrupt of handling queue in fec_enet_rx_queue(), to avoid
missing packets caused by clear interrupt of other queues.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 09df434b2f87..eeefed3043ad 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1506,7 +1506,12 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
 			break;
 		pkt_received++;
 
-		writel(FEC_ENET_RXF, fep->hwp + FEC_IEVENT);
+		if (queue_id == 0)
+			writel(FEC_ENET_RXF_0, fep->hwp + FEC_IEVENT);
+		else if (queue_id == 1)
+			writel(FEC_ENET_RXF_1, fep->hwp + FEC_IEVENT);
+		else
+			writel(FEC_ENET_RXF_2, fep->hwp + FEC_IEVENT);
 
 		/* Check for errors. */
 		status ^= BD_ENET_RX_LAST;
-- 
2.17.1

