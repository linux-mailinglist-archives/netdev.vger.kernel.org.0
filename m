Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5ECE26145A
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 18:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731716AbgIHQQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 12:16:22 -0400
Received: from mail-am6eur05on2093.outbound.protection.outlook.com ([40.107.22.93]:26176
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731648AbgIHQOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 12:14:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDbzLiA3SXwkN751gofiozbyl1MAycSbDXQGrpTOGAr6kZ/m5LMHEjAIQc/Q9QRYQT7YG//eZOstbl0X0gvArCnz2lNkqMGJyF4bbHrA2rlLOVpb3HKfizpeYWP9/foxR4l5IN7rM1Bk0LKvqE10UlxdhATq91tA1BwXZobkjmNf4L5HujsEdJKgrGOPvRh7qrKWOInf5mi8jrEhTGjaMRyr5+K/5fmab0oAKOKFbTfeKkENSLy51WCSVrfDvrU2oYxYi9p5HADWhpOxreOTF1S5bxLE7F7cf/vn9b+hqNXQRDsa3pt7xHFXs3GHhds9wfGfRcryceicAA3DOK+4TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5v5AH4lazorxXbFyR4vBK2N58jkKw5xELdwp3OICEc=;
 b=BNeVjpl0TBTkbnjtAoquG/bx+GSYWLoJhQB0DbTU5k11ES4PStQoexBp6MTrkCT5T4o82ZPVc1iSUnr1FhIsPJurxJfVBkkLgiopLiLuqWEieu1I1XyZtO1aWTUHpno6enl8xlBCM6s7woys96Hht+RVP8vy8ZKLVUR0mgk6IcjLqSLZ2BwU/k0RIsaEkZ2VdQrGsRT2ExHipklRcnDdnM+t7dQP9xNQsIBT92mec8Pbndr+zRMt2bXHuCzh+Tx+h3Pb9S5R2DpJ2HC1nmhjee/qYLeXbsJrA/MOoYKI8ZQpA/fv+FBVLAxihYOmJ80bbWZ20YwQmihTvC+b7fcGeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5v5AH4lazorxXbFyR4vBK2N58jkKw5xELdwp3OICEc=;
 b=HCRBs251X0rXiE5W2OiB1xBPnVPi+pAXbnTTzf5ero3RcuspRWxaRd4alVMaLvr1EWuyMmN+BVJAsY3ZPfLBcm4THlRSHN8zTngC8c/6D4/1tqG3px1pftXJQ6n/U46220VTdoV3bQf1baMhPyVVGykw/vLLQ99Q/XfRAYgmoUY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0490.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:61::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Tue, 8 Sep 2020 14:33:01 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 14:33:01 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [RFT net] net: ipa: fix u32_replace_bits by u32p_xxx version
Date:   Tue,  8 Sep 2020 17:32:37 +0300
Message-Id: <20200908143237.8816-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM7PR04CA0018.eurprd04.prod.outlook.com
 (2603:10a6:20b:110::28) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM7PR04CA0018.eurprd04.prod.outlook.com (2603:10a6:20b:110::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Tue, 8 Sep 2020 14:33:00 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b06db470-e672-4728-9794-08d8540416f8
X-MS-TrafficTypeDiagnostic: HE1P190MB0490:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0490AC4EBF4FDA77824502EE95290@HE1P190MB0490.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NmFZZmqFYqR5E7sp75t3yz66tWUPlqO2jk9U+Z2R/PZj4oJb+58YemlabVU6aCF8NZAKnA398wsxgzjV589cCoR46kqhgkJbwMt5dLJeweUoochfxsT72ShcS+bjsIKUT7YUy7N6ILaTsu5xsGbmxlQW2aAnOyNgL6pWiO9O95rYGNpLlPSUqgB4v6YBmjnMMpxQakbfFa69+8MVoxUmZQFylThNVI00geqTuF/W3NM6BDsG8RCBpXi6foZhPgJdpetBdiwmtMI1+/yEoaZ+f0tuHwZTK3i46zf0aqwJgScbKfBV7dIdJNj/9t5IoiqMUmF+WlH5EatP92Da8X6ESQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(39830400003)(396003)(66476007)(8936002)(66946007)(66556008)(956004)(2616005)(83380400001)(44832011)(5660300002)(66574015)(52116002)(316002)(6506007)(186003)(36756003)(6666004)(26005)(16526019)(2906002)(6512007)(6486002)(8676002)(107886003)(110136005)(4326008)(86362001)(478600001)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Se/lq69Jml72dIuzaR3b4NKIHfHiS0uANZvNVti/71/mNj35b5UxNm6dj9EiDZ3QWZkBZ88XJtnR93Ah3lG07fJZmPzGMaPltVePoBfvEqzaYUUItOYgzZRF6S3SSo5Y7hogDL4CvZWFEjdCGh2xJEMZgBwL/bMPM6AovewH07+hhLcIocc71hHx1MgVJgKouwqDFJ+vIvawjASHoowkJZaiiEjyQJDCvO+mYwFfaj3XtgYvEHy2L//no5+AASMEl4Ev3dq2LqWz1+76oyqb7bn1tsXG8uinCi69U5eI1B2Ds+o1kpFpfhhZGTZO2U7MQvmxKBUZHXVPjlSdB6a4RcH3tMZ9n76TpYA7NjHRwdJ+Je7yxXUvSHtGX+i94o6Nhq2sdUlmiRlesPYWqtPEtouQS3ULzu5Xi7CLvmrN6bJVHJa6J60o2Mr1DhP6cWSyTEVpUb04Cq95jC/D4IvbaFtlul7Cs3cT0SCqULj18eDYhUZP/vByNwtwQx3kQ39c0BNOU+b9uq8jq7vd1+Yj2UFTTU3C093VT1jh84PM5r9CVSVmoIxkCzIJOUBNfNQ7pd6BhqoKQQw9JP6ojnJlVB4g+i4eIA9OFN2BMxPdw5By7YuS8hpZ5CjPRXwo+pnapT9fUwqvr709fCm+MHTkgg==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: b06db470-e672-4728-9794-08d8540416f8
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 14:33:01.8605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ue/TruGcqnnS+UCsZ6Z8nJyKFLxKff/xiMVvERdZ7X43jO1IZNbvDg9eYI+HvlbujQSvg8nLvdqgeTA+Y+UlvIaKbbkMZTMe3La2TJAWJXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0490
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like u32p_replace_bits() should be used instead of
u32_replace_bits() which does not modifies the value but returns the
modified version.

Fixes: 2b9feef2b6c2 ("soc: qcom: ipa: filter and routing tables")
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
Found it while grepping of u32_replace_bits() usage and
replaced it w/o testing.

 drivers/net/ipa/ipa_table.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 2098ca2f2c90..b3790aa952a1 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -521,7 +521,7 @@ static void ipa_filter_tuple_zero(struct ipa_endpoint *endpoint)
 	val = ioread32(endpoint->ipa->reg_virt + offset);
 
 	/* Zero all filter-related fields, preserving the rest */
-	u32_replace_bits(val, 0, IPA_REG_ENDP_FILTER_HASH_MSK_ALL);
+	u32p_replace_bits(&val, 0, IPA_REG_ENDP_FILTER_HASH_MSK_ALL);
 
 	iowrite32(val, endpoint->ipa->reg_virt + offset);
 }
@@ -573,7 +573,7 @@ static void ipa_route_tuple_zero(struct ipa *ipa, u32 route_id)
 	val = ioread32(ipa->reg_virt + offset);
 
 	/* Zero all route-related fields, preserving the rest */
-	u32_replace_bits(val, 0, IPA_REG_ENDP_ROUTER_HASH_MSK_ALL);
+	u32p_replace_bits(&val, 0, IPA_REG_ENDP_ROUTER_HASH_MSK_ALL);
 
 	iowrite32(val, ipa->reg_virt + offset);
 }
-- 
2.17.1

