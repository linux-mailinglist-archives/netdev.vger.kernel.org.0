Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27CB15A1E6D
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243808AbiHZB4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiHZB4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:56:44 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53E6C6B74;
        Thu, 25 Aug 2022 18:56:42 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MDNC85zHKz1N7K7;
        Fri, 26 Aug 2022 09:53:08 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 26 Aug 2022 09:56:40 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 26 Aug 2022 09:56:40 +0800
Subject: Re: [PATCH -next] wifi: rtw88: add missing destroy_workqueue() on
 error path in rtw_core_init()
To:     Ping-Ke Shih <pkshih@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        Bernie Huang <phhuang@realtek.com>
References: <20220825133731.1877569-1-yangyingliang@huawei.com>
 <2f08c305927a43d78d6ab86468609288@realtek.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <39e21608-c7e2-422a-1e05-e7ebb250ecac@huawei.com>
Date:   Fri, 26 Aug 2022 09:56:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2f08c305927a43d78d6ab86468609288@realtek.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022/8/26 8:44, Ping-Ke Shih wrote:
>> -----Original Message-----
>> From: Yang Yingliang <yangyingliang@huawei.com>
>> Sent: Thursday, August 25, 2022 9:38 PM
>> To: linux-kernel@vger.kernel.org; netdev@vger.kernel.org; linux-wireless@vger.kernel.org
>> Cc: tony0620emma@gmail.com; kvalo@kernel.org; Bernie Huang <phhuang@realtek.com>
>> Subject: [PATCH -next] wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()
>>
>> Add the missing destroy_workqueue() before return from rtw_core_init()
>> in error path.
>>
>> Fixes: fe101716c7c9 ("rtw88: replace tx tasklet with work queue")
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/net/wireless/realtek/rtw88/main.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
>> index 790dcfed1125..557213e52761 100644
>> --- a/drivers/net/wireless/realtek/rtw88/main.c
>> +++ b/drivers/net/wireless/realtek/rtw88/main.c
>> @@ -2094,7 +2094,7 @@ int rtw_core_init(struct rtw_dev *rtwdev)
>>   	ret = rtw_load_firmware(rtwdev, RTW_NORMAL_FW);
>>   	if (ret) {
>>   		rtw_warn(rtwdev, "no firmware loaded\n");
>> -		return ret;
>> +		goto destroy_workqueue;
>>   	}
>>
>>   	if (chip->wow_fw_name) {
>> @@ -2104,11 +2104,15 @@ int rtw_core_init(struct rtw_dev *rtwdev)
>>   			wait_for_completion(&rtwdev->fw.completion);
>>   			if (rtwdev->fw.firmware)
>>   				release_firmware(rtwdev->fw.firmware);
>> -			return ret;
>> +			goto destroy_workqueue;
>>   		}
>>   	}
>>
>>   	return 0;
>> +
>> +destroy_workqueue:
> It's not so good that the label 'destroy_workqueue' is the same as function name.
> I suggest to just use 'out' instead.
How about 'out_destory_workqueue' ?

Thanks,
Yang
>
>> +	destroy_workqueue(rtwdev->tx_wq);
>> +	return ret;
>>   }
>>   EXPORT_SYMBOL(rtw_core_init);
>>
>> --
>> 2.25.1
>>
>>
>> ------Please consider the environment before printing this e-mail.
> .
