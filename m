Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0FA7744AF
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 07:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390371AbfGYFE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 01:04:26 -0400
Received: from ja.ssi.bg ([178.16.129.10]:54472 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390362AbfGYFE0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 01:04:26 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x6P53C2r004663;
        Thu, 25 Jul 2019 08:03:12 +0300
Date:   Thu, 25 Jul 2019 08:03:12 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Arnd Bergmann <arnd@arndb.de>
cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jacky Hu <hengqing.hu@gmail.com>,
        Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] [v2 net-next] ipvs: reduce kernel stack usage
In-Reply-To: <20190722113009.2704377-1-arnd@arndb.de>
Message-ID: <alpine.LFD.2.21.1907250742420.2292@ja.home.ssi.bg>
References: <20190722113009.2704377-1-arnd@arndb.de>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Mon, 22 Jul 2019, Arnd Bergmann wrote:

> With the new CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL option, the stack
> usage in the ipvs debug output grows because each instance of
> IP_VS_DBG_BUF() now has its own buffer of 160 bytes that add up
> rather than reusing the stack slots:
> 
> net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_sched_persist':
> net/netfilter/ipvs/ip_vs_core.c:427:1: error: the frame size of 1052 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> net/netfilter/ipvs/ip_vs_core.c: In function 'ip_vs_new_conn_out':
> net/netfilter/ipvs/ip_vs_core.c:1231:1: error: the frame size of 1048 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> net/netfilter/ipvs/ip_vs_ftp.c: In function 'ip_vs_ftp_out':
> net/netfilter/ipvs/ip_vs_ftp.c:397:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> net/netfilter/ipvs/ip_vs_ftp.c: In function 'ip_vs_ftp_in':
> net/netfilter/ipvs/ip_vs_ftp.c:555:1: error: the frame size of 1200 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> Since printk() already has a way to print IPv4/IPv6 addresses using
> the %pISc format string, use that instead, combined with a macro that
> creates a local sockaddr structure on the stack. These will still
> add up, but the stack frames are now under 200 bytes.
> 
> So far I have also only added three files that caused the warning
> messages to be reported. There are still a lot of other instances of
> IP_VS_DBG_BUF() that could be converted the same way after the
> basic idea is confirmed.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2:
>  - use compressed ipv6 format
>  - fix port number endianess

	Thanks! Some comments below...

> ---
>  include/net/ip_vs.h             | 59 ++++++++++++++++-----------------
>  net/netfilter/ipvs/ip_vs_core.c | 44 ++++++++++++------------
>  net/netfilter/ipvs/ip_vs_ftp.c  | 20 +++++------
>  3 files changed, 60 insertions(+), 63 deletions(-)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 3759167f91f5..eace4374e69f 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -227,6 +227,16 @@ static inline const char *ip_vs_dbg_addr(int af, char *buf, size_t buf_len,
>  		       sizeof(ip_vs_dbg_buf), addr,			\
>  		       &ip_vs_dbg_idx)
>  
> +#define IP_VS_DBG_SOCKADDR4(fam, addr, port)				\
> +	(struct sockaddr*)&(struct sockaddr_in)				\
> +	{ .sin_family = (fam), .sin_addr = (addr)->in, .sin_port = (port) }
> +#define IP_VS_DBG_SOCKADDR6(fam, addr, port)				\
> +	(struct sockaddr*)&(struct sockaddr_in6) \
> +	{ .sin6_family = (fam), .sin6_addr = (addr)->in6, .sin6_port = (port) }
> +#define IP_VS_DBG_SOCKADDR(fam, addr, port) (fam == AF_INET ?		\
> +			IP_VS_DBG_SOCKADDR4(fam, addr, port) :		\
> +			IP_VS_DBG_SOCKADDR6(fam, addr, port))
> +
>  #define IP_VS_DBG(level, msg, ...)					\
>  	do {								\
>  		if (level <= ip_vs_get_debug_level())			\
> @@ -251,6 +261,7 @@ static inline const char *ip_vs_dbg_addr(int af, char *buf, size_t buf_len,
>  #else	/* NO DEBUGGING at ALL */
>  #define IP_VS_DBG_BUF(level, msg...)  do {} while (0)
>  #define IP_VS_ERR_BUF(msg...)  do {} while (0)
> +#define IP_VS_DBG_SOCKADDR(fam, addr, port) NULL
>  #define IP_VS_DBG(level, msg...)  do {} while (0)
>  #define IP_VS_DBG_RL(msg...)  do {} while (0)
>  #define IP_VS_DBG_PKT(level, af, pp, skb, ofs, msg)	do {} while (0)
> @@ -1244,31 +1255,23 @@ static inline void ip_vs_control_del(struct ip_vs_conn *cp)
>  {
>  	struct ip_vs_conn *ctl_cp = cp->control;
>  	if (!ctl_cp) {
> -		IP_VS_ERR_BUF("request control DEL for uncontrolled: "
> -			      "%s:%d to %s:%d\n",
> -			      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
> -			      ntohs(cp->cport),
> -			      IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
> -			      ntohs(cp->vport));
> +		pr_err("request control DEL for uncontrolled: "
> +		       "%pISpc to %pISpcn",

	Backslash was lost

> +		       IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr, cp->cport),
> +		       IP_VS_DBG_SOCKADDR(cp->af, &cp->vaddr, cp->vport));
>  
>  		return;
>  	}
>  
> -	IP_VS_DBG_BUF(7, "DELeting control for: "
> -		      "cp.dst=%s:%d ctl_cp.dst=%s:%d\n",
> -		      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
> -		      ntohs(cp->cport),
> -		      IP_VS_DBG_ADDR(cp->af, &ctl_cp->caddr),
> -		      ntohs(ctl_cp->cport));
> +	IP_VS_DBG(7, "DELeting control for: cp.dst=%pISpc ctl_cp.dst=%pISpc\n",
> +		  IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr, cp->cport),
> +		  IP_VS_DBG_SOCKADDR(cp->af, &ctl_cp->caddr, ctl_cp->cport));
>  
>  	cp->control = NULL;
>  	if (atomic_read(&ctl_cp->n_control) == 0) {
> -		IP_VS_ERR_BUF("BUG control DEL with n=0 : "
> -			      "%s:%d to %s:%d\n",
> -			      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
> -			      ntohs(cp->cport),
> -			      IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
> -			      ntohs(cp->vport));
> +		pr_err("BUG control DEL with n=0 : %pISpc to %pISpc\n",

	We can remove the space before colon

> +		       IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr, cp->cport),
> +		       IP_VS_DBG_SOCKADDR(cp->af, &cp->vaddr, cp->vport));
>  
>  		return;
>  	}
> @@ -1279,22 +1282,18 @@ static inline void
>  ip_vs_control_add(struct ip_vs_conn *cp, struct ip_vs_conn *ctl_cp)
>  {
>  	if (cp->control) {
> -		IP_VS_ERR_BUF("request control ADD for already controlled: "
> -			      "%s:%d to %s:%d\n",
> -			      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
> -			      ntohs(cp->cport),
> -			      IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
> -			      ntohs(cp->vport));
> +		pr_err("request control ADD for already controlled: "
> +		       "%pISpc to %pISpc\n",
> +		       IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr, cp->cport),
> +		       IP_VS_DBG_SOCKADDR(cp->af, &cp->vaddr, cp->vport));
>  
>  		ip_vs_control_del(cp);
>  	}
>  
> -	IP_VS_DBG_BUF(7, "ADDing control for: "
> -		      "cp.dst=%s:%d ctl_cp.dst=%s:%d\n",
> -		      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
> -		      ntohs(cp->cport),
> -		      IP_VS_DBG_ADDR(cp->af, &ctl_cp->caddr),
> -		      ntohs(ctl_cp->cport));
> +	IP_VS_DBG(7, "ADDing control for: "
> +		  "cp.dst=%pISpc ctl_cp.dst=%pISpc\n",

	May be we can join above lines

> +		  IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr, cp->cport),
> +		  IP_VS_DBG_SOCKADDR(cp->af, &ctl_cp->caddr, ctl_cp->cport));
>  
>  	cp->control = ctl_cp;
>  	atomic_inc(&ctl_cp->n_control);
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 46f06f92ab8f..06ab0bf9ae08 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -52,7 +52,6 @@
>  #include <net/ip_vs.h>
>  #include <linux/indirect_call_wrapper.h>
>  
> -
>  EXPORT_SYMBOL(register_ip_vs_scheduler);
>  EXPORT_SYMBOL(unregister_ip_vs_scheduler);
>  EXPORT_SYMBOL(ip_vs_proto_name);
> @@ -295,11 +294,11 @@ ip_vs_sched_persist(struct ip_vs_service *svc,
>  #endif
>  		snet.ip = src_addr->ip & svc->netmask;
>  
> -	IP_VS_DBG_BUF(6, "p-schedule: src %s:%u dest %s:%u "
> -		      "mnet %s\n",
> -		      IP_VS_DBG_ADDR(svc->af, src_addr), ntohs(src_port),
> -		      IP_VS_DBG_ADDR(svc->af, dst_addr), ntohs(dst_port),
> -		      IP_VS_DBG_ADDR(svc->af, &snet));
> +	IP_VS_DBG(6, "p-schedule: src %pISpc dest %pISpc "
> +		      "mnet %pIS\n",

	Join? mnet %pISc ?

> +		      IP_VS_DBG_SOCKADDR(svc->af, src_addr, src_port),
> +		      IP_VS_DBG_SOCKADDR(svc->af, dst_addr, dst_port),
> +		      IP_VS_DBG_SOCKADDR(svc->af, &snet, 0));
>  
>  	/*
>  	 * As far as we know, FTP is a very complicated network protocol, and
> @@ -567,12 +566,12 @@ ip_vs_schedule(struct ip_vs_service *svc, struct sk_buff *skb,
>  		}
>  	}
>  
> -	IP_VS_DBG_BUF(6, "Schedule fwd:%c c:%s:%u v:%s:%u "
> -		      "d:%s:%u conn->flags:%X conn->refcnt:%d\n",
> +	IP_VS_DBG(6, "Schedule fwd:%c c:%pISpc v:%pISpc "
> +		      "d:%pISp conn->flags:%X conn->refcnt:%d\n",

	d:%pISpc

>  		      ip_vs_fwd_tag(cp),
> -		      IP_VS_DBG_ADDR(cp->af, &cp->caddr), ntohs(cp->cport),
> -		      IP_VS_DBG_ADDR(cp->af, &cp->vaddr), ntohs(cp->vport),
> -		      IP_VS_DBG_ADDR(cp->daf, &cp->daddr), ntohs(cp->dport),
> +		      IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr, cp->cport),
> +		      IP_VS_DBG_SOCKADDR(cp->af, &cp->vaddr, cp->vport),
> +		      IP_VS_DBG_SOCKADDR(cp->daf, &cp->daddr, cp->dport),
>  		      cp->flags, refcount_read(&cp->refcnt));
>  
>  	ip_vs_conn_stats(cp, svc);
> @@ -886,8 +885,8 @@ static int handle_response_icmp(int af, struct sk_buff *skb,
>  	/* Ensure the checksum is correct */
>  	if (!skb_csum_unnecessary(skb) && ip_vs_checksum_complete(skb, ihl)) {
>  		/* Failed checksum! */
> -		IP_VS_DBG_BUF(1, "Forward ICMP: failed checksum from %s!\n",
> -			      IP_VS_DBG_ADDR(af, snet));
> +		IP_VS_DBG(1, "Forward ICMP: failed checksum from %pISc!\n",
> +			      IP_VS_DBG_SOCKADDR(af, snet, 0));
>  		goto out;
>  	}
>  
> @@ -1220,13 +1219,13 @@ struct ip_vs_conn *ip_vs_new_conn_out(struct ip_vs_service *svc,
>  	ip_vs_conn_stats(cp, svc);
>  
>  	/* return connection (will be used to handle outgoing packet) */
> -	IP_VS_DBG_BUF(6, "New connection RS-initiated:%c c:%s:%u v:%s:%u "
> -		      "d:%s:%u conn->flags:%X conn->refcnt:%d\n",
> -		      ip_vs_fwd_tag(cp),
> -		      IP_VS_DBG_ADDR(cp->af, &cp->caddr), ntohs(cp->cport),
> -		      IP_VS_DBG_ADDR(cp->af, &cp->vaddr), ntohs(cp->vport),
> -		      IP_VS_DBG_ADDR(cp->af, &cp->daddr), ntohs(cp->dport),
> -		      cp->flags, refcount_read(&cp->refcnt));
> +	IP_VS_DBG(6, "New connection RS-initiated:%c c:%pISpc v:%pISpc "
> +		  "d:%pISp conn->flags:%X conn->refcnt:%d\n",

	d:%pISpc

> +		  ip_vs_fwd_tag(cp),
> +		  IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr, cp->cport),
> +		  IP_VS_DBG_SOCKADDR(cp->af, &cp->vaddr, cp->vport),
> +		  IP_VS_DBG_SOCKADDR(cp->af, &cp->daddr, cp->dport),
> +		  cp->flags, refcount_read(&cp->refcnt));
>  	LeaveFunction(12);
>  	return cp;
>  }
> @@ -1969,7 +1968,6 @@ static int ip_vs_in_icmp_v6(struct netns_ipvs *ipvs, struct sk_buff *skb,
>  }
>  #endif
>  
> -
>  /*
>   *	Check if it's for virtual services, look it up,
>   *	and send it on its way...
> @@ -1998,10 +1996,10 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
>  		      hooknum != NF_INET_LOCAL_OUT) ||
>  		     !skb_dst(skb))) {
>  		ip_vs_fill_iph_skb(af, skb, false, &iph);
> -		IP_VS_DBG_BUF(12, "packet type=%d proto=%d daddr=%s"
> +		IP_VS_DBG(12, "packet type=%d proto=%d daddr=%pISc"
>  			      " ignored in hook %u\n",
>  			      skb->pkt_type, iph.protocol,
> -			      IP_VS_DBG_ADDR(af, &iph.daddr), hooknum);
> +			      IP_VS_DBG_SOCKADDR(af, &iph.daddr, 0), hooknum);
>  		return NF_ACCEPT;
>  	}
>  	/* ipvs enabled in this netns ? */
> diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
> index cf925906f59b..22099c42e184 100644
> --- a/net/netfilter/ipvs/ip_vs_ftp.c
> +++ b/net/netfilter/ipvs/ip_vs_ftp.c
> @@ -306,9 +306,9 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
>  					   &start, &end) != 1)
>  			return 1;
>  
> -		IP_VS_DBG_BUF(7, "EPSV response (%s:%u) -> %s:%u detected\n",
> -			      IP_VS_DBG_ADDR(cp->af, &from), ntohs(port),
> -			      IP_VS_DBG_ADDR(cp->af, &cp->caddr), 0);
> +		IP_VS_DBG(7, "EPSV response (%pISpc) -> %pISc detected\n",
> +			  IP_VS_DBG_SOCKADDR(cp->af, &from, port),
> +			  IP_VS_DBG_SOCKADDR(cp->af, &cp->caddr, 0));
>  	} else {
>  		return 1;
>  	}
> @@ -510,15 +510,15 @@ static int ip_vs_ftp_in(struct ip_vs_app *app, struct ip_vs_conn *cp,
>  					  &to, &port, cp->af,
>  					  &start, &end) == 1) {
>  
> -		IP_VS_DBG_BUF(7, "EPRT %s:%u detected\n",
> -			      IP_VS_DBG_ADDR(cp->af, &to), ntohs(port));
> +		IP_VS_DBG(7, "EPRT %pISpc detected\n",
> +			  IP_VS_DBG_SOCKADDR(cp->af, &to, port));
>  
>  		/* Now update or create a connection entry for it */
> -		IP_VS_DBG_BUF(7, "protocol %s %s:%u %s:%u\n",
> -			      ip_vs_proto_name(ipvsh->protocol),
> -			      IP_VS_DBG_ADDR(cp->af, &to), ntohs(port),
> -			      IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
> -			      ntohs(cp->vport)-1);
> +		IP_VS_DBG(7, "protocol %s %pISpc %pISpc\n",
> +			  ip_vs_proto_name(ipvsh->protocol),
> +			  IP_VS_DBG_SOCKADDR(cp->af, &to, port),
> +			  IP_VS_DBG_SOCKADDR(cp->af, &cp->vaddr,
> +					     htons(ntohs(cp->vport)-1)));
>  	} else {
>  		return 1;
>  	}
> -- 
> 2.20.0

Regards

--
Julian Anastasov <ja@ssi.bg>
