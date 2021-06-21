Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8A13AE326
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 08:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhFUGbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 02:31:13 -0400
Received: from mail-eopbgr140040.outbound.protection.outlook.com ([40.107.14.40]:33280
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229918AbhFUGbL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 02:31:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8ghlJKlsXfzqPbHr9FOe4IcTBiqNfVsMZw4wFleMCTr5dVCCufDYnk+bct19+vUbmUYwjENSWvyQ+t6drC3eGRBR0duDA10kPoV/DBsz8WcnoYpYCvzjt//JgBBZyIepD1IMy8dxShkIPS597/aY8hLDrvKHrpBYciMaTCD30mm6uRD1Sk9cz5GuO3tSEZ4E0xLuqS7zcl3wp8x7sUIe7TmL2cbY5GTRQj1lxndbxGvR5v2rL666u+eDHNz1VexCSExiJQ82CV8yD3OvIwMUVUJswgYAtaHzb+0xcp7xeS5xMXZvmvm5qupRBiiQjdJbuZbhgr23cgNMutWhaB5vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ij/c4BMHC5yA75SWzXud2WwbvgL1bwuIbO3imqmEwIw=;
 b=fxukCvVVRRyVBNY0Sia8tG/fRmnYh81JqtaAC/ARJbTq7ol9HCzL6FTljTMgGwk1wIoYhpnhc1zJY3ZeOzaMsfMYkprIJlEx+Em19VCb1CeDAN6qltgkR8nVWyCoNUiigvrSXwqkcwncZ8TqDSKlHwgnIIgQH0bEo0YnAbNLSSpq0ok+HZzrgDEU3OldjohHruDPl5QtdMUBh2vyPQEkwKa14va8RN2KbzwYijQqydKmEUSy9W0PO9e8DuZ+BA72LmYFUbJpt4t3bsPu7OGmyZPHvecHhsUTF4vMCLACwdN6qEtCpxvmC3UdfHRS9x3wEE8X0rRY1F8yRhZB0gOdCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ij/c4BMHC5yA75SWzXud2WwbvgL1bwuIbO3imqmEwIw=;
 b=LCOLu3WZka23k8fz+jnGOm5VrmRCNBXWPWbkXk5Lf8sKnpVhj9q2DWyKP9V4DNpHAQyHl+ZQLaGEnG8lQ2GcSkpimUrWpSseN6AxRoWaPhuFchNyleJ/Frvx2rhR5di5XzJ6i2gsaF4H8SNZh5WxtLl++ds8+lJgQnYl6RyZnZI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5883.eurprd04.prod.outlook.com (2603:10a6:10:b1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Mon, 21 Jun
 2021 06:28:55 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e%8]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 06:28:55 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V3 2/2] net: fec: add ndo_select_queue to fix TX bandwidth fluctuations
Date:   Mon, 21 Jun 2021 14:27:37 +0800
Message-Id: <20210621062737.16896-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210621062737.16896-1-qiangqing.zhang@nxp.com>
References: <20210621062737.16896-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGAP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::14)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGAP274CA0002.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Mon, 21 Jun 2021 06:28:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 558cf420-4429-44a4-6649-08d9347dd85c
X-MS-TrafficTypeDiagnostic: DB8PR04MB5883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB58836848AF3086F90844477BE60A9@DB8PR04MB5883.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eet8/KF5J6sIvt7quWs7IeljrgjLVBUoobMutEMiLrRh/Gycn+MpGjYtTQt7DwJA2jMCfGRw1Zp0wSdpXLdscfIC3SNMCKzsD64y1melK41tReL55Kqab244wOTLkbG81941HAwaFEQn8iFt+OO8Sci6bM6ol1JajJvosym0VXnVbI4YJ0MCf8C1ARkq64FKAnx3hO9l9Pm0NqZvHSdc7YejkVpTQDhch/U+UbXxmZfL0djZOT0BbtDNfmDaOgoqLFagh+FaoOBZdRCrhpTZw7+41yWdtLgqRtJ4Oa6+NBjVzerloOz86mB7HGcPQwIg8GDHp2uihg1RR2mlkYwCwcxo9oUioPGNhx8H2MPAX3xzkkJRkcnyQOSZqL9HnrS2MA8uK+75Lrf9OUaGpIfY2iUcPUT9Ykmr6GL1UucwJEta8rhy02B0MIHSTJpwq/0hMfGJb2Zb9TbCy8aPCWlNNSUQsBBtvazQ17FrX0My4LZ7ZTPAHFYK/BszdIDrB4tGTSGsh4H+vKIRgmIJyjvTwITpwfID2gBI8lGMk6x5vqoBm8Ituy0GB4dJc6TZjFCJTNBinWgiJawNZ1o6RUmhVzLLErirneJJwR3hJQ1r7KZLAniU6Ol6dO7pmHhixwa3WgF3iunjEZ9Dok09WEHk1GurYB+BztvcHx6I93RtkgOTSP2AitLUbsW5iGgrJi4U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(66946007)(66556008)(66476007)(36756003)(6512007)(956004)(2616005)(478600001)(4326008)(86362001)(83380400001)(16526019)(6486002)(186003)(6666004)(38350700002)(316002)(5660300002)(8676002)(2906002)(8936002)(6506007)(38100700002)(26005)(1076003)(52116002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nf6kSvJS0CXEMKIztblVNH1Bkn1KrWW+w2AuutHM4Hp/jgXv/NJnJki1FYGu?=
 =?us-ascii?Q?nixcVbJqZQ3pzZl/9tSZzR95N9vF1oR5Hs+IasZZtYL4ybDK/9bgHtyJv8Pg?=
 =?us-ascii?Q?brYY4RItzjkvT4U78MKCoGQOoZ2nXLDRLaUW48+MDFsmkZeyhe3oWNSQg8cd?=
 =?us-ascii?Q?CQRMyiUhtG3RNeARLhRPq4L5Qq6LcFoflH/URj8bGZ+TsLVAihQt7FRY5Wd1?=
 =?us-ascii?Q?pCm7cnKCzjK8d0o592rUqiBSMBXbUqRpB44e61gm1FtRFre0+tpNG4XQmSTg?=
 =?us-ascii?Q?PSIEj4EBHJfATTL5z+EzdcaM4VzoAkViNp1oG2e3mFnPyCfkmsD0/3hsiTUL?=
 =?us-ascii?Q?RV8e/BgIJYly3S5Sc/9fHBI5r188ly98FxJ9VcMqI4/JUiSLwuSTIhjheur7?=
 =?us-ascii?Q?DpH8K1GFLrRY/ZTDCLjghq5K84DaWautTNBt8nsN2yvhmV4+j6sEy20kqASu?=
 =?us-ascii?Q?x8XgSLWI8pudtQ8JfvctNpv2++DwWYCv+qhsnyoi/aadmPeZB8skO2PUyAGC?=
 =?us-ascii?Q?oVtuL2NeW+bMhDC3oyfONuuSfM1Fl9MUm1NA5NVGAS+1qSROZpQsncJqKvwt?=
 =?us-ascii?Q?k1bYtUtq9YNg2yX/hn2BBbVdVASgxaSyygg7ToTdSoH236Jol7vkNXyNBska?=
 =?us-ascii?Q?Ln+BEsBTJ6hBQdIw1bCP97zD/4MmOe6nizCsmChtAvc5UvyWiBqV3/hReBI0?=
 =?us-ascii?Q?0uHOk+pVrbrC89dGYmORXS2a1i83zCnX3sYf+jHWKJtqmYiZ5KPIAvSonELO?=
 =?us-ascii?Q?DAqp/gPmvE83hB6E+W0nKxOiHQqsxfajk1GhD4dEDkDOiC57qVt1eiWYu0dn?=
 =?us-ascii?Q?S2WtzKwy4scG7rTlXJrE9njK8A3ZvaFjh5yeIOT9EjDMUYQOGl26mAj76XRq?=
 =?us-ascii?Q?ASQ15yRLBvV7EKAU+3MhX1pAb1A1naM8dvO/pFzavkMocrjxnS1xnjcvAt1z?=
 =?us-ascii?Q?2l7iSN7DcMjC+3pcA4ZzyMiLjnVOD/kabfWocszCt+UpjE+dkfCIolm+sdHQ?=
 =?us-ascii?Q?CMlRyfs99tATfsu1RmX9kqBkTxY8rTRakeTmWjpphr7Nw97ghDmgCwbR/YBY?=
 =?us-ascii?Q?9q4FyLzLp8bTdv0iTYAI6JAYLfAit78PHgEWYRej8xochQHUu2oFTEdmkOJ+?=
 =?us-ascii?Q?rAYk21Oi19JBc+maCoCyuKScoCUR9tFO66EqXfE/I6GtRS+p2Xa1QUiYHB9Z?=
 =?us-ascii?Q?txPIPpGK6B0VS5+rQ9HVbW8SsIW3DHAzXWh9cskBzLCZAkYue0ZuV7l/KhXY?=
 =?us-ascii?Q?Qe3S3iZIsQq92phK8m180ps9LwThsDNu5YsT6dI2ckfs6ZnzghGSe3PkCoy5?=
 =?us-ascii?Q?4O64iCfEmudB1zNrPV60UvqP?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 558cf420-4429-44a4-6649-08d9347dd85c
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2021 06:28:55.6629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XniXPoeqxZ9aEeJqNVkidCv6u9fIKjqK/BzU9QAMoB83xZBZc5llwXRHnUTrdxflwmUitzEwO/XcmPLz7ibJ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5883
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

As we know that AVB is enabled by default, and the ENET IP design is
queue 0 for best effort, queue 1&2 for AVB Class A&B. Bandwidth of each
queue 1&2 set in driver is 50%, TX bandwidth fluctuated when selecting
tx queues randomly with FEC_QUIRK_HAS_AVB quirk available.

This patch adds ndo_select_queue callback to select queues for
transmitting to fix this issue. It will always return queue 0 if this is
not a vlan packet, and return queue 1 or 2 based on priority of vlan
packet.

You may complain that in fact we only use single queue for trasmitting
if we are not targeted to VLAN. Yes, but seems we have no choice, since
AVB is enabled when the driver probed, we can't switch this feature
dynamicly. After compare multiple queues to single queue, TX throughput
almost no improvement.

One way we can implemet is to configure the driver to multiple queues
with Round-robin scheme by default. Then add ndo_setup_tc callback to
enable/disable AVB feature for users. Unfortunately, ENET AVB IP seems
not follow the standard 802.1Qav spec. We only can program
DMAnCFG[IDLE_SLOPE] field to calculate bandwidth fraction. And idle
slope is restricted to certain valus (a total of 19). It's far away from
CBS QDisc implemented in Linux TC framework. If you strongly suggest to do
this, I think we only can support limited numbers of bandwidth and reject
others, but it's really urgly and wried.

With this patch, VLAN tagged packets route to queue 0/1/2 based on vlan
priority; VLAN untagged packets route to queue 0.

Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 98cd38379275..8aea707a65a7 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -76,6 +76,8 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
 
 #define DRIVER_NAME	"fec"
 
+static const u16 fec_enet_vlan_pri_to_queue[8] = {0, 0, 1, 1, 1, 2, 2, 2};
+
 /* Pause frame feild and FIFO threshold */
 #define FEC_ENET_FCE	(1 << 5)
 #define FEC_ENET_RSEM_V	0x84
@@ -3240,10 +3242,40 @@ static int fec_set_features(struct net_device *netdev,
 	return 0;
 }
 
+static u16 fec_enet_get_raw_vlan_tci(struct sk_buff *skb)
+{
+	struct vlan_ethhdr *vhdr;
+	unsigned short vlan_TCI = 0;
+
+	if (skb->protocol == htons(ETH_P_ALL)) {
+		vhdr = (struct vlan_ethhdr *)(skb->data);
+		vlan_TCI = ntohs(vhdr->h_vlan_TCI);
+	}
+
+	return vlan_TCI;
+}
+
+static u16 fec_enet_select_queue(struct net_device *ndev, struct sk_buff *skb,
+				 struct net_device *sb_dev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	u16 vlan_tag;
+
+	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
+		return netdev_pick_tx(ndev, skb, NULL);
+
+	vlan_tag = fec_enet_get_raw_vlan_tci(skb);
+	if (!vlan_tag)
+		return vlan_tag;
+
+	return fec_enet_vlan_pri_to_queue[vlan_tag >> 13];
+}
+
 static const struct net_device_ops fec_netdev_ops = {
 	.ndo_open		= fec_enet_open,
 	.ndo_stop		= fec_enet_close,
 	.ndo_start_xmit		= fec_enet_start_xmit,
+	.ndo_select_queue       = fec_enet_select_queue,
 	.ndo_set_rx_mode	= set_multicast_list,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_tx_timeout		= fec_timeout,
-- 
2.17.1

