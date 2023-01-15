Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9E866B360
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 19:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjAOSDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 13:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbjAOSDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 13:03:37 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2106.outbound.protection.outlook.com [40.107.243.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BEC125AD;
        Sun, 15 Jan 2023 10:03:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mRpG/SAERjKrX62lbJvnNA1eBkJLUyXvIZ8s2AxVcfkIGR5/qrqdbdGPm5z931ct4VC2PRlObZ8DNDmilLtMQiVhQ2hlLDGG0JPoZ1ZYTYsAR37/25KfQcmzYI55uEKVyNMWSG+ALG5wxqnV/s4HCYCVkagznUu2WgDxL9wN5e2s5JdvRRSaM64KyZTbX38p9XBqf9ZbqW3IWZkCih9+jwWgVBsULiYEikRfvkLNPyC7q6Ytu/q9Q/ShVex8hwW04eJKc6LecT/uhRUwLJnlpZkhTiRARgUJLnU0WCVcfGJ1YV1uu1IiQpzb9gVC1JMxZddoMq7OEXP8ECLtUoFIUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y74y1YDeXSM0XxINtZXZyIreZ1dUbf6HB6DrxTNdU+k=;
 b=dL0tgH+KBvM2nc7Mkfw0iDn3bpGwfOQRmq/Hc2kQSfIVtxm2ow/vbeF7c4L84NyrAMZntTpGhJS/hWKqfZnm37HZsa8FBD8sMdSnPRIPcPTa6j++31UjpX0sxfsM1QEd/Bc8xesVpMe8/Kmc7id+jtEZ/w3G8Ux+YFx98YOtgIg9a0OuGe+auYrfumGY1QXUsT8+tcPki61hdUKeuU4gB9LLYh/JOU9O1OS2qRcaECtJbPGCi8L3z0zHa9/xTq44h847CWfGlbWanySkkDDa5dkvhVx2r6dmKFnEPn0snG/joC+78WXBIZb+TLXmClSiDFgKSTQIQpewu/C06HaKkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y74y1YDeXSM0XxINtZXZyIreZ1dUbf6HB6DrxTNdU+k=;
 b=pfSx3Pf2eXOJ52Ad4bCv0F6i+tPUlatThSy3vtv/rNx5JGh6VHz6TTtbtz6pJixAWqti+XnsAE8iuxu7PBqQj6joWIaCEdYwETTr9DfnHUQ0Yfoa58Y04JH7otfv6+WlTJUwAW+PLxSAVtJz5l1knEF2Cd3TWv7iz6LJSUmgzcM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5814.namprd13.prod.outlook.com (2603:10b6:303:172::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Sun, 15 Jan
 2023 18:03:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.5986.019; Sun, 15 Jan 2023
 18:03:13 +0000
Date:   Sun, 15 Jan 2023 19:03:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, nathan@kernel.org,
        ndesaulniers@google.com, vinicius.gomes@intel.com,
        jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] igc: return an error if the mac type is unknown in
 igc_ptp_systim_to_hwtstamp()
Message-ID: <Y8Q/1mFjuYXdJg/A@corigine.com>
References: <20230114140412.3975245-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230114140412.3975245-1-trix@redhat.com>
X-ClientProxiedBy: AM0PR02CA0140.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5814:EE_
X-MS-Office365-Filtering-Correlation-Id: 410b7116-c5ba-4d44-c25b-08daf722c478
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZN1u0T0zdODT7uiX2dcC+CdM+iZ3Q3tKNKY4iS+vkxZ4Ez6/wondG6dkgE2CE37scF73KkIihO9XmFdwUW3pqCSKwnJ79eaUfUaFupXjAfuEz4tUt7PCRDGwTPjEp64FOb2hPx2aLvP24PXIrSBvsoa5t8uoBzu3egGa+vJza3EdJT2l2YHReNMUbPUQklVZVPrYyPUJzHKWn0BlQpZwBr/H6b18LPSSjlsWgBQ51Vu0dYKVHfrTcJ7jUjFzRqK/fH1XK4fk3RcDBX+cXbfDHDceUFBASm66YsOUKAp/NOqKeo3saSrIV8TrFOc6TdeGuqou49HRvit94C6ALRx7ZIUjK/qGr4lBUDyxjSfK5150rH/q2xfjMRokFOGWLIYLNJuRkgVkea2oY4aSZevm97F8CVfnsFjDxTdfOaWrmXv/aZBRRcZ0kpQYoRITbwxNhV+PNTMUzvBuf9pZi/k+tJb03zKvH9xEqj4N1PlSD0elX9y56DHwYgJLYjxLock+dqFi9KnlC5LwpBC3tB/E/V1e1Rx+Tuo5sG7aKJcsJQhrxIpRZAkSkHxcpabc4JLx9aNRk060BpMsFV/fwOyfWVW/QYxWGx1TjhvgLvXNXOQ7AJeLmpzMb5WbDozGm5pEsomXX7l7RzAb+vp7vQQK0EaRO0KFCZXHJ3IhAYR64NgEKV45yO2TngYYU3JpIo9o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(376002)(39830400003)(396003)(451199015)(44832011)(7416002)(8936002)(4744005)(41300700001)(5660300002)(6486002)(6506007)(6666004)(83380400001)(2906002)(66476007)(66556008)(66946007)(8676002)(38100700002)(36756003)(6916009)(4326008)(478600001)(316002)(2616005)(86362001)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4z2V8iUz93hUtjm7PMbt8Lyz1UE+3ij5jON2c/Tr453UkQTDrhqVuYDR82ha?=
 =?us-ascii?Q?e4YCPxMhI3h56whoqGWJW7CLS+fuoEh5MdymJroOS7lr+ugOQWdySzQw9WzT?=
 =?us-ascii?Q?nf1bEtU+/PNvE6oGkoyWQAPXcofJcVUoNblyya/wkAJ+GpLtD5/GgEl5vitV?=
 =?us-ascii?Q?fpp+BFkIzm89hxCg9scwnL3uUCgb+UjAjkQbupf63mrkCG9fOAznDZS8aGQP?=
 =?us-ascii?Q?H8z+KoGW/xItiMfUD6za4ABoYsCww/f5CTMt3VEWsx0ISiCfdx30lAP+Nd3g?=
 =?us-ascii?Q?uq/aI71zXm0gONI2JMarjAe7UvcFqfFjt8ipE0GbMfQvfA1IyGH92lS4KZ1v?=
 =?us-ascii?Q?cf7hgtp+zZgJSjKA7Go5YQWSbCakTHcQfmq/JCzSBEFyd40E9xr9VzK8cBBP?=
 =?us-ascii?Q?Vgu1fiYh/83ClpSfiVaPhj9rp825UkMrsnyW7uxr4gvyw8RFhG2QGsYs1sou?=
 =?us-ascii?Q?zEvMTsL9WB1iMBMCu+pLaXaoEn0FbfpKxM9E0TXt/Bn68ftnpo68A5rZ9ve5?=
 =?us-ascii?Q?LQGaPgM/su6dhEZb2y+4UsqTj0dNnI71s7MFYCApefd/VJuWCk9dDzuwO2Nl?=
 =?us-ascii?Q?5CDmUgqD4aEPtjv0lUvOJ4rtASHEiSZYzbleTWZhU51zCFrMEy0sI5UT+n1x?=
 =?us-ascii?Q?W1mct14PRcIfnr0SEbN2EYAL4ifwkNwa/1GN9R0p+5zwKEh2TkLJnG2LgMB1?=
 =?us-ascii?Q?FS9U/RxvAmFn9J8JvqZD9qyTcs30XwTAd/Q0NIK98Lv2ZBlYSRRn0WFAydrg?=
 =?us-ascii?Q?Rek3oheKOFWzSaKNoT+IUNAuRM9dzptfFlA7p+1yx+B6//fmOIlePbul69sG?=
 =?us-ascii?Q?/PkA5HDK29FzAiZuJkhQCToaa0uwSm3WGrDIPX29v2Q2dn2Ec2rpW3TOlKWw?=
 =?us-ascii?Q?y5ufF1AEPeav0FZiDVv1lFx/K7rPwBKMP0PR0RKmJuHkFo+Y/+ewFbnkJJfq?=
 =?us-ascii?Q?CAFQQ3faI/vljU5CjPvoTDDgrJ8PmWZr4+9YHR3BU3UBa9Gs6dfrQ1Xq6WXq?=
 =?us-ascii?Q?Q/esjHnNz2DjI+uwUYIUZOr7M3x807gMZphkFh8u06KdNt8qZDqJQfoovChY?=
 =?us-ascii?Q?E9ogdU3+UD8Ea2ojj8pzVKLNlVQyN7c4dyRQh+wj72sh26rPptptqdbSLh/r?=
 =?us-ascii?Q?d8Itub5BrmO0vD9CwEutf3hz8gre1/wwL9LKCdk2p8pnO+RwspvVwTCCEXDM?=
 =?us-ascii?Q?t9Zyk0sT3XTwbRTHKy7e6UrRK4se9kifoCSMiuNYWIPP3JKO4FeWCvZVT8FK?=
 =?us-ascii?Q?kSkXIM86CzrGfJq1ByO9PXyF4giqqTyCqzzKSZ3ccPTMerAmn43xlVw6dv+8?=
 =?us-ascii?Q?fnmVgxEDsyV6QT4SY/RNO8Lr390+5gtd3vF0RY+tMBpqJe0yS/BQtmx/HiLt?=
 =?us-ascii?Q?qiTYXsDy1lNWeUqftlx0jPzqTeKpvQ0vcPuohrcaj7TleiPmpR2IG+aMJ2II?=
 =?us-ascii?Q?GqODxu4QUJhmavvddM86bjfemYoKud3Pesu7Rg2g6AWuc3kO6oS4fVqzKkpw?=
 =?us-ascii?Q?jF6liog91niXVXvA4qyipgY382UzbtPS0RSrqgT7cgvrf8YqufNiJTI3D3ae?=
 =?us-ascii?Q?PXdSFPdbddN4sfBUAR7ZG6N0+RO2FASwhfXs4LWJjiPyrwiFrB76wBhe0Qxy?=
 =?us-ascii?Q?aIuubuQIQ73gaHJdMhPcsDrZf/A2wecq1ZYa1id3UeRjAezHGdsY3ddDYUyv?=
 =?us-ascii?Q?wfmwuw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 410b7116-c5ba-4d44-c25b-08daf722c478
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2023 18:03:12.6523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U7nfl/C6FNuvRRzx0iai5Vh1EckGglEJk+V20a/+38J2CTTHaHeoheqguzKjHi3DTX+bMam/9YBsC5MsIhqGU7KOMHBiE103wfzKQKON+A4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5814
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 14, 2023 at 09:04:12AM -0500, Tom Rix wrote:
> clang static analysis reports
> drivers/net/ethernet/intel/igc/igc_ptp.c:673:3: warning: The left operand of
>   '+' is a garbage value [core.UndefinedBinaryOperatorResult]
>    ktime_add_ns(shhwtstamps.hwtstamp, adjust);
>    ^            ~~~~~~~~~~~~~~~~~~~~
> 
> igc_ptp_systim_to_hwtstamp() silently returns without setting the hwtstamp
> if the mac type is unknown.  This should be treated as an error.
> 
> Fixes: 81b055205e8b ("igc: Add support for RX timestamping")
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
