Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E70730A01F
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 03:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbhBACBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 21:01:53 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7701 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbhBACBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 21:01:34 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601760d60000>; Sun, 31 Jan 2021 18:00:54 -0800
Received: from [172.27.8.91] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 02:00:51 +0000
Subject: Re: [PATCH net-next v5] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Ido Schimmel <idosch@idosch.org>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, kernel test robot <lkp@intel.com>
References: <20210130023319.32560-1-cmi@nvidia.com>
 <20210130145227.GB3329243@shredder.lan>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <c62ee575-49e0-c5d6-f855-ead5775af141@nvidia.com>
Date:   Mon, 1 Feb 2021 10:00:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210130145227.GB3329243@shredder.lan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612144854; bh=ZwpXq3H1Nsi+0Bb38bMCBy14DFO2mNfOUCSzSxa9VXE=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=hvL91OqXeiixlG4xdiO96UaU4xS6aDha13o5evn2x+PyQrPtbkAMR2WYuPInS3A2b
         M5JFMO8DCe6gjJnOx0LpUj1cnjI+EKbbGoMF6lTp/6TjRc1j3bPBz7YH71offaD3iy
         3mQUMV5NyQfApkobXV5nylZlWH+ijlpsH4Qw4vq4jTXdlX3i77dTLeTajG6NiIq33S
         psR2F0MNbmHqg9o1rZRXlHskYr4L/jkSCDA8IwCSU3D0+MvnKuT1A3/c7WB6uaPKDs
         WrkoCMdssyWUpB5zetwajgAZxiJhNdOhpfmcQMz6TDp6WAt2bwTiGKR9xO1fR50Kha
         2fkldfP84oYrg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/2021 10:52 PM, Ido Schimmel wrote:
> On Sat, Jan 30, 2021 at 10:33:19AM +0800, Chris Mi wrote:
>> In order to send sampled packets to userspace, NIC driver calls
>> psample api directly. But it creates a hard dependency on module
>> psample. Introduce psample_ops to remove the hard dependency.
>> It is initialized when psample module is loaded and set to NULL
>> when the module is unloaded.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
> This belongs in the changelog (that should be part of the commit
> message). Something like "Fix xxx reported by kernel test robot".
But I see existing commits have it. And Jakub didn't ask me to do it. So 
I think
I'd better keep it.
>
>> Signed-off-by: Chris Mi <cmi@nvidia.com>
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>> v1->v2:
>>   - fix sparse errors
>> v2->v3:
>>   - remove inline
>> v3->v4:
>>   - add inline back
>> v4->v5:
>>   - address Jakub's comments
>>
>>   include/net/psample.h    | 26 ++++++++++++++++++++++++++
>>   net/psample/psample.c    | 14 +++++++++++++-
>>   net/sched/Makefile       |  2 +-
>>   net/sched/psample_stub.c |  5 +++++
>>   4 files changed, 45 insertions(+), 2 deletions(-)
>>   create mode 100644 net/sched/psample_stub.c
>>
>> diff --git a/include/net/psample.h b/include/net/psample.h
>> index 68ae16bb0a4a..d0f1cfc56f6f 100644
>> --- a/include/net/psample.h
>> +++ b/include/net/psample.h
>> @@ -14,6 +14,15 @@ struct psample_group {
>>   	struct rcu_head rcu;
>>   };
>>   
>> +struct psample_ops {
>> +	void (*sample_packet)(struct psample_group *group, struct sk_buff *skb,
>> +			      u32 trunc_size, int in_ifindex, int out_ifindex,
>> +			      u32 sample_rate);
>> +
>> +};
>> +
>> +extern const struct psample_ops __rcu *psample_ops __read_mostly;
>> +
>>   struct psample_group *psample_group_get(struct net *net, u32 group_num);
>>   void psample_group_take(struct psample_group *group);
>>   void psample_group_put(struct psample_group *group);
>> @@ -35,4 +44,21 @@ static inline void psample_sample_packet(struct psample_group *group,
>>   
>>   #endif
>>   
>> +static inline void
>> +psample_nic_sample_packet(struct psample_group *group,
>> +			  struct sk_buff *skb, u32 trunc_size,
>> +			  int in_ifindex, int out_ifindex,
>> +			  u32 sample_rate)
>> +{
>> +	const struct psample_ops *ops;
>> +
>> +	rcu_read_lock();
>> +	ops = rcu_dereference(psample_ops);
>> +	if (ops)
>> +		ops->sample_packet(group, skb, trunc_size,
>> +				   in_ifindex, out_ifindex,
>> +				   sample_rate);
>> +	rcu_read_unlock();
>> +}
>> +
>>   #endif /* __NET_PSAMPLE_H */
>> diff --git a/net/psample/psample.c b/net/psample/psample.c
>> index 33e238c965bd..983ca5b698fe 100644
>> --- a/net/psample/psample.c
>> +++ b/net/psample/psample.c
>> @@ -8,6 +8,7 @@
>>   #include <linux/kernel.h>
>>   #include <linux/skbuff.h>
>>   #include <linux/module.h>
>> +#include <linux/rcupdate.h>
>>   #include <net/net_namespace.h>
>>   #include <net/sock.h>
>>   #include <net/netlink.h>
>> @@ -35,6 +36,10 @@ static const struct genl_multicast_group psample_nl_mcgrps[] = {
>>   
>>   static struct genl_family psample_nl_family __ro_after_init;
>>   
>> +static const struct psample_ops psample_sample_ops = {
>> +	.sample_packet	= psample_sample_packet,
>> +};
>> +
>>   static int psample_group_nl_fill(struct sk_buff *msg,
>>   				 struct psample_group *group,
>>   				 enum psample_command cmd, u32 portid, u32 seq,
>> @@ -456,11 +461,18 @@ EXPORT_SYMBOL_GPL(psample_sample_packet);
>>   
>>   static int __init psample_module_init(void)
>>   {
>> -	return genl_register_family(&psample_nl_family);
>> +	int ret;
>> +
>> +	ret = genl_register_family(&psample_nl_family);
>> +	if (!ret)
>> +		RCU_INIT_POINTER(psample_ops, &psample_sample_ops);
>> +	return ret;
>>   }
>>   
>>   static void __exit psample_module_exit(void)
>>   {
>> +	rcu_assign_pointer(psample_ops, NULL);
>> +	synchronize_rcu();
>>   	genl_unregister_family(&psample_nl_family);
>>   }
>>   
>> diff --git a/net/sched/Makefile b/net/sched/Makefile
>> index dd14ef413fda..0d92bb98bb26 100644
>> --- a/net/sched/Makefile
>> +++ b/net/sched/Makefile
>> @@ -3,7 +3,7 @@
>>   # Makefile for the Linux Traffic Control Unit.
>>   #
>>   
>> -obj-y	:= sch_generic.o sch_mq.o
>> +obj-y	:= sch_generic.o sch_mq.o psample_stub.o
> Why the stub is under net/sched/ when psample is at net/psample/?
> psample is not the same as 'act_sample'.
If this stub is in net/psample and compiled to psample kernel module, NIC
driver still depends on it. It must be in kernel. And I think net/sched 
is the
only place we can put. If we put it in somewhere else, like net/, I 
guess we'll
get more objections.
>
>>   
>>   obj-$(CONFIG_INET)		+= sch_frag.o
>>   obj-$(CONFIG_NET_SCHED)		+= sch_api.o sch_blackhole.o
>> diff --git a/net/sched/psample_stub.c b/net/sched/psample_stub.c
>> new file mode 100644
>> index 000000000000..0541b8c5100d
>> --- /dev/null
>> +++ b/net/sched/psample_stub.c
>> @@ -0,0 +1,5 @@
>> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> psample has "// SPDX-License-Identifier: GPL-2.0-only"
Done. Thanks.
>
>> +/* Copyright (c) 2021 Mellanox Technologies. */
>> +
>> +const struct psample_ops __rcu *psample_ops __read_mostly;
>> +EXPORT_SYMBOL_GPL(psample_ops);
>> -- 
>> 2.26.2
>>

