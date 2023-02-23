Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358F86A0A45
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbjBWNPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234489AbjBWNPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:15:01 -0500
Received: from out-58.mta1.migadu.com (out-58.mta1.migadu.com [95.215.58.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FE14AFEC
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 05:14:28 -0800 (PST)
Message-ID: <632ac6bb-6cf7-d1c6-880b-c341bd55943c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677158049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qxNeUOEy8wU66mpIp2CnNfnoAkeOymmQPqWdtE001VA=;
        b=jqNRzwtYcTfv67jimuGlB/W7m8OPA7bBZCICvgev+y4fsy3h0PSqC8pW8KOeIEGcNFdd5M
        7G4gsOHfovFr26S6TUiJmZ4NgoCVrHk4m7bWwEAD8yoCsXUUngq4tnknEmtY3rAYNMHhPk
        mDLAE3ZZlVZTDlUYWZiJ2ulCJQqMR5U=
Date:   Thu, 23 Feb 2023 21:14:02 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv3 6/8] RDMA/rxe: add the support of net namespace
To:     Zhu Yanjun <yanjun.zhu@intel.com>, jgg@ziepe.ca, leon@kernel.org,
        zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, parav@nvidia.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20230214060634.427162-1-yanjun.zhu@intel.com>
 <20230214060634.427162-7-yanjun.zhu@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20230214060634.427162-7-yanjun.zhu@intel.com>
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
> Originally init_net is used to indicate the current net namespace.
> Currently more net namespaces are supported.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Add netdev@vger.kernel.org.

Zhu Yanjun

> ---
>   drivers/infiniband/sw/rxe/rxe.c     |  2 +-
>   drivers/infiniband/sw/rxe/rxe_net.c | 33 +++++++++++++++++------------
>   drivers/infiniband/sw/rxe/rxe_net.h |  2 +-
>   3 files changed, 22 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
> index e81c2164d77f..4a17e4a003f5 100644
> --- a/drivers/infiniband/sw/rxe/rxe.c
> +++ b/drivers/infiniband/sw/rxe/rxe.c
> @@ -196,7 +196,7 @@ static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
>   		goto err;
>   	}
>   
> -	err = rxe_net_init();
> +	err = rxe_net_init(ndev);
>   	if (err)
>   		return err;
>   
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index b56e2c32fbf7..9af90587642a 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -32,7 +32,7 @@ static struct dst_entry *rxe_find_route4(struct rxe_qp *qp,
>   	memcpy(&fl.daddr, daddr, sizeof(*daddr));
>   	fl.flowi4_proto = IPPROTO_UDP;
>   
> -	rt = ip_route_output_key(&init_net, &fl);
> +	rt = ip_route_output_key(dev_net(ndev), &fl);
>   	if (IS_ERR(rt)) {
>   		rxe_dbg_qp(qp, "no route to %pI4\n", &daddr->s_addr);
>   		return NULL;
> @@ -56,7 +56,8 @@ static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
>   		struct sock *sk;
>   
>   		rcu_read_lock();
> -		sk = udp6_lib_lookup(&init_net, NULL, 0, &in6addr_any, htons(ROCE_V2_UDP_DPORT), 0);
> +		sk = udp6_lib_lookup(dev_net(ndev), NULL, 0, &in6addr_any,
> +				     htons(ROCE_V2_UDP_DPORT), 0);
>   		rcu_read_unlock();
>   		if (!sk) {
>   			pr_info("file: %s +%d, error\n", __FILE__, __LINE__);
> @@ -549,9 +550,13 @@ int rxe_net_add(const char *ibdev_name, struct net_device *ndev)
>   void rxe_net_del(struct ib_device *dev)
>   {
>   	struct sock *sk;
> +	struct rxe_dev *rdev;
> +
> +	rdev = container_of(dev, struct rxe_dev, ib_dev);
>   
>   	rcu_read_lock();
> -	sk = udp4_lib_lookup(&init_net, 0, 0, htonl(INADDR_ANY), htons(ROCE_V2_UDP_DPORT), 0);
> +	sk = udp4_lib_lookup(dev_net(rdev->ndev), 0, 0, htonl(INADDR_ANY),
> +			     htons(ROCE_V2_UDP_DPORT), 0);
>   	rcu_read_unlock();
>   	if (!sk)
>   		return;
> @@ -564,7 +569,8 @@ void rxe_net_del(struct ib_device *dev)
>   		rxe_release_udp_tunnel(sk->sk_socket);
>   
>   	rcu_read_lock();
> -	sk = udp6_lib_lookup(&init_net, NULL, 0, &in6addr_any, htons(ROCE_V2_UDP_DPORT), 0);
> +	sk = udp6_lib_lookup(dev_net(rdev->ndev), NULL, 0, &in6addr_any,
> +			     htons(ROCE_V2_UDP_DPORT), 0);
>   	rcu_read_unlock();
>   	if (!sk)
>   		return;
> @@ -636,6 +642,7 @@ static int rxe_notify(struct notifier_block *not_blk,
>   	switch (event) {
>   	case NETDEV_UNREGISTER:
>   		ib_unregister_device_queued(&rxe->ib_dev);
> +		rxe_net_del(&rxe->ib_dev);
>   		break;
>   	case NETDEV_UP:
>   		rxe_port_up(rxe);
> @@ -669,19 +676,19 @@ static struct notifier_block rxe_net_notifier = {
>   	.notifier_call = rxe_notify,
>   };
>   
> -static int rxe_net_ipv4_init(void)
> +static int rxe_net_ipv4_init(struct net_device *ndev)
>   {
>   	struct sock *sk;
>   	struct socket *sock;
>   
>   	rcu_read_lock();
> -	sk = udp4_lib_lookup(&init_net, 0, 0, htonl(INADDR_ANY),
> +	sk = udp4_lib_lookup(dev_net(ndev), 0, 0, htonl(INADDR_ANY),
>   			     htons(ROCE_V2_UDP_DPORT), 0);
>   	rcu_read_unlock();
>   	if (sk)
>   		return 0;
>   
> -	sock = rxe_setup_udp_tunnel(&init_net, htons(ROCE_V2_UDP_DPORT), false);
> +	sock = rxe_setup_udp_tunnel(dev_net(ndev), htons(ROCE_V2_UDP_DPORT), false);
>   	if (IS_ERR(sock)) {
>   		pr_err("Failed to create IPv4 UDP tunnel\n");
>   		return -1;
> @@ -690,20 +697,20 @@ static int rxe_net_ipv4_init(void)
>   	return 0;
>   }
>   
> -static int rxe_net_ipv6_init(void)
> +static int rxe_net_ipv6_init(struct net_device *ndev)
>   {
>   #if IS_ENABLED(CONFIG_IPV6)
>   	struct sock *sk;
>   	struct socket *sock;
>   
>   	rcu_read_lock();
> -	sk = udp6_lib_lookup(&init_net, NULL, 0, &in6addr_any,
> +	sk = udp6_lib_lookup(dev_net(ndev), NULL, 0, &in6addr_any,
>   			     htons(ROCE_V2_UDP_DPORT), 0);
>   	rcu_read_unlock();
>   	if (sk)
>   		return 0;
>   
> -	sock = rxe_setup_udp_tunnel(&init_net, htons(ROCE_V2_UDP_DPORT), true);
> +	sock = rxe_setup_udp_tunnel(dev_net(ndev), htons(ROCE_V2_UDP_DPORT), true);
>   	if (PTR_ERR(sock) == -EAFNOSUPPORT) {
>   		pr_warn("IPv6 is not supported, can not create a UDPv6 socket\n");
>   		return 0;
> @@ -735,14 +742,14 @@ void rxe_net_exit(void)
>   	unregister_netdevice_notifier(&rxe_net_notifier);
>   }
>   
> -int rxe_net_init(void)
> +int rxe_net_init(struct net_device *ndev)
>   {
>   	int err;
>   
> -	err = rxe_net_ipv4_init();
> +	err = rxe_net_ipv4_init(ndev);
>   	if (err)
>   		return err;
> -	err = rxe_net_ipv6_init();
> +	err = rxe_net_ipv6_init(ndev);
>   	if (err)
>   		goto err_out;
>   	return 0;
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.h b/drivers/infiniband/sw/rxe/rxe_net.h
> index 027b20e1bab6..56249677d692 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.h
> +++ b/drivers/infiniband/sw/rxe/rxe_net.h
> @@ -15,7 +15,7 @@ int rxe_net_add(const char *ibdev_name, struct net_device *ndev);
>   void rxe_net_del(struct ib_device *dev);
>   
>   int rxe_register_notifier(void);
> -int rxe_net_init(void);
> +int rxe_net_init(struct net_device *ndev);
>   void rxe_net_exit(void);
>   
>   #endif /* RXE_NET_H */

