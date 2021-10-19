Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A044F4337D4
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 15:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbhJSN4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 09:56:44 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:24360 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhJSN4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 09:56:43 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HYZqk1X8szbgYm;
        Tue, 19 Oct 2021 21:49:54 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 21:54:27 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Tue, 19 Oct
 2021 21:54:25 +0800
Subject: Re: [PATCH V4 net-next 0/6] ethtool: add support to set/get tx
 copybreak buf size and rx buf len
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <andrew@lunn.ch>, <amitc@mellanox.com>, <idosch@idosch.org>,
        <danieller@nvidia.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <jdike@addtoit.com>,
        <richard@nod.at>, <anton.ivanov@cambridgegreys.com>,
        <netanel@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <chris.snook@gmail.com>,
        <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <jeroendb@google.com>, <csully@google.com>,
        <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <linux-s390@vger.kernel.org>
References: <20211014113943.16231-1-huangguangbin2@huawei.com>
 <20211014131420.23598-1-alexandr.lobakin@intel.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <e6d91f02-702c-e1b2-ffdd-15f317508443@huawei.com>
Date:   Tue, 19 Oct 2021 21:54:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20211014131420.23598-1-alexandr.lobakin@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/14 21:14, Alexander Lobakin wrote:
> From: Guangbin Huang <huangguangbin2@huawei.com>
> Date: Thu, 14 Oct 2021 19:39:37 +0800
> 
> Hi there,
> 
>> From: Hao Chen <chenhao288@hisilicon.com>
>>
>> This series add support to set/get tx copybreak buf size and rx buf len via
>> ethtool and hns3 driver implements them.
>>
>> Tx copybreak buf size is used for tx copybreak feature which for small size
>> packet or frag. Use ethtool --get-tunable command to get it, and ethtool
>> --set-tunable command to set it, examples are as follow:
>>
>> 1. set tx spare buf size to 102400:
>> $ ethtool --set-tunable eth1 tx-buf-size 102400
>>
>> 2. get tx spare buf size:
>> $ ethtool --get-tunable eth1 tx-buf-size
>> tx-buf-size: 102400
> 
> Isn't that supposed to be changed on changing Tx copybreak value
> itsef?
> And what if I set Tx copybreak buf size value lower than Tx
> copybreak? I see no sanity checks for this.
> 
Hi Alexander,
HNS3 driver still execute the previous packet sending process
when tx copybreak buf size is lower than tx copybreak,
So, we have no check for tx copybreak buf size when set it.

>> Rx buf len is buffer length of each rx BD. Use ethtool -g command to get
>> it, and ethtool -G command to set it, examples are as follow:
>>
>> 1. set rx buf len to 4096
>> $ ethtool -G eth1 rx-buf-len 4096
>>
>> 2. get rx buf len
>> $ ethtool -g eth1
>> ...
>> RX Buf Len:     4096
> 
> Isn't that supposed to be changed on changing MTU?
> And what if I set Rx buf len value lower than MTU? I see no checks
> as well.
> 
> That means, do we _really_ need two new tunables?
> 
When MTU remains unchanged and rx buf len changes from 2048 to 4096.
TCP packet receiving bandwidth of single thread changes from 34.1 Gbps to 48.6 Gbps(improve 42.5%).
it means that when we enable hardware GRO, it make sense to change rx buf len.

And if we set rx buf len(only support 2k, 4k) which is lower than MTU,
it will split packages into smaller chunks to rx bd, and in general situations,
rx buf len is greater than MTU.

>> Change log:
>> V3 -> V4
>> 1.Fix a few allmodconfig compile warning.
>> 2.Add more '=' synbol to ethtool-netlink.rst to refine format.
>> 3.Move definement of struct ethtool_ringparam_ext to include/linux/ethtool.h.
>> 4.Move related modify of rings_fill_reply() from patch 4/6 to patch 3/6.
>>
>> V2 -> V3
>> 1.Remove documentation for tx copybreak buf size, there is description for
>> it in userspace ethtool.
>> 2.Move extending parameters for get/set_ringparam function from patch3/6
>> to patch 4/6.
>>
>> V1 -> V2
>> 1.Add documentation for rx buf len and tx copybreak buf size.
>> 2.Extend structure ringparam_ext for extenal ring params.
>> 3.Change type of ETHTOOL_A_RINGS_RX_BUF_LEN from NLA_U32 to
>>    NLA_POLICY_MIN(NLA_U32, 1).
>> 4.Add supported_ring_params in ethtool_ops to indicate if support external
>>    params.
>>
> 
> [snip]
> 
> Thanks,
> Al
> .
> 
