Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E40D3F0F1C
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 02:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhHSAUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 20:20:15 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:37584 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233866AbhHSAUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 20:20:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UjtkiJA_1629332377;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0UjtkiJA_1629332377)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 19 Aug 2021 08:19:37 +0800
Date:   Thu, 19 Aug 2021 08:19:36 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>,
        Wensong Zhang <wensong@linux-vs.org>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        yunhong-cgl jiang <xintian1976@gmail.com>
Subject: Re: [PATCH] net: ipvs: add sysctl_run_estimation to support disable
 estimation
Message-ID: <20210819001936.GA5594@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20210818032056.44886-1-dust.li@linux.alibaba.com>
 <98f95dc0-9bec-6f2b-c2b3-d332d2bef9a@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98f95dc0-9bec-6f2b-c2b3-d332d2bef9a@ssi.bg>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 08:52:11PM +0300, Julian Anastasov wrote:
>
>	Hello,
>
>On Wed, 18 Aug 2021, Dust Li wrote:
>
>> fix #31562403
>> 
>> estimation_timer will iterater the est_list to do estimation
>> for each ipvs stats. When there are lots of services, the
>> list can be very large.
>> We observiced estimation_timer() run for more then 200ms on
>> a machine with 104 CPU and 50K services.
>> 
>> yunhong-cgl jiang report the same phenomenon before:
>> https://www.spinics.net/lists/lvs-devel/msg05426.html
>> 
>> In some cases(for example a large K8S cluster with many ipvs services),
>> ipvs estimation may not be needed. So adding a sysctl blob to allow
>> users to disable this completely.
>> 
>> Default is: 1 (enable)
>
>	I guess, this patch should target net-next tree.

Yes. I will change the patch and send a v2 with net-next prefix.

>
>> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
>> ---
>>  Documentation/networking/ipvs-sysctl.rst | 17 ++++++
>>  include/net/ip_vs.h                      |  3 +
>>  net/netfilter/ipvs/ip_vs_est.c           | 73 ++++++++++++++++++++++++
>>  3 files changed, 93 insertions(+)
>> 
>> diff --git a/Documentation/networking/ipvs-sysctl.rst b/Documentation/networking/ipvs-sysctl.rst
>> index 2afccc63856e..e20f7a27fc85 100644
>> --- a/Documentation/networking/ipvs-sysctl.rst
>> +++ b/Documentation/networking/ipvs-sysctl.rst
>> @@ -300,3 +300,20 @@ sync_version - INTEGER
>>  
>>  	Kernels with this sync_version entry are able to receive messages
>>  	of both version 1 and version 2 of the synchronisation protocol.
>> +
>> +run_estimation - BOOLEAN
>> +	0 - disabled
>> +	not 0 - enabled (default)
>> +
>> +	If disabled, the estimation will be stop, and you can't see
>> +	any update on speed estimation data.
>> +
>> +	For example
>> +	'Conns/s   Pkts/s   Pkts/s          Bytes/s          Bytes/s'
>> +	those data in /proc/net/ip_vs_stats will always be zero.
>> +	Note, this only affect the speed estimation, the total data
>> +	will still be updated.
>> +
>> +	You can always re-enable estimation by setting this value to 1.
>> +	But be carefull, the first estimation after re-enable is not
>> +	accurate.
>> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
>> index d609e957a3ec..6cbb3a08b176 100644
>> --- a/include/net/ip_vs.h
>> +++ b/include/net/ip_vs.h
>> @@ -941,6 +941,9 @@ struct netns_ipvs {
>>  	struct ctl_table_header	*lblcr_ctl_header;
>>  	struct ctl_table	*lblcr_ctl_table;
>>  	/* ip_vs_est */
>> +	int			sysctl_run_estimation;
>
>	We should keep such sysctl vars in a CONFIG_SYSCTL block
>and we have corresponding inline functions for the two
>cases depending on CONFIG_SYSCTL. Still, many of the sysctl_*
>fields are not moved into such ifdef.
>
>	But you can get sysctl_pmtu_disc as example:
>
># grep -r sysctl_pmtu_disc include/net/ip_vs.h net/netfilter/ipvs/
>
>	Add the var in ip_vs_ctl.c as the other vars
>and implement it just like sysctl_pmtu_disc.
>
>> +	struct ctl_table_header	*est_ctl_header;
>> +	struct ctl_table	*est_ctl_table;
>
>	As result, we will not need specific ctl table

OK, will do, thanks for the advice.


>
>>  	struct list_head	est_list;	/* estimator list */
>>  	spinlock_t		est_lock;
>>  	struct timer_list	est_timer;	/* Estimation timer */
>> diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
>> index 05b8112ffb37..6709796b8621 100644
>> --- a/net/netfilter/ipvs/ip_vs_est.c
>> +++ b/net/netfilter/ipvs/ip_vs_est.c
>> @@ -100,6 +100,9 @@ static void estimation_timer(struct timer_list *t)
>>  	u64 rate;
>>  	struct netns_ipvs *ipvs = from_timer(ipvs, t, est_timer);
>>  
>> +	if (!ipvs->sysctl_run_estimation)
>> +		goto skip;
>
>	Some day this var will not be present if !CONFIG_SYSCTL,
>so we should call the new inline function:
>
>	if (!sysctl_run_estimation(ipvs))
>		goto skip;

Yeah, this is better, will do.

>
>> +
>>  	spin_lock(&ipvs->est_lock);
>>  	list_for_each_entry(e, &ipvs->est_list, list) {
>>  		s = container_of(e, struct ip_vs_stats, est);
>> @@ -131,6 +134,8 @@ static void estimation_timer(struct timer_list *t)
>>  		spin_unlock(&s->lock);
>>  	}
>>  	spin_unlock(&ipvs->est_lock);
>> +
>> +skip:
>>  	mod_timer(&ipvs->est_timer, jiffies + 2*HZ);
>>  }
>>  
>> @@ -184,10 +189,77 @@ void ip_vs_read_estimator(struct ip_vs_kstats *dst, struct ip_vs_stats *stats)
>>  	dst->outbps = (e->outbps + 0xF) >> 5;
>>  }
>>  
>> +#ifdef CONFIG_SYSCTL
>> +/* IPVS ESTIMATION sysctl table */
>> +static struct ctl_table vs_vars_table[] = {
>> +	{
>> +		.procname	= "run_estimation",
>> +		.data		= NULL,
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec,
>> +	},
>> +	{ }
>> +};
>> +
>> +static int ip_vs_est_sysctl_init(struct netns_ipvs *ipvs)
>> +{
>> +	struct net *net = ipvs->net;
>> +
>> +	if (!net_eq(net, &init_net)) {
>> +		ipvs->est_ctl_table = kmemdup(vs_vars_table,
>> +					      sizeof(vs_vars_table),
>> +					      GFP_KERNEL);
>> +		if (!ipvs->est_ctl_table)
>> +			return -ENOMEM;
>> +
>> +		/* Don't export sysctls to unprivileged users */
>> +		if (net->user_ns != &init_user_ns)
>> +			ipvs->est_ctl_table[0].procname = NULL;
>> +
>> +	} else {
>> +		ipvs->est_ctl_table = vs_vars_table;
>> +	}
>> +
>> +	ipvs->sysctl_run_estimation = 1;
>> +	ipvs->est_ctl_table[0].data = &ipvs->sysctl_run_estimation;
>> +
>> +	ipvs->est_ctl_header =
>> +		register_net_sysctl(net, "net/ipv4/vs", ipvs->est_ctl_table);
>> +	if (!ipvs->est_ctl_header) {
>> +		if (!net_eq(net, &init_net))
>> +			kfree(ipvs->est_ctl_table);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static void ip_vs_est_sysctl_cleanup(struct netns_ipvs *ipvs)
>> +{
>> +	unregister_net_sysctl_table(ipvs->est_ctl_header);
>> +
>> +	if (!net_eq(ipvs->net, &init_net))
>> +		kfree(ipvs->est_ctl_table);
>> +}
>> +
>> +#else
>> +
>> +static int ip_vs_est_sysctl_init(struct netns_ipvs *ipvs)
>> +{
>> +	ipvs->sysctl_run_estimation = 1;
>> +	return 0;
>> +}
>> +
>> +static void ip_vs_est_sysctl_cleanup(struct netns_ipvs *ipvs) { }
>> +
>> +#endif
>
>	Drop this ctl table. Just reset sysctl_run_estimation in
>ip_vs_control_net_init_sysctl().

Will do.

>
>> +
>>  int __net_init ip_vs_estimator_net_init(struct netns_ipvs *ipvs)
>>  {
>>  	INIT_LIST_HEAD(&ipvs->est_list);
>>  	spin_lock_init(&ipvs->est_lock);
>> +	ip_vs_est_sysctl_init(ipvs);
>>  	timer_setup(&ipvs->est_timer, estimation_timer, 0);
>>  	mod_timer(&ipvs->est_timer, jiffies + 2 * HZ);
>>  	return 0;
>> @@ -196,4 +268,5 @@ int __net_init ip_vs_estimator_net_init(struct netns_ipvs *ipvs)
>>  void __net_exit ip_vs_estimator_net_cleanup(struct netns_ipvs *ipvs)
>>  {
>>  	del_timer_sync(&ipvs->est_timer);
>> +	ip_vs_est_sysctl_cleanup(ipvs);
>>  }
>> -- 
>> 2.19.1.3.ge56e4f7
>
>Regards
>
>--
>Julian Anastasov <ja@ssi.bg>
