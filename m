Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0D620BCE9
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgFZWqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:46:52 -0400
Received: from mail-am6eur05on2082.outbound.protection.outlook.com ([40.107.22.82]:6168
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726110AbgFZWqv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 18:46:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l7gtVuKx+v4bo4hwaQDpoRmiYECZnWdRxdXJdO6RZ78ubhv1x4NpZSgqlzXxzxowY33wZux60ZZl1mqmO1lKQihyYLXetEm477R4T8gg+i0Bu4r+A16xY3yU4KVXA53FH9kmem4DCQ1qO+Km+TPkit4mltoVWiFe5wQCi0bZvw+WUOvSbQFVNfQ++Ea3CVbtfdR3NfgAarfDA1SNde1fi3kHXctFIMiqINtjjbxiMAq9/XVZWTG/jc4kEsNBVPBrbOUhTZVXpxsWnf6MUrc5tumdQfLvomPRyBmQPcs1MmioCSMhtdF9HW9RYMAPXPEMmwbwAa4Dnd3IW2T27zv83Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRxdpXo7jQzFsbHqqUB0EBJmSyht6vtbl+S0T/P/pLI=;
 b=oI17y6A2Nfot/zYm8qduMGAwHzUXfFYcuqaAEE2beLYHK+IEIFvfB9JTfmUyEBI7R0IqE5OhSEpOjyykTafUfYivySf4isoZmrlbKudzFczLv0tdT6AjqVFAHane/Qz805BioBYBmCeF9P1e73UM8IT9UuQyEMhTPSTaVQkKNFiy7DF7Sdf5hw36ffvvxt7Lsma3gkgjCtvGj6Zf19/uN7uADLcRVCIhpTRKgdo8/d6Xok9Sovg7uicnvrhtYOghNfELQsREi3/g9CDxcJp03i+Av5uDe8aOLzUMKrncLPqGNIl27c+bMdOOwkyFqtC0oKbN+CA4dP+HtLVDrZ6zLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRxdpXo7jQzFsbHqqUB0EBJmSyht6vtbl+S0T/P/pLI=;
 b=EdtUbrWKgyqedhHZ+1lGaLsjOtJIqMjCqNsrBvscu9S5DEL2BeqQHZaz0wakIxKQK6+Ck64uxc7flsZXVYDesN7Rru3suRbdZdRBUXg+6XlmBmvkkbsZ17yiZnC2la+H15Gj+QHELANHCABiWUS1lk9nEI68n/gHyMxMw1HyQow=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3196.eurprd05.prod.outlook.com (2603:10a6:7:33::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.21; Fri, 26 Jun 2020 22:46:18 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 22:46:18 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jiri@mellanox.com,
        idosch@mellanox.com, Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v1 1/4] uapi: pkt_sched: Add two new RED attributes
Date:   Sat, 27 Jun 2020 01:45:30 +0300
Message-Id: <ea058286aa9a3dd430d261e61111cf5f91c857bc.1593211071.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1593209494.git.petrm@mellanox.com>
References: <cover.1593209494.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0139.eurprd05.prod.outlook.com
 (2603:10a6:207:3::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:207:3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 22:46:16 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f736c954-a8a8-4412-31c1-08d81a22bd25
X-MS-TrafficTypeDiagnostic: HE1PR05MB3196:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3196BCFC249EF4FB5CB665BADB930@HE1PR05MB3196.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tQVmrWrXXz8pKTyGVy6xj1jHgFXmWoupYzgHkWjrf7ghQtCTEoHLPi8bRjOFZP5FkEcQPfmzGADr82ce1AoejDgf6+DusuDlqH71vHwHGIZhlQIL/COuMPs1YzBtpPlgtPrYQnV1VNcqgvpJukJU0uNypAJFhIQwYIOIcdEnWAReci7MjKdQbVUEYhde9CTXYzbwWq6euYQPeniD45UpWW1m3/bb66OUDKOm6+PjfpnXv9QqSTkg2zEg/2PYjLhv9t1ohKrxpCpZxWeHWEDKudxgamJpi8QAi8UdF4tbjlp4hMBXqLVaCqTyT8cnjYHttPxx9PYi0JpEBDjALUB6rA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(5660300002)(66476007)(8676002)(956004)(54906003)(52116002)(2616005)(6666004)(83380400001)(4744005)(4326008)(6512007)(2906002)(26005)(8936002)(6916009)(107886003)(66556008)(36756003)(478600001)(86362001)(66946007)(186003)(316002)(6486002)(6506007)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: x2qTuYw1/t1jMHb9V94tQ5MoL7UE2kF0mW2n4fFgv0Div074VnnzOCwyu3X7qa1Yw29wHpYbRal6rtgNMSSIZ1RxxSUlysGetoTOY7ma2Du+swSZRoN8afErn0EO8cog3JJdd+hJPUv0K1Qo4oHnm9rlG2p57ztpE7gr8Pa2ipHp/ZbVZ11iHjPMjGRKC+kp7YOlP0hWE7oprCUYl1brbGJMl/wBN9YZXuTGPqtrBEgI7QVZyfnnUEsTL9bn6HK9iTOUDpVXVlZL4htYnc0b6rgMwj5yPzD0eCfukmRFr/ysG7w+OZ1ZES8jpQEScmKRdDXomYmnty93EjGKHVMo46PNmxivapP6nskUwyj3vhH5QdhDJOOjkVYmedxFnfRWo5ovszVkgdrg3MzFhRnFz1FqjysHEh2cU5iPax04DtbBhsM7/tinC2Z0101Jo2docVDzxulws3EaZO10OAblFWr7MyMxiGRue7rWpCS7I4Y=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f736c954-a8a8-4412-31c1-08d81a22bd25
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 22:46:18.0195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQO9N+JiFrBEexYsEiJQS7TG8ATrwmTdzFIZdo2caDuyNY4+Ug0qrQNYfG7sP9D3JCn99xAuTMkj/Gh++L1XWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/uapi/linux/pkt_sched.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index a95f3ae7..9e7c2c60 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -257,6 +257,8 @@ enum {
 	TCA_RED_STAB,
 	TCA_RED_MAX_P,
 	TCA_RED_FLAGS,		/* bitfield32 */
+	TCA_RED_EARLY_DROP_BLOCK, /* u32 */
+	TCA_RED_MARK_BLOCK,	/* u32 */
 	__TCA_RED_MAX,
 };
 
-- 
2.20.1

