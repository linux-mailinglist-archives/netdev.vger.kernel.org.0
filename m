Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC54E3695D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 03:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfFFBnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 21:43:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:18089 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726561AbfFFBnJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jun 2019 21:43:09 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 620AAF014900085AD60D;
        Thu,  6 Jun 2019 09:43:07 +0800 (CST)
Received: from [127.0.0.1] (10.177.19.180) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Thu, 6 Jun 2019
 09:43:05 +0800
Subject: Re: [PATCH net-next] net: Drop unlikely before IS_ERR(_OR_NULL)
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        <netdev@vger.kernel.org>, <linux-sctp@vger.kernel.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>
References: <20190605142428.84784-1-wangkefeng.wang@huawei.com>
 <20190605142428.84784-3-wangkefeng.wang@huawei.com>
 <20190605091319.000054e9@intel.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <721a48ce-c09a-a35e-86ae-eac5eec26668@huawei.com>
Date:   Thu, 6 Jun 2019 09:39:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190605091319.000054e9@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.177.19.180]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/6/6 0:13, Jesse Brandeburg wrote:
> On Wed, 5 Jun 2019 22:24:26 +0800 Kefeng wrote:
>> IS_ERR(_OR_NULL) already contain an 'unlikely' compiler flag,
>> so no need to do that again from its callers. Drop it.
>>
> <snip>
>
>>  	segs = __skb_gso_segment(skb, features, false);
>> -	if (unlikely(IS_ERR_OR_NULL(segs))) {
>> +	if (IS_ERR_OR_NULL(segs)) {
>>  		int segs_nr = skb_shinfo(skb)->gso_segs;
>>  
> The change itself seems reasonable, but did you check to see if the
> paths changed are faster/slower with your fix?  Did you look at any
> assembly output to see if the compiler actually generated different
> code?  Is there a set of similar changes somewhere else in the kernel
> we can refer to?

+Enrico Weigelt

There is no different in assembly output (only check the x86/arm64), and

the Enrico Weigelt have finished a cocci script to do this cleanup.


>
> I'm not sure in the end that the change is worth it, so would like you
> to prove it is, unless davem overrides me. :-)
>
>
> .
>

