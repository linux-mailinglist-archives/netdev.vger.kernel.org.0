Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A336A2F5C
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 13:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBZMBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 07:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBZMBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 07:01:52 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2125.outbound.protection.outlook.com [40.107.220.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB383D31E;
        Sun, 26 Feb 2023 04:01:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4JDWbcfYTvjG/Z4eP41RWxkqBkw/baRzyOhiiMiJzST3eKwrn/mcdHTotGCpdJyU1lYk2kCZ57wiOHMM4zGRgqGHfVwloDv3uVh0RbqlfESr+6AYbXMcgFjlcCUHHi2wqkSP9EG9E9msfoJ6m73tdtaXjLTclSGbTa1RfgOWZdtR+t521qds0ACys5LsaMTWnyXBFLPO+a32HCwAJHS404Pon3YLjDctRLgxjQLkL+2c1XHUIiZ0WkCZFK2EejvxeO9FFsW2oUB4qYJ0OVWoBd1wZ4g+EMU0Gt/hejd53Sy7miQYLP04TseefQG8tjrHoiCi4fw5g4/bt+lcvUQDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVMBYBtoAKLp1mvb5GeR/ct0yAzhGQP7M1kG+imBbWs=;
 b=MtgJ5VHeEqQ37DkTPhzjDP/X63mgo5as0ACeqgkYTO7foxPTQPJBkJkQTQAj1Ga2tlkOXWctwAB0blXzr9NxwpzuBo57c+okb6YGFNI/wcYSLFvgIRVUj2Lb4XiYCehky1MhA15IqiezeTpJFAqQkTWByDkT6W/akAIkNOQ2oRkc21DR0RcOBOxil6FnZMltHv1P/+XSq4D88f3lUEiU3m1h+exNziPIeAfQMr6Wlo5a2vSE7BwHG/mOCbZ/I74e8i2zGK6qqGLkY9VTaNfHzu50snzBexqxdoY6mdkxOyH8zjwFBpebnBkYF49xx98uiDSZFwZVmwyfxuDmxkjwvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVMBYBtoAKLp1mvb5GeR/ct0yAzhGQP7M1kG+imBbWs=;
 b=t7lPgOUrbBw7n/KDCiv0+xct7RjyfZ3yAkYF5h6sD8lLlYvjYpUAd6jR+IEKnxFrnYLSxlXJ6+Of/+D17rOqzb0OUaURsBYGS+sJTq3DEMSFV80lIZLjRdeV35Yu9DamelS5OEp4Espe2XbQFPmPYR0wpmNoel6b8OcYMEh5EDs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB6020.namprd13.prod.outlook.com (2603:10b6:510:fd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Sun, 26 Feb
 2023 12:01:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6134.027; Sun, 26 Feb 2023
 12:01:45 +0000
Date:   Sun, 26 Feb 2023 13:01:36 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, paulb@nvidia.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/sched: cls_api: Move call to
 tcf_exts_miss_cookie_base_destroy()
Message-ID: <Y/tKIKrR0ucIQ5mI@corigine.com>
References: <20230224-cls_api-wunused-function-v1-1-12c77986dc2d@kernel.org>
 <Y/oycX7fMP8yJAdd@corigine.com>
 <Y/p6b4rGiUqGHSsW@dev-arch.thelio-3990X>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/p6b4rGiUqGHSsW@dev-arch.thelio-3990X>
X-ClientProxiedBy: AM0P190CA0016.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB6020:EE_
X-MS-Office365-Filtering-Correlation-Id: 4da836b9-eaad-467f-23fb-08db17f13ade
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eckwUk8PaY+Rk1o39YMLZ+N19mqpdEmR2wqgYBxxes/i5dxJeMhK0LVDO94oBPHLMkxD9I8x5YJHJLZYF6cTCNMqdZgL/NOpejFksDgDIYx+2JIZlXZzNMl4iDPagvn5iq9IUyOvhbVZSrtPmcR8Twbin0sKkIAUucceLx9i1EgMIaXesXY8/5tTDyk7R55Svrbj8f7OhdvfRpV0s+wBzTADGZZ9E6LKcZRRIYlSyBPf5CdMgMkXtu0Fxn+h12K27FVSnPmZGVC7JctXdPEBAxMKD16wQ1ljftmb9CI4/FcguyaR2gHUIHeo9CJXYFD2VaMxI0wZFoaeuCJq8VIe+Rjx77CCfuiVQ0sIDePlN/GbUWxknrs5J1l/lnmOd/fBsgoukz+Ur5mOdK6G944G3803K6IxObx30h3N1pGiqcieJW3h2j2HeYmk+HTdY/GQPPEO7Etpl02Wqz0huIn3CkbErdEKMSncWWIyL7pr84Q2U++lHZLSGBdn1xXKS8OyqczCqFbni0QPtpcr1NjX+m9upSiQ19odO29Tjb3WqRliOz/TimRM/mqHLlg5E9M/HwfZEk5a4DRZxcVqCZQvE3Ga0Z8yqBpxmlyri1zke5iy6lFSH+kJ5iGpkaDvu0jfaFFeV3XHqEawIxiM+XEUHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(366004)(39840400004)(376002)(136003)(451199018)(4326008)(83380400001)(66946007)(66476007)(6916009)(66556008)(41300700001)(316002)(6512007)(36756003)(8676002)(8936002)(38100700002)(5660300002)(7416002)(44832011)(86362001)(478600001)(186003)(2906002)(2616005)(6486002)(6506007)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oK5fugVCO3ORhA4QljhYnmEAKgU+FJEYm1QQB0OdphSe1skaHXYjlXgqlsgg?=
 =?us-ascii?Q?h+zEmVGN75qk+lI9koKsgsSep5z8kAVvbM2Kzd6C0W6cbGy/2fQkREihDk6h?=
 =?us-ascii?Q?I4n/mYpIndMjPVwdtS/jWi7ZRd85vyZukSpeVAjan3dJJn1uvhXAIMrheWfJ?=
 =?us-ascii?Q?uVT9PshCNi4L/6f65cqU3hOBC31T3ITtsKBqwemOLSQQmd9aiCk/177HdA3o?=
 =?us-ascii?Q?bogSvcK9OV3sJrqa7PhIQCleEhfHNEIwA3tfRwiRLN/TZvdM4Qrq6vFIFbgi?=
 =?us-ascii?Q?jfcwL+MoRJ61lC4fVby6vf7VQfwRHo/jmI1vpqgaCS+JxrJ1Z6mDxLqDLDB4?=
 =?us-ascii?Q?9kd+LJiB12rxFg7EhjWC7/LyD6l7ZMPCFbQkgh83FsKgXqDc6mizXkbcHNS0?=
 =?us-ascii?Q?JCW9wjiXf4cPAWoTf8wz7g8IBhbzbq56eXTVdzccaTEMFcZp04j56zeYkliy?=
 =?us-ascii?Q?ch45vue4pKMJcEODJ346EbZVFALNHKMvoaMuGYvnDCLvqMwH1dxm8Y/zlSf1?=
 =?us-ascii?Q?H2uoKhiMHHMXPxH9LhnycqJSSNk73V5ZXd7Zol2I3sle7/OiQzs++8Is2Y7Q?=
 =?us-ascii?Q?qSY1tkxkKKchqokFYfDwS4GDu9oaV+musoEroQuCbUYdGpWBghV5WLgiV/fp?=
 =?us-ascii?Q?lLe45seYLNi8FUthiWiEVnzpJ6xIPfnU9ySqdpnJEOEu1ZvcMpW2LZYguS1r?=
 =?us-ascii?Q?eoFILQs5M5D6NS5sPHtoztgrSBPO3SDvF/lZO/+S8cAgGYs+8suX+U72eney?=
 =?us-ascii?Q?vgY2a8djI0DggeG8/Ag9YNPkXulVJL1xfz+zlSXCB5yr0uUpGqxwUzyTxNcn?=
 =?us-ascii?Q?g5OqBWiQtv+bcq1vdzb7jl+Ii2ro/8yqBGIdyLUya7sYEoVnHsj6LRk/IxvB?=
 =?us-ascii?Q?filqjjBqqQkyZgJO3XmXbhM41dJ11Q+JC7JCt3fG4eMbFCiI2ubTcfBaR8W6?=
 =?us-ascii?Q?O4He3TYcauY/BZ1Q644G3YRl43RerPR+uEdSIaVfYeenMprjKXtyXgbdXHGM?=
 =?us-ascii?Q?NGgKowa/Z2ieDVzU9WcVKk1/5ZAU2BG8z6l2bHiWwiReQBJVa9ZWEdHIlLni?=
 =?us-ascii?Q?U7DkjkpNTf3jxtXTIkf7F8FU+ziwZb7qREGmeg11SYfbDHvl40cg4VVuYNhU?=
 =?us-ascii?Q?XwaqGmJLWkVw84lKo8BO2Rh0xYb9WkOEOSCynS+woKnnp1eFHCHgr+uwNliq?=
 =?us-ascii?Q?XS2DDj1y4rs3kNfF4xKO2ofgD3N1jpokqbgVlItw7t69WS3YpOMkWMLJPfV2?=
 =?us-ascii?Q?f4kByQcHNYhRX8EBR4FzAe3iC0vNIAbltbDYuaJEX8tMbG7ruBvZyTwkP3Tv?=
 =?us-ascii?Q?M5uHoM/rFrZ2ukQMEt8LfUB8kRBwFcooj7IjxInIuBRq79m7g2CdSpQop4l+?=
 =?us-ascii?Q?3i1jLgqSGuiLnVBr7qEPhljTtLdsgQYEycw+MiJp9Oz3Fk4y6j3ptAPGnbxi?=
 =?us-ascii?Q?3fNHIIeCkyLFpmYJgxam7AlwaV+Z/wFRyjPqlyHABbHDYcLl3imMsiqqeaAg?=
 =?us-ascii?Q?W9w8Tcs42pxKBNcR3OVgGseeYK5YfBgHIqXjPPGDYWeonvXEpFbcjT+FBpKc?=
 =?us-ascii?Q?ZcDyDDxbZ+D9NOhhJR/QAB426li46pRJc0xQ97TDyLame2UgUkO9z6+fowsU?=
 =?us-ascii?Q?psLWlQmbNuVnKh3kG2FJ4DuQZRl/aX3vYHBi7dhr/MZaa6jESOmCJBu6bMdL?=
 =?us-ascii?Q?Ohi4tg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da836b9-eaad-467f-23fb-08db17f13ade
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2023 12:01:44.8375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ExpNiev3wJ1QwUwoLxCchW5ObGZsJB5HJMpkS3qveh4FWHcaATD/uFgdGVe+40gjYSGmhWIUgRe22gsvxMXZMo4o8bDy3DIgm8Rrqyc8WOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB6020
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 25, 2023 at 02:15:27PM -0700, Nathan Chancellor wrote:
> On Sat, Feb 25, 2023 at 05:08:17PM +0100, Simon Horman wrote:
> > On Fri, Feb 24, 2023 at 11:18:49AM -0700, Nathan Chancellor wrote:
> > > When CONFIG_NET_CLS_ACT is disabled:
> > > 
> > >   ../net/sched/cls_api.c:141:13: warning: 'tcf_exts_miss_cookie_base_destroy' defined but not used [-Wunused-function]
> > >     141 | static void tcf_exts_miss_cookie_base_destroy(struct tcf_exts *exts)
> > >         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > 
> > > Due to the way the code is structured, it is possible for a definition
> > > of tcf_exts_miss_cookie_base_destroy() to be present without actually
> > > being used. Its single callsite is in an '#ifdef CONFIG_NET_CLS_ACT'
> > > block but a definition will always be present in the file. The version
> > > of tcf_exts_miss_cookie_base_destroy() that actually does something
> > > depends on CONFIG_NET_TC_SKB_EXT, so the stub function is used in both
> > > CONFIG_NET_CLS_ACT=n and CONFIG_NET_CLS_ACT=y + CONFIG_NET_TC_SKB_EXT=n
> > > configurations.
> > > 
> > > Move the call to tcf_exts_miss_cookie_base_destroy() in
> > > tcf_exts_destroy() out of the '#ifdef CONFIG_NET_CLS_ACT', so that it
> > > always appears used to the compiler, while not changing any behavior
> > > with any of the various configuration combinations.
> > > 
> > > Fixes: 80cd22c35c90 ("net/sched: cls_api: Support hardware miss to tc action")
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > 
> > Thanks Nathan,
> > 
> > I think the #ifdefs in this file could do with some work.
> 
> Yes, it is definitely an eye sore. I thought about cleaning it up but it
> felt like net-next material to me, plus I have no other interest in this
> code other than making the warning in my builds go away, if I am being
> honest :)

Yes, of course (x2) :)

> > But as a fix this looks good to me.
> > 
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 
> Thanks for the quick review!
> 
> Cheers,
> Nathan
> 
