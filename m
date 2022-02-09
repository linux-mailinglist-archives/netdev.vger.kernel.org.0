Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458EF4AEBAE
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 09:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240173AbiBIIAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 03:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240203AbiBIIAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 03:00:37 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA56FC05CB80;
        Wed,  9 Feb 2022 00:00:40 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V4-I6Fo_1644393637;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V4-I6Fo_1644393637)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 16:00:37 +0800
Date:   Wed, 9 Feb 2022 16:00:34 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Stefan Raspl <raspl@linux.ibm.com>, kgraul@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/smc: Allocate pages of SMC-R on ibdev NUMA
 node
Message-ID: <YgN0ok0bJ4lc9ida@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220130190259.94593-1-tonylu@linux.alibaba.com>
 <YfeN1BfPqhVz8mvy@unreal>
 <YgDtnk8g7y5oRKXB@TonyMac-Alibaba>
 <YgEjZonizb1Ugg2b@unreal>
 <6d88abaa-62b8-c2ae-2b96-ceca6eea28e7@linux.ibm.com>
 <YgI4pz0coUJcK8WO@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgI4pz0coUJcK8WO@unreal>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 11:32:23AM +0200, Leon Romanovsky wrote:
> On Tue, Feb 08, 2022 at 10:10:55AM +0100, Stefan Raspl wrote:
> > On 2/7/22 14:49, Leon Romanovsky wrote:
> > > On Mon, Feb 07, 2022 at 05:59:58PM +0800, Tony Lu wrote:
> > > > On Mon, Jan 31, 2022 at 09:20:52AM +0200, Leon Romanovsky wrote:
> > > > > On Mon, Jan 31, 2022 at 03:03:00AM +0800, Tony Lu wrote:
> > > > > > Currently, pages are allocated in the process context, for its NUMA node
> > > > > > isn't equal to ibdev's, which is not the best policy for performance.
> > > > > > 
> > > > > > Applications will generally perform best when the processes are
> > > > > > accessing memory on the same NUMA node. When numa_balancing enabled
> > > > > > (which is enabled by most of OS distributions), it moves tasks closer to
> > > > > > the memory of sndbuf or rmb and ibdev, meanwhile, the IRQs of ibdev bind
> > > > > > to the same node usually. This reduces the latency when accessing remote
> > > > > > memory.
> > > > > 
> > > > > It is very subjective per-specific test. I would expect that
> > > > > application will control NUMA memory policies (set_mempolicy(), ...)
> > > > > by itself without kernel setting NUMA node.
> > > > > 
> > > > > Various *_alloc_node() APIs are applicable for in-kernel allocations
> > > > > where user can't control memory policy.
> > > > > 
> > > > > I don't know SMC-R enough, but if I judge from your description, this
> > > > > allocation is controlled by the application.
> > > > 
> > > > The original design of SMC doesn't handle the memory allocation of
> > > > different NUMA node, and the application can't control the NUMA policy
> > > > in SMC.
> > > > 
> > > > It allocates memory according to the NUMA node based on the process
> > > > context, which is determined by the scheduler. If application process
> > > > runs on NUMA node 0, SMC allocates on node 0 and so on, it all depends
> > > > on the scheduler. If RDMA device is attached to node 1, the process runs
> > > > on node 0, it allocates memory on node 0.
> > > > 
> > > > This patch tries to allocate memory on the same NUMA node of RDMA
> > > > device. Applications can't know the current node of RDMA device. The
> > > > scheduler knows the node of memory, and can let applications run on the
> > > > same node of memory and RDMA device.
> > > 
> > > I don't know, everything explained above is controlled through memory
> > > policy, where application needs to run on same node as ibdev.
> > 
> > The purpose of SMC-R is to provide a drop-in replacement for existing TCP/IP
> > applications. The idea is to avoid almost any modification to the
> > application, just switch the address family. So while what you say makes a
> > lot of sense for applications that intend to use RDMA, in the case of SMC-R
> > we can safely assume that most if not all applications running it assume
> > they get connectivity through a non-RDMA NIC. Hence we cannot expect the
> > applications to think about aspects such as NUMA, and we should do the right
> > thing within SMC-R.
> 
> And here comes the problem, you are doing the right thing for very
> specific and narrow use case, where application and ibdev run on
> same node. It is not true for multi-core systems as application will
> be scheduled on less load node (in very simplistic form).
> 
> In general case, the application will get CPU and memory based on scheduler
> heuristic as you don't use memory policy to restrict it. The assumption
> that allocations need to be close to ibdev and not to applications can
> lead to worse performance.
> 

Yes, the applications cannot run faster if they always access remote
memory. There are something complex in SMC, so choose to bind to the
RDMA device.

As Stefan mentioned, SMC is to provide a drop-in replacement for TCP.
SMC doesn't allocate memory for the new connection most of time, it has
linkgroup-level buffer reuse pool. The memory is only allocated during
connecting in process context or workqueue (non-blocking) if no buffer
in the beginning. Later it will reuse the buffer in the link group. The
data operations (send/recv) occurs in the following progress and wake up
by scheduler (epoll). Also, local IRQ binding can help process runs on
the node of RDMA device.

NUMA 0                | NUMA 1
// Application A      |
connect()             |
  smc_connect_rdma()  |
    smc_conn_create() |
      // create buffer|
      smc_buf_create()|
      ...             |
                      |
close()               |
  ...                 |
    // recycle buffer |
    smc_buf_unuse()   |
                      | // Application B
                      | connect()
                      |   smc_connect_rdma()
                      |     smc_conn_create()
                      |       // reuse buffer in NUMA 0
                      |       smc_buf_create()

Thanks,
Tony Lu
