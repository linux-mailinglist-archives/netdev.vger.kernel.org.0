Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760B25A7F8
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 03:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfF2BPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 21:15:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8233 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726643AbfF2BPT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 21:15:19 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 635BA4AA946E0D202CDB;
        Sat, 29 Jun 2019 09:15:15 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Sat, 29 Jun 2019
 09:15:05 +0800
Subject: Re: [PATCH net-next 02/12] net: hns3: enable DCB when TC num is one
 and pfc_en is non-zero
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
CC:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Peng Li <lipeng321@huawei.com>
References: <1561722618-12168-1-git-send-email-tanhuazhong@huawei.com>
 <1561722618-12168-3-git-send-email-tanhuazhong@huawei.com>
 <CA+FuTSdWa0dMz15m79SLsNAw9zkp3+3MSfKiRwKnjZ7QAyq1Uw@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <b3d14dce-45a9-2d13-93d5-be6e5ef0c709@huawei.com>
Date:   Sat, 29 Jun 2019 09:15:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdWa0dMz15m79SLsNAw9zkp3+3MSfKiRwKnjZ7QAyq1Uw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/6/29 2:47, Willem de Bruijn wrote:
> On Fri, Jun 28, 2019 at 7:53 AM Huazhong Tan <tanhuazhong@huawei.com> wrote:
>>
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>
>> Currently when TC num is one, the DCB will be disabled no matter if
>> pfc_en is non-zero or not.
>>
>> This patch enables the DCB if pfc_en is non-zero, even when TC num
>> is one.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> Signed-off-by: Peng Li <lipeng321@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
> 
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
>> index 9edae5f..cb2fb5a 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
>> @@ -597,8 +597,10 @@ static void hclge_tm_tc_info_init(struct hclge_dev *hdev)
>>                 hdev->tm_info.prio_tc[i] =
>>                         (i >= hdev->tm_info.num_tc) ? 0 : i;
>>
>> -       /* DCB is enabled if we have more than 1 TC */
>> -       if (hdev->tm_info.num_tc > 1)
>> +       /* DCB is enabled if we have more than 1 TC or pfc_en is
>> +        * non-zero.
>> +        */
>> +       if (hdev->tm_info.num_tc > 1 || hdev->tm_info.pfc_en)
> 
> small nit: comments that just repeat the condition are not very informative.
> 
> More helpful might be to explain why the DCB should be enabled in both
> these cases. Though such detailed comments, if useful, are better left
> to the commit message usually.

Very helpful suggestion. thanks.
Will keep that in mind next time.

> 
>>                 hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
>>         else
>>                 hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
>> @@ -1388,6 +1390,19 @@ void hclge_tm_schd_info_update(struct hclge_dev *hdev, u8 num_tc)
>>         hclge_tm_schd_info_init(hdev);
>>  }
>>
>> +void hclge_tm_pfc_info_update(struct hclge_dev *hdev)
>> +{
>> +       /* DCB is enabled if we have more than 1 TC or pfc_en is
>> +        * non-zero.
>> +        */
>> +       if (hdev->tm_info.num_tc > 1 || hdev->tm_info.pfc_en)
>> +               hdev->flag |= HCLGE_FLAG_DCB_ENABLE;
>> +       else
>> +               hdev->flag &= ~HCLGE_FLAG_DCB_ENABLE;
>> +
>> +       hclge_pfc_info_init(hdev);
>> +}
> 
> Avoid introducing this code duplication by defining a helper?
> 

Will send out a new patch to remove the code duplication by defining a helper.

> .
> 

