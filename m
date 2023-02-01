Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B066869DF
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbjBAPRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbjBAPRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:17:19 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2105.outbound.protection.outlook.com [40.107.101.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3357271648
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 07:16:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2uXzjsnamM//lBYo2i2mWAdwAwFBUDst286lymVMdOZExHy8CLArUG0PRRyQ2OFYsnxaeVxM29Tjl8g4cgpbzri9dM/1zQFbOVt5PWL3Sk7QTH/zwg8YsuyOUn+YOIEBZ1auNRPwYciTw1v9/5v9lwYOYCfmc5ldoBmy5JQVEWEEPHRXKyHV0z4Nx6mXWNdp+sIkk52ipVn8ntstFWqquOdkrVCzUxhUZG6KQ2JHexx5hoqKss576xWwJHmB7b/93ObI5Igk/nXB3r3Lro/D71H00xVTpdSDBt5VECO7ty3Lji0mT+R+llq3B8ouxtKgKqWKbqmlrgSv7LtZuPiCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMf5n6h9w1XuDAx8qO8zGEo7KxQlon1Wsy1y7UX1Mtk=;
 b=eP50SwCH8Xf9EARYBBHmgaYq1iUs2VnEs6lh/mhPMYZ5k4C2POvdfq+sWn4ApoiCFFlSRRZ3js3YANSHxR7VFg/C+uBatY/VWGDkcbGVSS+CRR0eMWBkKuRfbdEDdE0Bp+Q8hu7mlTdxLnsBKox8vKN6iTgMPHooWXGx/Z74VLMHSYhgRrZLaT31cnzyGtesgEa+D3+runeDsCFb+h3P4FiD8ubYn5Q6rQr+pfhCFwzdWM+fkSkzpAUElEw/lsTSVH7y3MwTVMZ5nIJCPsPSxE6391+NIBZ3SqQDTNe4XD5+hQHYXyxxM44mzc/OQPreO8SNOLovVOJKw9BVP7hHuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMf5n6h9w1XuDAx8qO8zGEo7KxQlon1Wsy1y7UX1Mtk=;
 b=BStWiQsi5tdNbg7KTa715t3cPSfQ7gp05CY02zs+POodqba0A3iY6Pt6GicBFiB9ut6tUrh+FSMWJhynBcLU5eywR9wHuaPhJ7njmtQifRKvxZvS8W/43HXdj3qr3j4h02bTcDAXgnNOEFYgTolVJinywS0Lo7EN5Eytc0Q3c/M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5719.namprd13.prod.outlook.com (2603:10b6:303:171::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 15:16:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 15:16:29 +0000
Date:   Wed, 1 Feb 2023 16:16:22 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v4 net-next 12/15] net/sched: taprio: pass mqprio queue
 configuration to ndo_setup_tc()
Message-ID: <Y9qCRtdfcs9L5RrD@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-13-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-13-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AS4P251CA0014.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5719:EE_
X-MS-Office365-Filtering-Correlation-Id: 09326135-ef9e-427d-2f3e-08db04674b0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cii//9TQQ22ZqImvQb4P7dsOwMHpl0p+Rdu+UNtwyI1sdKGifGYBp3EcWKBqyM7H/vwPsxKGLQvoviZX/1fgn2pO0Do+2lXHRdbiD0lwFdVEQMGyP7OOmZTU7Jv6aua3tgOvLuJfqd1HFO5zu1byG55KKCesndNMDxIv+K1vutjbh+nH7d0+mLsvudz1y5RSq+eu7xAtgM9YkAL+r9lJm3sRaSyT9gHUTmaCS6kfy63n4ULaSXA9P9bnFYsLCYROuoEj1BwMMC1cRUGjhP00fJNypc2znppfmlF+ZpjmPWMuW3ruB1t5MzBZSMM3q+EeHIHMI3TzThUTPRlsg/PPROu5BO4Jf+BiwWWNmaWuwQPHhhec+wJAxXLSEfSlTq2FMt16xr5sAF3xT2pMyEpis93X32PYuv7asW1O2I2FJqA0OY41jz3JoJIzFH671EDRwElynEIaJcAy4Ntrdoq7/5fyyMr1K/PZQR1svD3OnpnmGqcYbCQ/TL77Nvk62P4XzWU1537ql5bj2kt9jMp52yZAsXNYxhnWCOQgptC4RIB+X5x3IUxHhr60aJmre02+Z8ouZ5pS/Y8OAR6AFEL9b2xHK0RmTGkV0UkC14hSvxmKn2iJtlgw+lRfquEDTe8kyM24WmviXMOGL3IrHi9tcgg4jP/qcCE+SYCT0rrSkwBGCbKk0M4Gk4+BLplTpLcO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(346002)(136003)(366004)(376002)(451199018)(478600001)(316002)(6916009)(4326008)(8676002)(8936002)(66476007)(41300700001)(6506007)(66556008)(66946007)(83380400001)(6666004)(6512007)(6486002)(186003)(86362001)(54906003)(2616005)(44832011)(5660300002)(7416002)(38100700002)(2906002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1Y7nk+Oa3pJ+kBLZAK4xONbYle8FDHCBJ71Ter2TR4uH5kYKF3pZKYaTNNsU?=
 =?us-ascii?Q?RIu2MYa/Ub2IVMlJH6sFYO1OiJ3bk0mBHFhhavoFAo6HsgFAQxwVEFE0edah?=
 =?us-ascii?Q?O+2WItDKjKE4Ly7Rrn0CyIZdQ9eJrIWh4S/Sk+0/SiXiP20pAoLWSsAK6EkT?=
 =?us-ascii?Q?l5jbsWQ1QTx0E2VUfKMzo/md1i3KLcMNQYqBoGWQEQo9RxejMT3Yj6ffOJIe?=
 =?us-ascii?Q?5wE+fxT5iJimb+p7je4490gL43mnAUJjbytdow0rPQ1ZaMZMkOjQnxW7Tw0T?=
 =?us-ascii?Q?WxFKfqJ6TnllMvsopOgwifq7t4OScIgA+q4yXxmqyxPSsqY+FU+0iCS3VeA0?=
 =?us-ascii?Q?NTCYDQmrR0xpoG/8YOS9+0mSQrKks/PRHOfKIUmw3ibIs7+a96wcSuuaKOjq?=
 =?us-ascii?Q?9oPAxjuilUir3X2H6U7gxxVRQnxFQH+qjE7J7SmRuvImgY47KhNlUh2GV5ZU?=
 =?us-ascii?Q?rAWUkm4727oxRZSc1grW/OYYXpp2jHWLUtdDa0OuusHamF6l2p+w+GmOLbwv?=
 =?us-ascii?Q?t2RXM2YV54rSEGUbMJW/pewUli9ibbJU/0f87xaax/bmd9sfF+UjK683IX3R?=
 =?us-ascii?Q?VaxczpH0riJyAmN3YHD48PstA2slFNglQk50fBda96d1MFrGLT3h5HotUn/R?=
 =?us-ascii?Q?MWVTJ/hh5Ei3PJs8Kp6p3p+ZbwdbX0/LFxkhOeom3AZleN+zb4rEDLXCTX4+?=
 =?us-ascii?Q?yi4hLlIKk0Cc+foaoI7cwJnLqtSZJu66MEXNo7Vc+tsFXvdNppFoIDIktUX0?=
 =?us-ascii?Q?3yzzX9CPuQWYWxD4CSXoIYn2C22Y23zashhqscausyOsAcjvFoGRHjruA+bA?=
 =?us-ascii?Q?sp6cJl4jt08v4HlodGnxAOKb13rsNGsen6nee7zMgc5/+Wo2oLDBHPtHW0w0?=
 =?us-ascii?Q?luRSZhS9j/SrcTFZbDlozu2v4ejvJe2CTsFrnlEc/Fgy+IJn+vFYJTFKgwfU?=
 =?us-ascii?Q?3tZG2GfUnUsF2JX1XUOto8QhQm9k9/jSkJ+1nPstU5H2Lo4gQnWFUzxaJPI3?=
 =?us-ascii?Q?j3DUIKBGE2GxDjzAhmoFzF+ZlZ50o1hlLHRxGC5Pba2arzFW/J4JjIXRQGzM?=
 =?us-ascii?Q?tucIagxc2ks2GmpD4YLsakRb0c7WxDv+oz/P4ssdXvxwC1lqV1WHOIRwC6gN?=
 =?us-ascii?Q?OdUPySi8YqdEV3qygPrs4N2EBzFvdBGiqkz2UoqmtxzB0uByOPGuBLtR+et0?=
 =?us-ascii?Q?2MPxIL7CMjH2MLKbhh1qXxG80DBaOWceUz66qhg0N9twYS3DZWz64qR8CJ0a?=
 =?us-ascii?Q?IUI81c7ZM0M0NhAP2NzsNBTUBcllZ4CTaxphyZVtqNqvlvBqsfGS7JOAS+TE?=
 =?us-ascii?Q?CDImZrckIT5whxvfk9H4eAxoGnShLjrOxOwNt9e3cqv6059LA+42MvNE1bKK?=
 =?us-ascii?Q?aNfrrLuSEAe9F4blLOFKQ2bSd/YjoMeFz5mHcn72tjb9aYIGUCJxa4uE8H8p?=
 =?us-ascii?Q?oQ9dd7Hlo8gYrs12bFdmABmsz1Ej7SVCV7Ia9K4nVNmjA9pQJVgW5AOIifHL?=
 =?us-ascii?Q?54y4Qt2e7lfZ2XMoLG7nSbPBpbjJUaaGPyKt+eWc07qx89TIXs7jwLY0g8tC?=
 =?us-ascii?Q?4npWHbkQCNgJ7km6WPA+ch1taguF08hX4CK1qq5I+ZazCxwJRuaA+KeX7BhV?=
 =?us-ascii?Q?D/uj3RYlMmS7zS7Rt5bTQfLLPbHK3oez/obl6eqkeM2sY8xSVas0RqTZpCDo?=
 =?us-ascii?Q?fXtzmg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09326135-ef9e-427d-2f3e-08db04674b0c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 15:16:29.3392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqUn18ofhIzb1PKrVhdVot9CNHDuPJfEvEN0nOkXl0t6aPjAuUqKBwX7ow5Ww5wy5UCPgyjcDwXXABXNco6FHWo43IGJp3q/pGMTzcfbbJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5719
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:42PM +0200, Vladimir Oltean wrote:
> The taprio offload does not currently pass the mqprio queue configuration
> down to the offloading device driver. So the driver cannot act upon the
> TXQ counts/offsets per TC, or upon the prio->tc map. It was probably
> assumed that the driver only wants to offload num_tc (see
> TC_MQPRIO_HW_OFFLOAD_TCS), which it can get from netdev_get_num_tc(),
> but there's clearly more to the mqprio configuration than that.
> 
> To remedy that, we need to actually reconstruct a struct
> tc_mqprio_qopt_offload to pass as part of the tc_taprio_qopt_offload.
> The problem is that taprio doesn't keep a persistent reference to the
> mqprio queue structure in its own struct taprio_sched, instead it just
> applies the contents of that to the netdev state (prio:tc map, per-TC
> TXQ counts and offsets, num_tc etc). Maybe it's easier to understand
> why, when we look at the size of struct tc_mqprio_qopt_offload: 352
> bytes on arm64. Keeping such a large structure would throw off the
> memory accesses in struct taprio_sched no matter where we put it.
> So we prefer to dynamically reconstruct the mqprio offload structure
> based on netdev information, rather than saving a copy of it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

