Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BED4FCCF8
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 05:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343875AbiDLDXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 23:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbiDLDX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 23:23:27 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2090.outbound.protection.outlook.com [40.107.117.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C731929C;
        Mon, 11 Apr 2022 20:21:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYoIEtsKgCOENEKIes8PxUE15Bei2o19w6c4ZaKOf7rAiZT0WJ8VQDj8bhkniU3+FcjCYBIgwqhcWmrQYtfKCDGuUccv/mSQ5Bwvz1b38TF8RGcPOz4NikLNJMAio3VrKVFKqNBQAHIkzJIoXWP1Jr2n4qQM8c4VNchCGxc9dWPUdfvy/kJUDp3miXjz1d8iKhO42sHv3tmxiDQckg0yJo57v1ezMdJ8oaIDgpijqRkgXJdP9EgtRrO/DLlhIhPb0boCxkIOkj35Ut/GGLitJoIz0QL4S8LGwkaA0tEmHHJutF5i63XE8bCoTrYmvwahVn9Lou+7ZfKaC85ukAc4sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7ww1Z1CJPoMaxPfrpWqV/6jgNlTGISLUiQRpm8c6SA=;
 b=DQHp0qMyBI7Pu//CKkAD1Kesrw7+x5xmgjGKtGsMoFibix7goebTHgW3JEHByFMok1qmyrxgbBgBJAQJQhWkJHgwb1slkPLbloFcHIcCpctF7W4ftNtlZ5WesRwkV8bTyYOLIkHphjdHRV5upUggmgs5Kq/oQxXXHm6aEjRMhJm0KBnKLvMXN2EKl4IYpww0XW72ca4Vdv2IgQJvJEcH9bk1UGe7FeD773rw1q8O5euJXi0b1qprpuxtzHPM5hcL2JRCSLm+UQXJ4LY7IO6EXv7o8YCZdWggh9CxR3QFhzJVz6ismcg91g1YO3u9r7DI2i9SqOHv59TkTIVKT+NNMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7ww1Z1CJPoMaxPfrpWqV/6jgNlTGISLUiQRpm8c6SA=;
 b=TBGECgx7YTrFSmizoksFMsQDJFf6jEb2qJ7TyX8Jhs9ebgOec05wKDLBUrssniJRSrKIcKNumO73pyj7G5faJ36AURqe0OZb3ZShbUHkTyoye8CdsRhlQekjVf2w6Va6XKwWwnobTU3aAMqK1dUQjaHM0nUmQVALLSxOOpc9i5k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by SI2PR06MB4637.apcprd06.prod.outlook.com (2603:1096:4:145::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 03:21:09 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::5aa:dfff:8ca7:ae33]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::5aa:dfff:8ca7:ae33%6]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 03:21:09 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6]),
        linux-kernel@vger.kernel.org (open list)
Cc:     zhengkui_guo@outlook.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH] ipv6: exthdrs: use swap() instead of open coding it
Date:   Tue, 12 Apr 2022 11:20:58 +0800
Message-Id: <20220412032058.14136-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0139.apcprd02.prod.outlook.com
 (2603:1096:202:16::23) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc0f0dfa-128a-46c9-00ab-08da1c337cb6
X-MS-TrafficTypeDiagnostic: SI2PR06MB4637:EE_
X-Microsoft-Antispam-PRVS: <SI2PR06MB463722EDAE2D8386CA42ECEFC7ED9@SI2PR06MB4637.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Ux4jptunsK2aEFBy5dj3jjtzGr8pKXIKc7yt2lsOzJ0cLz1QxK9lT2wg308wUpZwsZF6wP1dF/clWwpKdGEjCg26swpXX54PP6N4dyCa4nMyGAgPa2B/jxXEpDUKbNvFm5v1DT7F2cHCgz3Mon1AC5YiF2AZg9iCwURonJNdt4XDiS1TfmKwFD9rvezOoS2mH5Llu2CpVS/Ux7wz7ilIOHiMgsb8hr3vzwCQPXg0u+X6pSI83mvKNP+dbZqSyAYPK2tnOsyFcfA4AOurOFvGJ0k6oZeo8SY/pMm/ewYvmLKaLgPYlzhADtr+swtrOnBrXOF2FSMec9PcY6HPosYa392govku/MdubC/CufIYowUCxUePvx1SdAkl6tmaPWxRfuARIMTQuXxDdmK2QklH0BfZ8McQxP9bFjUgo/nxkBrUR4yori1bYskYsNJvuGifwQDcRO5cH82RQQImY+ZsyZ65HEBVITwDpahdZNYyU91UDFbpSpBOzaIzUqndb9MB6R0anoWe5EqRACZpubYQ0UiP9W0/p/6JuaTzsRDdF/PXoarRrAnGV8iGt0IeS1qrdo6WpjJG6vw7LTeaFxRDOlP9Y6gK6Dgk0koGbCuzB24MkDjdcEJFQSUK4wVnuQVa+3DQdU+3Qn615X4QRQuKGSiTMDKMgnVl8PlVVnObTxJtKiqq6BUctgNoA7GrQ27OyvLS0ZMhf3E+9S0yPlk1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(6666004)(2906002)(6512007)(5660300002)(316002)(2616005)(86362001)(8936002)(1076003)(6486002)(66476007)(66946007)(66556008)(8676002)(107886003)(6506007)(4326008)(38350700002)(38100700002)(110136005)(36756003)(52116002)(83380400001)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pvp7Dq3KOjIz3W18qBFQLEqwxU3xj9SNq7c7+qbN4qJEDgL2RfvXw9bceu8c?=
 =?us-ascii?Q?wnwyLgRVxCTjgTS77fSTX+gaCQHQfk74Qj/4EHnjoLG1r/jVJ2C8y6X6c+T+?=
 =?us-ascii?Q?UpMl10980i2TP/57bUuXMn60GBfYznrp8/UcZlTBmEoLqve7bbTbFPhLVUrZ?=
 =?us-ascii?Q?8Ksq9ISRz5+PA7UMbaq9ME0jL7FQIu7oxc4NkXDhF+IhDVj01xGI5Y7D1pib?=
 =?us-ascii?Q?AlnvFxIqup8pMuep/0QGcqI/A0DmXfZkOCKTIet9051XJJdbvFRk6ArsD3w5?=
 =?us-ascii?Q?kL3v9r/DnEycKkaXXzDoRTDuukMghvcYC41L2MYxkvDuqKwjSs03ZiDAPtTY?=
 =?us-ascii?Q?tHcC3imwwzyeQziPwmoOnTf8sE/jrerPNxi+jaixcwpUu7uiZetqm2d5atlQ?=
 =?us-ascii?Q?hc2BQRPQpQWSuGLepc+pd3GA0hESfLB7Y0EDWp4oP6dYiALBJS7cQpdfloY+?=
 =?us-ascii?Q?gjO8mRKXQvPteBSbHpsz5yRcyOefgr7kNAtUd/JffUzwoA3lChPwApROSDJS?=
 =?us-ascii?Q?ErNLzdJyGY1x2+Vc1UuAbAnLXbJwIlmAf2ffdoWKz4kgfAoEVkxMEvma730e?=
 =?us-ascii?Q?Xj7aHuOgWmDadW+bdGFVDvjPhtzGavEdWk79DZRrLISMj6UheXlpiGAVFOu9?=
 =?us-ascii?Q?lbouFFA65VRaOmCcHt9y/yFuyxZowU01rRp5m6GzR1GEs4Feq3QagbeStyic?=
 =?us-ascii?Q?hXCnrcybxf/peHPZExeByCxrnZq9y0eobj1Jf36Cqv5eTApAmMnjzfwFwKJr?=
 =?us-ascii?Q?TqYtODLmILglqPKrG52wcBPRGlaQs3296oXKmGAGhIRQmHUjWS4bV6tG1lmB?=
 =?us-ascii?Q?j3124mJq4Jz28i0UlK2oXyJW1dmoDmWGGeKxE6kQw23HW6+12vBDRWgqLcCH?=
 =?us-ascii?Q?fLf2SsLkzQ7VWvRKizSqkA1XmQ0fvTd1GMO6oERfnqG0lvroU5oxV5Uti9hv?=
 =?us-ascii?Q?laI9Vgss7syL8NJjQAcXf4i3I2tlCiNkt2tSgsRIKGggzP+rzzYAIUpGlw8b?=
 =?us-ascii?Q?bWkKSw2W4BGi+pK40yntIYfGCQC6BUtpGoQSpmEZyLFhUsQRk1W0AGMsghaH?=
 =?us-ascii?Q?qAz5LS9gwYM+LJFyCy/b9oU+hlHERAPfrMkXaIWy7LknPAbnWZqgaHjDv8Bv?=
 =?us-ascii?Q?8tmjsOMBP+vNgz0cjnSzs17dXogg+WVt34dXMEUS5WqV5EkiGMwpxQp7iBlh?=
 =?us-ascii?Q?v4kR/P+HVLRmBLEfBezD8uWxyilVHLUD4EkYEZeSYD9xiteWBMbfGv20wh46?=
 =?us-ascii?Q?ZRIVMZidhp0ZdQ/aHpWj0rxzXTNSdYae4R0GvSn8070firpWJZlljLmsGJRO?=
 =?us-ascii?Q?cwOO6NUHTFKJSPm9CMde2x1w+4u04Fxab7rJhQF1NOwsZC/E200g/AvbKjDf?=
 =?us-ascii?Q?b/MV3aEoZaMh6HT6eHdU2HzhnCTtoou4dMlXM0/IylKk0KVGKnAEDA9n9sQ0?=
 =?us-ascii?Q?YaOi8/Sa3htMkdXl9S7S7X3eVUWGqacqp+vscAShQ4kfQqrlWT76hHtgwWkk?=
 =?us-ascii?Q?R8uUTIcDKQtEtITBu1wFLjbo0HC7o+mKUM37ejtg8R18988FGHWuxpkn3OP2?=
 =?us-ascii?Q?IyvdxnKGdhHxFRw6lNgTXZjW1hH0zJjMNMmUv1ejWHAO7bK3DBuU7F3k1MBw?=
 =?us-ascii?Q?MwDU1wsZU5B5jr1EFzi2g/WWiSvrhVyrbiyOdo50JnKumIkt6j/ySGm9Xv+g?=
 =?us-ascii?Q?LuxqzfWSKPH5d6ISV+ZCQWhqgplCovtmUYWPKccD6ylEo205q811LqzgbSgd?=
 =?us-ascii?Q?4yHcmuglCg=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0f0dfa-128a-46c9-00ab-08da1c337cb6
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 03:21:08.9121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: orEaXIQfYDFJNscZpMakdQ9zC16zDph+59/rJOq67vVruvrLL1ZD2kZHbKPq/082L0DPrU9GwZ7q8iXWrROfaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB4637
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Address the following coccicheck warning:
net/ipv6/exthdrs.c:620:44-45: WARNING opportunity for swap()

by using swap() for the swapping of variable values and drop
the tmp (`addr`) variable that is not needed any more.

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 net/ipv6/exthdrs.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 658d5eabaf7e..a2094aa1cb32 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -487,7 +487,6 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
 	struct net *net = dev_net(skb->dev);
 	struct inet6_dev *idev;
 	struct ipv6hdr *oldhdr;
-	struct in6_addr addr;
 	unsigned char *buf;
 	int accept_rpl_seg;
 	int i, err;
@@ -616,9 +615,7 @@ static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
 		return -1;
 	}
 
-	addr = ipv6_hdr(skb)->daddr;
-	ipv6_hdr(skb)->daddr = ohdr->rpl_segaddr[i];
-	ohdr->rpl_segaddr[i] = addr;
+	swap(ipv6_hdr(skb)->daddr, ohdr->rpl_segaddr[i]);
 
 	ipv6_rpl_srh_compress(chdr, ohdr, &ipv6_hdr(skb)->daddr, n);
 
-- 
2.20.1

