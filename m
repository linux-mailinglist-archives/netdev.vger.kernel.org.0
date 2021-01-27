Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F0E305829
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhA0KUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 05:20:18 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16105 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbhA0KSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 05:18:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60113db10000>; Wed, 27 Jan 2021 02:17:21 -0800
Received: from [172.27.8.81] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 27 Jan
 2021 10:17:19 +0000
Subject: Re: [PATCH net-next v2] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Zhu Yanjun <zyjzyj2000@gmail.com>
CC:     netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        <jiri@nvidia.com>, <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
References: <20210127074651.510134-1-cmi@nvidia.com>
 <CAD=hENcqq1-m-8hyswQEVOb8jxqW4bzW2XrPdGabOO6kdJYnww@mail.gmail.com>
From:   Chris Mi <cmi@nvidia.com>
Message-ID: <4b20c0d7-c8c7-70ab-1ff4-c7a74d602ae5@nvidia.com>
Date:   Wed, 27 Jan 2021 18:17:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAD=hENcqq1-m-8hyswQEVOb8jxqW4bzW2XrPdGabOO6kdJYnww@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611742641; bh=MyBiwvtbZDPynZheWdVFFE+8JPiXnHRL+Uahm1MTuyE=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=UWJVDep7/xax4+o+4O/yJBIdyK3/yaa+7ktQa9EB5eLoPxMu9+KJ6CHJOU037P9WH
         +DTcEAHu8dyX/pr3OKqWk1A8wUfKgXWpZyx4knMwawVF7YQzLN1am2e2681FYVjXpx
         zjteNWxbHmKxKQZOY21oWlO32U32NcmlRWTlQF0+nj2jShPjOIYjb4dCjR5eAIA9hX
         ILwrfKVkPcPEFOKDFFD9cAymOm026Yy6nLwqF9W39t/bZkXSKm4L6IuevAYcJ+qWGQ
         MPRtYE3dFovPp8lbuSvfOf5eLN0xZHX9ByJs4A0QnMJ6ac4IS09EjWeYZhSlhIPBes
         VYr6kuBvqrZwA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/2021 5:47 PM, Zhu Yanjun wrote:
> On Wed, Jan 27, 2021 at 5:06 PM Chris Mi <cmi@nvidia.com> wrote:
>> In order to send sampled packets to userspace, NIC driver calls
>> psample api directly. But it creates a hard dependency on module
>> psample. Introduce psample_ops to remove the hard dependency.
>> It is initialized when psample module is loaded and set to NULL
>> when the module is unloaded.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Chris Mi <cmi@nvidia.com>
>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>> v1->v2:
>>   - fix sparse errors
>>
>>   include/net/psample.h    | 27 +++++++++++++++++++++++++++
>>   net/psample/psample.c    | 13 ++++++++++++-
>>   net/sched/Makefile       |  2 +-
>>   net/sched/psample_stub.c |  7 +++++++
>>   4 files changed, 47 insertions(+), 2 deletions(-)
>>   create mode 100644 net/sched/psample_stub.c
>>
>> diff --git a/include/net/psample.h b/include/net/psample.h
>> index 68ae16bb0a4a..e6a73128de59 100644
>> --- a/include/net/psample.h
>> +++ b/include/net/psample.h
>> @@ -4,6 +4,7 @@
>>
>>   #include <uapi/linux/psample.h>
>>   #include <linux/list.h>
>> +#include <linux/skbuff.h>
>>
>>   struct psample_group {
>>          struct list_head list;
>> @@ -14,6 +15,15 @@ struct psample_group {
>>          struct rcu_head rcu;
>>   };
>>
>> +struct psample_ops {
>> +       void (*sample_packet)(struct psample_group *group, struct sk_buff *skb,
>> +                             u32 trunc_size, int in_ifindex, int out_ifindex,
>> +                             u32 sample_rate);
>> +
>> +};
>> +
>> +extern const struct psample_ops __rcu *psample_ops __read_mostly;
>> +
>>   struct psample_group *psample_group_get(struct net *net, u32 group_num);
>>   void psample_group_take(struct psample_group *group);
>>   void psample_group_put(struct psample_group *group);
>> @@ -35,4 +45,21 @@ static inline void psample_sample_packet(struct psample_group *group,
>>
>>   #endif
>>
>> +static inline void
> inline is not needed here. The compiler should judge it.
Done.
>
> Zhu Yanjun
>
>> +psample_nic_sample_packet(struct psample_group *group,
>> +                         struct sk_buff *skb, u32 trunc_size,
>> +                         int in_ifindex, int out_ifindex,
>> +                         u32 sample_rate)
>> +{
>> +       const struct psample_ops *ops;
>> +
>> +       rcu_read_lock();
>> +       ops = rcu_dereference(psample_ops);
>> +       if (ops)
>> +               psample_ops->sample_packet(group, skb, trunc_size,
>> +                                          in_ifindex, out_ifindex,
>> +                                          sample_rate);
>> +       rcu_read_unlock();
>> +}
>> +
>>   #endif /* __NET_PSAMPLE_H */
>> diff --git a/net/psample/psample.c b/net/psample/psample.c
>> index 33e238c965bd..2a9fbfe09395 100644
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
>> +       .sample_packet  = psample_sample_packet,
>> +};
>> +
>>   static int psample_group_nl_fill(struct sk_buff *msg,
>>                                   struct psample_group *group,
>>                                   enum psample_command cmd, u32 portid, u32 seq,
>> @@ -456,11 +461,17 @@ EXPORT_SYMBOL_GPL(psample_sample_packet);
>>
>>   static int __init psample_module_init(void)
>>   {
>> -       return genl_register_family(&psample_nl_family);
>> +       int ret;
>> +
>> +       ret = genl_register_family(&psample_nl_family);
>> +       if (!ret)
>> +               RCU_INIT_POINTER(psample_ops, &psample_sample_ops);
>> +       return ret;
>>   }
>>
>>   static void __exit psample_module_exit(void)
>>   {
>> +       RCU_INIT_POINTER(psample_ops, NULL);
>>          genl_unregister_family(&psample_nl_family);
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
>> -obj-y  := sch_generic.o sch_mq.o
>> +obj-y  := sch_generic.o sch_mq.o psample_stub.o
>>
>>   obj-$(CONFIG_INET)             += sch_frag.o
>>   obj-$(CONFIG_NET_SCHED)                += sch_api.o sch_blackhole.o
>> diff --git a/net/sched/psample_stub.c b/net/sched/psample_stub.c
>> new file mode 100644
>> index 000000000000..0615a7b64000
>> --- /dev/null
>> +++ b/net/sched/psample_stub.c
>> @@ -0,0 +1,7 @@
>> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>> +/* Copyright (c) 2021 Mellanox Technologies. */
>> +
>> +#include <net/psample.h>
>> +
>> +const struct psample_ops __rcu *psample_ops __read_mostly;
>> +EXPORT_SYMBOL_GPL(psample_ops);
>> --
>> 2.26.2
>>

