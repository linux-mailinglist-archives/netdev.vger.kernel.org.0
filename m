Return-Path: <netdev+bounces-8465-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 957B772433D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D058F1C20DE9
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13AF37B92;
	Tue,  6 Jun 2023 12:55:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CC237B61
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:55:07 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A6A10D7
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:54:51 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.54])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Qb9N26JFKzLq7j;
	Tue,  6 Jun 2023 20:51:46 +0800 (CST)
Received: from [10.174.178.171] (10.174.178.171) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 20:54:48 +0800
Subject: Re: [Question] integer overflow in function
 __qdisc_calculate_pkt_len()
To: Jakub Kicinski <kuba@kernel.org>
CC: Networking <netdev@vger.kernel.org>
References: <7723cc01-57bf-2b64-7f78-98a0e6508a2e@huawei.com>
 <20230605161922.5e417434@kernel.org>
From: "luwei (O)" <luwei32@huawei.com>
Message-ID: <c6ab254d-76c3-7507-3935-e9bad4da0bab@huawei.com>
Date: Tue, 6 Jun 2023 20:54:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230605161922.5e417434@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.171]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


在 2023/6/6 7:19 AM, Jakub Kicinski 写道:
> On Fri, 2 Jun 2023 10:50:44 +0800 luwei (O) wrote:
>>       I found an integer overflow issue in function
>> __qdisc_calculate_pkt_len(), the root cause is overhead and cell_align
>> in stab is not checked.
>>
>> For example, if overhead is set to -2147483559 and cell_align is set to
>> -32767 (tc tool limit it to 0 and -1, but other values can be set with
>> netlink api),
>>
>> the integer overflow occurs:
>>
>>    568 void __qdisc_calculate_pkt_len(struct sk_buff *skb,
>>    569                                const struct qdisc_size_table *stab)
>>    570 {
>>    571         int pkt_len, slot;
>>    572
>>    573         pkt_len = skb->len + stab->szopts.overhead; (1)
>>    574         if (unlikely(!stab->szopts.tsize))
>>    575                 goto out;
>>    576
>>    577         slot = pkt_len + stab->szopts.cell_align;   (2)
>>    578         if (unlikely(slot < 0))
>>    579                 slot = 0;
>>
>> if skb->len is 66, slot will be 66 + (-2147483559) + (-32767) =
>> 2147451036, and pkt_len will be 2147451040 finally.  I think the value
>> of overhead and cell_align
>>
>> should be limited, but not sure to which values they should be limited,
>> can any one give me some suggestions?
> on a quick look limiting the cell_align to S16_MIN at the netlink level
> (NLA_POLICY_MIN()) seems reasonable, feel free to send a patch.
> .

Thanks for your reply, but do your mean cell_align or overhead? It seems 
limit cell_align to

S16_MIN(-32768) can still cause the overflow:

     66 + (-2147483559) + (-32767) = 2147451036

   skb->len = 66
   stab->szopts.overhead = -2147483559
   stab->szopts.cell_align = -32767

-- 
Best Regards,
Lu Wei


