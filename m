Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C38D6ED433
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 20:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbjDXSPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 14:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbjDXSPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 14:15:49 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2106.outbound.protection.outlook.com [40.107.243.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2724C35;
        Mon, 24 Apr 2023 11:15:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnQAJQDpgAc0SF0QZ3sH/bp6ZmEfSc04FDQE8Oetsci9Qj5hENEEjo//ZjHYWT8biZxhNcrxhmkktUmk3W/G+QeRZO7Jt/xuUDS01dXrv4C4atazpHNdqVMpeARyJIKfoRpN3eLeRsqHJeOE6Dobf5GzpVdc2MEDGiOfaVZ4foPKC5L42UQ0LMuCCoRxQBLMKQA+6X60wFeTm6EATcsRJ/x5yTgwGCHBOgmMTUjkN7ZnsT7iemrW76QubyiCecBpSTJAne/4ScmV9Nmr1q8jA9zeo6aolsWjllNn+eqdqZ/+1bOi60fI4Jyd6eaJ7RE8ri3W71jjM2bUsM2b4s3nDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HT6pfiFB+DGGob8o8h1khAjBoY6GLZoCQ/SroPHsLtA=;
 b=iD0m4kOi+MHFJ5me01U5qbDhSCVCsgb5BRNGu3mdQR/ZED8LmdJYHDTpd1NNPct/gR5IErysZn3ZqV+59Zl/Bg7Bx105lbQ8gRZn8aPm5rl9LgpOQPhVBzv6VrDNBVBxI56fHhM3VpUN8pwtgRIWA/b3hs/88cba94gB9Fawhv4RgsjdyoVLC4OwUVuM+buBuvfKpMY6kOj21KmcSZ5NqVM6QF6sTa08s5P2PGq07zwJ1SXv9PZbShgn3bXG36D1hdqd7cOwfd3DZLxT76M342J+JYl7to06Pg3FiOWT85uEPJZZravzOVWOGv5S2eiaALgYDoi/S8CFSPksiZY9Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HT6pfiFB+DGGob8o8h1khAjBoY6GLZoCQ/SroPHsLtA=;
 b=NzMHJpzKR5URtYJc+gv3QF6M5oFFDra173AM9oBgax60wTZhdbW0AyyHYp28JeQdwskVUg8kNnKSW3+1g2BiD2ILyK6YtJveGls8rnzwYjYlWYbwYWftvOGmAcqkWb0EZJP1qC0LnnUGy6fyw8ePn2sSQP1pmrv+/yyTNHUsJGo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4984.namprd13.prod.outlook.com (2603:10b6:303:f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 18:14:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 18:14:57 +0000
Date:   Mon, 24 Apr 2023 20:14:50 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Aloka Dixit <quic_alokad@quicinc.com>,
        Muna Sinada <quic_msinada@quicinc.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] wifi: mac80211: Fix puncturing bitmap handling in
 __ieee80211_csa_finalize()
Message-ID: <ZEbHGv/EwlaBUpGN@corigine.com>
References: <e84a3f80fe536787f7a2c7180507efc36cd14f95.1682358088.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e84a3f80fe536787f7a2c7180507efc36cd14f95.1682358088.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AS4P190CA0028.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d0::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4984:EE_
X-MS-Office365-Filtering-Correlation-Id: 03595e77-1d18-4a25-27ad-08db44efcf90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 15HRRzuYl//W2OL/iuBPUqw4mns+V4R8VjLICQkY7zOYo13SHWIDdrPCxNn9CGM+0ZGNk15U/JqwWfWsmZnnny7zPQSDugiX4ZuI8UuEo5mBOvG7F+vSZnechArPRV2PamrF6nc1PRulQyo4AngxiphxXt1YyEE4fYavfEVQD03DHvvWrClzYeCZrXWEzxdHYjEkLH5Nxl32OHC2cLyA2Ox9h6WfQOx1Ks7xe8BcA4s5yV1O779dwgj/nZFQ4ZV49sa4037PKhiK1D26m4pFizH6odivd3l8vF5I4rALoPWGZvUDr9dM7MZxEwYVPZRywu/QxrFZAaqIZCQfH0GAbkvdXThvADRAcT0UXAeVDNHwTIJJJ2PO8jSVZB3DOAg4qo716JTM/iJX9+lgS1CHG9sQW64T57TYRq4E1pbkqIjN4B76pTVAu6bcbrG+7xv62niMRdSBIynsDLX1WbZSxTOSfN15R6csVyiM4UHCyC2CCRILIekVjUHorwtN8Q8q3nzLR04oKWB52w4vqJeCncFjbi6S0TysxQVEF3NPlfNnIedOpsZKMpA4RF88lvzjpjXaMRzh393ykEMgg2Cm2e85XMU2QZgICUNkc2F+o4E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(396003)(376002)(39840400004)(451199021)(38100700002)(6506007)(6512007)(2616005)(186003)(83380400001)(8936002)(44832011)(2906002)(4744005)(8676002)(7416002)(5660300002)(36756003)(478600001)(54906003)(6486002)(6666004)(316002)(4326008)(6916009)(41300700001)(66556008)(66946007)(86362001)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hEj2eGqX1ktwmhQzpSWf4uC3ucgQACq/5sNhwrlC+tzbbep2HuDfHOEusb4w?=
 =?us-ascii?Q?yMLC1cdChrhoiCZSar/ghR98ZY0A/9TJiklLg+9vm3F6wE2cfEhE8s7Irle0?=
 =?us-ascii?Q?bup3E1K7c9utXWDpSTEzGcBvmARwAvWTNB2aBBVb7Y2SOoHo/BWUC8ksj6P2?=
 =?us-ascii?Q?ZBHh6j/u+Cb0X/5/pL9bGY4hkr1vD59Sp7T1wAH6qNczzVrm3AqdLPTVxi9G?=
 =?us-ascii?Q?3IZaeiqxRAsPJlt67fTJlQ4ZM9KDlssdMD3xnr3XSIW+ldqhIEC2nUaAly2z?=
 =?us-ascii?Q?pjOg7kks8XcwBejSvd+GfN2lLZwZQa16IHGIizvJuzd66mZEYavTkzNIRxdQ?=
 =?us-ascii?Q?dIzIZlRTJcibwbgDQ+Yv5S3Rvqm/6PRTTqZgOKDmKe7uqf7hgbqopjPdp3Zs?=
 =?us-ascii?Q?XQdSE8qIUslrSssM0qLaJs8sLALvWPBs2bgXQITKUhM248cisfTvI8cDFmoF?=
 =?us-ascii?Q?fhMZ7ZOe9uNb8l4Yb17kaj+AfKeNwYz2mreNMu75ZcuXKp4W5Uqd+9ejTip2?=
 =?us-ascii?Q?E5P//Xy/ks+uwHQcjah+8Y2NabhbTHtGcT339Qn/zyHG+r47AYg2VsmR2+5+?=
 =?us-ascii?Q?uPGT5zTMx0vKOcHyO3MXU7lYxlj4p9kK6EBxAC84D2Kv74MWhz4nTpMkQBF6?=
 =?us-ascii?Q?FqucUa+QQSnQZhNH7jG8XfEicGlHytPX+wLObhomqU5JzZRO6YNZt0w7Bcxv?=
 =?us-ascii?Q?BZzd9n1M5cNd0K7JuYZ/klVOgFkJRjoz6Vjtm4oG3928WMgV/MAAvnku/BUJ?=
 =?us-ascii?Q?8v8OcvX/F78kVkFzj9KOy8WHk+uFq57Mmgr33dBrt/JmbCP7+RubffWDngtt?=
 =?us-ascii?Q?QKDQFxme0XPaVtKKZetidA0w5Rkwl+5rz/hxfezrbfjxCHj7/Lu4ycNoz5aw?=
 =?us-ascii?Q?cgY89bKUiIZanC1jK+CDyL8UFc7w1LXhvXA9qM0Nfgunxg7H8eWQtgCLr7Rl?=
 =?us-ascii?Q?PAifdknu7N4iN52TEOnrgjiJPalZZuCcoLtgpvVlWjmEgErzHmodB1moJ5/4?=
 =?us-ascii?Q?hZ0ivkYEuYcEK3obZtJqRmXJexYnyRXVj8dx7dWBTERS9H1E0TnZ6md4l3c2?=
 =?us-ascii?Q?GiT6NAWJ0DkCmS1ojpv/AqxmWkVqSxLpCpY1HdMdJW9LAUtx7Vsy8SgMi5px?=
 =?us-ascii?Q?P6QIGIuSsVm0Z5bSMeNox/2hlbqK5hGfHbWTiIgS8bN9N2TYlgqwntp2IL+k?=
 =?us-ascii?Q?G3OwiWDysZexm7N2XJGx6aKyvTrbWnOPsYKCCm8V9hSPRjHQUsJ8XZ1PyyEr?=
 =?us-ascii?Q?zWYIM6n8ry7pRWOdFe2ivaCCHcvNGB2YWMIAB3eCfvAgIo0T7r8v96rkwWoi?=
 =?us-ascii?Q?ub5/PzwIu6a5WVQL1ShM52N6Kw7LkA8mNPpXt79YZfw76ajjGSusfvaQsrwH?=
 =?us-ascii?Q?bLhF7b9GvVDjjF4qxwtSbm5133PN4OcTDaN9rDEU/LFDrghSxJeicTEFE5Ge?=
 =?us-ascii?Q?dxrZ15iSGCrxCJEl+B3LKa76N3T8cw+7tf7fJNiZ3gG03ZS6pymewIKtsMUe?=
 =?us-ascii?Q?kWzaNDBCGOdO8DU8emRU+kcdaQx0F+pdIiI3wVfse1DFe2hp590VYHdXeLng?=
 =?us-ascii?Q?dIR01zsF72KF5cjQUTaZZkPScyviImKNYGne0dGEAK+4CyOqplfw5KkXyyJU?=
 =?us-ascii?Q?Rxu1KOXcm5qnSorCLTFD3Ia46Ld8D+zqCaxM0Pow1Heib6PZZkdrxV1I5Ar3?=
 =?us-ascii?Q?+xTIKw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03595e77-1d18-4a25-27ad-08db44efcf90
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 18:14:57.7672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZx5ELsZ9qohbaJQ4DbX/tyrxvdsi30XswH77aMqSJozD+5nwndTSrlzlRqAXc1/gSMrIHT1EkPcFemCcdXHkwrosAY0WzyeEeh0EeW1+Ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4984
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 07:42:04PM +0200, Christophe JAILLET wrote:
> 'changed' can be OR'ed with BSS_CHANGED_EHT_PUNCTURING which is larger than
> an u32.
> So, turn 'changed' into an u64 and update ieee80211_set_after_csa_beacon()
> accordingly.
> 
> In the commit in Fixes, only ieee80211_start_ap() was updated.
> 
> Fixes: 2cc25e4b2a04 ("wifi: mac80211: configure puncturing bitmap")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Compile tested only.
> ---
>  net/mac80211/cfg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Simon Horman <simon.horman@corigine.com>

