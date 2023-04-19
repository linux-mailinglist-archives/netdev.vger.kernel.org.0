Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EF66E79E2
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbjDSMkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbjDSMks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:40:48 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5816D83
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:40:47 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q1gMk17wZzsRFf;
        Wed, 19 Apr 2023 20:39:14 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 19 Apr
 2023 20:40:44 +0800
Subject: Re: [PATCH net-next v2 1/5] net: wangxun: libwx add tx offload
 functions
To:     "mengyuanlou@net-swift.com" <mengyuanlou@net-swift.com>
CC:     <netdev@vger.kernel.org>, Jiawen Wu <jiawenwu@trustnetic.com>
References: <20230417105457.82127-1-mengyuanlou@net-swift.com>
 <20230417105457.82127-2-mengyuanlou@net-swift.com>
 <630e590e-fac3-5f69-688e-ac140ab3464e@huawei.com>
 <4E862584-755D-4EC4-9588-DB0B14D64CD5@net-swift.com>
 <82c37bb4-b2b0-037a-7f63-71324f493e1d@huawei.com>
 <1996D963-EFD9-420E-BEE2-E29B83F3811B@net-swift.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <a0ea9822-695b-df3f-c95f-766ef5b3f6a9@huawei.com>
Date:   Wed, 19 Apr 2023 20:40:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1996D963-EFD9-420E-BEE2-E29B83F3811B@net-swift.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/19 10:27, mengyuanlou@net-swift.com wrote:
> 
> 
>> 2023年4月18日 20:11，Yunsheng Lin <linyunsheng@huawei.com> 写道：
>>
>> On 2023/4/18 15:00, mengyuanlou@net-swift.com wrote:
>>>>> + goto exit;
>>>>> + case htons(ETH_P_ARP):
>>>>> + ptype = WX_PTYPE_L2_ARP;
>>>>> + goto exit;
>>>>> + default:
>>>>> + ptype = WX_PTYPE_L2_MAC;
>>>>
>>>> Is it ok to set ptype to WX_PTYPE_L2_MAC for first->protocol != ETH_P_IP
>>>> && first->protocol != ETH_P_IPV6? Does hw need to do checksum/tso or other thing
>>>> about those packet? if not, setting WX_PTYPE_L2_MAC seems enough?
>>>>
>>>    • The hardware needs to parse these packets with these ptype bits.
>>
>> What does hw do after parsing these packets? Updating some stats according to
>> the protocol type?
>> It seems really related to hw implementation, I am just curious if it is worth
>> the added overhead for driver.
>>
> For ETH_P_1588 hw will add timestamp for packets. 

I am not quite familiar with 1588, but does stack not set the SKBTX_HW_TSTAMP
in skb_shinfo(skb)->tx_flags when hw timestamp is required?

> The others are used to loopback scene, because hw can not parse l2 type.

I suppose that is for sriov loopback case where one function send packet
to another function under the same PF?

For the above case, hw just copy the packet type from tx desc to rx desc
without parsing the packet and assuming the driver always put the correct
packet type? I am not sure it is safe to assume that driver always put the
correct packet type, as the driver can be in a vm which may not be trustworthy?
If this happens, I am also not sure if this may cause problem for other
vm using different VF under the same PF?

> 
> According to chip designers, the others are not necessary.
> Does it really cost a a lot for driver? 
> Thanks.
> 
> 
> .
> 
