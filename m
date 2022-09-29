Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23EAC5EF10F
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbiI2I7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234841AbiI2I7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:59:01 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20712.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::712])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDF9DDD8F
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:58:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oh2X7nVjV6IU1eO5sMQjijkBKfJIh+wZfEUBBc81S+GAODtFPGC+d1S0fyDTrMy2BgxXymPrI2auIfb66aVMuWE/I4vECBetlmHPtJVK/cxz8/lbHZlJ98QTRmM2EullROCvqj+B/zCtCHoPA07T4cU8Ha1qu/zN2LH8JjPy5POD6/G84ZbT2jGlYbjeEINBry7wuCfgk/difDbh4fyrhnLSinN0pCgnqTtBeE2bdk0YHxbnvwn7Ne63jVxfz6h4UccTV3bF4c0ixwDmcmD5E+cqDj9xt44X8kI/kFAuj7GRqlbxoXum3WQ0P4rT1uWCbjUjAttW4VAqnn3i+N5ZsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fl92N4KaCggtMsUzbNIKw4hULs/CANoPYN0Uau9w9d8=;
 b=NgnXHlrERsg/uiOetAC9SflqlUS6WFJpW9sw14xnsq5C+7pET+dCW86qg/C7bw7lFl340zmnUFMAtnW4B1LxPBqdPfQyGgUlUYf5Jq8YSPtJ/98XOu/9p6P3GnsMCNo+uX4dfKcRcuP5SPrCzUc0OluPl6s1FLmblunO1P4LDK1KhhJoFQoMRB58vt/THbU33e+/pU7/uL/AdIgmZ8bRyAi6EhRwODiduc/+ypIZi1vAJwYh2r6MWeKdzteFVQXxnl3MtZ6KtP/VZ6a8QSkaGzVXZHu7D/uS4oiONTrWwRpMvVNeoUrHYsQ175Om5bybiNDmgLYquVPCToWBlzduwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fl92N4KaCggtMsUzbNIKw4hULs/CANoPYN0Uau9w9d8=;
 b=Tk4hCI9QKi2WYuhsNzLUeaAWWgCWsUooECXtXckMQORlglv5jNvlwkFUfbh47pV0G751ZJR3gU0Mu2z5pFmKGZtpBkYOgPeiooIcTQIzze0l1IrjIavImOAbpS8e3s4KXQGV0Gsy+cYQ5HXSg8ppxRf78nCO36Hxut7870eMOH4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3854.namprd13.prod.outlook.com (2603:10b6:208:19e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 29 Sep
 2022 08:58:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Thu, 29 Sep 2022
 08:58:56 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: [PATCH net-next v2 2/5] nfp: avoid halt of driver init process when non-fatal error happens
Date:   Thu, 29 Sep 2022 10:58:29 +0200
Message-Id: <20220929085832.622510-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220929085832.622510-1-simon.horman@corigine.com>
References: <20220929085832.622510-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0036.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3854:EE_
X-MS-Office365-Filtering-Correlation-Id: 76c4b18d-7af7-41b5-2fe3-08daa1f8d70d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +/CguTtKbtYShS3Tt+fWBsT7YxMtJ795qZeWYAOQxQatX1e4kgdSJ1mVK4bvqxJP8SHaui1oPoEQNn58z+PYC0FcXGbf6PLWIXzbL8HyI+YJiy2iwIKXB+bDXgTfQ5F9StyzHp5jN91HikcQQGvjy5vPx3xrWKIlnqiCdFdc2Ywuw9+5QHl6/Z+Lj47UdARTE+mtRZEUbmvpIgUkBieDOWajL1KsCgk8/Rt9mk+Fc/waut/d+9fGnZuinfRwFZluGFyZ2VBb6T9Vl7yH4w648Flr/iYyWE7NgvbyiVl4t9f76Zpb5/OOIjEwfIuMhy0UPY8+ecYXFOdcfIMu8iNSEESygok9M70davB9ZDMm2/E38WxFPvA/kuQhiBP+zMtxM4b0QSmgMouND5NJK/4UrQxn5r8WHqzZIxQDZSFwKJ6MGX+JnD8pn49WaOFbEqzL4tPzOFmolSCmySlCARJCkyKkNdaf3XunVdIlSf0PHItAwrnFWgmw9Unh3m9AJqEMpbuQ7jBJrSC0UBzOSGAbSuhvC6MXhtvYLiUaQcaP/XVcQPV+IP4VNbqFZOg2nexxzWuNpBVvCKVY8nMk++qCEqj/aWseVheCWf2caHxBaDNVMllgBk2XQ6JLV0pTPGScyxoFucV8trJAkYsORugokG7b8DnHa/k7QUnJ7M6J+CgVEDtICMI+PlaPsIgQIyHo3fYNR0D90gQmrmYEUE099uzeXK8Fj6C1qBzwcTNcJIL1pPk8ARKEQ6mV9nc6lb3U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(39840400004)(136003)(451199015)(8676002)(2616005)(1076003)(186003)(83380400001)(6512007)(86362001)(66946007)(4326008)(54906003)(5660300002)(66476007)(6666004)(107886003)(2906002)(36756003)(6506007)(38100700002)(66556008)(6486002)(44832011)(52116002)(41300700001)(478600001)(8936002)(316002)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hHLgWLozo5+ODzeHzrzQcdHJuRhkKTOOj94S/inibmClDGXfvq1fwXkAicPS?=
 =?us-ascii?Q?GXz3fTiqbpGEG/qPzg7n8TfFQRaEOPsUOAnoegSQ0VHFP1sdpGuA+o5/pJeY?=
 =?us-ascii?Q?gd/bvGnDulOLy8UUUBZlTaqZ187MyRLiLGOFyHyYjVilLXxuJ4kJz0/Nv5Nq?=
 =?us-ascii?Q?gFQJEqAI0ElCXLizrBVYUhrWTEYbf/bs+fA2yJF1IItDY9F85qpMm4vWI+mz?=
 =?us-ascii?Q?ZJdMsDimwruBi2B4q0IyEia3J0E3GK+an5vM833HdHL+pm2gD0D9sm9qT+xf?=
 =?us-ascii?Q?/bmQlPscCrXZoPao6GeP8nypC8LFVgWu+QvPNY4dfpI/eMqvDcWOQblRsYy7?=
 =?us-ascii?Q?rKWF84XKyF2qXnA+lwtwah89hh/sxSdHWbxgG5iDx7N2SVCcWZ4D3ZglnqvG?=
 =?us-ascii?Q?7ROEq/herw08CjeOhWy2QGfImx52YkchdxxqH34BjCCoY/V2A0np2IWpTn6B?=
 =?us-ascii?Q?TDqfUFkiqE5YzRcbinfRADw1VMr+oUmxKNaytQRFIKHF74lzyQ9ZP64trjIP?=
 =?us-ascii?Q?FiBCSIKviGm8JY5fwRoID8MQOisG6Dki5tBLwwlWj6U0ECiU6K03sZ1lGThR?=
 =?us-ascii?Q?B47OPN+xkgr2dGTgSZepjpOiT9dd/Cg2kxgMZj+5b9Q9t5/QlKmsxydRcP9c?=
 =?us-ascii?Q?TIsQfjmVAFBvxmIc+R0aotm0VUzQ4BVNBnN52+KWplkFPhP49pI/UaYBr4um?=
 =?us-ascii?Q?ZwMtBXPySflCBgTZdeng5u8be+FgLc4YhfvA7207aglquf7TPSSgqJ4605jg?=
 =?us-ascii?Q?Zw7PDtghLd6q55aqv3OLTL+z5LwvRmPeSoIK6gpfw/0UzeRo+0iAl6H1Jre8?=
 =?us-ascii?Q?mJoI3Rl3MbPe+YZKsyJlznnGknV9A9yw3IjcUmlr86i89Ua1lJ+QOP06YFyY?=
 =?us-ascii?Q?rtOobxF9ptG730bzVjPK2bOrx+gA87GAAD6PTHWaEaAXUn1ABP/1oj4NAkcd?=
 =?us-ascii?Q?DOF2c/LaIknbEkGG6QUGevowVfxiu7rF+MdKXgTaLB8aMDkHlvhpKJYw4zJ9?=
 =?us-ascii?Q?0zPu9aDpyUo/Mzd6Qmrcseoy2IHtclRucFL+6mlMFYfwfICET69Yg9yXie11?=
 =?us-ascii?Q?8THdmufUNQT1Op23kTMOXKTU9WfhDrje5OrIX8f8mEiJCTA0BgEBd80+KK29?=
 =?us-ascii?Q?0n34krdHt5QS8QsMTG6O2L7MbQ26mkny5HEVb9GeHROCNASkwWao8y8r4aka?=
 =?us-ascii?Q?7wtbib9pgFxUNnMAfGkqqaK6kxADb/xlvF6scZtB7izxzp19m3/M57PZ9/rl?=
 =?us-ascii?Q?RaJrrfG+sePyPeSMSwqTBhjRF8e7WJnEIi4Ox26t+Yo9McfZJOdyd0NFOOrc?=
 =?us-ascii?Q?pKTx4p+dG+AmZCeztcext0EmwP5wmTy8Y/dZ8jKYwJ50VUvBztVH1nxXG/ft?=
 =?us-ascii?Q?ywzwIkCJPGOjJYl9CwSfZ/PkqFTYshTjPakInjJIV+uecc1VZOIJ0Vsd76QX?=
 =?us-ascii?Q?PiACcV4xjpWX2TWxin9AGTIysMg0wVLP+TBQ++5vFC8qaVTDWbJLYyTmeRes?=
 =?us-ascii?Q?vGXsCTK3lPpGRFXfGECuPaJUZ2yZ7uLAlnIarYa3zicT1FVh19/5lNIvqKqv?=
 =?us-ascii?Q?B8O7EO18SgiaGhxkEfvNxok9H5+r+ToiaLu1XbTORSmTHNOb0Xa9dmHje6lx?=
 =?us-ascii?Q?mCv6X4Qr5aa8vq0vJP2CCbJWP6ItR8nBcSUy7i8GwObQTuaZOujDBoLWb97o?=
 =?us-ascii?Q?eW7reg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c4b18d-7af7-41b5-2fe3-08daa1f8d70d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 08:58:56.1094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3gn58cZaVKqM3nRvULgfE9Sq25Bgc1F7ROYid0kG3uVQC8NSHw/+eAWQfpxleK0cTe6iRCwWVQuNSOlkOOoJph0sseWpN2yyCtpeWa/bDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3854
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

It's not a fatal error when setting `hwinfo` into management firmware
fails, no need to halt the whole driver initialization process.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
index e2d4c487e8de..f3852ba8099a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
@@ -315,18 +315,17 @@ static int nfp_net_pf_cfg_nsp(struct nfp_pf *pf, bool sp_indiff)
 	int err;
 
 	nsp = nfp_nsp_open(pf->cpp);
-	if (IS_ERR(nsp)) {
-		err = PTR_ERR(nsp);
-		return err;
-	}
+	if (IS_ERR(nsp))
+		return PTR_ERR(nsp);
 
 	snprintf(hwinfo, sizeof(hwinfo), "sp_indiff=%d", sp_indiff);
 	err = nfp_nsp_hwinfo_set(nsp, hwinfo, sizeof(hwinfo));
+	/* Not a fatal error, no need to return error to stop driver from loading */
 	if (err)
 		nfp_warn(pf->cpp, "HWinfo(sp_indiff=%d) set failed: %d\n", sp_indiff, err);
 
 	nfp_nsp_close(nsp);
-	return err;
+	return 0;
 }
 
 static int nfp_net_pf_init_nsp(struct nfp_pf *pf)
-- 
2.30.2

