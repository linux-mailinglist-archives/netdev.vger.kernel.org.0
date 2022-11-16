Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E312F62B9F3
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 11:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238976AbiKPKst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 05:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238992AbiKPKsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 05:48:07 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2131.outbound.protection.outlook.com [40.107.92.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C593C49B70;
        Wed, 16 Nov 2022 02:35:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNZLJOV1FLRCgdAPNvMdOczNizM6nA9PKS7ZiYwEBxjvfOzy1zlxFWJw+1XaaPUUT6iTOB/QzJzBTwaXFzGujMjt1lVUOIu3fH/0pLBkg6LF/NFQodoSLmNsCD6hu0IXcTn82X3j2TcQIPSEo6/goZeevyRXUkiW145AAIVpRP2PAZapksdOTDM+D53EN8z4KZMbwm80wxiB/kb5mDXDB7JS+1tiX8UgFlDNknJMT8a0GWEpCEeI7UQBSwa/wvkWOs/VWJUWfgQGwnUFZZH1ATva8zsg9OhnuUdeqVocMy5j5lsZdPOw3bbF5qj4kKAiy/mUfsBviCu9MuUDzXW/PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0YoPxDSqpCwxopfyCL/FER4Xzrfp12u06/5AOevuC0A=;
 b=Dh7es1UAaurlClCpeFSGwNNPqejKRn7cPTPun/8CXfv5zodkA9uCjTkxKwMTndu7VYC9Y1P4BtUEs252k1GlXkTTZTYRJW+PQgs9pUcnmIQzkMOD2MQ8ZXEhXkShE8deyHHMgoVa+qQaF2qbehXWuN7+aHwx4eqg7PL4Mdmgd4w1Io+RYTueejECm2yP0lqC83zN0G2HyvSrkg7ExH2v3ZXtsYGIYKuYcR5JkOzJkErI77CBLsZHHoW6Bd+MWg9SuGd2GM0jIPMUJ1Rc3WfCkNvie6+VL6mrN4Qg+Fxd2yJ2oJ9kHZaI9uUFPwXiJNdZ6OXkgpllQvVBKl/z+b3YCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YoPxDSqpCwxopfyCL/FER4Xzrfp12u06/5AOevuC0A=;
 b=rpjK43lTPMWZFKLVb4ijae80WLkeE2sUpGHbBOlWntSh9T/oxj3Zd8bO1yOkdfon184ib+xYMu0PkN80o6uvGcbuphuxwbADA+gdCmQfyRZ8hEWle8cwEeAzK+Y1EUGYDY7qRYwhaYV8pDiyrfSRxX0+zADdCT5cKpbbYxAFdwc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3742.namprd13.prod.outlook.com (2603:10b6:208:1e7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 10:35:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%8]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 10:35:47 +0000
Date:   Wed, 16 Nov 2022 11:35:40 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Denis Arefev <arefev@swemel.ru>
Cc:     Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-patchest@linuxtesting.org, trufanov@swemel.ru, vfh@swemel.ru,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: Re: [PATCH v2] lag_conf: Added pointer check and continue
Message-ID: <Y3S8/K40fBP05fAT@corigine.com>
References: <20221116081336.83373-1-arefev@swemel.ru>
 <Y3Sv6oZgi3k5VaLz@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3Sv6oZgi3k5VaLz@corigine.com>
X-ClientProxiedBy: AM0PR02CA0107.eurprd02.prod.outlook.com
 (2603:10a6:208:154::48) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3742:EE_
X-MS-Office365-Filtering-Correlation-Id: 9913987b-610c-448e-69e7-08dac7be5219
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YahLsPPPID2QxpzJ80dMTyGpd1aUo3Fg4yg1yE6du+osSovT8AVXJAMXRL3bJhsAbKQP0HEHd1cgHrrc5Nruqs0GH61+8+0aRTX3aR1pXBJcfrIeZ0sUJHFIYKEnWrzXBxSST7leYboo3m5G1QHdls2AbYNXxLrgKqFI3TNM4EGxLphRm9kOS57DPl2H4+HGgEkNX1fqxxK41cnSunREU23k+iF19pRBixxY/LFZLAZrpIURo867VP/ZhB3I+k3HM4UxnDwT6XQEcuAna93SzhIPZ+yLd9GOLNrP/wSdnWpHhQH/NRBkZFJMw7//6ZKFS0yUtOl4OyoKo39xVWg2DQK29mGjk2dN4zK1I0/ZFqG06qAH5kdI4I8fqLXRAdTsN+KcIXwDwqemSk7qqkWusNXav22wr//rTehCZRNfFTQP2+OQUP7Rst+IJ0Sipx9oxLRoEk8jC5kB/ywgQQ7Gz49o7TTbKQcyeQeFy6DI7XI3fVP56f5hBYJACWDYw+BUc4Y8XMyB7r5fMchQDR6B4k4J8e1Sma+9D3YLdSVzT0NvhzxONYbP0jppw6z07+44c1tU8ckKsCQPM7wLMuYiuqzfqRAQ65HfYcDKskg5Cx264S+ElYRbZ4G+J5s+dmCap2ckOHKFUlxmWjCqt8plZZvcRK0RBZPBuG5AaKzHbVBLQ68m2pEZNxCzgKBwsnXE7dksWw0NLAFhon0IiPAC/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39840400004)(396003)(376002)(346002)(366004)(451199015)(6666004)(2616005)(6506007)(6512007)(36756003)(107886003)(6916009)(478600001)(186003)(6486002)(83380400001)(8936002)(86362001)(54906003)(44832011)(2906002)(316002)(66946007)(5660300002)(38100700002)(7416002)(8676002)(4326008)(41300700001)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bWCtJsEK5HHWI9ejUaYavQNFUHTheJtQXYgIvXMiLrHxGJZa7tkV+Hv+Yf2n?=
 =?us-ascii?Q?xl0AJMyZszV3DizgU4sb0P1lgXm554jqosNIrPC2bk0TjZTZhVhg7fxSS1nV?=
 =?us-ascii?Q?SYzzRNRvW2tmkEp0X9Vgs6S9X+r5+4AVdUfMYOwZ08UtBpYu524GyDTuyUNs?=
 =?us-ascii?Q?1G3FiiOnWK3EF4AFy5M7TvGnOSOxag+lDR0n6HmQVwQ+I5PNph8D8AErzvjZ?=
 =?us-ascii?Q?nzC9is1lfOQ83rPGm/VliZu6QyJ6sK7tB9Wbo4FlVghmLaWP2121JDPP4zMi?=
 =?us-ascii?Q?pnEoxNbfJcK9FSb2hVkX5XCWr9x4WdZZN7z3eMXRTpZwfktwgBNeFieNJV3v?=
 =?us-ascii?Q?ZKTmFxLWD9T8as2WOinajSjapZcsXRg6pnuJNrp9KiCwMk0vbT+BtUUaz3yO?=
 =?us-ascii?Q?erWPYKqwoS8Fs12+kry9tQe1kTCl12bNNkcAwQVxCAzkhkQvDoxtKkPAxvCu?=
 =?us-ascii?Q?ea46AAB5pnx9XFXSjeqpnQFuN2tAi/soL6jQN0NuWNc2gYrCdxJnvNF8/wgB?=
 =?us-ascii?Q?xT3lbYAjuCasMdeNBEO5LTJDQ1P2KiKBgkUZZtJAcTMEKYgajEeqg7zxjDDg?=
 =?us-ascii?Q?6vFVxXdP7Z3V3RkQz6S9mROTIhaO8F9O0Z4a5chOce37vAprJDCEmKGiK5t1?=
 =?us-ascii?Q?UwXnkP9U8Az860GaofBjeFTQGwZqw0NobzQahpz+fOxTMREyUfeCrplOOsGN?=
 =?us-ascii?Q?WpPBVKuRBG+Gz4k3lSY+7otM1UAMeHMoyWYmv/zeWBJGv8U9F6/pZXerGN9v?=
 =?us-ascii?Q?XZqoUjpMUDk8ENei/9X+9LwETOzAcoTXGiMl43F/SKvqMk28gS8S1H41QNHP?=
 =?us-ascii?Q?wCARWT08c7R4F4YxpIwyWx2hGeFK0rXO3d2lTT/FqDYrrjAmD5Je516L4jDD?=
 =?us-ascii?Q?Wv1Mwd4AejFciH5x3KplHJn7FJWGiBiUPV0ivZpxRg7bvxfALb6UvkNq3HK7?=
 =?us-ascii?Q?Vc2QtWUYUD8/gE6Nd9KaJLymxQooMrQjCR3KZSm73u+CS4HGq00+7lEx/puQ?=
 =?us-ascii?Q?O92uY91tTSPAwxqgnKAd1vLYxO38W9asKFUZUEWG413S69we78Qc74aaPQdC?=
 =?us-ascii?Q?FjxrYLEVJPxJLHCWlIqJW4iKARWMNxi5fs/rIwywtX+NO6GMrfydKIxOCSXr?=
 =?us-ascii?Q?XcHVU7SZP4GiJO+W0hhs3MI8W4TXN5kTmhYbZ1xb/nvTkdkHRifYMQddmzci?=
 =?us-ascii?Q?S75WwIbQU1LYCp38fFyCxxsVe+nmejBtSlFDXylbBZ5r6qdx0DQzhoc9+Ndf?=
 =?us-ascii?Q?UTMBOy0DTJ971y0RH65awIluL77Q8jZLPNnrLHdref+YsMQ7gGXTFj/TeRRT?=
 =?us-ascii?Q?pojE9/yFccYr5qCtO2wBisq2OpWsd7ekTAWKIZy39f7UERfOo4JTPPeiiiYR?=
 =?us-ascii?Q?MgESRGLPOmNMBxDvZtMTM6erYB2Uav4X5fR0UZjuV6jBuBPL7fR+WiHZx7Ns?=
 =?us-ascii?Q?Tib21nHb8OHwR1q013RuzfG7/cmZL9EOmoAK4QbWZIN6JQCtumATgWNexqxp?=
 =?us-ascii?Q?imlbkWIXtIlhufsxAFBpa/l8LZfe0gr7IetS/ZHhwmPBr5NKby8F/2yXh12t?=
 =?us-ascii?Q?a2OUNMv9AXKac/SJYRyvkACW5TEDUbbRqstZyEnc+7COdOGzlbG5MJk3zxMJ?=
 =?us-ascii?Q?lFYwpkgx7yrn7/gszHKgh/N08KVubGbdZ1QD2ydTKXM4dWyM9Kq9i3jw4pV4?=
 =?us-ascii?Q?ENTX/w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9913987b-610c-448e-69e7-08dac7be5219
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 10:35:47.6923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: StK5YWx+haQYw4qD0nQT5RcBKoqLgCxddTt4tl/YaISH2biVZxSdqtq5YvGAMD4f7xpa0xLlDDvQ4lo33uOjYukkaRQVuBHrsaGWtnjd5w8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3742
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 10:40:00AM +0100, Simon Horman wrote:
> On Wed, Nov 16, 2022 at 11:13:36AM +0300, Denis Arefev wrote:
> > Return value of a function 'kmalloc_array' is dereferenced at
> > lag_conf.c:347 without checking for null,
> > but it is usually checked for this function.
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > 
> > Signed-off-by: Denis Arefev <arefev@swemel.ru>
> 
> Thanks Denis,
> 
> I'll let me colleague Yinjun review the functional change,
> although, based on his earlier feedback, it does look good to me.

I confirmed with Yinjun that he is happy with the patch,
other than the comments that I made.

> From my side I have two nits:
> 
> 1. I think the patch prefix should be 'nfp: flower:'
>    i.e., the patch subject should be more like
>    [PATCH v2] nfp: flower: handle allocation failure in LAG delayed work
> 
> 2. Inline, below.
> 
> Kind regards,
> Simon
> 
> > diff --git a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> > index 63907aeb3884..1aaec4cb9f55 100644
> > --- a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> > +++ b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> > @@ -276,7 +276,7 @@ static void nfp_fl_lag_do_work(struct work_struct *work)
> > 
> >         mutex_lock(&lag->lock);
> >         list_for_each_entry_safe(entry, storage, &lag->group_list, list) {
> > -               struct net_device *iter_netdev, **acti_netdevs;
> > +               struct net_device *iter_netdev, **acti_netdevs = NULL;
> 
> 2. I don't think it is necessary (or therefore desirable)
>    to initialise acti_netdevs to NULL.
>    As far as I can tell the variable is already always
>    set before being used.
> 
> ...
