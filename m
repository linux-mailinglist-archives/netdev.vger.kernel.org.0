Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506AE6A0A4A
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbjBWNPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234524AbjBWNPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:15:31 -0500
Received: from out-58.mta0.migadu.com (out-58.mta0.migadu.com [91.218.175.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E153A580DB
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 05:15:04 -0800 (PST)
Message-ID: <d7b7b79b-27c5-02fe-9d8d-ead68a353d22@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677158103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sNDGBQchk0H5sRgTPwFhSsNIQ0sxPOc/Siuaj3zyXxU=;
        b=shic12fXZNTcZKgBbk/0dVSx3RS3f1OddviqKSyHB4cIQDwHWU1783nM/OTK9oqTtXrfKp
        ZAOmaFzY9Z/VOtGetcubs8lH6HbLyblMo6op13gtXs3SyBhaqBuCfAOQimgzwMjclp6YZL
        aF1fvZxhExNpxwrfbrpZhA5EiwPQENE=
Date:   Thu, 23 Feb 2023 21:14:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv3 7/8] RDMA/rxe: Add the support of net namespace notifier
To:     Zhu Yanjun <yanjun.zhu@intel.com>, jgg@ziepe.ca, leon@kernel.org,
        zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, parav@nvidia.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20230214060634.427162-1-yanjun.zhu@intel.com>
 <20230214060634.427162-8-yanjun.zhu@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20230214060634.427162-8-yanjun.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2023/2/14 14:06, Zhu Yanjun 写道:
> From: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> The functions register_pernet_subsys/unregister_pernet_subsys register a
> notifier of net namespace. When a new net namespace is created, the init
> function of rxe will be called to initialize sk4 and sk6 socks. When a
> net namespace is destroyed, the exit function will be called to handle
> sk4 and sk6 socks.
> 
> The functions rxe_ns_pernet_sk4 and rxe_ns_pernet_sk6 are used to get
> sk4 and sk6 socks.
> 
> The functions rxe_ns_pernet_set_sk4 and rxe_ns_pernet_set_sk6 are used
> to set sk4 and sk6 socks.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Add netdev@vger.kernel.org.

Zhu Yanjun
> ---
>   drivers/infiniband/sw/rxe/Makefile  |   3 +-
>   drivers/infiniband/sw/rxe/rxe.c     |   9 ++
>   drivers/infiniband/sw/rxe/rxe_net.c |  50 +++++------
>   drivers/infiniband/sw/rxe/rxe_ns.c  | 134 ++++++++++++++++++++++++++++
>   drivers/infiniband/sw/rxe/rxe_ns.h  |  17 ++++
>   5 files changed, 187 insertions(+), 26 deletions(-)
>   create mode 100644 drivers/infiniband/sw/rxe/rxe_ns.c
>   create mode 100644 drivers/infiniband/sw/rxe/rxe_ns.h
> 
> diff --git a/drivers/infiniband/sw/rxe/Makefile b/drivers/infiniband/sw/rxe/Makefile
> index 5395a581f4bb..8380f97674cb 100644
> --- a/drivers/infiniband/sw/rxe/Makefile
> +++ b/drivers/infiniband/sw/rxe/Makefile
> @@ -22,4 +22,5 @@ rdma_rxe-y := \
>   	rxe_mcast.o \
>   	rxe_task.o \
>   	rxe_net.o \
> -	rxe_hw_counters.o
> +	rxe_hw_counters.o \
> +	rxe_ns.o
> diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
> index 4a17e4a003f5..c297677bf06a 100644
> --- a/drivers/infiniband/sw/rxe/rxe.c
> +++ b/drivers/infiniband/sw/rxe/rxe.c
> @@ -9,6 +9,7 @@
>   #include "rxe.h"
>   #include "rxe_loc.h"
>   #include "rxe_net.h"
> +#include "rxe_ns.h"
>   
>   MODULE_AUTHOR("Bob Pearson, Frank Zago, John Groves, Kamal Heib");
>   MODULE_DESCRIPTION("Soft RDMA transport");
> @@ -234,6 +235,12 @@ static int __init rxe_module_init(void)
>   		return -1;
>   	}
>   
> +	err = rxe_namespace_init();
> +	if (err) {
> +		pr_err("Failed to register net namespace notifier\n");
> +		return -1;
> +	}
> +
>   	pr_info("loaded\n");
>   	return 0;
>   }
> @@ -244,6 +251,8 @@ static void __exit rxe_module_exit(void)
>   	ib_unregister_driver(RDMA_DRIVER_RXE);
>   	rxe_net_exit();
>   
> +	rxe_namespace_exit();
> +
>   	pr_info("unloaded\n");
>   }
>   
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index 9af90587642a..8135876b11f6 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -17,6 +17,7 @@
>   #include "rxe.h"
>   #include "rxe_net.h"
>   #include "rxe_loc.h"
> +#include "rxe_ns.h"
>   
>   static struct dst_entry *rxe_find_route4(struct rxe_qp *qp,
>   					 struct net_device *ndev,
> @@ -554,33 +555,30 @@ void rxe_net_del(struct ib_device *dev)
>   
>   	rdev = container_of(dev, struct rxe_dev, ib_dev);
>   
> -	rcu_read_lock();
> -	sk = udp4_lib_lookup(dev_net(rdev->ndev), 0, 0, htonl(INADDR_ANY),
> -			     htons(ROCE_V2_UDP_DPORT), 0);
> -	rcu_read_unlock();
> +	sk = rxe_ns_pernet_sk4(dev_net(rdev->ndev));
>   	if (!sk)
>   		return;
>   
> -	__sock_put(sk);
>   
> -	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL)
> +	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL) {
>   		__sock_put(sk);
> -	else
> +	} else {
>   		rxe_release_udp_tunnel(sk->sk_socket);
> +		sk = NULL;
> +		rxe_ns_pernet_set_sk4(dev_net(rdev->ndev), sk);
> +	}
>   
> -	rcu_read_lock();
> -	sk = udp6_lib_lookup(dev_net(rdev->ndev), NULL, 0, &in6addr_any,
> -			     htons(ROCE_V2_UDP_DPORT), 0);
> -	rcu_read_unlock();
> +	sk = rxe_ns_pernet_sk6(dev_net(rdev->ndev));
>   	if (!sk)
>   		return;
>   
> -	__sock_put(sk);
> -
> -	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL)
> +	if (refcount_read(&sk->sk_refcnt) > SK_REF_FOR_TUNNEL) {
>   		__sock_put(sk);
> -	else
> +	} else {
>   		rxe_release_udp_tunnel(sk->sk_socket);
> +		sk = NULL;
> +		rxe_ns_pernet_set_sk6(dev_net(rdev->ndev), sk);
> +	}
>   }
>   #undef SK_REF_FOR_TUNNEL
>   
> @@ -681,18 +679,18 @@ static int rxe_net_ipv4_init(struct net_device *ndev)
>   	struct sock *sk;
>   	struct socket *sock;
>   
> -	rcu_read_lock();
> -	sk = udp4_lib_lookup(dev_net(ndev), 0, 0, htonl(INADDR_ANY),
> -			     htons(ROCE_V2_UDP_DPORT), 0);
> -	rcu_read_unlock();
> -	if (sk)
> +	sk = rxe_ns_pernet_sk4(dev_net(ndev));
> +	if (sk) {
> +		sock_hold(sk);
>   		return 0;
> +	}
>   
>   	sock = rxe_setup_udp_tunnel(dev_net(ndev), htons(ROCE_V2_UDP_DPORT), false);
>   	if (IS_ERR(sock)) {
>   		pr_err("Failed to create IPv4 UDP tunnel\n");
>   		return -1;
>   	}
> +	rxe_ns_pernet_set_sk4(dev_net(ndev), sock->sk);
>   
>   	return 0;
>   }
> @@ -703,12 +701,11 @@ static int rxe_net_ipv6_init(struct net_device *ndev)
>   	struct sock *sk;
>   	struct socket *sock;
>   
> -	rcu_read_lock();
> -	sk = udp6_lib_lookup(dev_net(ndev), NULL, 0, &in6addr_any,
> -			     htons(ROCE_V2_UDP_DPORT), 0);
> -	rcu_read_unlock();
> -	if (sk)
> +	sk = rxe_ns_pernet_sk6(dev_net(ndev));
> +	if (sk) {
> +		sock_hold(sk);
>   		return 0;
> +	}
>   
>   	sock = rxe_setup_udp_tunnel(dev_net(ndev), htons(ROCE_V2_UDP_DPORT), true);
>   	if (PTR_ERR(sock) == -EAFNOSUPPORT) {
> @@ -720,6 +717,9 @@ static int rxe_net_ipv6_init(struct net_device *ndev)
>   		pr_err("Failed to create IPv6 UDP tunnel\n");
>   		return -1;
>   	}
> +
> +	rxe_ns_pernet_set_sk6(dev_net(ndev), sock->sk);
> +
>   #endif
>   	return 0;
>   }
> diff --git a/drivers/infiniband/sw/rxe/rxe_ns.c b/drivers/infiniband/sw/rxe/rxe_ns.c
> new file mode 100644
> index 000000000000..29d08899dcda
> --- /dev/null
> +++ b/drivers/infiniband/sw/rxe/rxe_ns.c
> @@ -0,0 +1,134 @@
> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> +/*
> + * Copyright (c) 2016 Mellanox Technologies Ltd. All rights reserved.
> + * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
> + */
> +
> +#include <net/sock.h>
> +#include <net/netns/generic.h>
> +#include <net/net_namespace.h>
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <linux/pid_namespace.h>
> +#include <net/udp_tunnel.h>
> +
> +#include "rxe_ns.h"
> +
> +/*
> + * Per network namespace data
> + */
> +struct rxe_ns_sock {
> +	struct sock __rcu *rxe_sk4;
> +	struct sock __rcu *rxe_sk6;
> +};
> +
> +/*
> + * Index to store custom data for each network namespace.
> + */
> +static unsigned int rxe_pernet_id;
> +
> +/*
> + * Called for every existing and added network namespaces
> + */
> +static int __net_init rxe_ns_init(struct net *net)
> +{
> +	/*
> +	 * create (if not present) and access data item in network namespace
> +	 * (net) using the id (net_id)
> +	 */
> +	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
> +
> +	rcu_assign_pointer(ns_sk->rxe_sk4, NULL); /* initialize sock 4 socket */
> +	rcu_assign_pointer(ns_sk->rxe_sk6, NULL); /* initialize sock 6 socket */
> +	synchronize_rcu();
> +
> +	return 0;
> +}
> +
> +static void __net_exit rxe_ns_exit(struct net *net)
> +{
> +	/*
> +	 * called when the network namespace is removed
> +	 */
> +	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
> +	struct sock *rxe_sk4 = NULL;
> +	struct sock *rxe_sk6 = NULL;
> +
> +	rcu_read_lock();
> +	rxe_sk4 = rcu_dereference(ns_sk->rxe_sk4);
> +	rxe_sk6 = rcu_dereference(ns_sk->rxe_sk6);
> +	rcu_read_unlock();
> +
> +	/* close socket */
> +	if (rxe_sk4 && rxe_sk4->sk_socket) {
> +		udp_tunnel_sock_release(rxe_sk4->sk_socket);
> +		rcu_assign_pointer(ns_sk->rxe_sk4, NULL);
> +		synchronize_rcu();
> +	}
> +
> +	if (rxe_sk6 && rxe_sk6->sk_socket) {
> +		udp_tunnel_sock_release(rxe_sk6->sk_socket);
> +		rcu_assign_pointer(ns_sk->rxe_sk6, NULL);
> +		synchronize_rcu();
> +	}
> +}
> +
> +/*
> + * callback to make the module network namespace aware
> + */
> +static struct pernet_operations rxe_net_ops __net_initdata = {
> +	.init = rxe_ns_init,
> +	.exit = rxe_ns_exit,
> +	.id = &rxe_pernet_id,
> +	.size = sizeof(struct rxe_ns_sock),
> +};
> +
> +struct sock *rxe_ns_pernet_sk4(struct net *net)
> +{
> +	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
> +	struct sock *sk;
> +
> +	rcu_read_lock();
> +	sk = rcu_dereference(ns_sk->rxe_sk4);
> +	rcu_read_unlock();
> +
> +	return sk;
> +}
> +
> +void rxe_ns_pernet_set_sk4(struct net *net, struct sock *sk)
> +{
> +	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
> +
> +	rcu_assign_pointer(ns_sk->rxe_sk4, sk);
> +	synchronize_rcu();
> +}
> +
> +struct sock *rxe_ns_pernet_sk6(struct net *net)
> +{
> +	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
> +	struct sock *sk;
> +
> +	rcu_read_lock();
> +	sk = rcu_dereference(ns_sk->rxe_sk6);
> +	rcu_read_unlock();
> +
> +	return sk;
> +}
> +
> +void rxe_ns_pernet_set_sk6(struct net *net, struct sock *sk)
> +{
> +	struct rxe_ns_sock *ns_sk = net_generic(net, rxe_pernet_id);
> +
> +	rcu_assign_pointer(ns_sk->rxe_sk6, sk);
> +	synchronize_rcu();
> +}
> +
> +int __init rxe_namespace_init(void)
> +{
> +	return register_pernet_subsys(&rxe_net_ops);
> +}
> +
> +void __exit rxe_namespace_exit(void)
> +{
> +	unregister_pernet_subsys(&rxe_net_ops);
> +}
> diff --git a/drivers/infiniband/sw/rxe/rxe_ns.h b/drivers/infiniband/sw/rxe/rxe_ns.h
> new file mode 100644
> index 000000000000..a3eac9558889
> --- /dev/null
> +++ b/drivers/infiniband/sw/rxe/rxe_ns.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
> +/*
> + * Copyright (c) 2016 Mellanox Technologies Ltd. All rights reserved.
> + * Copyright (c) 2015 System Fabric Works, Inc. All rights reserved.
> + */
> +
> +#ifndef RXE_NS_H
> +#define RXE_NS_H
> +
> +struct sock *rxe_ns_pernet_sk4(struct net *net);
> +struct sock *rxe_ns_pernet_sk6(struct net *net);
> +void rxe_ns_pernet_set_sk4(struct net *net, struct sock *sk);
> +void rxe_ns_pernet_set_sk6(struct net *net, struct sock *sk);
> +int __init rxe_namespace_init(void);
> +void __exit rxe_namespace_exit(void);
> +
> +#endif /* RXE_NS_H */

