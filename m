Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E84A3924A9
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 04:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhE0CC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 22:02:26 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6644 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbhE0CCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 22:02:20 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fr9v52czhz1CF0C;
        Thu, 27 May 2021 09:57:53 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 27 May 2021 10:00:45 +0800
Received: from [127.0.0.1] (10.69.26.252) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 27 May
 2021 10:00:45 +0800
Subject: Re: [RFC net-next 2/4] ethtool: extend coalesce setting uAPI with CQE
 mode
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <thomas.lendacky@amd.com>,
        <irusskikh@marvell.com>, <michael.chan@broadcom.com>,
        <edwin.peer@broadcom.com>, <rohitm@chelsio.com>,
        <jesse.brandeburg@intel.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
References: <1622021262-8881-1-git-send-email-tanhuazhong@huawei.com>
 <1622021262-8881-3-git-send-email-tanhuazhong@huawei.com>
 <20210526170033.62c8e6eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Huazhong Tan <tanhuazhong@huawei.com>
Message-ID: <b29f05f8-3c57-ec6a-78bb-3a22f743f7f1@huawei.com>
Date:   Thu, 27 May 2021 10:00:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210526170033.62c8e6eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.69.26.252]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/5/27 8:00, Jakub Kicinski wrote:
> On Wed, 26 May 2021 17:27:40 +0800 Huazhong Tan wrote:
>> Currently, there many drivers who support CQE mode configuration,
>> some configure it as a fixed when initialized, some provide an
>> interface to change it by ethtool private flags. In order make it
>> more generic, add 'ETHTOOL_A_COALESCE_USE_CQE_TX' and
>> 'ETHTOOL_A_COALESCE_USE_CQE_RX' attribute and expand struct
>> kernel_ethtool_coalesce with use_cqe_mode_tx and use_cqe_mode_rx,
>> then these parameters can be accessed by ethtool netlink coalesce
>> uAPI.
>>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
>> index 25131df..975394e 100644
>> --- a/Documentation/networking/ethtool-netlink.rst
>> +++ b/Documentation/networking/ethtool-netlink.rst
>> @@ -937,6 +937,8 @@ Kernel response contents:
>>     ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
>>     ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
>>     ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
>> +  ``ETHTOOL_A_COALESCE_USE_CQE_TX``	       bool    Tx CQE mode
>> +  ``ETHTOOL_A_COALESCE_USE_CQE_RX``	       bool    Rx CQE mode
>>     ===========================================  ======  =======================
>>   
>>   Attributes are only included in reply if their value is not zero or the
>> @@ -975,6 +977,8 @@ Request contents:
>>     ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
>>     ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
>>     ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
>> +  ``ETHTOOL_A_COALESCE_USE_CQE_TX``	       bool    Tx CQE mode
>> +  ``ETHTOOL_A_COALESCE_USE_CQE_RX``	       bool    Rx CQE mode
>>     ===========================================  ======  =======================
>>   
>>   Request is rejected if it attributes declared as unsupported by driver (i.e.
> You need to thoroughly document the semantics. Can you point us to
> which drivers/devices implement similar modes of operation (if they
> exist we need to make sure semantics match)?


Ok, will complement the semantics.


Currently, only mlx5 provides a interface to update
this mode through ethtool priv-flag. other drivers like
broadcom and ice just use a fixed EQE and do not have
update interface.



>> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
>> index 1030540..9d0a386 100644
>> --- a/include/linux/ethtool.h
>> +++ b/include/linux/ethtool.h
>> @@ -179,6 +179,8 @@ __ethtool_get_link_ksettings(struct net_device *dev,
>>   
>>   struct kernel_ethtool_coalesce {
>>   	struct ethtool_coalesce	base;
>> +	__u32	use_cqe_mode_tx;
>> +	__u32	use_cqe_mode_rx;
> No __ in front, this is not a user space structure.
> Why not bool or a bitfield?


bool is enough, __u32 is used here to be consistent with

fields in struct ethtool_coalesce.

This seems unnecessary?


>>   };
>>   
>>   /**
>> @@ -216,6 +223,8 @@ const struct nla_policy ethnl_coalesce_set_policy[] = {
>>   	[ETHTOOL_A_COALESCE_TX_USECS_HIGH]	= { .type = NLA_U32 },
>>   	[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH]	= { .type = NLA_U32 },
>>   	[ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL] = { .type = NLA_U32 },
>> +	[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]	= { .type = NLA_U8 },
>> +	[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]	= { .type = NLA_U8 },
> This needs a policy to make sure values are <= 1.
>
> .

