Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD8E37B43D
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 04:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhELCpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 22:45:25 -0400
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:55840
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230129AbhELCpW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 22:45:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+m6QGIZkOfipaTSAcV497WlhRHtxElsMEch7jdbxwyhbQTjLWkgV2at1OOvWy0CpEvoeJuNtIc7Iu28lGwASzVH7w9+v0uenVm9HKcFCbcq1RZV84Xn7cnl3dAu+Ei9UKnixCRuxsTd170vjxMF8iGE+6+ZlHdhWtZfyqtSSI1PD1oa9qjLKwOa7MoTxCnLN/wkX7EaMMmnkbW34PdC8fTjIDIp32UcIfCT/5Jg6Pt02dz7dNCm+gI/LYA8xgqTZTzOX9u6ZnCWPH74izSpMkcoif6V7DC/UvfaGrZgFB0LlkQI6pPOUEj+jI27nZOPK7P7IdV92UnWhcj7pA8FdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mKaME+Pz8pAscmf/yjN1bN5qiF0Xdis0xEq7Qe3Lt8=;
 b=h7Tv1gDsQ2UCx9esWJ1kn5my1vJl2qeM6YmCtKgWGgQ9OIcVMrf+dAypiABpGlejOmm6jVErCeuV2BAfowdOz5/rPgocL3vfe/rmBHOAMASa7QIdz+7LMVe9vQeIHbTVaGkISG3IX7/x4hPvvw2Az3DURvJl8XWXhzGKbm36QwGy5onKZV/R3SWS6gu9hOgCLzp1s6PRA6QhTnSByFvx41E/mGLMt5MbGpiHdK+30Dv8CGkaZ/jhQjoQvvUx4TPcOaCR//TmI+HgNhlA7bqf0EU1GErL+wy/bKqRAjN/t7uLmBshNTbonOP2iLSUINopnNbNpb4KHyLXikXN5OYCHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mKaME+Pz8pAscmf/yjN1bN5qiF0Xdis0xEq7Qe3Lt8=;
 b=EbfQ6u2X0GW0PqfDblJud4rhG0unonFz8vjwQ+IU9sOd1u/4+TJKMX8+OUv2sZ36Wt2BtRn1T2d2rPfbNTaeN10IU/v3upglNmzjXTFjFoPvrJ5o/hVNDz4IoJaHGGlgYYfMvNT4bgO8MpRvuufO4rasODu4ngwO5lawaCksXE4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5884.eurprd04.prod.outlook.com (2603:10a6:10:b0::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Wed, 12 May
 2021 02:44:13 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4129.025; Wed, 12 May 2021
 02:44:13 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: fec: add defer probe for of_get_mac_address
Date:   Wed, 12 May 2021 10:44:00 +0800
Message-Id: <20210512024400.19041-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210512024400.19041-1-qiangqing.zhang@nxp.com>
References: <20210512024400.19041-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR03CA0095.apcprd03.prod.outlook.com
 (2603:1096:4:7c::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR03CA0095.apcprd03.prod.outlook.com (2603:1096:4:7c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.12 via Frontend Transport; Wed, 12 May 2021 02:44:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5b52fc9-ce79-4485-e9f3-08d914efd402
X-MS-TrafficTypeDiagnostic: DB8PR04MB5884:
X-Microsoft-Antispam-PRVS: <DB8PR04MB58840384BE7471F4CCBAC302E6529@DB8PR04MB5884.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nSMBxuPk7dYOpxTpf6mXiugjV8GyMCd/GeWqkrqlHQvEmxG+MbqyTKYlFgqLUiKSKOCTC+UdCapEgqLFNx6RaOKNwvvl1zedYe5Gt4A9Vco7bSSiFEpKVMqxfzeFb89j5ajfKyUQTQpoVug4c491WsUbvEkCrjCaaeaIvjLj8WYeM4/gDR+KiXcs2Iof3GVitKf9I01Zlvp17rzFWZv8RWkIA58LUeztxyL4Gsod+fOoui4cMz/z29EV0CQmV59Z04ZxH85OQRk1oQaR5iniOI2xOO0tJLb69IYVxurFkfzaf9H4QZpAb9ola/41UQjRgrRu2xTqwFz7Jw8nB8QTI25CIGEkPJV1iLb2lCEDaW2PlzBS0XmmqUVgyWEK1Uu1DV2GJ6VFeql5DqOh268mWuL61uG7H2azeJhFURAPc6HdyIY7vRvBBt2lSg+SojYpN4EBj833X5VaNFkk4I7XpaI9ta/3gVei47zl0/PPGLfx+B3y+VKV8s/d/wbaYBBCfjjVtedj1OBj1952BXhqHSHn1M9KlLP2yUoHxnvGZTbGJMqpdJfsDH2m5nzyZnnNdV0Sbyw0bGNA1iP7Wcf2oUYBM5J/QZspGXeQ3/SwcyXPiHEqMYd8+DFNHMEY4IXlCad0NMalbkeBQ72tVUiYZ2eCuSJ388U/tRb7xDtibquSAAvV+kK62VjpNZzhpte7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(478600001)(2616005)(52116002)(8936002)(5660300002)(86362001)(956004)(4326008)(66476007)(66556008)(8676002)(66946007)(6666004)(1076003)(83380400001)(6486002)(186003)(6512007)(16526019)(6506007)(26005)(316002)(36756003)(2906002)(38350700002)(38100700002)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eNayRG1yPE+zGVEyjg8XXJuPOLPnU8NDS3DmtjS1tjsCMyUunfmLLW1nZBuK?=
 =?us-ascii?Q?onrR56NJ9943DwXVBexKCLV3kSxGzk/jxAXzcfUsX9I+d2LQcQ9EPeup0Jnq?=
 =?us-ascii?Q?kVVaL3siCtPz7zOWBqZ+yofkLQkWXplZ+3QnGyN+LgDzl1Jspp/KoRISCQZd?=
 =?us-ascii?Q?G6/iKqfcAQnweGrRaQFiw1mcg457O/uS14nsoS9npFhhzCiPQoW0CGxNE5RS?=
 =?us-ascii?Q?90ylXm8madvDNw2e8jd72vazVtH+0msAcRpfD0dRsFnGJLm0I+WDsab5WkQZ?=
 =?us-ascii?Q?I/PFTGSXJ6BHthn/wp/TL10r/Nd83JM1vm5UEkf8jd9wrdH0kpn+dnS6s2TH?=
 =?us-ascii?Q?enmarcyr4H+QsCws2KCjaasGWeJWtQZlxFFYiozRxcL1gI81O0T2DvlOONLy?=
 =?us-ascii?Q?e419+kT02alw6g/gVYaT43QHYZjzDTKXWL25r4DeuopxKIuNYlAfdIBnk3GR?=
 =?us-ascii?Q?UGkzUP10FBiuNIjf7Fr/SvJHS15jrh2X/ne4pDI5wRlHcsCZS+UPI8Q/ibpX?=
 =?us-ascii?Q?AMZPr5ouoIooDbw20PsHZOLHY8WRvTGnJg5ItmviU/K1SQCq4nRPmqND4FYn?=
 =?us-ascii?Q?lqBMSPylG0CkeWtrUUaOzvJsYurvNd6P/dPhzw0rI+brJxIicfHF0CI6qg5i?=
 =?us-ascii?Q?mXgfXCnPZV56fyBIP7tJhzd6xdl2Uj945dYx4BCb7TbPcJCkrgm5qZUIZE50?=
 =?us-ascii?Q?pRyMEMw/SeU2D1cEFjBp0ikkhpLJEK+GcFNTCLVTSiZei3GhA7P4PnQiFno4?=
 =?us-ascii?Q?laQ6/LUrRODAcTtNKf/d4xAOEunRd30r6HdoiQqcg1SqPz77+mMUn/asTCr8?=
 =?us-ascii?Q?ZJDpahCxKbZ8hXnEB2fUvqzT+UT8+8H1wHDUaeRWHrMdWaxor6tJrEqBlzBR?=
 =?us-ascii?Q?66QMDtU+tlASKsUtsaRd/6RVPxplxQ4XXF4iqrGVPE8PSFqPdIPXw2sZGIrB?=
 =?us-ascii?Q?A/BeXMIjHE0988jTF6zxrr8W4UbRkA5Jbb3X5Wm8WxfV1XS4GRtei1SKbMsO?=
 =?us-ascii?Q?fIS+ocwnp8OjyqaeXgqFGIxPUILZZnCJ5xt2UXHRDhW1q/9Gi/w/XdKVdQxY?=
 =?us-ascii?Q?yVW5eZ98YKoGj4NWF49b6DLqnLrg73YXv+1H7HTU4W9RzGQi9BAqcJQ9hqVY?=
 =?us-ascii?Q?L4sfSN47hGyJjKYMYk4Hz1E5ARB6EJ5j31NjFJIN7bTPFmNc6PyjXpP8oALG?=
 =?us-ascii?Q?eVtKpzcgr1MfRWRPWgjgX7J42c0ZAlXTtqQGt9vCVrw8J0OyzWWXXaoKFsUl?=
 =?us-ascii?Q?BJC4hnfa9V8fB9waybgH69QWWdEoI5I0mYfTfI0XA17TXWg1pcx2r9Yrd6/m?=
 =?us-ascii?Q?uVqe9u+cYCwhHKs18RPW4mfm?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b52fc9-ce79-4485-e9f3-08d914efd402
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 02:44:13.7809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tq0mA7GC6PLOVoeon1ZTCCPpGzJJCxVYLou4OM9KHLUDfUspdh7/IWuJ3JQxn3A9bzXo1iFvZX2j0Z81/2gxJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5884
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

If MAC address read from nvmem efuse by calling .of_get_mac_address(),
but nvmem efuse is registered later than the driver, then it
return -EPROBE_DEFER value. So modify the driver to support
defer probe when read MAC address from nvmem efuse.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a2ada39c22d7..ad82cffc6f3f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1662,7 +1662,7 @@ static int fec_enet_rx_napi(struct napi_struct *napi, int budget)
 }
 
 /* ------------------------------------------------------------------------- */
-static void fec_get_mac(struct net_device *ndev)
+static int fec_get_mac(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
 	unsigned char *iap, tmpaddr[ETH_ALEN];
@@ -1685,6 +1685,8 @@ static void fec_get_mac(struct net_device *ndev)
 			ret = of_get_mac_address(np, tmpaddr);
 			if (!ret)
 				iap = tmpaddr;
+			else if (ret == -EPROBE_DEFER)
+				return ret;
 		}
 	}
 
@@ -1723,7 +1725,7 @@ static void fec_get_mac(struct net_device *ndev)
 		eth_hw_addr_random(ndev);
 		dev_info(&fep->pdev->dev, "Using random MAC address: %pM\n",
 			 ndev->dev_addr);
-		return;
+		return 0;
 	}
 
 	memcpy(ndev->dev_addr, iap, ETH_ALEN);
@@ -1731,6 +1733,8 @@ static void fec_get_mac(struct net_device *ndev)
 	/* Adjust MAC if using macaddr */
 	if (iap == macaddr)
 		 ndev->dev_addr[ETH_ALEN-1] = macaddr[ETH_ALEN-1] + fep->dev_id;
+
+	return 0;
 }
 
 /* ------------------------------------------------------------------------- */
@@ -3305,7 +3309,10 @@ static int fec_enet_init(struct net_device *ndev)
 	}
 
 	/* Get the Ethernet address */
-	fec_get_mac(ndev);
+	ret = fec_get_mac(ndev);
+	if (ret)
+		goto free_queue_mem;
+
 	/* make sure MAC we just acquired is programmed into the hw */
 	fec_set_mac_address(ndev, NULL);
 
-- 
2.17.1

