Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8720B6497D1
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 02:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiLLB6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 20:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiLLB6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 20:58:08 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2B964F8
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 17:58:07 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NVl6s33bfzJpGy;
        Mon, 12 Dec 2022 09:54:29 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemm500007.china.huawei.com (7.185.36.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 12 Dec 2022 09:58:04 +0800
Subject: Re: [PATCH net 1/3] mISDN: hfcsusb: don't call dev_kfree_skb() under
 spin_lock_irqsave()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <isdn@linux-pingi.de>,
        <davem@davemloft.net>
References: <20221207093239.3775457-1-yangyingliang@huawei.com>
 <20221207093239.3775457-2-yangyingliang@huawei.com>
 <20221209155758.459b858d@kernel.org>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <cea4e99a-10f0-c959-c1f2-30fc6614c219@huawei.com>
Date:   Mon, 12 Dec 2022 09:58:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20221209155758.459b858d@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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


On 2022/12/10 7:57, Jakub Kicinski wrote:
> On Wed, 7 Dec 2022 17:32:37 +0800 Yang Yingliang wrote:
>>   			spin_lock_irqsave(&hw->lock, flags);
>>   			skb_queue_purge(&dch->squeue);
> Please take a look at what skb_queue_purge() does.
> Perhaps you should create a skb_buff_head on the stack,
> skb_queue_splice_init() from the sch->squeue onto that
> queue, add the rx_skb and tx_skb into that queue,
> then drop the lock and skb_queue_purge() outside the lock.
skb_queue_purge() calls kfree_skb() which is not allowed in this
case, I will send a v2 to change it.

Thanks,
Yang
>
>>   			if (dch->tx_skb) {
>> -				dev_kfree_skb(dch->tx_skb);
>> +				dev_consume_skb_irq(dch->tx_skb);
> .
