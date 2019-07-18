Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8C006CF91
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 16:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390656AbfGRORX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jul 2019 10:17:23 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:2113 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390356AbfGRORX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 10:17:23 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.1]) by rmmx-syy-dmz-app12-12012 (RichMail) with SMTP id 2eec5d307f28e2e-a11f6; Thu, 18 Jul 2019 22:16:09 +0800 (CST)
X-RM-TRANSID: 2eec5d307f28e2e-a11f6
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [10.0.0.249] (unknown[112.22.251.180])
        by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee15d307f26c3f-095a6;
        Thu, 18 Jul 2019 22:16:09 +0800 (CST)
X-RM-TRANSID: 2ee15d307f26c3f-095a6
Content-Type: text/plain; charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [net-next 1/2] ipvs: batch __ip_vs_cleanup
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
In-Reply-To: <alpine.LFD.2.21.1907152333300.5700@ja.home.ssi.bg>
Date:   Thu, 18 Jul 2019 22:16:05 +0800
Cc:     "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Simon Horman <horms@verge.net.au>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8441EA26-E197-4F40-A6D7-5B7D59AA7F7F@cmss.chinamobile.com>
References: <1563031186-2101-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
 <1563031186-2101-2-git-send-email-yanhaishuang@cmss.chinamobile.com>
 <alpine.LFD.2.21.1907152333300.5700@ja.home.ssi.bg>
To:     Julian Anastasov <ja@ssi.bg>
X-Mailer: Apple Mail (2.3273)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On 2019年7月16日, at 上午4:39, Julian Anastasov <ja@ssi.bg> wrote:
> 
> 
> 	Hello,
> 
> On Sat, 13 Jul 2019, Haishuang Yan wrote:
> 
>> It's better to batch __ip_vs_cleanup to speedup ipvs
>> connections dismantle.
>> 
>> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
>> ---
>> include/net/ip_vs.h             |  2 +-
>> net/netfilter/ipvs/ip_vs_core.c | 29 +++++++++++++++++------------
>> net/netfilter/ipvs/ip_vs_ctl.c  | 13 ++++++++++---
>> 3 files changed, 28 insertions(+), 16 deletions(-)
>> 
>> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
>> index 3759167..93e7a25 100644
>> --- a/include/net/ip_vs.h
>> +++ b/include/net/ip_vs.h
>> @@ -1324,7 +1324,7 @@ static inline void ip_vs_control_del(struct ip_vs_conn *cp)
>> void ip_vs_control_net_cleanup(struct netns_ipvs *ipvs);
>> void ip_vs_estimator_net_cleanup(struct netns_ipvs *ipvs);
>> void ip_vs_sync_net_cleanup(struct netns_ipvs *ipvs);
>> -void ip_vs_service_net_cleanup(struct netns_ipvs *ipvs);
>> +void ip_vs_service_nets_cleanup(struct list_head *net_list);
>> 
>> /* IPVS application functions
>>  * (from ip_vs_app.c)
>> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
>> index 46f06f9..b4d79b7 100644
>> --- a/net/netfilter/ipvs/ip_vs_core.c
>> +++ b/net/netfilter/ipvs/ip_vs_core.c
>> @@ -2402,18 +2402,23 @@ static int __net_init __ip_vs_init(struct net *net)
>> 	return -ENOMEM;
>> }
>> 
>> -static void __net_exit __ip_vs_cleanup(struct net *net)
>> +static void __net_exit __ip_vs_cleanup_batch(struct list_head *net_list)
>> {
>> -	struct netns_ipvs *ipvs = net_ipvs(net);
>> -
>> -	ip_vs_service_net_cleanup(ipvs);	/* ip_vs_flush() with locks */
>> -	ip_vs_conn_net_cleanup(ipvs);
>> -	ip_vs_app_net_cleanup(ipvs);
>> -	ip_vs_protocol_net_cleanup(ipvs);
>> -	ip_vs_control_net_cleanup(ipvs);
>> -	ip_vs_estimator_net_cleanup(ipvs);
>> -	IP_VS_DBG(2, "ipvs netns %d released\n", ipvs->gen);
>> -	net->ipvs = NULL;
>> +	struct netns_ipvs *ipvs;
>> +	struct net *net;
>> +	LIST_HEAD(list);
>> +
>> +	ip_vs_service_nets_cleanup(net_list);	/* ip_vs_flush() with locks */
>> +	list_for_each_entry(net, net_list, exit_list) {
> 
> 	How much faster is to replace list_for_each_entry in
> ops_exit_list() with this one. IPVS can waste time in calls
> such as kthread_stop() and del_timer_sync() but I'm not sure
> we can solve it easily. What gain do you see in benchmarks?

Hi, 

As the following benchmark testing results show, there is a little performance improvement:

$  cat add_del_unshare.sh
#!/bin/bash

for i in `seq 1 100`
    do
     (for j in `seq 1 40` ; do  unshare -n ipvsadm -A -t 172.16.$i.$j:80 >/dev/null ; done) &
    done
wait; grep net_namespace /proc/slabinfo

Befor patch:
$  time sh add_del_unshare.sh
net_namespace       4020   4020   4736    6    8 : tunables    0    0    0 : slabdata    670    670      0

real    0m8.086s
user    0m2.025s
sys     0m36.956s

After patch:
$  time sh add_del_unshare.sh
net_namespace       4020   4020   4736    6    8 : tunables    0    0    0 : slabdata    670    670      0

real    0m7.623s
user    0m2.003s
sys     0m32.935s


> 
>> +		ipvs = net_ipvs(net);
>> +		ip_vs_conn_net_cleanup(ipvs);
>> +		ip_vs_app_net_cleanup(ipvs);
>> +		ip_vs_protocol_net_cleanup(ipvs);
>> +		ip_vs_control_net_cleanup(ipvs);
>> +		ip_vs_estimator_net_cleanup(ipvs);
>> +		IP_VS_DBG(2, "ipvs netns %d released\n", ipvs->gen);
>> +		net->ipvs = NULL;
>> +	}
>> }
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 



