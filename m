Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC6D6DB59C
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 23:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjDGVBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 17:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjDGVBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 17:01:35 -0400
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021019.outbound.protection.outlook.com [52.101.57.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF134199B;
        Fri,  7 Apr 2023 14:01:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZzhkltEhnDmiX2DuEoG7ujGLUMi0cqiRwmZAAkQ2uA8AHcFJobAGk+XjySjDf9xlnORXFmESsxgiW8U7Tc2noOLnRFxl6nQ9Zxx28Ob8q+C6bapZ+IB4lJpbfnhOow7gKX0bC3l1gA+PZetDnsC4ElrQ1G1pcqcXiLJ+I6XCfWkGd2PxTewIMZDGfc+wHSlKxv3HqErgCLY/tF2PCktGSldmUfGywcXyW7YdvrltVEb0Z0MyeZxqzIao+ScFjvs3F7RdWEgwfLXX0H8vAOhjm7ESWbhEpHydYYv0+HzsG+Mc6kaJ71/LrU/9K5Bvk+sI9XMl7S1Z2wKqUlEHTjaJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuMGlQ4YMOcUOs/K0KNKKSg7ers37G6kyUxwA98/U3w=;
 b=mW1+jkOBtBiAbeoLhbUnFxvIhNhheuR+Wad9MoX/wQIsoDsMpezR2/2D4GATsmtRXggWpTUCt7JqURrbr5i9m9nQt54zPNQBMrRy3d87gzIgBvyKD67K+yj3SkgS7x/5jBynoDbGhZUgbbTOHC3guBEonRbzFCIwYJrZd0A7vRybvyHahIxbU3Keocv8TKSsYCx1NpIleGWG88f5SLFgQ9T85l57soyoqkZ3atpdYE/WdmCi+OhytmETW3ofQEuVoODwuTVO88WFKRHO1WPXr3qrc4CRiIoOrPCDRK6D5ziK8RB3kx1sLNsaj9IEfgpH3dTsI2Jo3PBYGd7bmBHBBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuMGlQ4YMOcUOs/K0KNKKSg7ers37G6kyUxwA98/U3w=;
 b=RzQ4u4Wi9dDaDnOo1GPvoQYtv3A9CQXuO2SDVQ2Q26feqJ5blXm+fFMxaKNX7F+cjC/TY3ud1VG2IwdQchTQr36ajOHzDArly+N7vCsA1pZmSFLchtqC9T6sawHCVQY4ubed9kpwJapiR0x6YNZii1ZjouArtuAVSqrj2FaYHFg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by PH0PR21MB1895.namprd21.prod.outlook.com (2603:10b6:510:1c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.20; Fri, 7 Apr
 2023 21:01:26 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::3e29:da85:120c:b968%6]) with mapi id 15.20.6298.018; Fri, 7 Apr 2023
 21:01:26 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, decui@microsoft.com, kys@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, wei.liu@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
        longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-rdma@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        sharmaajay@microsoft.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2,net-next, 1/3] net: mana: Use napi_build_skb in RX path
Date:   Fri,  7 Apr 2023 13:59:54 -0700
Message-Id: <1680901196-20643-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1680901196-20643-1-git-send-email-haiyangz@microsoft.com>
References: <1680901196-20643-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:303:8c::22) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|PH0PR21MB1895:EE_
X-MS-Office365-Filtering-Correlation-Id: c9a2f738-1a29-4ccb-5bca-08db37ab402f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mKaVheW/M8cAkBGILJTbX5h7OblVQReE+x4nndawpNWACWhjeDXsfmM3dC+i+hTXDxdNenasqCLEGUFaypG4mo7xXF/GYmDq1H25lvbiCxe/FL4qb5vgBepZ9fWBvjchMUPMJoVVrSuavMUzKYWtzVTBcGJnGvCkwLhzPx5r2OBuYVaytYjQHXp9XxTsYAxQWuwCUmONNdI1AE4IWc+CFdFthVwM7YKcSdieQgOtx4CSPsZj0ydn5QFRMTbvcahJ6lGLu4id28Hw3R4ubNE2gJwcbbPFRlaFpy3HtwBarjD0XoEujnaAvVuGuVUIgI5jS4Z3C6QcUUmuXrcrta+mUrlRLqN4FrDoC+tVjrfMfvxHQkhwjajO6eMV+XR22KcT3b0M8TGYiAKOJd9wPJ91SR0W731fgdKhI5Q9bBKjIyBZNTSgwFCapQzc02cb7bPpn89RUZS4x8/VKdLkotF3eBNAN9KH2lSZiuev/wVHeoSkX1FNT5/s4gMAPS5kXmAhDR1GmHAn3KqcbTXpYbiJB9Mib/SmXfKrm2X4sOzt9ZqjmaWHFSAHj7bY87g39HuBelSCgqIwXA4PYZPLA1VegAdG6n87lzrzIQs5A8z+x1wwmFOLsE3tq4VIOz9Xdn7Y9AiJFsHLsL01TDAWeuqP5BDGu8OP8KXU+H1r4t+WIOk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(451199021)(66946007)(6486002)(66476007)(478600001)(8676002)(4326008)(7846003)(66556008)(41300700001)(786003)(316002)(52116002)(36756003)(83380400001)(2616005)(6512007)(26005)(6506007)(6666004)(8936002)(5660300002)(2906002)(7416002)(10290500003)(82960400001)(38350700002)(38100700002)(82950400001)(186003)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?45AiUSkVPTV0rkXc7iUg+0OcWClZj1zvjiKZ14zfZwWMQ/+V5TD2yaW2kCe3?=
 =?us-ascii?Q?OAbRU+XHhz6V7OADKXuKDRQPo+FrtxKg1DhbH0sLG5OQGufCDgSPUdNWPRaJ?=
 =?us-ascii?Q?9qNdJHCZLDv3pgd9LLc2O8nlGtvGf0l6XH0il55rzzmKRlgJKC6VD+Cafr2M?=
 =?us-ascii?Q?gPl+X5nCos3hlX3nzynoIi/WBdt2HGSrdLaBmySveijHT6vFmSioIMY1TPP5?=
 =?us-ascii?Q?1af+vFLMZnIRLb9Ij9p47PWR8IFFBurKqZFlSmUFsKyQEF7Wh+yGvplTK7vx?=
 =?us-ascii?Q?VkrgVa7SNtmuT1Rkpr4AcklWPLaXMZHu2md9E5jj8RzMFbyHAAjCYwyHJqRl?=
 =?us-ascii?Q?FO/yxD0yP5nPHGwvyB1g0T208ye8ml4xnfGHLay1fN7xuIbD3Ff8xeSxLzOg?=
 =?us-ascii?Q?ontPTB7JoFpqihbTE8m6gvA8/bGC4OS1Z9yH/KHoSGbPowC4eJMd8Q4N0Kvg?=
 =?us-ascii?Q?LxU2Chd5OqIj5jF/cZ6xSNmm63RGSosJkgHDOVmBPky0/zl21M/XoMJRW29n?=
 =?us-ascii?Q?yJotilPyAzTdk6WqMh9v4rKO0xh6dnglmY7Q3YuwCt8CmHI2byUvZIO3p4j4?=
 =?us-ascii?Q?Sn79bbTMvcL6BNB+ngKCJ57vkUxFydKV3xACn9X6ZGTtyRBo5Jcau343YVud?=
 =?us-ascii?Q?LHaJYHpxaq9owfwnZPEDTr+TxBowCK2rgIxd0SvpU8tbbLTQC9Tr9gNUV9QQ?=
 =?us-ascii?Q?BP7u3c0kuo4QLGO26jeku7UWR92eNkCV3BI8l304FpXX0vUjxfnNhcOR0PqZ?=
 =?us-ascii?Q?liKw/r+Jw1G3nPaVfslXJujOq2CxpUleUoQCfZWu81ZzIEno0XKbFWBYzrWL?=
 =?us-ascii?Q?Ts/LZZ26HtdaqLdmDLB+HaKUiPdQWOW/GLnXDwqAQyRLkIaDnkcn/L8oPKwV?=
 =?us-ascii?Q?jeBEVVV6rmZ2h4nWzO5U71fF5uJSJMrM6caegTkCkXhqFOQH4iPLK5bxF5OS?=
 =?us-ascii?Q?PlZt3eAuMhCn1EaQG7oAdFONiB+Iy682kpMFD3BYPTTdfa9Lr74gYvRjNEIF?=
 =?us-ascii?Q?/R0CNkuhnH3ZscjaqgTtbK0FzBUVIyo7ud/+WYx7ad4MRcOgFJUGuNN+e7ip?=
 =?us-ascii?Q?HL4cLFXkcq+ELmn7TBbzlbekGdnkBSIZUlx97/wV0z3HCAUNcdeAX9bRvCmd?=
 =?us-ascii?Q?O8Nj4TvM+0r+wllxYgK/KsrImEN7aGuGbUk/zTbmDFSdmPCYI3rUKmvKLHwy?=
 =?us-ascii?Q?yteaNCStqAvQY0tsvdhDSkMZjkVFKwVk0GMJf6EjM3Y+tyVDl35erQP4NQUX?=
 =?us-ascii?Q?t6VAn5vHcGO/DmyOmB70Z8W02ZgWgOjIbwCIy7o2MgTewUf00nRJ9+v7AdZN?=
 =?us-ascii?Q?GqaG0CJmq+MTrpFA07pmgjcW11C2V7ppbqfIFwh/StLqepdKUTQA9oS29WBA?=
 =?us-ascii?Q?mQGrAsYAt1xjq5xjY6Di4VeG5V4cLkK7YhFegCWThT6BmtMDgEZzJeKxHN5p?=
 =?us-ascii?Q?jSoVM58hpiEJgJtPsAJ4Ae27/RrfqEelDcilAgnBet8QNZX2NXIofBYf5KXk?=
 =?us-ascii?Q?4oLZDFohs3eH/mBSqnNpRdCSJ6cNVnLxNV0tViTySgXs6brGwFuGTVOgKEbz?=
 =?us-ascii?Q?fbFr/dAsy+194jirfgvvuY88qGGKdCJv0ZtHmAFA?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9a2f738-1a29-4ccb-5bca-08db37ab402f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 21:01:26.2206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t1ExX7+5iwP8hVwPkZKhQZLX5y/GGsBcpmcR97Vchnnrm/BlGvTBBCRqkgNcyfCy9+okgqTC45jAIBIYFlZaMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1895
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use napi_build_skb() instead of build_skb() to take advantage of the
NAPI percpu caches to obtain skbuff_head.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 492474b4d8aa..112c642dc89b 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1188,7 +1188,7 @@ static void mana_post_pkt_rxq(struct mana_rxq *rxq)
 static struct sk_buff *mana_build_skb(void *buf_va, uint pkt_len,
 				      struct xdp_buff *xdp)
 {
-	struct sk_buff *skb = build_skb(buf_va, PAGE_SIZE);
+	struct sk_buff *skb = napi_build_skb(buf_va, PAGE_SIZE);
 
 	if (!skb)
 		return NULL;
-- 
2.25.1

