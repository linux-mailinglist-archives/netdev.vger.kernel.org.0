Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF0A6CFC93
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 09:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjC3HTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 03:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjC3HTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 03:19:43 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2109.outbound.protection.outlook.com [40.107.220.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E0EEC;
        Thu, 30 Mar 2023 00:19:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMTt02OQWguPe1pk2mAbZTMeu1xOpICxfFA2eSGXv1IfkHVhYlvJLIdZUb4Yw9fOaN3ZFrii2VCX74UneJ6KUqd1U6IgblNUXJJpqM8HiVU9ONsZszJ82opADCER0LSzC2QVtSSS/3xVabIwhk7hv2LRs+eEqzrPNOY5zYgqrHmVtkffiKKoUFRQN6qSVbLdcy3yxp8X5281Hc9a1KTmxh4GdxlDXDmhX5QhwWE5SprLc7hohAmjJoatvwZePNVdfrmePq81rNXXpOJTPz1MULq1k0huZMk3Pk9cpjg/xzyEo0+KF2S5pytSrflEBlQCZ8Uz62hI//pN4z2BM9xbpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q4EkY2x1eQ2DgZ1uCXM0gaxMlx2aupulSEK730D2SkA=;
 b=Em4eLFm7sqY3f1U8fjJwLOWznMmN9qLIf6N4i/ZV/dbDFWxRtT7pX5AnMqjr2tcYvZseSzOdj/HUVbz3scOaFfJ8JTp9HHs3yk5R9r7iqvjdixE+VUHtZYQASYbu5RkHtiLSZQ1hxYnkdBw4GNdXnVtKHevApng/bmt8uIafzYEbpbXHs/xwMoqIYVjlEzHUBNyXiefhpPBXmHeFkflK5qJAb1wrYuJpLT9ZzI2I657EK/K3TQ7gn/1yrCj3Oi38sCGZESSBAQfml/REWLOdDVeHk5mKHJzYQ6jbI8LISOGEbXjE29F/COkkZAxPd/yZ1JBnIe+w9q+mncDoU3uLcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q4EkY2x1eQ2DgZ1uCXM0gaxMlx2aupulSEK730D2SkA=;
 b=C8T2sUiyCdCIhobUE8WwA1GxSKtBqHpyB1F2JuCTbl1Z5SQwpmcUmF0ai652P4Yi931lswPWIa2FR1tplfcLNMIruQmQgzn09MpqNPvnS0V0bcn5hEsxzRgxdFPH/Ysz+zswvJa5zhlHu0kIHEdMM/DkPY26dMZoM7d0lIB0HUM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5480.namprd13.prod.outlook.com (2603:10b6:510:131::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Thu, 30 Mar
 2023 07:19:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Thu, 30 Mar 2023
 07:19:39 +0000
Date:   Thu, 30 Mar 2023 09:19:33 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mISDN: remove unneeded mISDN_class_release()
Message-ID: <ZCU4BQ0C4K6HoBsf@corigine.com>
References: <20230329060127.2688492-1-gregkh@linuxfoundation.org>
 <ZCST8vuQDEo9GhsS@corigine.com>
 <ZCUlo1jcPeU4K_AI@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCUlo1jcPeU4K_AI@kroah.com>
X-ClientProxiedBy: AS4P189CA0041.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5480:EE_
X-MS-Office365-Filtering-Correlation-Id: 227417d7-e876-497d-32fd-08db30ef1f8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nHOmo6ALGw5NEBsgf4WqXblFHl770M9NkQuoTXeURZSOOq6DpXeAVDNx1rR6PHUDR7A5f5R71NHp7PDDWwLOXk2jlauKamNXbD8bvRAfhbZBLBWq9t9y5LePdpb0Nqlv/5s7HmTG246A1alNsCMA49pM6DFxYQgECOW4oM9uOsBdnPKXNEPFrv3ib5pu4o54R1GY72lgrbF5Ehz1LWK11Ywi7L3ZxgQ/SsFuVfg7YD8IQP0Kj1aQrMrDDSxrwtCeEYzw46eTpZ8RPwdgrd8wmv6CvWV+PC+nHTzIRdWp695Dp9i5mjgm2CM+YXV/9SB8KXMVnAvqY55mbKFyJKRaiBtNUYspyvOlkezpSUFZ1ejrN38bOgz+PU2pOtc8azpxz4hLb1LtsTD+KtBredOrE8SwLXZq1G/52jByJJBBLDxEKqZQ6XyheYHyRa10t5r4Dh3DbqDvPzupbLNzcZdc8k1vSUv/RlTFehdmRpL00iOYM+5bslNn/SImerivPGbKu0w9E8fj7NYwMd5nCDJp7FuRggbCLAuD7di0ibJZ59XqqPcN+bgBggq4GzWb5zxm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(39840400004)(376002)(346002)(451199021)(86362001)(2906002)(36756003)(6486002)(66946007)(6666004)(2616005)(83380400001)(478600001)(38100700002)(6512007)(5660300002)(8676002)(66556008)(66476007)(316002)(4326008)(6506007)(6916009)(8936002)(186003)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Bs2xL78N0M6LQfYNucdUJKRWUK8rTeRRWmBYW79JzsWpEw8vnt0GFgniw+P1?=
 =?us-ascii?Q?PPpvGGePUT/Oct8fsPEeW2uEksj+OhQdDnF4BPLfunhAO8cTi59IKCoV9/Wv?=
 =?us-ascii?Q?Q29+7e2C+NjFP1Ir4KVmm6Yamr2FpyckidWjrpDoYSviOQEULS/RAlpfpwbE?=
 =?us-ascii?Q?LcIuTmTO2Ya1duESWgxi4lSXZXQAUrbDBLOMiHUQ4wx41oQDBe0X9QfTpx3q?=
 =?us-ascii?Q?pMVROZyiBfEP7KAbagzaOkTdFAVj7N3IK+msQ3UEZ7UD9j9gUAXdZIfVCDC3?=
 =?us-ascii?Q?X77B6yFmvUAcpNXrYTw9N2xUUhUJbs/x8a/mbnmu/FpbnsUJ/dBBjEq9H/nQ?=
 =?us-ascii?Q?If+Z4fSxVT+wp+Jr17fL8R2xPW8rQ5bW4vZK7V6Ns+2RVMVpYrJdfLne0YQs?=
 =?us-ascii?Q?ESqcO87ouoZiSlAP9sorI0CA8/uwhvl7XnD8d2MXhqkPQniXlTa7iCdAiEF6?=
 =?us-ascii?Q?Lz2rdgQGbVstSoz0x8T2LI/TKS6yZlGEaQeXq0Od4kxZxV0gGZSRBUxFCaYp?=
 =?us-ascii?Q?OoqKJ3MtpO0ZQ3qjlrkAVv4PBPlEIoMUrEhNEGnynzSP+iqx9sYADEslJ4xN?=
 =?us-ascii?Q?7nR71CaYlgwF9wa/Za34WvRS6LinTgskKRCeall7CSp4JUh+KB6E/vbdfxNo?=
 =?us-ascii?Q?TErs/JtscDI9nRbEfe+m865rZLhL//ptY4bshphFqkXhh8GGWwUEkr6T6Qj4?=
 =?us-ascii?Q?oMhvnc/vqBQDMaxaXvAJxlzO1W0phzHJWYYKLBwePG8hqDq8hQGWX2zQpFCM?=
 =?us-ascii?Q?ul73VS2+AK9two3t2e3n1D2hOujL8dPexTlDL4mi8GYiOyfsuqEf4Z9MAypL?=
 =?us-ascii?Q?Avku3f+UOfuStFsr9npqvSywQN5H/z+kCKCQ7obhQAP9o24jpOJTT6XErcAs?=
 =?us-ascii?Q?qWQ+Dyh2C2S/53YO6JIAN3zCyODkQ0+QCBPqy9yvyNUgIUv9vnh1Te9ke4A+?=
 =?us-ascii?Q?L5s8Iz6HR3BUyE+PII+/IJCUf+bwKoTG77kOBSR5+Vgsk+mOGH3478IM4rLU?=
 =?us-ascii?Q?m4yNOJDugcFm3kGZAavupTgAFnVUik+ROC/1Rz9DqTlnyAavWbqM6vlqG2sH?=
 =?us-ascii?Q?Tf/8dY7WZGVsDWrAMyjQe1nRXjACHUgbqw/j1FSdPSJZQZAypi3TACwswwWn?=
 =?us-ascii?Q?QCn3KxT0sGY4MhvK682T0Qw0PKlj2RKit2vQ4u264H6pqAM/aHATsl8Mwwq+?=
 =?us-ascii?Q?bCp0B4d8hXQgeLgRAonnZvMFm+ni2vufp/jL96tkui1fzI429BuF3rHjNcGB?=
 =?us-ascii?Q?4xrWRGViottTmqKeITfeMrnDatzXBARbP8NckB0ezpEG1dla998mYUwo6hlO?=
 =?us-ascii?Q?WCxByPUVRCd+L1euIUXc5QheCH8Xh+HSIOpH2UrHVxw3Uc/lzzIbFz2iuxBL?=
 =?us-ascii?Q?PqrsLOwJycUBkmws18az01T4Q5jVqdkThRvxF13rYdIk/ffj2HW0SBLnoyLL?=
 =?us-ascii?Q?xKdde6N7cs8wY7VzMpCrjRBq+MVif5EKQxpOxm8VFJwUKG4oEoHyMtBO4S2B?=
 =?us-ascii?Q?zGNcKzkqtp4hbkhDQjgfDjsNJcJca/FBG3Xbj8NE32Qcuz+ArC+QMPBXWyeI?=
 =?us-ascii?Q?tmjQeoWRsrlgaIbIOdkYI3FUA9ZV9qICEcixtohlm5bRLU6pA5v832s1LL9E?=
 =?us-ascii?Q?NZ4hn617t/wnBiRzUn0U6wzi/ta2jb/AI7dnj23qn8HHTxmCcc9WWCVD/Wf5?=
 =?us-ascii?Q?mgjfWw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 227417d7-e876-497d-32fd-08db30ef1f8c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 07:19:38.9318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ovLDKGPRziXEUgXexUN3Je4yb8ffCz4+41SrZxk0Kyi+LxpFTtDzt53MKi+hj95rlXMd10BLpGVip5/pIhv3fDb4iLywr2M/Rhb3t78g0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5480
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 08:01:07AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Mar 29, 2023 at 09:39:30PM +0200, Simon Horman wrote:
> > On Wed, Mar 29, 2023 at 08:01:27AM +0200, Greg Kroah-Hartman wrote:
> > > The mISDN_class_release() is not needed at all, as the class structure
> > > is static, and it does not actually do anything either, so it is safe to
> > > remove as struct class does not require a release callback.
> > > 
> > > Cc: Karsten Keil <isdn@linux-pingi.de>
> > > Cc: netdev@vger.kernel.org
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > > Note: I would like to take this through the driver-core tree as I have
> > > later struct class cleanups that depend on this change being made to the
> > > tree if that's ok with the maintainer of this file.
> > > 
> > >  drivers/isdn/mISDN/core.c | 6 ------
> > >  1 file changed, 6 deletions(-)
> > 
> > I assume this will hit the following in drivers/base/class.c:class_release():
> > 
> >         if (class->class_release)
> >                 class->class_release(class);
> >         else
> > 		pr_debug("class '%s' does not have a release() function, "
> > 		"be careful\n", class->name);
> > 
> > So I also assume that you are being careful :)
> 
> Yes, I am :)
> 
> I need to remove that debug line soon as I'm moving all struct class
> instances to be static and in read-only memory, which would mean that no
> release function is needed at all for them.  Give me a few hundred more
> commits to get there...

Excellent, good luck with your journey of a few hundred patches.
