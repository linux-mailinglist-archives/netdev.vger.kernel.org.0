Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BC52786E7
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgIYMTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:19:35 -0400
Received: from mail-eopbgr10061.outbound.protection.outlook.com ([40.107.1.61]:2854
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728395AbgIYMTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:19:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDMU8R43x7tZneN8QVylf8fdwYzyuDpI53j0Y7yYklD72HziDuXhH6iTTpty+NkNZa5M0FhOZxREj+rh6eWbnX3YO3bVEqNhWLpa87dUm8oj2ArTmSXsmYGnAPjFRxdJgqmtHPr6vBz7Z86iJErQmhz7/UHux/d1/VIVLRi6HP4VzmAeell+Rkzf3SM90VQF5OKRjce1kolDpXoYL1EysVreR60SD90Ua71dPyhfmx27ef4do2BF+7MnBLekWAGWsYJdd8zKl2nMN2+8op8SFaa6z7UPxzuWyVdgHsGDX5mZEOB62TJINYDo36A08Lf6mEmlw9LevsQnhXAQ+zjXyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9Q9VZHI8pe4qYIYWbqUSQXZToio5qUuTKPqIi1ZHqE=;
 b=FMx1QBXrT9psue60KA6RIhfh73dL/ZOkpR7kNhPxQrSl86XlEDf3ibpW7iWEShGrQ3Ijj9Q3vC97WmnnodZGEbJ2dkAChC5Ug9i9F+zjBYgLgF0Xajn0sWKoSRtdZRXoV4F/3ovSh8IsoSSFAjr3XVz11tuxqD4VDAHPGl0HeK+Tl0W2nkkjf7nJE9+5tZPoiwk1JrJxDkN2XRao8EO930newwHbSjfJwN4NV56T7ItnJBTUQ3pFhbLekBm/i6P69Bwq39YkWy8YxnbcTwx7w9QJ3TTufqwUy1CuIlDmjf9Q0nBZvwdelnI9Ib+PbJZyCzbdoIRvyaobgoKJ53Z2EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h9Q9VZHI8pe4qYIYWbqUSQXZToio5qUuTKPqIi1ZHqE=;
 b=rpFE/ksc0BAue/LY7gUy2SXa4cITOTMMR7s4BXkmAd7xF5NYwOLiGY8aAVKl/uKeX4cihboin1v2J/Gmm/OAxS/l2h844gLpxD8Wb4f2Q4F1cXOga4RB5u431sV0G4o/HbuexCMRGD5Ey5Vy4AjCTgfniuHXk2VIFt1L9zT8TSw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5856.eurprd04.prod.outlook.com (2603:10a6:803:eb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 12:19:25 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 12:19:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 04/14] net: mscc: ocelot: change vcap to be compatible with full and quad entry
Date:   Fri, 25 Sep 2020 15:18:45 +0300
Message-Id: <20200925121855.370863-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925121855.370863-1-vladimir.oltean@nxp.com>
References: <20200925121855.370863-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0007.eurprd08.prod.outlook.com
 (2603:10a6:803:104::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VE1PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:803:104::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 12:19:24 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d393dfcb-eb2f-4d36-ee37-08d8614d3d99
X-MS-TrafficTypeDiagnostic: VI1PR04MB5856:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB58566B078C3E192DFE3434D4E0360@VI1PR04MB5856.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:632;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z9r2A8UFYBlQfJS6sTzNZzH4GLZQXLixBb+s/SZJ4GKWh3sJgkhdCTwfz9UXwNJMNC406ef8E97CSmcvCCcHawi8ReqCmtkxTuW7nrClzB6VWSr6xXW7Q4DNXLfP0WztWPr6+sTam2Agb6NJVe8Zf6BS4l/NMGllpMgFZhwwxAVoGcFPxPuVIHxnkw6ECrIgZBkZPoj5ZJMTVGd1764F184xy6AkgbAI6JkAG8ZUp7j/ypH2vvFB7oNL7jzHdjW36/FlEw/5CJR7GWUzrkEkfPaxNrMQ72/ah0LP0J+Hw9kozKAIffiofh3YUFBK/wfjVzfLfeluXibnIA108GZF0ILXLT8ukSH9QzTHUbBi+aB0yire+A3NVLujmdvUXi2r00SgAimn4qeDACXfdpP9Oj3Z9alp/dk86RGxGD66Zegn61lO81Kome9DvmWZvIDK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(136003)(39860400002)(26005)(16526019)(478600001)(52116002)(186003)(316002)(4326008)(86362001)(6512007)(36756003)(1076003)(2906002)(6916009)(44832011)(66946007)(8936002)(69590400008)(5660300002)(6506007)(66476007)(6666004)(6486002)(7416002)(83380400001)(66556008)(956004)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UZToLt2SuF2DTBFEd9ZI5/OqxNi5QJH1K2HNOUAZ6jhUO4h5TeCJ782GCqigzbQpWq2u0UJi43UVtDOdL3A01OTuuZEtrVCHb55nGoVaPsbeN1SxlSeijzi+mYCGjZsMVUV2cPQCO7SVF5h6lqweJBtGiUUbH2hCs5tZWhFgaNxdkNQSqbkkKDQRgTt3uN1x4tAHSdxc6/8wvma2ZQR/xQtA2d8ADkAJzOaSLYVS1EFbBT6jw1yDPW1VZ45EwEF8MgPqrNVNa8kBZntUAJALoqAvhgvS3n7Rnj3kc6HdM5SC0KS/MGGWU9eSaKr/w/K0OI4tf98z4jQRFgpa/CkDNcIDT6R4LJazTDWLE/5wVJ+GehfPc3va0Lo5fa/YmEXk90qVhfyO3FZ7iklgBaHhYPmPbiVcWSTMTX+L7O7VbHitEIMxkxZJ+3Wz7MOAh2XqHVwB62rPV4SAG7uZhoTmaChE8+ysswD7dhnt6LphbHaRqkgoOBCiOxhr4LWW2JneAlxIzbwNVL2aEkqm4j9xhfY1bC9Opx35Wb9Esc1xWfXAVYLFDf49aZ1cGS0l79ChgXMDgFW2gGvlSIZUrMzFJEn4R3299RTD54fzzpd9BAMZ2WASTZGCiqLN/ntMiOUzi8C7nxA4hAFaKFG+NhXY5w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d393dfcb-eb2f-4d36-ee37-08d8614d3d99
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 12:19:24.8658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aAnMPpWojZ91wWHedhVgfmZ8dWL6anGv8pu/7KmKraqj64RBuE+tL8yzG8NCt+Sq73zZmkXcLf3gUrhtGpx5TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5856
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

