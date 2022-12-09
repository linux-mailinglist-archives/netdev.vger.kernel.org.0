Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F622647F89
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 09:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiLIItf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 03:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLIIte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 03:49:34 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B440396FA;
        Fri,  9 Dec 2022 00:49:31 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NT4S471CVzmWWK;
        Fri,  9 Dec 2022 16:48:36 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 9 Dec
 2022 16:48:57 +0800
Subject: Re: [PATCH net-next] net: tso: inline tso_count_descs()
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <ezequiel.garcia@free-electrons.com>
References: <20221208024303.11191-1-linyunsheng@huawei.com>
 <20221208195721.698f68b6@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <fc37030e-6888-7a08-348d-cdcc524285ce@huawei.com>
Date:   Fri, 9 Dec 2022 16:48:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20221208195721.698f68b6@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/12/9 11:57, Jakub Kicinski wrote:
> On Thu, 8 Dec 2022 10:43:03 +0800 Yunsheng Lin wrote:
>> tso_count_descs() is a small function doing simple calculation,
>> and tso_count_descs() is used in fast path, so inline it to
>> reduce the overhead of calls.
> 
> TSO frames are large, the overhead is fine.
> I'm open to other opinions but I'd rather keep the code as is than
> deal with the influx with similar sloppily automated changes.
> 
>> diff --git a/include/net/tso.h b/include/net/tso.h
>> index 62c98a9c60f1..ab6bbf56d984 100644
>> --- a/include/net/tso.h
>> +++ b/include/net/tso.h
>> @@ -16,7 +16,13 @@ struct tso_t {
>>  	u32	tcp_seq;
>>  };
> 
> no include for skbuff.h here

Do you mean including skbuff.h explicitly in tso.h?
It seems ip.h included in tso.h has included skbuff.h.

> 
>> -int tso_count_descs(const struct sk_buff *skb);
>> +/* Calculate expected number of TX descriptors */
>> +static inline int tso_count_descs(const struct sk_buff *skb)
>> +{
>> +	/* The Marvell Way */
> 
> these comments should be rewritten as we move
> the function clearly calculates the worst case buffer count

Will change to below:
/* Calculate the worst case buffer count */

> 
>> +	return skb_shinfo(skb)->gso_segs * 2 + skb_shinfo(skb)->nr_frags;
>> +}
> .
> 
