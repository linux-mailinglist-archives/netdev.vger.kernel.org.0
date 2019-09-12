Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3078B0653
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 02:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbfILA4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 20:56:25 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:53034 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbfILA4Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 20:56:25 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4FCB5C9E52582C95C148;
        Thu, 12 Sep 2019 08:56:21 +0800 (CST)
Received: from [127.0.0.1] (10.74.149.191) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 12 Sep 2019
 08:56:07 +0800
Subject: Re: [PATCH V2 net-next 4/7] net: hns3: fix port setting handle for
 fibre port
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>
References: <1568169639-43658-1-git-send-email-tanhuazhong@huawei.com>
 <1568169639-43658-5-git-send-email-tanhuazhong@huawei.com>
 <7f914173-a2fc-08d8-e2b1-48fa3da4e29c@cogentembedded.com>
From:   tanhuazhong <tanhuazhong@huawei.com>
Message-ID: <5dd0fae1-c5ab-8bbd-41db-58570e7b5c5e@huawei.com>
Date:   Thu, 12 Sep 2019 08:56:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.2
MIME-Version: 1.0
In-Reply-To: <7f914173-a2fc-08d8-e2b1-48fa3da4e29c@cogentembedded.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.149.191]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/9/11 18:16, Sergei Shtylyov wrote:
> Hello!
> 
> On 11.09.2019 5:40, Huazhong Tan wrote:
> 
>> From: Guangbin Huang <huangguangbin2@huawei.com>
>>
>> For hardware doesn't support use specified speed and duplex
> 
>     Can't pasre that. "For hardware that does not support using", perhaps?

Yes, thanks. Will check the grammar more carefully next time.

> 
>> to negotiate, it's unnecessary to check and modify the port
>> speed and duplex for fibre port when autoneg is on.
>>
>> Fixes: 22f48e24a23d ("net: hns3: add autoneg and change speed support 
>> for fibre port")
>> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
>> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
>> ---
>>   drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 15 +++++++++++++++
>>   1 file changed, 15 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c 
>> b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> index f5a681d..680c350 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
>> @@ -726,6 +726,12 @@ static int hns3_check_ksettings_param(const 
>> struct net_device *netdev,
>>       u8 duplex;
>>       int ret;
>> +    /* hw doesn't support use specified speed and duplex to negotiate,
> 
>     I can't parse that, did you mean "using"?

yes, thanks.

> 
>> +     * unnecessary to check them when autoneg on.
>> +     */
>> +    if (cmd->base.autoneg)
>> +        return 0;
>> +
>>       if (ops->get_ksettings_an_result) {
>>           ops->get_ksettings_an_result(handle, &autoneg, &speed, 
>> &duplex);
>>           if (cmd->base.autoneg == autoneg && cmd->base.speed == speed &&
>> @@ -787,6 +793,15 @@ static int hns3_set_link_ksettings(struct 
>> net_device *netdev,
>>               return ret;
>>       }
>> +    /* hw doesn't support use specified speed and duplex to negotiate,
> 
>     Here too...
> 


yes, thanks.

>> +     * ignore them when autoneg on.
>> +     */
>> +    if (cmd->base.autoneg) {
>> +        netdev_info(netdev,
>> +                "autoneg is on, ignore the speed and duplex\n");
>> +        return 0;
>> +    }
>> +
>>       if (ops->cfg_mac_speed_dup_h)
>>           ret = ops->cfg_mac_speed_dup_h(handle, cmd->base.speed,
>>                              cmd->base.duplex);
> 
> MBR, Sergei
> 
> .
> 

