Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130BB39C730
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 11:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhFEJ4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 05:56:35 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4318 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFEJ4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 05:56:34 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fxvxg0nw2z1BGQj;
        Sat,  5 Jun 2021 17:49:59 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 17:54:45 +0800
Received: from [10.67.102.67] (10.67.102.67) by dggemi759-chm.china.huawei.com
 (10.1.198.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 5 Jun
 2021 17:54:45 +0800
Subject: Re: [RESEND net-next 1/2] net: hns3: add support for PTP
To:     Richard Cochran <richardcochran@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>
References: <1622602664-20274-1-git-send-email-huangguangbin2@huawei.com>
 <1622602664-20274-2-git-send-email-huangguangbin2@huawei.com>
 <20210603131452.GA6216@hoboy.vegasvil.org>
From:   "huangguangbin (A)" <huangguangbin2@huawei.com>
Message-ID: <4b2247bc-605e-3aca-3bcb-c06477cd2f2e@huawei.com>
Date:   Sat, 5 Jun 2021 17:54:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210603131452.GA6216@hoboy.vegasvil.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.67]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/6/3 21:14, Richard Cochran wrote:
> On Wed, Jun 02, 2021 at 10:57:43AM +0800, Guangbin Huang wrote:
> 
>> @@ -4342,12 +4352,34 @@ static void hclge_periodic_service_task(struct hclge_dev *hdev)
>>   	hclge_task_schedule(hdev, delta);
>>   }
>>   
>> +static void hclge_ptp_service_task(struct hclge_dev *hdev)
>> +{
>> +	if (!test_bit(HCLGE_STATE_PTP_EN, &hdev->state) ||
>> +	    !test_bit(HCLGE_STATE_PTP_TX_HANDLING, &hdev->state) ||
>> +	    !time_is_before_jiffies(hdev->ptp->tx_start + HZ))
>> +		return;
>> +
>> +	/* to prevent concurrence with the irq handler, disable vector0
>> +	 * before handling ptp service task.
>> +	 */
>> +	disable_irq(hdev->misc_vector.vector_irq);
> 
> This won't work.  After all, the ISR thread might already be running.
> Use a proper spinlock instead.
> 
Thanks for review. Using spinlock in irq_handler looks heavy, what about
adding a new flag HCLGE_STATE_PTP_CLEANING_TX_HWTS for hclge_ptp_clean_tx_hwts()?
Function hclge_ptp_clean_tx_hwts() test and set this flag at the beginning
and clean it in the end. Do you think it is Ok?

Thanks,
Guangbin
.

>> +	/* check HCLGE_STATE_PTP_TX_HANDLING here again, since the irq
>> +	 * handler may handle it just before disable_irq().
>> +	 */
>> +	if (test_bit(HCLGE_STATE_PTP_TX_HANDLING, &hdev->state))
>> +		hclge_ptp_clean_tx_hwts(hdev);
>> +
>> +	enable_irq(hdev->misc_vector.vector_irq);
>> +}
> 
> Thanks,
> Richard
> .
> 
