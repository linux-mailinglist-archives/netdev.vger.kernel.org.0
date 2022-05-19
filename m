Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6CA52DDA1
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 21:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243712AbiESTVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 15:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244535AbiESTVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 15:21:20 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2132.outbound.protection.outlook.com [40.107.113.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B4E49263;
        Thu, 19 May 2022 12:21:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GkQ++glaLEazI+k9j10Pd3RaeKhSFxTMysiSOQwiWrk1Ct47OUbZNsr6eay4NDBqDzlOYm204wW6B8exoggR5xgBkuXzuBJgHBkJNE6+0eCIuZ91FMiPH/nPn+KO1xKiMurJa12Vi96XLETQ50kr557+FyRW/EDmGjKDyifeuuK/5dqw//y87OMEF/gdsdCPln9mjNfsN1yk7DKoBuIEIEgQDq2nu+pqHsUf/rnQqNDDOpme2XbbdIQjSjRMPRtYCGkeVZ8ZZ6480nMVdFGOk4P81EgFQBVXH7H2Tu2e2DyKEUkmW62k1/wjn8/PjXpk20Qu8Buhz3bM3pSnjVO/jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l/22aY2x8/5RXzx0SnwrcQGUnU9WcgpiFfyvYzUyKsw=;
 b=lJw2og9an7G01IoDGaU4clzPtQkU3+XtQrfX5EUW8iM9KnvVQC3dtT1eWitqzlM15Inu0mx27m6jZYYLawVr4kHv+SOEIW4SuSXTdwporQ5lrS1USBOZ4aGLW+b+GGg0aYndNzTyMXQcZap0Z9B8bKAN7vUKniN7Bvz/E/Owm2KmkbsFSpwYlD0BUYKkoG1k/Dr1S7lLBSVtplZOucfi86dkN1LA3TOUxz8GPjmJ9j3BVOflp9slpDawK8qkZvBDuczq82vyzzqx8uVv5/CNxCCzcoGn+nxEDqP2ZkqkS85B03Mrwpa4k9gipcRLyEOd4h+gA9q4p1nMoB94nYrqmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l/22aY2x8/5RXzx0SnwrcQGUnU9WcgpiFfyvYzUyKsw=;
 b=atDDnoHmNUgZX7LwZ2Upra79r9oXPKOMJvOoHRwQmIT3gR1eh64Al981Y2mE/EDhHxHNB+AkMbdprnccbfPHGOYUfJrdPKJlB82kAsHaH0VwFUU4z6pxSOwVJ6UDz8Q0yPBSPsP4kJy2JDIkaI5wNLXzlwlJotBrEwPmrnhBgNQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OSAPR01MB2820.jpnprd01.prod.outlook.com (2603:1096:604::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.15; Thu, 19 May 2022 19:21:16 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::89f3:ab98:2ab5:7dae]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::89f3:ab98:2ab5:7dae%7]) with mapi id 15.20.5273.017; Thu, 19 May 2022
 19:21:15 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net] ptp: ptp_clockmatrix: fix is_single_shot
Date:   Thu, 19 May 2022 15:20:59 -0400
Message-Id: <1652988059-8740-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: BN6PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:404:10a::16) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dba47b7e-0ab0-4467-1739-08da39ccbdf7
X-MS-TrafficTypeDiagnostic: OSAPR01MB2820:EE_
X-Microsoft-Antispam-PRVS: <OSAPR01MB2820D3CF8ACF57552A6F54E6BAD09@OSAPR01MB2820.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FwJ5kZcfr5YHZE1EHO3R9oeCoCQKMbxOAgCptlZ44gjbB4Drsc4VXsPuXNl3rseKG9wEMIMZ1Ou4SduNwqWwYkxQQe4XQsLYlRLGGHatHw8b1KpCJ05HzNh+abckXFGWAkV6O9jAbL2AB0ePGZVu7Cn6MgNnGFnkc2YoL0MeRp7hApzChfpJVhw/o+JC5fLVtJNGhGIPH4DRHx3I6hgikulXLkoIz4g1O9n0oLr7x7B4aQD7aYHXsDbPAQcA/AR8BvKtPOo4CZvixCbKIYHwtfwXTgW7bRjGjjNClRilToLHWV3eZEEqOKqHpUfz87ZHDfFy2RhVyKzKx9mV34Vr88qrmjlceqTA+SsKqBIb2OZBabAnqgV+EZt1GIsdadhG2ezVt5Sjvcj8cfRVEQu3EFii95z+sZ1b9qnVrAl768ORraLIflemW6qx3to1N9uT2UUUHn20idyD8lBaoo7JWkbah2uNvfa91vrQKG3uBY5U1WT/aO4rABaPsQZz25Rzbe8g6HuHBhUtDAVB+PzDT4AsKUZ7v4R5/DCFH8ILQ6e3unQL12FaDHCu/83ilFkhrpfQNOif9H4XduHPBlGsYb0kP4HHnQOpmai0/U90a1hPJYriFYBmrO7SdiqIf+3oiFvOoV5aUtKInuQGpOZZINRYcRhId/38WDgzgKk7nZdrXoLoKJEAVECwmtLyvLhdFuWUqyAM5si3hDsRY+fv/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(186003)(2906002)(83380400001)(86362001)(38350700002)(508600001)(26005)(2616005)(316002)(6512007)(107886003)(8936002)(66556008)(66946007)(66476007)(4326008)(6666004)(52116002)(8676002)(6506007)(5660300002)(38100700002)(4744005)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KZQfX57yqhp55OH7WnkMBJwxDXxei8QiMHJN4bQ09mQSbm0nYGyn8Ep/uEoA?=
 =?us-ascii?Q?oBnhg+c2uVdBFh0Iq4KgS+TtMjqJX4ZwRAyR8b5kp95LyaGb5xH9f1+Ns0aP?=
 =?us-ascii?Q?9twfQuYVJGZUvgVmubS8xjPbp/2qjZ/8u0CTiaGrAqDPO2T3ZPqDoic+QDen?=
 =?us-ascii?Q?KRS/aNa4NafYAmaWIQn4FbutNRokjjSpX4+5S4Gp9zeutCnzVA8FxZsfRO2/?=
 =?us-ascii?Q?B0NC+b+HTx9j24w8kLU6KB0SeIPzCeIS6xgkIswyask3VUTIaf6CuF1wraZm?=
 =?us-ascii?Q?kedIFP8w5A4KabmyFc83E5cVeJUVgLE0zYJbkm0akCumGUzSOQyFOhVO5/2A?=
 =?us-ascii?Q?I+0YiolMKWun9MHrP/xohJg2jvCqf+vaik7gWxQXxYBJHVzPLxrBUhnq/GSo?=
 =?us-ascii?Q?f0pG7EfPvR1isF2kJ12Y8toCFtQyRtqHRhKLkUqZzgmJ5EjItD+upovAjUmG?=
 =?us-ascii?Q?mBCnDdmkNJgESZFCHtw/h0VD/U2CRPWrFmB+wKO0TFK+l1BFxZdfsz1S7U33?=
 =?us-ascii?Q?7lRG9Lt2Yrmhjd1dQhZKwP9ytpV2CmpskGsIpzy16rFJpDGGNVT59Gu40gwh?=
 =?us-ascii?Q?m1jX8Tjm4CEhu9y/oshuGrR5bbJ+P+0McwvbK7+BOuJrAOFAHliNiEnCuCG6?=
 =?us-ascii?Q?+23iwt0JBrOgwQc/koc+fa9k4nzpA3v9dmnhbyCOmiNwHBGGB0RfRf2P6mwd?=
 =?us-ascii?Q?hVi5aFoxBzVWY2KECjgzGdSal5ASrDO+/r5y3dVzPD7km1LyuMsyKFivF3f8?=
 =?us-ascii?Q?DRwR0IcmuBrLbTnkv2VZwoYELtYD0w9mypGQm/AoCtQeR8CyuZ01XymvUdys?=
 =?us-ascii?Q?XlGMs/UHeizaSKa+A4hDsdNGKr12Fcw0At1SzB3JnORQNY/yJAbFbXqMey44?=
 =?us-ascii?Q?/Re+0ir7AM4O25mlezx0onQYWDRgeK9F7J+25+skCX++r1Xmn8uA0PJ/Fz6b?=
 =?us-ascii?Q?WmGM0YpRO7V0INSKvXv1lo23yTRDVAeO1O3lpgB9hZ2YB1UmqGFuzuffGbIq?=
 =?us-ascii?Q?guY2985nsaWqYK1B69BQ2V/R4imr/vXoSwA82tAfU/Tl8C5/FDGFwyjgCzPQ?=
 =?us-ascii?Q?/oTtm4KQQcdoIvWuiPslm+6SiHdTbt+NVl2Gf2jxDdWWWO05/+vAB+K1ZNye?=
 =?us-ascii?Q?sUi1MeqmbywlOt3U9M1h7AOpIkuPHxMfa0gmTxZ0wvbHIr9NHa95V7zrYjnw?=
 =?us-ascii?Q?43r6V7F3fOGHpqGIoGhu0lmN5+Udm0yxUTW67BAGeEyvo4gUYFw7qoztV4Bn?=
 =?us-ascii?Q?/XaqdNCvVVI9r87+N3ZR1K/i9SRa41ALzXvnOHpoc4o1pv8+w8kRPqBeglBg?=
 =?us-ascii?Q?ePcg2MVsUtK1NFGnsthWrL/s83Ob0csxzHIJCX7QU2h0dQ21kpIYBd9Wx9Rt?=
 =?us-ascii?Q?R3f7IQtN1JIglZAlB1Us3ApYWQ3yian2zubKnxDyx6cYtQtEmDeSvYDgojZn?=
 =?us-ascii?Q?Wvg7bdIL/Y93kO2LGEAlpJba6ffKINjeTDxBkTsZwcCYG8uC/3no0C2qeT2P?=
 =?us-ascii?Q?+doJ6ia7PirVqLfrjNlDn1VeSNwyNGb4IwHDzz4HjbhZ3MjVCcD4Rt5oKClj?=
 =?us-ascii?Q?Z5QQlObuM0Sef6/uEi6eDOOjiIb9U6lb+I0iB3epvDenluCZz6hFQ5Xnp2gp?=
 =?us-ascii?Q?AJ2ZdvBbotZkPQ96J39/YDKCu2Gmz+r4jPqxH14Tue0SS2JqAN9H2mJOYAl5?=
 =?us-ascii?Q?AXj0WQkPG3/L8n+/EL3kj/J3+3mRA4ak7LqngqnBmNVkYTnpdLNn6Z+ls1e1?=
 =?us-ascii?Q?dokC/Q8/SYBJzwWiediOowiwPXJw9g0=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dba47b7e-0ab0-4467-1739-08da39ccbdf7
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 19:21:15.2513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQr4fjX1Fr12ObNRq3prtegNtGt0NGOOXJypzTCdMRgYOcbI3qvqfXwIk04C1ZMK3H+kXO4W9rhG1GIHrNTXLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2820
X-Spam-Status: No, score=0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

is_single_shot should return false for the power_of_2 mask

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index cb258e1..c9d451b 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -267,7 +267,7 @@ static int arm_tod_read_trig_sel_refclk(struct idtcm_channel *channel, u8 ref)
 static bool is_single_shot(u8 mask)
 {
 	/* Treat single bit ToD masks as continuous trigger */
-	return mask <= 8 && is_power_of_2(mask);
+	return !(mask <= 8 && is_power_of_2(mask));
 }
 
 static int idtcm_extts_enable(struct idtcm_channel *channel,
-- 
2.7.4

