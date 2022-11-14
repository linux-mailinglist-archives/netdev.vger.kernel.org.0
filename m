Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6827362741F
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 02:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbiKNBYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 20:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiKNBYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 20:24:16 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A92C10067;
        Sun, 13 Nov 2022 17:24:14 -0800 (PST)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N9WmT0y3fzmVvJ;
        Mon, 14 Nov 2022 09:23:53 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 09:24:12 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 09:24:11 +0800
Message-ID: <d008c301-ba36-0263-a2e9-3ea2e942c1ec@huawei.com>
Date:   Mon, 14 Nov 2022 09:24:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] kcm: Fix kernel NULL pointer dereference in
 requeue_rx_msgs
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <cong.wang@bytedance.com>,
        <f.fainelli@gmail.com>, <tom@herbertland.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20221112120423.56132-1-wanghai38@huawei.com>
 <Y3GR89nyWvTwHulH@pop-os.localdomain>
From:   "wanghai (M)" <wanghai38@huawei.com>
In-Reply-To: <Y3GR89nyWvTwHulH@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/14 8:55, Cong Wang 写道:
> On Sat, Nov 12, 2022 at 08:04:23PM +0800, Wang Hai wrote:
>> In kcm_rcv_strparser(), the skb is queued to the kcm that is currently
>> being reserved, and if the queue is full, unreserve_rx_kcm() will be
>> called. At this point, if KCM_RECV_DISABLE is set, then unreserve_rx_kcm()
>> will requeue received messages for the current kcm socket to other kcm
>> sockets. The kcm sock lock is not held during this time, and as long as
>> someone calls kcm_recvmsg, it will concurrently unlink the same skb, which
>> ill result in a null pointer reference.
>>
>> cpu0 			cpu1		        cpu2
>> kcm_rcv_strparser
>>   reserve_rx_kcm
>>                          kcm_setsockopt
>>                           kcm_recv_disable
>>                            kcm->rx_disabled = 1;
>>    kcm_queue_rcv_skb
>>    unreserve_rx_kcm
>>     requeue_rx_msgs                              kcm_recvmsg
>>      __skb_dequeue
>>       __skb_unlink(skb)				  skb_unlink(skb)
>>                                                    //double unlink skb
>>
> We will hold skb queue lock after my patch, so this will not happen after
> applying my patch below?
> https://lore.kernel.org/netdev/20221114005119.597905-1-xiyou.wangcong@gmail.com/

Hi Cong,

I tested your patch and it fixed my problem, thanks.

> .

-- 
Wang Hai

