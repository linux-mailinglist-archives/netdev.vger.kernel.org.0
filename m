Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03124D438C
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 10:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240806AbiCJJ3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 04:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbiCJJ3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 04:29:43 -0500
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2121.outbound.protection.outlook.com [40.107.215.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD24403DA;
        Thu, 10 Mar 2022 01:28:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQZMdWbkpExlANeoagV6m71LXkq6ei6y4otvHnSA4L3KvMCTUx9OY0VuseXVL6pLupZMuwgYOQFckKKLTuBiWZciTGkvV/me0kyIpyJiZgxOWa4q+5svtUPViGAFOvlo3qMFdd6Zs1Ha0AHLRIPdOWLky8GaEZimvda+EGjL2b+kUjd+91OTW3leIN/Ote2qiS2IufvRv9YaoXWvMtmUPuKbm5g2nQ0QF/AXFGRTZlBxxzwAQ012M3mkayXowQzQj1psd/esg7wvnk/Vo40RtXpnuhfCYmlkG+rn+NcAYzeJ8LhetkGXV+JOirzXZp/IMxzrk+fvaylZDSQwkC1RJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFCXHW3BplTIMC5Oe/yQG4P5aasqOYCnehIMZJQy//8=;
 b=gUSJzi0rtgeOYROOecSrFfubsbSR6zD8DHu+yJ/cYUXyJGGB64nJYvMtnsn+V4t7/6M0/y+PfOoiLOnpi5tiiIxq0RQ1T/5JAPakQzZzfyqHX9RZix5wRQt6dVAAqRDUo/kKGvlgJJ8pIHbzGHmRhO5G79ituXnjzHHaSNuOeBNd9G7uj7kbJT/lcFrsYR5bLydF1EAPYlaScONQwaov6ty+cbmKgzIdeS41TxuGMiUaWgGlKfYFYlMe3fJT8amKFnZ9oMXONEBJARDHvoV5JdEQqNBZB3J/jZVdHNwZtj13xygCdlNCVyky9wRuFrPcrsSTczJOy9mviW6R7DDYcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFCXHW3BplTIMC5Oe/yQG4P5aasqOYCnehIMZJQy//8=;
 b=DJac0dWk2Gnb99up9SWBFtkUesZ7dFfjl/Pv5v880ak8rBJjIgY1DgFGb9n8bu4DBFQ0MraHqzu/SyOBTeRdiaF576VytvpcxKUGrzj0YOVqBBNEZS2lDhHicSB95/2ChhLw8xzOss6qebuqxsJ+A1pkKFTMiwliz0nIdYb5zp8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by SG2PR06MB4962.apcprd06.prod.outlook.com (2603:1096:4:17d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Thu, 10 Mar
 2022 09:28:40 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::30ce:609e:c8e8:8a06]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::30ce:609e:c8e8:8a06%4]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 09:28:40 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH] bpf: test_run: use kvfree() for memory allocated with kvmalloc()
Date:   Thu, 10 Mar 2022 01:28:27 -0800
Message-Id: <20220310092828.13405-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0302CA0016.apcprd03.prod.outlook.com
 (2603:1096:202::26) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 896f3179-80cb-4690-e972-08da02785cdd
X-MS-TrafficTypeDiagnostic: SG2PR06MB4962:EE_
X-Microsoft-Antispam-PRVS: <SG2PR06MB49622085F66AA0198C094EEBA20B9@SG2PR06MB4962.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8BF68XqAK29u3qCXcvqpLWRqRI1Ace8v+9jntP4GXGWcrLBc77uxcQsOCg2yyN3gHAH5PW5QaDfTf+/6XiNuhpgiFBsTen1aR6xeU7t0F9bept4uJCJwX9ZpFX/EGSFUn3jQkdnGgnGbcRqHORLsqZKaWdXDw3Bjm++silidVzdQS5jQPPXamzTQFjUc0Vk5QhFbmM9x9BRm7zvasA99sjCsftvRUBmNNdDwbowAUp19c8S3yVDMoq22McIketL6cFpLPZtgmUZ/dSAvqXrFuwKYMd82q6anXzuKIZab2kcbOMps8f3+X4jcwITxZHuHV0cIQaGfWkCol7Q5Ojin8TW94G0wcldkjdYA6jajOl7EvG6OX6mO6aOh5ZjFggB42q9Q9wJ/ZKICIdBohIPfb7M8Xc9mu1d2T3IZf+Ro8oKqtrZUgYFK/zPeaiciXCZUzeZvu5vkYAHzuSjKBeV06w5iJuPoNMKMeo//QbraJaGji8WObfCPeYFOG0zxrz00/zuIBxKKe57D5uwAx6syw4PlJAooLsHGjEIjuxRwjB9BYMgNElaS5DwmyQu80O+4XlkP9/jiINfr3Dumi3KeSMh9/kpm68c4BwE2ARQb1JtU0e2qeSUAq/t9bS0LhODo8CeKXwbN9oS/OBTFsVtGnPG8HrbYoSzC8U/iJBJrrMscPGxkNdJNTxz2L6bsHhJDY3iiQZYHctYQszbv8miIOGXIvE9+kSj/aPFDdGUXlD8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(5660300002)(6666004)(110136005)(36756003)(8676002)(1076003)(4744005)(83380400001)(38350700002)(6486002)(921005)(38100700002)(26005)(66946007)(52116002)(7416002)(8936002)(316002)(508600001)(86362001)(6506007)(66476007)(66556008)(4326008)(2906002)(186003)(6512007)(107886003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9ZgD7GjiPyABCtgPpB/R8Z6eIO3K/7dCMh0KxgrIeRGjVZSYhsaaB55HYowG?=
 =?us-ascii?Q?dl78OKmz0Cztl9EHSTFYqckAXoC4Ybqs8qECUEUnNvDPBw9KvWoWP4ktTHBY?=
 =?us-ascii?Q?/Dy8/NxewuTorOe2tJh90pXlmiLSmkN49OCubaaLcbw9eqO0AP14+YzAqQc/?=
 =?us-ascii?Q?81MhZi2TSCrXQEJ+favDhDaSrrjmOFDw+muxzZHfst2/Z05IMtu7RyKuhwA5?=
 =?us-ascii?Q?VGYibmipzz+3EerN4TfZ/9yfsTh2zmkBhAKPmblGo5HYLJSkXt73Q/V/+LhZ?=
 =?us-ascii?Q?cmvZZHaUqVnGRzI2A2IZJLEP2eoHfL+OI8tdmBvDLqe3EIkcKTXOs/ktccPO?=
 =?us-ascii?Q?ze+EAfktnOMDqKw6Q5QDpkM4rQzj8mXLeux83GbZzRx9FmpE2iEI7udZC1gC?=
 =?us-ascii?Q?E2ZvCLN51EG40AOav+XVXZetYHslnYWxWqDwNi+CXg/vFXcJmHA2vuqvTe6r?=
 =?us-ascii?Q?W1aPIly6/gT6BkhwwtPw9Mj8R17J2c7BT9OucGodV0uODzZ5LfmDtxsvCA0n?=
 =?us-ascii?Q?dfdcgss8SP1TXuKfikykMfM6Xj0G+6WO0qxsuJlDhfUnAkqqt24bb/FsIKvq?=
 =?us-ascii?Q?T7sgo31Wc9Vyon+4QPBzCjSny4Ckru6du0dSlIQzs3lD2S0SRB/qusTw7Nhi?=
 =?us-ascii?Q?pxi1pnEr3hqwpb4VmNJUagZkkWNMKKCLCZJg1r4/qXaZuHEgarHWIpPgenll?=
 =?us-ascii?Q?UQXiSQ/4/4DlwpiMsRMm0wUErC+6BUmBFoXUKRaA87vacGaI8n8qdXdpVjzP?=
 =?us-ascii?Q?4KfJpWkfCgeYhrCxctAbTrzdkXEmCauMke5bClkyRGS6zPhQOYHLHzvwMieT?=
 =?us-ascii?Q?ueXlxoKHiK0vCfjEb+Mx3So34l1BhYzfa8QOol8i5ZVG4EYSWqULKC8gYWX/?=
 =?us-ascii?Q?Ez/WPCTSvONMDOdknMSK8toXUIuCqivn9ApXHFQeDFxsswhPKQlALIDegc8f?=
 =?us-ascii?Q?uHByJ+w+fjLTT0q1bHWaXss3ZB5bK0mWNVh0fFk6JPRRVixVKu8qx524lG8R?=
 =?us-ascii?Q?5fxrsOHhjIqAd9rDeW47PzLLNdimF9zpX0Pn1orvzIyxtDz3zJ2TgdxjNmVg?=
 =?us-ascii?Q?eXhreGzegFu5BfZQTlmE7BdBrc6JxVo9mYY79buPKQ5IrmjUsxkzQ5f9atRr?=
 =?us-ascii?Q?lhxFjtsE5aUIAIdg9IxMhEVU+SAXcNbV//pA+UUkaD2LKtaltTZ/D9EUqXb4?=
 =?us-ascii?Q?Wo7qcHxoNi6dZC1vObiho7b1MnFD2KBDxRzSOvnjGbUed2xDQrfeR7uGbHBx?=
 =?us-ascii?Q?9E3EDmNWAGIoO/gr2RINw6jaImdo/STWd1r+bvGFLPowv10WoSCx8DE4rqJm?=
 =?us-ascii?Q?SLFddG3v9PcxnwqUDwstdnOOpB6JhXibL8LJ3BfyzdRzR1MH1rgM81aW5kuX?=
 =?us-ascii?Q?phN0G6icyD499vrm0aZtzXMENe/spado9NGb+y/sj3NmBd3NLSuXnf21caf8?=
 =?us-ascii?Q?hrPQZOeas4k/SEIztHn8RFCJQ41qu9JC?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 896f3179-80cb-4690-e972-08da02785cdd
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 09:28:40.5130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yNlnCUdgn7ZD8435WRAkX/tvdg6APYjFzSr4vqIzMkIv/aZ1mFgcRM7ro0QTso3jF49A3CYEEIFF3NVmXLFFTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB4962
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is allocated with kvmalloc(), the corresponding release function
should not be kfree(), use vfree() instead.

Generated by: scripts/coccinelle/api/kfree_mismatch.cocci

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 net/bpf/test_run.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 25169908be4a..b7e1e5f61c50 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -196,9 +196,9 @@ static int xdp_test_run_setup(struct xdp_test_data *xdp, struct xdp_buff *orig_c
 err_mmodel:
 	page_pool_destroy(pp);
 err_pp:
-	kfree(xdp->skbs);
+	kvfree(xdp->skbs);
 err_skbs:
-	kfree(xdp->frames);
+	kvfree(xdp->frames);
 	return err;
 }
 
-- 
2.17.1

