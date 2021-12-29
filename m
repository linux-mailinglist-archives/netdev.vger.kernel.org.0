Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1ED4480F45
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 04:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238577AbhL2DXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 22:23:11 -0500
Received: from mail-bn8nam08on2138.outbound.protection.outlook.com ([40.107.100.138]:18785
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238574AbhL2DXC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 22:23:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5oEiI8sFfstb5oAIPUxDnpYyC1xEuEGxHMngqRyJjBWK69aPINLv+cp2bWASe0+wIpGxoIq0/2E7Q501+0kXf69lB17sGHUMhUmKNPYNboEPry/TAWHlKylmUYIoKji2OSi4b14FrYpxMe8vYGgoMven7hzc10hHbTQi9ZuIea3Rrjf6QL3fpMaHbFOeWXO2hmMket0kK09xa/coKPDgE8vr2RzNYIpxjyljb2FHL0XD4hUaNnlYtnvyJHQfXlgozxlM25bkxw3lmKNqflyaCJ+TDlq5Bl9JQNQTMwxdgwlDbhPdqNz7YmhyrxNm06InPJIYkH90Ko2nMq2qR/UzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=toz/kREwsP45vdGNTdO8e4m3bTuuZYfc/3+TCfHILJk=;
 b=N4gMu/KDtygc3m0uLLW178z5yiexwlQ74jcHeH3wmwuiK9CCn597d4rxoOXpfswkaQhqOVq394+YUmhKkDzUGUjfihVNiXOn0Yg7l8RRbxJNvZ3R7wF7aGxs8pfCZBjy4POnvPOUjwJoeOp5BpuRXNhWR6+YhdwxAwwob7CVQkp6b4mOsi05PA0QtWaG8vAUp/TSf7lJIlY1ZrwoBoY5RTjjKDmfsdgueXu+ZJ7WWKhUmwjq2MINNbyBmK0ZrrwoM1wszQrLUCcN6Kq/9uHdAttcbv3Tyd+N70LJQK1IBFmE3pGyD6/QA+qv0fHPLC7NVKFgZ8heMOktEtKUqqCaVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toz/kREwsP45vdGNTdO8e4m3bTuuZYfc/3+TCfHILJk=;
 b=ynTr8FMkduqR/DMiIkYb4RGsy+CAN8qmEs/7h9+RYnlwiHc5p4T/zZmmpyV9+EA2UnkLHc7puyiD0ItQW62fwk+TobW5qGn+Wwwcs9pUDaaGiywR1rFd4SYdttzM61MxBKzMrf552JRToIsTD51B1xrg7wq2OMg8OaJS7mwvcVo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB5521.namprd10.prod.outlook.com
 (2603:10b6:303:160::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Wed, 29 Dec
 2021 03:22:51 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4823.024; Wed, 29 Dec 2021
 03:22:51 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 5/5] net: pcs: lynx: use a common naming scheme for all lynx_pcs variables
Date:   Tue, 28 Dec 2021 19:22:37 -0800
Message-Id: <20211229032237.912649-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211229032237.912649-1-colin.foster@in-advantage.com>
References: <20211229032237.912649-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR14CA0015.namprd14.prod.outlook.com
 (2603:10b6:300:ae::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb616982-b09a-4fa8-23bd-08d9ca7a7e98
X-MS-TrafficTypeDiagnostic: CO1PR10MB5521:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB552168857DB54D0A4FAC00BDA4449@CO1PR10MB5521.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sqYNuTw/6u9Vs3pEh8CVLnUlNAQWNOeUQJFo36nDYltPo+BfW0kEbC1Uyo9JE1P3kRmsCDwtAGA+u+U1G3/QgS+eYr2t4DvBLTK0ozG0VQkMv9Yy+NOZxZ6U9oZHDo+KP+KRRnjlg/pSGJNxO2agUFCpfjCo8dKRfkz1oMgmENv6t1nPkheIoxsJUh86DtFiEWw91NRLpWU+lSJFLFBMmXpsg2+KyFjvSt4YE+3GAtXM0S00fp1DzJHyHMtWlnpyasFSuiY2tDk/JVG1h6CYOemHuFkqd+yBA9Pn580pIhwOLe/JIPkKAdoOqYn1eC/qZDV3I1vB4RPY08PQJoN3n0Kt3dQpXJkZF5mUs+GPw3URUjXypTeTaxyqFXzGmEzaxhUyGUB11YEiDODJ7UMiJn1eL/S3wRv5z4N1mc0rgTwAVoDX0k16t/mQHCF9oWQpojnd62HtsF/X3YNkDI9Oqfc9yq3Fg95dGzK1Bx9IAsVk4YzAqRPerNBlOV6oX44tcj2sjFV6wf/3XRI18e8RUQBa2qW+CXDsZ5Pb2P/AheHVyQaXrcSG3VA98ouWOR/b93NviSz/kq/VWFXX1It+m1fiJnjP7DVV7ZeWGgLZfZlQ5Un36Y1j7H9pp3vaSu0foESXtziT1m9uAouiyDrB4RbyQSil2+4ZqYRmupKdh1xDoETR2XUQ2O+T4iWHfPNNgkLvg3/3MO8jXAY3p+UM/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(42606007)(376002)(396003)(366004)(39830400003)(6666004)(316002)(66946007)(186003)(8676002)(4326008)(2616005)(2906002)(6512007)(44832011)(83380400001)(26005)(6506007)(508600001)(1076003)(86362001)(54906003)(5660300002)(8936002)(38100700002)(38350700002)(52116002)(66556008)(66476007)(6486002)(7416002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q60BTOl65WzMwo0vNQjSlSHP5pBz7BlfUwUZZGxm9R4tQ5iyAiXFglRK5kfu?=
 =?us-ascii?Q?4UntKhCZMzx64YZn1hdC98A51PgdUgh45CxWrciJvD7WHLugLesjGY35EQDC?=
 =?us-ascii?Q?Ue9q04+pJEZuc8fPpkbghE9wJAdOLKQ2YDLoJZCV3aLUlyd7RMuMiWsjpUuB?=
 =?us-ascii?Q?D/f39ssqShTb32IVIcbRdFd1zWen4Q+SU9bABlOUpX0PI2tqgq9n+u70z9wY?=
 =?us-ascii?Q?nMTUeSaAREDLy30v+ashZq6jMJ65gyPscqrX472Kk62ayhahkmTJbVggN0XN?=
 =?us-ascii?Q?L576YRM+3/MMJkkPRT1X5OOqbviTbm5GSR/kp/DLbXp/818fcuMcHyH6CgVG?=
 =?us-ascii?Q?uY/NeQ+8XErPwtlZIyVJl5yNmS2QHEVbAwxKIcBOGb0lWzeUDZbIpjWZMMNe?=
 =?us-ascii?Q?KiJBA7P5lbNmNvSEKHi6csCJW84xoliN/4X6ytMiQbcvpQ3UJ3ZdJHlHE/Qj?=
 =?us-ascii?Q?NnHrlh3IgmR2wSuvYKkWDvpMB41uTm30uPi/w9SrbYTZl3/7Uk1RQvvTFuSA?=
 =?us-ascii?Q?BPLlxCHJKuIA4H0HlzevLs8ZmSE3KZUdG41iooyZCGMO7SQpLPcBrt5iNlsu?=
 =?us-ascii?Q?9FgPetSxhxFpXG5SxjSJRP6ROEXDeqpKMl8kBTXucN08kxHes1AlN8Vi36Wl?=
 =?us-ascii?Q?mKjYetq1j7YuRqR1euA3s7dakzkfhyRQyDRQprA9YI9y8WIcTvG6fMsLBUmu?=
 =?us-ascii?Q?+mjpYhicQoJk2Rxb3tJ/6r5EmZlUHEp4AsRUcPHzW9Zza2D4ytvAnqxUf7mj?=
 =?us-ascii?Q?z5Yy8bWvf9xayBTGtJVBCmW7VYhZUZRuYb/RpjpW917bFD7wG65K5zROhzsj?=
 =?us-ascii?Q?Lw/DlBumwqTP+FpbPmyjF6TpK2AMoF/WQ8UM8WmdRf6tvucmPSsvtuBdNEw0?=
 =?us-ascii?Q?aTqvUjKl71O5JnOduEjVgNDeepvFTAKX+mHuoiKiwiHm411PVShHpP0VyIGn?=
 =?us-ascii?Q?8VjjEFNR1Gam9fa+FnGQTxl2IilsPztCoIvvNjp8rmVTVexU+2v2OwXChfX1?=
 =?us-ascii?Q?5GgIIAk1PC7WfPy3VxlfDLs02mbMbfpEEWUtJIPi7mI3d4WN8YTDhJAv26bv?=
 =?us-ascii?Q?yv8AO9+ZNWxrItskIE8q1MrRL06VYAJUPthl5EqREGemXTi1z2s0xSuo0Y8b?=
 =?us-ascii?Q?IBV2/HCd1f1XMJCEvLVsQZV31nPVAjGcoJQRMkdgcQQ9x3mqi+fbT6O/1Ul+?=
 =?us-ascii?Q?3FO/Q9hEdaapN/0ka9Kxg3BbZ6U8IvnQODbMVnhiHmOJk1Nw061PHp3tPgQj?=
 =?us-ascii?Q?xEZcm+Q2hWgZn4emLMBUwSSG2/k+1nXyqlF8LQLT1EMs7ozHrWOcPLB5Z9KY?=
 =?us-ascii?Q?Xt4cz04KLNu3Mj4lw4tbhBtpJydJ4oSFiBhBTDTVDf2Dv16ZdvVhC0Kqm2h/?=
 =?us-ascii?Q?2dmoUsc4zt1dyd97XUwwp3bHvK7eTyKABIjZkWxNYON+LqvD2nvWsdMTNraE?=
 =?us-ascii?Q?3+kXT0gz3E01+wKvqbVs0Tyv9maFJKpldymyw9fSnG0cESW4awZiVP4VkMDL?=
 =?us-ascii?Q?uWJPCGBeE0a+sonzEcnCVXUqBybF8uXyUaWQpwTIRSyoKeJpytReRtCfb+rk?=
 =?us-ascii?Q?E7DzK9ntgdM0FM1rnyL9ruoHW0lwY/+qk8S+bU++bwC+2ej3NK86oU2QTm25?=
 =?us-ascii?Q?ip0/QqgdQKucibQCvB5QKbRjSe3C0fJ/9gX8v1hxegd5JSITje8yU1TE+5UP?=
 =?us-ascii?Q?SHR29g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb616982-b09a-4fa8-23bd-08d9ca7a7e98
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 03:22:50.9606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rlAJhb0R4ZvkcYyorruIWOKD+i9PNrSUfT+9Rr/ORctd9qZnA5/ie0s92k00IwvD6LStSxqefdt9vyfP83P/ZzEUpaGGAhPCRgURrU6P5+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pcs-lynx.c used lynx_pcs and lynx as a variable name within the same file.
This standardizes all internal variables to just "lynx"

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/pcs/pcs-lynx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index 7ff7f86ad430..fd3445374955 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -345,17 +345,17 @@ static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
 
 struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 {
-	struct lynx_pcs *lynx_pcs;
+	struct lynx_pcs *lynx;
 
-	lynx_pcs = kzalloc(sizeof(*lynx_pcs), GFP_KERNEL);
-	if (!lynx_pcs)
+	lynx = kzalloc(sizeof(*lynx), GFP_KERNEL);
+	if (!lynx)
 		return NULL;
 
-	lynx_pcs->mdio = mdio;
-	lynx_pcs->pcs.ops = &lynx_pcs_phylink_ops;
-	lynx_pcs->pcs.poll = true;
+	lynx->mdio = mdio;
+	lynx->pcs.ops = &lynx_pcs_phylink_ops;
+	lynx->pcs.poll = true;
 
-	return lynx_to_phylink_pcs(lynx_pcs);
+	return lynx_to_phylink_pcs(lynx);
 }
 EXPORT_SYMBOL(lynx_pcs_create);
 
-- 
2.25.1

