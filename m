Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8AA1974F2
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbgC3HLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:11:40 -0400
Received: from ja.ssi.bg ([178.16.129.10]:59798 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728489AbgC3HLk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 03:11:40 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 02U7BL0O006642;
        Mon, 30 Mar 2020 10:11:21 +0300
Date:   Mon, 30 Mar 2020 10:11:21 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next] ipvs: fix uninitialized variable warning
In-Reply-To: <1585538415-27583-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
Message-ID: <alpine.LFD.2.21.2003301006560.5190@ja.home.ssi.bg>
References: <1585538415-27583-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Mon, 30 Mar 2020, Haishuang Yan wrote:

> If outer_proto is not set, GCC warning as following:
> 
> In file included from net/netfilter/ipvs/ip_vs_core.c:52:
> net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_in_icmp':
> include/net/ip_vs.h:233:4: warning: 'outer_proto' may be used uninitialized in this function [-Wmaybe-uninitialized]
>  233 |    printk(KERN_DEBUG pr_fmt(msg), ##__VA_ARGS__); \
>      |    ^~~~~~
> net/netfilter/ipvs/ip_vs_core.c:1666:8: note: 'outer_proto' was declared here
> 1666 |  char *outer_proto;
>      |        ^~~~~~~~~~~
> 
> Fixes: 73348fed35d0 ("ipvs: optimize tunnel dumps for icmp errors")
> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

Acked-by: Julian Anastasov <ja@ssi.bg>

	Hm, my compiler does not report it: gcc version 9.1.1

> ---
>  net/netfilter/ipvs/ip_vs_core.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index d2ac530..aa6a603 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -1663,7 +1663,7 @@ static int ipvs_gre_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
>  	unsigned int offset, offset2, ihl, verdict;
>  	bool tunnel, new_cp = false;
>  	union nf_inet_addr *raddr;
> -	char *outer_proto;
> +	char *outer_proto = "IPIP";
>  
>  	*related = 1;
>  
> @@ -1723,7 +1723,6 @@ static int ipvs_gre_decap(struct netns_ipvs *ipvs, struct sk_buff *skb,
>  		if (cih == NULL)
>  			return NF_ACCEPT; /* The packet looks wrong, ignore */
>  		tunnel = true;
> -		outer_proto = "IPIP";
>  	} else if ((cih->protocol == IPPROTO_UDP ||	/* Can be UDP encap */
>  		    cih->protocol == IPPROTO_GRE) &&	/* Can be GRE encap */
>  		   /* Error for our tunnel must arrive at LOCAL_IN */
> -- 
> 1.8.3.1

Regards

--
Julian Anastasov <ja@ssi.bg>
