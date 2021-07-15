Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2AF3C98D1
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 08:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhGOGhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 02:37:34 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:11278 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbhGOGhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 02:37:34 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GQPbH5bRxz1CJ32;
        Thu, 15 Jul 2021 14:28:59 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Jul 2021 14:34:38 +0800
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 15 Jul
 2021 14:34:38 +0800
Subject: Re: [RFC net-next] net: extend netdev features
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>,
        "shenjian15@huawei.com" <shenjian15@huawei.com>
References: <1625910047-56840-1-git-send-email-shenjian15@huawei.com>
 <YOm82gTf/efnR7Fj@lunn.ch> <2b6bc8a7-6fe3-b42e-070d-f9a81560ecda@huawei.com>
 <YO2avXo6XSBEzZb/@lunn.ch>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <4172ae73-a43d-18be-aca6-9dd02b69ac09@huawei.com>
Date:   Thu, 15 Jul 2021 14:34:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <YO2avXo6XSBEzZb/@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/7/13 21:53, Andrew Lunn 写道:
>> Hi Andrew,
>>
>> Thanks for your advice.
>>
>> I have thought of using linkmode_ before (https://lists.openwall.net/netdev/
>> 2021/06/19/11).
>>
>> In my humble opinion, there are too many logical operations in stack and
>> ethernet drivers,
>> I'm not sure changing them to the linkmode_set_ API is the best way. For
>> example,
>>
>> below is codes in ethernet drivre:
>> netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
>>          NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
>>          NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
>>          NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
>>          NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
>>          NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
>>
>> When using linkmode_ API, I have two choices, one is to define several feature
>> arrays or
>> a whole features array including all the feature bits supported by the ethernet
>> driver.
>> const int hns3_nic_vlan_features_array[] = {
>>      NETIF_F_HW_VLAN_CTAG_FILTER,
>>      NETIF_F_HW_VLAN_CTAG_TX,
>>      NETIF_F_HW_VLAN_CTAG_RX,
>> };
>> const int hns3_nic_tso_features_array[] = {
>>      NETIF_F_GSO,
>>      NETIF_F_TSO,
>>      NETIF_F_TSO6,
>>      NETIF_F_GSO_GRE,
>>      ...
>> };
> Using arrays is the way to go. Hopefully Coccinelle can do most of the
> work for you.
>
>> linkmode_set_bit_array(hns3_nic_vlan_features_array, ARRAY_SIZE
>> (hns3_nic_vlan_features_array), netedv->features);
> I would probably add wrappers. So an API like
>
> netdev_feature_set_array(ndev, int hns3_nic_tso_features_array),
>                           ARRAY_SIZE(int hns3_nic_tso_features_array);
>
> netdev_hw_feature_set_array(ndev, int hns3_nic_tso_features_array),
>                              ARRAY_SIZE(int hns3_nic_vlan_features_array);
>
> etc. This will help during the conversion. You can keep
> netdev_features_t as a u64 while you convert to the mew API. Once the
> conversion is done, you can then convert the implementation of the API
> to a linux bitmap.
This way looks much better. I'm being troubled to split these changes 
from the
single huge patch. These wrappers can help. Thanks!

>> When using netdev_feature_t *, then just need to add an arrary index.
>>
>> netdev->features[0] |= NETIF_F_HW_VLAN_CTAG_FILTER |
>>          NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX | xxxxxx
>>
> And you want to add
>
> netdev->features[1] |= NETIF_F_NEW_FEATURE;
>
> This is going to result in errors, where developers add
> NETIF_F_NEW_FEATURE to feature[0], and the compiler will happily do
> it, no warnings. Either you need the compiler to enforce the correct
> assignment to the array members somehow, or you need a uniform API
> which you cannot get wrong.
Yes, this is prone to error, and compiler won't warn it. I will 
reconsider the
array and linux bitmap.

>> By the way, could you introduce me some code re-writing tools ?
> Coccinelle.
>
> https://www.kernel.org/doc/html/latest/dev-tools/coccinelle.html
> https://coccinelle.gitlabpages.inria.fr/website/
> I've no idea if it can do this level of code re-write. You probably
> want to post on the mailing list, describe what you want to do.
>
>       Andrew
> .
Thanks, I'll see how to use it.

