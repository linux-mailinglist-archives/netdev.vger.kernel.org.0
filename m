Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6254F4C1885
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 17:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242789AbiBWQYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 11:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242785AbiBWQYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 11:24:12 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2093.outbound.protection.outlook.com [40.107.223.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C42C5DB1
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 08:23:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jspV0eGcQXREvNrNkt4xER/OWVtAOh7Xa0xyj7wYGAu+vgDfKehlrGoxK8B+Q4uLUGhkjBYObaAnFjQW8hH2uhh0WSxKYyUuGEtPsG3ClZi3b0340v3PP5pKmIUauqe3j931mquNCmyH40imlneZk6TB1wUSE5B+a9hbUL0NCQCLxREi9CHHs2T/N7TzbK1fmuX0DEQxalcxkHYQBdSaj6fLN7tRd6xTgKlA/T3qmveECU97kyeJCDbKRiBJn+98WX+FMyPggLYA09gq7DswxRshRZXEsoOdIljSgNb7Oc0+09K2YunJHdIsCpvLIN0y9p9EJsMe27vWBvhZTAWfbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRQoPF5pkMS7cU2mm3QmMFh0vMKaoYlErxSgMv8HibQ=;
 b=HzQQ5G0o2uDcnGIGn0O0Ve+aOWdUl0Pz9om2OgdW+RboHXK7hZnCuLddmWaDbzBsKkBwd0M4I9s4h7Q+H/P9HPY1XL6bRZDCa0GtNvo3WXIPrZv5YCbLC21ba7wOOm0QwT4DPT6kLwEZf0G+mdCg8TUVkluSaFebIabudb3HucVpayrh0nZoaZfiNJJGzz/arK/YePpJGLHAGnnyfZe5kSplNjshNAHVddFl/XzJvOig/2oZUBab268DIeD0cvpKRevcobbj4DpW6V4VOvA3YgHgKa3A3LF4bGEKUFJsUuxrbJZh3eLtf7DF7hF2kUIWoIQbDW+wNN4BeTaJSwSwvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRQoPF5pkMS7cU2mm3QmMFh0vMKaoYlErxSgMv8HibQ=;
 b=Vbh8WQR8tJ37KdD7jCZN+kV29C1DHM21YHgrnnbstqeDqXV3o0L8FicLsTdrYTeiLrzlO8lm0UiZbu/Je60YeG8rNfNSLEfy8w9BIVlxO3aTwBTrJcTsKKi97ov8mrnKabQLYmzhsRD/OHuGfez25xz7eABqfmyEJ549auJIHoo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1757.namprd13.prod.outlook.com (2603:10b6:300:132::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 16:23:33 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::7037:b9dc:923c:c20d%6]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 16:23:33 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v2 6/6] nfp: add NFP_FL_FEATS_QOS_METER to host features to enable meter offload
Date:   Wed, 23 Feb 2022 17:23:02 +0100
Message-Id: <20220223162302.97609-7-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220223162302.97609-1-simon.horman@corigine.com>
References: <20220223162302.97609-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f69a9fd1-adbd-4ca9-9478-08d9f6e8d5a4
X-MS-TrafficTypeDiagnostic: MWHPR13MB1757:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB1757B122E497039B0A34CCDEE83C9@MWHPR13MB1757.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lvkIHF2q+DrC7+1YljRLl6IxYjo8dSt7Ho9TahrWqQa/XftlikDHEW5lvv1z7syJ/Bs4dRFhANJx+w/+glrVofQWPsh3fbhLsmyVp6Q9cg81qT3xt5tGvPHmLLz87IYjQm8AId9osiLHn+K1ngrYEAj6p/Tojh7IHAROvDVd28HFh+ctiD0LceDBipZoUUwj9g31Fn/HUJsRnRwE7DC2ba5F/+tdW3tANeMZhsdbvpVx+r6OlOUPZwvXGL7D+l0erQDgkAcxG9Vt1NgIkjVkLJ3umnfkALPteqBxVVbsdJ2A7xfYT4vDr3ojMAl8uSJqAaM5DDZ4ihrcD//U+47RTit+7DfzzBz4ubFzs5ylzvUHvyLGW61CaykG65ybyYjn5MCUipUg2t+DBIPVC/Op3oXRdUNOZEgmMmmEyAQigr9jy93emb/x6/KhWRbGhBkj95D5Qq2g0EUVBmSJJIIu9+WROJuH8upauup1bTUEoj4SNts6LCv6HYA+9N3lz/LQHP5M4oalllIBF+Ltaskn9sEFY3UgQ49sQCU7/T0mikw6bZRX4ljYzoWk/kSvGZmD+ZtcNXW3gN8egPR7lOa4xD7C8Pk1wqg062XMh/O+ZX9lh7hX+qZcp/3f9b1Ucs8KfzCmqqqBEcEWaRo4HTkO3PEInu7x9AOfVQQyeIGwDRNU3KaDMwlj/biFwZaVkRpE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(136003)(366004)(396003)(39830400003)(8936002)(6506007)(86362001)(508600001)(52116002)(6486002)(36756003)(44832011)(2906002)(5660300002)(54906003)(110136005)(83380400001)(66476007)(1076003)(66556008)(8676002)(2616005)(316002)(66946007)(186003)(38100700002)(107886003)(6512007)(6666004)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ffiiLCHv56a16Bn0nuZkWHTbX4N0Q5U2l3xiiwXf6vmBQtjXP/r29/wasMvo?=
 =?us-ascii?Q?8fQgK8aCtQdfCEDnhHzsM0PZLdpEj+SP8DZx2t+MZIxVaB6fi/ft9tR0XmEx?=
 =?us-ascii?Q?Wj8FN/ac9v4SnL94ksyAMbFfsOd+WM5fusK8jVz2A9dbWDvii4pMuZq3zFxF?=
 =?us-ascii?Q?zE4vb6W6mH2xA6gvE7htyVmF6jvsvgtIVJWYw7mLG/032DtLOqCnToib5Yhg?=
 =?us-ascii?Q?zithHegPKkuaa7wYEmtYY5+/OzebD1WnW2bll3C71ynukgehn7F77lOm/ORP?=
 =?us-ascii?Q?Xcix+INakGIYyW/2kWrpubQQLZRwF4yBzTBr11qXTci5fbZYMbGe8gSLf2lF?=
 =?us-ascii?Q?qDhldxKjp+V2EZMnz6HaehjnpZjHU9PbmFckoN7c6jNFK1DbMQvh2FF7xH0d?=
 =?us-ascii?Q?aLEc9ziZNA/lzmGW7LrZfyZ9xS06P9+MkWvGWAVESnO8W0rlqCr1HF63Fpo7?=
 =?us-ascii?Q?KABCtpbtLBSlaTdsn+40WuQbEkDvCLB/PK0jiH4TPDr2cmMhr/s08xnUdS2R?=
 =?us-ascii?Q?wjHCa6IOODSYSaL00r3AoMpxeRwrObDWoSxbBiY9jDK5Tou0tslYGbGXgRuj?=
 =?us-ascii?Q?riaor4rgOGZcItpcuzcjWvQX2XYlak1XB8PTjknBz6wfYOKkdhnhcxL3FXk4?=
 =?us-ascii?Q?KmjQxxGsIjgF3yT35pybRrV/KocoFfDQXOPXIEWMh7iSwBfcddcZ9xkCEyPs?=
 =?us-ascii?Q?3yaqwznxrKSQSg+tjfrxBtsxx8+5/KXXMnFCsrKIfSC6NM9IS/9/biCGr+Wr?=
 =?us-ascii?Q?DvH4OrVtM3S80/G8LEL/+FxWszsIdFJlypiQCX3PbxsEyfxdqaQPYxr/XVin?=
 =?us-ascii?Q?xh4QoUGCHZhSNTUdNDeajB2OeSK7gOGzh+oGMuF1mw/tOni8RoJ3QUSn5gff?=
 =?us-ascii?Q?nNYBoGawYSkD5vV3YCk394LX2gJ11OpYtO0lbPd0cEGZ0syp00swbqB9kevL?=
 =?us-ascii?Q?oRtwy6aOfHgtX+bu2hB91OHQcpB6SGABtFWZ6oxyWeWeMlI5o5kb5CZgzUoU?=
 =?us-ascii?Q?iOb5ipsDR6O39SkYQLc6XSIIQpcjjvEkP2XOVa8f5aCDAWSVfDpwJCMtSrjG?=
 =?us-ascii?Q?XnjYi2vwHXDrjk2ZMUZR+jzxY8JPBGWAAPR/JBHR7aydQStbBAHygyTdXFMj?=
 =?us-ascii?Q?gQaT8jFrTvaGdL4Y+sVxoYZRew1gBXITToOfYomxrtImyFN8HhCzrncCJe0V?=
 =?us-ascii?Q?3L1xF4j6oArGA4mxIYMJvuPdGw30u4ce1foCrNIyPUGr/hT/1n3bpVpUqe5M?=
 =?us-ascii?Q?c2IaOCFWA8NN76DMQO2G3nXFidtFV/L+YfbirBOw8D7vilZopYl33AO4ktpc?=
 =?us-ascii?Q?JMPVVP86buw7BTkEtk8RbEGtzwf2xnI6JOzHC4wjEtASScopDQ+gog8T3VBT?=
 =?us-ascii?Q?qZt5mrUTMu30YByr5/dhzSRjQx7tSliEVUHn/X7jeADDzotFOv2SGPqznBq2?=
 =?us-ascii?Q?VOC8F1H8EpiuL4phART8ADAlVw9CmudKcbRL7K+EowbJBdB5ARSWSuH175ni?=
 =?us-ascii?Q?lAX9oWaY9/KKgt2ljWHWOWLiF/rH1PZP9t7wFl3SwjDksBDZw79jOWHJtyki?=
 =?us-ascii?Q?UQVJFLz+SC03Zn6CerWTQUmeKKXhxcqu57aOVPnmTmgDut4ymmR52SFnnY19?=
 =?us-ascii?Q?untUGGBlLe3v7xJ1EzDHZ76eITwmUFOPrnY6dIwuLwf3ed6Z1H2FmnCw9XLA?=
 =?us-ascii?Q?p3WqERt9tJtSW+WDM1UeobZyZN7KS5uDS+WqNpAb8bH3Ubn2Vn7NLN08AJOp?=
 =?us-ascii?Q?MarIfhoDUg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f69a9fd1-adbd-4ca9-9478-08d9f6e8d5a4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 16:23:32.9951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rHZojI6iXgpl/ELKmjDYtylkBXrKPqgCZJMN/do4mRn0/sMHpAW1ufsNG98SYYa7FM4BvEnA36cMZMWy3Y+esNZe+EHbo+PxJbOhahY7UJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1757
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Add NFP_FL_FEATS_QOS_METER to host features to enable meter
offload in driver.

Before adding this feature, we will not offload any police action
since we will check the host features before offloading any police
action.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/main.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 729f3244be04..fa902ce2dd82 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -66,7 +66,8 @@ struct nfp_app;
 	NFP_FL_FEATS_PRE_TUN_RULES | \
 	NFP_FL_FEATS_IPV6_TUN | \
 	NFP_FL_FEATS_VLAN_QINQ | \
-	NFP_FL_FEATS_QOS_PPS)
+	NFP_FL_FEATS_QOS_PPS | \
+	NFP_FL_FEATS_QOS_METER)
 
 struct nfp_fl_mask_id {
 	struct circ_buf mask_id_free_list;
-- 
2.30.2

