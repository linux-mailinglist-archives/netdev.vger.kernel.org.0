Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E3A69CEE
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 22:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732007AbfGOUkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 16:40:16 -0400
Received: from ja.ssi.bg ([178.16.129.10]:33272 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730258AbfGOUkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 16:40:16 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x6FKdqBF006984;
        Mon, 15 Jul 2019 23:39:53 +0300
Date:   Mon, 15 Jul 2019 23:39:52 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
cc:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Simon Horman <horms@verge.net.au>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [net-next 1/2] ipvs: batch __ip_vs_cleanup
In-Reply-To: <1563031186-2101-2-git-send-email-yanhaishuang@cmss.chinamobile.com>
Message-ID: <alpine.LFD.2.21.1907152333300.5700@ja.home.ssi.bg>
References: <1563031186-2101-1-git-send-email-yanhaishuang@cmss.chinamobile.com> <1563031186-2101-2-git-send-email-yanhaishuang@cmss.chinamobile.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Sat, 13 Jul 2019, Haishuang Yan wrote:

> It's better to batch __ip_vs_cleanup to speedup ipvs
> connections dismantle.
> 
> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
> ---
>  include/net/ip_vs.h             |  2 +-
>  net/netfilter/ipvs/ip_vs_core.c | 29 +++++++++++++++++------------
>  net/netfilter/ipvs/ip_vs_ctl.c  | 13 ++++++++++---
>  3 files changed, 28 insertions(+), 16 deletions(-)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 3759167..93e7a25 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -1324,7 +1324,7 @@ static inline void ip_vs_control_del(struct ip_vs_conn *cp)
>  void ip_vs_control_net_cleanup(struct netns_ipvs *ipvs);
>  void ip_vs_estimator_net_cleanup(struct netns_ipvs *ipvs);
>  void ip_vs_sync_net_cleanup(struct netns_ipvs *ipvs);
> -void ip_vs_service_net_cleanup(struct netns_ipvs *ipvs);
> +void ip_vs_service_nets_cleanup(struct list_head *net_list);
>  
>  /* IPVS application functions
>   * (from ip_vs_app.c)
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 46f06f9..b4d79b7 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -2402,18 +2402,23 @@ static int __net_init __ip_vs_init(struct net *net)
>  	return -ENOMEM;
>  }
>  
> -static void __net_exit __ip_vs_cleanup(struct net *net)
> +static void __net_exit __ip_vs_cleanup_batch(struct list_head *net_list)
>  {
> -	struct netns_ipvs *ipvs = net_ipvs(net);
> -
> -	ip_vs_service_net_cleanup(ipvs);	/* ip_vs_flush() with locks */
> -	ip_vs_conn_net_cleanup(ipvs);
> -	ip_vs_app_net_cleanup(ipvs);
> -	ip_vs_protocol_net_cleanup(ipvs);
> -	ip_vs_control_net_cleanup(ipvs);
> -	ip_vs_estimator_net_cleanup(ipvs);
> -	IP_VS_DBG(2, "ipvs netns %d released\n", ipvs->gen);
> -	net->ipvs = NULL;
> +	struct netns_ipvs *ipvs;
> +	struct net *net;
> +	LIST_HEAD(list);
> +
> +	ip_vs_service_nets_cleanup(net_list);	/* ip_vs_flush() with locks */
> +	list_for_each_entry(net, net_list, exit_list) {

	How much faster is to replace list_for_each_entry in
ops_exit_list() with this one. IPVS can waste time in calls
such as kthread_stop() and del_timer_sync() but I'm not sure
we can solve it easily. What gain do you see in benchmarks?

> +		ipvs = net_ipvs(net);
> +		ip_vs_conn_net_cleanup(ipvs);
> +		ip_vs_app_net_cleanup(ipvs);
> +		ip_vs_protocol_net_cleanup(ipvs);
> +		ip_vs_control_net_cleanup(ipvs);
> +		ip_vs_estimator_net_cleanup(ipvs);
> +		IP_VS_DBG(2, "ipvs netns %d released\n", ipvs->gen);
> +		net->ipvs = NULL;
> +	}
>  }

Regards

--
Julian Anastasov <ja@ssi.bg>
