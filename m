Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC806A0A29
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbjBWNNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbjBWNNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:13:15 -0500
Received: from out-30.mta0.migadu.com (out-30.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB4A5651A
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 05:12:39 -0800 (PST)
Message-ID: <3424b6de-bc62-b36a-2774-76bf9b8fbca3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677157955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jnrWJW+UajLTcUHzRJwig65sW/mOsFRTsBg6L7MzmKY=;
        b=eBnx9rgT0yh938WZL/h1nj/fUfD0uL+b53tBGwlWJst26giQu2C2J3kKRdN7knJk3DKfAN
        mw75YhSadAPd/uW19Hkk3lj4w53oF2sZVHdSPOYePQ9rNZ5lm6fZmIRAM1uYG6oa+Vc6K9
        NSstF2ltqtykvvqbPWIw8ytQk0gqoUw=
Date:   Thu, 23 Feb 2023 21:12:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv3 4/8] RDMA/rxe: Implement dellink in rxe
To:     Zhu Yanjun <yanjun.zhu@intel.com>, jgg@ziepe.ca, leon@kernel.org,
        zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, parav@nvidia.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20230214060634.427162-1-yanjun.zhu@intel.com>
 <20230214060634.427162-5-yanjun.zhu@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20230214060634.427162-5-yanjun.zhu@intel.com>
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
> When running "rdma link del" command, dellink function will be called.
> If the sock refcnt is greater than the refcnt needed for udp tunnel,
> the sock refcnt will be decreased by 1.
> 
> If equal, the last rdma link is removed. The udp tunnel will be
> destroyed.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Add netdev@vger.kernel.org.

Zhu Yanjun

> ---
>   drivers/infiniband/sw/rxe/rxe.c     | 12 +++++++++++-
>   drivers/infiniband/sw/rxe/rxe_net.c | 17 +++++++++++++++--
>   drivers/infiniband/sw/rxe/rxe_net.h |  1 +
>   3 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
> index 0ce6adb43cfc..ebfabc6d6b76 100644
> --- a/drivers/infiniband/sw/rxe/rxe.c
> +++ b/drivers/infiniband/sw/rxe/rxe.c
> @@ -166,10 +166,12 @@ void rxe_set_mtu(struct rxe_dev *rxe, unsigned int ndev_mtu)
>   /* called by ifc layer to create new rxe device.
>    * The caller should allocate memory for rxe by calling ib_alloc_device.
>    */
> +static struct rdma_link_ops rxe_link_ops;
>   int rxe_add(struct rxe_dev *rxe, unsigned int mtu, const char *ibdev_name)
>   {
>   	rxe_init(rxe);
>   	rxe_set_mtu(rxe, mtu);
> +	rxe->ib_dev.link_ops = &rxe_link_ops;
>   
>   	return rxe_register_device(rxe, ibdev_name);
>   }
> @@ -206,9 +208,17 @@ static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
>   	return err;
>   }
>   
> -struct rdma_link_ops rxe_link_ops = {
> +static int rxe_dellink(struct ib_device *dev)
> +{
> +	rxe_net_del(dev);
> +
> +	return 0;
> +}
> +
> +static struct rdma_link_ops rxe_link_ops = {
>   	.type = "rxe",
>   	.newlink = rxe_newlink,
> +	.dellink = rxe_dellink,
>   };
>   
>   static int __init rxe_module_init(void)
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index 3ca92e062800..4cc7de7b115b 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -530,6 +530,21 @@ int rxe_net_add(const char *ibdev_name, struct net_device *ndev)
>   	return 0;
>   }
>   
> +#define SK_REF_FOR_TUNNEL	2
> +void rxe_net_del(struct ib_device *dev)
> +{
> +	if (refcount_read(&recv_sockets.sk6->sk->sk_refcnt) > SK_REF_FOR_TUNNEL)
> +		__sock_put(recv_sockets.sk6->sk);
> +	else
> +		rxe_release_udp_tunnel(recv_sockets.sk6);
> +
> +	if (refcount_read(&recv_sockets.sk4->sk->sk_refcnt) > SK_REF_FOR_TUNNEL)
> +		__sock_put(recv_sockets.sk4->sk);
> +	else
> +		rxe_release_udp_tunnel(recv_sockets.sk4);
> +}
> +#undef SK_REF_FOR_TUNNEL
> +
>   static void rxe_port_event(struct rxe_dev *rxe,
>   			   enum ib_event_type event)
>   {
> @@ -689,8 +704,6 @@ int rxe_register_notifier(void)
>   
>   void rxe_net_exit(void)
>   {
> -	rxe_release_udp_tunnel(recv_sockets.sk6);
> -	rxe_release_udp_tunnel(recv_sockets.sk4);
>   	unregister_netdevice_notifier(&rxe_net_notifier);
>   }
>   
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.h b/drivers/infiniband/sw/rxe/rxe_net.h
> index a222c3eeae12..f48f22f3353b 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.h
> +++ b/drivers/infiniband/sw/rxe/rxe_net.h
> @@ -17,6 +17,7 @@ struct rxe_recv_sockets {
>   };
>   
>   int rxe_net_add(const char *ibdev_name, struct net_device *ndev);
> +void rxe_net_del(struct ib_device *dev);
>   
>   int rxe_register_notifier(void);
>   int rxe_net_init(void);

