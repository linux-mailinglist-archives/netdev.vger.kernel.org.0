Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E69541BCA4
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 04:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243734AbhI2CVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 22:21:40 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13384 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243048AbhI2CVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 22:21:39 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HK0MV4Mt4z900D;
        Wed, 29 Sep 2021 10:15:18 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 10:19:53 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 29 Sep
 2021 10:19:51 +0800
Subject: Re: [PATCH V2 net-next 1/6] ethtool: add support to set/get tx
 copybreak buf size via ethtool
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
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
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <linux-s390@vger.kernel.org>
References: <20210924142959.7798-1-huangguangbin2@huawei.com>
 <20210924142959.7798-2-huangguangbin2@huawei.com>
 <20210924230537.cxiopoi3mwlpgx5c@lion.mk-sys.cz>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <7be0fd4c-e940-8f1b-9fa2-8b0aae9a900a@huawei.com>
Date:   Wed, 29 Sep 2021 10:19:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210924230537.cxiopoi3mwlpgx5c@lion.mk-sys.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/25 7:05, Michal Kubecek wrote:
> On Fri, Sep 24, 2021 at 10:29:54PM +0800, Guangbin Huang wrote:
>> From: Hao Chen <chenhao288@hisilicon.com>
>>
>> Add support for ethtool to set/get tx copybreak buf size.
>>
>> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
>>   Documentation/networking/ethtool-netlink.rst | 24 ++++++++++++++++++++
>>   include/uapi/linux/ethtool.h                 |  1 +
>>   net/ethtool/common.c                         |  1 +
>>   net/ethtool/ioctl.c                          |  1 +
>>   4 files changed, 27 insertions(+)
>>
>> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
>> index d9b55b7a1a4d..a47b0255aaf9 100644
>> --- a/Documentation/networking/ethtool-netlink.rst
>> +++ b/Documentation/networking/ethtool-netlink.rst
>> @@ -1521,6 +1521,30 @@ Kernel response contents:
>>     ``ETHTOOL_A_PHC_VCLOCKS_INDEX``       s32     PHC index array
>>     ====================================  ======  ==========================
>>   
>> +TUNABLE_SET
>> +===========
>> +
>> +Request contents:
>> +
>> +  =====================================  ======  ==========================
>> +  ``ETHTOOL_TX_COPYBREAK_BUF_SIZE``      u32     buf size for tx copybreak
>> +  =====================================  ======  ==========================
>> +
>> +Tx copybreak buf size is used for tx copybreak feature, the feature is used
>> +for small size packet or frag. It adds a queue based tx shared bounce buffer
>> +to memcpy the small packet when the len of xmitted skb is below tx_copybreak
>> +(value to distinguish small size and normal size), and reduce the overhead
>> +of dma map and unmap when IOMMU is on.
>> +
>> +TUNABLE_GET
>> +===========
>> +
>> +Kernel response contents:
>> +
>> +  ====================================  ======  ==========================
>> +  ``ETHTOOL_TX_COPYBREAK_BUF_SIZE``     u32     buf size for tx copybreak
>> +  ====================================  ======  ==========================
> 
> I have to repeat my concerns expressed in
> 
>    https://lore.kernel.org/netdev/20210826072618.2lu6spapkzdcuhyv@lion.mk-sys.cz
> 
> and earlier in more details in
> 
>    https://lore.kernel.org/netdev/20200325164958.GZ31519@unicorn.suse.cz
> 
> That being said, I don't understand why this patch adds description of
> two new message types to the documentation of ethtool netlink API but it
> does not actually add them to the API. Instead, it adds the new tunable
> to ioctl API.
> 
> Michal
> 

Hi Michal, thanks for your opinion.
Is there any documentation for ioctl API? We didn't find it.
Or we add a new documentation of ioctl API for the new tunable?

Guangbin
