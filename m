Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C8736D394
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 10:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbhD1IBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 04:01:41 -0400
Received: from mail-eopbgr770042.outbound.protection.outlook.com ([40.107.77.42]:11535
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229643AbhD1IBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 04:01:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QLSH4kI4lw9nZQYf2atUsyf02ACVF4hScoq8AVRg2wH9EfzRH36W9Oxjia9yNU2zNeHyN7FBiqK5zkTJgalzZeEYzIQBKVUPfuhqlycrB4uzpXSQbbsAwKOuRFTj9DOtyMhezhoJn/tbi0RFevbTux/AxpKrkHvsh9Z0BGRF0QDqF4zwMw2seEs0xjt8Lo3wEgudvbGJNI1TpL5ZfXoW9QV9IFLKR2s1+Um3p6JJfomGhghTpKTLLvwCjLiUZ8RdIgq0e4CJ3OFpRtWA++Fs4JpMUVkaJElCGiSMQp9jO66MmaJ/eoHX4vqeqtSxDbo5jf2kywYVgtnmDfsH5iVz5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iIpZ6e6Q2CXjnWADVyUuhGg0L3hnwW/AVtfRVGNqssw=;
 b=XsA4CZHLy+lA4JmQ/dfCi2ikhQZr18rft5qhA/CxqNAoffN+A7zqEqKLguwxU+XeToyGhdVz9NTZEhhvHiMUghBEs3NSLzUWPNJWBntwoVnHZuR5gyu8HeiFwLXotcRPDig8acH6/jjPyjKKycqS5iBBpKGoyKVVBuGjEqi0z0HCWAmbBnSx44uML/S+fzdL1gMLC7nnNVK6AvkTqAsosS2pZ/uXbjvbBMrkRpJTjw8PnOVWZ2aXnCuXoZcLRj2lHjmtCZU3lyKywEmhuH/luumtj5B4/MELAbXH4M6J2QA23fejPsD2vEskADpokmUKLx7V53dY7yA4FxUdmgU/qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iIpZ6e6Q2CXjnWADVyUuhGg0L3hnwW/AVtfRVGNqssw=;
 b=R2Qx0riGOmd5ErY7G/JJx35SrD2Lj1/JkWGkAJtXSdEqZqsXcNqzvKTqkNh7ypjCP7lDcW5+vTOmLjUXj/kpKvPWZWnqtb9cSn92wMKactWeEu7nETGzVsy9Cdkz4NpvDrU15bIUJp3Wz4LuhmxOyMHjj9AXa8caGE47DtjNCiV9Tj2+IAkzTEly/EV+Hn/C6R40MxIBlnwfqGRuRXdCng4lk+wGjernQPM4oFS8OEdIZnHkN5jZR263EggWTW9C3CqPAv0SREsMkP4pY+Xi2pQCgpsZkMv6uxwxgafAWOjIEHbKXklj6VMn4DZHZgW/s3Lws9IXXejQClRh5r5lIg==
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5039.namprd12.prod.outlook.com (2603:10b6:5:38a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Wed, 28 Apr
 2021 08:00:55 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::a145:fd5b:8d6f:20e6%2]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 08:00:55 +0000
Subject: Re: [PATCH] bridge: Fix possible races between assigning
 rx_handler_data and setting IFF_BRIDGE_PORT bit
To:     zhangzhengming <zhangzhengming@huawei.com>, roopa@nvidia.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        wangxiaogang3@huawei.com, xuhanbing@huawei.com
References: <1619594949-20428-1-git-send-email-zhangzhengming@huawei.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <9b7b2580-a3a3-d071-4db3-4ef795a1ea68@nvidia.com>
Date:   Wed, 28 Apr 2021 11:00:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <1619594949-20428-1-git-send-email-zhangzhengming@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::8) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.158] (213.179.129.39) by ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.26 via Frontend Transport; Wed, 28 Apr 2021 08:00:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf3277c4-5ecf-4921-c763-08d90a1bc033
X-MS-TrafficTypeDiagnostic: DM4PR12MB5039:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB50399DF9DB849E917F6A3E33DF409@DM4PR12MB5039.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zfDNGOyco3pzVC7tC7BvDSUmPyQIRgC696mxqi+4HmOB2pBMoHaXPmd718LmgbTpXFdZGEmTJXeSiBq734VkIBMNODCTr3uWzmwb3NsyHMJmNM6Hy6w7KUw6D+0VOg0ci0gGnMVFDkay//fEb7tyUc4mwfjsGTquYH3CjH+lyNFc09Bf4XD5spuwRKhmYKXTO4hRA9en5UJETaOqp/MWE1wGlcK7xZIT6iboRMia/kvno51YT8cXoarn6rYysq3N1Yum/bIdWstzyC8zIy9Y4vKjdyPyn3ntCHJBm+A8D5BF4fJw7QICd1qWbdUfyZCMaBx6dWkBw2kmLN9xuoXYq6LgRUiKUaVONe4kxN6ehzypD7X0K6T9jo1UJ+5JL7stQvdx0TzYLCY4zedQiqeaqjoKnyKKZFt8k7v5CeVDI9pU2phO1o793uBbN5c8hT7m3e4Tkie5c9ioiCWqun5QQ6dayAm1rgsWCkEufn5IspvTfeLGTz7wgTqa0dQKH1DOjFwfjKmIcolmU5FU27M28bsuTkywoEEMo/W2nIgPe4Ob9oVfryYV2i8yisOzwkDz5xyc9jiQmou2okUlXTeh3ZeB2L6yb8TGzm9so/PT1SCw5wfp59+s4ThoFLZjr5n5vHX5ZumJWaX22gaJvnBdv82qEjng90A2n6V4CsihaU68/JJgapJlUL2OL1meXulJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(478600001)(83380400001)(956004)(4326008)(2616005)(66946007)(66476007)(2906002)(66556008)(5660300002)(26005)(53546011)(31686004)(38100700002)(86362001)(31696002)(6666004)(36756003)(186003)(8936002)(8676002)(16526019)(6486002)(16576012)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dEFvMlVnRUIxM0owelgzMlUzbVNMZFNCUTlEN01vYTNsUEh4TTBZNGZtTi92?=
 =?utf-8?B?S3JmdlUxcS9nakwzVVpPUDNoeTl6UmRLNis0alE1b1JDOTZCMS9TRzZNQTJK?=
 =?utf-8?B?blptZlZzSjRncTNGWFFYOVA2R0xxM1RZcWxTTGtYUnJ1bDRsWEJHbElpa2xZ?=
 =?utf-8?B?QTRsT2JqMGR2RG0xKzVRWEhhZVZYSU03ejRDcFk0eDdlZkd2K0Nnb1hmNmVp?=
 =?utf-8?B?WXFkZ3Q1eUs1dkVDZTZkK0hOWlB0RDl1Qk5xYmRWTUxncmNTbEZhTU0vQTFX?=
 =?utf-8?B?OTZicWNyT2h2aEV1NS9mTWlia1hOTHZMb08xVmpiczhTL0ZwNWQ3UlRYNTNT?=
 =?utf-8?B?Nm1Ja2NwTzdKRStMZ1JGeWJjTWtERHFBQ0gxTTNCcm5PSHRuaDJjL1MxYmdN?=
 =?utf-8?B?QUtsczhlclUwSS96M2dpRUYxeU5WRUVqTFQzMzVaU2NKeWNsR0g1U3ZseDVD?=
 =?utf-8?B?U3I4c3h4VHdvUUJLZVNONjlWaHB5c0FlRkpqNkFoTHJNbERWVTdIQ0lMekMz?=
 =?utf-8?B?TU5Edk1hSHdKZTRwWlBBcEYrNXVVMXZsYnFnaUx3RHZtV2V6bStSQkd1a3hZ?=
 =?utf-8?B?RUp5VEMrK2JRWlJ2MVpFVkt4NkdnbURxdjlxRENMeTYzdUhRQS94WVlHZmp2?=
 =?utf-8?B?UnAvVWZXTlRjaVpGSzFjQldZNzJ1aHZmd2Y5dTFwZDdlYjdiaVlZVVpJQVly?=
 =?utf-8?B?MklERjFHSXcyemFndDYxdXZMQmhDZEpUR2VnaG1PMWhjd3duYWMvaDhRQlYy?=
 =?utf-8?B?MVNqLzkycFlCK1Fpc0ZSNWd3RHdVeEdhWUlGS2RiMUQ0UGJmRktyVUt0ZXpD?=
 =?utf-8?B?T1QzRkoxMEFVdmpWWE1HWTdpN3FHTTJiVytwUlpkbWhUN0VtWU9rTVNsVThp?=
 =?utf-8?B?OEVXTDcwQlpXdldMajBoa1BGTjhnaHdnZU5hTHFLMCtjd21zUmI4RStPN1pD?=
 =?utf-8?B?a1h2QXltYk1qMEVhZ1llQjd6SWZkUkNhRDlodDNuMEZnWTBPUFBlRW13R0tp?=
 =?utf-8?B?dHMwY0lOR1dhMXNkT1p0Qy9zZjZMNm8yOEZ6Qk9mUEkwSU9sR0RMK3FuYWdW?=
 =?utf-8?B?bjgxdHZuaEJTczZrZ2UvZ1VHSzA5RGRaUi8xclBKVVdVSUZxaGt3M05uT1lP?=
 =?utf-8?B?ZVg1OTZMblNoT1AzcFBvMDc4LzhmZWtYeHdSUi9taWpOS2dpZzhPV3owTm9j?=
 =?utf-8?B?VGFvUTJSaTFzR0xIdHZjd1UxSmlrZStsWlY3NTF4ckdYcktWVVhCVDhYVm9S?=
 =?utf-8?B?Nk9veGRZTFFUR1c4bkJ4dlh6dW56WWpEZHl1c01lQ1BEMlU2YmZjc1NaVXpy?=
 =?utf-8?B?eVhVa09EeUI3d1RLRVh3bGhUaU5KSG5qSGNFazJ1cEZJSjRpM29hVEJQTXlz?=
 =?utf-8?B?T1NpZGpkNEx4K1JJV3YxN1llTXVtMGwyditjME1rbzhkd25OU3lpMW1XWEpQ?=
 =?utf-8?B?aTlWQnZtQitZQ1dOTG1UWHFELzV4cWN2NUI3Q1ZPbTZqakg0UXJaUzJwZnRE?=
 =?utf-8?B?eGwxQ2JIOE1UQVdSNlM3VklPNnk1N2NEdHIyOWF1QUFYbEhHdWtxdEYreXNi?=
 =?utf-8?B?dkdlT0JHZCtQemYxVnNvRzJCbmFvUEhyZ0NXS3VVYzlHeFFZcEgvTXI0TlJu?=
 =?utf-8?B?b1NwcG4vb2o0L1RNL2dnZ3VJOUYvemNwb1l4WmJRVW54MWNkazBPeWVUc3pH?=
 =?utf-8?B?c3lJMmt1eEo3ZWx2ZEwvb0RNVSt4ekEzVWZnbUlxSUVjc2srQlJuNlJjLzht?=
 =?utf-8?Q?V+Z/2PTpTAYxfjUR3uuap2lXcOl9bsQr7jIHJsB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf3277c4-5ecf-4921-c763-08d90a1bc033
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:00:55.6660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5tT1Hj54MAIWm2z4PVX0Vff7BS7Ryw4GprlFXArYJyBdLH/VE4mSFuZSA62RQ1NGkQcsTjldKzUp/Rlwfge8lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5039
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/04/2021 10:29, zhangzhengming wrote:
> From: Zhang Zhengming <zhangzhengming@huawei.com>
> 
> There is a crash in the function br_get_link_af_size_filtered,
> as the port_exists(dev) is true and the rx_handler_data of dev is NULL.
> But the rx_handler_data of dev is correct saved in vmcore.
> 
> The oops looks something like:
>  ...
>  pc : br_get_link_af_size_filtered+0x28/0x1c8 [bridge]
>  ...
>  Call trace:
>   br_get_link_af_size_filtered+0x28/0x1c8 [bridge]
>   if_nlmsg_size+0x180/0x1b0
>   rtnl_calcit.isra.12+0xf8/0x148
>   rtnetlink_rcv_msg+0x334/0x370
>   netlink_rcv_skb+0x64/0x130
>   rtnetlink_rcv+0x28/0x38
>   netlink_unicast+0x1f0/0x250
>   netlink_sendmsg+0x310/0x378
>   sock_sendmsg+0x4c/0x70
>   __sys_sendto+0x120/0x150
>   __arm64_sys_sendto+0x30/0x40
>   el0_svc_common+0x78/0x130
>   el0_svc_handler+0x38/0x78
>   el0_svc+0x8/0xc
> 
> In br_add_if(), we found there is no guarantee that
> assigning rx_handler_data to dev->rx_handler_data
> will before setting the IFF_BRIDGE_PORT bit of priv_flags.
> So there is a possible data competition:
> 
> CPU 0:                                                        CPU 1:
> (RCU read lock)                                               (RTNL lock)
> rtnl_calcit()                                                 br_add_slave()
>   if_nlmsg_size()                                               br_add_if()
>    >                              -> netdev_rx_handler_register
>                                                                     ...
>                                                                     // The order is not guaranteed
>       ...                                                           -> dev->priv_flags |= IFF_BRIDGE_PORT;
>       // The IFF_BRIDGE_PORT bit of priv_flags has been set
>       -> if (br_port_exists(dev)) {
>         // The dev->rx_handler_data has NOT been assigned
>         -> p = br_port_get_rcu(dev);
>         ....
>                                                                     -> rcu_assign_pointer(dev->rx_handler_data, rx_handler_data);
>                                                                      ...
> 
> Fix this by adding memory barrier instruction to ensure the order.
> 
> Signed-off-by: Zhang Zhengming <zhangzhengming@huawei.com>
> Reviewed-by: Zhao Lei <zhaolei69@huawei.com>
> Reviewed-by: Wang Xiaogang <wangxiaogang3@huawei.com>
> ---
>  net/bridge/br_if.c      | 6 ++++++
>  net/bridge/br_netlink.c | 1 +
>  2 files changed, 7 insertions(+)
> 

No need for memory barriers, just use br_port_get_check_rcu() in br_get_link_af_size_filtered()
and check the return value. It will be much simpler and shorter.

Thanks

> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index f7d2f47..42895be 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -636,6 +636,12 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>  	err = netdev_rx_handler_register(dev, br_get_rx_handler(dev), p);
>  	if (err)
>  		goto err4;
> +
> +	/* Make sure dev->rx_handler_data is written in netdev_rx_handler_register
> +	 * before the bit IFF_BRIDGE_PORT of dev->priv_flags is set.
> +	 * coupled with smp_rmb() in br_get_link_af_size_filtered.
> +	 */
> +	smp_wmb();
>  
>  	dev->priv_flags |= IFF_BRIDGE_PORT;
>  
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index f2b1343..ccc1fd7 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -103,6 +103,7 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
>  
>  	rcu_read_lock();
>  	if (netif_is_bridge_port(dev)) {
> +		smp_rmb(); /* coupled with smp_wmb() in br_add_if() */
>  		p = br_port_get_rcu(dev);
>  		vg = nbp_vlan_group_rcu(p);
>  	} else if (dev->priv_flags & IFF_EBRIDGE) {
> 

