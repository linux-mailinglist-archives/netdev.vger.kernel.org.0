Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8636541BCCA
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 04:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243833AbhI2CfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 22:35:10 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13386 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243824AbhI2CfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 22:35:08 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HK0g360Wgz8ywd;
        Wed, 29 Sep 2021 10:28:47 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 10:33:25 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 29 Sep
 2021 10:33:24 +0800
Subject: Re: [PATCH V2 net-next 3/6] ethtool: add support to set/get rx buf
 len via ethtool
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <jdike@addtoit.com>, <richard@nod.at>,
        <anton.ivanov@cambridgegreys.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <saeedb@amazon.com>, <chris.snook@gmail.com>,
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
References: <20210924142959.7798-1-huangguangbin2@huawei.com>
 <20210924142959.7798-4-huangguangbin2@huawei.com>
 <20210924231400.aettgmbwx6m4pdok@lion.mk-sys.cz>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <3eedca6c-5c8d-d2d1-16e5-96a95b492e1a@huawei.com>
Date:   Wed, 29 Sep 2021 10:33:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210924231400.aettgmbwx6m4pdok@lion.mk-sys.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/9/25 7:14, Michal Kubecek wrote:
> On Fri, Sep 24, 2021 at 10:29:56PM +0800, Guangbin Huang wrote:
>> From: Hao Chen <chenhao288@hisilicon.com>
>>
>> Add support to set rx buf len via ethtool -G parameter and get
>> rx buf len via ethtool -g parameter.
>>
>> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
>>   Documentation/networking/ethtool-netlink.rst |  2 ++
>>   include/linux/ethtool.h                      | 18 ++++++++++++++++--
>>   include/uapi/linux/ethtool.h                 |  8 ++++++++
>>   include/uapi/linux/ethtool_netlink.h         |  1 +
>>   net/ethtool/netlink.h                        |  2 +-
>>   net/ethtool/rings.c                          | 17 ++++++++++++++++-
>>   6 files changed, 44 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
>> index a47b0255aaf9..9734b7c1e05d 100644
>> --- a/Documentation/networking/ethtool-netlink.rst
>> +++ b/Documentation/networking/ethtool-netlink.rst
>> @@ -841,6 +841,7 @@ Kernel response contents:
>>     ``ETHTOOL_A_RINGS_RX_MINI``           u32     size of RX mini ring
>>     ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
>>     ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
>> +  ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
>>     ====================================  ======  ==========================
>>   
>>   
>> @@ -857,6 +858,7 @@ Request contents:
>>     ``ETHTOOL_A_RINGS_RX_MINI``           u32     size of RX mini ring
>>     ``ETHTOOL_A_RINGS_RX_JUMBO``          u32     size of RX jumbo ring
>>     ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
>> +  ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
>>     ====================================  ======  ==========================
>>   
>>   Kernel checks that requested ring sizes do not exceed limits reported by
> 
> Would it make sense to let driver report also maximum supported value
> like it does for existing ring parameters (ring sizes)?
> 
> Michal
> 
We think it have no sense to report maximum supported value.
Rx buf len of hns3 driver only supports 2048 and 4096 at present, they are
discrete value and checked by driver.
