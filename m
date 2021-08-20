Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5123F263E
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238469AbhHTFAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 01:00:03 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:45478 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233505AbhHTE7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 00:59:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UkFVSTL_1629435544;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0UkFVSTL_1629435544)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 20 Aug 2021 12:59:05 +0800
Date:   Fri, 20 Aug 2021 12:59:04 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Simon Horman <horms@verge.net.au>,
        Wensong Zhang <wensong@linux-vs.org>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        yunhong-cgl jiang <xintian1976@gmail.com>
Subject: Re: [PATCH net-next v3] net: ipvs: add sysctl_run_estimation to
 support disable estimation
Message-ID: <20210820045904.GC5594@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20210819084418.27004-1-dust.li@linux.alibaba.com>
 <5fee5fd0-2e2-1ec2-8640-def6b0bc32ee@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fee5fd0-2e2-1ec2-8640-def6b0bc32ee@ssi.bg>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 07:53:06AM +0300, Julian Anastasov wrote:
>
>	Hello,
>
>On Thu, 19 Aug 2021, Dust Li wrote:
>
>> estimation_timer will iterater the est_list to do estimation
>
>	...will iterate...
>
>> for each ipvs stats. When there are lots of services, the
>> list can be very large.
>> We observiced estimation_timer() run for more then 200ms on
>
>	...We found that estimation_timer() runs for...

OK, thanks for you carefull review, I will fix those details
and send a v4.

Thanks again !

>
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
>> 
>> Cc: yunhong-cgl jiang <xintian1976@gmail.com>
>> Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
>> ---
>> v2: Use common sysctl facilities
>> v3: Fix sysctl_run_estimation() redefine when CONFIG_SYSCTL not enabled
>> ---
>
>	Replace above "---" after v3 with empty line,
>avoid multiple "---" lines.
>
>>  Documentation/networking/ipvs-sysctl.rst | 17 +++++++++++++++++
>>  include/net/ip_vs.h                      | 12 ++++++++++++
>>  net/netfilter/ipvs/ip_vs_ctl.c           |  8 ++++++++
>>  net/netfilter/ipvs/ip_vs_est.c           |  5 +++++
>>  4 files changed, 42 insertions(+)
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
>
>	We can remove the above example
>
>> +
>> +	You can always re-enable estimation by setting this value to 1.
>> +	But be carefull, the first estimation after re-enable is not
>
>	...careful...
>
>> +	accurate.
>> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
>> index 7cb5a1aace40..269f8808f6db 100644
>> --- a/include/net/ip_vs.h
>> +++ b/include/net/ip_vs.h
>> @@ -931,6 +931,7 @@ struct netns_ipvs {
>>  	int			sysctl_conn_reuse_mode;
>>  	int			sysctl_schedule_icmp;
>>  	int			sysctl_ignore_tunneled;
>> +	int 			sysctl_run_estimation;
>
>	scripts/checkpatch.pl --strict /tmp/file.patch
>reports for extra space just after 'int'.
>
>>  
>>  	/* ip_vs_lblc */
>>  	int			sysctl_lblc_expiration;
>> @@ -1071,6 +1072,11 @@ static inline int sysctl_cache_bypass(struct netns_ipvs *ipvs)
>>  	return ipvs->sysctl_cache_bypass;
>>  }
>>  
>> +static inline int sysctl_run_estimation(struct netns_ipvs *ipvs)
>> +{
>> +	return ipvs->sysctl_run_estimation;
>> +}
>> +
>>  #else
>>  
>>  static inline int sysctl_sync_threshold(struct netns_ipvs *ipvs)
>> @@ -1163,6 +1169,11 @@ static inline int sysctl_cache_bypass(struct netns_ipvs *ipvs)
>>  	return 0;
>>  }
>>  
>> +static inline int sysctl_run_estimation(struct netns_ipvs *ipvs)
>> +{
>> +	return 1;
>> +}
>> +
>>  #endif
>>  
>>  /* IPVS core functions
>> @@ -1650,6 +1661,7 @@ static inline int ip_vs_confirm_conntrack(struct sk_buff *skb)
>>  static inline void ip_vs_conn_drop_conntrack(struct ip_vs_conn *cp)
>>  {
>>  }
>> +
>
>	Remove this irrelevant hunk.
>
>>  #endif /* CONFIG_IP_VS_NFCT */
>>  
>>  /* Using old conntrack that can not be redirected to another real server? */
>> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
>> index c25097092a06..cbea5a68afb5 100644
>> --- a/net/netfilter/ipvs/ip_vs_ctl.c
>> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
>> @@ -2017,6 +2017,12 @@ static struct ctl_table vs_vars[] = {
>>  		.mode		= 0644,
>>  		.proc_handler	= proc_dointvec,
>>  	},
>> +	{
>> +		.procname	= "run_estimation",
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec,
>> +	},
>>  #ifdef CONFIG_IP_VS_DEBUG
>>  	{
>>  		.procname	= "debug_level",
>> @@ -4090,6 +4096,8 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
>>  	tbl[idx++].data = &ipvs->sysctl_conn_reuse_mode;
>>  	tbl[idx++].data = &ipvs->sysctl_schedule_icmp;
>>  	tbl[idx++].data = &ipvs->sysctl_ignore_tunneled;
>> +	ipvs->sysctl_run_estimation = 1;
>> +	tbl[idx++].data = &ipvs->sysctl_run_estimation;
>>  
>>  	ipvs->sysctl_hdr = register_net_sysctl(net, "net/ipv4/vs", tbl);
>>  	if (ipvs->sysctl_hdr == NULL) {
>> diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
>> index 05b8112ffb37..9a1a7af6a186 100644
>> --- a/net/netfilter/ipvs/ip_vs_est.c
>> +++ b/net/netfilter/ipvs/ip_vs_est.c
>> @@ -100,6 +100,9 @@ static void estimation_timer(struct timer_list *t)
>>  	u64 rate;
>>  	struct netns_ipvs *ipvs = from_timer(ipvs, t, est_timer);
>>  
>> +	if (!sysctl_run_estimation(ipvs))
>> +		goto skip;
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
>> -- 
>> 2.19.1.3.ge56e4f7
>
>Regards
>
>--
>Julian Anastasov <ja@ssi.bg>
