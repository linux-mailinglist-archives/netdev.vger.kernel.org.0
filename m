Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9DED27C213
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgI2KLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:37 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:54849
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728273AbgI2KLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGql8CH54vMgQ5sLPPXRO/T4Aq0dgnCCHqMSUBqlkQFe9/tSSTyYKwEvdkj53+wZ2Lo1vswuMmOQmmw/vzb8ssYpzOlyFcv8Hqy5+8c7gRnTeJUN5eFhKeaQM8+7usWS4oRvfm9lZ0QOY+wZPoCQ7e0vyKyVjkeZ9vHiugUsK/grcYxiuru3z0Mzm1qmyx1unFvsJcHAnZJz65uxC2tLk18Wgfr/uCfHd6LnSc5rP9Iq/xR4JkgtBV4allFR+wuiGFPZ1oavn3m/ocPylxQgrbxIqirgZNZWBN82A8czTXMwhCmXyMstJIjdOL4BBqlV47vYfzZMftbpwACnB2Y9bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=huejVChd8tEdl2YFbkhswpAzl376CwkUBZYXJ6iyIOs=;
 b=SY+EuS8vk3H1tyxX5cWRRp+SyYrP17w3wbt0zCG/dVAHcpohAMYPlHc4YcSGBuU2FO6ROw58ZhXApelQIMGgh//gsZFWB7VGQi4ijMFf8RuYVQC5W+bH9KV3woy4l8Y4ElX/6tzNJZMYAHnZDZGuDVEFiwmm6sDzxglo7ISxlMmnsQV9s60EtrpP1ryyjKgKUWyjcJTz3kGXUw2sLXsyNioku8dk36SgZZ22nSUa0Fyksj+LXZhvQpiFdFAQaK72xvjMfwWnw9TXrPf0ov6m7IXP4+LVn5Ld5vbbkFECJ0hz/jIjxWQZIQtpgyZTxS2XtLv0MYV4XpO/lYbeZq6ZCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=huejVChd8tEdl2YFbkhswpAzl376CwkUBZYXJ6iyIOs=;
 b=eT8gfcbAut9qNxWu61HqnGFd50JEwVKWzChz+wCykCt4PdgxA2caA67OD+/L7mX1WsVWP51UinrmCx6rH5L0T9F23yDU4QGha5XxAOulIUcRlzeHGI0JVVIWbm4KejswgHWkit+tlcaZGa2qWzpZN5xvoNfEt14hywG7GKAcSrQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:43 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 11/21] net: mscc: ocelot: change vcap to be compatible with full and quad entry
Date:   Tue, 29 Sep 2020 13:10:06 +0300
Message-Id: <20200929101016.3743530-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b25d5e19-a5f4-4128-36cb-08d8645fecdc
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295AE0DF18DDB6377277577E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wq66/quTyPyKuKeVsGFBNiCwKY8PWqdqdeUJ1cL3XqyXjAd2EcIW/dCA3aEQvdJcMfOKz1lPS7pDRUcJWLU7nV0yZVtYbIm9+1TynUh0pN3mxQ0Mkk3d2S20xLVHTj3CJ4gRT7mUJyX53Ljq4vIaMsfke8vV9FfjT+YbZfWTPnEwTOs9bNy+KARrO5kSsJZLfx5CAVxdLzekVZcwizgEVkgxxS+1Ji9s8doJ9E+g6rRQJN15NbnMkyDPnQH4vfB7g8uYIIs991lJ0AURNKLz/1f80Mo9Pnu9qCnJHkObM7r5MrfGQyD/5WHEf9bDSmgy5iHIg6N4rcea/XKrZ9KgkT7YOdLyfIIJ3H+MORkH5O9iXrmgsaOdEWAG0NXPAtN706rhMDDdmmMvY+csdJaxSoTBAAxURlcHmsh2VAB79vKoOtr7ZCf5rOb+wrL2nMWg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uuaWot6y0sVg7cSoQ9CsfRlqryoguUoN93LdQ3Q1axkKsaiy1A2NsHHPKZ4sDpmGovO+u07nB68CtCAfUh+1KXww4nuNNvciQr57kNSIa81LcyEMpgIz3bLtwceZsEDFClRwZcNylQKvXJxzpiAfnHxajJzjSpmcM8yGXKWEvmUHWBB68pDe5TD4c2hAmIJzVMhG8/+zm8Sq32IG/pwtCf0SvL9QA9y55svMZ2mHhKQkOzcq9rBTDC90REUyIL1u21f50V5CHEEOy2+hs9HWXaROQpzsHhGQjQ+Yrhb01SKkej1P/w7T++Bdt7v2ywLIPYZJHZWbWE5RtqGKSjO6/p9xVkwHPL1pHaTIt1zimmlWpJX69EoaBrZn0DTO2HnpSGrDYJzYj6Zvvz5hEIXUXeS1k2+A6pWVOU5CVcVnAFuxR7pkZiR2wH0zjP/xqtJqZ2RgoHscOo2ajACH7sDL0/UOa+saRFVcJs92KYMXenplGBeJ+iVssogoEPSAiwiMpgtp2Cjn+8CNmLyFH+a4wpVDtNfDOXeaaQNDUliEAQjUrY4O83hc1HOn73YkhpvlhoO55rgCyqM2KWCxUODgtN+OABIAR/4nB8VnJGo84DpPW6HkRoPJWb+7yX1u0DbereALVOmRc4G6rSMhVJk1BQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b25d5e19-a5f4-4128-36cb-08d8645fecdc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:43.3599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lDuI7MDlaI8Y/9OgZrUl0z1Bh/RgcIeu8i36kPz6IVSE056zu4k/5c0fH9g0+WtoRMEPmLdcacn/QnGs6glCoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

When calculating vcap data offset, the function only supports half key
entry. This patch modify vcap_data_offset_get function to calculate a
correct data offset when setting VCAP Type-Group to VCAP_TG_FULL or
VCAP_TG_QUARTER.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index e9629a20971c..67fb516e343b 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -176,8 +176,8 @@ static void vcap_data_offset_get(const struct vcap_props *vcap,
 	int i, col, offset, count, cnt, base;
 	u32 width = vcap->tg_width;
 
-	count = (data->tg_sw == VCAP_TG_HALF ? 2 : 4);
-	col = (ix % 2);
+	count = (1 << (data->tg_sw - 1));
+	col = (ix % count);
 	cnt = (vcap->sw_count / count);
 	base = (vcap->sw_count - col * cnt - cnt);
 	data->tg_value = 0;
-- 
2.25.1

