Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CDA48FBDF
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 10:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbiAPJAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 04:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiAPJAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 04:00:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A2AC061574;
        Sun, 16 Jan 2022 01:00:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2BD3B80D03;
        Sun, 16 Jan 2022 09:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8568C36AE3;
        Sun, 16 Jan 2022 09:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642323638;
        bh=KYRyRxbKp/rnkSYS3fen+3CDbp+21yx4utj7/mWS6Vs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EI6qShxCSx+AtkwIc8J9rd9WUVXqKOTmo+tZ89ya0w82rzWiopWhnLJbRyqlsL1e3
         TqI9otPo1yvi6kNRl1lH1Zj5ipGAsNVyiJN2MQvBjbk4Klg8DFJnjJGTwX0wefysVN
         iLjVzVHhkiNgsG/hd8oVx8cDqkWOhiWlJAoHNvkNQejCaygVDXla0CVcr4BrVpbOWY
         HDgzaxNWccGQr03vx9VJE1pvjjrxruMPFX2cW24hv9fZH+e41O3gnr1eZqGuiFxsTv
         DfRN6VVJfWlPmj+bKz/ulZWC58pbxlhoOLfe/6OuvEPVBCg1RFGFmwymxoW1BrrM6w
         v3447/6qknWmg==
Date:   Sun, 16 Jan 2022 11:00:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple
 cores
Message-ID: <YePesYRnrKCh1vFy@unreal>
References: <20220114054852.38058-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220114054852.38058-1-tonylu@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 01:48:46PM +0800, Tony Lu wrote:
> Currently, SMC creates one CQ per IB device, and shares this cq among
> all the QPs of links. Meanwhile, this CQ is always binded to the first
> completion vector, the IRQ affinity of this vector binds to some CPU
> core. 
> 
> ┌────────┐    ┌──────────────┐   ┌──────────────┐
> │ SMC IB │    ├────┐         │   │              │
> │ DEVICE │ ┌─▶│ QP │ SMC LINK├──▶│SMC Link Group│
> │   ┌────┤ │  ├────┘         │   │              │
> │   │ CQ ├─┘  └──────────────┘   └──────────────┘
> │   │    ├─┐  ┌──────────────┐   ┌──────────────┐
> │   └────┤ │  ├────┐         │   │              │
> │        │ └─▶│ QP │ SMC LINK├──▶│SMC Link Group│
> │        │    ├────┘         │   │              │
> └────────┘    └──────────────┘   └──────────────┘
> 
> In this model, when connections execeeds SMC_RMBS_PER_LGR_MAX, it will
> create multiple link groups and corresponding QPs. All the connections
> share limited QPs and one CQ (both recv and send sides). Generally, one
> completion vector binds to a fixed CPU core, it will limit the
> performance by single core, and large-scale scenes, such as multiple
> threads and lots of connections.
> 
> Running nginx and wrk test with 8 threads and 800 connections on 8 cores
> host, the softirq of CPU 0 is limited the scalability:
> 
> 04:18:54 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> 04:18:55 PM  all    5.81    0.00   19.42    0.00    2.94   10.21    0.00    0.00    0.00   61.63
> 04:18:55 PM    0    0.00    0.00    0.00    0.00   16.80   82.78    0.00    0.00    0.00    0.41
> <snip>
> 
> Nowadays, RDMA devices have more than one completion vectors, such as
> mlx5 has 8, eRDMA has 4 completion vector by default. This unlocks the
> limitation of single vector and single CPU core.
> 
> To enhance scalability and take advantage of multi-core resources, we
> can spread CQs to different CPU cores, and introduce more flexible
> mapping. Here comes up a new model, the main different is that creating
> multiple CQs per IB device, which the max number of CQs is limited by
> ibdev's ability (num_comp_vectors). In the scenen of multiple linkgroups,
> the link group's QP can bind to the least used CQ, and CQs are binded
> to different completion vector and CPU cores. So that we can spread
> the softirq (tasklet of wr tx/rx) handler to different cores.
> 
>                         ┌──────────────┐   ┌──────────────┐
> ┌────────┐  ┌───────┐   ├────┐         │   │              │
> │        ├─▶│ CQ 0  ├──▶│ QP │ SMC LINK├──▶│SMC Link Group│
> │        │  └───────┘   ├────┘         │   │              │
> │ SMC IB │  ┌───────┐   └──────────────┘   └──────────────┘
> │ DEVICE ├─▶│ CQ 1  │─┐                                    
> │        │  └───────┘ │ ┌──────────────┐   ┌──────────────┐
> │        │  ┌───────┐ │ ├────┐         │   │              │
> │        ├─▶│ CQ n  │ └▶│ QP │ SMC LINK├──▶│SMC Link Group│
> └────────┘  └───────┘   ├────┘         │   │              │
>                         └──────────────┘   └──────────────┘
> 
> After sperad one CQ (4 linkgroups) to four CPU cores, the softirq load
> spreads to different cores:
> 
> 04:26:25 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> 04:26:26 PM  all   10.70    0.00   35.80    0.00    7.64   26.62    0.00    0.00    0.00   19.24
> 04:26:26 PM    0    0.00    0.00    0.00    0.00   16.33   50.00    0.00    0.00    0.00   33.67
> 04:26:26 PM    1    0.00    0.00    0.00    0.00   15.46   69.07    0.00    0.00    0.00   15.46
> 04:26:26 PM    2    0.00    0.00    0.00    0.00   13.13   39.39    0.00    0.00    0.00   47.47
> 04:26:26 PM    3    0.00    0.00    0.00    0.00   13.27   55.10    0.00    0.00    0.00   31.63
> <snip>
> 
> Here is the benchmark with this patch (prototype of new model):
> 
> Test environment:
> - CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4.
> - nginx + wrk HTTP benchmark.
> - nginx: disable access_log, increase keepalive_timeout and
>   keepalive_requests, long-live connection.
> - wrk: 8 threads and 100, 200, 400 connections.
> 
> Benchmark result:
> 
> Conns/QPS         100        200        400
> w/o patch   338502.49  359216.66  398167.16
> w/  patch   677247.40  694193.70  812502.69
> Ratio        +100.07%    +93.25%   +104.06%
> 
> This prototype patches show nealy 1x increasement of QPS.
> 
> The benchmarkes of 100, 200, 400 connections use 1, 1, 2 link groups.
> When link group is one, it spreads send/recv to two cores. Once more
> than one link groups, it would spread to more cores.
> 
> If the application's connections is no more than link group's limitation
> (SMC_RMBS_PER_LGR_MAX, 255), and CPU resources is restricted. This patch
> introduces a tunable way to reduce the hard limitation of link group
> connections number. It reduces the restriction of less CQs (cores) and
> less competition, such as link-level CDC slots. It depends on the scenes
> of applications, so this patch provides a userspace knob, users can
> choose to share link groups for saving resources, or create more link
> groups for less limitation.
> 
> Patch 1-4 introduce multiple CQs support.
> - Patch 1 spreads CQ to two cores, it works for less connections.
> - Patch 2, 3, 4 introduce multiple CQs support, involves a new medium
>   to tie link and ibdev, and load balancing between different completion
>   vectors and CQs.
> - the policy of spreading CQs is still thinking and testing to get
>   highest performance, such as splitting recv/send CQs, or joining them
>   together, or bind recv/recv (send/send) CQ to same vector and so on.
>   Glad to hear your advice.
> 
> Patch 5 is a medium for userspace control knob.
> - mainly provide two knobs to adjust the buffer size of smc socket. We
>   found that too little buffers would let smc wait for buffer for a long
>   time, and limit the performance.
> - introduce a sysctl framework, just for tuning, netlink also does work.
>   Because sysctl is easy to compose as patch and no need userspace example.
>   I am glad to wait for your advice about the control panel for
>   userspace.
> 
> Patch 6 introduces a tunable knob to decrease the per link group
> connections' number, which would increase parallel performance as
> mentioned previous.
> 
> These patches are still improving, I am very glad to hear your advice.

Please CC RDMA mailing list next time.

Why didn't you use already existed APIs in drivers/infiniband/core/cq.c?
ib_cq_pool_get() will do most if not all of your open-coded CQ spreading
logic.

Thanks
