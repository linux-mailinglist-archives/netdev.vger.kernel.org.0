Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6649E44126F
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 04:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhKADpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 23:45:08 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:15322 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbhKADpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 23:45:03 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HjJkg1mRcz90cS;
        Mon,  1 Nov 2021 11:42:19 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 1 Nov 2021 11:42:19 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Mon, 1 Nov
 2021 11:42:18 +0800
Subject: Re: [PATCH V5 net-next 0/6] ethtool: add support to set/get tx
 copybreak buf size and rx buf len
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
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
References: <20211030131001.38739-1-huangguangbin2@huawei.com>
 <YX2H3yN2tJXKt+ai@lunn.ch>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <f4937fea-4693-e534-38db-e8c64158ce55@huawei.com>
Date:   Mon, 1 Nov 2021 11:42:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <YX2H3yN2tJXKt+ai@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/10/31 1:58, Andrew Lunn wrote:
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
> How does this interact with MTU? If i have an MTU of 1500, and i set
> the rx-buf-len to 1000, can i expect all frames to the discarded?
> Should the core return -EINVAL? Or do you think some hardware will
> simply allocate two buffers and scatter/gather over them? Which
> implies that drivers which cannot SG must check if the rx-buf-len is
> less than the MTU and return -EINVAL?
> 
>       Andrew
> .
> 
Yes, hns3 driver supports scatter/gather for this situation, it's necessary
for driver which cannot support SG to check if rx buf len is less than mtu.
