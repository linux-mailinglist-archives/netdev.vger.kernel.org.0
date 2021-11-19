Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FC4456FC7
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 14:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbhKSNl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 08:41:26 -0500
Received: from mail-mw2nam08on2104.outbound.protection.outlook.com ([40.107.101.104]:61857
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235488AbhKSNlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 08:41:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RA59v/dkzhRJZvXoCzAFR3nBVNpRa5szmujGqCUZ0w6F0E2unjpmBfIEAb0C8deJhlqxEz1fIPVEPuI9jDGLxShinn7q2eZ6LYPfBJvo6ONUyuGHPGeHgYsbe6FxJQCI5on33K9LiqoGS03mW71qg5apEqQ7I4LNGt3YrN+B9PqVQNandWvLOQwkpDraheGjuamqBx2/PL5+2Cpu5aZN8Uxk1JXBEzBzSVootKNsRESg9U2yGRyuVpI8C/iqnOCoTrb3EtlwEvBXUVyZ5D3iEXgDsq1oq8fpp9MIftdFaxO+IvvrA59U97ZHsO92W13/ZtGpn/EH51gEDzOobfUjEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvhGfwJtnASaOWh8+xrd7IXxNT8CqoT2KQt+x8X3yQI=;
 b=QSuCMGmEuQx9pIXXQzB9iNhEBVjcf9KbVmtcGeaL2uPv52/0m+jkchPhzkOnN5UaFqB9kKS8XhNGLMAWaddh1iS29HgQNF99DdI2x43ee1aJeZETNL+xQgoiJxzoaphgPwVZ0sW0r7GjNUb9Fx8P+bJ7nKq+kMHe3nr7XxOB20KsrqOryfXCRz96u7hgm6sFp+ImB52VCx7bIIBo9+1cs6S1NO5cIQ8SOvhVV+OcXW2zc7kZu1cW3zS57iS7tOaNK+Url8NneJEzOXZO3YWCO1nbZUws6QVNsyiFw59+gVyhOJ+whP9sa/3FM3k7Uq3NN/ckqwqburARZqMV+LmSSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvhGfwJtnASaOWh8+xrd7IXxNT8CqoT2KQt+x8X3yQI=;
 b=B9XKxFuVfC4tslRf9AWB9Artmje7R0AmD/jWIJaU5GbmarkkVio6BiFbNsEKMFnT4oosnU/S9LkmRjukuLvCIbk2+Gc0Q7dTphTaeQppo4CdcP7RuDEbFoFfgrWWNt3JEofHMYlmiW2GPXql/VNJSxvVxvBERYYcGSJYKlTUZAk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5794.namprd13.prod.outlook.com (2603:10b6:510:11d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.13; Fri, 19 Nov
 2021 13:38:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7%7]) with mapi id 15.20.4713.016; Fri, 19 Nov 2021
 13:38:21 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Diana Wang <na.wang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net] nfp: checking parameter process for rx-usecs/tx-usecs is invalid
Date:   Fri, 19 Nov 2021 14:38:03 +0100
Message-Id: <20211119133803.28749-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0052.eurprd05.prod.outlook.com
 (2603:10a6:200:68::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9) by AM4PR0501CA0052.eurprd05.prod.outlook.com (2603:10a6:200:68::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 13:38:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61237ac6-8512-4c0d-c1cc-08d9ab61da8a
X-MS-TrafficTypeDiagnostic: PH0PR13MB5794:
X-Microsoft-Antispam-PRVS: <PH0PR13MB57944991779D4CD69E7E3C9CE89C9@PH0PR13MB5794.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rz5Ykhn21lSnIQRmDxtG0bPE7kj8W2XaFGWMHjQa7uITPY/SbVr9YKmUdkY4/me1+mEemBxG6YwrzCY0Kb10y282FuE8t7Sdv/XSKM9nKvL3XCczUFqI8V1/UFPbs5vkangeyI0zYPFdTxVFtteo+ZxJueqhQNuQb+5kppPKA0XPIyG9+a/ckdIucUe8gBE2wDhOF1qIykZ0PEO1l51rAHIQAHSmn7Oq5pXLU7BbRR4q0qi8o4HPEfNpqqMPSyLQKiQOT00oZ6RdXODBZXV/KRsh8tetC54A/yVw2/wbVfzkqzMfIpWZ//kcpBPcwpLgLLQOMj8epJtrCT1e97TFCE28q0YrQAFkI1wl6x5a7dTuTNT+7UKcxTGkUHi2EBKDkMcwWOz0cLxq3D8Ht9eME0slhH8ywfzUwyQEelS66qr7OekaElfq85DKyeVqW2H2EyO9KVRUWSNw6FihJ0SqntNrMsq2Vy9aES27vYkYcrqn5zT29+lqbxgwtNnGSorKBP9j4NUWiCk4gFNzNRSphT99QT5ZvbHS8z0uJcwsKGJQQSdZlA8ALqXOvBbckGcICYOyr4M44xmpDNip5iTFw7oqdwTEkdZMUFuMkHN3qTiYAkeIQKhvYr9E99sdrOy5KHP4b4AH0oigwOLGNj+xC2hm2Whv6VALf6zErFF/mVJSpgBJJACKNmkDuij69SIOlH1RwlSI6o2w3V+NzkTHvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(136003)(39830400003)(396003)(316002)(8936002)(2906002)(83380400001)(38100700002)(107886003)(66946007)(4326008)(66556008)(6506007)(66476007)(186003)(36756003)(6486002)(2616005)(110136005)(54906003)(5660300002)(44832011)(6666004)(8676002)(52116002)(508600001)(1076003)(6512007)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9EfXdUyjsfbLuBcudyJE8GwbT/bX11wOZFyiVC3iGulUbT1b0hk3ovCax8Ls?=
 =?us-ascii?Q?9Iz1rPJ6ePmtQKc9HODmoXwA/t4C/9Q03i7ZJ2H/QLyOjTLXEyqEvXlKSb40?=
 =?us-ascii?Q?cDoEAjepPxjHgoKNCCTq58D1OPZ21y5N+1x7z2O1p70a9ua774b2V/yXmZg9?=
 =?us-ascii?Q?7RDqqLINr4FY22lo0J6BCrTiGU5su067yDILEO8EhbRS/kMjYeeBd2u/8hVb?=
 =?us-ascii?Q?5RjESO9KMaFaqbjTI989NSPt1XisKez/ADOSJ2YMrAY5FEt08iALdgaLET7o?=
 =?us-ascii?Q?muXyq3nlzqkaTFMZ/meJj90WdpbF6MN1CFKKJZSN10wHEXoxZUDdrfA1CBe/?=
 =?us-ascii?Q?3Q+ZK9uvQJN8XZa/76G21/UhS49f0JTCkb1yX0uCKxAE+vCFaPVifz7R0yV+?=
 =?us-ascii?Q?UCLtlkMYlPZMR5pIwOtqKB1K/qNqWSHSJTYqB4iKgugwt70m1v26iPffbMBM?=
 =?us-ascii?Q?PmVMa0wJ9pmauHigVWBcvWSWtGjI7NHy72zi0dbh4XJ8yDXYs+mlx7K1ckiL?=
 =?us-ascii?Q?Rs+SYjfhVK8E6r/7Kyg17AGSPS5bgiJy/YKJZrK9xjXEmHCqEJmN3IeQPSBt?=
 =?us-ascii?Q?UIDq1RxsJWmwbg7ovRL7pbhawsLQp5+hTzsYzmBLzuRX9eLqAHAVXPtS9lUo?=
 =?us-ascii?Q?xDgZK0GrgZMDGm3K8w7AiWpg1Lx0SBZVPQ0W3KbKDOud+WbPl147suw5Ijbv?=
 =?us-ascii?Q?JWRa/2rYeKfzMmNv7HWeUMTMTHhPdmONOTuIgt7sf0gRUF+GQr2Qhyjn9ge2?=
 =?us-ascii?Q?a6+aUGONZ9I2K+K9VvNPBedaZtJKrJHfcYFi28ulDb+ZCVVzCLu/41rqdGvY?=
 =?us-ascii?Q?xRlLqWXTJFpflbvDYSIF7Q+Es+FZP7/7PIeDJxQeZwpn3TaxfFHkalE33sOV?=
 =?us-ascii?Q?lyGKHQOIHpZ8scpmsGCJw+Es8S600kpCEswd34Q+ZXhyQBRCj0CMRAoVGK9K?=
 =?us-ascii?Q?dBn7mixJexiRcPPEtwbhBz79wOkdSwm5c3QRk8CA4ER2mOXCbt+GWZUimjBc?=
 =?us-ascii?Q?lfPBctdMq4W+x5L9Qd74Tk83xG4hVOQ+/poD4lyvrtTNRwkXIpvejLwRVI/u?=
 =?us-ascii?Q?t7Nl/FP6VzRLAJqpYxDW63dYfqo11KLzzzyil4SxpPbQ4RmzLn3thunXfVVK?=
 =?us-ascii?Q?GEH8L0hW0ljzbkMGlt0UDVfyuVwSlMHzuSabp6eq8DSXgQvcsWkBgPKv0H0W?=
 =?us-ascii?Q?17/SVrCTXuIiyfBhjUILvxO9/QqZSjesdnBs8FmIiSBB2fDPxQuqlOk3BRpJ?=
 =?us-ascii?Q?L8Em0rF53WC3b6zDVjeCpo8ntdO4hxyEvKpfvcfW5slN8M/q/jAEffq3ZqAt?=
 =?us-ascii?Q?YIaEUoBMqCIYrPOu9xW0VF86Ai4xil4xhdDTbJZbyn9EGG0eDc6Tnut+DP2H?=
 =?us-ascii?Q?jAMY9JAQKZLX3V9RUKJCnkxlQ7R/LDyTGdZOmLtwivpiTfrnCyS0Pv377uFD?=
 =?us-ascii?Q?2hQBLJrnAc30luSV4yDYLWvpGzshhTi5JNBV27woqzxEZdVJ6jHvMumD4d3l?=
 =?us-ascii?Q?Ra6xPer/UeQPdcdNFac9D5bzHu7/BAHuwaQwxqJPfq3ItxRDCR1P0e1BKT4X?=
 =?us-ascii?Q?Aim20p33b9duYLFRoKFkg33GY78CV33wL819Lw31cFfc4gGU6Y2pbn1rnptU?=
 =?us-ascii?Q?m6xDPXDT3bBLyA1o4OQp45NcU9IC8j8h+URB/wJoscDsEmoc7WtzWEQI2etq?=
 =?us-ascii?Q?+JeMsg4uCvOBt08HsuEHpRXycWJ/BqUQGB9t+kXHQdLNFzxzjNQZSNevzXxJ?=
 =?us-ascii?Q?iwjk3s7Aueja76Sv2lcVKH9niEeesYA=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61237ac6-8512-4c0d-c1cc-08d9ab61da8a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 13:38:21.7494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f/kKhCwqSsj8at3QbAL2F2QMD+FSgsgflxw1qVDKlLSxfxedueOQLcojITiIwzI7jSqDkNEi3lPk3ZcsXXjhmIgsfnEsI1Q85YUmkLXqDvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5794
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Diana Wang <na.wang@corigine.com>

Use nn->tlv_caps.me_freq_mhz instead of nn->me_freq_mhz to check whether
rx-usecs/tx-usecs is valid.

This is because nn->tlv_caps.me_freq_mhz represents the clock_freq (MHz) of
the flow processing cores (FPC) on the NIC. While nn->me_freq_mhz is not
be set.

Fixes: ce991ab6662a ("nfp: read ME frequency from vNIC ctrl memory")
Signed-off-by: Diana Wang <na.wang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h         | 3 ---
 drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index df203738511b..0b1865e9f0b5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -565,7 +565,6 @@ struct nfp_net_dp {
  * @exn_name:           Name for Exception interrupt
  * @shared_handler:     Handler for shared interrupts
  * @shared_name:        Name for shared interrupt
- * @me_freq_mhz:        ME clock_freq (MHz)
  * @reconfig_lock:	Protects @reconfig_posted, @reconfig_timer_active,
  *			@reconfig_sync_present and HW reconfiguration request
  *			regs/machinery from async requests (sync must take
@@ -650,8 +649,6 @@ struct nfp_net {
 	irq_handler_t shared_handler;
 	char shared_name[IFNAMSIZ + 8];
 
-	u32 me_freq_mhz;
-
 	bool link_up;
 	spinlock_t link_status_lock;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 1de076f55740..cf7882933993 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -1344,7 +1344,7 @@ static int nfp_net_set_coalesce(struct net_device *netdev,
 	 * ME timestamp ticks.  There are 16 ME clock cycles for each timestamp
 	 * count.
 	 */
-	factor = nn->me_freq_mhz / 16;
+	factor = nn->tlv_caps.me_freq_mhz / 16;
 
 	/* Each pair of (usecs, max_frames) fields specifies that interrupts
 	 * should be coalesced until
-- 
2.20.1

