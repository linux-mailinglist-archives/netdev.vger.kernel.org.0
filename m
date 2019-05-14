Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F323B1C352
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 08:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfENGir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 02:38:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:52958 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726007AbfENGir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 02:38:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 67978AD2C;
        Tue, 14 May 2019 06:38:46 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id AC829E014B; Tue, 14 May 2019 08:38:44 +0200 (CEST)
Date:   Tue, 14 May 2019 08:38:44 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Weilong Chen <chenweilong@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next v2] ipv4: Add support to disable icmp timestamp
Message-ID: <20190514063844.GH22349@unicorn.suse.cz>
References: <1557802614-51040-1-git-send-email-chenweilong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1557802614-51040-1-git-send-email-chenweilong@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 10:56:54AM +0800, Weilong Chen wrote:
> The remote host answers to an ICMP timestamp request.
> This allows an attacker to know the time and date on your host.
> 
> This path is an another way contrast to iptables rules:
> iptables -A input -p icmp --icmp-type timestamp-request -j DROP
> iptables -A output -p icmp --icmp-type timestamp-reply -j DROP
> 
> Default is enabled.
> 
> enable:
> 	sysctl -w net.ipv4.icmp_timestamp_enable=1
> disable
> 	sysctl -w net.ipv4.icmp_timestamp_enable=0
> testing:
> 	hping3 --icmp --icmp-ts -V $IPADDR
> 
> Signed-off-by: Weilong Chen <chenweilong@huawei.com>
> ---

I'm not sure what you are trying to do but this looks like a process
violation:

  - it's exactly the same as the patch rejected yesterday
  - it's marked as "v2" again
  - net-next is closed until the end of merge window anyway

Michal Kubecek

>  include/net/ip.h           | 2 ++
>  net/ipv4/icmp.c            | 5 +++++
>  net/ipv4/sysctl_net_ipv4.c | 8 ++++++++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/include/net/ip.h b/include/net/ip.h
> index 2d3cce7..71840e4 100644
> --- a/include/net/ip.h
> +++ b/include/net/ip.h
> @@ -718,6 +718,8 @@ bool icmp_global_allow(void);
>  extern int sysctl_icmp_msgs_per_sec;
>  extern int sysctl_icmp_msgs_burst;
>  
> +extern int sysctl_icmp_timestamp_enable;
> +
>  #ifdef CONFIG_PROC_FS
>  int ip_misc_proc_init(void);
>  #endif
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index f3a5893..5010541 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -232,6 +232,7 @@ static inline void icmp_xmit_unlock(struct sock *sk)
>  
>  int sysctl_icmp_msgs_per_sec __read_mostly = 1000;
>  int sysctl_icmp_msgs_burst __read_mostly = 50;
> +int sysctl_icmp_timestamp_enable __read_mostly = 1;
>  
>  static struct {
>  	spinlock_t	lock;
> @@ -953,6 +954,10 @@ static bool icmp_echo(struct sk_buff *skb)
>  static bool icmp_timestamp(struct sk_buff *skb)
>  {
>  	struct icmp_bxm icmp_param;
> +
> +	if (!sysctl_icmp_timestamp_enable)
> +		goto out_err;
> +
>  	/*
>  	 *	Too short.
>  	 */
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 875867b..1fe467e 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -544,6 +544,14 @@ static struct ctl_table ipv4_table[] = {
>  		.extra1		= &zero,
>  	},
>  	{
> +		.procname	= "icmp_timestamp_enable",
> +		.data		= &sysctl_icmp_timestamp_enable,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &zero,
> +	},
> +	{
>  		.procname	= "udp_mem",
>  		.data		= &sysctl_udp_mem,
>  		.maxlen		= sizeof(sysctl_udp_mem),
> -- 
> 2.7.4
> 
