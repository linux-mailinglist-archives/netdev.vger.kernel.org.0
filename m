Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD0A62E010
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbiKQPiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbiKQPiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:38:07 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2094.outbound.protection.outlook.com [40.107.102.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A36F59167
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:38:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U4r87FYv4wjSL2NRvgpV4pcvBwYbCG+ZnhQLie8Z3irOpJdGu3MRwQ44T/t9r6yV+T4rqX8jLK0Sycx7LnFpiHsXSvGw5LufEOUecP3nifZTRYqSwkfhfyKFthnWtRS7OagNmjUeLR1EcT1L54gVdTVxqD+t8EQZUHHq6jLakWRYPQM0PmpKB5e3GNLuKE5OQAokxFWXb1+w6L5+rz6+zMZCNWHKs1NThLl7xHK+ifhXaiL/Rh++fuSnAe9/CrO3qWWRkke0oXxnKVmfa3OaYft5yoKm//B7lGHb4+DpZCJu+XOvDgngCyTGxCzUgARzVX5BSzNJ4/dpAhKhkHPPtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+NDvIkv2ZrZjBfaMRDQPv61ujUAAMfy2wSKhkC99KM=;
 b=ULuXiwEi71a8L/SbNu+WRUPfK2KXpuQbb9rWWLk+8piZABR6ePpbmwkeN1q21D7iLb+i7kn22r2U9TQpdZ+2DdxYDcuH1Fp+6Zu17IIUwUHNOm9LoB6Pc1ZZURGVmzf2WQ0DcfTs4R7LzxMlEt0QlncnYAvPyNxqs4C20MR3uSleVsa8uww6jvJV7H4voiqcBiboqVxpud6d9PxCy6rD6C/v6aje1LqumvM6Kacppa5ITurtwyIHWkUBCbxmTgIC6xmm0CsrEPvJKtkZVwjjod3RVeMMnpjpsdo5OjNnSgMk4zfHfYo5/OKvnG8fNClhPvKDYd9ktuV9u11TkVDIMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+NDvIkv2ZrZjBfaMRDQPv61ujUAAMfy2wSKhkC99KM=;
 b=N0AzWqCPkjVrFj2ACYE0+zaB8Zbxsjq6YGDv3DwKfgJy1qvybSux/4woKgB+WHeEeXSTKxZTnttFC9vPAoqfq0dB/vWyQp4YWVN9ubUwDB2Pa3d2uxJbRvVB0NZvek/4zrLemqC1Rf3J17racqxwG2rWjl3QTrJUa91WvRq/oio=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5242.namprd13.prod.outlook.com (2603:10b6:208:345::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 15:38:05 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5813.018; Thu, 17 Nov 2022
 15:38:04 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Diana Wang <na.wang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net 1/2] nfp: fill splittable of devlink_port_attrs correctly
Date:   Thu, 17 Nov 2022 16:37:43 +0100
Message-Id: <20221117153744.688595-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221117153744.688595-1-simon.horman@corigine.com>
References: <20221117153744.688595-1-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR05CA0019.eurprd05.prod.outlook.com (2603:10a6:205::32)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5242:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bbecc50-6741-475d-6b46-08dac8b1b668
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M4NY9HeR3MyjCv6tYPNqSSTRoi0VqhsetRJ9aGb9T5xu2Ctky3eT3cOiSrlDcKtKMvEFQqAqVj1b/fLwWtjWs4V7FBkFGJOfDPEOoN3Rz6rnE4h7Y1fFJ6PYEXAKBpDWP1JM0nxMBL29HxEuzRbYEQAEPkdX2n5Fu/E/CufPzMH5vG2T3aJZo9d4Jg20ehbKRSFFer5c7dXHJ7+Bm1X4NvrU+Ksu7gvJ7Q+hsmLgbV4uYk9IZ/B9OSUG8mXMl06G6ZTBspQtsjKnq+nOPQk9PVimRvfqqMR808Vp8nV1rsk9kFoPowgE1ONSlXwXJA7fTjV9IcIMTjrCWcKC6IKrQxQwfh+AtEuSG/7WOsNIkSsX+SNtZzLCHe1bwAZjP/ZndLK9dPmZrI2TO+7r9t5NL3GmpBPkc4FkfMY61EkRw1CCe1dLmUNjx1LPogVa7yFQluApawLS69o/lVwgI+9HG7cgPAReZOxWEyQiJNU1WDo9ms+eO0KiQT6GylIADctMMHlwylTN+rzLcwR0lEpNoR3mobHEkS1V5yw7ZcD1TDtARp5btXmGjG5tfg+dzV6RxwGSjvPAowjqf6xiJGCH2V80K86b5MyMKwSmomZiv5436+uoiCj7wIUYsDjPTJe/Eb1JRgPDizU6glGInINiDVnh+lMC23s8hKV7J4+iDJ9Ycm7n3z+y1QWASygUqi5L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(39840400004)(366004)(396003)(451199015)(4326008)(83380400001)(66476007)(86362001)(8676002)(66946007)(66556008)(5660300002)(44832011)(8936002)(41300700001)(38100700002)(2616005)(6506007)(6512007)(6486002)(110136005)(186003)(36756003)(52116002)(478600001)(6666004)(316002)(1076003)(107886003)(66574015)(54906003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUlhUEpTVkw1cDZjR0RrVCsrVVRDSXIxeDliemtsT1FCcGhpdVZTdjRraWJ1?=
 =?utf-8?B?cS8wWVp2Ymx1ZUZPclJVb3pLOCsvQUEwTFE4MnBDcnBDZExHS2g0UHNLWHcr?=
 =?utf-8?B?WFFXUFRtZjJCVk4xMnJRMmJBaDV4YXRqaXZsclYwUlA1dzhXNXR3bHBYcDNM?=
 =?utf-8?B?MzNIaysrcllUa2d2VTI3b1FEZnJKcXQxUEc5WXRINm9UeGtnTnVPRXhoeWxs?=
 =?utf-8?B?QUovaHJneFNCbEVRR2k4ZnB1QSt6OGFmYUY2OGpIeVpNanorSmtZcmhNcEhY?=
 =?utf-8?B?bEpSaEFYblRJT3FTamV1WWlUV3U4QW8yVFJJQzJOZzJhMHVHYW9mcUNPNE9a?=
 =?utf-8?B?NmgwUE9zWlU5VUJud0ZiSG1EQWRqODY1T1NZeWxZMnF5Z1RRT1lWK0xzUllj?=
 =?utf-8?B?Z3JPbWVQeFBjdWpQUDlsU3htMzlxTFZmd3U3Y2RveHJ5SWkvRXlFVkFNSklK?=
 =?utf-8?B?blVXV3EwQmFCdXp0TGRiUDNCR24yN3F6QmhPaFFuL1dzOVhQbHY4T0F0N1ZR?=
 =?utf-8?B?bE11T2pvYkRhVlZnSTZqQ3paY1Q1bHBWY01Mdjh2M2I5NlFoVHBOSnV6S3R6?=
 =?utf-8?B?ZDJZUjNGNk16YTVmaldsbTdRWHoxbFBFK25LS2ZjWnN2L2JyQzYvazN2Y24x?=
 =?utf-8?B?MElScWFLMklsL3h6YlRhYUhzMERHbWIvWjhMMGZoaWE2MGlYK3Q5STRPWlpo?=
 =?utf-8?B?SzlxT3dxKzMxU0hFOElDaERlNzFxVWxGUk53clZCUGRrNHA1WVZvY1dqQWdC?=
 =?utf-8?B?Sm9ISTh3aFdkYXdTcmloTmJRbW5ac1VMNGJIZ2VBcjhuanRUMlVWcTRnNXAx?=
 =?utf-8?B?MVN5QWpXbnJ6eGIxNTk2RjBmUC9qSXo2eE03aThsdjRUU1dzSHd1Z1p4Rnhj?=
 =?utf-8?B?M0lieER6OWIrU1Z4SjJCajBjZmpGak9henlkUHpndCtQcUVMTWwrVlVvdExX?=
 =?utf-8?B?OTIyUU1kNFZmNkxuMnZyNk1TRU1uMmRDWlF1MS8vRDVYY2VycE9xbXgzdWg4?=
 =?utf-8?B?ZWZhc3M3emdlcWlXU3RGT1lMeTVoeHNNWU1zbHlkTVNKaFQ5REwydGMwdGN6?=
 =?utf-8?B?MEFyd2M3Q2NuYmQ1MldWd2tIZCtSVGlUaXN0YXVSeGtkNENjbVdjcy9Gc1BX?=
 =?utf-8?B?cmdjZU83T3lFWE1vUTFBdXRxa0ZFOXlJOGFhU0JiamFHTTE5eUQ0aVloMmZo?=
 =?utf-8?B?UzRtK1Z1Wjg5VHl1dHc4S0E4SmJYZ2FXeGtOcHZJUEhMTU1nVkgwelN2dVd2?=
 =?utf-8?B?RDdaaWtkdFdocjEwbmpIQThNNU5QR0hHRjhhQTlpUTFaR1IySnpYWGRDSXNt?=
 =?utf-8?B?S1h4M0lYeUJLMjVMWXhPcm1jcHRkaFo4cmxiZ3M1aXU4MnErTnJzcU5kcHdl?=
 =?utf-8?B?eFNBZU1vWTdVSllXYTNCUDA0T3I1dFlUMUczWlVsWmlTUEIrdytYMkJ0WEF5?=
 =?utf-8?B?RlVHV1lxUnFodkVrOGd0TWZzSVZmYnU5SVhOVXRzUlR3MUVUMWZWdFhzS3pq?=
 =?utf-8?B?MXY2cVFJTmtRb3FuN2pIei9TdGhCaTNjMFRnc2ZIT2hKbHdTb1JIL3c1dXlu?=
 =?utf-8?B?MXdVMVU0QWJ3Uy83ZlpVNm9iMmpQWHV3RzJqaUVnM2dVek9oY3M4ZmdxTTV1?=
 =?utf-8?B?UElSM3Jzd09kaTBYVHRLcGtEbFQyRU16RGdwU0hnU1VrZk1QT3NQbktpV0xx?=
 =?utf-8?B?NDljenR1VXU3dkhuR1hhOTZ1RFdRbm95T25Vd1pMcXBDRkx5MVhReHgvbExZ?=
 =?utf-8?B?bXZoL3MyTkI3eUoyNGYwbHlnd2FCazhlNHRDMCtXQ2tQclFJeGhIcGtTMU4x?=
 =?utf-8?B?dGNKYm5LVWt1MDVRQm5ybjFvSWRqRUJ0T3ozcC9GWStZbjNGblpNTE9MZHpo?=
 =?utf-8?B?ZFVHaHVPSzlzY0hoQVdQWlQ3VGYrNC9WTTcwVDBhSFpNQkhWaSt2NUt0ZFdP?=
 =?utf-8?B?dXFBRzhkZlVHLzlHQ1JBQ0tucHRUNkxuLzB2dG83L2pYZnRwODVybzBwNWlH?=
 =?utf-8?B?WkpxOUtIU1dadzFzOFFiVmF1RHFEaXBtZXBLRXQ2WXR0ejNpTFlPZVByZVho?=
 =?utf-8?B?MXpBUG9oSHNoYkRrT2ptRXZhaTdTOTA1T0NlWGlyK1luTzVQOUVwNFJQU2VF?=
 =?utf-8?B?dUw3KzIrNFZpUWJwM0d4QWEvYVNEZkZJYlJmN3BUS2VIVXpPeTZodlp3Z1BL?=
 =?utf-8?B?d2IrUGcvNzVoVDRFZDY3RUVCNm0yMStRTkwzajRkWEdRZkg5bldsbkREdSs1?=
 =?utf-8?B?ekdyaGNjZlk1Nm1IWi9IcTlOZGFBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bbecc50-6741-475d-6b46-08dac8b1b668
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 15:38:02.3596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JEa44CKawNwztO6RX02EomjMoWDEktl8S4167c1cv4SM/eoEayO+YGSmvYwBHQCyBm3Q1HOqv0ydoTQ8K/KcKuHdr1oUWIAhvg62l4crhvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5242
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Diana Wang <na.wang@corigine.com>

The error is reflected in that it shows wrong splittable status of
port when executing "devlink port show".
The reason which leads the error is that the assigned operation of
splittable is just a simple negation operation of split and it does
not consider port lanes quantity. A splittable port should have
several lanes that can be split(lanes quantity > 1).
If without the judgement, it will show wrong message for some
firmware, such as 2x25G, 2x10G.

Fixes: a0f49b548652 ("devlink: Add a new devlink port split ability attribute and pass to netlink")
Signed-off-by: Diana Wang <na.wang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
index 405786c00334..cb08d7bf9524 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_devlink.c
@@ -341,7 +341,7 @@ int nfp_devlink_port_register(struct nfp_app *app, struct nfp_port *port)
 		return ret;
 
 	attrs.split = eth_port.is_split;
-	attrs.splittable = !attrs.split;
+	attrs.splittable = eth_port.port_lanes > 1 && !attrs.split;
 	attrs.lanes = eth_port.port_lanes;
 	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
 	attrs.phys.port_number = eth_port.label_port;
-- 
2.30.2

