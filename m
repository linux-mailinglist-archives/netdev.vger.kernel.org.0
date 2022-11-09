Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDB636221C7
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiKICNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKICNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:13:17 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB99F5D697;
        Tue,  8 Nov 2022 18:13:16 -0800 (PST)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N6T5W0YNVz15MTX;
        Wed,  9 Nov 2022 10:13:03 +0800 (CST)
Received: from dggpemm500015.china.huawei.com (7.185.36.181) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 10:13:14 +0800
Received: from [10.174.177.133] (10.174.177.133) by
 dggpemm500015.china.huawei.com (7.185.36.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 10:13:14 +0800
Subject: Re: [PATCH] Bluetooth: hci_conn: Fix potential memleak in
 iso_listen_bis()
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
CC:     <luiz.von.dentz@intel.com>, <pabeni@redhat.com>,
        <liwei391@huawei.com>, <linux-bluetooth@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221108112308.3910185-1-bobo.shaobowang@huawei.com>
 <CABBYNZJxkkrmuq+2LS3PAbhBCdE5oAkMuw_yggsXW=X0j8CCTw@mail.gmail.com>
From:   "Wangshaobo (bobo)" <bobo.shaobowang@huawei.com>
Message-ID: <5096457b-c62b-08c3-d27b-c34ff9409e5a@huawei.com>
Date:   Wed, 9 Nov 2022 10:13:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <CABBYNZJxkkrmuq+2LS3PAbhBCdE5oAkMuw_yggsXW=X0j8CCTw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.133]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500015.china.huawei.com (7.185.36.181)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/9 7:41, Luiz Augusto von Dentz 写道:
> Hi Wang,
>
> On Tue, Nov 8, 2022 at 3:24 AM Wang ShaoBo <bobo.shaobowang@huawei.com> wrote:
>> When hci_pa_create_sync() failed, hdev should be freed as there
>> was no place to handle its recycling after.
> The patch itself seems fine but the description is misleading since we
> are not freeing the hdev instead we are jus releasing the reference we
> got.
>
>> Fixes: f764a6c2c1e4 ("Bluetooth: ISO: Add broadcast support")
>> Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
>> ---
>>   net/bluetooth/iso.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
>> index f825857db6d0..4e3867110dc1 100644
>> --- a/net/bluetooth/iso.c
>> +++ b/net/bluetooth/iso.c
>> @@ -880,6 +880,9 @@ static int iso_listen_bis(struct sock *sk)
>>
>>          hci_dev_unlock(hdev);
>>
>> +       if (err)
>> +               hci_dev_put(hdev);
> Not sure why you are not always calling hci_dev_put?

emm, I would have thought that the reference would be released after 
calling hci_cmd_sync_queue(), but in fact actually not.

-- Wang ShaoBo

>
>>          return err;
>>   }
>>
>> --
>> 2.25.1
>>
>
