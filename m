Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D248B2E9FAF
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 22:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbhADV4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 16:56:10 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8626 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbhADV4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 16:56:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff38ed10000>; Mon, 04 Jan 2021 13:55:29 -0800
Received: from [172.27.14.94] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan
 2021 21:55:16 +0000
Subject: Re: [PATCH net-next v3 2/4] sch_htb: Hierarchical QoS hardware
 offload
To:     Jakub Kicinski <kuba@kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <netdev@vger.kernel.org>
References: <20201215074213.32652-1-maximmi@mellanox.com>
 <20201215074213.32652-4-maximmi@mellanox.com>
 <20201221171736.6f5ebe1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <04607f76-3548-f6d1-061c-8d5d918f4017@nvidia.com>
Date:   Mon, 4 Jan 2021 23:55:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201221171736.6f5ebe1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609797329; bh=w7M38qCZ2oY4xaD0XF29muUtcKqTnB+WaiwkotYYXUM=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=BgwZgwqoFNukbV2vb5jfLFTQkrH3yykRXfQKFcpleGjC/LPBTQM8T86cZC6hEumTE
         9ZMk5HNdvBkkuDGtbHRW4muZ6U5jsQBCXjjE0mu4rku1rU1ZJXXquApb1601RHXATM
         9inqv2Y4PgJsKRq+WAAWdOMEu8eGUKpl9CRzMQ1MsWxKwUh/mAgyUpDIyZt6Wxi/u2
         Xx1nGoj175KF6X/G0ZiUdktMvef4hkdygIROh1vXisF2PUU0f/bTSn1j5k7+bFmwmD
         17bHWaS5igGhNnYU2zYaBxHztsfHFbCvrLxNkNDfcCXWKDqcMWvJTHiv24PGR+LhGO
         BOqZF8JjcgIvA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-22 03:17, Jakub Kicinski wrote:
> On Tue, 15 Dec 2020 09:42:11 +0200 Maxim Mikityanskiy wrote:
>> +	q->offload = nla_get_flag(tb[TCA_HTB_OFFLOAD]);
>> +
>> +	if (q->offload) {
>> +		if (!tc_can_offload(dev) || !dev->netdev_ops->ndo_setup_tc)
>> +			return -EOPNOTSUPP;
> 
> Is there a check somewhere making sure this is the root?

No, I should add something like:
         if (sch->parent != TC_H_ROOT)
                 return -EOPNOTSUPP;

Thanks.

>> +		q->num_direct_qdiscs = dev->real_num_tx_queues;
> 
> Why real_num_tx_queues? How do you handle queue count changes?

When HTB gets attached, we query the number of regular TX queues and use 
them for HTB direct (unclassified) traffic. When HTB is already 
attached, changing the number of channels is blocked by the driver, so 
the amount of direct queues doesn't change (otherwise it would be hard 
to maintain correspondence between queues and classes). However, new 
queues are added (i.e. real_num_tx_queues increases) when HTB classes 
are added.

>> +		q->direct_qdiscs = kcalloc(q->num_direct_qdiscs,
>> +					   sizeof(*q->direct_qdiscs),
>> +					   GFP_KERNEL);
>> +		if (!q->direct_qdiscs)
>> +			return -ENOMEM;
>> +	}
> 
> I can't quite parse after 20 minutes of staring at this code what the
> relationship between the device queues and classes is. Is there any
> relationship between real_num_tx_queues and classes?
> 

Let's say we had N TX queues before attaching HTB (i.e. 
real_num_tx_queues was N). Then queues 0..N-1 correspond to direct mode 
of HTB, and queues starting from N are used for leaf classes. So, when 
some classes are added, real_num_tx_queues will be bigger than N (say, 
it would be M), and queues N..M-1 will correspond to leaf classes. Inner 
classes don't have a backing queue.

In the current implementation, one leaf class is backed by one queue, 
but it can be changed in the future to allow multiple queues to back a 
class.

The mapping is stored in the driver and used in ndo_select_queue.

I hope it answers your question, but I'm ready to provide more details 
if you ask.

Thanks,
Max
