Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4D5520488
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 20:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240177AbiEIS3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 14:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240122AbiEIS3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 14:29:35 -0400
X-Greylist: delayed 479 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 09 May 2022 11:25:37 PDT
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5124A1E5EFB;
        Mon,  9 May 2022 11:25:34 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 345551AD70;
        Mon,  9 May 2022 21:17:37 +0300 (EEST)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 982F01AEBC;
        Mon,  9 May 2022 21:17:35 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 18DCD3C07D1;
        Mon,  9 May 2022 21:17:31 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 249IHPlO074453;
        Mon, 9 May 2022 21:17:28 +0300
Date:   Mon, 9 May 2022 21:17:25 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     menglong8.dong@gmail.com
cc:     Simon Horman <horms@verge.net.au>, pablo@netfilter.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH net-next] net: ipvs: random start for RR scheduler
In-Reply-To: <20220509122213.19508-1-imagedong@tencent.com>
Message-ID: <cb8eaad0-83c5-a150-d830-e078682ba18b@ssi.bg>
References: <20220509122213.19508-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Mon, 9 May 2022, menglong8.dong@gmail.com wrote:

> From: Menglong Dong <imagedong@tencent.com>
> 
> For now, the start of the RR scheduler is in the order of dest
> service added, it will result in imbalance if the load balance

	...order of added destinations,...

> is done in client side and long connect is used.

	..."long connections are used". Is this a case where
small number of connections are used? And the two connections
relatively overload the real servers?

> For example, we have client1, client2, ..., client5 and real service
> service1, service2, service3. All clients have the same ipvs config,
> and each of them will create 2 long TCP connect to the virtual
> service. Therefore, all the clients will connect to service1 and
> service2, leaving service3 free.

	You mean, there are many IPVS directors with same
config and each director gets 2 connections? Third connection
will get real server #3, right ? Also, are the clients local
to the director?

> Fix this by randomize the start of dest service to RR scheduler when

	..."randomizing the starting destination when"

> IP_VS_SVC_F_SCHED_RR_RANDOM is set.
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/uapi/linux/ip_vs.h    |  2 ++
>  net/netfilter/ipvs/ip_vs_rr.c | 25 ++++++++++++++++++++++++-
>  2 files changed, 26 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
> index 4102ddcb4e14..7f74bafd3211 100644
> --- a/include/uapi/linux/ip_vs.h
> +++ b/include/uapi/linux/ip_vs.h
> @@ -28,6 +28,8 @@
>  #define IP_VS_SVC_F_SCHED_SH_FALLBACK	IP_VS_SVC_F_SCHED1 /* SH fallback */
>  #define IP_VS_SVC_F_SCHED_SH_PORT	IP_VS_SVC_F_SCHED2 /* SH use port */
>  
> +#define IP_VS_SVC_F_SCHED_RR_RANDOM	IP_VS_SVC_F_SCHED1 /* random start */
> +
>  /*
>   *      Destination Server Flags
>   */
> diff --git a/net/netfilter/ipvs/ip_vs_rr.c b/net/netfilter/ipvs/ip_vs_rr.c
> index 38495c6f6c7c..e309d97bdd08 100644
> --- a/net/netfilter/ipvs/ip_vs_rr.c
> +++ b/net/netfilter/ipvs/ip_vs_rr.c
> @@ -22,13 +22,36 @@
>  
>  #include <net/ip_vs.h>
>  
> +static void ip_vs_rr_random_start(struct ip_vs_service *svc)
> +{
> +	struct list_head *cur;
> +	u32 start;
> +
> +	if (!(svc->flags | IP_VS_SVC_F_SCHED_RR_RANDOM) ||

	| -> &

> +	    svc->num_dests <= 1)
> +		return;
> +
> +	spin_lock_bh(&svc->sched_lock);
> +	start = get_random_u32() % svc->num_dests;

	May be prandom is more appropriate for non-crypto purposes. 
Also, not sure if it is a good idea to limit the number of steps,
eg. to 128...

	start = prandom_u32_max(min(svc->num_dests, 128U));

	or just use

	start = prandom_u32_max(svc->num_dests);

	Also, this line can be before the spin_lock_bh.

> +	cur = &svc->destinations;

	cur = svc->sched_data;

	... and to start from current svc->sched_data because
we are called for every added dest. Better to jump 0..127 steps
ahead, to avoid delay with long lists?

> +	while (start--)
> +		cur = cur->next;
> +	svc->sched_data = cur;
> +	spin_unlock_bh(&svc->sched_lock);
> +}
>  
>  static int ip_vs_rr_init_svc(struct ip_vs_service *svc)
>  {
>  	svc->sched_data = &svc->destinations;
> +	ip_vs_rr_random_start(svc);
>  	return 0;
>  }
>  
> +static int ip_vs_rr_add_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest)
> +{
> +	ip_vs_rr_random_start(svc);
> +	return 0;
> +}
>  
>  static int ip_vs_rr_del_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest)
>  {
> @@ -104,7 +127,7 @@ static struct ip_vs_scheduler ip_vs_rr_scheduler = {
>  	.module =		THIS_MODULE,
>  	.n_list =		LIST_HEAD_INIT(ip_vs_rr_scheduler.n_list),
>  	.init_service =		ip_vs_rr_init_svc,
> -	.add_dest =		NULL,
> +	.add_dest =		ip_vs_rr_add_dest,
>  	.del_dest =		ip_vs_rr_del_dest,
>  	.schedule =		ip_vs_rr_schedule,
>  };
> -- 
> 2.36.0

Regards

--
Julian Anastasov <ja@ssi.bg>

