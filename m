Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50FE73EA990
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 19:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbhHLRg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 13:36:26 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:55518 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236128AbhHLRgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 13:36:25 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UioNIcs_1628789757;
Received: from IT-C02W23QPG8WN.local(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UioNIcs_1628789757)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 13 Aug 2021 01:35:57 +0800
Subject: Re: [PATCH v2 2/2] net: return early for possible invalid uaddr
To:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Baoyou Xie <baoyou.xie@alibaba-inc.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210811152431.66426-1-wenyang@linux.alibaba.com>
 <20210811152431.66426-2-wenyang@linux.alibaba.com>
 <247c8272-0e26-87ab-d492-140047d4abc4@gmail.com>
From:   Wen Yang <wenyang@linux.alibaba.com>
Message-ID: <6c11b9e7-6aac-65c9-4755-99d41fbdcb4e@linux.alibaba.com>
Date:   Fri, 13 Aug 2021 01:35:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <247c8272-0e26-87ab-d492-140047d4abc4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/8/12 上午12:11, Eric Dumazet 写道:
> 
> 
> On 8/11/21 5:24 PM, Wen Yang wrote:
>> The inet_dgram_connect() first calls inet_autobind() to select an
>> ephemeral port, then checks uaddr in udp_pre_connect() or
>> __ip4_datagram_connect(), but the port is not released until the socket
>> is closed. This could cause performance issues or even exhaust ephemeral
>> ports if a malicious user makes a large number of UDP connections with
>> invalid uaddr and/or addr_len.
>>
>>   
> 
> This is a big patch.
> 
> Can the malicious user still use a large number of UDP sockets,
> with valid uaddr/add_len and consequently exhaust ephemeral ports ?
> 
> If yes, it does not seem your patch is helping.
> 

Thank you for your comments.
However, we could make these optimizations:

1, If the user passed in some invalid parameters, we should return as
soon as possible. We shouldn't assume that these parameters are valid
first, then do some real work (such as select an ephemeral port), and
then finally check that they are indeed valid or not.

2. Unify the code for checking parameters in udp_pre_connect() and
__ip4_datagram_connect() to make the code clearer.

> If no, have you tried instead to undo the autobind, if the connect fails ?
> 

Thanks. Undo the autobind is useful if the connect fails.
We will add this logic and submit the v3 patch later.

-- 
Best wishes，
Wen

