Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85BB6DE2D9
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDKRm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjDKRmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:42:23 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2090.outbound.protection.outlook.com [40.107.93.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF86655B8;
        Tue, 11 Apr 2023 10:42:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f8tKHAtYq1SSsGOmpQVSwNQtUwhm198CXaTz5esBE90nak/ZaXgQiPG0EFL85JAl6qYRtVnyo4kTxe8LCY9M2HgqsQ/8Vyd0NMQ/4iHofl8zkPLjHVyH/BaPYHK5tU90INBFRc4RG/pVLDoghbJ5l674j8MhA1y4kxVh7SBgAnHrlalQzA7iQzQVfzFkbTzKfqPIyFHQrpZf0vhSaFVGDJ6U4PZicP7MsnWcuhYd9+AOU27q4ftRr+T2znQQG7xs2LkC86IpwALrZ9bx4P7jmLYcgpqWtDt2nTQvrYqPVk0IVH/oIgcyprIIR/x5QWUtzH1jk9f/AmlyUhq2MEA4Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RxwryS+0mAZAw5naAmlHlJ+WWdAIS4suQXEVTJq89PU=;
 b=SzzkkapYv8e17WrOB3QqJ5sjYjExQAVH+5OCAwIA/XAUaCQKAmTJDpLIXCzKEfhHtln7md3A9t5UhK73OhVVJFQXv9b+VWr96HHyFSJtQUbxZJS/gVi2unbwd3IYXZkQhelwBFWEmsAS3fmLfw3iDjHtkOobk6en00UU0mUMRMWWriUPRDA6rR8O8o4PmLn3/aPZNUZE8wG0cj5p6/HySc2G/yo4utq1KSDx41pK+BU+zNExEbU0nsgn1WUcoFq+A8qCs6xtndc0RkZQ2zj5os8JuvvppiYFELsJ4cOowtSOSoTGYh+nDQ3KbGkcOlWD81wAUQ1y5Klwbq3AfzIzKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RxwryS+0mAZAw5naAmlHlJ+WWdAIS4suQXEVTJq89PU=;
 b=qEfXYi2zmT1DykVo3hGSUeOfaB0ZfIbTE+mEJk3OLT5gAlb39SGegCXpgtJ60BQEJ0+vvFYrgiuy7Q2uJzSj5ovIIhfDIryaaEO0BAtF3A11V5FpwJ4cbTCvZqePWrGcqS+nGafxWRk6LAna/xzkkLYyoEITQTT9GxQQR5J84GA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6227.namprd13.prod.outlook.com (2603:10b6:806:2de::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 17:42:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 17:42:17 +0000
Date:   Tue, 11 Apr 2023 19:42:09 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, naveenm@marvell.com,
        edumazet@google.com, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, maxtram95@gmail.com,
        corbet@lwn.net
Subject: Re: [net-next Patch v9 0/6] octeontx2-pf: HTB offload support
Message-ID: <ZDWb8QyRITjf4nKw@corigine.com>
References: <20230411090359.5134-1-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411090359.5134-1-hkelam@marvell.com>
X-ClientProxiedBy: AS4PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6227:EE_
X-MS-Office365-Filtering-Correlation-Id: 02dbdecc-a3e5-4762-b73e-08db3ab417b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DmplrKgIRts7NX6o0Tl00mGoDRKcP+0Ck8pd6VkrVb3naArI82xI1XxHSoaS5Npzh58S32NOxJPhwHwaTPPqamzesutwTP2VU5K5btFqagxwHmHERNHcDUZsRMpoW3GW9jLr2l1TaP28KiLo/NaVu3fQj/GOqF8mpsVQ3dJpkZqu8kS05Xud9LifFNldUWn5xPRa/FabU3jQqNyHWyObYTb2E0+oBaL5cONDknaYtlaylZ2Y8AIs/tFHYMTtraICutpUBhwzPpqpw7vvCzkgnarMrdnmxMvV7N9OIh6xvfZmvdSc26YaNToJQ5c8qkTISkWuD2E2m90eIvaC0kH0L5TSSbACMNsvMyjRapayeIpUoy8UjkFFBHRuSYJcC8YJ2GVPXFc72lk53O/6jv+I5zQ4C42cJ/UOnM0VduXZNul+9iZmZhBDvV8PVKzwgx8LaA/J3DmWVtKZkzZWsJ33sbf0q2cGp4QYtiDV2Jeg3YKNMDU9Be+E2qvEstZLbEbviS3KMjESiQV1xd8nODt+JGsZU8ltlVYoqlv+cHDohskGCMr3WvES+kmAHud82SWm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39850400004)(376002)(396003)(136003)(451199021)(44832011)(41300700001)(6486002)(66556008)(38100700002)(66476007)(4326008)(6916009)(8676002)(66946007)(2616005)(2906002)(316002)(478600001)(186003)(86362001)(6666004)(5660300002)(8936002)(6506007)(6512007)(83380400001)(7416002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Oulj8ItP4CZcrtTK/IYOKQ72J63EZvhUV1GwTq1gsf7FbnfqhVQOYcC9DaG?=
 =?us-ascii?Q?xX0YcHu1/bEACJHz0m8N/8Hr3B/3Yp+kfXYSBElaNqCMD2a7X5tGHNjq6+YJ?=
 =?us-ascii?Q?TA4MDY9T/AYvihxzJO0YojLBJQucMOu/jg4eToO9L4BQFd5+gvfVEdpTg0YS?=
 =?us-ascii?Q?Mtw1Imy6flFMCk3U53HyQRrWioHTdNnwl7g9LlUhDO2xznScwiDUYYUKbGBR?=
 =?us-ascii?Q?Xqx78wvgeP+Mup0sXjQh1qyG3JSY4UZsXUSEs9PYQdMwLJ9gZT9WLEmk+sQ+?=
 =?us-ascii?Q?ErQB/cxz02KyRrjB+aper989JirNFCy5O6Vkajpoai35sJs+391iZnvoEJfl?=
 =?us-ascii?Q?3KvZQDb+Zs+PX4jGws0ctALaR26w4Wqh+96fAtAhbqaN0H0+H6lJ8ruSyysk?=
 =?us-ascii?Q?JUFOp+1+JEdoRiy8bySSBs89gVxvaGA6EVzvgpyGQb/QvKqFz5BZgEKMPRzc?=
 =?us-ascii?Q?uKDjrUlXskszec0vaZe9i3LEbzRfytfkLlhLEBqfG0JYo382TL3W6rr4afGd?=
 =?us-ascii?Q?LLNgD+9nRvh7lWYz1FcSKhjJoCLZMqUfJ0kp1DeVuDrBoWP4wfHnPdjZUcrd?=
 =?us-ascii?Q?YeIVW8zaDEt4Nav9J+/H0+b5ohjrVlE2hOxsn3bljnGqW8DWOTWBZWMN+cAJ?=
 =?us-ascii?Q?YYMHP994V1G442t4BCpgrT4MebTb68A2EaFt8Z1z2u5arsqWjOGJf/4Sf+QW?=
 =?us-ascii?Q?OfwgzOPpGND1G2ulqsy9bc+AzaKXC8+VVKWGsjsAlSZh3baGdWlpwCBY9FWr?=
 =?us-ascii?Q?KWjwD91cjYLvTEkBM5ZupoHQqfXT/LB/6UenJn3sP+JJFv7eKzDpO8cG59TF?=
 =?us-ascii?Q?voIjIFJzkkctJoqJxUQkkYsTLdN2qEEkZrQCImMyiRuHgEEUNvuyBG03CjMn?=
 =?us-ascii?Q?TXAzpNwKtwlKAIPROry5jZcMCscpb0UC7WdVy2lS5aiTQY3aFGmXsKo5NgLi?=
 =?us-ascii?Q?d4/pE5ocv8CG77GU7jqu/6+ZC+t4BcqMr6Zvfi09bLn5MrPiaQnl0xaFfBzO?=
 =?us-ascii?Q?h001YHpRr65jFgh++45AOgdcCcmAjdtRl1TPJNaMxWd0P2THILJEvmPCSRLA?=
 =?us-ascii?Q?9G2731j6KgHaIRqxyRRQXzxQofBMjXbI0OKiZeqb77uvDHcfRtVMJjk5qJ1t?=
 =?us-ascii?Q?jmpyVPXRe2X7xydS7zB6CZ6s4zSwHBtuiEYpYoYlztEQB1ppNyy90ioCXSjj?=
 =?us-ascii?Q?QpDe+zbTMqsvgdEqNwv1HdYcwccIEQyRW6wHrobVUOlp+kUm9U4+o6n1KgEh?=
 =?us-ascii?Q?s3RVBaOLDfgN0FxpoEj/Fon6WL2iHWZHPyoyCftpliImWhqTT2yoGEoM0/Nm?=
 =?us-ascii?Q?3XbdEmVYx4ikg2zYuL2phcZBhc9avqkk2PnbsIgbL95CNBqV9K//d8cOwPsg?=
 =?us-ascii?Q?G/onH1o0uRoOiVQ9RcCmmnBHQN2XQY8xtqop6N5O3G5sgRklkax0iXOj/qFM?=
 =?us-ascii?Q?RwV3w7S5e7VZI3ioHAnjEkHbUiqkW1Za9HkMxNngj7R0yiNj2VQfab4qk/Mi?=
 =?us-ascii?Q?WUnK4V/uV1ksPLRQtrh+04KiZJawf78lIQVyXqSN3CElo4VGYEsno9P8yq4U?=
 =?us-ascii?Q?Ob/3gA7WXGGsKVDZZIl1+SH2s/pzv7g4STVaNJpkdsVK6nlEp73jRPbnvpfM?=
 =?us-ascii?Q?ScXaldDsToEurQHIqgR5uwm4rXXVSXLihgPZe9xdKIUcjDbQF1cutDu6uS2D?=
 =?us-ascii?Q?FrN8yQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02dbdecc-a3e5-4762-b73e-08db3ab417b0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 17:42:17.1574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g+nRf0rVy13DozDxcQs3pz8qz62/Cd/NL0a9sFsLDpkJVGzvvCIJeOHKQPo+aVHTkV4QxJ2t44kJEWKrXjrF0RVVvU9YGoeydru4vfRVxf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6227
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 02:33:53PM +0530, Hariprasad Kelam wrote:
> octeontx2 silicon and CN10K transmit interface consists of five
> transmit levels starting from MDQ, TL4 to TL1. Once packets are
> submitted to MDQ, hardware picks all active MDQs using strict
> priority, and MDQs having the same priority level are chosen using
> round robin. Each packet will traverse MDQ, TL4 to TL1 levels.
> Each level contains an array of queues to support scheduling and
> shaping.
> 
> As HTB supports classful queuing mechanism by supporting rate and
> ceil and allow the user to control the absolute bandwidth to
> particular classes of traffic the same can be achieved by
> configuring shapers and schedulers on different transmit levels.
> 
> This series of patches adds support for HTB offload,
> 
> Patch1: Allow strict priority parameter in HTB offload mode.
> 
> Patch2: Rename existing total tx queues for better readability
> 
> Patch3: defines APIs such that the driver can dynamically initialize/
>         deinitialize the send queues.
> 
> Patch4: Refactors transmit alloc/free calls as preparation for QOS
>         offload code.
> 
> Patch5: Adds actual HTB offload support.
> 
> Patch6: Add documentation about htb offload flow in driver
> 
> Hariprasad Kelam (3):
>   octeontx2-pf: Rename tot_tx_queues to non_qos_queues
>   octeontx2-pf: Refactor schedular queue alloc/free calls
>   docs: octeontx2: Add Documentation for QOS
> 
> Naveen Mamindlapalli (2):
>   sch_htb: Allow HTB priority parameter in offload mode
>   octeontx2-pf: Add support for HTB offload
> 
> Subbaraya Sundeep (1):
>   octeontx2-pf: qos send queues management
> -----
> v1 -> v2 :
>           ensure other drivers won't affect by allowing 'prio'
>           a parameter in htb offload mode.
> 
> v2 -> v3 :
>           1. discard patch supporting devlink to configure TL1 round
>              robin priority
>           2. replace NL_SET_ERR_MSG with NL_SET_ERR_MSG_MOD
>           3. use max3 instead of using max couple of times and use a better
>              naming convention in send queue management code.
> 
> v3 -> v4:
> 	  1. fix sparse warnings.
> 	  2. release mutex lock in error conditions.
> 
> v4 -> v5:
> 	  1. fix pahole reported issues
>           2. add documentation for htb offload flow.
> 
> v5 -> v6:
> 	  1. fix synchronization issues w.r.t hlist accessing
>              from ndo_select_queue with rcu lock.
>           2. initialize qos related resources in device init.
> 
> v6 -> v7:
> 	  1. fix erros reported by sparse and clang
> 
> v7 -> v8:
> 	  1. cover letter header is malformed in last version.
>              correct the cover letter
> v8 -> v9:
> 	  1. fix issues reported by smatch

Thanks. I checked and all issues I've reported are resolved.
