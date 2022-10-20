Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43B06054A3
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 03:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiJTBAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 21:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiJTBAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 21:00:13 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1263CFAE6F
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 18:00:10 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mt8QM4vfFzHv5N;
        Thu, 20 Oct 2022 08:59:55 +0800 (CST)
Received: from kwepemm600008.china.huawei.com (7.193.23.88) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 09:00:01 +0800
Received: from [10.174.176.230] (10.174.176.230) by
 kwepemm600008.china.huawei.com (7.193.23.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 09:00:00 +0800
Message-ID: <281db3e6-fde9-7fb6-9c44-d2f149c21304@huawei.com>
Date:   Thu, 20 Oct 2022 08:59:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v2] nfc: virtual_ncidev: Fix memory leak in
 virtual_nci_send()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <bongsu.jeon@samsung.com>, <krzysztof.kozlowski@linaro.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20221018114935.8871-1-shangxiaojing@huawei.com>
 <20221019173351.4e3a8ab7@kernel.org>
From:   shangxiaojing <shangxiaojing@huawei.com>
In-Reply-To: <20221019173351.4e3a8ab7@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.230]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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



On 2022/10/20 8:33, Jakub Kicinski wrote:
> On Tue, 18 Oct 2022 19:49:35 +0800 Shang XiaoJing wrote:
>> --- a/drivers/nfc/virtual_ncidev.c
>> +++ b/drivers/nfc/virtual_ncidev.c
>> @@ -54,16 +54,19 @@ static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
>>   	mutex_lock(&nci_mutex);
>>   	if (state != virtual_ncidev_enabled) {
>>   		mutex_unlock(&nci_mutex);
>> +		consume_skb(skb);
>>   		return 0;
>>   	}
>>   
>>   	if (send_buff) {
>>   		mutex_unlock(&nci_mutex);
>> +		consume_skb(skb);
>>   		return -1;
> 
> these two should be kfree_skb() as we're dropping a packet

ok, will be fixed in v3.

Thanks,
-- 
Shang XiaoJing
