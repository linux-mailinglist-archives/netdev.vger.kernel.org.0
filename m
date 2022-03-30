Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CCE4EBA7F
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 07:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243089AbiC3F5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 01:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243085AbiC3F5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 01:57:36 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B511B787
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 22:55:50 -0700 (PDT)
Received: from kwepemi100017.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KSwc05svLzgYD4;
        Wed, 30 Mar 2022 13:54:08 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100017.china.huawei.com (7.221.188.163) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 30 Mar 2022 13:55:47 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 30 Mar
 2022 13:55:47 +0800
Subject: Re: [RFCv3 PATCH net-next 1/2] net-next: ethtool: extend ringparam
 set/get APIs for tx_push
To:     Jakub Kicinski <kuba@kernel.org>
References: <20220329091913.17869-1-wangjie125@huawei.com>
 <20220329091913.17869-2-wangjie125@huawei.com>
 <20220329162057.7bba69cd@kernel.org>
CC:     <mkubecek@suse.cz>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <98b746da-44c4-a132-3231-1f42885f941f@huawei.com>
Date:   Wed, 30 Mar 2022 13:55:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220329162057.7bba69cd@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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



On 2022/3/30 7:20, Jakub Kicinski wrote:
> On Tue, 29 Mar 2022 17:19:12 +0800 Jie Wang wrote:
>> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
>> index 24d9be69065d..424159027309 100644
>> --- a/Documentation/networking/ethtool-netlink.rst
>> +++ b/Documentation/networking/ethtool-netlink.rst
>> @@ -862,6 +862,7 @@ Kernel response contents:
>>    ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
>>    ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT``    u8      TCP header / data split
>>    ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
>> +  ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
>>    ====================================  ======  ===========================
>>
>>  ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT`` indicates whether the device is usable with
>> @@ -887,6 +888,7 @@ Request contents:
>>    ``ETHTOOL_A_RINGS_TX``                u32     size of TX ring
>>    ``ETHTOOL_A_RINGS_RX_BUF_LEN``        u32     size of buffers on the ring
>>    ``ETHTOOL_A_RINGS_CQE_SIZE``          u32     Size of TX/RX CQE
>> +  ``ETHTOOL_A_RINGS_TX_PUSH``           u8      flag of TX Push mode
>>    ====================================  ======  ===========================
>>
>>  Kernel checks that requested ring sizes do not exceed limits reported by
>
> You need to also describe what it does. Do you have a user manual
> or some form of feature documentation that could be used as a starting
> point. We're happy to help with the wording and grammar but you need
> to give us a description of the feature so we're not guessing.
yes, I have some feature focumentations. I will add this part in next 
version.
>
> .
>

