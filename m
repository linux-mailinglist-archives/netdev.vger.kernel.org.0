Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B806603784
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 03:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiJSBaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 21:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiJSBaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 21:30:12 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A5877E8F
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 18:30:09 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MsY2M0vx0zVhyd;
        Wed, 19 Oct 2022 09:25:31 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 09:29:34 +0800
Received: from [10.174.176.230] (10.174.176.230) by
 kwepemm600008.china.huawei.com (7.193.23.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 09:29:33 +0800
Message-ID: <677a98a6-6eea-ae1b-f6f6-0055bd8f584a@huawei.com>
Date:   Wed, 19 Oct 2022 09:29:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v2] nfc: virtual_ncidev: Fix memory leak in
 virtual_nci_send()
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <bongsu.jeon@samsung.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
References: <20221018114935.8871-1-shangxiaojing@huawei.com>
 <a14a28c7-946d-fa2b-f3f1-69faaf269fbf@linaro.org>
From:   shangxiaojing <shangxiaojing@huawei.com>
In-Reply-To: <a14a28c7-946d-fa2b-f3f1-69faaf269fbf@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.230]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600008.china.huawei.com (7.193.23.88)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/18 22:06, Krzysztof Kozlowski wrote:
> On 18/10/2022 07:49, Shang XiaoJing wrote:
>> skb should be free in virtual_nci_send(), otherwise kmemleak will report
>> memleak.
>>
>> Steps for reproduction (simulated in qemu):
>> 	cd tools/testing/selftests/nci
>> 	make
>> 	./nci_dev
>>
>> BUG: memory leak
>> unreferenced object 0xffff888107588000 (size 208):
>>    comm "nci_dev", pid 206, jiffies 4294945376 (age 368.248s)
>>    hex dump (first 32 bytes):
>>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>    backtrace:
>>      [<000000008d94c8fd>] __alloc_skb+0x1da/0x290
>>      [<00000000278bc7f8>] nci_send_cmd+0xa3/0x350
>>      [<0000000081256a22>] nci_reset_req+0x6b/0xa0
>>      [<000000009e721112>] __nci_request+0x90/0x250
>>      [<000000005d556e59>] nci_dev_up+0x217/0x5b0
>>      [<00000000e618ce62>] nfc_dev_up+0x114/0x220
>>      [<00000000981e226b>] nfc_genl_dev_up+0x94/0xe0
>>      [<000000009bb03517>] genl_family_rcv_msg_doit.isra.14+0x228/0x2d0
>>      [<00000000b7f8c101>] genl_rcv_msg+0x35c/0x640
>>      [<00000000c94075ff>] netlink_rcv_skb+0x11e/0x350
>>      [<00000000440cfb1e>] genl_rcv+0x24/0x40
>>      [<0000000062593b40>] netlink_unicast+0x43f/0x640
>>      [<000000001d0b13cc>] netlink_sendmsg+0x73a/0xbf0
>>      [<000000003272487f>] __sys_sendto+0x324/0x370
>>      [<00000000ef9f1747>] __x64_sys_sendto+0xdd/0x1b0
>>      [<000000001e437841>] do_syscall_64+0x3f/0x90
>>
>> Fixes: e624e6c3e777 ("nfc: Add a virtual nci device driver")
>> Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
>> ---
>> changes in v2:
>> - free skb in error paths too.
>> ---
>>   drivers/nfc/virtual_ncidev.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
>> index f577449e4935..3a4ad95b40a7 100644
>> --- a/drivers/nfc/virtual_ncidev.c
>> +++ b/drivers/nfc/virtual_ncidev.c
>> @@ -54,16 +54,19 @@ static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
>>   	mutex_lock(&nci_mutex);
>>   	if (state != virtual_ncidev_enabled) {
>>   		mutex_unlock(&nci_mutex);
>> +		consume_skb(skb);
> 
> Ehhh... This looks ok, but now I wonder why none of other NCI send
> driver do it. If the finding is correct, all drivers have same issue.

yes, i'll try to reproduce these issues, and make another patch set if 
there are the issues.

Thanks,
-- 
Shang XiaoJing
