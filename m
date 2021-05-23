Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB7438DADE
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 12:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhEWKVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 06:21:55 -0400
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:54404
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231703AbhEWKVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 06:21:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oahOpe6rb68Z2Y3FexGFUH6aHMyHJoE6jaHvLd8m9j8A94u0Df/TlYbVHblnhh1bb3DcXezDJ2iWS7+4W30nGmAi4OyGxAYPQ3wRIe/n3cRi6MutguXVSoNF0zUfwp3vOigbwQz6jgfyAo7CfIbjyprBXj/hBeDJmZ/WATnwsjm/utAAPhTq6bLUuqwu1Nm4KKOpCfQ1CfIWHpwGvBP8qvT6+2s8U+JL3wwSRteRH5w47hezOYObWlnYWk4buY5HnHHIcHZcZINcBEg3akdS/uZW2cGYQWdYuLpeNwDxPX2FcRwoWjShBhvhrhan5elcmj8IeBtLnt1uuu9EgaGUYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bBCIJ7cda/IBtOcHDDluSjO9pf9rLPtStKrpsRoVVg=;
 b=WI1BJoBjyRD05j2mqzS/1q24gUVfNa/CHRhmifFxJurWX0Q1Iv5/py6pQBiKFnzh+sW+O4t+ksStOXe3KtZKDyPLb0KetAYUW6esZ2zAFqTE50qFfeumlVxHc7wU1LmqAwjdhjFkA6R5O5yhw+a1GGDqBD3xPwC5Xxtddny02qvphu182oGj1hQkdKZ3g21/YiXNxYVMUNwOfx74kjhFEnz1+tf9kr/PCiIG0BZn6ZPM64QixARzQYidy4FwNtNL1lcQ0QarvV8i3GS8i5YBtWFh3sp8KRUFLEa3m1WP84Wh4P0xqSztp2cf/q9YfCFudW7p3VFEZDkA8I0nsBYc0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0bBCIJ7cda/IBtOcHDDluSjO9pf9rLPtStKrpsRoVVg=;
 b=YANf4Huq8LBLLikxYkc+FrhDELAb9UQPV92zqyDx+tjU7PJuESO6FH9IX8b76qxyLzOEdUiEgeHAkzBaJ0h2Fvq3g7JIXpa81nb60G4fSk+BML+ShuAnASWRRTjbn1r5m0W/P+OICtjlxesKqg7vaUSs6fcDdFVM2vt9+YmhwA8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5788.eurprd04.prod.outlook.com (2603:10a6:10:b1::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 10:20:21 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 10:20:21 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [RFC net-next 2/2] net: fec: add ndo_select_queue to fix TX bandwidth fluctuations
Date:   Sun, 23 May 2021 18:20:19 +0800
Message-Id: <20210523102019.29440-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210523102019.29440-1-qiangqing.zhang@nxp.com>
References: <20210523102019.29440-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:54::17) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0053.apcprd02.prod.outlook.com (2603:1096:4:54::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Sun, 23 May 2021 10:20:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c276f4e8-b2b5-45a0-312d-08d91dd45f32
X-MS-TrafficTypeDiagnostic: DB8PR04MB5788:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB5788FCBB98EAAD4B2A679383E6279@DB8PR04MB5788.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rQH5Ym0RweE37BP9m3k2METtSOiXbi3gqlpT3R7lhQO3B7j+ax3ODfTTVbe+neDIY/Wrn6bm0d3vH6EeRtCZ59wwR19MwE3FnYahg7z235kGLqbf7iiO80BtWVOKhEMqsNckVzarH5pdscFMz+O226K0ru8z2oh/J5o/Tod73NZ6sYo1g1beqeO0L2H+doHILtV+S41tVBOMvEo9jTxcTb3HmkYZ04TxnyubBdzT0X9qH5h4nYF8Ucx1yM8HCuMeGW9S+8VbI1jhppLH0l1hjTBuoJzOQ+px+R/IIR5bLtBcMs5wyyydfzNQU1cEapvHr5998L0LoN/J0XQi4IWIqBb9S7Bh3BTAb72zZq4mFwhW++AcH1lFBY13ryfk/V6dtCWTbhc9HWOChGrNISzEQSkZ7sjUireK2ZMVdqjV7gqReQwaKhyt/Hf5IJrqLuvES6J3tS9EDHEZbitCWIImhQy31UsZykwyvKE0fuQZCM76uIJQQNjWbwyxYFec53O8bpJ8dCWUO9wAJVKFSR3iC1BdbzUljKINC3nxv9NbH4zdqdL/BugtUOouWJVzJuW/irANTnWKW964wqneE3r7CNQUa4bu6gkOGyQsYi762BWXknsNGi/dH5S/2jp9bO4TjpAG0LqcWxtWW7Ei+DLE5LRrZmYScaRf7DZlRVhiLrekeTTcv5smRXmXDQtqtZpE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(52116002)(8676002)(83380400001)(478600001)(316002)(86362001)(6486002)(66946007)(38100700002)(38350700002)(4326008)(66476007)(6512007)(16526019)(186003)(2616005)(36756003)(2906002)(6506007)(66556008)(8936002)(26005)(1076003)(956004)(5660300002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3fyUukgkoFVqEGuTrCW6FdsDOYswoKWJvFpmIcJwaNr0znCR6eR982m0aomg?=
 =?us-ascii?Q?/yD5miwBdScoBDo5Nxilc9k4Hg0BTPFQmowGhKLvqH2Pn9ykUnpq+vfDPapu?=
 =?us-ascii?Q?C3Ecze7D0z8dtkUSWNkiQHY8SlREF08zofiSBdoZeSKniOKUFhe4XYFm+ENG?=
 =?us-ascii?Q?+gUoQOgAsDuMv/QUInyLyRn4Dcl9IuJdz6Hz88EDh4ZWnLOfq1mq+GLaiGnz?=
 =?us-ascii?Q?iOHHtajTw/3dzc0qo7UB0gVPUqXNyOrY8jCILEYvObEsFsg/UCcdGQUMlQp4?=
 =?us-ascii?Q?ws/fDzGwAv/ukrEEZ6exeE2u5zX46tZWSubFEGx4ot+urKSJAxcmeJGLvcLl?=
 =?us-ascii?Q?G8wte064pMCj9O8lGsoRUoQ2HzHFRtuEL7kzbnwVwmdgWlQA7yjOUZ4LLpwP?=
 =?us-ascii?Q?htlAvF7bcNBbe4Qd8LSXvO24l/miQpeuOG84Ga7lXeKf2N1WoS7Uix3Bvs/j?=
 =?us-ascii?Q?6ERBIW44TONa0ErugIfXE6MPsk3LJrIguqSAQ0Rju/Q5wqjAwMcGQMCrXB2Q?=
 =?us-ascii?Q?yqrAHqYYz10U+q+N6W2fzxGfI0EIQ/MlrSJHpre2rFSGG7JOTGLf5vdB6sNF?=
 =?us-ascii?Q?yixLbzH1IazbEUYyFVfjHPLwDxTSsQ0LeuK7v+lVY2QgW9TaI5LjFzlvUAh1?=
 =?us-ascii?Q?/gWOic0nJk0S4yARei1LOyKe+pUO8KUz40U5ay41Z68HRv31qKOdjoN6NHhy?=
 =?us-ascii?Q?xfcYM4Qs8vaGKR+zQ4/PTYDRlUfKaI/iGtW79n3HINks5eVKCqHLWGJx7VEe?=
 =?us-ascii?Q?aZkLkzstmj9FT/88jVGq3LQESC4WlGtp1XKtcQ2BkQ3ojca9UgowA3Q1JqQg?=
 =?us-ascii?Q?edQaWA10LAOcYpfvq8AJ9VxqAX0ll0VjXK9/ZRorMbfj9CJru5yy70vtbTv7?=
 =?us-ascii?Q?CE9pfJD//wUYGPkmiQZI/e20n63gSiKKY3/vTaThlg5Yqjjo5rirXnScOE1+?=
 =?us-ascii?Q?yOIHiklyPQv0OLwI0QQ1E8BYzUJJx8Ht75wFKtEsFGfYoQe02bdIBsMd3853?=
 =?us-ascii?Q?oUa5ebLUnpGh3RcMfAPT8qC38uCLCNrFw4uz7nEUK+IXhJaUDfSpLNMuBZgm?=
 =?us-ascii?Q?4JOoKWppu5beB7FKEoY7VxMASKlN0ITMLDAMOAkJ+DO/kdcw7gwaH5qQxLv8?=
 =?us-ascii?Q?ZBI93ttBHdhU79eLQsh9WktZsa3jfkIUpj3KWUB2t5x+3+lh1QWJGNYlPHZb?=
 =?us-ascii?Q?TdT/Fmz74jxnhsSwWLOflM6aqmz9EAwhmmeCLnm80nZT1FZiazKjhDgHaQTc?=
 =?us-ascii?Q?yscLakP3GM7J3BWr5AmW4FHbVx5fFdvCapNfQG6hlo3lNQlZd58L1uo4NebW?=
 =?us-ascii?Q?YFqh4LiGZLVG61AjZyk3CKcl?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c276f4e8-b2b5-45a0-312d-08d91dd45f32
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 10:20:21.8765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 77zhp55H6z5BOZI8ROBrHotvL/dzG8mblYVHFPstw3oSBQzv2sY/lKf1RcOsjdrtyldsHzta7PgUZhbyPPEBzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5788
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

As we know that AVB is enabled by default, and the ENET IP design is
queue 0 for best effort, queue 1&2 for AVB Class A&B. Bandwidth of
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

With this patch, VLAN tagged packets route to queue 1&2 based on vlan
priority; VLAN untagged packets route to queue 0.

Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 053a0e547e4f..3cde85838189 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -76,6 +76,8 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
 
 #define DRIVER_NAME	"fec"
 
+static const u16 fec_enet_vlan_pri_to_queue[8] = {1, 1, 1, 1, 2, 2, 2, 2};
+
 /* Pause frame feild and FIFO threshold */
 #define FEC_ENET_FCE	(1 << 5)
 #define FEC_ENET_RSEM_V	0x84
@@ -3236,10 +3238,40 @@ static int fec_set_features(struct net_device *netdev,
 	return 0;
 }
 
+u16 fec_enet_get_raw_vlan_tci(struct sk_buff *skb)
+{
+	struct vlan_ethhdr *vhdr;
+	unsigned short vlan_TCI = 0;
+
+	if (skb->protocol == ntohs(ETH_P_ALL)) {
+		vhdr = (struct vlan_ethhdr *)(skb->data);
+		vlan_TCI = ntohs(vhdr->h_vlan_TCI);
+	}
+
+	return vlan_TCI;
+}
+
+u16 fec_enet_select_queue(struct net_device *ndev, struct sk_buff *skb,
+			  struct net_device *sb_dev)
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

