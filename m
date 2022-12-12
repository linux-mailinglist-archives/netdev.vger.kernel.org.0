Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063666497D2
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 02:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiLLB6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 20:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiLLB6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 20:58:50 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A8EBC95
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 17:58:47 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NVlBn07MPzJqRw;
        Mon, 12 Dec 2022 09:57:53 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 12 Dec 2022 09:58:43 +0800
Subject: Re: [PATCH net v4] ethernet: s2io: don't call dev_kfree_skb() under
 spin_lock_irqsave()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jdmason@kudzu.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <leon@kernel.org>
References: <20221208120121.2076486-1-yangyingliang@huawei.com>
 <20221208084753.6523ff23@kernel.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <09eddbfd-091d-dfd3-2597-9c18bc04dac5@huawei.com>
Date:   Mon, 12 Dec 2022 09:58:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20221208084753.6523ff23@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/12/9 0:47, Jakub Kicinski wrote:
> On Thu, 8 Dec 2022 20:01:21 +0800 Yang Yingliang wrote:
>> It is not allowed to call kfree_skb() or consume_skb() from hardware
>> interrupt context or with hardware interrupts being disabled.
>>
>> It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
>> The difference between them is free reason, dev_kfree_skb_irq() means
>> the SKB is dropped in error and dev_consume_skb_irq() means the SKB
>> is consumed in normal.
>>
>> In this case, dev_kfree_skb() is called in free_tx_buffers() to drop
>> the SKBs in tx buffers, when the card is down, so replace it with
>> dev_kfree_skb_irq() here.
> Make sure you read this:
>
> https://www.kernel.org/doc/html/next/process/maintainer-netdev.html
OK.

Thanks,
Yang
> .
