Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88E262DA7C
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbiKQMPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240006AbiKQMO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:14:56 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703346B21F;
        Thu, 17 Nov 2022 04:14:54 -0800 (PST)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NCf3q3h3JzRpGD;
        Thu, 17 Nov 2022 20:14:31 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 20:14:52 +0800
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 20:14:52 +0800
Subject: Re: [PATCH net] net/qla3xxx: fix potential memleak in ql3xxx_send()
To:     Leon Romanovsky <leon@kernel.org>
CC:     <GR-Linux-NIC-Dev@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, Jeff Garzik <jeff@garzik.org>,
        Ron Mercer <ron.mercer@qlogic.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1668675039-21138-1-git-send-email-zhangchangzhong@huawei.com>
 <Y3YdOQYQ5SjdeRpT@unreal>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <f68629b9-62f9-5a58-9d5f-f33cb4912bf4@huawei.com>
Date:   Thu, 17 Nov 2022 20:14:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <Y3YdOQYQ5SjdeRpT@unreal>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/17 19:38, Leon Romanovsky wrote:
> On Thu, Nov 17, 2022 at 04:50:38PM +0800, Zhang Changzhong wrote:
>> The ql3xxx_send() returns NETDEV_TX_OK without freeing skb in error
>> handling case, add dev_kfree_skb_any() to fix it.
> 
> Can you please remind me why should it release?
> There are no paths in ql3xxx_send() that release skb.
> 
> Thanks
> 

If ql_send_map() returns NETDEV_TX_OK, the packet is sent, and
ql_process_mac_tx_intr() releases tx_cb->skb. However, the skb
cannot be released in this error path.

Thanks,
Changzhong

>>
>> Fixes: bd36b0ac5d06 ("qla3xxx: Add support for Qlogic 4032 chip.")
>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>> ---
>>  drivers/net/ethernet/qlogic/qla3xxx.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
>> index 76072f8..0d57ffc 100644
>> --- a/drivers/net/ethernet/qlogic/qla3xxx.c
>> +++ b/drivers/net/ethernet/qlogic/qla3xxx.c
>> @@ -2471,6 +2471,7 @@ static netdev_tx_t ql3xxx_send(struct sk_buff *skb,
>>  					     skb_shinfo(skb)->nr_frags);
>>  	if (tx_cb->seg_count == -1) {
>>  		netdev_err(ndev, "%s: invalid segment count!\n", __func__);
>> +		dev_kfree_skb_any(skb);
>>  		return NETDEV_TX_OK;
>>  	}
>>  
>> -- 
>> 2.9.5
>>
> .
> 
