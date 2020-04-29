Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5DC1BD341
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 05:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgD2Du3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 23:50:29 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3380 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726662AbgD2Du3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 23:50:29 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 202F9A8B8C69B864AD05;
        Wed, 29 Apr 2020 11:50:27 +0800 (CST)
Received: from [127.0.0.1] (10.166.212.180) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 29 Apr 2020
 11:50:22 +0800
Subject: Re: [PATCH -next] hinic: Use ARRAY_SIZE for nic_vf_cmd_msg_handler
To:     Joe Perches <joe@perches.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1588130136-49236-1-git-send-email-zou_wei@huawei.com>
 <01d45e599732bc5af33a09b36e63beabfcad8d25.camel@perches.com>
From:   Samuel Zou <zou_wei@huawei.com>
Message-ID: <a67b8ad8-f157-2200-910d-19b23dcf77ab@huawei.com>
Date:   Wed, 29 Apr 2020 11:50:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <01d45e599732bc5af33a09b36e63beabfcad8d25.camel@perches.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.212.180]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,
Thanks for your comments, I will modify and send the v2

On 2020/4/29 11:23, Joe Perches wrote:
> On Wed, 2020-04-29 at 11:15 +0800, Zou Wei wrote:
>> fix coccinelle warning, use ARRAY_SIZE
>>
>> drivers/net/ethernet/huawei/hinic/hinic_sriov.c:713:43-44: WARNING: Use ARRAY_SIZE
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Zou Wei <zou_wei@huawei.com>
>> ---
>>   drivers/net/ethernet/huawei/hinic/hinic_sriov.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
>> index b24788e..ac12725 100644
>> --- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
>> +++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
>> @@ -710,8 +710,7 @@ int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
>>   	if (!hwdev)
>>   		return -EFAULT;
>>   
>> -	cmd_number = sizeof(nic_vf_cmd_msg_handler) /
>> -			    sizeof(struct vf_cmd_msg_handle);
>> +	cmd_number = ARRAY_SIZE(nic_vf_cmd_msg_handler);
>>   	pfhwdev = container_of(dev, struct hinic_pfhwdev, hwdev);
>>   	nic_io = &dev->func_to_io;
>>   	for (i = 0; i < cmd_number; i++) {
> 
> Probably better to remove cmd_number altogether
> ---
>   drivers/net/ethernet/huawei/hinic/hinic_sriov.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
> index b24788..af70cc 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_sriov.c
> @@ -704,17 +704,15 @@ int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
>   	struct hinic_hwdev *dev = hwdev;
>   	struct hinic_func_to_io *nic_io;
>   	struct hinic_pfhwdev *pfhwdev;
> -	u32 i, cmd_number;
> +	u32 i;
>   	int err = 0;
>   
>   	if (!hwdev)
>   		return -EFAULT;
>   
> -	cmd_number = sizeof(nic_vf_cmd_msg_handler) /
> -			    sizeof(struct vf_cmd_msg_handle);
>   	pfhwdev = container_of(dev, struct hinic_pfhwdev, hwdev);
>   	nic_io = &dev->func_to_io;
> -	for (i = 0; i < cmd_number; i++) {
> +	for (i = 0; i < ARRAY_SIZE(nic_vf_cmd_msg_handler); i++) {
>   		vf_msg_handle = &nic_vf_cmd_msg_handler[i];
>   		if (cmd == vf_msg_handle->cmd &&
>   		    vf_msg_handle->cmd_msg_handler) {
> @@ -725,7 +723,7 @@ int nic_pf_mbox_handler(void *hwdev, u16 vf_id, u8 cmd, void *buf_in,
>   			break;
>   		}
>   	}
> -	if (i == cmd_number)
> +	if (i == ARRAY_SIZE(nic_vf_cmd_msg_handler))
>   		err = hinic_msg_to_mgmt(&pfhwdev->pf_to_mgmt, HINIC_MOD_L2NIC,
>   					cmd, buf_in, in_size, buf_out,
>   					out_size, HINIC_MGMT_MSG_SYNC);
> 
> 
> 
> .
> 

