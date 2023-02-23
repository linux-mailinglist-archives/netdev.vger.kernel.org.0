Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2AE6A0A57
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbjBWNRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbjBWNRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:17:30 -0500
Received: from out-56.mta1.migadu.com (out-56.mta1.migadu.com [IPv6:2001:41d0:203:375::38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15E04AFD9
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 05:17:18 -0800 (PST)
Message-ID: <453d0d1a-faf5-1309-a366-631e1570fb61@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677157857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pwLZsTGh4ppEUAQxqklFuWexhm1edLuBnQhvFl2fjjE=;
        b=tWdoGj66C0PkcSF3iP6SrncgwL+/8ldtnoQM0No5sAvXsJUiZw4jk86cL3Ig++yMXVz9vC
        DJjjo7PDVj7SWOtGkuuzOwwSOq6IMUW4nuvh0lBM5/gXTDT3j7os7yAam7EKn5WnZTW0cQ
        8YkZjfQNE4+EmKJs5Mw9ug/u+Zu7fwU=
Date:   Thu, 23 Feb 2023 21:10:48 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv3 2/8] RDMA/rxe: Support more rdma links in init_net
To:     Zhu Yanjun <yanjun.zhu@intel.com>, jgg@ziepe.ca, leon@kernel.org,
        zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, parav@nvidia.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20230214060634.427162-1-yanjun.zhu@intel.com>
 <20230214060634.427162-3-yanjun.zhu@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20230214060634.427162-3-yanjun.zhu@intel.com>
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
> In init_net, when several rdma links are created with the command "rdma
> link add", newlink will check whether the udp port 4791 is listening or
> not.
> If not, creating a sock listening on udp port 4791. If yes, increasing the
> reference count of the sock.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Add netdev@vger.kernel.org.

Zhu Yanjun

> ---
>   drivers/infiniband/sw/rxe/rxe.c     | 12 ++++++-
>   drivers/infiniband/sw/rxe/rxe_net.c | 55 +++++++++++++++++++++--------
>   drivers/infiniband/sw/rxe/rxe_net.h |  1 +
>   3 files changed, 52 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
> index 64644cb0bb38..0ce6adb43cfc 100644
> --- a/drivers/infiniband/sw/rxe/rxe.c
> +++ b/drivers/infiniband/sw/rxe/rxe.c
> @@ -8,6 +8,7 @@
>   #include <net/addrconf.h>
>   #include "rxe.h"
>   #include "rxe_loc.h"
> +#include "rxe_net.h"
>   
>   MODULE_AUTHOR("Bob Pearson, Frank Zago, John Groves, Kamal Heib");
>   MODULE_DESCRIPTION("Soft RDMA transport");
> @@ -205,14 +206,23 @@ static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
>   	return err;
>   }
>   
> -static struct rdma_link_ops rxe_link_ops = {
> +struct rdma_link_ops rxe_link_ops = {
>   	.type = "rxe",
>   	.newlink = rxe_newlink,
>   };
>   
>   static int __init rxe_module_init(void)
>   {
> +	int err;
> +
>   	rdma_link_register(&rxe_link_ops);
> +
> +	err = rxe_register_notifier();
> +	if (err) {
> +		pr_err("Failed to register netdev notifier\n");
> +		return -1;
> +	}
> +
>   	pr_info("loaded\n");
>   	return 0;
>   }
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index e02e1624bcf4..3ca92e062800 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -623,13 +623,23 @@ static struct notifier_block rxe_net_notifier = {
>   
>   static int rxe_net_ipv4_init(void)
>   {
> -	recv_sockets.sk4 = rxe_setup_udp_tunnel(&init_net,
> -				htons(ROCE_V2_UDP_DPORT), false);
> -	if (IS_ERR(recv_sockets.sk4)) {
> -		recv_sockets.sk4 = NULL;
> +	struct sock *sk;
> +	struct socket *sock;
> +
> +	rcu_read_lock();
> +	sk = udp4_lib_lookup(&init_net, 0, 0, htonl(INADDR_ANY),
> +			     htons(ROCE_V2_UDP_DPORT), 0);
> +	rcu_read_unlock();
> +	if (sk)
> +		return 0;
> +
> +	sock = rxe_setup_udp_tunnel(&init_net, htons(ROCE_V2_UDP_DPORT), false);
> +	if (IS_ERR(sock)) {
>   		pr_err("Failed to create IPv4 UDP tunnel\n");
> +		recv_sockets.sk4 = NULL;
>   		return -1;
>   	}
> +	recv_sockets.sk4 = sock;
>   
>   	return 0;
>   }
> @@ -637,24 +647,46 @@ static int rxe_net_ipv4_init(void)
>   static int rxe_net_ipv6_init(void)
>   {
>   #if IS_ENABLED(CONFIG_IPV6)
> +	struct sock *sk;
> +	struct socket *sock;
> +
> +	rcu_read_lock();
> +	sk = udp6_lib_lookup(&init_net, NULL, 0, &in6addr_any,
> +			     htons(ROCE_V2_UDP_DPORT), 0);
> +	rcu_read_unlock();
> +	if (sk)
> +		return 0;
>   
> -	recv_sockets.sk6 = rxe_setup_udp_tunnel(&init_net,
> -						htons(ROCE_V2_UDP_DPORT), true);
> -	if (PTR_ERR(recv_sockets.sk6) == -EAFNOSUPPORT) {
> +	sock = rxe_setup_udp_tunnel(&init_net, htons(ROCE_V2_UDP_DPORT), true);
> +	if (PTR_ERR(sock) == -EAFNOSUPPORT) {
>   		recv_sockets.sk6 = NULL;
>   		pr_warn("IPv6 is not supported, can not create a UDPv6 socket\n");
>   		return 0;
>   	}
>   
> -	if (IS_ERR(recv_sockets.sk6)) {
> +	if (IS_ERR(sock)) {
>   		recv_sockets.sk6 = NULL;
>   		pr_err("Failed to create IPv6 UDP tunnel\n");
>   		return -1;
>   	}
> +	recv_sockets.sk6 = sock;
>   #endif
>   	return 0;
>   }
>   
> +int rxe_register_notifier(void)
> +{
> +	int err;
> +
> +	err = register_netdevice_notifier(&rxe_net_notifier);
> +	if (err) {
> +		pr_err("Failed to register netdev notifier\n");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
>   void rxe_net_exit(void)
>   {
>   	rxe_release_udp_tunnel(recv_sockets.sk6);
> @@ -666,19 +698,12 @@ int rxe_net_init(void)
>   {
>   	int err;
>   
> -	recv_sockets.sk6 = NULL;
> -
>   	err = rxe_net_ipv4_init();
>   	if (err)
>   		return err;
>   	err = rxe_net_ipv6_init();
>   	if (err)
>   		goto err_out;
> -	err = register_netdevice_notifier(&rxe_net_notifier);
> -	if (err) {
> -		pr_err("Failed to register netdev notifier\n");
> -		goto err_out;
> -	}
>   	return 0;
>   err_out:
>   	rxe_net_exit();
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.h b/drivers/infiniband/sw/rxe/rxe_net.h
> index 45d80d00f86b..a222c3eeae12 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.h
> +++ b/drivers/infiniband/sw/rxe/rxe_net.h
> @@ -18,6 +18,7 @@ struct rxe_recv_sockets {
>   
>   int rxe_net_add(const char *ibdev_name, struct net_device *ndev);
>   
> +int rxe_register_notifier(void);
>   int rxe_net_init(void);
>   void rxe_net_exit(void);
>   

