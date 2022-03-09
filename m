Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC944D309D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 14:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbiCIN46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 08:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiCIN45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 08:56:57 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2104.outbound.protection.outlook.com [40.107.102.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B0A17C400
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 05:55:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikEN7BzeSqhyrSf/yPIGOEqO67yjWGwT+kyCmoGTJx4+8c6DOZooFo4No1Z+21uQgJkmCdHcobOzeZaAjXRiLlgrnTWYDoU/ejQ/UaSGHvWJHbg88cbz6RyooAkbOUMFLrgGquwBlQXrm/QJBimWM+70vx7w16zvnCqMB8j29MvHqovwoTiJ8dUChVcNxHsT3RuIj1X0GDKWZlXvxYidwyQznr+uGHYWdWujXv6y4bo90jsljzLYnTKv8zxsxJq6/jiroBgIaimkkA3oDp4TDrwDB4QJhAEoRobfjhU2vBXjiTTAsMWepgPtt+FLomKMOn1T3IBIC+ZJ1YN28gEhSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8ETpw6wzwX6VWiy/fQg0xP9imdYlcQEH1BnKvw8b/Y=;
 b=gcCrXaa3DzlOkn383hg+uFYvF4KFh4zr41H4pNT8NlQfM658WMvBAGyygKRde3uGM7kYZuugByy5/p7lkCTeO6QwuqiM6Aw4h/I64tW5qXZJDYcy8kpbiMwqS6jXWHgc2JzZDY03CSf6wEPOFQM1IdMafrgJ//MCwQzvze1XrbrsgoY+znWdPFolWXSE5FegiCQTV+2h81TqjuSWwxw9p0UxqxwqNmYeHiuNwHTRMv7DnSKF2BUGSh5t6DNIiZqJDbbIEovrvd5RXsALIJcwnct/iwYbl/h2ZO1UvxnZ1py331VlPZrjXiGO4rUT5JYSimXv0EGXF8yaIV5dLcFKvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8ETpw6wzwX6VWiy/fQg0xP9imdYlcQEH1BnKvw8b/Y=;
 b=bZJp/gMh5YJSfMv9kxorsOo3ZKZe+2rykdLIbGeK8wTVWinWJgFLU2xhCbKCipZO0Pv/i2y60yO/9xQJoXabzTV1gHTVX0U+kBYPnXzoZEfH/LrvurHh4ckpfj/ul3E7BgykS7hsi/ECOLWMCLp9NKQx+GxbT4R1NmQzhBzptDc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4885.namprd13.prod.outlook.com (2603:10b6:303:f1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.7; Wed, 9 Mar
 2022 13:55:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Wed, 9 Mar 2022
 13:55:54 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next] nfp: xsk: fix a warning when allocating rx rings
Date:   Wed,  9 Mar 2022 14:55:33 +0100
Message-Id: <20220309135533.10162-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:208:be::49) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7da308d-de2d-4c00-871e-08da01d4878b
X-MS-TrafficTypeDiagnostic: CO1PR13MB4885:EE_
X-Microsoft-Antispam-PRVS: <CO1PR13MB48851A06DCE647450D8584DFE80A9@CO1PR13MB4885.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FgM8ULTQXTt9Ri5xi2a64W2hBNg1cwVhU8E2wwFsdzv752QlHSXhw3W4dWhLMdiMs+bc/S4gvAG29dltrxle92Jg5xMTuSU7MQdYdm4oqBXXqpQ8VAfmV27KZXQrObVuZLEs1aYKiPR5PdCWgxG3jC5iPS0NRWNMDGC05+goQDAuD4MMzmH3A1aa4zkm3h6yJvDgZIDR/0U8Df83xEfchEUAPCEPJGJmsjJrSsgsnRiQ2YCu/BKb91LzgD8o/v4IzNRUEOwep5GNeY1hJN0QuoFDz6Nvi8C5T2JV9Yg7vbMjJbhryDSpLwPVGJHGr/uXkounHUoVRQdo4SUdDCQMB9qW2VBOglrVRIxDqaf2YdPuMkiPKCkErc8OmInp/a4044BYlHJBGYeXtTgM1AdIqH34/bJ3+5GTZSuKVgYBXG3MeJXhRGhhaKZ38t8NLtai1ORcbm2lNvsBjC4sh/rk54GZHpyKFI4Wb38ii5DGxxGduYg+MP1jwXdBFapiRByAFMt5RHJEjJsCsQlAv+ul9QndgbpM9vwzYXfdsTwvfqGetYTSltO0p10GTncE6wyvCipay0PQQGMBLGe+rKKRinQEMwYS+Wb1rFPNpj/ZRCTf3kFhFlNbk7KpAE4CSBQJYbK4Hjdv+ma/sOoVWFVSIeMiqrXX1/Eo9yph7zb3I3p2nocS3k4eIsj6LyW9Hpe7Yh/hXDcFeK9ICOaGHqVPkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(396003)(39840400004)(136003)(376002)(366004)(52116002)(36756003)(44832011)(6512007)(6666004)(5660300002)(83380400001)(6506007)(1076003)(186003)(2616005)(107886003)(2906002)(86362001)(8936002)(38100700002)(316002)(508600001)(6486002)(54906003)(110136005)(4326008)(66946007)(66556008)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1VNNHphVWlzSDUxMTBtUldUeTk0bzVmWThDUnpQVDZmZmtlT3JTb3BDdmpL?=
 =?utf-8?B?TklzdlBVQ1dsampNUnBsaTVvNldLc0k5d0ZVSEZGUHJoRzVHYXRFSmxCWDZq?=
 =?utf-8?B?NnlYRllWU1l5WjdzdmFPd2dnejlpVjkrSi9YNUxEcDhkY292TmdyZjJlaFQx?=
 =?utf-8?B?L1RIZnFLY2QzUW9LUXM3QmVvVXMxOFE5VmpvRkMyOWJHUU5sWEhSMjk1akVN?=
 =?utf-8?B?SHVDR0JiVmFxYjJrNi9UdU5nODE5NGNObmFZZzVYVUxoUjB2ZnF2bDEvNFNk?=
 =?utf-8?B?TGd2d2ZyN2lCd0d4U3pqWVVKK254UGtoZ0M1V0dKL2p5ME9rVi9sUFZNU1Qz?=
 =?utf-8?B?MkFtK0VsT0tISzBWK2lyRFhFVmxQOWRBdjh1SmpKSElGeUtaYzIvajFrVE5r?=
 =?utf-8?B?aDI1UmorbUxBZ3o0VnUrK1NybjU1UzVCZ2ZXcENoMGNoNWRTd0ltSXlSR2RL?=
 =?utf-8?B?UXByd0NUMUZnZkdxLzB2Q3o5ZTRJTDRjWlhzdUZlYThBK25Ed0thSjZlL2Mw?=
 =?utf-8?B?eG5PenRNZG9sNnVTMG03NjJwVDBxNThBRlpkQ2gySldCbEJxMUVnWVBMTnVW?=
 =?utf-8?B?TmRlMnlleWRtRWliZ2REU2phMWpVUjU5TWNlR3FJeCtReTJJMWo5NWU2ZDdK?=
 =?utf-8?B?QVRMZHJFSVFFcHBweHhvL0p4NURuSDk5NS8xc0VZV3hCZk43YW5oVUt6RHVB?=
 =?utf-8?B?Y2N6cUdoMGxMd3prcUMvQlFPOTZNYjhMUS9TclE3M01DUmJ5S0YyekxvRVBn?=
 =?utf-8?B?UHdZUFNUeFQwNjcwV3g4cTFFNTRnaCtCd0FjNEpabjRkUnlmUVU3NEgvL3NB?=
 =?utf-8?B?WVVJUk5lalc5d1h2RVozL2tOZms2MXNhR1QzenQxRUtGbWRJRG9UNGQrY0VK?=
 =?utf-8?B?Q1RUMkVIbFcvN3V0L3VUMDEvUzU3QnpTZ0ZUVDhhVitUSDVtRytFSHFxZTM2?=
 =?utf-8?B?bGNsQlZkcG1GNi9XNUN3SW55OHk0L2R6TDFDTEFTSEVEVkVZSWZ1cUExdnp0?=
 =?utf-8?B?Yy9zT3B5eXljWEN4aExDdjZLdXVINWdUWENUaWI1K3Rxd1AyL2MwdDErSE1K?=
 =?utf-8?B?R1EzdEZoa08ydmhBQ3gwN25yWklVQ3RnRmVHV1A0VkwyL1dXd2hDNXE1SUJy?=
 =?utf-8?B?ck1Ycm1aV242ckJMQitnSE9mejhrODZvbk0zR3BVUEtBWno0SXNCNW1uUk1z?=
 =?utf-8?B?TU1SYmVVWGRyWlRVMmd1L2h4aWw1cEUvNG93eHVDbnc1d3pYaGl2ZTltYkFu?=
 =?utf-8?B?Q0V0VXFHbVlyVitUOU1tVEFrSTd5TkhqNjNlanlPRWRBdDVhVXY2TFZ2c2ZS?=
 =?utf-8?B?VWZUbCtNeTdxc0JkZHlyQUZCbyt5S2NVV0dGWC9RZ29lMlNqQkYzK201aHht?=
 =?utf-8?B?cEhHbFlRbjYrQXJQRllVeHZkQTB6M2xwcm9DSzZXbXFGcGRqQVM4eWxMMlhI?=
 =?utf-8?B?akRSOXVoUnkvMEcvNDRaQTNoVk5KY3JUSENmSGFrZVpEaHdtVVc0OFFES0Fh?=
 =?utf-8?B?VC9pWU1CbUhDbFgwaUFBZmV1dTlUeGpwRFVuTlJWbjR4M2hSb0gwYnNxNzlN?=
 =?utf-8?B?bFkzbUUvZlMzNUlwejRjSytTdzM0Uk95U2c0bGZaYkI4NjNwQnN2akRSaHJM?=
 =?utf-8?B?K3NWMEtBaEkvRGViOXl6cXlwNFVLVktxT0lCMHNZOFNCbGFWZ0F5dHh6QlQr?=
 =?utf-8?B?ak5UQmUwclNYSXd2WEpocUFhZXpBLzVVT2N2UHhMdTVvamU1U3YrUVdyaDl3?=
 =?utf-8?B?M1IwN3BKUnBCblgwK0hqamxVc2NZRmdTaTdDZjB3NHhMNE04NTcvZnlXWVJs?=
 =?utf-8?B?WldxeUVGMFlhN0N5ZWVoTUxSVjR5OC82Y04vUmlkeFpzbU93RlpyaS9GRzhO?=
 =?utf-8?B?azlydEU5QytIL05tSlprTlByazd6c05GMVhmSXpJM3dBOGdOcURmSThna1Nr?=
 =?utf-8?B?WjluOCtFM2oreVhrcit5NTk3d2dKMUxJL0R3RHVZVDNQNlRtQkhiWWl5amx1?=
 =?utf-8?B?MEx1MG1sd2hmWWhZVlhWWnBxdVh4OUhYUzhvUFp2aVI2Q2JPQ25UZXF4SUtt?=
 =?utf-8?B?Q08yUWZsQzQ4ZUY1WWl6bnRLV3ZPQ0pDZTM0dz09?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7da308d-de2d-4c00-871e-08da01d4878b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 13:55:54.8077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WHG3qXy42e+EfVqJ+MkchKQiBv7huzhCYMM123UX99cClhAjsp/5XONAfZpwVHvCdtNjTgcRBieogZiVPzLJSr1o9fQUN+884OGtxesh9Ws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4885
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

Previous commits introduced AF_XDP zero-copy support, in which
we need register different mem model for xdp_rxq when AF_XDP
zero-copy is enabled or not. And this should be done after xdp_rxq
info is registered, which is not needed for ctrl port, otherwise
there complaints warnings: "Missing register, driver bug".

Fix this by not registering mem model for ctrl port, just like we
don't register xdp_rxq info for ctrl port.

Fixes: 6402528b7a0b ("nfp: xsk: add AF_XDP zero-copy Rx and Tx support")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index d5ff80a62882..67a87fdf7564 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2622,11 +2622,12 @@ nfp_net_rx_ring_alloc(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring)
 				       rx_ring->idx, rx_ring->r_vec->napi.napi_id);
 		if (err < 0)
 			return err;
-	}
 
-	err = xdp_rxq_info_reg_mem_model(&rx_ring->xdp_rxq, mem_type, NULL);
-	if (err)
-		goto err_alloc;
+		err = xdp_rxq_info_reg_mem_model(&rx_ring->xdp_rxq,
+						 mem_type, NULL);
+		if (err)
+			goto err_alloc;
+	}
 
 	rx_ring->cnt = dp->rxd_cnt;
 	rx_ring->size = array_size(rx_ring->cnt, sizeof(*rx_ring->rxds));
-- 
2.20.1

