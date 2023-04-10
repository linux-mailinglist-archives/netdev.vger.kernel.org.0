Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71936DCE4C
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 01:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjDJXxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 19:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjDJXxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 19:53:00 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2051.outbound.protection.outlook.com [40.107.13.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30FB1BD1
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 16:52:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJ0EHDzQFj7B0f7o7Hz8JyzbHqU7Zo4NeCU29n6qblmvHe6MX9W1E4nHugV6A4YIBhRgMnSuxHu7yS5lArShIr3ZAFwUkfsfajxVWgfOgfzmeq6+1LVwJ15C4vpeOPwe2qHLwkO4OpicoNAoS6b7JZy05l1ZWiPKs0mcR98rWaPcuB/d7g3Uqiih+993p6ZCqIMMwf58UFkofnxJCBT3QsL8O4lOWfu2usWYAItuvamSBsDplzc0NAyUfMpzTmKThklmWSO1FH3LL2edGLYH5YSGyni96+LS/Ux6Qg+DQ1RKjkbevN/AZW+1ZkgR8PX6QYGFf8KdB38nB27KxNG/Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9KLHoZdJ2DNE3rymqPT2fmPbq0yZohGytSTxoGFN7k=;
 b=J2zG0odTDkevOoSmwCE43f3fkDK++0AxlcPQj9ROm+m2ArGh2IcApVnGqorLB0rfUOpxGWDPLloieffmnJ5vTTjLGKGgfjeufiYnq1KPwOvaBIJ5UeePjbcapGrp/pmMcAbFA5y2q5bJDaapETLavNePFHel3SbqrNyHeGTY/0vGZLhyQ5V7ndJ7oetmywxnYT3F5c119zxlTUEsPbseztTmahZL/Ja3OAAZPOwisFfED8AJLA3BTxvZMnSpyfTnctJQeTJ5JDDfKR8m4qiWZ7xm/prxDMNy+fwZxp6wSgdroSHIsmYLFjEos/yH+6jWZAQI6izE2isW6e+3wZsy2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9KLHoZdJ2DNE3rymqPT2fmPbq0yZohGytSTxoGFN7k=;
 b=raX/r1bj4VpD0dH4r+JAj9UaKSeiszcm6736HEVp7y7+IKoTKduldtXC1UmqtzXJiY04bskCbilu8GBsc9LNIC42J1DB5jbFzr1Y3aTfCT0MiOECF3bbu1kS6IYCouISeHwub0T/XD32rD/9P+b2fUEq3+w7GzcFVPov75V8lbQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8523.eurprd04.prod.outlook.com (2603:10a6:20b:432::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 23:52:53 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Mon, 10 Apr 2023
 23:52:53 +0000
Date:   Tue, 11 Apr 2023 02:52:49 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH v2 net] net: don't omit syncing RX filters to devices
 that are down
Message-ID: <20230410235249.36uo76ivwisdx7xu@skbuf>
References: <20230410195220.1335670-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410195220.1335670-1-vladimir.oltean@nxp.com>
X-ClientProxiedBy: VI1PR0302CA0001.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::11) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8523:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a61660c-e892-4d52-369e-08db3a1eb2de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UCARRQ31B/qUSP2d4O++4DSIDAH8F4fCpm7IoRqZ60HhOq7bI8NFrFp21/wCMFbniPz4EAWUt82wrQR1Du3OmFxbVgJPCxdERmqoJnOM/7i0vdGAxd19joZB0EHSdbN94KnVJ5iI+2FK6UvolbEXXV/zcJFRlpW6IwuuzYtG6SiAm3obLjP9GGmfwiNcZexc/uABOa5tJF8/yCOCOBUNsiS+o+IG7YlQedpyCgc0PdfPzfMTFc0MlfyD4UzzmgDpeb0FforVK7B6edr++q1gcozcaBboypvalMQUM+SGVfVMmCjESWw9kHKDIkthEzG16VbrX9Xhm4HD1yfW+AACY3SnxQZY4WawzEMmafNC6BD2PzDxyrtVy+TvaBR2Fdri2fKFobc5mGHqCMp5ZUOPjQFPrCGWJKESldpLM7r7K6JiOI9rcdlbwbFmw7U21REGkDnCD+XvaH6H7wll7mTlq0eGEwezvMoynmQOqtCmbj2XjkDz622k1aU4uA311jN4Wde+ft0/BrzqgOdI6VJk+WVbhjPgmCAWupLN0N3F6UYlPKcdi4speH+6scyLC1YZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199021)(2906002)(33716001)(5660300002)(8936002)(41300700001)(66476007)(66556008)(83380400001)(4326008)(8676002)(6916009)(66946007)(6666004)(316002)(6486002)(44832011)(478600001)(54906003)(186003)(38100700002)(86362001)(1076003)(6506007)(6512007)(9686003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0LtbE8f5sePAEWUepq46nxuX28lOhRbsxE0ZNJ5SOJ1aYZ2VkxVWmjI2aSu7?=
 =?us-ascii?Q?dGNZPMsWTvuMX8s2id7YEkY53Klbjv1RJLSzftBkKVF/X+Z1l/Zo7ws6b8UU?=
 =?us-ascii?Q?OsOurXbTq3aH0rNq6Fdqu5wIeDkQYAq7TqDbiF+9TtnxmSeQeCQNUstE6ySW?=
 =?us-ascii?Q?aGXn3xz9LeXEfeG4CNk4SubR5w8t1V4i9ofeyHuD5EVnfv0X9ljM/+dvglic?=
 =?us-ascii?Q?5NNVOe+u9g8WFJwvAflMuccBeFa2ZBYVJWXrwbd59qVX7qQWS8a4cvEDfb93?=
 =?us-ascii?Q?LjjQT09giP7+j3J91ohV1iDUznIIWwr0z09lbvz5DKleNkm4dIyV2a90l1Il?=
 =?us-ascii?Q?J0Pcto6g8v/mQET9Tx5H8W052cq6OyLuVnphEBHJrshHsd32k6ldcmUfW1NE?=
 =?us-ascii?Q?HKOi2IcwMvePTQxFVwQjfCdOchJvIeYiZoamoHjZL2jRu63CYwzJ04nAgVyO?=
 =?us-ascii?Q?tyl9AeCbQVwu8H2jB7jHdNRQH9OW9/q40Uom7C1nUNrujV+gfss2uDNbKKA3?=
 =?us-ascii?Q?kBG4ItWKCWzlGLc3S3oK9LRk7RJ2BYcv04Xs4MykmFubI5cwHm0m+vsaHWVK?=
 =?us-ascii?Q?z2+d7/qJyK+8rpQzWdWCA9X+smirZMstHmafpjUYlwFMivnZP6mL9WXpViLh?=
 =?us-ascii?Q?xT4artJtnoOeAmDaYNQxKonyOeh235LRFzQ21KZCHYc5IX0IOcbtrQMtC2Mg?=
 =?us-ascii?Q?jLf7GdsQjM8TUKmCRibK1aJpDU0Z/1VK452QLJ66SM8kH8/sOIuGLXP/C/yY?=
 =?us-ascii?Q?q5aWWMjmLOAP5leOjXaJ7W2TbVc9etZRjmy7MjzxGIQE87CEAxswvJym+yLM?=
 =?us-ascii?Q?kQrie4ugSpHcSGeVFLud183Ht52tZG4Rxq23n55n/3w9J3c/4tddfFInihth?=
 =?us-ascii?Q?7SClA4n8tETEfCGWw1Vese6mlF6z4dtwlBxI8+TcOjIjhP34aj1fCDjWokLK?=
 =?us-ascii?Q?Vl9hF406azzghgRO8sFWwes/kxOnQgKLM2AfnY42W/1Hy45D6nS7CuBCvYpu?=
 =?us-ascii?Q?aTID0n/oT7SuvYQw98w4d7G3a4nGtEy6UjAhiAlWiNPHxEMu5WJAiOLoS2nd?=
 =?us-ascii?Q?pI35/zPoPsfBzh7NHnrBUO6e8MLtsQM6U1a4ykwpx7mWuchsECQYP1IVJEuA?=
 =?us-ascii?Q?a2UJcAbPfHYGxHdBq+UpcRTYKpntvjhB88yezGA7cenpv3XzxehLOfP8ETeO?=
 =?us-ascii?Q?lFUuL4g7ec9rHiwyXMT5GH5AWWQlbpA9i0dKigkVdAwDaVx+8qcvj9tDI59a?=
 =?us-ascii?Q?a1G818fsIFkSmb5Ci+sDL80sBrUNc/MaATGM7LCI3jIEVfR7iSKDIY8MZWMk?=
 =?us-ascii?Q?IvPcux4JbgaAp2KzdrYF3xTdI9aXqo23qYcAzhnEnze7qZ+oxODuyjXfNVHt?=
 =?us-ascii?Q?uF+0VTM3DBySXvogbyc21J4QjnMNMPn3mupIih9XQcfC1eRu3KHbmQYYoBWT?=
 =?us-ascii?Q?wKA8gfetVCfWixUcxiVTvVfsoElrnFeUsT2XxocbGXtU4gjWjvEteeSTeU83?=
 =?us-ascii?Q?1MojuiyVAj+2D/ypjGgIRu2WNxEdSGFeZd3Ss7B88n2wJ1hBFrK1JXJo41cL?=
 =?us-ascii?Q?dsRZa2oLO+f270Eg/RQ0RM7gVOwdExbn2nEc3mAqsNyAbpUTdV1jwrxqHt/b?=
 =?us-ascii?Q?dg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a61660c-e892-4d52-369e-08db3a1eb2de
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 23:52:52.9664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DXMlWPkk/CFujRMCAkLJ5jK5BPy001YLPXeqGFajMBgmW75GK1nc/VS6gRLsZo3qQI/+OpUiNmUpyua93IACWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8523
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 10:52:20PM +0300, Vladimir Oltean wrote:
> There are 2 possible ways to solve the issue.
> 
> Alternatively, we could remove the check/optimization and thus make
> dev_mc_del() always propagate down to the ndo_set_rx_mode() of the
> device. This would implicitly solve the IGMP/IGMP6 code paths with DSA,
> as well as any other potential issues of this kind with address deletion
> not being synced prior to device removal.

Self NACK.

After a more careful inspection of dmesg, I now notice this WARN_ON
during probe time:

[    7.710448] mscc_felix 0000:00:00.5 swp0 (uninitialized): PHY [0000:00:00.3:10] driver [Microsemi GE VSC8514 SyncE] (irq=POLL)
[    7.735401]
[    7.736921] ============================================
[    7.742266] WARNING: possible recursive locking detected
[    7.747610] 6.3.0-rc5-01277-g8ec1b4985857 #77 Not tainted
[    7.753048] --------------------------------------------
[    7.758391] kworker/u4:0/8 is trying to acquire lock:
[    7.763477] ffff5c348439a280 (_xmit_ETHER){+...}-{3:3}, at: dev_mc_add+0x40/0xa0
[    7.770991]
[    7.770991] but task is already holding lock:
[    7.776859] ffff5c34843e1280 (_xmit_ETHER){+...}-{3:3}, at: dev_mc_add+0x40/0xa0
[    7.784358]
[    7.784358] other info that might help us debug this:
[    7.790924]  Possible unsafe locking scenario:
[    7.790924]
[    7.796876]        CPU0
[    7.799340]        ----
[    7.801803]   lock(_xmit_ETHER);
[    7.805073]   lock(_xmit_ETHER);
[    7.808342]
[    7.808342]  *** DEADLOCK ***
[    7.808342]
[    7.814295]  May be due to missing lock nesting notation
[    7.814295]
[    7.821119] 7 locks held by kworker/u4:0/8:
[    7.825334]  #0: ffff5c3480007948 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x1f8/0x568
[    7.835549]  #1: ffff80000856bd58 (deferred_probe_work){+.+.}-{0:0}, at: process_one_work+0x224/0x568
[    7.844886]  #2: ffff5c34826a71c0 (&dev->mutex){....}-{4:4}, at: __device_attach+0x48/0x1a0
[    7.853358]  #3: ffffb9e51aa8db80 (dsa2_mutex){+.+.}-{4:4}, at: dsa_register_switch+0x50/0x1188
[    7.862182]  #4: ffffb9e51aa70788 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock+0x28/0x40
[    7.869956]  #5: ffff5c34843f95b0 (&idev->mc_lock){+.+.}-{4:4}, at: __ipv6_dev_mc_inc+0xa8/0x498
[    7.878864]  #6: ffff5c34843e1280 (_xmit_ETHER){+...}-{3:3}, at: dev_mc_add+0x40/0xa0
[    7.886803]
[    7.886803] stack backtrace:
[    7.891188] CPU: 1 PID: 8 Comm: kworker/u4:0 Not tainted 6.3.0-rc5-01277-g8ec1b4985857 #77
[    7.904249] Workqueue: events_unbound deferred_probe_work_func
[    7.910146] Call trace:
[    7.912611]  dump_backtrace+0x108/0x130
[    7.916486]  show_stack+0x24/0x30
[    7.919832]  dump_stack_lvl+0x60/0x80
[    7.923531]  dump_stack+0x18/0x28
[    7.926880]  __lock_acquire+0x7e8/0x2fc8
[    7.930850]  lock_acquire+0x118/0x260
[    7.934555]  _raw_spin_lock_nested+0x68/0xb0
[    7.938871]  dev_mc_add+0x40/0xa0
[    7.942218]  dsa_slave_sync_mc+0x68/0x180
[    7.946264]  __hw_addr_sync_dev+0x138/0x158
[    7.950483]  dsa_slave_set_rx_mode+0x3c/0x70
[    7.954796]  __dev_set_rx_mode+0x80/0xa0
[    7.958762]  dev_mc_add+0x74/0xa0
[    7.962109]  igmp6_group_added+0x78/0x128
[    7.966162]  __ipv6_dev_mc_inc+0x278/0x498
[    7.970299]  ipv6_dev_mc_inc+0x20/0x38
[    7.974087]  ipv6_add_dev+0x3f0/0x4d0
[    7.977791]  addrconf_notify+0x1b0/0x4a8
[    7.981757]  raw_notifier_call_chain+0x50/0x88
[    7.986254]  call_netdevice_notifiers+0x74/0xd0
[    7.990823]  register_netdevice+0x4f0/0x600
[    7.995054]  dsa_slave_create+0x3f8/0x620
[    7.999099]  dsa_port_setup+0x10c/0x158
[    8.002978]  dsa_register_switch+0xe18/0x1188
[    8.007378]  felix_pci_probe+0x120/0x1f0
[    8.011345]  pci_device_probe+0x1b0/0x278
[    8.015394]  really_probe+0x13c/0x2f8
[    8.019097]  __driver_probe_device+0xc0/0xf8
[    8.023409]  driver_probe_device+0x48/0x218
[    8.027634]  __device_attach_driver+0x128/0x158
[    8.032209]  bus_for_each_drv+0x12c/0x160
[    8.036257]  __device_attach+0xcc/0x1a0
[    8.040131]  device_initial_probe+0x20/0x38
[    8.044356]  bus_probe_device+0xa0/0x118
[    8.048316]  deferred_probe_work_func+0x98/0xe0
[    8.052890]  process_one_work+0x290/0x568
[    8.056935]  worker_thread+0x238/0x4a8
[    8.060716]  kthread+0x108/0x130
[    8.063983]  ret_from_fork+0x10/0x20

which appears to be a false positive caused by the newly opened time
window in which DSA user ports have net_devices registered, but they
aren't yet upper devices of the DSA master, so their dev->nested_level
is the same.

It seems like I will return to the targeted fix for v3, after some more
investigation here tomorrow.
