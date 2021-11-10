Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FDF44B9E7
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 02:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhKJBUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 20:20:02 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15813 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhKJBUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 20:20:01 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hpn4p0GB1z913D;
        Wed, 10 Nov 2021 09:16:58 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 09:17:12 +0800
Received: from [10.67.103.87] (10.67.103.87) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Wed, 10 Nov
 2021 09:17:12 +0800
Subject: Re: [RFCv4 PATCH net-next] net: extend netdev_features_t
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>
References: <20211107101519.29264-1-shenjian15@huawei.com>
 <YYr3FXJC3eu4AN31@lunn.ch>
From:   "shenjian (K)" <shenjian15@huawei.com>
Message-ID: <86fa46f8-2a20-8912-7ec2-19257d6598db@huawei.com>
Date:   Wed, 10 Nov 2021 09:17:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <YYr3FXJC3eu4AN31@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.103.87]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/11/10 6:32, Andrew Lunn 写道:
>> -	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
>> +	if ((netdev_active_features_test_bit(netdev, NETIF_F_HW_TC_BIT) >
>> +	    netdev_features_test_bit(NETIF_F_NTUPLE_BIT, features)) &&
> Using > is interesting.
will use

if (netdev_active_features_test_bit(netdev, NETIF_F_HW_TC_BIT) &&
     !netdev_features_test_bit(netdev, NETIF_F_HW_TC_BIT))

instead.

> But where did NETIF_F_NTUPLE_BIT come from?
Thanks for catching this!


>
>> -	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
>> -		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
>> -		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
>> -		NETIF_F_GRO | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_GRE |
>> -		NETIF_F_GSO_GRE_CSUM | NETIF_F_GSO_UDP_TUNNEL |
>> -		NETIF_F_SCTP_CRC | NETIF_F_FRAGLIST;
>> +	netdev_features_zero(&features);
>> +	netdev_features_set_array(hns3_default_features_array,
>> +				  ARRAY_SIZE(hns3_default_features_array),
>> +				  &features);
> The original code is netdev->features |= so it is appending these
> bits. Yet the first thing the new code does is zero features?
>
>        Andrew
> .
The features is a local variable, the change for netdev->active_features 
is later, by calling

netdev_active_features_direct_or(netdev, features);


By the way, have you reveiwed the rest of patch ? Is there anything else need to rework ?

I wonder whether to go ahead.

Thanks!

     Jian

