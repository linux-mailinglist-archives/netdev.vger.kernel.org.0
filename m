Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542486A0A56
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 14:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbjBWNRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 08:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbjBWNQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 08:16:58 -0500
X-Greylist: delayed 356 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Feb 2023 05:16:57 PST
Received: from out-60.mta1.migadu.com (out-60.mta1.migadu.com [IPv6:2001:41d0:203:375::3c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E01580DF
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 05:16:57 -0800 (PST)
Message-ID: <84167a74-783a-3b18-6cf1-56040a959937@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1677158215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ItEfsAfRedubPpbPHlyUfuw+bx9qD76D7JibAWu1Rw=;
        b=mKkD7uDpgpUvgQatnWONqmzkWFtsoUfn31swJfqyjAxZPMOVeBaYW35rE/cqpInG94FBy+
        2mNIjcFwHDNEX6hW0Qk1UbzMJ5mdmsg8NZehpmOrm5ZPJnRaN+P093cYhfEXZwDEJV8wtA
        FCShQ5mUaBvGaxRXQTpZhYJmYmFvDBI=
Date:   Thu, 23 Feb 2023 21:15:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv3 8/8] RDMA/rxe: Replace l_sk6 with sk6 in net namespace
To:     Zhu Yanjun <yanjun.zhu@intel.com>, jgg@ziepe.ca, leon@kernel.org,
        zyjzyj2000@gmail.com, linux-rdma@vger.kernel.org, parav@nvidia.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
References: <20230214060634.427162-1-yanjun.zhu@intel.com>
 <20230214060634.427162-9-yanjun.zhu@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20230214060634.427162-9-yanjun.zhu@intel.com>
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
> The net namespace variable sk6 can be used. As such, l_sk6 can be
> replaced with it.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Add netdev@vger.kernel.org.

Zhu Yanjun

> ---
>   drivers/infiniband/sw/rxe/rxe.c       |  1 -
>   drivers/infiniband/sw/rxe/rxe_net.c   | 20 +-------------------
>   drivers/infiniband/sw/rxe/rxe_verbs.h |  1 -
>   3 files changed, 1 insertion(+), 21 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
> index c297677bf06a..3260f598a7fb 100644
> --- a/drivers/infiniband/sw/rxe/rxe.c
> +++ b/drivers/infiniband/sw/rxe/rxe.c
> @@ -75,7 +75,6 @@ static void rxe_init_device_param(struct rxe_dev *rxe)
>   			rxe->ndev->dev_addr);
>   
>   	rxe->max_ucontext			= RXE_MAX_UCONTEXT;
> -	rxe->l_sk6				= NULL;
>   }
>   
>   /* initialize port attributes */
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index 8135876b11f6..ebcb86fa1e5e 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -50,24 +50,6 @@ static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
>   {
>   	struct dst_entry *ndst;
>   	struct flowi6 fl6 = { { 0 } };
> -	struct rxe_dev *rdev;
> -
> -	rdev = rxe_get_dev_from_net(ndev);
> -	if (!rdev->l_sk6) {
> -		struct sock *sk;
> -
> -		rcu_read_lock();
> -		sk = udp6_lib_lookup(dev_net(ndev), NULL, 0, &in6addr_any,
> -				     htons(ROCE_V2_UDP_DPORT), 0);
> -		rcu_read_unlock();
> -		if (!sk) {
> -			pr_info("file: %s +%d, error\n", __FILE__, __LINE__);
> -			return (struct dst_entry *)sk;
> -		}
> -		__sock_put(sk);
> -		rdev->l_sk6 = sk->sk_socket;
> -	}
> -
>   
>   	memset(&fl6, 0, sizeof(fl6));
>   	fl6.flowi6_oif = ndev->ifindex;
> @@ -76,7 +58,7 @@ static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
>   	fl6.flowi6_proto = IPPROTO_UDP;
>   
>   	ndst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(ndev),
> -					       rdev->l_sk6->sk, &fl6,
> +					       rxe_ns_pernet_sk6(dev_net(ndev)), &fl6,
>   					       NULL);
>   	if (IS_ERR(ndst)) {
>   		rxe_dbg_qp(qp, "no route to %pI6\n", daddr);
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
> index 52c4ef4d0305..19ddfa890480 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.h
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
> @@ -408,7 +408,6 @@ struct rxe_dev {
>   
>   	struct rxe_port		port;
>   	struct crypto_shash	*tfm;
> -	struct socket		*l_sk6;
>   };
>   
>   static inline void rxe_counter_inc(struct rxe_dev *rxe, enum rxe_counters index)

