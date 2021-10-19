Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E64843377D
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 15:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhJSNqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 09:46:54 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:25235 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235739AbhJSNqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 09:46:53 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HYZhD5S7Qz8tfG;
        Tue, 19 Oct 2021 21:43:24 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 21:44:38 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Tue, 19 Oct
 2021 21:44:36 +0800
Subject: Re: [PATCH V4 net-next 1/6] ethtool: add support to set/get tx
 copybreak buf size via ethtool
To:     Eric Dumazet <eric.dumazet@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <mkubecek@suse.cz>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <jdike@addtoit.com>, <richard@nod.at>,
        <anton.ivanov@cambridgegreys.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <gtzalik@amazon.com>, <saeedb@amazon.com>,
        <chris.snook@gmail.com>, <ulli.kroll@googlemail.com>,
        <linus.walleij@linaro.org>, <jeroendb@google.com>,
        <csully@google.com>, <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>, <linux-s390@vger.kernel.org>
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
 <20211014113943.16231-2-huangguangbin2@huawei.com>
 <e4e276c6-9545-cf6a-b23e-a80123e896a0@gmail.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <a8b9b95a-d7e3-53ad-cf87-9bb6f1610c5a@huawei.com>
Date:   Tue, 19 Oct 2021 21:44:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <e4e276c6-9545-cf6a-b23e-a80123e896a0@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/14 21:58, Eric Dumazet wrote:
> 
> 
> On 10/14/21 4:39 AM, Guangbin Huang wrote:
>> From: Hao Chen <chenhao288@hisilicon.com>
>>
>> Add support for ethtool to set/get tx copybreak buf size.
> 
> What is the unit ?
> 
> Frankly, having to size the 'buffer' based on number of slots in TX ring buffer
> is not good.
> 
> What happens later when/if ethtool -G tx xxxxx' is trying
> to change number of slots ?
> 
> The 'tx copybreak' should instead give a number of bytes per TX ring slot.
> 
> Eg, 128 or 256 bytes.
> 
> This is very similar to what drivers using net/core/tso.c do.
> 
> They usually use TSO_HEADER_SIZE for this.
> 
Hi Eric,
The unit is bytes.

Tx copybreak buf is a queue based tx shared bounce buffer and it is allocated
based on page size, not based on slot numbers. When the len of xmitted skb is
below tx_copybreak, tx copybreak buf will share buffer of specific size(slot size)
for tx to memcpy the small packet.

So, what you mentioned seems not related to this patch.

>>
>> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
>>   include/uapi/linux/ethtool.h | 1 +
>>   net/ethtool/common.c         | 1 +
>>   net/ethtool/ioctl.c          | 1 +
>>   3 files changed, 3 insertions(+)
>>
>> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
>> index a2223b685451..7bc4b8def12c 100644
>> --- a/include/uapi/linux/ethtool.h
>> +++ b/include/uapi/linux/ethtool.h
>> @@ -231,6 +231,7 @@ enum tunable_id {
>>   	ETHTOOL_RX_COPYBREAK,
>>   	ETHTOOL_TX_COPYBREAK,
>>   	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
>> +	ETHTOOL_TX_COPYBREAK_BUF_SIZE,
>>   	/*
>>   	 * Add your fresh new tunable attribute above and remember to update
>>   	 * tunable_strings[] in net/ethtool/common.c
>> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
>> index c63e0739dc6a..0c5210015911 100644
>> --- a/net/ethtool/common.c
>> +++ b/net/ethtool/common.c
>> @@ -89,6 +89,7 @@ tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
>>   	[ETHTOOL_RX_COPYBREAK]	= "rx-copybreak",
>>   	[ETHTOOL_TX_COPYBREAK]	= "tx-copybreak",
>>   	[ETHTOOL_PFC_PREVENTION_TOUT] = "pfc-prevention-tout",
>> +	[ETHTOOL_TX_COPYBREAK_BUF_SIZE] = "tx-copybreak-buf-size",
>>   };
>>   
>>   const char
>> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
>> index bf6e8c2f9bf7..617ebc4183d9 100644
>> --- a/net/ethtool/ioctl.c
>> +++ b/net/ethtool/ioctl.c
>> @@ -2383,6 +2383,7 @@ static int ethtool_tunable_valid(const struct ethtool_tunable *tuna)
>>   	switch (tuna->id) {
>>   	case ETHTOOL_RX_COPYBREAK:
>>   	case ETHTOOL_TX_COPYBREAK:
>> +	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
>>   		if (tuna->len != sizeof(u32) ||
>>   		    tuna->type_id != ETHTOOL_TUNABLE_U32)
>>   			return -EINVAL;
>>
> .
> 
