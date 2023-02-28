Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A0A6A5741
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 11:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjB1K4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 05:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjB1K4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 05:56:10 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2104.outbound.protection.outlook.com [40.107.93.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEB030195
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 02:55:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQsBt7JQTEmUEktWKig2pvGtzdVdRz+n3d95hI9NJtpH/Z6wu0mYRcipLWu6XX55AhcTfhZSm+ztZBYBokwMnxi221W545lBTpvYg6cGwrqKDQ4EiQ0rKYhHODCtwO6qp7jP88iWDI0GsNhS4aPAz7584nZxfCxJC6zx/teY7i5CCi0MsM5hkV8gMzaWmSr+8ZKXzTcTYPafu3k5276fxTr0BBv0DLWtNSt16S1g2Hq7hkrY2fvTNLyqseDBZXHVxzS1bFh3pjVCJTf7WPQtsgiD2I2yNAgJfa1hbRpZhMLfXuKu7cRj0qjOzs8RyugyCHaxt93HnVj8Dfv2Vqu+LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F344yRcDtrQ6Hod49+054daTWtdrzXTsizpSd9jxE10=;
 b=WpIssA+sUsPWXfa2uRyUhiM2W52+iyf/JfOCY4emW89V/pQF3IxgqGt4bpgIO8iXofR5fL94fQObO/NiS7N4SImIpl1Emdu3783WWWSB9K+DThTVOZlcEUuU7hGsAaoaBu8d0AVt0/BaH3PoyaB/XQGVDrOyQGTD8pG+naPwfB3cdIiyoGBV1fi0zzvF3g4KaLT2zi0m/yAkBDIlLf5I0oS7bIfiAL+M3QZPtzC3WmUPSZWbGcJAsgjOcxPTf8M6Q8QEgxrt3dnmExqm2LxubPOI/MY8R/3D4XgZ71n1ewn5nDpOWj29llSEfOZfZ83je4Qm1TnXE8P6T6iFqMgsNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F344yRcDtrQ6Hod49+054daTWtdrzXTsizpSd9jxE10=;
 b=ATYWQCQejvZrJfjwKmeQdSVmExehCb1XVchhpxLWNOFe9WqaCTETxSYDr1tT7jgXE6unm0TXW/vM+WcguDoqIWc2BDiqyYYpj7PaAvsjn6Omhk61M7r7fE31mPtm1mPYIaQxisdzvy/T+HcUMhnqGgsKlVIBeUlKFtb3i9V2VD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4977.namprd13.prod.outlook.com (2603:10b6:a03:357::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 10:55:27 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 10:55:26 +0000
Date:   Tue, 28 Feb 2023 11:55:12 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com,
        syzbot+baabf3efa7c1e57d28b2@syzkaller.appspotmail.com,
        syzbot <syzkaller@googlegroups.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net] net/sched: flower: fix fl_change() error recovery
 path
Message-ID: <Y/3dkG5lcunUnEqi@corigine.com>
References: <20230227184436.554874-1-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227184436.554874-1-edumazet@google.com>
X-ClientProxiedBy: AM3PR07CA0082.eurprd07.prod.outlook.com
 (2603:10a6:207:6::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4977:EE_
X-MS-Office365-Filtering-Correlation-Id: 480e8e0b-d617-405d-c871-08db197a4c98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AgEoLry99gex7IEuWOf8UmqjkxT6iBm+y+U2MRr0+fJSsz/xlEyS7Pp/8lNv9+DMjvDW0kzJOJbmKK9Cxyof+J4fOJqE/117dE+U/TwnCiWFspP9HiuYFJuqMWTX4Zp530TeolI2pilKADsmyROhsmnq7aB0ku30jREocGJlk/6E0OvGin53Twt1Mg6y5CGQaD/O9VxXyDPL32EYbujKpWXRydng5koBYnXievqZ9wCwCFHqAMN24GFZprKO+mGV7rgXPhR9NurTPGfbvp3qHz+Xf0XfLdJ76K0tuy/GPrYqi7gu6/T1xyWY9Dp926a7BDWdqvm9p6tukJeegVZNdjGXVP3DAEAwzaQhvVpsO1TpMOX4bRqNGU19jS3SnXM2O3kt7Gujxt9c2Z9r8486DyEJdGjyEixKwSUii3gllRY6MItc13jUYYCrC/ObSbQguh+gqrAph91CzYTeUzsLPRbzC8pzvtU1sgPqBhlZR3XNy923/cgmNTjNnl08QknX4mkrwgK+0TDhijSIjPr8qiZHiIv2ZPLUGiiTcX+BTEXKXiwc/znmJ0FWTi9xGkFOAR4HywB/cX/MwuWDhc1guNihJkudc3s3V/9lLhGG9SjoUUKffjR5OVEu8gFBGH2ADqlwt7t1HYgOSsSN1w1EihJnNCbvEbHJG+8CSH6s/HGiIJS3hGgBmSHG8J7QId1J
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(136003)(39840400004)(366004)(451199018)(36756003)(86362001)(66476007)(8676002)(66556008)(41300700001)(5660300002)(4326008)(8936002)(6916009)(66946007)(2906002)(44832011)(38100700002)(6666004)(6486002)(478600001)(54906003)(316002)(83380400001)(2616005)(6512007)(186003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rREBjPrDxlTXMt2ICfAmgh+o3PJpjDBNboBPJ8Gp3vnW1wWmD1G4SNDtrK2G?=
 =?us-ascii?Q?QJ8rP8+vUG1A4SKavtBrnQx+wBBI1p93D1CfAZo/zucHXVQMqRwyO47qIXEe?=
 =?us-ascii?Q?Vzvw3+VCnEe8/ZWI6WZzWvNZH6FnoID47HFBrGrXqlSOSkt6vv54nXk0+r5d?=
 =?us-ascii?Q?BfEV9s7vTUBDauzUhNZ42rtePMDzaxc2uLBhHkgkHAmxxONIFL88LqUSElvH?=
 =?us-ascii?Q?6vHuk0AOWOKWDg7Ru/16l4Om+nbO0hdr4d3kd6NbaaaI1fqTJqpVaiWpHYXW?=
 =?us-ascii?Q?OIjYshGl+XFKysyKbiKi6L6kGqihChCL7M5agaPfd9SOicC6nW8ZFMIwtl4l?=
 =?us-ascii?Q?kBIAfw7ZXNFgTJFeC3+MJ5MkCDiNQBjWDHQoQ6PO7axsv/KIMfI5xPcukKGN?=
 =?us-ascii?Q?Bz+HhacVcH8SyCvFxeSMv1PorDte4Rnk85KUtZ83UUQObLIIaYPS2Lk+fobb?=
 =?us-ascii?Q?gD2ob11c0PkqVZFaV2Cak8O9bqE/9c74ntStZmiNVcM+yC2TZF2u3MjAdiJL?=
 =?us-ascii?Q?og6sLrId9nW4EJjOHZkIJsy0F1Vu9R3mcj9HC5KDhSWqpYETRdk3IME0MQsu?=
 =?us-ascii?Q?wWGTksPRrzSiS0CmGamAKmVt7JO+ZEDkPR/SwEbaV1IXHO3wG0YEvVs2YOW0?=
 =?us-ascii?Q?91HbhFrJSJxgEvp/h39fz8ldDilj56UxX6j83JYD/Qzk2NVfTOlb7lNaDWsZ?=
 =?us-ascii?Q?3+zGQLX2uRJQC/+NbbydPbG9v6ZiPKXlf62Lg6H2VShktpYEf2XRgsFOOBsD?=
 =?us-ascii?Q?Sc6h0ofXcFZz/DiJbknPX82oOved33fvgAWJdhFo98sZDOvdAsbMZvAZD6lM?=
 =?us-ascii?Q?sYQZGydhRPeqTJ4c+e8WXTKt0KHuS6pzbBBM4fuHR9k2Xubs4tZhgFeKTqrI?=
 =?us-ascii?Q?nK6ZcwtAPn4+uNXl+tOiilwi8ebQ4nmYZsqq8wAaeVb/n6d8ax9VQUSTHXLB?=
 =?us-ascii?Q?q42N7kt6MG30PTdM3oOTI7Bl7j4KpIJNtw3p3zNG9r2+v0zm7zo+XlvW/4Xy?=
 =?us-ascii?Q?cQnnypljHv98GQ8ycTlTqAetIxvLT5vtsk0yvJLhG800p6/r/i5O9oa2t1t/?=
 =?us-ascii?Q?Wy+fKQWkOTFXpk0kXQ5ocyPTmLoPNt3F9cs+xl3W2gMPMq8ktFIoWVuNOdm9?=
 =?us-ascii?Q?TKaVD31cHm4Wvip9aHBKXleCVDvd4A1Mk8qkoAlUs7AuGgAzI/7X32TO+GWr?=
 =?us-ascii?Q?M0C6dYEpDFuaydoBWbmUNOh+GQjZLoysqd3TDnXNf8C4OOPZEA4+XEj5XcyN?=
 =?us-ascii?Q?+6IJPkHuQfgDkd4Vz4XZFSr2E6JvAcIWhjoJqA1jH2HfBVsw03qntQkol68+?=
 =?us-ascii?Q?QRmZ0IZCs0/YW9DWpCj5u4+o3oqT3kDlL/Y7h73jXZn0PYgvQz7KSip6GlIF?=
 =?us-ascii?Q?i6RWEDKom37YZqWREy2x4TKAICGGxaRfCjfZwlTJQjTryvMHChnCiRe5j7y3?=
 =?us-ascii?Q?6U3h4K6sPwu05+Mx1Hfxnb5/teqmbHJ4VV0Bihe3k2KE+dMhmqCTv75I/RBw?=
 =?us-ascii?Q?eQ/mNLl9uVOkAcuFMoBmjvtzJs4dgbRYPmHsNUjx0Z0gdzyLelZG2jf5pkrD?=
 =?us-ascii?Q?ECEcOrmbpNS1Bpk0RvpkTKVqjOMz8nyJN4kRt0unPEW1UmmqJuDpe6E1wmYi?=
 =?us-ascii?Q?mM4nG8c8flMmq2kXI7qfmOBjtONedBdeYpJTarcl+vgVd1qCxRgijBdUNurR?=
 =?us-ascii?Q?4/V52w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 480e8e0b-d617-405d-c871-08db197a4c98
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2023 10:55:26.8291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xLqrwBB05Geh7Iccclrw39R86n5dS34IyVQsUhxs7eE+LHldNs+uhgL+DJ2kllhk5hdbpWks6g3qgchej+dhLaDjdZMO9DkxDgi/ejJc+OM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4977
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 06:44:36PM +0000, Eric Dumazet wrote:
> The two "goto errout;" paths in fl_change() became wrong
> after cited commit.
> 
> Indeed we only must not call __fl_put() until the net pointer
> has been set in tcf_exts_init_ex()
> 
> This is a minimal fix. We might in the future validate TCA_FLOWER_FLAGS
> before we allocate @fnew.
> 
> BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:72 [inline]
> BUG: KASAN: null-ptr-deref in atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
> BUG: KASAN: null-ptr-deref in refcount_read include/linux/refcount.h:147 [inline]
> BUG: KASAN: null-ptr-deref in __refcount_add_not_zero include/linux/refcount.h:152 [inline]
> BUG: KASAN: null-ptr-deref in __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
> BUG: KASAN: null-ptr-deref in refcount_inc_not_zero include/linux/refcount.h:245 [inline]
> BUG: KASAN: null-ptr-deref in maybe_get_net include/net/net_namespace.h:269 [inline]
> BUG: KASAN: null-ptr-deref in tcf_exts_get_net include/net/pkt_cls.h:260 [inline]
> BUG: KASAN: null-ptr-deref in __fl_put net/sched/cls_flower.c:513 [inline]
> BUG: KASAN: null-ptr-deref in __fl_put+0x13e/0x3b0 net/sched/cls_flower.c:508
> Read of size 4 at addr 000000000000014c by task syz-executor548/5082
> 
> CPU: 0 PID: 5082 Comm: syz-executor548 Not tainted 6.2.0-syzkaller-05251-g5b7c4cabbb65 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0xd9/0x150 lib/dump_stack.c:106
> print_report mm/kasan/report.c:420 [inline]
> kasan_report+0xec/0x130 mm/kasan/report.c:517
> check_region_inline mm/kasan/generic.c:183 [inline]
> kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
> instrument_atomic_read include/linux/instrumented.h:72 [inline]
> atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
> refcount_read include/linux/refcount.h:147 [inline]
> __refcount_add_not_zero include/linux/refcount.h:152 [inline]
> __refcount_inc_not_zero include/linux/refcount.h:227 [inline]
> refcount_inc_not_zero include/linux/refcount.h:245 [inline]
> maybe_get_net include/net/net_namespace.h:269 [inline]
> tcf_exts_get_net include/net/pkt_cls.h:260 [inline]
> __fl_put net/sched/cls_flower.c:513 [inline]
> __fl_put+0x13e/0x3b0 net/sched/cls_flower.c:508
> fl_change+0x101b/0x4ab0 net/sched/cls_flower.c:2341
> tc_new_tfilter+0x97c/0x2290 net/sched/cls_api.c:2310
> rtnetlink_rcv_msg+0x996/0xd50 net/core/rtnetlink.c:6165
> netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2574
> netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
> netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1365
> netlink_sendmsg+0x925/0xe30 net/netlink/af_netlink.c:1942
> sock_sendmsg_nosec net/socket.c:722 [inline]
> sock_sendmsg+0xde/0x190 net/socket.c:745
> ____sys_sendmsg+0x334/0x900 net/socket.c:2504
> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2558
> __sys_sendmmsg+0x18f/0x460 net/socket.c:2644
> __do_sys_sendmmsg net/socket.c:2673 [inline]
> __se_sys_sendmmsg net/socket.c:2670 [inline]
> __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2670
> 
> Fixes: 08a0063df3ae ("net/sched: flower: Move filter handle initialization earlier")
> Reported-by: syzbot+baabf3efa7c1e57d28b2@syzkaller.appspotmail.com
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paul Blakey <paulb@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
