Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B43D16A0015
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 01:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbjBWAcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 19:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBWAcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 19:32:01 -0500
Received: from out-18.mta0.migadu.com (out-18.mta0.migadu.com [IPv6:2001:41d0:1004:224b::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877321C581
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 16:32:00 -0800 (PST)
Message-ID: <0f33e8d9-1643-25bf-d508-692c628c381b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677112316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fA7t017qCWaxkOJg2uoJ+VsM0SMWMXYCIbCKOk1Lea0=;
        b=vksgWrrt3lu6tLYUjbR1eJzymjpgKoDXc7e9PmMamMVpDNnmdzEiqmxytKO4F5BRKK3W1N
        4WFd5aEDmOAjXuqm5IuAB+W1YzCgQ4h/bx4h1c7NLPZ8DERNXxTj767hwo4arn8LYr0Wwd
        iLMtaAmmVy8wDhA7D6tbrxcLW6cz5rE=
Date:   Thu, 23 Feb 2023 08:31:49 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv3 0/8] Fix the problem that rxe can not work in net
 namespace
To:     Zhu Yanjun <yanjun.zhu@intel.com>, jgg@ziepe.ca, leon@kernel.org,
        zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, parav@nvidia.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20230214060634.427162-1-yanjun.zhu@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20230214060634.427162-1-yanjun.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2023/2/14 14:06, Zhu Yanjun 写道:
> From: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> When run "ip link add" command to add a rxe rdma link in a net
> namespace, normally this rxe rdma link can not work in a net
> name space.
> 
> The root cause is that a sock listening on udp port 4791 is created
> in init_net when the rdma_rxe module is loaded into kernel. That is,
> the sock listening on udp port 4791 is created in init_net. Other net
> namespace is difficult to use this sock.
> 
> The following commits will solve this problem.
> 
> In the first commit, move the creating sock listening on udp port 4791
> from module_init function to rdma link creating functions. That is,
> after the module rdma_rxe is loaded, the sock will not be created.
> When run "rdma link add ..." command, the sock will be created. So
> when creating a rdma link in the net namespace, the sock will be
> created in this net namespace.
> 
> In the second commit, the functions udp4_lib_lookup and udp6_lib_lookup
> will check the sock exists in the net namespace or not. If yes, rdma
> link will increase the reference count of this sock, then continue other
> jobs instead of creating a new sock to listen on udp port 4791. Since the
> network notifier is global, when the module rdma_rxe is loaded, this
> notifier will be registered.
> 
> After the rdma link is created, the command "rdma link del" is to
> delete rdma link at the same time the sock is checked. If the reference
> count of this sock is greater than the sock reference count needed by
> udp tunnel, the sock reference count is decreased by one. If equal, it
> indicates that this rdma link is the last one. As such, the udp tunnel
> is shut down and the sock is closed. The above work should be
> implemented in linkdel function. But currently no dellink function in
> rxe. So the 3rd commit addes dellink function pointer. And the 4th
> commit implements the dellink function in rxe.
> 
> To now, it is not necessary to keep a global variable to store the sock
> listening udp port 4791. This global variable can be replaced by the
> functions udp4_lib_lookup and udp6_lib_lookup totally. Because the
> function udp6_lib_lookup is in the fast path, a member variable l_sk6
> is added to store the sock. If l_sk6 is NULL, udp6_lib_lookup is called
> to lookup the sock, then the sock is stored in l_sk6, in the future,it
> can be used directly.
> 
> All the above work has been done in init_net. And it can also work in
> the net namespace. So the init_net is replaced by the individual net
> namespace. This is what the 6th commit does. Because rxe device is
> dependent on the net device and the sock listening on udp port 4791,
> every rxe device is in exclusive mode in the individual net namespace.
> Other rdma netns operations will be considerred in the future.
> 
> In the 7th commit, the register_pernet_subsys/unregister_pernet_subsys
> functions are added. When a new net namespace is created, the init
> function will initialize the sk4 and sk6 socks. Then the 2 socks will
> be released when the net namespace is destroyed. The functions
> rxe_ns_pernet_sk4/rxe_ns_pernet_set_sk4 will get and set sk4 in the net
> namespace. The functions rxe_ns_pernet_sk6/rxe_ns_pernet_set_sk6 will
> handle sk6. Then sk4 and sk6 are used in the previous commits.
> 
> As the sk4 and sk6 in pernet namespace can be accessed, it is not
> necessary to add a new l_sk6. As such, in the 8th commit, the l_sk6 is
> replaced with the sk6 in pernet namespace.
> 
> Test steps:
> 1) Suppose that 2 NICs are in 2 different net namespaces.
> 
>    # ip netns exec net0 ip link
>    3: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
>       link/ether 00:1e:67:a0:22:3f brd ff:ff:ff:ff:ff:ff
>       altname enp5s0
> 
>    # ip netns exec net1 ip link
>    4: eno3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel
>       link/ether f8:e4:3b:3b:e4:10 brd ff:ff:ff:ff:ff:ff
> 
> 2) Add rdma link in the different net namespace
>      net0:
>      # ip netns exec net0 rdma link add rxe0 type rxe netdev eno2
> 
>      net1:
>      # ip netns exec net1 rdma link add rxe1 type rxe netdev eno3
> 
> 3) Run rping test.
>      net0
>      # ip netns exec net0 rping -s -a 192.168.2.1 -C 1&
>      [1] 1737
>      # ip netns exec net1 rping -c -a 192.168.2.1 -d -v -C 1
>      verbose
>      count 1
>      ...
>      ping data: rdma-ping-0: ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqr
>      ...
> 
> 4) Remove the rdma links from the net namespaces.
>      net0:
>      # ip netns exec net0 ss -lu
>      State     Recv-Q    Send-Q    Local Address:Port    Peer Address:Port    Process
>      UNCONN    0         0         0.0.0.0:4791          0.0.0.0:*
>      UNCONN    0         0         [::]:4791             [::]:*
> 
>      # ip netns exec net0 rdma link del rxe0
>      
>      # ip netns exec net0 ss -lu
>      State     Recv-Q    Send-Q    Local Address:Port    Peer Address:Port    Process
>      
>      net1:
>      # ip netns exec net0 ss -lu
>      State     Recv-Q    Send-Q    Local Address:Port    Peer Address:Port    Process
>      UNCONN    0         0         0.0.0.0:4791          0.0.0.0:*
>      UNCONN    0         0         [::]:4791             [::]:*
>      
>      # ip netns exec net1 rdma link del rxe1
> 
>      # ip netns exec net0 ss -lu
>      State     Recv-Q    Send-Q    Local Address:Port    Peer Address:Port    Process
> 
> V2->V3: 1) Add "rdma link del" example in the cover letter, and use "ss -lu" to
>             verify rdma link is removed.
>          2) Add register_pernet_subsys/unregister_pernet_subsys net namespace
>          3) Replace l_sk6 with sk6 of pernet_name_space
> 
> V1->V2: Add the explicit initialization of sk6.

Add netdev@vger.kernel.org.

Zhu Yanjun

> 
> Zhu Yanjun (8):
>    RDMA/rxe: Creating listening sock in newlink function
>    RDMA/rxe: Support more rdma links in init_net
>    RDMA/nldev: Add dellink function pointer
>    RDMA/rxe: Implement dellink in rxe
>    RDMA/rxe: Replace global variable with sock lookup functions
>    RDMA/rxe: add the support of net namespace
>    RDMA/rxe: Add the support of net namespace notifier
>    RDMA/rxe: Replace l_sk6 with sk6 in net namespace
> 
>   drivers/infiniband/core/nldev.c     |   6 ++
>   drivers/infiniband/sw/rxe/Makefile  |   3 +-
>   drivers/infiniband/sw/rxe/rxe.c     |  35 +++++++-
>   drivers/infiniband/sw/rxe/rxe_net.c | 113 +++++++++++++++++-------
>   drivers/infiniband/sw/rxe/rxe_net.h |   9 +-
>   drivers/infiniband/sw/rxe/rxe_ns.c  | 128 ++++++++++++++++++++++++++++
>   drivers/infiniband/sw/rxe/rxe_ns.h  |  11 +++
>   include/rdma/rdma_netlink.h         |   2 +
>   8 files changed, 267 insertions(+), 40 deletions(-)
>   create mode 100644 drivers/infiniband/sw/rxe/rxe_ns.c
>   create mode 100644 drivers/infiniband/sw/rxe/rxe_ns.h
> 

