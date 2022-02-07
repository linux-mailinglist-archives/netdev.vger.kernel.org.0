Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078964AC0E5
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 15:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376378AbiBGOQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 09:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388570AbiBGNtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 08:49:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A176C0401C0;
        Mon,  7 Feb 2022 05:49:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B433461258;
        Mon,  7 Feb 2022 13:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEECC004E1;
        Mon,  7 Feb 2022 13:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644241772;
        bh=VjD//5GmX4HtgK0McMZ2+tZ69u0OKe5K4PhsuFpSLoM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jeqOzkD6gN0mxsHe/uCY5WZ3Wrr4+7QvGlSVPEQsAKbMeSMB9kgBLWH6UsBY2REh5
         eLlFK/85/wc2qS9COKn11IC4Xz4V89cOtXEgQ5ao1GZ11GDqpGqSP5gYjzmQRx4LlK
         d+pq6hkMlnWcQA3RjCa+JEE09Fofy/+c80nUZ0p6FMIIJVq7FQu27MTki4npopWZMx
         LIHZHI/hZMS1TtAYe6ynbGel99OR27kQZKI8AXevbOSPxDP5/m4TautOU5dhqWDotF
         xT8V1Ma4WzXm7q5HomLvjddsBzW4oHvbHHH7LXRrKfMVY2H+pSammx/l1pnFwSwykW
         l3JMtwngGeeEw==
Date:   Mon, 7 Feb 2022 15:49:26 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] net/smc: Allocate pages of SMC-R on ibdev NUMA
 node
Message-ID: <YgEjZonizb1Ugg2b@unreal>
References: <20220130190259.94593-1-tonylu@linux.alibaba.com>
 <YfeN1BfPqhVz8mvy@unreal>
 <YgDtnk8g7y5oRKXB@TonyMac-Alibaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgDtnk8g7y5oRKXB@TonyMac-Alibaba>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 05:59:58PM +0800, Tony Lu wrote:
> On Mon, Jan 31, 2022 at 09:20:52AM +0200, Leon Romanovsky wrote:
> > On Mon, Jan 31, 2022 at 03:03:00AM +0800, Tony Lu wrote:
> > > Currently, pages are allocated in the process context, for its NUMA node
> > > isn't equal to ibdev's, which is not the best policy for performance.
> > > 
> > > Applications will generally perform best when the processes are
> > > accessing memory on the same NUMA node. When numa_balancing enabled
> > > (which is enabled by most of OS distributions), it moves tasks closer to
> > > the memory of sndbuf or rmb and ibdev, meanwhile, the IRQs of ibdev bind
> > > to the same node usually. This reduces the latency when accessing remote
> > > memory.
> > 
> > It is very subjective per-specific test. I would expect that
> > application will control NUMA memory policies (set_mempolicy(), ...)
> > by itself without kernel setting NUMA node.
> > 
> > Various *_alloc_node() APIs are applicable for in-kernel allocations
> > where user can't control memory policy.
> > 
> > I don't know SMC-R enough, but if I judge from your description, this
> > allocation is controlled by the application.
> 
> The original design of SMC doesn't handle the memory allocation of
> different NUMA node, and the application can't control the NUMA policy
> in SMC.
> 
> It allocates memory according to the NUMA node based on the process
> context, which is determined by the scheduler. If application process
> runs on NUMA node 0, SMC allocates on node 0 and so on, it all depends
> on the scheduler. If RDMA device is attached to node 1, the process runs
> on node 0, it allocates memory on node 0.
> 
> This patch tries to allocate memory on the same NUMA node of RDMA
> device. Applications can't know the current node of RDMA device. The
> scheduler knows the node of memory, and can let applications run on the
> same node of memory and RDMA device.

I don't know, everything explained above is controlled through memory
policy, where application needs to run on same node as ibdev.

Thanks

> 
> Thanks,
> Tony Lu
