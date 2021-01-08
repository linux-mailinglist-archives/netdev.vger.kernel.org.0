Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6672EF051
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 10:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbhAHJ7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 04:59:10 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:60113 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727569AbhAHJ7J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 04:59:09 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff82cc30000>; Fri, 08 Jan 2021 17:58:27 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 8 Jan
 2021 09:58:27 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.55) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 8 Jan 2021 09:58:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drstACGtZv4XsIjOmVBrWogp4Yc31n3XxA6Js9v+WcT37+AHEuiWBnZ6gNtyOA3O+i1P53uTz+tX5ipSjMcbfjW8MOlWYLo3InKcNuSCV1PaCAeyKSQSa6087/UUczLBNz4ssUyzVR9+PSprk6AlnmcAE+nkvSZZ2mfNBZD0T1lEtklkeruitQU88IbIxvATv8moRpAprZ4cm6eHKJtE9smHr7Gw97GreIjwkNw/MD1Bx8ajKfv3csN9qjReVzqbS17zFzxIvORUa2D/vXxOF1t9GU9QubxYfadxhLC4N4WQDLFCDNJijZ1IIgQTqbakkE0WEH3ENOpzTVfXRyLH6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amMVV2UxTsT/xQFRAJQYw3TAIH8iMgTG6Lw3kROkg+w=;
 b=cQB9jhOZ7N1471LRWHpmHUJEfW6fk+kn/FI1injIyfSODI7O81KF1yx7xr7UeFbNKWktQJ+9tl5H5lU178uIzJ2D7TCmUNFhQ9e+07xML1brrRr65CAsyhWdSpZo7aEDz8cBQ7n3ebH9sHRs8K+EYxQ5r8n8+NsxgSpSOSOZaUQMLnHiWbEDwVJPWMpB3k3nq5K01y5La7AB/MTnTahybQxxCF5Kon2HCX/JKMR1FfLIcN+ce61tKshhBREHoRcgK4Y1RZMERgMJo2HJSAxH20UYO/+8RQHvou1b6w4HZKZzqNoxEVzAL+LKltXMmQLzUYtNBe7aHRF+Gh+qRfOlKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: strlen.de; dkim=none (message not signed)
 header.d=none;strlen.de; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3818.namprd12.prod.outlook.com (2603:10b6:5:1cf::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 8 Jan
 2021 09:58:23 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae%6]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 09:58:23 +0000
Subject: Re: [PATCH v4 net-next 16/18] net: bonding: ensure .ndo_get_stats64
 can sleep
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
References: <20210108002005.3429956-1-olteanv@gmail.com>
 <20210108002005.3429956-17-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <2a790830-9957-2985-2f5e-e87e6693a723@nvidia.com>
Date:   Fri, 8 Jan 2021 11:58:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210108002005.3429956-17-olteanv@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0106.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::21) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.106] (213.179.129.39) by ZR0P278CA0106.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 09:58:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f9795e6-c25b-4859-ddcd-08d8b3bbefec
X-MS-TrafficTypeDiagnostic: DM6PR12MB3818:
X-Microsoft-Antispam-PRVS: <DM6PR12MB381849F90197C149F94338BEDFAE0@DM6PR12MB3818.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wE+PxUuBzvAYkDr/YOAu/M+wd9DBJoqum35UN+zhQKBiOsI/BFMcbJbfgyPBitAm1MkcWZusmKqGNt8ZaaZ1QddShHdj/niPJ2l3KWZpDhoNOQbyX41y96E5KM9RRB+67B/4RWjZPUi11+3n4bEWGxXueP1oVXYOOoUjU6ntkFdPiBJ9bM5XnQ+bMvPOrKbX1/tbjYTnVfTcd4xuXsl14kZXpUQlR9rqCnysK0gaimXK2zPhB/V8kk9UHMUHamESAEy7JopRfXQP5NhMzahKKG+1p4VwqgECIlRK8P+xyLmX3hf6XxaHsQuZGoravgacukKIyT9WMLSiFrnUFOYUEg9mLd+R9TSSKyRBCHhd5ScEM2By1jG87l/y2qgFFz7pyYg7rBsxcseif8XWPHmB71letuvlR3K8Dlm596N8FwoKVm7G5ZEAYVjFdcOysnDmzppD89UpUBRXr4S75XMtEpej8yd8h1xDh+BXif852KvZNAo3kG6c9NKr4eb8J9IX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(376002)(366004)(110136005)(54906003)(66946007)(66476007)(66556008)(316002)(31696002)(83380400001)(26005)(6666004)(16576012)(956004)(6486002)(2616005)(186003)(31686004)(478600001)(86362001)(8936002)(53546011)(2906002)(16526019)(36756003)(8676002)(5660300002)(4326008)(7416002)(142923001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TWZsK2NSRHRpeGlVdjZ6Y1UxQVFEaWpxbHZld1c0ajhtVnNKV2lxSGhPVDZ0?=
 =?utf-8?B?YmVYYWtHSGNPRmxLdm9QM0Z0a2haUHEzS2JRZDJKMmpYYTd0QVFXekR3VWJD?=
 =?utf-8?B?TkE2YUIrWUdwMG1ESm5HTmtrUWw2VTUzTGFubDVUc0M1Z3JqZjBRcUJEZk5I?=
 =?utf-8?B?bzhQUmJnUzdZdkwvb1M1RURIYk9RR21lNExRMXBzOXJ6bjQvQ2YyWTdQS05l?=
 =?utf-8?B?a2ZNdS9CMmlZcks4dGNxQzF0NE1WYzgwbGhsV21rT05NUUZkNDMvTVNaVlU5?=
 =?utf-8?B?YXMwUlpxRVlrdVdPUG56NmhIb3FrWDJQa1pZbXo1VVYwTWYrNDNncWdSSlVG?=
 =?utf-8?B?eWpWWWN6dFNPRXBFN3FCS2RrdjFLejI1NDNJN0w4VTR2akkwYUUvdE0xRFdX?=
 =?utf-8?B?K3BqRTExVWtDbGhDaUViamNYOUp5bUFFc3MzNStNYTM3UXkvTkVOK3lSeVJ6?=
 =?utf-8?B?M3FYR3ZtU1NDVE9HT2F0NEtlQVlualpUdk9FU3JIbXJQWi9BZ2ZWaHVyTXRW?=
 =?utf-8?B?WmxZOWltVVRBTHpmeGlDNWdJQ0tIUU5ZYW9JajluOURjNENxZTNrRHlDSWwy?=
 =?utf-8?B?dityMi9qdGVOVlR3K3FUT0FKMGhJbzZmYjBjaXg2UlRBbTRma2dEWkwxNkts?=
 =?utf-8?B?Q3lKZ25xVE15WHc2WUpuRThUTVRoMHZsS3VyZUgxbFgvVnkvQ2wrYU1ra1dv?=
 =?utf-8?B?VHMyMmN0VTUvV0ZMMHVnejIxNWpuZ0Q4elQvaVI1UE92K1ZqRDExQkx5eXlk?=
 =?utf-8?B?MHJ1eGF0N2ZpZHBpS2pWY2RhRm56bzZTYitSNnpTYnJQZk1zSXpzUWpIVlN1?=
 =?utf-8?B?bE9QRUFOL3hrZUd6ZEtRVGZhd2k2cko4WlVnTEtlcEpwOFBoUGZFdWdsTnU4?=
 =?utf-8?B?R1VKdTdyY1FNQ1BhUy8weit6T3l1ZXpxa2JaTW9sTkh2UWV0Z1ZNNXZYZTFp?=
 =?utf-8?B?NTY4UUs4MFpXNTlzdENFbEFIOXlIcHlLZDI0RG5JRXo4RVRhK3MyN3RoL3NO?=
 =?utf-8?B?SGNsQjFEQTVSM3d2VTl2VkZmWHJBMnhUb1I5YnRhbDIwT3FsZFNlUTU1V3FR?=
 =?utf-8?B?QUVzMXpYNVZwR1FlZHYrQ25WS29TVHNjZ3V5UUxwakpBa3c5WEpUbUxhY1Vh?=
 =?utf-8?B?OXYrckM0UnhacHNMbllaMm9xVjFQSHQ0cmVQWGRRc2hTWFVJUmZkWlcxcnNT?=
 =?utf-8?B?YWl1VkRIQndQVFZtemF3bThYVnVDU0R4N3hicDdBeUtkWG9yTlNBZmU0R2M4?=
 =?utf-8?B?M2xIV1o3SkQ4c2tkdFpueEpkT0Q4OTdzcVN6RUl2bnp2OWNpWkJBZ0ZNVmgx?=
 =?utf-8?Q?VY1epb9aoiOhlRgBnhRkH8kjBa1cP8ijCw?=
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 09:58:23.7812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f9795e6-c25b-4859-ddcd-08d8b3bbefec
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fVHrb7Sd1VH5aL9wfexQWDKtFYsVXPY+SEiJk4m1PBh3Ok/ja+dTYgZFkKtnA7L5LOU9szDllnMyv4VfU134uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3818
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610099907; bh=amMVV2UxTsT/xQFRAJQYw3TAIH8iMgTG6Lw3kROkg+w=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Exchange-Transport-Forked:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=fJhQXfKZoIMP9fPrf4zBxFlWpTPZKLC+GinSMR39+6sTiGYCnircgLWuAvylYIkDp
         dguSv9oz3+V5fOwfNiFfZCri3t0a+jjF3+xMA+lGfO4rFDF8B3Xzb25Lv02ziPQYVu
         XKquj31uHpPhA6rVeA4RW5YdON0qaD2EHhxlgQjRWImdVN80AN0ozePV9Qr6BhcxCS
         4H2G+jH6m6QV4ENIj09l+RMAqs7MkLXzbWhk24kX10hQluUCLhTygwyBLQUJ88t6Gp
         PyYTObUKXM7+vs/I131ffpuW1kwCMRFiAsi5z4cnBhte+vGfDS9g0gkP2zVI9fX1aS
         Jx3PITe1YGppA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/01/2021 02:20, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There is an effort to convert .ndo_get_stats64 to sleepable context, and
> for that to work, we need to prevent callers of dev_get_stats from using
> atomic locking.
> 
> The bonding driver retrieves its statistics recursively from its lower
> interfaces, with additional care to only count packets sent/received
> while those lowers were actually enslaved to the bond - see commit
> 5f0c5f73e5ef ("bonding: make global bonding stats more reliable").
> 
> Since commit 87163ef9cda7 ("bonding: remove last users of bond->lock and
> bond->lock itself"), the bonding driver uses the following protection
> for its array of slaves: RCU for readers and rtnl_mutex for updaters.
> This is not great because there is another movement [ somehow
> simultaneous with the one to make .ndo_get_stats64 sleepable ] to reduce
> driver usage of rtnl_mutex. This makes sense, because the rtnl_mutex has
> become a very contended resource.
> 
> The aforementioned commit removed an interesting comment:
> 
> 	/* [...] we can't hold bond->lock [...] because we'll
> 	 * deadlock. The only solution is to rely on the fact
> 	 * that we're under rtnl_lock here, and the slaves
> 	 * list won't change. This doesn't solve the problem
> 	 * of setting the slave's MTU while it is
> 	 * transmitting, but the assumption is that the base
> 	 * driver can handle that.
> 	 *
> 	 * TODO: figure out a way to safely iterate the slaves
> 	 * list, but without holding a lock around the actual
> 	 * call to the base driver.
> 	 */
> 
> The above summarizes pretty well the challenges we have with nested
> bonding interfaces (bond over bond over bond over...), which need to be
> addressed by a better locking scheme that also not relies on the bloated
> rtnl_mutex.
> 
> Instead of using something as broad as the rtnl_mutex to ensure
> serialization of updates to the slave array, we can reintroduce a
> private mutex in the bonding driver, called slaves_lock.
> This mutex circles the only updater, bond_update_slave_arr, and ensures
> that whatever other readers want to see a consistent slave array, they
> don't need to hold the rtnl_mutex for that.
> 
> Now _of_course_ I did not convert the entire driver to use
> bond_for_each_slave protected by the bond->slaves_lock, and
> rtnl_dereference to bond_dereference. I just started that process by
> converting the one reader I needed: ndo_get_stats64. Not only is it nice
> to not hold rtnl_mutex in .ndo_get_stats64, but it is also in fact
> forbidden to do so (since top-level callers may hold netif_lists_lock,
> which is a sub-lock of the rtnl_mutex, and therefore this would cause a
> lock inversion and a deadlock).
> 
> To solve the nesting problem, the simple way is to not hold any locks
> when recursing into the slave netdev operation, which is exactly the
> approach that we take. We can "cheat" and use dev_hold to take a
> reference on the slave net_device, which is enough to ensure that
> netdev_wait_allrefs() waits until we finish, and the kernel won't fault.
> However, the slave structure might no longer be valid, just its
> associated net_device. That isn't a biggie. We just need to do some more
> work to ensure that the slave exists after we took the statistics, and
> if it still does, reapply the logic from Andy's commit 5f0c5f73e5ef.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v4:
> Now there is code to propagate errors.
> 
> Changes in v3:
> - Added kfree(dev_stats);
> - Removed the now useless stats_lock (bond->bond_stats and
>   slave->slave_stats are now protected by bond->slaves_lock)
> 
> Changes in v2:
> Switched to the new scheme of holding just a refcnt to the slave
> interfaces while recursing with dev_get_stats.
> 
>  drivers/net/bonding/bond_main.c | 113 ++++++++++++++------------------
>  include/net/bonding.h           |  49 +++++++++++++-
>  2 files changed, 99 insertions(+), 63 deletions(-)
> 
[snip]
> +static inline int bond_get_slave_arr(struct bonding *bond,
> +				     struct net_device ***slaves,
> +				     int *num_slaves)
> +{
> +	struct net *net = dev_net(bond->dev);
> +	struct list_head *iter;
> +	struct slave *slave;
> +	int i = 0;
> +
> +	mutex_lock(&bond->slaves_lock);
> +
> +	*slaves = kcalloc(bond->slave_cnt, sizeof(*slaves), GFP_KERNEL);
> +	if (!(*slaves)) {
> +		netif_lists_unlock(net);
> +		return -ENOMEM;
> +	}

The error path looks wrong, you unlock netif_lists and return with slaves_lock held.

Cheers,
 Nik

> +
> +	bond_for_each_slave(bond, slave, iter) {
> +		dev_hold(slave->dev);
> +		*slaves[i++] = slave->dev;
> +	}
> +
> +	*num_slaves = bond->slave_cnt;
> +
> +	mutex_unlock(&bond->slaves_lock);
> +
> +	return 0;
> +}
> +
> +static inline void bond_put_slave_arr(struct net_device **slaves,
> +				      int num_slaves)
> +{
> +	int i;
> +
> +	for (i = 0; i < num_slaves; i++)
> +		dev_put(slaves[i]);
> +
> +	kfree(slaves);
> +}
> +
>  #define BOND_PRI_RESELECT_ALWAYS	0
>  #define BOND_PRI_RESELECT_BETTER	1
>  #define BOND_PRI_RESELECT_FAILURE	2
> 

