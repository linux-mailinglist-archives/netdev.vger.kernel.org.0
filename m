Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5403168783B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbjBBJFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbjBBJFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:05:47 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20717.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::717])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488F29760;
        Thu,  2 Feb 2023 01:05:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OaBjbUdCsW9Hn0WwnByutkhxyxhtMZiN6Q8tCDAQpbTD5Nfso8JIbhmXshnswJZvaeYMB59AZxE5v4P9RbQkzBB3PHATB3RV3pfiIy1kgRFGqQoiYU+gTC83rqmyL/taMp8lKu9Ws7q6c8muHJiWvf/Sz9+1yu1gYp30y0bZ+41ovikpiYm2nQ9no5WabZKFE2q2phfSP91+M/5pavuZtAP5OeXIX7rMKv7WKPXUg7aht9RFtDPuIHEuCqsVq3grte92Z8gkqxWuB3dVbIkXQ+8jWMkS8KLOP88PmqDnWHIWlNYbTxTsEI2C/2iGPF18rIg1xWz11IjTRddu/UCorw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4HW0EXn1679bQeLLICxWfrOSYg9d7k+k6WT5Dt3LY1M=;
 b=eocuc3FuYXeBTL3VI5sfvH6NHWi2VS8HUZSFktXlW3UArg6Tx4km6RGiQRilJJmfyczYRpLPcIahp83kiGLD3bGfI2wfMmWO3q27fyGtxpOFtPZflUVVid4iroCpt1oChaqr/xRELheZ05emSnIgub2J9EKksHi4UOUUMeWUk/ygLxDuzgIQMpKeEHyuc17jpan16Bh7tGudZ4UrpahH7LyC6tgWZRHD8nguio2YHJQUhvZfqrydCcli7x4+1WYCl73u1HtbzQnPb30Fa/TjZXLltX/IyBE6GsgS7rqea/8Il6utYONtjjMwx1buPf+51lntd5NyGpvl3e4D+LbIjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4HW0EXn1679bQeLLICxWfrOSYg9d7k+k6WT5Dt3LY1M=;
 b=jWEj9U69FxcRg8NCUioqxNwwVXT55e+peZdZGTHj/gtWYgjQ8wG3BZHu5tgXgIUeHegKtOAo5vnIQ7dajD5kA9CGlM7z9eY5/tBmP5ig1zj5RVAes5avpuU1WdTLRGx1mfwirOwFOvOoFXajdX4GVcfYsWarokGLUYIWJta/fe0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by BL0PR13MB4417.namprd13.prod.outlook.com (2603:10b6:208:1c5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Thu, 2 Feb
 2023 09:05:42 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::1cd0:5238:2916:882]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::1cd0:5238:2916:882%4]) with mapi id 15.20.6064.027; Thu, 2 Feb 2023
 09:05:42 +0000
Date:   Thu, 2 Feb 2023 10:05:35 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] net: openvswitch: fix flow memory leak in
 ovs_flow_cmd_new
Message-ID: <Y9t832LOl5FsC3dv@corigine.com>
References: <20230201210218.361970-1-pchelkin@ispras.ru>
 <4331E34B-4237-48D0-B4E0-016E45176FD1@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4331E34B-4237-48D0-B4E0-016E45176FD1@redhat.com>
X-ClientProxiedBy: AM9P250CA0020.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::25) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|BL0PR13MB4417:EE_
X-MS-Office365-Filtering-Correlation-Id: 6619315f-e357-4afe-6564-08db04fca923
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HWkeziKSCJMwWDAEo+FXc9XcMVj67mWYfRUqNYagY6HXQnkrmQjU7V7Eo6+8O/iiAv56nkgu8DFT9O/z84aukdqt7kKC9KSX6xnuBiydGLeEIEy89CxPEAedlofd6LguC2hNRp/H6GiwEtQVL0cva28PDhjwNJFeO6hCr/qGz30OoEe4efc8M7p4yMcyxNt9JYwAsoltb9Xts6vluo57G0DzDm6PLzeCXd7u1QnHSzJ3IklJwcGGoEC2cYzX6qzWA9I8tZqcBcsjYWjBw7h14RNUklR1eC3UfyOlCcf1k0VgnoBtmbLS+Vd/w0xTIL54KI4xHEwJQK7KUGnYdy1/GYLuFl5IT5W8iebsx0W5ooIRE8dG8PBqpBwjz8HkbWFu7SykjwxmJKST20RDdazWEeTtRIrgtGCOwSTuObAp++syvVRo2u+1/N6lJQZts9R3MSHbeNNkICTdRTRJBgzC9druxJv25gEcSB3rKAMczmAfZ8MicZY+JqF6A5kWdlpl460K9/pODhg6NdOE7WFgMBvopeQO0ty8z6QfVZ7auS8SLBbWT5JPTKW69cddlbUf1222L5pzvjN7+gjW8KDeQo6x9CeMPUFz2e4UVALqyIHjItKtreOHlgv2+OjnKba5cUctlgQtAUrnEUTn3bG7dVeKFFh6oBWJzUj4zL0cElJIAJEygxqdYZj9qIBVfMMD4KKHCdZB91PWbKhgGTi8ZDnxhjOh7DEgPCn1IxFxkBkBasDJKn2F1uFImnSfQ5sC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(366004)(376002)(396003)(346002)(136003)(451199018)(7416002)(316002)(6486002)(86362001)(478600001)(38100700002)(2616005)(6666004)(6512007)(186003)(6506007)(53546011)(5660300002)(54906003)(83380400001)(36756003)(2906002)(66476007)(66556008)(6916009)(8936002)(41300700001)(8676002)(44832011)(4326008)(66946007)(505234007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tFgo8dgjBeYSpMmXdhDPSaMWeWohFWSbILJGeAVpbISMFwL9UtSO6MIDKHUs?=
 =?us-ascii?Q?CuAdV8n8+EmkIE5mDu2/qpGRHhcoqeuN6a2Ve1uirKfYrfV8f1P793bNtkhS?=
 =?us-ascii?Q?i5CWYIswfp6U6MS1tAF3RDE4xPe88MCEYknBKsteDS4jiLhcuZ657rYH8XKV?=
 =?us-ascii?Q?i4t87cECCGEAvKmUNEA3jMsXmgYIFRQuKxHYoxsz3Nwl/1ExdZQrd1I8xlqe?=
 =?us-ascii?Q?pKNeq2xoUGuS3INqpwfCZpZ9x92+D3F43jV/MBia43PR8/ifKTdyZeDJ4fTx?=
 =?us-ascii?Q?CeajspNjHzE/49wPiDkR2pFDcqjKPPyPJsjdHH1FTnmXq7NQRpgMh+8MEnAb?=
 =?us-ascii?Q?im0+oDzQjuUSWyzThSqdLbv9NDZcGtMyt20hyqXIaZc4seb/kn4LZmDkrpY1?=
 =?us-ascii?Q?3EJRpE1tAB3QwVXYcHhpbwp1UUfy8YQQhPI1kvKyGb0VKYr2warBf9X7nfmF?=
 =?us-ascii?Q?midZ3eCSPOp7mJN79ykGCT1+GrxWxolMbwfPQjIp3uJUvog57BncZwdA4ezN?=
 =?us-ascii?Q?pJdzsVmJjsX8B/cF6esMOpJvfYZGKYj9ImLlKY/7RbhX84Zt3pwAsra49SwS?=
 =?us-ascii?Q?JuOppEw989I3Un9Pkcf35EOtxFQca2fe79Ru56GWTDcO1Sx3dp5YRwhBqO7E?=
 =?us-ascii?Q?HcCFmAoxb9s3xQ1kUFuPUBRc+vk6M8NFXkC5niliI4T43v/OYLvZjwhC1UNH?=
 =?us-ascii?Q?/b+gjFvSiwOjsxBIt3rbmf2DKo6KGxYe66kq8F9dQFtLljEWXcmpPk3e+gSK?=
 =?us-ascii?Q?Ru2NAwVsaaSpGIg63Xgxr9D1CtTaS/kqR9pwWsJurwNmScH90npsEihGMFnI?=
 =?us-ascii?Q?evOl/2xmU3VOZfi8TKYL9r8nlQ0q9Yl0m85jURZMcizE93c8gZzpTNs75YDO?=
 =?us-ascii?Q?aP9inKxRk19b73oRNbOeGam2KWYPArUDidH/oL5xgPtQth4qhafYHC1xqz/4?=
 =?us-ascii?Q?7PwtNYWcZA0023xw8SWhvcBEGa10pa5rTi8vpAXt7+Jff6Mr1EFGt8ArYfof?=
 =?us-ascii?Q?wqGwIVgTXLK7IXIA0ZmFuCaMWA+bPnpHCs71tQb0GxvYSOZEUuYqsDG8cG1P?=
 =?us-ascii?Q?Ra5HKIaWOanWemZD9QpxpF/yJogPErd8giTBsLBtsex5U3XJvPPbL8pedCZ0?=
 =?us-ascii?Q?/iT/Umv3sozRNSL2rth8LtbZHd5fEDCVK6k4vcxtx760znzakila9qvpjPMw?=
 =?us-ascii?Q?nHhILLghDw0aQQATb84pZApmFMQamA9OWTDXuxYW0W1LSCW58vSe/0uFGnZE?=
 =?us-ascii?Q?BYR7N9DytQCWT2cqDu+sdSiQ9M8Ak60qMnO4pw89YQrp31aVVQujJyapl2sF?=
 =?us-ascii?Q?Mf0L7KPk6A8pnDz3HL/E4JQQ2dAVeO2ebmAscOfpjERtfxd/o8Plb0qWkhIc?=
 =?us-ascii?Q?El7k2mrr7cZ8wqECrLaUTBc9VsgdsVYWbldI3t2aj3E5ptaXmMj4FJcdBcJU?=
 =?us-ascii?Q?ApSPGvmct7dECLHC+7KEXib9LdB6mTpFzWQjP95Z7D98XFc3eKTmjGerXdbH?=
 =?us-ascii?Q?MyiNFhPCWjBn34Wi5zGqzz5/qHSwNcdYnMFJPct+6ScRsLtnrJ3o1+VSgmOi?=
 =?us-ascii?Q?4m1FZ/EjfWsb63mKx+JTIadYvSQh1EowPDoA6pRJSG6TZRFVHU6PVAcc6XnU?=
 =?us-ascii?Q?AoGJFKcWX7eqBbAkEtID2x5QIamgtv0wu7MizTAHkJkvHaS3dXTeQz/gi8vP?=
 =?us-ascii?Q?MWcrCQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6619315f-e357-4afe-6564-08db04fca923
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 09:05:42.0714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xme6LD638rHjlpULhFjPqSL6uUuo8yathIK+OCPhQ0Le086qbAPZG5pjqkPyLqvuqTxcZFpg0QrLHdoNlU0LTJn9JXQ7DX+CvfooZRQuGZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4417
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 09:11:04AM +0100, Eelco Chaudron wrote:
> 
> 
> On 1 Feb 2023, at 22:02, Fedor Pchelkin wrote:
> 
> > Syzkaller reports a memory leak of new_flow in ovs_flow_cmd_new() as it is
> > not freed when an allocation of a key fails.
> >
> > BUG: memory leak
> > unreferenced object 0xffff888116668000 (size 632):
> >   comm "syz-executor231", pid 1090, jiffies 4294844701 (age 18.871s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<00000000defa3494>] kmem_cache_zalloc include/linux/slab.h:654 [inline]
> >     [<00000000defa3494>] ovs_flow_alloc+0x19/0x180 net/openvswitch/flow_table.c:77
> >     [<00000000c67d8873>] ovs_flow_cmd_new+0x1de/0xd40 net/openvswitch/datapath.c:957
> >     [<0000000010a539a8>] genl_family_rcv_msg_doit+0x22d/0x330 net/netlink/genetlink.c:739
> >     [<00000000dff3302d>] genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
> >     [<00000000dff3302d>] genl_rcv_msg+0x328/0x590 net/netlink/genetlink.c:800
> >     [<000000000286dd87>] netlink_rcv_skb+0x153/0x430 net/netlink/af_netlink.c:2515
> >     [<0000000061fed410>] genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
> >     [<000000009dc0f111>] netlink_unicast_kernel net/netlink/af_netlink.c:1313 [inline]
> >     [<000000009dc0f111>] netlink_unicast+0x545/0x7f0 net/netlink/af_netlink.c:1339
> >     [<000000004a5ee816>] netlink_sendmsg+0x8e7/0xde0 net/netlink/af_netlink.c:1934
> >     [<00000000482b476f>] sock_sendmsg_nosec net/socket.c:651 [inline]
> >     [<00000000482b476f>] sock_sendmsg+0x152/0x190 net/socket.c:671
> >     [<00000000698574ba>] ____sys_sendmsg+0x70a/0x870 net/socket.c:2356
> >     [<00000000d28d9e11>] ___sys_sendmsg+0xf3/0x170 net/socket.c:2410
> >     [<0000000083ba9120>] __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
> >     [<00000000c00628f8>] do_syscall_64+0x30/0x40 arch/x86/entry/common.c:46
> >     [<000000004abfdcf4>] entry_SYSCALL_64_after_hwframe+0x61/0xc6
> >
> > To fix this the patch rearranges the goto labels to reflect the order of
> > object allocations and adds appropriate goto statements on the error
> > paths.
> >
> > Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> >
> > Fixes: 68bb10101e6b ("openvswitch: Fix flow lookup to use unmasked key")
> > Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> > Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> > ---
> > v1->v2: make goto statements structured
> 
> Thanks for fixing this, the changes look good.
> 
> Acked-by: Eelco Chaudron <echaudro@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

