Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA3D4E2969
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 15:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344498AbiCUOE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 10:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349145AbiCUODX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 10:03:23 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2135.outbound.protection.outlook.com [40.107.117.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65770175386;
        Mon, 21 Mar 2022 07:00:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWKz1ix3e6CXPnj7SuGMaPuioX85bqygRbGwjVlruINvQqOO+pFm4uuZQpfsLsHCD+k9a2zxQkqlE0FlLakhGBssvsGw57L4xAWYrS3RUuCnH6rKxQWStStBS+Y3q6ibj6/kl8xrh3MJ/w0oPhqBgdk87kaauDlvbUrsjEyEewC6ne8cdg++X4la0v4dh15wqA4cSn0HihWvAPMGJZs/EfZ9N7MrfKUEjVT35CPlHjI8iJ2tHVMc6ZQQAtiNjTjPZDRKD1VrFxLNHjLzvSi6+2MVvXgFeJwuYWLkEe6DQ3H5y1LBkCk+/pcFh+U1sxmHvgMm+mAzNg04kUU1fSwNGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=raIMv+jYAUYeAwZAsAfcnEEdMohFzYBNJB1JN8vdqJE=;
 b=jYSjweGbZ1y3MxnDAnBftjtX1cNqfOzlzbxUOhIGbwi5hczXkE2nXIcpJMCuIC8ANT4fAG0WiLe/KcCodkKFxKFxFuHgARkg3PC4nuWhu9sXvU/M+gXx/zZDKyyGH9EZQNaNUaebqqe5MoXzqrHgHXBAi9mHXs4lP6fO4UvQGRJlxxjPVFERVrTq5TFM4GUGpkQLUm4Be9nhh8r7HL0XouleyzqKl59Ov2xqSIiMFTWH7DDNo/T7/NarjuYRVMEgn24/0m90KWLJwmXHeI6AJIadaR99g2CCtcIPYI+0cbBHM5jnM2z1HcItjRBuZwp0lkQFHm5oy/O6IUwDuW0Lcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=raIMv+jYAUYeAwZAsAfcnEEdMohFzYBNJB1JN8vdqJE=;
 b=B3CGwk1tFX4dELmCGZOM4l3UZ8HrMeZoPFArGC4HXImjf0M0zbPtCVTWr2ZUFdXbsoz/VFmSkRWjsvxQ7+v7n486IcFFpF55HKQHNbd5GiwZGDqBKhmpS0DimSfavByH6pCK3LUUQe7nXup0TFVzuvT6JQLPPkrpvXY8UTo4HdQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 TY2PR06MB3469.apcprd06.prod.outlook.com (2603:1096:404:ff::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.17; Mon, 21 Mar 2022 14:00:07 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732%4]) with mapi id 15.20.5081.017; Mon, 21 Mar 2022
 14:00:07 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     alexandr.lobakin@intel.com, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH v2] ice: use min_t() to make code cleaner in ice_gnss
Date:   Mon, 21 Mar 2022 21:59:47 +0800
Message-Id: <20220321135947.378250-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2P15301CA0005.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::15) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 101997a1-7d9a-4dd3-10d3-08da0b431a5a
X-MS-TrafficTypeDiagnostic: TY2PR06MB3469:EE_
X-Microsoft-Antispam-PRVS: <TY2PR06MB34694A95BA381856FDAACD0AAB169@TY2PR06MB3469.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wAP/pZCxM01cEEtGlwN9AD4Cja6+arDYAoZ1LXKO2EW/iZVVsMdlymb+a2Tu/YT9U6Npl3Ho7Esp4Ty7TiejGmzPxXrwGv0kf05tiFsgIROlkBumw33DYUJa7xH8def7dOCIjD8+1SEgv4wyxwfZ8N9iZqBElRJbmxolXlI2POoSi7v738I/XllXV+ol91elkUELBA9psghFvaiWcmUNRa7CIR8EBKU2tmKuoJjXH2dxWk3c2ayZnjY6tDxXpxusYFfiJg4wk27cwiLk7QSh/lys1p7yDOFUrXPfhnOdu34/XCpFQaRSr9NAOyOOiaF5u0oDgMIsTp3OVMOnJ25vrRcy0bRb3r9SOx5J3d9Y2rkPSNPUJcUuySbmg1wmWQo4zFh+vT23EGQNmgNidhbEZ/iWk70llya5xISsfQegN/iM3kQZd54TyEqZ/WI8UWlfYo0MDNB0jVex1K0j2OFKWRbfa8vKXxXNWuYDeboi4/mXUaUlCUn3ctypxN0w6WMXFFF9fv1+gJYKcfrfpTOWQtPiqc1q9135xR6y+pFjINTeIlpZXVGWPwYvscDRh5eNnmPvbLfn8PrMNcAxu2D1zpc9X4Hd+ef/w7eUeZDc/rtGSqClWIZLiCUcwxBVcPAGWWOGPKI7UiRATWe7eOpL4ueAAi8utHD5CgeAkANqMxotqfjXack4+P/xerP66qgkTJjPRq63PXrnLfek3mggng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(4744005)(5660300002)(38100700002)(38350700002)(52116002)(2616005)(107886003)(6506007)(1076003)(6512007)(186003)(36756003)(26005)(6666004)(508600001)(6486002)(2906002)(66476007)(8676002)(4326008)(86362001)(316002)(110136005)(83380400001)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HkLiA3qfNxPd1MiWtYfiuTvBKmpnHEjvpi87Vj2EwgyGrAv8TlBR6VfZw+N9?=
 =?us-ascii?Q?GpNJV4ZZPT7ctbrLqBse5HZt2Z3tagK7P8KKQLHLUjB3Cbtiq7q8t1g3LwHq?=
 =?us-ascii?Q?+0PO/Hx7D85UWpb6fUkHad+lkQ8rxmIoGvwiQy8NZj6N2tXGEerF96omFSgd?=
 =?us-ascii?Q?hQEKilgS8mZ6BUaBAOsmyViPLlx6qIBT8ygZp24rJGAAHGC+z3pX67VnrbaT?=
 =?us-ascii?Q?54ZBZaDGvQHs2t+gb/KjOX8HT0VRPYDrKCtS7sHnpGFH/Sknuiqwl16muJjI?=
 =?us-ascii?Q?aQ/iAuUpee1MB9Gj5+olNRnDqkjPMibRnfKdv1i71XluLElfYFQBQOGiOrcP?=
 =?us-ascii?Q?k19rXyCFEU8YiLXwU4zTsuczGc/rMpG1p7MruDnetLclo6M/9wTBrsq3qDUs?=
 =?us-ascii?Q?I+1JpkG4olDPuhTwTpjIOnabK2px+wofQZkN70lljohQwLOFpaRnGEOJ+xiJ?=
 =?us-ascii?Q?n4o/mdUoFg0YkcE51Jv7mHY2TJGYM6CIYB631FjzUsNo6GhUjwmHw2NFsZEw?=
 =?us-ascii?Q?yoZNiGHxcAXBM2B6HKdoax8hKGOrytmqyLNvuD0qOfb7l0UjK7RjfHMHOd0X?=
 =?us-ascii?Q?chb9l/a+uqw0ecSPNiuY6aXqZqtgQK8idL/RDxEBj3kQ5NrliBJM9iwzAAhh?=
 =?us-ascii?Q?BQSHxRfHKnmv3wmA89tPTeBNC4Mr56jT3U3WlNyYArXvyS7MysWy8j1c9PdO?=
 =?us-ascii?Q?zld/AiwPyb++r7FTghkLSx+X0nxuE5vI99Bp8D7VDE9KNBh0O8FiL50ZzDVx?=
 =?us-ascii?Q?2dFLn/bnjbRquU4NyD9V9enKfbgyZdT9296guSlNuHRsvY8W+BAGg/mZfdGy?=
 =?us-ascii?Q?rDdh/Umuq9QXzQnNj1w5OmYGxSOcsefd/l8SguvrHBR4uNvs/vH1RpsqbraP?=
 =?us-ascii?Q?GLvrARcz3WdYoDsffIGTjtQqGKjhUOx60KATTGS924V74n6ihyj7AAmjoIyv?=
 =?us-ascii?Q?Ynf5A0oNP9HQTlTlxjxTHDeUZ2Cm0W8+PoezQ4j1IineS7yRn+iG6baG7++H?=
 =?us-ascii?Q?eWm+9tt/RLxE+8KUZg6TBwERXDlAQeszpSJ8YdYNji8WWRN0bPg5aTbuRlYZ?=
 =?us-ascii?Q?WiAyvaQDNMS/kdhFK19Lk/DJcvBmajqv92ZinLDcXm/RxBt8bY3D9H6/mZsY?=
 =?us-ascii?Q?8iNUx9o7A+KFvN3Jvm41AFHkXQK+goHSvruXJJofJSDhrMidM7OTvjjrOw+x?=
 =?us-ascii?Q?XyaQt8iw8EXp0gSq673U2BSyF3TNBaxWcWjtrUcaJl5Drtrwn2CSHhKNENsR?=
 =?us-ascii?Q?+E3tKj6viVQa/LKpY5lZs1Yd/cgGVixGsbCifD4BWmNy+1noV3ZDyjg03jho?=
 =?us-ascii?Q?7xWQ+PqoJErdAg79hQS4xUDstWBhEQKz6zR/FMmUQgVVr04MmUDWtVO1q3qX?=
 =?us-ascii?Q?QYGApRWwpGBIniPEOK/kzEaZNRB2dHtC8gJE+LSCVFQn0LUUcq0dioCGkfWc?=
 =?us-ascii?Q?NEsfQPHr7PVyLL1wADvNfigan3h0Hkw8?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 101997a1-7d9a-4dd3-10d3-08da0b431a5a
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 14:00:06.9482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hopYejgsW4P+fycC9kq1IRHSg/ozYnyb9t6gSPQeqLuKMLiOnEOM0dRsD6Hf8mxu/GFpO71P/d4zB7a4qxORWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR06MB3469
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
./drivers/net/ethernet/intel/ice/ice_gnss.c:79:26-27: WARNING opportunity for min()

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
Changelog:
v2:
- Use typeof(bytes_left) instead of u8.
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index 35579cf4283f..57586a2e6dec 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -76,8 +76,7 @@ static void ice_gnss_read(struct kthread_work *work)
 	for (i = 0; i < data_len; i += bytes_read) {
 		u16 bytes_left = data_len - i;
 
-		bytes_read = bytes_left < ICE_MAX_I2C_DATA_SIZE ? bytes_left :
-					  ICE_MAX_I2C_DATA_SIZE;
+		bytes_read = min_t(typeof(bytes_left), bytes_left, ICE_MAX_I2C_DATA_SIZE);
 
 		err = ice_aq_read_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
 				      cpu_to_le16(ICE_GNSS_UBX_EMPTY_DATA),
-- 
2.35.1

