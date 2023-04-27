Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4256F05EF
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 14:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbjD0Mja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 08:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243513AbjD0Mj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 08:39:28 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::61e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A33C2;
        Thu, 27 Apr 2023 05:39:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxQxpPlx19rxvkeEQKSqB2lhZOkXaRsRYsLenj4AvYv3D8Q2XZb3983oZHlCg4F9gFKRCRGS5xqFsnNcUQ5Fb9t7G+i67J1nLjxPTcEo86oo8AEa9aIXMBZQuYp2Ird1ovvrtukNDz3ztnh3ImG/YyYbbBL2B8tJq7ryrQBB0rzNQVWaQrbtR6Petzm+4/v7yGKD5F+TpQW8A4rQJWrwqnau2hhGb9s5UO66ppYJ7tSMWPgvdNKtN839+x56syyjJq5h3rMB4dY+nVpm9pLl20jVAp3dPSBjWKF63bok++POtPY0vk6+UlxKxIOPCw+4PcQDHdt3dsqetVDsiIWsuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZXJBImx35euvSX5tMRx77wDVP5Mrv6PnUSDn6VrJQrs=;
 b=ALV+PbqGVaQuy7uI2AxXd6g0MddC7+qU2dT4HQbGQtIs0lZHNLX5SR/qY8Si0ckPfMczLlVBl9Cd+zxOuxl46xDIqQkBBxl/sBwYCgnzzduGnG1AQKB5i1fZZ++vpDOs7o1oZR+M5Jd/qbVhrIdXPvr5bqzPd8J+JuEdcGeashw8TckQBjLdlOI+L7hqROOtNVVN9G/uQO8Ojj1bLiZD2A55SU3VGWLFd8Z1jOyouVqUtcNCB9mleFLTWFpHEdh0HnDff1Bggv/uz3+NntrU+Yd9L3ZLwv/iQDDHGOqY4V5OxRZ1yj5HtWqpvzShCP5Rj4LYqZF7CW3uhqg+EXmBug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=sina.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXJBImx35euvSX5tMRx77wDVP5Mrv6PnUSDn6VrJQrs=;
 b=I3T9cGwqxVLpSGFYD0+4Agh4fh/8AW6OkQZopNQcJsWfEd8qSObBo2jlvPP3bzrobSdyoNFvgtmerSXVJ4RjVg/GN+dowMCp7zMB3RK0qU9XqDcadgH4SJmIoq2GgKqw/ArnyxlspFjQP9YZk9ZtPrgAC8qrX08xo5KBRJL7NzdXFu/V5HVN1UD2FhMp5MLU0nIm6XmgLSvurRyd1HNcO3jVb+6Cqx+uflm2KOp5j8BQF28BcZBYXtEdiFwhS7T/jYyQk+DeAUGBN4AXfe4Sg9rqYdnCqrp3WCFismf9PxsDyDT84LE6jGY5QXa0K4BdlzC+KG0N5I+eAc+q+Q0TEg==
Received: from DS7PR03CA0124.namprd03.prod.outlook.com (2603:10b6:5:3b4::9) by
 MW3PR12MB4523.namprd12.prod.outlook.com (2603:10b6:303:5b::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.21; Thu, 27 Apr 2023 12:39:23 +0000
Received: from CY4PEPF0000B8EE.namprd05.prod.outlook.com
 (2603:10b6:5:3b4:cafe::df) by DS7PR03CA0124.outlook.office365.com
 (2603:10b6:5:3b4::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22 via Frontend
 Transport; Thu, 27 Apr 2023 12:39:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8EE.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.16 via Frontend Transport; Thu, 27 Apr 2023 12:39:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 27 Apr 2023
 05:39:10 -0700
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 27 Apr
 2023 05:39:06 -0700
References: <0000000000006cf87705f79acf1a@google.com>
 <20230328184733.6707ef73@kernel.org> <ZCOylfbhuk0LeVff@do-x1extreme>
 <b4d93f31-846f-3391-db5d-db8682ac3c34@mojatatu.com>
 <CAM0EoMn2LnhdeLcxCFdv+4YshthN=YHLnr1rvv4JoFgNS92hRA@mail.gmail.com>
 <20230417230011.GA41709@bytedance> <20230426233657.GA11249@bytedance>
User-agent: mu4e 1.8.11; emacs 28.2
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        syzbot <syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <jiri@resnulli.us>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller-bugs@googlegroups.com>,
        <xiyou.wangcong@gmail.com>, <peilin.ye@bytedance.com>,
        <hdanton@sina.com>
Subject: Re: [syzbot] [net?] KASAN: slab-use-after-free Write in
 mini_qdisc_pair_swap
Date:   Thu, 27 Apr 2023 15:26:03 +0300
In-Reply-To: <20230426233657.GA11249@bytedance>
Message-ID: <877ctxsdnb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EE:EE_|MW3PR12MB4523:EE_
X-MS-Office365-Filtering-Correlation-Id: df0c6340-d632-4c6d-bfc8-08db471c6d4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HDPt+ju1HxQCyw9fhWBNjQu8LwCSnVkyAFJSAi7Gr9WfiOneXTAeJVKT5SzqbJqCvRF953skHQMN4IqO+cClU91B0KII7inhriqsnolAmLz8nXsn0hJ3OuvJmnXjo2rX+pTDdWY3ytuO4LyB2RLm6khG9caPLpbdZ7/hEbbOnafpBCthlPh9A1+NMlB7fgkPeCcUVIIBHASlNYs9hWAB94eDyrFMN/W9RF6Zmha8HwAN96+RuzKnUA9v8rIDgy5BKKbtmnMpFXYDdtuDX6izoErhSWT4NYtoKdQINQEyk1cT1lk+lJN9KTlVBjUPl/3MiWJREofKMzj6MtqFIFTA+/3zf/uqAPJQ+XUyboCu1HgkeF45qRKZsVyMd5Zeq9fiEWdA7Dd+XjgCHWW3LacYRleQC3tExTnRJrM2vxoPYNrz+MV7s2xlVYy1ZFIi2qyAgUmp5ef72n8V3fb/STBAkHax0vO3jVPKgNZU9RVjxwjH84YTwSAfJ1o1Eap5JiqFWZcTxxksBSbVG4RZuZlzlYmCCKVNL4k/IB1qRuPTYBXHz2Bjcw0Bt7BJpyyZySC5j0yxy9Q/jPmSqckJSrlrbOd1j3suzVZwtRnVaiyaswcWpnfnhY9uGm2/GR3a8sjlW2wlFFfUyofLVc392n7lr5/S3KZjpu4RZihHFS0O5ya8xF5vXvYe+jAI0TL7zLshQht0bqTE0C+BYx439YVScaBgTnTHS6wqC8wq0HV79LURKiStd8sEWeLiHufCechmeyCJI1MXVlvUkrR86etP7w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199021)(36840700001)(40470700004)(46966006)(82310400005)(66899021)(86362001)(36756003)(40480700001)(40460700003)(54906003)(478600001)(6666004)(7696005)(966005)(8936002)(8676002)(41300700001)(356005)(7636003)(70206006)(316002)(6916009)(82740400003)(4326008)(2616005)(36860700001)(47076005)(83380400001)(426003)(186003)(16526019)(336012)(70586007)(7416002)(26005)(2906002)(5660300002)(99710200001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2023 12:39:22.0184
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df0c6340-d632-4c6d-bfc8-08db471c6d4e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4523
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peilin,

On Wed 26 Apr 2023 at 16:42, Peilin Ye <yepeilin.cs@gmail.com> wrote:
> +Cc: Vlad Buslov, Hillf Danton
>
> Hi all,
>
> On Mon, Apr 17, 2023 at 04:00:11PM -0700, Peilin Ye wrote:
>> I also reproduced this UAF using the syzkaller reproducer in the report
>> (the C reproducer did not work for me for unknown reasons).  I will look
>> into this.
>
> Currently, multiple ingress (clsact) Qdiscs can access the per-netdev
> *miniq_ingress (*miniq_egress) pointer concurrently.  This is
> unfortunately true in two senses:
>
> 1. We allow adding ingress (clsact) Qdiscs under parents other than
> TC_H_INGRESS (TC_H_CLSACT):
>
>   $ ip link add ifb0 numtxqueues 8 type ifb
>   $ echo clsact > /proc/sys/net/core/default_qdisc
>   $ tc qdisc add dev ifb0 handle 1: root mq
>   $ tc qdisc show dev ifb0
>   qdisc mq 1: root
>   qdisc clsact 0: parent 1:8
>   qdisc clsact 0: parent 1:7
>   qdisc clsact 0: parent 1:6
>   qdisc clsact 0: parent 1:5
>   qdisc clsact 0: parent 1:4
>   qdisc clsact 0: parent 1:3
>   qdisc clsact 0: parent 1:2
>   qdisc clsact 0: parent 1:1
>
> This is obviously racy and should be prohibited.  I've started working
> on patches to fix this.  The syz repro for this UAF adds ingress Qdiscs
> under TC_H_ROOT, by the way.


Hmm, didn't realize it was the case.

>
> 2. After introducing RTNL-lockless RTM_{NEW,DEL,GET}TFILTER requests
> [1], it is possible that, when replacing ingress (clsact) Qdiscs, the
> old one can access *miniq_{in,e}gress concurrently with the new one.  For
> example, the syz repro does something like the following:
>
>   Thread 1 creates sch_ingress Qdisc A (containing mini Qdisc a1 and a2),
>   then adds a cls_flower filter X to Qdisc A.
>
>   Thread 2 creates sch_ingress Qdisc B (containing mini Qdisc b1 and b2)
>   to replace Qdisc A, then adds a cls_flower filter Y to Qdisc B.
>
>   Device has 8 TXQs.
>
>  Thread 1               A's refcnt   Thread 2
>   RTM_NEWQDISC (A, locked)    
>    qdisc_create(A)               1
>    qdisc_graft(A)                9
>
>   RTM_NEWTFILTER (X, lockless)
>    __tcf_qdisc_find(A)          10
>    tcf_chain0_head_change(A)
>  ! mini_qdisc_pair_swap(A)           
>             |                        RTM_NEWQDISC (B, locked)
>             |                    2    qdisc_graft(B)
>             |                    1    notify_and_destroy(A)
>             |                                  
>             |                        RTM_NEWTFILTER (Y, lockless)
>             |                         tcf_chain0_head_change(B)
>             |                       ! mini_qdisc_pair_swap(B)
>    tcf_block_release(A)          0             |
>    qdisc_destroy(A)                            |
>    tcf_chain0_head_change_cb_del(A)            |
>  ! mini_qdisc_pair_swap(A)                     |
>             |                                  |
>            ...                                ...
>
> As we can see there're interleaving mini_qdisc_pair_swap() calls between
> Qdisc A and B, causing all kinds of troubles, including the UAF (thread
> 2 writing to mini Qdisc a1's rcu_state after Qdisc A has already been
> freed) reported by syzbot.

Great analysis! However, it is still not quite clear to me how threads 1
and 2 access each other RCU state when q->miniqp is a private memory of
the Qdisc, so 1 should only see A->miniqp and 2 only B->miniqp. And both
miniqps should be protected from deallocation by reference that lockless
RTM_NEWTFILTER obtains.

>
> To fix this, I'm cooking a patch that, when replacing ingress (clsact)
> Qdiscs, in qdisc_graft():
>
>   I.  We should make sure there's no on-the-fly lockless filter requests
>       for the old Qdisc, and return -EBUSY if there's any (or can/should
>       we wait in RTM_NEWQDISC handler?)
>
>   II. We should destory the old Qdisc before publishing the new one
>       (i.e. setting it to dev_ingress_queue(dev)->qdisc_sleeping, so
>       that subsequent filter requests can see it), because
>       {ingress,clsact}_destroy() also call mini_qdisc_pair_swap(), which
>       sets *miniq_{in,e}gress to NULL

Another approach would be to somehow detect concurrent Qdisc replace and
return -EAGAIN from tcf_chain_tp_insert() before calling
tcf_chain0_head_change(). This would leverage existing cls_api
functionality that automatically retries after releasing all references
to chain/tp and obtaining them again instead of messing with qdisc api.
However, since I still didn't fully grasp the issue it is hard for me to
reason whether such approach would be possible to implement in this
case.

>
> Future Qdiscs that support RTNL-lockless cls_ops, if any, won't need
> this fix, as long as their ->chain_head_change() don't access
> out-of-Qdisc-scope data, like pointers in struct net_device.
>
> Do you think this is the right way to go?  Thanks!
>
> [1] Thanks Hillf Danton for the hint:
>     https://syzkaller.appspot.com/text?tag=Patch&x=10d7cd5bc80000
>
> Thanks,
> Peilin Ye

