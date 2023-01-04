Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8659065D386
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbjADM6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbjADM6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:58:06 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920E31CFD2
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 04:58:02 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Nn8k42G4czRqpx;
        Wed,  4 Jan 2023 20:56:28 +0800 (CST)
Received: from [10.67.102.37] (10.67.102.37) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 4 Jan
 2023 20:58:00 +0800
Subject: Re: [PATCH net-next 1/2] net: hns3: support wake on lan configuration
 and query
To:     Andrew Lunn <andrew@lunn.ch>
References: <20230104013405.65433-1-lanhao@huawei.com>
 <20230104013405.65433-2-lanhao@huawei.com> <Y7TgHS8oGbE656v0@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <shenjian15@huawei.com>,
        <netdev@vger.kernel.org>
From:   Hao Lan <lanhao@huawei.com>
Message-ID: <0087bf43-a78c-7d3c-4ab2-de246afe25f8@huawei.com>
Date:   Wed, 4 Jan 2023 20:57:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <Y7TgHS8oGbE656v0@lunn.ch>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.37]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,
Thank you for reviewing our code. Thank you very much.
You're right, such as WAKE_PHY, WAKE_CAST, these are implemented
in the kernel, they are ABI, they will never change, we use it
will directly simplify our code, your advice is very useful, thank
you very much for your advice.
However, these interfaces serve as a buffer between our firmware
and the linux community. Considering our interface expansion and
evolution, we may add some private modes in the future.
If the Linux community does not accept our private modes,
we will not be able to carry out these work.
So please let us keep enum HCLGE_WOL_MODE, thank you.

Best regards,
Hao Lan

On 2023/1/4 10:10, Andrew Lunn wrote:
>> +enum HCLGE_WOL_MODE {
>> +	HCLGE_WOL_PHY		= BIT(0),
>> +	HCLGE_WOL_UNICAST	= BIT(1),
>> +	HCLGE_WOL_MULTICAST	= BIT(2),
>> +	HCLGE_WOL_BROADCAST	= BIT(3),
>> +	HCLGE_WOL_ARP		= BIT(4),
>> +	HCLGE_WOL_MAGIC		= BIT(5),
>> +	HCLGE_WOL_MAGICSECURED	= BIT(6),
>> +	HCLGE_WOL_FILTER	= BIT(7),
>> +	HCLGE_WOL_DISABLE	= 0,
>> +};
> 
> These are the exact same values as WAKE_PHY, WAKE_CAST etc. Since they
> are ABI, they will never change. So you may as well throw these away
> and just use the Linux values.
> 

>>  struct hclge_hw;
>>  int hclge_cmd_send(struct hclge_hw *hw, struct hclge_desc *desc, int num);
>>  enum hclge_comm_cmd_status hclge_cmd_mdio_write(struct hclge_hw *hw,
>> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> index 4e54f91f7a6c..88cb5c05bc43 100644
>> --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
>> @@ -11500,6 +11500,201 @@ static void hclge_uninit_rxd_adv_layout(struct hclge_dev *hdev)
>>  		hclge_write_dev(&hdev->hw, HCLGE_RXD_ADV_LAYOUT_EN_REG, 0);
>>  }
>>  
>> +static __u32 hclge_wol_mode_to_ethtool(u32 mode)
>> +{
>> +	__u32 ret = 0;
>> +
>> +	if (mode & HCLGE_WOL_PHY)
>> +		ret |= WAKE_PHY;
>> +
>> +	if (mode & HCLGE_WOL_UNICAST)
>> +		ret |= WAKE_UCAST;
>> +
>> +	if (mode & HCLGE_WOL_MULTICAST)
>> +		ret |= WAKE_MCAST;
>> +
>> +	if (mode & HCLGE_WOL_BROADCAST)
>> +		ret |= WAKE_BCAST;
>> +
>> +	if (mode & HCLGE_WOL_ARP)
>> +		ret |= WAKE_ARP;
>> +
>> +	if (mode & HCLGE_WOL_MAGIC)
>> +		ret |= WAKE_MAGIC;
>> +
>> +	if (mode & HCLGE_WOL_MAGICSECURED)
>> +		ret |= WAKE_MAGICSECURE;
>> +
>> +	if (mode & HCLGE_WOL_FILTER)
>> +		ret |= WAKE_FILTER;
> 
> Once you throw away HCLGE_WOL_*, this function becomes much simpler.
> 
>> +
>> +	return ret;
>> +}
>> +
>> +static u32 hclge_wol_mode_from_ethtool(__u32 mode)
>> +{
>> +	u32 ret = HCLGE_WOL_DISABLE;
>> +
>> +	if (mode & WAKE_PHY)
>> +		ret |= HCLGE_WOL_PHY;
>> +
>> +	if (mode & WAKE_UCAST)
>> +		ret |= HCLGE_WOL_UNICAST;
> 
> This one two.
> 
>> @@ -12075,6 +12275,8 @@ static int hclge_reset_ae_dev(struct hnae3_ae_dev *ae_dev)
>>  
>>  	hclge_init_rxd_adv_layout(hdev);
>>  
>> +	(void)hclge_update_wol(hdev);
> 
> Please avoid casts like this. If there is an error, you should not
> ignore it. If it cannot fail, make it a void function.	
> 
>        Andrew
> .
> 
