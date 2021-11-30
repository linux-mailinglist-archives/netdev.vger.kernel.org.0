Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59F0462A41
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 03:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbhK3CSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 21:18:25 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:31923 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237367AbhK3CSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 21:18:24 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J35QV4Ss3zcbh5;
        Tue, 30 Nov 2021 10:14:58 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 10:15:04 +0800
Received: from [10.67.102.67] (10.67.102.67) by kwepemm600016.china.huawei.com
 (7.193.23.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 30 Nov
 2021 10:15:03 +0800
Subject: Re: [PATCH net-next 01/10] net: hns3: refactor reset_prepare_general
 retry statement
To:     Denis Kirjanov <dkirjanov@suse.de>, <davem@davemloft.net>,
        <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
References: <20211129140027.23036-1-huangguangbin2@huawei.com>
 <20211129140027.23036-2-huangguangbin2@huawei.com>
 <b66ad578-ab66-a6a5-961f-278db6ebe1dc@suse.de>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <fac7faf5-5eed-7a11-5c98-3cebaeb9ade7@huawei.com>
Date:   Tue, 30 Nov 2021 10:15:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <b66ad578-ab66-a6a5-961f-278db6ebe1dc@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/11/29 22:27, Denis Kirjanov wrote:
> 
> 
> 11/29/21 5:00 PM, Guangbin Huang пишет:
>> From: Jiaran Zhang <zhangjiaran@huawei.com>
>>
>> Currently, the hclge_reset_prepare_general function uses the goto
>> statement to jump upwards, which increases code complexity and makes
>> the program structure difficult to understand. In addition, if
>> reset_pending is set, retry_cnt cannot be increased. This may result
>> in a failure to exit the retry or increase the number of retries.
>>
>> Use the while statement instead to make the program easier to understand
>> and solve the problem that the goto statement cannot be exited.
>>
>> Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> ---
>>   .../hisilicon/hns3/hns3pf/hclge_main.c        | 32 ++++++++-----------
>>   .../hisilicon/hns3/hns3vf/hclgevf_main.c      | 32 ++++++++-----------
>>   2 files changed, 28 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> index a0628d139149..5282f2632b3b 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> @@ -11589,24 +11589,20 @@ static void hclge_reset_prepare_general(struct hnae3_ae_dev *ae_dev,
>>       int retry_cnt = 0;
>>       int ret;
>> -retry:
>> -    down(&hdev->reset_sem);
>> -    set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
>> -    hdev->reset_type = rst_type;
>> -    ret = hclge_reset_prepare(hdev);
>> -    if (ret || hdev->reset_pending) {
>> -        dev_err(&hdev->pdev->dev, "fail to prepare to reset, ret=%d\n",
>> -            ret);
>> -        if (hdev->reset_pending ||
>> -            retry_cnt++ < HCLGE_RESET_RETRY_CNT) {
>> -            dev_err(&hdev->pdev->dev,
>> -                "reset_pending:0x%lx, retry_cnt:%d\n",
>> -                hdev->reset_pending, retry_cnt);
>> -            clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
>> -            up(&hdev->reset_sem);
>> -            msleep(HCLGE_RESET_RETRY_WAIT_MS);
>> -            goto retry;
>> -        }
>> +    while (retry_cnt++ < HCLGE_RESET_RETRY_CNT) {
>> +        down(&hdev->reset_sem);
>> +        set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
>> +        hdev->reset_type = rst_type;
>> +        ret = hclge_reset_prepare(hdev);
>> +        if (!ret && !hdev->reset_pending)
>> +            break;
> up(&hdev->reset_sem); ?

This is reset preparation in PCIe FLR reset process, up(&hdev->reset_sem) will be called in hclge_reset_done().

>> +
>> +        dev_err(&hdev->pdev->dev,
>> +            "failed to prepare to reset, ret=%d, reset_pending:0x%lx, retry_cnt:%d\n",
>> +            ret, hdev->reset_pending, retry_cnt);
>> +        clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
>> +        up(&hdev->reset_sem);
>> +        msleep(HCLGE_RESET_RETRY_WAIT_MS);
>>       }
>>       /* disable misc vector before reset done */
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> index 3f29062eaf2e..0568cc31d391 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
>> @@ -2166,24 +2166,20 @@ static void hclgevf_reset_prepare_general(struct hnae3_ae_dev *ae_dev,
>>       int retry_cnt = 0;
>>       int ret;
>> -retry:
>> -    down(&hdev->reset_sem);
>> -    set_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
>> -    hdev->reset_type = rst_type;
>> -    ret = hclgevf_reset_prepare(hdev);
>> -    if (ret) {
>> -        dev_err(&hdev->pdev->dev, "fail to prepare to reset, ret=%d\n",
>> -            ret);
>> -        if (hdev->reset_pending ||
>> -            retry_cnt++ < HCLGEVF_RESET_RETRY_CNT) {
>> -            dev_err(&hdev->pdev->dev,
>> -                "reset_pending:0x%lx, retry_cnt:%d\n",
>> -                hdev->reset_pending, retry_cnt);
>> -            clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
>> -            up(&hdev->reset_sem);
>> -            msleep(HCLGEVF_RESET_RETRY_WAIT_MS);
>> -            goto retry;
>> -        }
>> +    while (retry_cnt++ < HCLGEVF_RESET_RETRY_CNT) {
>> +        down(&hdev->reset_sem);
>> +        set_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
>> +        hdev->reset_type = rst_type;
>> +        ret = hclgevf_reset_prepare(hdev);
>> +        if (!ret && !hdev->reset_pending)
>> +            break;
> same here

Same as above.

>> +
>> +        dev_err(&hdev->pdev->dev,
>> +            "failed to prepare to reset, ret=%d, reset_pending:0x%lx, retry_cnt:%d\n",
>> +            ret, hdev->reset_pending, retry_cnt);
>> +        clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
>> +        up(&hdev->reset_sem);
>> +        msleep(HCLGEVF_RESET_RETRY_WAIT_MS);
>>       }
>>       /* disable misc vector before reset done */
>>
> .
