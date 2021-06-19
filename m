Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B70F3AD6F8
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 05:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbhFSDW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 23:22:58 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5044 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbhFSDW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 23:22:57 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G6LXD0CxwzXhRq;
        Sat, 19 Jun 2021 11:15:40 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 19 Jun 2021 11:20:44 +0800
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 19 Jun
 2021 11:20:44 +0800
Subject: Re: [PATCH net-next 8/9] net: hns3: add support for queue bonding
 mode of flow director
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Huazhong Tan <tanhuazhong@huawei.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>
References: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
 <1615811031-55209-9-git-send-email-tanhuazhong@huawei.com>
 <20210315130448.2582a0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b7b23988-ecba-1ce4-6226-291938c92c08@huawei.com>
 <20210317182828.70fcc61d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9107b490-d74c-7ff2-de40-eb77770f0a64@huawei.com>
 <20210618150156.0ffc88a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <d276b445-ae19-cdf3-f2fc-cd32b91da02f@huawei.com>
Date:   Sat, 19 Jun 2021 11:20:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <20210618150156.0ffc88a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/6/19 6:01, Jakub Kicinski 写道:
> On Fri, 18 Jun 2021 09:18:21 +0800 shenjian (K) wrote:
>> Hi  Jakub，
>>
>>
>> 在 2021/3/18 9:28, Jakub Kicinski 写道:
>>> On Thu, 18 Mar 2021 09:02:54 +0800 Huazhong Tan wrote:
>>>> On 2021/3/16 4:04, Jakub Kicinski wrote:
>>>>> On Mon, 15 Mar 2021 20:23:50 +0800 Huazhong Tan wrote:
>>>>>> From: Jian Shen <shenjian15@huawei.com>
>>>>>>
>>>>>> For device version V3, it supports queue bonding, which can
>>>>>> identify the tuple information of TCP stream, and create flow
>>>>>> director rules automatically, in order to keep the tx and rx
>>>>>> packets are in the same queue pair. The driver set FD_ADD
>>>>>> field of TX BD for TCP SYN packet, and set FD_DEL filed for
>>>>>> TCP FIN or RST packet. The hardware create or remove a fd rule
>>>>>> according to the TX BD, and it also support to age-out a rule
>>>>>> if not hit for a long time.
>>>>>>
>>>>>> The queue bonding mode is default to be disabled, and can be
>>>>>> enabled/disabled with ethtool priv-flags command.
>>>>> This seems like fairly well defined behavior, IMHO we should have a full
>>>>> device feature for it, rather than a private flag.
>>>> Should we add a NETIF_F_NTUPLE_HW feature for it?
>>> It'd be better to keep the configuration close to the existing RFS
>>> config, no? Perhaps a new file under
>>>
>>>     /sys/class/net/$dev/queues/rx-$id/
>>>
>>> to enable the feature would be more appropriate?
>>>
>>> Otherwise I'd call it something like NETIF_F_RFS_AUTO ?
>> I noticed that the enum NETIF_F_XXX_BIT has already used 64 bits since
>>
>> NETIF_F_HW_HSR_DUP_BIT being added, while the prototype of
>> netdev_features_t
>>
>> is u64.   So there is no useable bit for new feature if I understand
>> correct.
>>
>> Is there any solution or plan for it ?
> I think you'll need to start a new word.
> .
>
what about define a netdev feature bitmap

#define __DECLARE_NETDEV_FEATURE_T(name)        \
     DECLARE_BITMAP(name, NETDEV_FEATURE_COUNT)

like __ETHTOOL_DECLARE_LINK_MODE_MASK does


