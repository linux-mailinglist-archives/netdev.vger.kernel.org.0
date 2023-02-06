Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F18768C753
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 21:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjBFUNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 15:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBFUN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 15:13:29 -0500
Received: from DM6FTOPR00CU001-vft-obe.outbound.protection.outlook.com (mail-cusazon11020020.outbound.protection.outlook.com [52.101.61.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A901E1FF;
        Mon,  6 Feb 2023 12:13:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYAzGtgS3n6tCMP2USQwBcpyvxFVHUoHzDzL6vsdc+HkifJFYcDQYtdF8NMsO/iZA1FRpUfw7vd1NgrF4AwLmCVsUJy2+VwOd5/IWG2uiBEBporRz5f/F9wjG5K2OCIiPbGIvFRJYUrZNa0LIof6DfctJpDKNgWebMJQjL2ZcdHhQwhp+Bii4a8OTNbIqvho7UCTAY8OufMsY5f5UR/H3R8H90Mt0X0uAMmypGyopxiB4R7PH49adpafk0hjGgrHX1YY2SUE54X7myTeFFkaNcXqhF3I3A39vE5D76VJyPauTHDBXEg9eAAjKbyaUWCVRRdbUy1VTbSV2nkjFkBi0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kyfb0hce+mSZKTzOiOV7UL6r0/baGHq/9l02z4uxB+Q=;
 b=DrbIlqdAb+63OGAFf2DyPODl/8X7I5o9+rUp3+X99wdeUHJMVmBtz9r5y4UJiuVp3+Pq7/o2ka1Rz+UOhhn7MpCZp9Jgi8pJScxpMbuGCIHk298Ilh2qNyv72g946utDiOGCzE155Z3zOCtKWxoDn4Vi40eeZk896z3O8JQ4ra9P7aXE7sXhqUk+0RD+aimhYd4FZTLgTK0Ncfo2BIl+xkqwSCUOLGDxmHFcdt0PD0YtSa5P57mfezzbCUrzAqUTxa5H5W8iTBsV4kFJQUKsZEBhjfJHT1mFc7WkpEWs4SWV/MuLfvDNpunPW7c+Q/K6zbP0kOccvUNnsBZckjX1Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kyfb0hce+mSZKTzOiOV7UL6r0/baGHq/9l02z4uxB+Q=;
 b=XQnIub5NQNcU2rmkDVTORS6/C3WTfRMBqxteJRvZkHzMIAgMmRcafYNVk6MhNkbo3TjWw23mTmYPh2owFnquNRTYVYFuXVeN1v5K8YMTckt+CVdwYhp2cbF0fSRZBwiis1vi0Dl/w1XOIv5UjcZkpLPpK2TV3eOn52JmGb7hQeo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DS0PR21MB3863.namprd21.prod.outlook.com (2603:10b6:8:122::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.1; Mon, 6 Feb
 2023 20:13:25 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::ef06:2e2c:3620:46a7%6]) with mapi id 15.20.6086.007; Mon, 6 Feb 2023
 20:13:25 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     mikelley@microsoft.com, stable@vger.kernel.org
Subject: [PATCH net 1/1] hv_netvsc: Allocate memory in netvsc_dma_map() with GFP_ATOMIC
Date:   Mon,  6 Feb 2023 12:11:57 -0800
Message-Id: <1675714317-48577-1-git-send-email-mikelley@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:303:b7::12) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR21MB1370:EE_|DS0PR21MB3863:EE_
X-MS-Office365-Filtering-Correlation-Id: c66eaea9-826e-4d68-4b43-08db087e9a40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GOpJIY5VQ1c0k0V3Fp0acZ1NOCns2SWiaih/SyFotY0VC9dDkUrSzcfMNVceXCFTIu0zmelhvMVn04JQh3eF/V7DG/cVJCFYwhuwbzMQKagDKAQ7aY8nXfGNs1ptJ0ZVT3sTQlk6KP+Z8geE2LUyPe/VNJ76a2Apq+Sa91aCVijPgB6O2STBPZDjjQ1gf472SFkbIANILqvNjjpXFTl3MBKitBPaLsKIp0dah/ZHOC07U4kasbHiw86X1WqjRsvKcyL4eFZ4HwgHuo6fIM7ZJLHma42Krp8YV3rqbn1gzgl0y7IPcFr40u4EJdMpktWHPBG6UqmcE/PfHN8AQW7ehFgtYYiTm0Bh2fmDcqfDxpfsFpyZ+RUlqQ/S77rv2oWImWEUtjlS5EwzZ7wLAK5BmMdlMquQgh+KVDJpOSBEXTiQQ2jRZtJM9zPnfoa7AnEsCS41H8GusGZxEyziNdul1Hz0r1HnMDUl9Y4+1fFkVzOKfptGRCMpTMgs6EoTXHULTb7PBn5JxtHt5ecGhdYNj1gcoXIDtldkPOztwRI9Eqo0AUczuTEx3Kl6wUpBSnSQXX19YIv1IU+nCWH/Fg3FoQHRohsuOKS9uejH6v+lEdRFWdE25BHNtcqB4nKOSbfoUa1vqBkM5YZO+hCo8w1z9uMy78NC6lYCP8Ljhy62XcHUELxMujjfnJae3ZWilJF/JdOsHAV4KhqVpNy5Pp0G/OGy5aS7FpriDNKKa59DvVBh3DEZgsT0pbE8Ty6/yj8T26VA6q6d9hfhQEc/hRAyqiTX1uKFuU3ofOlOGvVsZbA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199018)(5660300002)(6506007)(41300700001)(86362001)(6512007)(6666004)(26005)(186003)(4744005)(38100700002)(478600001)(8936002)(52116002)(2906002)(66946007)(66476007)(8676002)(83380400001)(66556008)(4326008)(2616005)(6486002)(82960400001)(38350700002)(966005)(82950400001)(36756003)(10290500003)(921005)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ovd/OdiP410segRK/SBesVa0EbcfiRaGOT5SEs9gnH8YhUcrzVX/yq5gnnn6?=
 =?us-ascii?Q?2yzFnVj2JMzSJzA68wAf6YGqJ9nGg5Q0zgWxuIZiUZiDnky1y9bCOhk4k20k?=
 =?us-ascii?Q?PQb+1jydnPrRVr7ElE8uZ+zuM5QlKkTqWKgvFvmW3r2jidFrxkyPQW0NpQUM?=
 =?us-ascii?Q?yYgsteFTkafGYKaW34FegWFr2UVOvQdEppwgVCTh/gF8UW/WnyWdNFsxVrQj?=
 =?us-ascii?Q?1pOse3yvgCiwNp0KYIpewFXTP3vrPm71eFFZML4yk8Fnwmjapv7vKQH5GMDe?=
 =?us-ascii?Q?wIwR0f1uzojeiZMHT4XRP0RIFxvClzxSf7ylGf8Q4A/+Ds4NpNQ1KRtSdl5S?=
 =?us-ascii?Q?OsOJjRmqYHnPlgwTZxtSObqoKa6xRDxYRlEluZo/whLXqb7x/eEuRh/tLd0f?=
 =?us-ascii?Q?e5yi1oJe/8vbhwMTgC1mtSZilHTimn12NJJeWksJBeri4Dn3drVvhi3Sf5Bt?=
 =?us-ascii?Q?QGo6eNiho6EuXs9VM5vKLWG/2LnmNkgSh1xR8N85BMhE7K2fmEnVKfzQuVI2?=
 =?us-ascii?Q?3uQhPShR2Vj3qed2S+HAN1Dx2WJ/PyjlHpKztJRcBvUiS59kboJ20VQ8fgUq?=
 =?us-ascii?Q?IHyNsQkin/BTykIve1o9eshZr+rfhu3T5s1BaHr4vtJOILtfQvphrTFc954m?=
 =?us-ascii?Q?Fk8RfXQPZJWddIKQV6dFpd8CYMlrbSpJDXFuVV8Up19BHXTKvzQr5N7qsY/7?=
 =?us-ascii?Q?LmVwwx+lte27yAg5/ddYIAQn26ZIb0o/LzsOG0JbgBpa08pVZSSJdnT227XM?=
 =?us-ascii?Q?t2QUIooA5bh2+jnlPT2LmnXdvdB3BhMygPPBoUYJ8MTUq1HCngBHtSaV/EJf?=
 =?us-ascii?Q?C/PwDgAtCBcB0Xey8Y4aAfXy0gqdpNapaA4hKdzpw6YTyzEr80Vt2A0Hc3Jg?=
 =?us-ascii?Q?FcRbsJJjhpwoj4Xb8IxzJ9txc/PJ5aI/FADz1VcTf+XX0FDZQQj6ODpA7V5M?=
 =?us-ascii?Q?Jeivp7kjF1ZcEoprZe5G1sD3Vj7emmoOgxSu54t2nTB+9XhnmhHwrpQ7j0iV?=
 =?us-ascii?Q?7rbHADt1+z9UgrXhNfvkNizXsyNtc2MkgktGhGRsjnaEIoI0P7JLWC283sHn?=
 =?us-ascii?Q?IEmEQBoPNnbE/xkM0je1GvekiGsNTxMmUNrO0Oo59ZoyBGv1XYu7Izwf4HMl?=
 =?us-ascii?Q?HPTXiRvJH9sNrHmQidH1HCmgvoRIxVelY720B/bTClbjwmxB744ebYWrer6j?=
 =?us-ascii?Q?+6X2Fdogr/YmDWtDoN1K2FIH4luesr/WKjwGTQbY7NOtGxM/5tMKvCCzZ2MP?=
 =?us-ascii?Q?qJ2hgRq4rhSatm4vvOHbRsUkySdYoL1Yd/PIIh7GH+ruH+CACD9VCgPy+4HA?=
 =?us-ascii?Q?0qDF/SpJIEmDC4JtbYT88tzxYa126B0+ZREfiGVaSAqKQsrmpNF4bxMe3xqf?=
 =?us-ascii?Q?teGu3dN9cA6Sx0xca/+iXxRbvooXTNXYpCs9hSg/ADVv60Wxrj/nienjvqZH?=
 =?us-ascii?Q?jH0ilQibh3C/TSLKsxTf1bJH1GhVE/iXnoucgQHMN46iuOFm1QuRYTCsvazd?=
 =?us-ascii?Q?BhGun3lCsPySli3WeuTSN/rcHSa76LEQkaOm7+v+9tJ2PMq2yvWwV7pgwlMz?=
 =?us-ascii?Q?Vwf9WyVN8Ul8dagGdyAviBQ+QVBQdODsgPvF2VWVKz88aHsZV08+8MVzqNE5?=
 =?us-ascii?Q?yg=3D=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c66eaea9-826e-4d68-4b43-08db087e9a40
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 20:13:25.1425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3jtIQUI4om8WfpZq3M2jLDv6LD0XWultO1JLSRQ/xLi56r6Z8z6+wRF5j8/iPVfKKwz9d5ibBn3A/wUPTATBkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR21MB3863
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Memory allocations in the network transmit path must use GFP_ATOMIC
so they won't sleep.

Reported-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/lkml/8a4d08f94d3e6fe8b6da68440eaa89a088ad84f9.camel@redhat.com/
Fixes: 846da38de0e8 ("net: netvsc: Add Isolation VM support for netvsc driver")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 drivers/net/hyperv/netvsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index e02d1e3..79f4e13 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1034,7 +1034,7 @@ static int netvsc_dma_map(struct hv_device *hv_dev,
 
 	packet->dma_range = kcalloc(page_count,
 				    sizeof(*packet->dma_range),
-				    GFP_KERNEL);
+				    GFP_ATOMIC);
 	if (!packet->dma_range)
 		return -ENOMEM;
 
-- 
1.8.3.1

