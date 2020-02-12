Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2558915AC3B
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 16:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgBLPnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 10:43:52 -0500
Received: from mail-eopbgr770133.outbound.protection.outlook.com ([40.107.77.133]:5505
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727026AbgBLPnw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 10:43:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMwKe8eh2r0DtCGZhDOK8/2kYJyIfE9zFeuZD6G/M/41WMgomXBizmS4pOWjldW/z8nBXkkrOORWY7pm/ye/32ixA0L2PYkkYDwbt8yGtTLJCZhTUki3GeDKCFaZ3z4q7iBo9/X+cZud/SXKfZbxXBTNONGd2ckOcifcSzKhtEV+qtocBiTFAQ3KaMWAeK880TYoDFil6IQ1bFIZ2wqlDs4gnbtswkOcfiNvwd9f0Fd7vcL1jNyTnmoSA2ptmgkTZfMUTH4kDTgxlAPF2dNVSfjpPb85p7kK/Ixma+8u5DQooWbOUfL2ZOoR6yN1ESqyi4H7vg5gz7t0h3JewzNarg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdACdbUyUzv7/HKrkFgUvgyXHqCzNqAs7/9+e0Gmy6E=;
 b=kbRqj8L6AYpRI4rRhZYAtc7L9CN58YfaR0ZaFv1q93a2X4zSYyMQ6PWLZbec/sQmT+qUQum40kgwFmDkCLkz1Kc8IHzFXtBsRw2MRwYNsHD4Op3oB9vGHCrbSprmHo+KSnHmFDjcMD7v8mryQBv77eiihlOvO2vvxGhiLQrngnE1oi+PCB7Ox3Q7z9AbCICBfcbbmmd/vfcLKOOWQUUeVLa2rsSmwyaMkVMzM0Q8zLCkV7DdxExXlU2jhAu40KrGJ6PfMZxcVn/X8+cvxYOfI5oS5atWy61lbrEqydTL0JGssr0f43kp9FVL4xFBle3Twh9V0vFhk4xTGh++vI9csw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MdACdbUyUzv7/HKrkFgUvgyXHqCzNqAs7/9+e0Gmy6E=;
 b=ehjoQFFjnBrBjx/4Dc7KdUVlDwMxCL8VTJQ2pILCmgjs7iJUPMLO6ZnGdW7KiOw3whgVAgv2it6Zbib72KtXaglMpKD1QVkbV/Vm/R66PoeBvKblK1//DsGPUgaT0LT+SlsdF18VC/vM0RMIl+zLSp6uRuuE5Y4oRKlOnbud+Po=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (20.178.239.29) by
 BYAPR11MB3846.namprd11.prod.outlook.com (20.178.236.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 12 Feb 2020 15:43:48 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99%7]) with mapi id 15.20.2729.021; Wed, 12 Feb 2020
 15:43:48 +0000
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Jethro Beekman <jethro@fortanix.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Jethro Beekman <jethro@fortanix.com>
Subject: [PATCH] net: fib_rules: Correctly set table field when table number
 exceeds 8 bits
Message-ID: <ec5c8c2f-34c6-bd70-7f61-7ed14b358d9d@fortanix.com>
Date:   Wed, 12 Feb 2020 16:43:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0436.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::16) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
Received: from [10.195.0.226] (212.61.132.179) by LO2P265CA0436.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:e::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 12 Feb 2020 15:43:45 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60bc2b2c-89d6-4ade-836e-08d7afd259b1
X-MS-TrafficTypeDiagnostic: BYAPR11MB3846:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR11MB38462F6D038C489FCBB51573AA1B0@BYAPR11MB3846.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 0311124FA9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(39840400004)(366004)(376002)(189003)(199004)(52116002)(6666004)(81166006)(8936002)(8676002)(81156014)(4744005)(316002)(508600001)(16576012)(110136005)(6486002)(26005)(2906002)(186003)(66946007)(66556008)(86362001)(31696002)(16526019)(36756003)(956004)(5660300002)(2616005)(31686004)(66476007)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB3846;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6wU8OrUxQKXWyZJWyF0vqpHXVY9nyojUFtVRivVDP2iJBOzUMI66SbNt2zzYfJSlyjNMET/zThRSEJNn5TpNCSPXseilh7pzaSfxzTMFmDrLbNSgrJFJdkLHMluxel87rzH3X6q63eRLBZ0VyzCS/YXKaPM7GPK2Yj2Mzsbcd5hMfVI6XlmtH/gD2qvzWxGJTcyKVwsZNl+RDXQsQLaQVYJgzPHwIhFI1stEe8TyJCCHmfcjEXZ2t12w8IC+jqhR42DTQDV9g9cMvftYqNpuf9P/RqgPjQpHnXdeoQf9KgH2SJLVXzO3d86uUj5OmRvX4+gD00bllj2heXyQ7iOUQwrT+XtAs2+lbK0yuq4ezXBVWBZXlkp2i4rr1Sq4OqbJf37y1bzku7q3WUBcd4e4fH5sA/505gsMddCL5yaQMXalmXyXWaz2uo4MsVB6F1zTvYX2oaq2gztinS+EwdX7W4q5C+lnZnlA+fxpRt0BC8anZ5NPPiU+5qG+7z5/5ekO
X-MS-Exchange-AntiSpam-MessageData: P2wajyEvZo7OmnCbo6mDcwQlDbtZJ1fWCAh54DBit8sPxRIisldg6x7FxpE4wCkPct9svgo7SEGNLQZrVXdm1B/eV2w2qFdpGKSgrETUFS7HB8eVVJB8croxDBVUugPpqEBqIHJxKFXvxpMTZc4XAg==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60bc2b2c-89d6-4ade-836e-08d7afd259b1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2020 15:43:48.3810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MRzolq/z8R/eDFCpru7unWUr7MZ3L5AmcAvx2xb8/jCwPdT3igiJeOCkks7Ug02NhNWBB/MY8RpkFtoMJQMNcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3846
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In 709772e6e06564ed94ba740de70185ac3d792773, RT_TABLE_COMPAT was added to
allow legacy software to deal with routing table numbers >= 256, but the
same change to FIB rule queries was overlooked.

Signed-off-by: Jethro Beekman <jethro@fortanix.com>
---
 net/core/fib_rules.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index 3e7e152..bd7eba9 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -974,7 +974,7 @@ static int fib_nl_fill_rule(struct sk_buff *skb, struct fib_rule *rule,
 
 	frh = nlmsg_data(nlh);
 	frh->family = ops->family;
-	frh->table = rule->table;
+	frh->table = rule->table < 256 ? rule->table : RT_TABLE_COMPAT;
 	if (nla_put_u32(skb, FRA_TABLE, rule->table))
 		goto nla_put_failure;
 	if (nla_put_u32(skb, FRA_SUPPRESS_PREFIXLEN, rule->suppress_prefixlen))
-- 
2.7.4

