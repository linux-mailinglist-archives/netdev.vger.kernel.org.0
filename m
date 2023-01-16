Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FF366B578
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 03:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbjAPCHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 21:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbjAPCHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 21:07:48 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDA84EF0
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 18:07:46 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NwFk33DmZz16Mqg;
        Mon, 16 Jan 2023 10:06:03 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 16 Jan 2023 10:07:43 +0800
Message-ID: <10aeb2bd-1d82-c547-3277-82ccb487199c@huawei.com>
Date:   Mon, 16 Jan 2023 10:07:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] net/sched: sch_taprio: fix possible use-after-free
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <eric.dumazet@gmail.com>, syzbot <syzkaller@googlegroups.com>,
        Alexander Potapenko <glider@google.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
References: <20230113164849.4004848-1-edumazet@google.com>
 <Y8Sb7LYDN/xjDBQy@pop-os.localdomain>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <Y8Sb7LYDN/xjDBQy@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/1/16 8:35, Cong Wang wrote:
> On Fri, Jan 13, 2023 at 04:48:49PM +0000, Eric Dumazet wrote:
>> syzbot reported a nasty crash [1] in net_tx_action() which
>> made little sense until we got a repro.
>>
>> This repro installs a taprio qdisc, but providing an
>> invalid TCA_RATE attribute.
>>
>> qdisc_create() has to destroy the just initialized
>> taprio qdisc, and taprio_destroy() is called.
>>
>> However, the hrtimer used by taprio had already fired,
>> therefore advance_sched() called __netif_schedule().
>>
>> Then net_tx_action was trying to use a destroyed qdisc.
>>
>> We can not undo the __netif_schedule(), so we must wait
>> until one cpu serviced the qdisc before we can proceed.
>>
> 
> This workaround looks a bit ugly. I think we _may_ be able to make
> hrtimer_start() as the last step of the initialization, IOW, move other
> validations and allocations before it.
> 
> Can you share your reproducer?
> 
> Thanks,
Maybe the issue is the same as 
https://syzkaller.appspot.com/bug?id=1ccb246eecb5114c440218336e4c7205aed5f2c8
