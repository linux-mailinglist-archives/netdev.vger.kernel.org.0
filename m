Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD45018AABB
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 03:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgCSChj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 22:37:39 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3479 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726623AbgCSChi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 22:37:38 -0400
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 1C37A70826ADA42F216E;
        Thu, 19 Mar 2020 10:37:35 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 19 Mar 2020 10:37:34 +0800
Received: from [10.173.219.71] (10.173.219.71) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 19 Mar 2020 10:37:34 +0800
Subject: Re: [PATCH net 1/6] hinic: fix process of long length skb without
 frags
To:     David Miller <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <aviad.krawczyk@huawei.com>, <luoxianjun@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <yin.yinshi@huawei.com>
References: <20200316005630.9817-1-luobin9@huawei.com>
 <20200316005630.9817-2-luobin9@huawei.com>
 <20200316144408.00797c6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200316.173330.2197524619383790235.davem@davemloft.net>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <69cec570-7b7d-f779-3ef3-b7f658f64555@huawei.com>
Date:   Thu, 19 Mar 2020 10:37:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200316.173330.2197524619383790235.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.173.219.71]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok，I will undo this patch.

On 2020/3/17 8:33, David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Mon, 16 Mar 2020 14:44:08 -0700
>
>> On Mon, 16 Mar 2020 00:56:25 +0000 Luo bin wrote:
>>> -#define MIN_SKB_LEN                     17
>>> +#define MIN_SKB_LEN			17
>>> +#define HINIC_GSO_MAX_SIZE		65536
>>> +	if (unlikely(skb->len > HINIC_GSO_MAX_SIZE && nr_sges == 1)) {
>>> +		txq->txq_stats.frag_len_overflow++;
>>> +		goto skb_error;
>>> +	}
>> I don't think drivers should have to check this condition.
>>
>> We have netdev->gso_max_size which should be initialized to
>>
>> include/linux/netdevice.h:#define GSO_MAX_SIZE          65536
>>
>> in
>>
>> net/core/dev.c: dev->gso_max_size = GSO_MAX_SIZE;
>>
>> Please send a patch to pktgen to uphold the normal stack guarantees.
> Agreed, the driver should not have to validate this.
> .
