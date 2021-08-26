Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4D13F82DB
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 09:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239740AbhHZHGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 03:06:12 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9365 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234415AbhHZHGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 03:06:04 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GwDJx4GMSz8vDZ;
        Thu, 26 Aug 2021 15:01:05 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 15:05:07 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 26
 Aug 2021 15:05:07 +0800
Subject: Re: [PATCH net-next 3/5] ethtool: add support to set/get rx buf len
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <mkubecek@suse.cz>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>
References: <1629873655-51539-1-git-send-email-huangguangbin2@huawei.com>
 <1629873655-51539-4-git-send-email-huangguangbin2@huawei.com>
 <20210825080908.1a5690a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <004dc46f-da33-3dbf-14db-006249c18fb1@huawei.com>
Date:   Thu, 26 Aug 2021 15:05:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210825080908.1a5690a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/8/25 23:09, Jakub Kicinski wrote:
> On Wed, 25 Aug 2021 14:40:53 +0800 Guangbin Huang wrote:
>> From: Hao Chen <chenhao288@hisilicon.com>
>>
>> Add support to set rx buf len via ethtool -G parameter and get
>> rx buf len via ethtool -g parameter.
>>
>> Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> 
>> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
>> index 266e95e4fb33..6e26586274b3 100644
>> --- a/include/uapi/linux/ethtool.h
>> +++ b/include/uapi/linux/ethtool.h
>> @@ -516,6 +516,7 @@ struct ethtool_coalesce {
>>    *	jumbo ring
>>    * @tx_pending: Current maximum supported number of pending entries
>>    *	per TX ring
>> + * @rx_buf_len: Current supported size of rx ring BD buffer.
> 
> How about "Current length of buffers on the rx ring"?
> 
Yes, thanks.

>>    * If the interface does not have separate RX mini and/or jumbo rings,
>>    * @rx_mini_max_pending and/or @rx_jumbo_max_pending will be 0.
>> @@ -533,6 +534,7 @@ struct ethtool_ringparam {
>>   	__u32	rx_mini_pending;
>>   	__u32	rx_jumbo_pending;
>>   	__u32	tx_pending;
>> +	__u32	rx_buf_len;
>>   };
> 
> You can't extend this structure, because it's used by the IOCTL
> interface directly. You need to pass the new value to the drivers
> in a different way. You can look at what Yufeng Mo did recently
> for an example approach.
> 
Ok, thanks your advice, we will modify this patch.

>> @@ -105,6 +109,7 @@ const struct nla_policy ethnl_rings_set_policy[] = {
>>   	[ETHTOOL_A_RINGS_RX_MINI]		= { .type = NLA_U32 },
>>   	[ETHTOOL_A_RINGS_RX_JUMBO]		= { .type = NLA_U32 },
>>   	[ETHTOOL_A_RINGS_TX]			= { .type = NLA_U32 },
>> +	[ETHTOOL_A_RINGS_RX_BUF_LEN]            = { .type = NLA_U32 },
> 
> We should prevent user space for passing 0 as input, so we can use it
> as a special value in the kernel. NLA_POLICY_MIN()
> 
Ok.

>>   };
>>   
>>   int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
>> @@ -142,6 +147,8 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
>>   	ethnl_update_u32(&ringparam.rx_jumbo_pending,
>>   			 tb[ETHTOOL_A_RINGS_RX_JUMBO], &mod);
>>   	ethnl_update_u32(&ringparam.tx_pending, tb[ETHTOOL_A_RINGS_TX], &mod);
>> +	ethnl_update_u32(&ringparam.rx_buf_len,
>> +			 tb[ETHTOOL_A_RINGS_RX_BUF_LEN], &mod);
>>   	ret = 0;
>>   	if (!mod)
>>   		goto out_ops;
> 
> We need a way of preventing drivers which don't support the new option
> from just silently ignoring it. Please add a capability like
> cap_link_lanes_supported and reject non-0 ETHTOOL_A_RINGS_RX_BUF_LEN
> if it's not set.
> .
Ok.

> 
