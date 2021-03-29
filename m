Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFA134D227
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 16:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhC2OKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 10:10:41 -0400
Received: from mail-vi1eur05on2085.outbound.protection.outlook.com ([40.107.21.85]:61377
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230167AbhC2OKO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 10:10:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q+kTP6nbbndTuet/Q4AkvF0JUkSIRSm+WvS8vERBQg5/Am1Wy14MKWvzMEuhDOLS7oHdEd7aTmylaT5pEYqzLlnvhnVy+TaD1249in0cAPSoXbScRhlS+GIbkqFgUPDHTYbCrIAINC/SpccLJi3JC44G4053DJxYvsLfUUkCTBweHUEJ8mjDvyId0izb0nZ2067qla+pkVSHjow6CmmOEwmasPKx3n048QIswVs3cjxq2rb3h1B7z7s/UYlUResggtIdHPZ2dSA81F7qC/CEyQP7kSBywOXuCwvdvDPyijcFJ4n6ETCa8frJjasvgMubWeqNLeB7LAv5WNkZGlFZlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2oSelr2zldtJvn3o26gAimtgLCmnMqhou8jW9XCWPg=;
 b=g+vU5inPnLGNBFD3Qq8RLcl7GLNRr22d1YOelDapbTN0PAtw34emfF03Ibr5Q0abgducmNlcXApsSIjlkOH+9XJhcTpr18n9QCTsw2mT2QsU4I0s4xmA2f5IEquzZBm0RUX0BUvhcNHzWp9vkq6eoISLzk0O8DPLZShN9/E2FVbsXP2bfrp/5ZzPLP0zyW7re3cvgeGi8hc6QV7TgEiXK40p8jX6PvF4RARp02Sf5wFZjbZPcM7YS7o/DD0OLb6oo2bwlNEjJIk7Go5zg/3KIsHy4IIYDXuV4BNEyP8aKemX20x/Utac12DJfStk0fSF9mWUbMUAOpzjd3RVZKMU7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U2oSelr2zldtJvn3o26gAimtgLCmnMqhou8jW9XCWPg=;
 b=k3Gs/IeumBTQSm4deDbSgEALE9IaTj2m2IMX0J8yQ895eeWK9QyEjldZGkebLIyURMdhd0IJ+eJCdzHd9KPZ65W6+C2jJpUe5ggAby/ukKgp0TQwGWqPIbvl5WKo/RXpI3ezPjHMqHMFUqWMMXPY/ZK0R05L7ocVYXY5dvtGLrE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR0402MB3666.eurprd04.prod.outlook.com (2603:10a6:208:12::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Mon, 29 Mar
 2021 14:10:12 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::542d:8872:ad99:8cae%6]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 14:10:12 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net] gianfar: Handle error code at MAC address change
Date:   Mon, 29 Mar 2021 17:08:47 +0300
Message-Id: <20210329140847.23110-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR04CA0134.eurprd04.prod.outlook.com
 (2603:10a6:208:55::39) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR04CA0134.eurprd04.prod.outlook.com (2603:10a6:208:55::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Mon, 29 Mar 2021 14:10:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c6d8fdfc-6b63-4fc3-41d3-08d8f2bc5e1b
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3666:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3666981CA820060873CBD8D6967E9@AM0PR0402MB3666.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iN5bm+QK6Y1cTT986KVaN45yxSln0O4wbMHUZZ3yDnjwzqP4x8wAEvQpvrTmYGDhWGzdfcNlCXNJxJG4C4ShUYqphXlfJi7F1CLFcNBPsa1r3IVHdWmwFDkPaJkE8ow7pekeOHrI9IwFeIqqKj9ZMcl+S0hh6NLyjBMD3KmdgWD3ZBGyb4RXiTyWxB80Hirnf3314groc5Gvw3yHXtgLPBWxx+XSaDc2J6KPDvMdPwC8S3jtmwN24SqX0Pdi7CnCzAuPKxbVluMsU+EP8c/cRMHiUA2nQrtKd86WrWMOi9b0DmuyZaETr0TrnIi6m5IeEW30aAcRoqiPYMhLIR1t0N/y+fODu/+FAU0PWykVAZEsq3+iipz9y8P5Tyzmi1wfOme+0wCm1p/8wROP7NE/xtCYmpCc4dHEw8304rtQdYOL7/mHmmne4KBGa8eAW0Q/+x6Jvtd0eWFyDIZpzNH4kU2dEnuVfSHebUsFnAhMJJV+yqoe+PeB5jne0aTIStiDr8GuTwuvZ+DFHZxhSWQSaGAXq12xKHLlAeqkhckOuXy59mXD2++Poj99+WmIpDqCSGn4Jh0XCqjTbSS8v+AiKdd7fMByv8nttH+f8gzT13NMvK2ZLUOq1wOqbHIUplUVU/6Yj7q1QJaEHGJq35ZzjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39850400004)(396003)(366004)(346002)(66946007)(66556008)(66476007)(8676002)(38100700001)(1076003)(5660300002)(86362001)(6916009)(478600001)(44832011)(6666004)(6486002)(83380400001)(4326008)(186003)(2906002)(54906003)(36756003)(7696005)(52116002)(316002)(26005)(4744005)(2616005)(16526019)(8936002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dS3okr0t0Q0jrpifQQhfi2RECgBRijuEvnUiATq03DPMfnoqpauvBCFM+6To?=
 =?us-ascii?Q?9KfDQPgrwmcrThzyZNTvj4++beXoTTLpcP4U8mbqtM/Fl3qjpzs+TARr87R7?=
 =?us-ascii?Q?ovm+ZnXmi341bXITwo1CrtHNjFOt02oTv2IX0FL8wZVuKt3N4143xghLRzR1?=
 =?us-ascii?Q?xWMTB597CRxoi+2HToIA3RWSJk6Sq++EMnOyRd5jV4qbenpEBPIhxty7e+P5?=
 =?us-ascii?Q?ZUeNnKeX+ReKiQAcUBx8J3EdxcfxakbnXz63Hv6ye3yZ1lPK4WINdHMcp8NM?=
 =?us-ascii?Q?afm5uIGvZfXllaVDv8NaHntngzaHzeTMeM/ODD9wDFbFe1tDO9IUxv0h8Pp2?=
 =?us-ascii?Q?XbG6eKC5t1pEPBV3VBWSc+9qSOutXwPANXZ7avGy9Q9dMZXPbfqZbZ53+3ha?=
 =?us-ascii?Q?jDV9Gmt9Q7F1LyGwaiTz1nsHu29nmU3NxPh7yy2RPJovUV9dGXxexsuC5/bA?=
 =?us-ascii?Q?OsEI+2QrEKDbnSVK7KZqcVUs/ovIj6vh29OCvyB1RGNKxLXh/09ha0H18du9?=
 =?us-ascii?Q?vk3A0PcpTV+OlvT5QslHrJDeMwhKHG+W7ISypXCMY4AA9mhTi+yu/cB1upAO?=
 =?us-ascii?Q?jUv2qY4EaT2xdI0C2VEGT7tZfS9OBjhoBDMBXIvfSvHyEVj0e2wYNiwT2GiH?=
 =?us-ascii?Q?Ye3jRruCzLcMo7nRMiuarBaCfmznPlI5csYRsvbuNTIpyKicpDm9oyxglFTG?=
 =?us-ascii?Q?4nrnGULAd/5DagVOqQBiWaVWPre5Zd0Q+6ZvVpMJNv9OKxJDdMXPUmnjrWL6?=
 =?us-ascii?Q?olgQXxDPdxHPDk+D3AYS0KfvuDPXHPkJsoAGsSGbRBpnHOENH3GLSQuZ7a3A?=
 =?us-ascii?Q?bjoBBBaijCYdwQ5cpcQMGD+R44Ji+HZUPgBwK/oEhydpGB6FnT+MHoIf7RCj?=
 =?us-ascii?Q?t9hgpckZCtx8lmnHAuD2OIy7GX5NexQFw1uQBokuPmRdLHRS4zI9qkfEmswj?=
 =?us-ascii?Q?MYVff4b7sU+F6CxOnSrHGtNqfZExFFZTNM59roSaFzcbYJH8k0BxD6AcKt/y?=
 =?us-ascii?Q?gN/3FEcGXW/+RvMS25U5Gs+vYhbtaUWcKv5PLIUaT/wBaDik8G7t432Cg5ig?=
 =?us-ascii?Q?MPEJNJrZzWr0PK50XjG4CwlJk07/tX99V9hV3u6DoKYc625XPTgwOKTdkUsT?=
 =?us-ascii?Q?mWtPv/RHo0JMGX15ov6ZW9W3LCQsJRkI81rgvxw+lkGcc0fMNc7FkjN9iMnN?=
 =?us-ascii?Q?P05pQJjgwPGhfAZ2NMZKhSJK4hz5VwtJq2M4PgXEC3aKSs4ZKEQjtp6ycjoP?=
 =?us-ascii?Q?hbavqt/8L+lFzy00SN6Vfjt35gLQQ0vnB7H6alSZbDjT468f45xHh++DHPqh?=
 =?us-ascii?Q?e4JTEtFqtRNzQ13LSYzVH+pR?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d8fdfc-6b63-4fc3-41d3-08d8f2bc5e1b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 14:10:12.0872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zAZvIUkz3SFjdRhDmSBh5NZbOhTZtViy1LiTzncmU17gfX9CanLT3tia3+nOccmSb6sKs14yPi7R7uEmxM+Phw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3666
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Handle return error code of eth_mac_addr();

Fixes: 3d23a05c75c7 ("gianfar: Enable changing mac addr when if up")

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/gianfar.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 1cf8ef717453..3ec4d9fddd52 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -363,7 +363,11 @@ static void gfar_set_mac_for_addr(struct net_device *dev, int num,
 
 static int gfar_set_mac_addr(struct net_device *dev, void *p)
 {
-	eth_mac_addr(dev, p);
+	int ret;
+
+	ret = eth_mac_addr(dev, p);
+	if (ret)
+		return ret;
 
 	gfar_set_mac_for_addr(dev, 0, dev->dev_addr);
 
-- 
2.17.1

