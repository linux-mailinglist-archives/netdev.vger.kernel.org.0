Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12EA36D831D
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjDEQK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjDEQK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:10:27 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2123.outbound.protection.outlook.com [40.107.237.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8838B3C22
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:10:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVa5nUKjg8h76TED5DR3TpqrUDYvGcZoJDMEuTkeGkI7BqUja43k/2rFgjo2s1RIYlKKLEBscHGkGTSSMg7KQ9G3hCG0mTq6KVwxbu802rZWBoBXWi9htS2p/lUwlA46xIdv8G4p4KOy+Q5AToiI3RoyZZG/HCR4ipfhK6XCmKhZkJ/OtUnxAlzW3JQLqxtmQ54J6M1tiqDIE3k4zam5VRwMz78wpy/17EIzP+YgSMwfiDUllKWB8WXyQioYtV0+DSLDlQ9kYbDYvRAhd53YtQtErxYVGsJkYnxDoXFZmN6rUoB5ZOkAm2f412IGZkR118W8lPIaVLIRh8iN9pJ7CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1o41QsWx/7J8+8TiYCgoKE2CP3n/8V8tTBE+MzOsBwI=;
 b=bOFnRkcoKr8I6PRb9uEAyBgy3Ufwrrdbn3Djzer1HchAbn3i3RfG3zA+F47oym1Rsg+aa/TuJvW0xg4z2gDHo2bMSVbn76AC535NdYZvEdM8NTobtYeZvVFLLeFPCkz0D5GWCQyf3eocPHyn91fQKspOYh+cbg4sjjgSU6NUOjgpfg67xoe4YuU2OmwW7vBbDSjpQ1Zv7Lhv7xrRwdkLrwqwsJkmH7nAGcAONGNe5c0f6OdjSrJSdGiWaB3hcU8AJghSPoR9qWe66O2D+UotN17F3vl0wGa2XNEPhfK51Hlau5jKxrHsonjsE9udGoGzZvw45lDPCMpTk4VxeRrYTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1o41QsWx/7J8+8TiYCgoKE2CP3n/8V8tTBE+MzOsBwI=;
 b=iRlq75RQgLDdPxkvQRULgH2yql0D2gk0kw8dEgi/I+ILsz2w9eOODvEqzxIlSBBDtz2AmeSjwYhZPbztyulBVpZibk1Pn3+aC5jfqF+U1+bjdG8g0fW6m4k8aA07lpg3U8Dy4CUMj96x3n/kv0uP8t44cv6v34i66xkaUwQzYv8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5741.namprd13.prod.outlook.com (2603:10b6:806:211::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 16:10:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 16:10:13 +0000
Date:   Wed, 5 Apr 2023 18:10:07 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 1/2] net: ethernet: mtk_eth_soc: add code for
 offloading flows from wlan devices
Message-ID: <ZC2dX/XfAy3iKDSW@corigine.com>
References: <20230405151026.23583-1-nbd@nbd.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405151026.23583-1-nbd@nbd.name>
X-ClientProxiedBy: AM3PR05CA0086.eurprd05.prod.outlook.com
 (2603:10a6:207:1::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5741:EE_
X-MS-Office365-Filtering-Correlation-Id: 6ddf49b7-d545-46ee-a2d4-08db35f03cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G4+XS3cXDgrSpTKYukfSWquIDJnpLNgk5DT13U6xzAehKlqD2vHJ+77BqFuvDKNRVI3Bxxwj0TvzNsJY1Z7McmpDNUBIYs9Qk/Z6pILy2DOJ2Ay8T2ukHHoK6pxgatCIxfVRkovpaBPJyxPm50aMTJYLBHLryX6VJKErXo4pHwqqkT6tjQz9ZqrMMOW6mslH1TUVX/GOrZVbubAr8GilM2WFFVffLq441deMgkGOMafLBj9n8HvsEn1d9Fr+735gewbRE43oLitMvU7O3NbTXASjWxNAdCrQVUWEzEuYUTot5b84+D+zLKG/fj/yc3hXINHK729HGw5X42voYxoQ/YBbqQayq3br7oRgjNIQwZgNmw3/DOiMw/4/6rGXsToZLDPCB1L+K5+gXdxPZq9mGQ/hZNFgtykv3Lg1xNpDTd8zVvYrJJvFmspSDnie+6f8i5TAGsB1PDE4SxjYX1lfqvTZGW5Sd1lZJNPKVSp/5znjBv4llFtdpgrEGM1zFBqAyFCgZoc01BY9iqDLvrp+WcfKR/CKmGFsae+RnLGnlpXb9oNVuQkvRFdgqnHeqcuw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(366004)(39840400004)(136003)(451199021)(86362001)(36756003)(2906002)(2616005)(6486002)(83380400001)(6506007)(6666004)(6512007)(186003)(66946007)(66476007)(66556008)(8676002)(4326008)(478600001)(38100700002)(41300700001)(316002)(44832011)(6916009)(5660300002)(4744005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yREz9Ad14zqJeG2FCvwc7ZS1XravSQG0D7nLurXtsFv2sOUxNS1jeKVqG9PK?=
 =?us-ascii?Q?ZNQ7jcAhcTMqShza/gzXKaTJ/BhUQ2Gd1m/zvtwa8s908WqyxjXXp+hMJfcg?=
 =?us-ascii?Q?z20QMCByiIkgkX/6iSRA4wETuMXoz+TTj63ynJIj7/eQuHf7zROLD2gxQ7qC?=
 =?us-ascii?Q?MwwkOT36+6fj1XwgTha4OFK4Vh57tcWoWy7U8IwkxSBzwlXJb/QqE/hqCMxB?=
 =?us-ascii?Q?XcAq7qnacu+6gmM5VNcF8UKnTgF3XsiMBuvknX6uvYxh5Wie4kKljY7pISpG?=
 =?us-ascii?Q?SIZp3897PU38n5zr8azpiX3XDTjhKHPQeFGEL3V4spYb7DAjb7QvuopssyMg?=
 =?us-ascii?Q?nSeqBZKXmkW9y5lyCTEXzVzg8G61owcJ0G4fWCi1JKJFjrHTy4wcU+zIDsq+?=
 =?us-ascii?Q?RgpzB1z9NOObrdld6fvB+m45W+JP++StVM6Q/P3EERI4239Fp8VBaVjW06OL?=
 =?us-ascii?Q?Yo9IirXFmVU5iFmhznbu2MJT581MVjx4oD/3gDgpjbRk6Bdn6dVbaUndkInh?=
 =?us-ascii?Q?Cxr2umwlcB3JEn6TxygxD5+kPVcM8FLirdCK/rZmJB3Iv2/WsIloTVA0qmJC?=
 =?us-ascii?Q?pb8KtKiHjX2imKNUOuo94SSiccYm5FVFkw+PyQeMB6adwZzZR8veLDmp4VnL?=
 =?us-ascii?Q?h9rizJJ1eruMAtPdLCCrNRBdciGu6mCSLsuxvdB8klCqVt9qnMFN4IX/hogB?=
 =?us-ascii?Q?+mzZDG3BQ8p26zS4TKjMgv8XWZ3jUbJ9pkr83n0xXhqCEve8FG/2jaJMaxUO?=
 =?us-ascii?Q?B3G+i/C3rqJ9ll0Wj4NannIUh/nXc5qtCENjGrZwOvQkCTopLg4fAeJDiLhU?=
 =?us-ascii?Q?pBnvZlTf5lwB/6pLbR2KdVcnSNJdT/JvLe7ygt3hXXsX64Pj0/UQsSLtpfQ1?=
 =?us-ascii?Q?g+rRSnQOKF9HMTO8sj3EwwEcjff+KMyc4Mosx60P8oM8DYCnFHWxRSr1uq+/?=
 =?us-ascii?Q?d+4Q4UP45x3EolzdopVH/ezrwuGoDNr27JymbvS8S/ewbavAlEKTrdnEUwd8?=
 =?us-ascii?Q?VG6hTKa86mPssyDdFVWapz8ffQLP/lRZYL65yDtNZz6TM2gjo2MMiS82XQdH?=
 =?us-ascii?Q?9r8dSWQc/SvspKlnletP7K+jmxbQuQnRBr8nQqGT0j+i+ZTGsD87lImehm5K?=
 =?us-ascii?Q?Cku+Ozha7/wgNPhE6wC5p9Jm1h+cAEmCbOB3jjg7/omDD4/ZFWHwKd7L26pO?=
 =?us-ascii?Q?KVVn1QtCqYtmyMBPNCssU4uE5mYNBlXxRF/SV+JTeassua7Ozr6YfvtOqDhC?=
 =?us-ascii?Q?a1kXCSk7zgOzeBk+kNoIV1q8q5ttGMaIsc8DjACeoe9F1s2wp/vmwL0eAQ1O?=
 =?us-ascii?Q?1rNDovAg3Q9yifhgVjDiQ6pK1bBrJ8WHcQnP5oRb7z17vrnLhZcin8CUZKMB?=
 =?us-ascii?Q?W0PATSGJwHqChzyZxwRM3dUJSH4KVG/oBFTIMRdw87wqnXfas0BU5iwtMlwH?=
 =?us-ascii?Q?zYKkR+yeXfx/v22Wr9XvNh4r3B4mFajm1lELL2J2bZ7sD/w+Vj1S4OX8IMfd?=
 =?us-ascii?Q?AKR46AY7c76AMhylVp1jJag4ny7HFeSVtPkY4m9TmqlSZMFanIM/JBpkp76B?=
 =?us-ascii?Q?CBkkCe3tNr8acE/fsD6NepdPFg/O2j2AwUjPwCIHs0LpleJp0rScD8nO4lBq?=
 =?us-ascii?Q?7TAK5eirZSq8DcG7ov0xRcCFhwzZoA3ceP5meKwOoYWKw4GbAaWj8th53ivH?=
 =?us-ascii?Q?cBDSyQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ddf49b7-d545-46ee-a2d4-08db35f03cf5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 16:10:13.6068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vOwGYr3Kjtgmh7qkjSmAPwTGAIew4F3EibpNqYVc+dbQxQGHS3VzkSU3lTlgHnfi5oyrCLlsZumDfmCi06/Z5cfcROx+1EePuFVMArLpUeI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5741
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 05:10:25PM +0200, Felix Fietkau wrote:
> WED version 2 (on MT7986 and later) can offload flows originating from
> wireless devices.
> In order to make that work, ndo_setup_tc needs to be implemented on the
> netdevs. This adds the required code to offload flows coming in from WED,
> while keeping track of the incoming wed index used for selecting the
> correct PPE device.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

