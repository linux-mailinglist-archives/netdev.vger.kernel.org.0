Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA3F29FABD
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgJ3Bto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:49:44 -0400
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:30883
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726156AbgJ3Btm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:49:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g64s0aLP2ojZ1JllpHJDS1WssNdZdKuhZbxExC2+DRaTb8WSCuAH6bqOWroXpfcQUmeAdwRSMSxb2Z2nL1HzZ3H439JiXQQffwlvPAgJF9eXvMrBh/BHsp4ml0TjbOJjbI2cJlcPLhsjl3yVUlD1BbiTMgjzjL3wZXJOL1/wEzBMQ86WnUuIeJrAC1ndTsTAesSSA0WDbsc0zhhWbuA1+JiQhrt2UmDi8emPlep2wmH38fzwBXlDAkDfSUZmbjAUG6qjsUkAUmyQU2USInJb4JdvsxFYMEBPbrM4hyWcIaEnw7J8fGRrPi/84JrT/46i11U9GooQYv3g/X1SVAmCng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUh0gmEZrOPV/0lSsvsGYcpJ8nm6HZCED9M4jEADDjc=;
 b=nR/U2CjVe31S9EBFqh86AkYeMqEQfsCV2YNetB/YJ7gvD3K2z/dHhmatEvvHMl5nSzB+1ehfnAqJQ8g5ZImg3wg8tZJSgaZ4Cj+glreXvPvAnnRCG2g2yyyOqimQaUI7owzqZMgrmmlH8/Wk3rESjvhQbWq7ZfUVGS82JJ88meLSHwHS8gRl6tuJzSIOR7JNip8Z4iPRj5QcSO5+bFpJ0Fcw+6Yt1/9sCMm7KfFtFD9rdBhvTGajs2D8vQGb2SnpE37Tdkw4/ALTI6uhPR4fCRA1XQr6K8fFF2S4jKvXeTYthw/wDR/2SjgiLlQSVulV0eGLYdnfdewdK7dVTbkF+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUh0gmEZrOPV/0lSsvsGYcpJ8nm6HZCED9M4jEADDjc=;
 b=hJEM1iV/9j4xJcCgpBSwYJfuw2s5TZ4W95ogmM0V7mHWRyVtajYlwxPuVe/1qs6D6cVIgwtmNxFMqF3NnFoItlSUj26ue1p15APgjeN62QJDSPSpOQf5NaFd0XETj225umWJHAYp2uuA/lm7N/u2IPHAU5sLdsJgO8AFTf6gJUE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 01:49:33 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 01:49:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>
Subject: [PATCH v2 net-next 06/12] net: dsa: tag_mtk: let DSA core deal with TX reallocation
Date:   Fri, 30 Oct 2020 03:49:04 +0200
Message-Id: <20201030014910.2738809-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
References: <20201030014910.2738809-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: AM0PR03CA0096.eurprd03.prod.outlook.com
 (2603:10a6:208:69::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 30 Oct 2020 01:49:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3f507c96-b515-4ab1-2575-08d87c760cc2
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB250931C90C9832567ED42390E0150@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TMtXYtnXgF4oOtQXjcLbhpuuTvNE0pVQ1g+HycszYYA/B6wcNzL79OqA3aryi+JAQ16SgZVCRZ3DBNdWSormd6/42n98/GnvbeO+Vbf+7ejavm28D+7/jWHCNUVelvHmQ/wo0Tw2yLnrsiYte/JSTElTgY+pnUw1co5+qGXZ+4X9HqWWiuPa8ahJPQOXw2NI/qL24hP/y/sXRzqv2UY0EHPhZfUwCRRZldmfGcF7RduBvsd7pAojlYezwGEPUcP6eyNOWG8SV05eIItOirDSd1Wh1FB+xqVRj6vAqDFIjZw3ZoqyaT0+YIlpDgIW8FdW+0auyURUVVGlD3U0DT5eJs3jpnNOeBDq0bftqobzdXdI5IPMqVMcBCsLrNjB2EBF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(396003)(346002)(376002)(366004)(5660300002)(54906003)(4744005)(16526019)(6506007)(66946007)(66476007)(1076003)(316002)(186003)(8676002)(69590400008)(36756003)(86362001)(44832011)(52116002)(6512007)(6486002)(66556008)(6666004)(956004)(6916009)(8936002)(478600001)(2616005)(7416002)(26005)(2906002)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vghsg22Dn5EtRaZzffSJ+I9WRVT+VASj5hCJLTVz0KzWszjTxiYFZ0JEmiPQwhWzCQ+v5M9QuV8Q8+tC751+wkCTR7yJthI59kEDSYvYBJ46zz45M7d+9PCLcA4dAAWT6tkC0CXBURlktdyBodZqDZzKyGMzWiHzF4o5mKm3l38tHpD/IczZ6xr5GbSCPb0uWUXxOReHFEbb/xPH3w6Au31trFcWw+CKJJTPuRJzSx6teIfjB1Qqo0k4GsZ9f8+4UCykyz3hK/o6pGGQe3LLxhqQrEge9e+cxMFxDjs8k/hm+wdcYbE30xGnnE1uZZ75J7KCHmRMUoB6Z4TIIjyaxl9YH+h9glh+037XWFJNM7i3Lj2o9PhxOCybt3DL/ZlFKjcn5NzrMW45I5BOqtbGPf6vlAjdyiCGe+7y5s96wy6ajt+9ia+Etw38b+0PmaEP/Ns/fmUdq5q37qMI0tDdzvp9lkmad2AMdzhnvwuV1oIdWxkEsXMDaDyaSAU3bxusmPbazkOjU9ZhRgit6nTwxNe6ak5Z9dqt3cWWrwrdPJUxmbN33J3yihY/aEhnIfYCsamvKumzKgxcSrTc/sIafsGTmLnIFDbJ9LXopyNQ9LleBsn+CDs1tIjY8fjBXYhrtqJSrRDRnSZDS9l6iQq26A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f507c96-b515-4ab1-2575-08d87c760cc2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2020 01:49:33.6959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lh1JaeE4LaNjrkpxifq0j8wODHXkPT1YSGNhXtfVlcolDu1eNDdPArUXj+DMdzSIT5yn4E6+jM2ZxRax7eFuwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: John Crispin <john@phrozen.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 net/dsa/tag_mtk.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 4cdd9cf428fb..38dcdded74c0 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -34,9 +34,6 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
 	 * table with VID.
 	 */
 	if (!skb_vlan_tagged(skb)) {
-		if (skb_cow_head(skb, MTK_HDR_LEN) < 0)
-			return NULL;
-
 		skb_push(skb, MTK_HDR_LEN);
 		memmove(skb->data, skb->data + MTK_HDR_LEN, 2 * ETH_ALEN);
 		is_vlan_skb = false;
-- 
2.25.1

