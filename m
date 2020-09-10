Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7CF2648F9
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 17:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731325AbgIJPn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 11:43:26 -0400
Received: from mail-eopbgr150123.outbound.protection.outlook.com ([40.107.15.123]:57729
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728443AbgIJPmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 11:42:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6RJZ2WZdVREEh/gA5m6FdZC12QfAUnWUSMuAUqLG3lQfDfjm4wI07OYDd14DnAbxSFjy6A7rdPoLNIiZZMmrucb+dTzluwafi4HIQRYZLlaf5w7Lves97ljrRHaegZHkdlYqeCF/lKcETCFW3CoCJ8fCawB7VobOHU8yjL/KDjbBF4BmxBY9wvHL0WjuctyYsZhQ8D+yheLrySb/M8kw2gHRsVmwy2JvVw3LqtCkMtK8qvUcrnR7FQpIRhuhoJwrmEPPe7VVAc/Ph5bxMlVBTOG795ezzWfw8s4WTlCNXGbUSNnpxwc/FKNAjxFTGbiJMfmXcIeTPi92PYRocNirg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbXbMGJOc5h0uC3epDIQNKWRCzA/8uvyi9U9ficj6DI=;
 b=RNRzDRaHVNsROB0Eoz1EJo3/sh0/u7VfhNk7Q/tS903c20EqiwrUfEHJw5c7QvitzLbBAaLtjAVyOslzeDqhu8BXd9RHP3QuWyTT9BoMWjKMFZeqoKDkAYZ6a3wx69RxxYVkBuhwR5uSYWnEdD7jwmcWKF8JJmRq+Kjn4jpZxXYdLdAQLiwb8Gve0JXYQlBuLdzGP5P/lEEq2VTTjpSGtuBRi9iAFRFbkSfTH3v0OurqZrl9yl9+WE9wEY16d/5Os3ElxpWKF0jGfVdh//Fw300a0X/b9cJhK+u69VoFwJ/2LE2wAgfNWG2gNP2zSZEjlgETLxOVNbJjzvsZv3J1YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbXbMGJOc5h0uC3epDIQNKWRCzA/8uvyi9U9ficj6DI=;
 b=NrqTrcB6o3O18sknwg99swfrQPr1VCezeWx7aXVzEUr+IypSrae5Ya91/tkS3TBNpVMDmDC8btLryrb17YPcFl0vaRfIck9KrXN4SZVnnGyey+QAzlxjKXgohk9yTXByvs7tIHxkSzg7XRBzne/ITITT/KbdPwQJvKCqPCdvOG4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0538.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5e::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.19; Thu, 10 Sep 2020 15:42:16 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 15:42:16 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [PATCH net] net: ipa: fix u32_replace_bits by u32p_xxx version
Date:   Thu, 10 Sep 2020 18:41:52 +0300
Message-Id: <20200910154152.24499-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0139.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::44) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P193CA0139.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Thu, 10 Sep 2020 15:42:15 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff1f117d-6db1-453c-b661-08d855a0183a
X-MS-TrafficTypeDiagnostic: HE1P190MB0538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB05383EFCB13E16CEE491ED3F95270@HE1P190MB0538.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wJ5EiDKCcjIvhdg0EAlc5Z9kYZ8VO3F1rQJp/Q9Fxnh8znCpfbF5id3BoUuTEJYUn2qc0j1TFCM6odzn5ffIxyWQG+sNiE5wsQ7OVCounTHFPqbDoAtpWZ8ZqXdO7pjJq7YeWIPDqNYBj3dPoWtbq1ZqnrQHUPtrseg747rfEfnBJL6xx+U8mfn0CgPUb7BeiK3zN0T19X9x44H1YBkfGEhibfOSMUkx/yIKo+vqwUzR9r3fjHVlk927001/OpQ4AEO1ohHUPzETU4L/aXPBDgHXjfk7z04fvgjdVFj4yLOGlzt9HDaq/YFU/t0BG9fd3C5DwXutoTp9PqcKXHldhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(346002)(136003)(376002)(366004)(396003)(5660300002)(16526019)(8676002)(478600001)(6506007)(107886003)(6486002)(8936002)(110136005)(83380400001)(6512007)(66574015)(52116002)(6666004)(4326008)(44832011)(86362001)(186003)(66556008)(26005)(66476007)(316002)(66946007)(1076003)(2616005)(36756003)(956004)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6rHwKskn6GQe/0THMtdbGGmiSmfR7L6A0fHZJDBlWGhxzyfNPzmAXcMK4iPSelYlBOmjw6sjtFh2bkkxtRWn5VFPQbQSiVKKqL2JfEVXSm2Sxo70MaSAAUj7RrCW9zoTFcmJZfGNRB2dpf/JFShOMv1y11xEhVGtUguNVhEWrrQfgnVPKSZHCB+ccyg/pPmspIDjZhk5SVC8On7GXJ+va31ZmdJbTZPhgclQ4j8GBvLmn493fqfLowpgTe8sRGsaDycYm4GlGIsiWNyTdOA3QP6nA0HRfGHNHbSkcEm/nRS774EIXJEb69DFhRzh1lJ39Ne5Zb4j1qW1gbNHfFGCMqZ2zBLTDiG5BRtB9VdcXtN7jv7OxGpcs48dQMke8fLjbTXeQDvEn7sMY2GNlJ9xHLHEOCY6Iev3wMnn3cEBMI2iIHoyPzsQ47ypPV2Md8Q1fpF04C8iUox6dTb2vIABD1XRGY8Xl4hmd6QfruPXZ+B0+juIs4F4yt1zH9iBFpWJItJO/jKuZTsLwZRFw2Upb1JB/nm4zpq2bj+1jOmIgk7YCkimMags/+C5GVCGErotmg+O4hHOS09ejDyzZzgklpOVlxe7ptL6chDt85wI27+Xx96+dRjBnaLia0HSLqxRw0qxN3Qt/di8mje9X2rgkw==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ff1f117d-6db1-453c-b661-08d855a0183a
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 15:42:16.5362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PWjW41J1Nh70OMdf96fu9yZ0I0XxPrFfSOIWclGkZqQ2ewHdg0LdYdy+M6UX1J0Oj8z2hyLriV6+nwVOSFSRBOqGvV2T9FJ3ueek8LZz6rc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0538
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks like u32p_replace_bits() should be used instead of
u32_replace_bits() which does not modifies the value but returns the
modified version.

Fixes: 2b9feef2b6c2 ("soc: qcom: ipa: filter and routing tables")
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
Reviewed-by: Alex Elder <elder@linaro.org>
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

