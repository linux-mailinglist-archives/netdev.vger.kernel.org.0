Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE41266392D
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 07:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjAJGSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 01:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbjAJGSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 01:18:34 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16C01C927;
        Mon,  9 Jan 2023 22:18:32 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NrgZH3Fp2znV8B;
        Tue, 10 Jan 2023 14:16:55 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 10 Jan 2023 14:18:28 +0800
Message-ID: <d773f69b-855f-d679-9e4c-c0a260411687@huawei.com>
Date:   Tue, 10 Jan 2023 14:18:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] Bluetooth: hci_sync: fix memory leak in
 hci_update_adv_data()
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
CC:     <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <brian.gix@intel.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20230109012651.3127529-1-shaozhengchao@huawei.com>
 <CABBYNZK=GXHO3QrEF2ZXWohnYkyPsfo0K9ZPxe0aMK_wuK1myQ@mail.gmail.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <CABBYNZK=GXHO3QrEF2ZXWohnYkyPsfo0K9ZPxe0aMK_wuK1myQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/1/10 5:11, Luiz Augusto von Dentz wrote:
> Hi Zhengchao,
> 
> On Sun, Jan 8, 2023 at 5:17 PM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>>
>> When hci_cmd_sync_queue() failed in hci_update_adv_data(), inst_ptr is
>> not freed, which will cause memory leak. Add release process to error
>> path.
>>
>> Fixes: 651cd3d65b0f ("Bluetooth: convert hci_update_adv_data to hci_sync")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   net/bluetooth/hci_sync.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
>> index 9e2d7e4b850c..1485501bd72f 100644
>> --- a/net/bluetooth/hci_sync.c
>> +++ b/net/bluetooth/hci_sync.c
>> @@ -6197,10 +6197,15 @@ static int _update_adv_data_sync(struct hci_dev *hdev, void *data)
>>   int hci_update_adv_data(struct hci_dev *hdev, u8 instance)
>>   {
>>          u8 *inst_ptr = kmalloc(1, GFP_KERNEL);
>> +       int ret;
>>
>>          if (!inst_ptr)
>>                  return -ENOMEM;
>>
>>          *inst_ptr = instance;
>> -       return hci_cmd_sync_queue(hdev, _update_adv_data_sync, inst_ptr, NULL);
>> +       ret = hci_cmd_sync_queue(hdev, _update_adv_data_sync, inst_ptr, NULL);
>> +       if (ret)
>> +               kfree(inst_ptr);
>> +
>> +       return ret;
>>   }
> 
> While this is correct I do wonder why we haven't used ERR_PTR/PTR_ERR
> like we did with the likes of abort_conn_sync, that way we don't have
> to allocate anything which makes things a lot simpler.
> 

Hi Luiz:
	Thank you for your advice. I think it is better to use
ERR_PTR/PTR_ERR to replace allocation. I will send V2.

Zhengchao Shao
>> --
>> 2.34.1
>>
> 
> 
