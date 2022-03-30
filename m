Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29E04EB802
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbiC3B5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiC3B5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:57:17 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DBCBBE32
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 18:55:33 -0700 (PDT)
Received: from kwepemi100017.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KSqJL2Kwkz1GCwX;
        Wed, 30 Mar 2022 09:55:14 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100017.china.huawei.com (7.221.188.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 30 Mar 2022 09:55:31 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 30 Mar
 2022 09:55:30 +0800
Subject: Re: [RFCv3 PATCH net-next 1/2] net-next: ethtool: extend ringparam
 set/get APIs for tx_push
To:     Michal Kubecek <mkubecek@suse.cz>
References: <20220329091913.17869-1-wangjie125@huawei.com>
 <20220329091913.17869-2-wangjie125@huawei.com>
 <20220329190924.d5gicfwoh6bp5iwd@lion.mk-sys.cz>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <huangguangbin2@huawei.com>, <lipeng321@huawei.com>,
        <shenjian15@huawei.com>, <moyufeng@huawei.com>,
        <linyunsheng@huawei.com>, <salil.mehta@huawei.com>,
        <chenhao288@hisilicon.com>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <c8ccec02-cc03-c7d6-0d26-0b9ef818fc9d@huawei.com>
Date:   Wed, 30 Mar 2022 09:55:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220329190924.d5gicfwoh6bp5iwd@lion.mk-sys.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/3/30 3:09, Michal Kubecek wrote:
> On Tue, Mar 29, 2022 at 05:19:12PM +0800, Jie Wang wrote:
>> Currently tx push is a standard driver feature which controls use of a fast
>> path descriptor push. So this patch extends the ringparam APIs and data
>> structures to support set/get tx push by ethtool -G/g.
>>
>> Signed-off-by: Jie Wang <wangjie125@huawei.com>
>> ---
> [...]
>> diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
>> index 9f33c9689b56..2bc2d91f2e66 100644
>> --- a/net/ethtool/rings.c
>> +++ b/net/ethtool/rings.c
> [...]
>> @@ -205,6 +210,15 @@ int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
>>  		goto out_ops;
>>  	}
>>
>> +	if (kernel_ringparam.tx_push &&
>> +	    !(ops->supported_ring_params & ETHTOOL_RING_USE_TX_PUSH)) {
>> +		ret = -EOPNOTSUPP;
>> +		NL_SET_ERR_MSG_ATTR(info->extack,
>> +				    tb[ETHTOOL_A_RINGS_TX_PUSH],
>> +				    "setting tx push not supported");
>> +		goto out_ops;
>> +	}
>> +
>>  	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam,
>>  					      &kernel_ringparam, info->extack);
>>  	if (ret < 0)
>
> This only disallows setting the parameter to true but allows requests
> trying to set it to false. I would rather prefer
>
> 	if (tb[ETHTOOL_A_RINGS_TX_PUSH] &&
> 	    !(ops->supported_ring_params & ETHTOOL_RING_USE_TX_PUSH)) {
> 		...
> 	}
>
> and putting the check before rtnl_lock() so that we do not do useless
> work if the request is invalid.
>
> But the same can be said about the two checks we already have so those
> should be probably changed and moved as well.
>
> Michal

OK, I will move these three checks in a new patch.

>

