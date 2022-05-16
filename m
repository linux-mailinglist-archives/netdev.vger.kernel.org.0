Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302A4527B89
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 03:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239155AbiEPBw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 21:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235915AbiEPBwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 21:52:25 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2136.outbound.protection.outlook.com [40.107.215.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C875FFE;
        Sun, 15 May 2022 18:52:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4zVJRbQymKZnAdDlNOjmhNFuaHQBER/ly0LfLLikixWit4EOfqBDfw3kIcj6IZb01OmiIJhp04DFtLNhKBAVLFQPziFHoD9Nbep8ZSzByV3MBD/eLonbIpxsas/8ka4yK3Dj8cNIcXuZPTh9PB5HOAzxwjGa1oXuKmOWB5Ge8Ru7efbk5vnDjgVNjO82x6VTvZxXcvinkpJ5wFPALPU8YrzNVxe2NzJnoLxSq/1JG4xZM3D5i7LSrQZM1dw83aJHCJt82LRzhYesfjQD0kkEvGhjvA3uvXYlJYsOCR1OU2XubihCkSNvT7kDLHgAyFkdXgxGRhrE70cS7nHt4WtKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a+NL8EnPQHy9GnLQt+39iZQmq2QqytyZ+Ad2tT+AGjI=;
 b=Gpf4wiDnLLrduvnDf6371fkF1qn01K4MU73qt6fJxZDdJcsTvQzabTGdhZ4ZGjFxHmfCM6i2ieyDGdwxGpLjs9kvIQ+vWH8ybqIyyS5xjvJYzwzPPfXJj5VI//BCSBOvipQtQLTiSxIoD50FYlHilv9Kn/yse3KsuFMiUOvbJs6P2BpMOy2D09Uc/aCHK9Vpvo9vVIphzMsvXKfROpk70R69t92pL30riXvlJsEdrp/lYJwPT6LIlLN2Ek5wlzA7QtouN4NUQ/WnR1x9qmYr/NtoFFbzs1MW3UNEC3766vNx2UtejmOLOS8D5VohXSbORCXS8XnnWyulKkle9Ta6XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+NL8EnPQHy9GnLQt+39iZQmq2QqytyZ+Ad2tT+AGjI=;
 b=PWtgujWjzZDaQ3WtKCGvuDOvCWA5F1l+5vrk9IcKN63Fcsv7PixyjlCN8FNtA391PTV4ebRI1p/Tmjs+0+fZ2yOMbrLebJxyOQBGErd17pQ/s43zzgctnzgCNjB6HKKsAvwnIsWlgh2nZvq/rvIJHm7H4/nyE+dRuVXm1G0WoWI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com (2603:1096:301:37::11)
 by TYZPR06MB4509.apcprd06.prod.outlook.com (2603:1096:400:75::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Mon, 16 May
 2022 01:52:20 +0000
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::4dea:1528:e16a:bad4]) by PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::4dea:1528:e16a:bad4%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 01:52:20 +0000
From:   Bernard Zhao <bernard@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bernard Zhao <11115066@vivo.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zhaojunkui2008@126.com, Bernard Zhao <bernard@vivo.com>
Subject: [PATCH] ethernet/ti: delete if NULL check befort devm_kfree
Date:   Sun, 15 May 2022 18:52:05 -0700
Message-Id: <20220516015208.6526-1-bernard@vivo.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0024.jpnprd01.prod.outlook.com
 (2603:1096:400:aa::11) To PSAPR06MB4021.apcprd06.prod.outlook.com
 (2603:1096:301:37::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f14a4b02-a4a4-43ef-7580-08da36deb64d
X-MS-TrafficTypeDiagnostic: TYZPR06MB4509:EE_
X-Microsoft-Antispam-PRVS: <TYZPR06MB4509EA3AA2F9EFA60B1BF2F3DFCF9@TYZPR06MB4509.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R8H/9+MS+thWb6J5wuXlCeymmK64MuX7Igb8VfE3D5hfEnS8IcRuZRHWLCkS06kCHMInywKA2adco6uge72T/RmeHFXA0n3+6lBUbyzLZmlV5tDd32q/rU0eGYYhim4Evve3DYmX0E9xWFCK2fPIGnXJDUMi2CycKRTY90SbrEkQjlzxJRfVP/zIrSMtssl1+Te4RZyMg/9EkvlDJdpxxqNfgCX4E/fznFrSLTIXfd+NLgy+GLC8VgM1HeghM4E8WtBgY56d9MdW3AtdcGglVlG3JMeqTiPMYleWk39RlV14oVJ92pKq6IjznEQZSFh1Wy8yfynXI4pVGAzEv6I+ngMMf4YC4xP3e2NXGT7+JzjlzRVRRaookexaLrhrY6z+aS0SVAMH5Ce/4YTNbQB5Eb+kPWm0qCs9CMyad5VNTS751+7SyrOQ2qJ1ZKidfT6OYX7nA89ad9qZWtowDGkDpK/KrQCHqb4atn1ZIAi/sc4TfjZu0GczaM9SkPRdMPfRq/G7QCAZIs1xHGpFUuDMqHl0n1WCJIff0ZgaVQaBydRaxOlY/4pjRx+Vjr6vGPENCv92j1ymtJ/n5hN3gw2f/pDrUtiniWdlMp/lJ88997w0s1dS3MM1CtuHGcZfrbTJT1WbNrmr6WzfWtj07h1nlLUJgu1cPr5UtN6o+PLk0YLKIFlsdOKYX4g5m1M2d6dE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB4021.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(86362001)(6666004)(66476007)(38100700002)(1076003)(2616005)(186003)(107886003)(6486002)(110136005)(83380400001)(2906002)(52116002)(316002)(508600001)(38350700002)(66556008)(66946007)(8676002)(26005)(6512007)(8936002)(36756003)(4326008)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dOxymvCHUns+KK3NbB/S5Z8BSf7urd/aScbQiZ9hKH+aj5dlPG23ZCfVVHN1?=
 =?us-ascii?Q?yPDHAlqzoggEwsHHtN8sPSy1uxtn3uKYQyug7GpXZHnIrYZvtRHShIVaNy0b?=
 =?us-ascii?Q?9eHRS9PD/RH/Z1vZHNxCdxNZjRnBazjMcoWErAK/vhR51l/gK70bICG9o+7t?=
 =?us-ascii?Q?vbsZ6p7L859MpLaFG11Odbx5LZ7sMqwVV7j6vA3XRhPMs5Y5nQM0QvAG4Pzp?=
 =?us-ascii?Q?tsj6p5i/kbk57pGp4429Uz0HqC0SCW7dBux3HZIbY9Q7shS8Nyl6MY06H3mt?=
 =?us-ascii?Q?xVbst8K3L2iOl+jXUNyzvrfgttRDZHBCoVgfuy5nUO2iFB6GTjkySmmmCwxU?=
 =?us-ascii?Q?wBnuHeEBN2XQuSsX6tHL2+ZnDfYCdzo0mWuRkTIeJqxbfrumEPA37JB8o5f0?=
 =?us-ascii?Q?p5JEcZDtVroPbuOsPgo+iv2knrnuHDpoJ8eHmQMAC5Kh35eBkAFA7cgENaZl?=
 =?us-ascii?Q?pvP6EIPwYla5cbz0JVNGZBpfVscZaGADbifgG3KLv04UvBzIej4NOy8p2ZBW?=
 =?us-ascii?Q?lSNAUauLCunNepREeJSDoIOEm70U9BnZcbATSj5lb+AFaIG2zaHH2Xu+8bAX?=
 =?us-ascii?Q?RnBnbJ8P5NQPqP+Us8rm1pjF98Hq8ZZv4nGb6GzcQPRSfug0nEEwS57xAKAk?=
 =?us-ascii?Q?iRO6U/v5f62vP7o7wE9jnpiCFmsCTUbjTbgaiUO8KvzHFAzNpW/4yEzh2aMe?=
 =?us-ascii?Q?wzqBzV8pdGvZ8r/e5JwylPQCeybimKQ4G4Tszl7BZaaSFJhP8SlioAQfv4Ff?=
 =?us-ascii?Q?qEp81N2uL+TfhiY5dTNq1IkGVC+fK+T1UFQiHcMHtIFIF3HhMEkJ/GYZg3ZK?=
 =?us-ascii?Q?Q1YZj4F4uB5p6lBa7Jr0wvV2H/pVDBGypTEvutA6/agiA1dacV9txH1vZ5M0?=
 =?us-ascii?Q?Y1sPhbQ4eZI2QI4pQWmfuhPcVEMN8R3mJXOQKOZz/6sMT0IkJDwZomUozVvV?=
 =?us-ascii?Q?/R41jSE7QUtFBW1PAWV4EX0CorsKZsy2j8fNOYv1txSzK8ShH8Kz+XoNkxai?=
 =?us-ascii?Q?+F6Ihp4mRh5flXW/O7O/c4/3iMS72Y/wJUtmKEbmMVL8JPb5CPFE9XAjZoqZ?=
 =?us-ascii?Q?hrjgEETtgD2eunUuIOlgmIypeC2hioAWnTbX0RwbISevH/aDP5CWJhqGws15?=
 =?us-ascii?Q?XCCuZ3JTRycJnHPqDoV3wJga0j2oiU6fr1ad/92N1sRCLb5dYYuB4aAemxDp?=
 =?us-ascii?Q?2ogUAO1qQLbd42dqcwoD7p44ivEPE97R0beVzhLDGYMHcBzXYmwuYjtdP+kD?=
 =?us-ascii?Q?MK1hKMFveYdQgWKl6EIv7sa8n7uFLQaFMli3v3PTulh2YCwhj3BLyOWJ6WUJ?=
 =?us-ascii?Q?G41F0IpEYjQj7hX4wcIT0uyCi8MuryTTVctDFSBzEIXEu1s3QqQ627UpKATQ?=
 =?us-ascii?Q?dbALjJCSxL8zogANv6PJTyTR5GMHBDRqQ9fTTZVod5TaPjPHu8qUwj4dksB2?=
 =?us-ascii?Q?E+lOh8hLdwpBjclpGWR2RGTiJcoFP5YuYB/ZAzvQZ3uWSAw6RuYQbEkapqWb?=
 =?us-ascii?Q?if2tfoiXmDaarhKMj1BaUVAz/H28McgfZ52b7KEoWsfH2Q4Ec3V0nzTL32il?=
 =?us-ascii?Q?FYu+k1DOTtQUHSAhbWIPJSbaXanNoY8qRzlaO81Yu/qjNf9p8jOTBlDvZBrB?=
 =?us-ascii?Q?ZzJ/N42HC4KAD4SxTPd7isj9BFKAL+DKUoLSQ0E04wO8qlA2RUR6F9iNwJR2?=
 =?us-ascii?Q?MLh6tKKOapvWryioSdv+93Cpw1TZK+2Dm55TF+sxM5vw4xSICTX/EZ8tz2+Q?=
 =?us-ascii?Q?mKYyQ2ex8Q=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f14a4b02-a4a4-43ef-7580-08da36deb64d
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB4021.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 01:52:19.8015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZPHT9hY0yeDKN8Kn3/OqXtno8Th/+Hr/Xa159bMnYUxtYPRP37scqLgez3RCh0WW9NRcHUjVRJW2upLYMGJ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB4509
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devm_kfree check the pointer, there is no need to check before
devm_kfree call.
This change is to cleanup the code a bit.

Signed-off-by: Bernard Zhao <bernard@vivo.com>
---
 drivers/net/ethernet/ti/am65-cpsw-qos.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index ebcc6386cc34..16b8794cb13c 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
@@ -164,8 +164,7 @@ static void am65_cpsw_admin_to_oper(struct net_device *ndev)
 {
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 
-	if (port->qos.est_oper)
-		devm_kfree(&ndev->dev, port->qos.est_oper);
+	devm_kfree(&ndev->dev, port->qos.est_oper);
 
 	port->qos.est_oper = port->qos.est_admin;
 	port->qos.est_admin = NULL;
@@ -432,11 +431,8 @@ static void am65_cpsw_purge_est(struct net_device *ndev)
 
 	am65_cpsw_stop_est(ndev);
 
-	if (port->qos.est_admin)
-		devm_kfree(&ndev->dev, port->qos.est_admin);
-
-	if (port->qos.est_oper)
-		devm_kfree(&ndev->dev, port->qos.est_oper);
+	devm_kfree(&ndev->dev, port->qos.est_admin);
+	devm_kfree(&ndev->dev, port->qos.est_oper);
 
 	port->qos.est_oper = NULL;
 	port->qos.est_admin = NULL;
@@ -522,8 +518,7 @@ static int am65_cpsw_set_taprio(struct net_device *ndev, void *type_data)
 	ret = am65_cpsw_configure_taprio(ndev, est_new);
 	if (!ret) {
 		if (taprio->enable) {
-			if (port->qos.est_admin)
-				devm_kfree(&ndev->dev, port->qos.est_admin);
+			devm_kfree(&ndev->dev, port->qos.est_admin);
 
 			port->qos.est_admin = est_new;
 		} else {
-- 
2.33.1

