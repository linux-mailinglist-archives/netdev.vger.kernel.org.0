Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 609E7683276
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjAaQXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjAaQXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:23:41 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2118.outbound.protection.outlook.com [40.107.92.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55E713538;
        Tue, 31 Jan 2023 08:23:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2nL1KijeZFgTiBw70YoYWxrz2xLjnlITDyhZhEIm2KG2kq6qBitnemJCXzyK8CSu2JHQFaH7eEo+CquvHzXMuSyb4RsOxeFJ45eexm5XTZ1DyO10CdvHtpuMRLcDCGkK8QLnA1s17Zdh/m69TmBVH+Pf98T/zDA4risK8PD5H0HgjZhFfRrB7d5xr9i41G9QJ7v9EmhI7hZ2basQmGJa9LAS8o4sBhft6uykSf9usSqHzXOSgRCW1q9ny6j2JGul6cUFDxz+J3w5ZARtMdbJ/lG5/+p4C2g0tYcu5/iKQVbp4aTZvM8HrU0WSd8/l6ldglEVap0/fyopuJO/lrk8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w+6VzV/CbTcUt5tXA2kkLE4aHJD8taU1fa7auMm5TXw=;
 b=GavUAxCGhW8sm9Z1XYYohXK/3uT4VKd7t0pTmPTUrIQ+ncZOHJ2BJ2aLl+TkbPnwylO4A4PV69j8GTTQHOaSpAWVJsNLvbBZIJ8F+Nfn82hyBh0Hl1HwhHpfphCxLN0W5fd916imS8Gfw8FImb+8zeyWzXW2bssXeuZtJighlrP2CEed3yTKls1HV7qa9Q5tYX7f1ri2RCKlMwSayM2bT1fugWUB1M1FK1DxS0T1CGK3NcWLlOU03XKmTDqDTk3TH4IRYf0bT4+VHiakw34nOfABPj4KHGr6Nfddz3NVPJTHUmP12Hp1pyXG+Xr7JaW0Oa445vCzsdjE/hqHlz70JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+6VzV/CbTcUt5tXA2kkLE4aHJD8taU1fa7auMm5TXw=;
 b=dw9KJj/rhelpp2GhGvbaEv4xwUf1iL17UByvvv34ERz95kkahFJ2eh9xlBP/gZLjqQvSHzwAXNBZMpWeP9cnfJ5GFj7HUB7Pp0qYP0yutqOrqj3h6hQbBPej8Ed8+Pu+vXq7Pr6smozsbSh9r7nQ4uOPAZ4Y/Z0JsNmjoQ/NKGE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4556.namprd13.prod.outlook.com (2603:10b6:610:35::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 16:23:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 16:23:37 +0000
Date:   Tue, 31 Jan 2023 17:23:30 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Natalia Petrova <n.petrova@fintech.ru>, stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] i40e: Add checking for null for nlmsg_find_attr()
Message-ID: <Y9lAgp19ZUIZFe9S@corigine.com>
References: <20230125141328.8479-1-n.petrova@fintech.ru>
 <20230130221106.19267-1-n.petrova@fintech.ru>
 <Y9ikffXU/qV1DV7f@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9ikffXU/qV1DV7f@kroah.com>
X-ClientProxiedBy: AS4PR09CA0006.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4556:EE_
X-MS-Office365-Filtering-Correlation-Id: 3673d928-7331-471d-bbee-08db03a781c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HPzpy4yDmRAAejqQqekLUjjOeCVQZyEplkoeAKuXy7F/jfQEoE5h+0diV6+GqE2O/L6G/hyoIc1IS+T3/pEr1CG9BiRhbK0/JU+//jGoPsi3ymKcVpkAE4HudjiL7DAhmx/OCO2FY3oEKcTvTv+wZaVOLv/6iOsqTIWnLWws8ESg6dbKKRwXN5TlbrpfqrS09z1CncNPadKsd/LiZyJS6NZ58onp+JoxUOkmPElI98GtnnfUbW21nBDdwiLxacDwvap4SjHr5DeLm4flxWQnV6jmtWaMNyl8BJg+opvaKpS7qk8c+RxRCsvREQ+ynHbzw3NfW5YyS14BsgQqi2nXRUm8zbrWQUtBtB1NMBGVTDciBBQcnHwjRbiyvUDOSIGp1GFXq6Xl7LIuAa5u187IWN4DrTdvFNGqj1xbp4LSeysYNub2c5gYhWOzbg4gjTT/827MltafemeWgMzk+SUlgnahINMdrxZ5foXNYzSYbVUGF3OiRTxhWbyKWBy1tg0jvs3q7vG0N5ags944JU4nslOtA8pbT25qnAoxHCCYlD6xUu8LS+p0wAsOmckSPwjVhIEu3zT9Ju2LrcwSgIhH3NeqNlacUU0HVJXKP1TwC8XAnfsVnnSEQsW6gkrVg5g2x2jW0v1iQYxgz/LUUr4EWSqXoW/zto6BriNd6rog571DXXqTHHGjf3PPuziaIgXa8jOLUU3OBv9xmiZLWXxGkUlXDVlTobVB85uGvP1GZlA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(366004)(376002)(136003)(396003)(451199018)(44832011)(2906002)(7416002)(86362001)(66899018)(5660300002)(8936002)(41300700001)(4326008)(316002)(2616005)(83380400001)(8676002)(66556008)(6916009)(66476007)(66946007)(38100700002)(6512007)(186003)(36756003)(478600001)(6506007)(6486002)(54906003)(966005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ugcA/pBnIngkjqS/bLbd7Ep/u9OmXH6kACF8ivKajojeb5pRfaIKFp5M2J8P?=
 =?us-ascii?Q?j3nQt0wHctLoivCUejGeuc39NG5uD+QwgVyBzLFYRTonBP9slbIGDrXG0KtC?=
 =?us-ascii?Q?MpcScjYzSa1t7vUyGb8se9OENyKsVOUTlGWOmArqpdeAJoki08CvkRyTjBid?=
 =?us-ascii?Q?obMbv17w3tRnAcKVfQzPpDRS7iC6sx16HsgP0QC14usncWIMHXgUmjQG9SOO?=
 =?us-ascii?Q?JU/qZIGhQmM5rq2xJ9AkYZn0WLlI6aN4m40TL7M9WYBA/06mMWJ4xYN7L27z?=
 =?us-ascii?Q?43N5SMi/xRgBe1UKynlUxkrSWWipEWF0vqeikQ/dvO5+DWm91NSnlAGfIESL?=
 =?us-ascii?Q?aE9W3sQzl9oPrtI+jI6mMIwjuAcq8kFay1Z4DfD2K00ueA5peLrUNaBJMACX?=
 =?us-ascii?Q?xMB/U6ZM/y/wpIabt6f+WqQgFzDwDnO2WndSSMRngioX1NgcxVlQp0v+NuOY?=
 =?us-ascii?Q?DYJu09Lxu6rrhAOQFW0wNJq/AedLBv1TNXnj2ZdNUFVfDtJ99VbYom8KMmun?=
 =?us-ascii?Q?j8dkC3EJ5D4rfsq4Wf1uziAzpFKiCcE+uXto5hBiLb22+7BOeHUKYB4cNIs1?=
 =?us-ascii?Q?Jf/+2ouR3F2XvSI0HmB8BitIs4wHkyq8fn9qglqhelGkAlDsE2tZRDi/VtkP?=
 =?us-ascii?Q?FMzI3HchP5QOno2PFaMYN2p6Diqe++qa3ImaHcAUEMBW9QCTiDRszvOJwqpl?=
 =?us-ascii?Q?o6O+NXLXKeJlrpyB+K1szcWoZf1dD0stiDjzv8YCUJNs7Hy/t7acOlAa1bTo?=
 =?us-ascii?Q?1wOBGCWkkAyBsb1ge15OVCKpZiui3nLfrtzSzkttrH1hlnXnwpVD75fvCSqC?=
 =?us-ascii?Q?4rf61E6UFqooBCtlfBF7w2dSXfcz8BYiQb8rI2H/dGcqwx+vmKljw/sIJgJl?=
 =?us-ascii?Q?U4qvWlM6sxMvdO7ydDxtiGZ9T2PHFxn1UIzBXvElJUntinCk65Gt58ipfPxf?=
 =?us-ascii?Q?P8hqjOqifS+Z10OWWcRmAf7XUSyI/cS3pKDPVIi3KBtdD8R1pEVTV1COB2zj?=
 =?us-ascii?Q?KY+xd9tz9ZbdmRqaPPPWd+bXaMeTqU+Vh+c2lGnVjikt3Me/XSAup7qlLPSO?=
 =?us-ascii?Q?Jljr8VPvp6//60eVpb2pQUX+oAI702GsuU8AL+SuueAx91rfalKIHz0l7W8R?=
 =?us-ascii?Q?ctD9ekPWktlT772OM0DIkat3gML1F+doow4pFuMusF4bOm5XzZwHZIbrL9YR?=
 =?us-ascii?Q?tCshBAtyR4PKy7K3k6lkJx605kujZKdzwVGdQnK70KuPvGEqylok0eTJsSgs?=
 =?us-ascii?Q?mMoAHUAS4Kvwvd7Oyk+jZweV8FJ+ukBM7esQ4NTbqUkFdpNfiEXwKvlO1yTr?=
 =?us-ascii?Q?2WEp1+owiPBDqNXvcEutlbiJDfXaP1/AMaWZJKaC7wsAQ5GRM+K6qY6X/s/R?=
 =?us-ascii?Q?i8B2DjCcjH64JORpzCe/U/DLmjMNJLngwRvA2h59dFiStqUthSHrMyyMgxhi?=
 =?us-ascii?Q?lg2mzA2tqNBCAuPQ2NAIFAVo8y8i9sIpqfAZkAh5T1RIVtBnXxEk/dQl81Lq?=
 =?us-ascii?Q?LBeVROVmLeX0vbzK8HNmJVMsD15tP2njf6W5X0UeCcx3mVRkrWEvLFMSbRif?=
 =?us-ascii?Q?/oGw7CyjlNjvUGFfBnB1F9zUu7MZumK6uiCQRmDmlqInWZzrDmkY6rx0Q3pz?=
 =?us-ascii?Q?ejJcIxDircrAC+lOfmMrGXpRmGYvsM2YTrLy7Ldi/yX4i0+wYrWUWEhA4me2?=
 =?us-ascii?Q?0kJk0g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3673d928-7331-471d-bbee-08db03a781c5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 16:23:37.7042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kzP+uHC1nFZdu41B7TZVLubGCoUc+lX/1zCK6LE0u1YgvO1FeHJovAnFRrHHETOI8W8ISaYIVzX+2JzlSr21Adgu9vZG3uCNHnt+9T7Pqgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4556
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 06:17:49AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 31, 2023 at 01:11:06AM +0300, Natalia Petrova wrote:
> > The result of nlmsg_find_attr() 'br_spec' is dereferenced in
> > nla_for_each_nested(), but it can take null value in nla_find() function,
> > which will result in an error.
> > 
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > 
> > Fixes: 51616018dd1b ("i40e: Add support for getlink, setlink ndo ops")
> > Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
> > Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > ---
> > v2: The remark about the error code by Simon Horman <simon.horman@corigine.com> 
> > was taken into account; return value -ENOENT was changed to -EINVAL.
> >  drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>

Hi Natalia,

offering some friendly guidance here.

It seems to me that the problem you have highlighted is present
in current upstream code, and thus should be addressed there.

If it is considered a bug fix, then it should be targeted at the 'net'
tree. If the patch is accepted, into the release currently being
worked on (v6.2), backporting to older kernels can follow from there.
Otherwise it can be targeted at 'net-next', for inclusion
in the following release (v6.3).

As I think might have been mentioned, elsewhere, for networking
changes, you should indicate the target tree in the subject.
E.g. for net

Subject: [PATCH v3] i40e: Check if nlmsg_find_attr() returns null

The above also incorporates a suggested enhancement to the subject text.

I believe there was also a typo spotted in the patch description:
finction -> function

In all, my suggestion would be to address these problems as a v3.
I do not believe that you need to include stable@vger.kernel.org
or Greg on the recipient list, as the patch would be for 'net'
or 'net-next', not stable.
