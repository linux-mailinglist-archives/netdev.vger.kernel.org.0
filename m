Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D21500490
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 05:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239691AbiDNDOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 23:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239689AbiDNDN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 23:13:59 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2104.outbound.protection.outlook.com [40.107.255.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C00C393C4;
        Wed, 13 Apr 2022 20:11:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJufNXZ5HQ6aCQY+wGAs73e2cQrZ5vuDYjFSxPKz4F3dr2zFE1cM7/+GhzOyXDCNR9NjW+uyZbTI7wBDQD6k6M4aHOJTXg0Ybq/5jMOjuicy5IyA+NXC1p/NVS6ckkX5ZtcUjUvUzRZcgTktzJtWP6aZZga77vN41h3m3824pADCpoJvPEVlclPRMz1qhPLuLZ7d97QnrNl4HHBx7/WHIONeDploDX8xdqIjv3wHitR4b1RYWCxKRRSFHBzyFsGCDIUBsH+epVU5tYSv/NkE+XL9HuAmQVV1T4qFNAAb1LNAjHu69YyugORdc3bXvXDg1+U8pkfQScscxZXwa/4E/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CoJWluMig/CITG8Tn4Ta4pjIgpfqD/7N3znFvTkdNAM=;
 b=X6EVG/q4cygkOHWpZ82fzNcLPLO+0bgzSayc0iS1HHWG6ayZrcfcqnwE6eSL79DkpMEHKl3QUp+3CZVpuznvcYfzZI6gnGmcDe3T0hJMZjmqHtYIReguS/FOHe7oY3za7biDym4fbvqDE+Np7Qa2fq6HYePqw7gpnRA4AyOCMwre7Uu9Uayw63A1WUBVrbQ+i5BuSwJK/l1e5VVgGYEajyTSUHZXy8VJqCODQzONMUvjY8W9+QS5fyI2sPAATEKE4DFsoclfRjp+alYFurdH7WTn1XfrZNZllDUkmMt67vL/bDL6n+V+/QgtE1ztVy9Ze6PAtBfG0D4K9qjw1gwIaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CoJWluMig/CITG8Tn4Ta4pjIgpfqD/7N3znFvTkdNAM=;
 b=CqWxy6DBt4zDfr3QdPicvTiBvvxKuG6GESWOqogm6aGvB8NlJ6wbP2C08XareNcy8pA0ZEY4KJXPz/47Tg1jksaMLhG1ZBxOL5UC1VGRSVlWxLOaUoitSWDzauR5ZKiqkaU0L2dY2addldjD0wtuM3O2aQ21xk6mhBPuCHnFcZE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by KL1PR0601MB4452.apcprd06.prod.outlook.com (2603:1096:820:7d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.30; Thu, 14 Apr
 2022 03:11:32 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::d4bd:64f4:e1c0:25cb]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::d4bd:64f4:e1c0:25cb%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 03:11:32 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Yihao Han <hanyihao@vivo.com>
Subject: [PATCH] net: qlogic: qlcnic: simplify if-if to if-else
Date:   Wed, 13 Apr 2022 20:11:09 -0700
Message-Id: <20220414031111.76862-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0013.apcprd04.prod.outlook.com
 (2603:1096:203:d0::23) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46bd10b2-3150-429f-b65e-08da1dc479f3
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4452:EE_
X-Microsoft-Antispam-PRVS: <KL1PR0601MB4452D364FEA485122ED2C098A2EF9@KL1PR0601MB4452.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8zwx/Xrj8Zt4KvfwZVKLm2UrgChCSG2hYh7CspiAX1lS1EqgOr3rdPR8P7QRGYlBY3ppiD3fRCli+PdbktgtyOKHoqlv0UnJocxrQzWvlloyAaecbxp9DT1Mabn5EwUQlh/vrul9RpT0KMhsceUt9sfckRAtgNvygYgVKau0tI8CLeHUbVe/U+LtscvhmdcBB+Xet89f/Ee/eGfO1YbrBJHX6LQR5MmTH2o98ArQoAKGnNrooVf7QzBMzg7/CC2ZIfyKOXbtWTvGmyxTB4YW4ALhO7J9lJP2U2nvVJXOoR4zNlekUBMr0yXxLXAJYrMAHP+9zBaSwgfHcZ5tUH0pL3R/4UUziTlviyUaCWL4uJY7LRS5npD+dnGIQXrE2FhEVfy5Rc8pTHm6q8dpN57TyYsu4G568XjhgftaxdAwE7BVXWyMPdutMWI0deuf1h5neNckHJtlKlfhNq767noPVakaR/8b16G5Ff326g7nEf/VupQ4HN5ZzX0f3OKpF3Hvnx3viqhYhHwNhpWXK/oES6ZlP6F4sH0pYtR0W8RVkSYwqVVG7bu2cl7UCnlCACqHS80BRV7PXDnNEmCh9YjWhpKtJUOkkzPVhSJ2I3VJ41IdDqNriU2hPyAPxGE2icMVhtu7Bsd21sK/3ypgDNpnz8SzijeonP4ngq2rG/Kos7nFklQ1zIS4SU9kIARIjni0ZbHCUeq+W4uojAHfn89qOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(83380400001)(1076003)(508600001)(107886003)(110136005)(36756003)(6486002)(26005)(38350700002)(316002)(6666004)(966005)(186003)(86362001)(8936002)(2906002)(66556008)(8676002)(52116002)(66476007)(4326008)(6506007)(6512007)(2616005)(66946007)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yOQFyxcYPygy3reV0Tas4dhYclDDV2Nl9GhqDDbpVppTdYwhp9J7DyyzHq20?=
 =?us-ascii?Q?Q+syzTdsxuyMZFBTuFxo2GBtDGTvTQ1T4EHbzUg1+JfWyjGd1gjYwD2Zqp3G?=
 =?us-ascii?Q?EAcPTWrihC+pm3D7yQSQxp2oTNUClm2nm3Ku+nNR7fsIhL1AxCX9hCIze8Qe?=
 =?us-ascii?Q?fgr8mgMrOeDqUQGOyKRskjQ4+JhslhVboSJP1AwSurOkfeM8XSgvFS2He77b?=
 =?us-ascii?Q?c+GCQUCoCkzqxFjNvGbajdu2IcuvV2WveuMMTCVqKWvLLKWHry6ZBv2heKQn?=
 =?us-ascii?Q?9BxkyYMC8OaVW0uI3vqGVIz4muuzroicwO0p4fyPEfQtmbPhBBusC0MVPB4r?=
 =?us-ascii?Q?7WGA1PIC+l7DEJqkplv03/joDxRqdsl4sXTuFIberi1CRrqmpMWuaWePsMnK?=
 =?us-ascii?Q?Xei0pZhiQ6Zuay9E8x8xmtsILDyDBo8ZPNpY/OaZ0sH/EfeGbxFDG09oqDqp?=
 =?us-ascii?Q?upmxh4PyfcirqUJtrE5qf2jVAlTHmSgUU642RHc16QhWD65q5dbJCba0KtNG?=
 =?us-ascii?Q?ebsO47vC1up/JYJxMvn/wojKjILat9AiI2m9YnnlIG8jDslc2Cqsb3aHzprR?=
 =?us-ascii?Q?G05ntdQrtNHSVUx1B4Zbj341a5sk2PSAqBTIFO4WiPYivgRQ9cJuotYUd5l9?=
 =?us-ascii?Q?tMdQuzoBpb43YGtCJRq34acxGOcOWAgmbP0lMIJE5gu2BCYaxYc0g/gPfk/s?=
 =?us-ascii?Q?L07WTvEDVAbcdFj6E/k6vB8zel30l3TyABxr24qZJXlJaWRYlEBK4Inr+iur?=
 =?us-ascii?Q?8S1VjUtXi56MVeCt2cmOTnz1ltiDy1hnlM3h2K6h4+K+8bnnl6/8RacDBYQb?=
 =?us-ascii?Q?Xmsf8T/8YjHm9jrRjM0JhKdK5rsAAYV3TtnBM4PkIgnu/0aqFOoC3bcn3ucf?=
 =?us-ascii?Q?pKxHrrOT7894HY3/W9aqcNO4Uslo/YF7tiznsHP78egJzWIvuH76yeHtWgh+?=
 =?us-ascii?Q?RbNXR9IS3fxH4YSONEnlITLlgXIxsEAnKUZn0SmxLTPwDLFYoxfQPGjL8zT6?=
 =?us-ascii?Q?8ssAxuYUB767TP48ILLNazBPOREwP3xkyxjRLxgOCTFcddP4N8G0oUosJ2Gq?=
 =?us-ascii?Q?1omeH83q0JRd5tpu0ydzn0QlOYnpORltsLGV+SJf64PaEvc+a3dxrKfNjsay?=
 =?us-ascii?Q?gIjGNjgMWIVRdfxr5ogAVE5OAFwzB3cg+PRVTCssNTaRPxFA/7hjDmErSBVU?=
 =?us-ascii?Q?Sbncs4QHrqlWtgrp+NjYhePZpzzrbEExPkPkHoNa88F8TCvOQ3MLa9FZW0EL?=
 =?us-ascii?Q?LtaEdexNRb1ezxGonM2g4gVSvkXUgn3kNNqAp99K7zhBb5JrGmEWe2aFC0HA?=
 =?us-ascii?Q?LyG8dko+h+6hld7FS8teD7EQqg64eew7yX+1UyVgTucIUahxtZCM4sX+cBmV?=
 =?us-ascii?Q?AmEwm8p0Ymets/8UccYkdV6Pfp5D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46bd10b2-3150-429f-b65e-08da1dc479f3
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 03:11:32.5029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AsMXPiC6q85f+3pnb51eQ31vjDPSYWh1rwJjb+wUXN1YT40a03oZr09Fv/im+bh6Me+WVojueMfQisedXHtJaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4452
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace `if (!pause->autoneg)` with `else` for simplification
and add curly brackets according to the kernel coding style:

"Do not unnecessarily use braces where a single statement will do."

...

"This does not apply if only one branch of a conditional statement is
a single statement; in the latter case use braces in both branches"

Please refer to:
https://www.kernel.org/doc/html/v5.17-rc8/process/coding-style.html

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index bd0607680329..e3842eaf1532 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -3752,7 +3752,7 @@ int qlcnic_83xx_set_pauseparam(struct qlcnic_adapter *adapter,
 	if (ahw->port_type == QLCNIC_GBE) {
 		if (pause->autoneg)
 			ahw->port_config |= QLC_83XX_ENABLE_AUTONEG;
-		if (!pause->autoneg)
+		else
 			ahw->port_config &= ~QLC_83XX_ENABLE_AUTONEG;
 	} else if ((ahw->port_type == QLCNIC_XGBE) && (pause->autoneg)) {
 		return -EOPNOTSUPP;
-- 
2.17.1

