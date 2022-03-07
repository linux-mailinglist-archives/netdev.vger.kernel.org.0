Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CD74CF442
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 10:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234040AbiCGJJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 04:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbiCGJJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 04:09:15 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2112.outbound.protection.outlook.com [40.107.255.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6437BDF5D;
        Mon,  7 Mar 2022 01:08:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BvUL/F7NJ8+3HGv8rUHlMtFNaC4r/hWUDitC8uXba/kEu08n8DtnRT34wGDaR3e5NnxcZ7eTGl3yBFyHeB5MUWE1ZYnXMFFnPaZUNcGjbIXD+fSfyuZrGZhtbq3XBHUWoJrEU3xBE4jtVtWF2x5aZkOKPk+Sp5NpUfxnt1rXqZjSJOV5p6PLJF0KRL8fuLFCnuWV5agc/heEWy4YXv9pozpoo0ermYS01iUn3SpKcD4i2/k4evBhGYiuyrv2ybf0ILwETtXvQJKcVAkkiSuV/eGU5t/52BD0+bp8Jir7muXz1FhdAWzqM3aj6YapNHEExsP8rGs9MgOtYE9+FK6+YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0kzCKBKjzDXrr3m1yppAWw64Ae+3AUT5JtnlTVAcdao=;
 b=Gay1O9VikeEw6ZCiHiVj2v2dMd+MKSWmTImswke9W4YMeh7kY6Ytd+YvmvdN2fjBt5day3rrkMd1ugKtu9pPQN9Tq03+SGz9br8yyf9R2WCXCeBF+U5N30oYcQZXEguWa4ONLw9ahz4ZpUXxpXBbsvnk0OFuPVP/dqmtWhPEezgD5YPKr3q+Pf19L1xeHVQZsgUxv82QGVh5NU0OVHWvEFfIuhLSqRu54wHmXxGSxHqlOkYcc0y44X27PkTyGJ6Wm/fRfm8aG4o/48FU9PYj7WYnxmS3uiFiFjJlq7Hn55yi61ZSB0dPcqXto+4yrcQEwgaimoNHT1O10l5cBVeMOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0kzCKBKjzDXrr3m1yppAWw64Ae+3AUT5JtnlTVAcdao=;
 b=FcWM4BnVDtmAeaIfxJ9rr38ZYU+sydYQzB9h9166bWHlGH/Gi2SgSuUL/q2GOh0N1wRvqEz0Q6dQBJVCyaTycNicAWxC6I4mDgYgdsOUlGU80Dg8KlsN4drsdsHXUU3ULRzQHTjJpxdCQ2gQu55oO5dib3l2IHpex4cBI4UXkIU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by TY2PR06MB2559.apcprd06.prod.outlook.com (2603:1096:404:52::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.21; Mon, 7 Mar
 2022 09:08:18 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::d924:a610:681d:6d59%5]) with mapi id 15.20.5038.026; Mon, 7 Mar 2022
 09:08:18 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Guo Zhengkui <guozhengkui@vivo.com>,
        Paolo Abeni <pabeni@redhat.com>,
        oss-drivers@corigine.com (open list:NETRONOME ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] nfp: xsk: avoid newline at the end of message in NL_SET_ERR_MSG_MOD
Date:   Mon,  7 Mar 2022 17:07:59 +0800
Message-Id: <20220307090804.4821-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0195.apcprd02.prod.outlook.com
 (2603:1096:201:21::31) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48eb2a71-7054-4267-a306-08da001a04de
X-MS-TrafficTypeDiagnostic: TY2PR06MB2559:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB2559B3507F66711EDC2F0131C7089@TY2PR06MB2559.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S6glt8yMq7XSkZaX/6d6F8rdtj64oQZfAJJ91MUhf8WFsLALFxJZ+p5DT8e6Zobfo6/Awcds6ANxEppdW258nNU6kxvnEtcOEWxeaiEoy79y1+ldSW8S2LoJdUiYjn+2X10lXTXgJOrFdcehv2zvB6/jcffxVLvIR9IQ0Rv1bCruCP2n7GqSpBJBkKTE6hKLFcPS27O+3u1BPKhM2dZqHi9aVpsAySNzNwySv16731G1eabvhoq/gr+Z/f4NOkaqpwrmpu58a1xj/VDTzVtueqLTqffQpg36r7Xj+ehVKXkfLPCqULsbZJMg/WJ1FJYtK7gtStql76p9K4kCApymKFF+Y9GaM7olKbu+/bjl/XuKJs701imwEaRXYokBByKNHFao4KHNF401gihKnQ4tvk58w/AxBXcTb2zmehr9A59cHIVdc70/yZA4SbsyDnLyyaSE20m8KQU49UvGWnAJp6LfQVP4MjRfqWCqfgIXjOqgkidVbyDehdUG9M3Skhh/Pp0KloiaDb1+UX1cWCRWbaidbTB6G45U6cSzRJ9zzJiqbq8aWSNyuWgw+ldB6l6knT5qqELCywv585HBRP2TTbsqLnzGVcYgWDMympHJ94CpCAmtAn3a1FBVmGhEkfcifk7XF1tFLIp9XGe61HzLmRrcxT1qlIny9skv8tdaVX6i9qzKK3MNcbL6irjtOZtKiC6fjxLPRx13xVYamNFvDvhQHEm63xjVSZwQzYbzkgM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(6486002)(66946007)(66476007)(8676002)(110136005)(316002)(7416002)(508600001)(83380400001)(4744005)(6512007)(36756003)(5660300002)(2906002)(1076003)(26005)(186003)(2616005)(15650500001)(6666004)(52116002)(8936002)(6506007)(38350700002)(921005)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JHO3W1LLlRTPtJzS2HpBFok37iaN7uTieWY28DQ5LPBdtKFInV6hjfApJ2Ke?=
 =?us-ascii?Q?G5bgnjc8TzQkNAqk9ZnzXAiMH5++wj2nEgTyjU9pKEY7PkcRn8diWnhGyepF?=
 =?us-ascii?Q?AgRApt0tWNrf5x7kHGDWHwrZo4YYncvzpdeo/WA5pyPnXCkf1DUUNiKD0ZUm?=
 =?us-ascii?Q?lkwIB5Nwp2dgSx3SF5Sl/xHyjYKjAglkvw0DTWyhpMPAeGq7TSlwgGC5Wwfx?=
 =?us-ascii?Q?HELnz/YKH5/9v0XJGCFMHXdfSh+ZWoyvU53t+JlY+v7q31CJA+EI2o6Zr9Ng?=
 =?us-ascii?Q?DSBJxBW3037SxhP6N485i1v9jkjX6HHQ/nGAMnxYs7e7jX3XsG4kiJEGw5CJ?=
 =?us-ascii?Q?yvvFUg3Q9+F/DSkkYP9JUHQZI/5kAagLhqHDjAFI/Hr5a99J7jOdAlhrUuEY?=
 =?us-ascii?Q?DY802sYw5GSbij5I2Gw+wTyu9mITkx3Ffvxsxdq266JUVL4wHH/gh2RZDY75?=
 =?us-ascii?Q?d9f5YA02i0Q1slCCu/95XSK8soK0Pg+1mj95e25tFvp/KdWsR+dWvlA20ya4?=
 =?us-ascii?Q?G64/FSSMlaY8d7QjLrjOOpLoB1kCEPHpd1crP/ONAhwM/KguYQsJQSUwRX1o?=
 =?us-ascii?Q?vi4Ac5SAwk+e7CWJCi1FIrxy/qT1oCW/TiARJvoLFnatubEcglT9cHgShrsM?=
 =?us-ascii?Q?t/vAzUiMwJOhhys/QeZCzMmdijK6kVQKvqM4HPcpTI/lxCiSnrIJjvqcaWaq?=
 =?us-ascii?Q?fBzSlD9YMtJoVi8Syc3zJq3oD5vPJcoJmPpd/AkOjT0v24xt+6TsHinn2Fss?=
 =?us-ascii?Q?sqPRH0cgW2Vg5SP5I3Sz7qdmBxrFoEhkbouwMe54DC3LBzMuWhN7c7xZCyJ9?=
 =?us-ascii?Q?IPzzbKyHzMSw7Bl0j7CllygEW+pMwh6KuctiKgc9F5HR4D54Butg8skZR57u?=
 =?us-ascii?Q?ECDR61tM8bEftVriqsqjMcX1Vuo2Y62E/sOlzdcIu2Ua11jyFyMkZbqwRVzE?=
 =?us-ascii?Q?31MWM6zUzghYk/vbuW0ctHgXWKl5A20JGwhYw4raNIz2eD1aDZhPoNULJ5Aq?=
 =?us-ascii?Q?JxMUC8SPp6nZ9eYgnJVuf2hCy8RPZW2tQgJMEQYpUyRONPaOp6nyXWBppD2g?=
 =?us-ascii?Q?h3yvqP2CahMEtLmXvc9d558KaNcUNzU4a6f6TuL2z/vYpzbp8UvjBBZDqcDn?=
 =?us-ascii?Q?5Bo5vPUYotoiaDcsF+TDAGueDTzTixIrcQmwyMtQztC4knGQqlV+Y05agIYn?=
 =?us-ascii?Q?lkJeiNKgF/s0tD4Dpina9fBrG9Rcee6wzYhegkLNcaly6as6k76VV5lRh3lF?=
 =?us-ascii?Q?A7C1vHst6q5oJ4wiz5Hd7LekUPJOfAd7v2i1ir7fNFwIKEh+hkAvQEqYkwDx?=
 =?us-ascii?Q?A13Qr8pH/DjZ9ypOJ//zhzR5zfrAzCmKI9CmgVtsLVtEIspntaYqAkXxGM5e?=
 =?us-ascii?Q?DlZniEDoV4A4bCBTl8Rdtrl9QuOLZ9hQF6tTMfuZRp6mm088zqhR+8Vc5bH7?=
 =?us-ascii?Q?Z1YqMb/6nxfFTFh8SmMZNDOEyKPz4zvOuWyC9p8zxf1txubkIb5wH6SO7G48?=
 =?us-ascii?Q?ohq3JB40zR/wP8ANshZXQDfhhU24JjAjlW1PruJCvbbQojtBRL1rLAHpHMxz?=
 =?us-ascii?Q?BtxQoaHrOd5HycJSglmZV+RQtc7khEPx5lte98D87f9Bh5WhHqOjIlKxOTMo?=
 =?us-ascii?Q?COGZznXqMOC9/eV6BtXjYUk=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48eb2a71-7054-4267-a306-08da001a04de
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 09:08:18.0945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0D0rqjyw2ESjRgQ5m9oLtZJWLWbI4BB/i/76Ai44brJ0Kjt+WR9sDzQzC7EDbK35wvmUw6/7PReezv2cMs5/Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB2559
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
drivers/net/ethernet/netronome/nfp/nfp_net_common.c:3434:8-48: WARNING
avoid newline at end of message in NL_SET_ERR_MSG_MOD

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 00a09b9e0aee..d5ff80a62882 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3431,7 +3431,7 @@ nfp_net_check_config(struct nfp_net *nn, struct nfp_net_dp *dp,
 
 		if (xsk_pool_get_rx_frame_size(dp->xsk_pools[r]) < xsk_min_fl_bufsz) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "XSK buffer pool chunk size too small\n");
+					   "XSK buffer pool chunk size too small");
 			return -EINVAL;
 		}
 	}
-- 
2.20.1

