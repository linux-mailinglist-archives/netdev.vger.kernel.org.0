Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3683C620CF7
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiKHKPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbiKHKPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:15:22 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4DDBF8;
        Tue,  8 Nov 2022 02:15:20 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N63rH08jkzRnwq;
        Tue,  8 Nov 2022 18:15:11 +0800 (CST)
Received: from [10.174.178.41] (10.174.178.41) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 18:15:18 +0800
Message-ID: <f9b02ce0-43be-56ab-f077-951b41d6a0e5@huawei.com>
Date:   Tue, 8 Nov 2022 18:15:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] vhost/vsock: Fix error handling in vhost_vsock_init()
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     <stefanha@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
        <davem@davemloft.net>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
References: <20221108091357.115738-1-yuancan@huawei.com>
 <20221108093358.4knnc6tlts7sm7a6@sgarzare-redhat>
From:   Yuan Can <yuancan@huawei.com>
In-Reply-To: <20221108093358.4knnc6tlts7sm7a6@sgarzare-redhat>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.41]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/8 17:33, Stefano Garzarella 写道:
> On Tue, Nov 08, 2022 at 09:13:57AM +0000, Yuan Can wrote:
>> A problem about modprobe vhost_vsock failed is triggered with the
>> following log given:
>>
>> modprobe: ERROR: could not insert 'vhost_vsock': Device or resource busy
>>
>> The reason is that vhost_vsock_init() returns misc_register() directly
>> without checking its return value, if misc_register() failed, it returns
>> without calling vsock_core_unregister() on vhost_transport, resulting 
>> the
>> vhost_vsock can never be installed later.
>> A simple call graph is shown as below:
>>
>> vhost_vsock_init()
>>   vsock_core_register() # register vhost_transport
>>   misc_register()
>>     device_create_with_groups()
>>       device_create_groups_vargs()
>>         dev = kzalloc(...) # OOM happened
>>   # return without unregister vhost_transport
>>
>> Fix by calling vsock_core_unregister() when misc_register() returns 
>> error.
>
> Thanks for this fix!
>
>>
>> Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
>
> Is this the right tag?
>
> It seems to me that since the introduction of vhost-vsock we have the 
> same problem (to be solved differently, because with the introduction 
> of multi-transport we refactored the initialization functions).
>
> So should we use 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")?
Thanks for pointing out this problem! I will use the correct tag in the 
v2 patch.

-- 
Best regards,
Yuan Can

