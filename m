Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6853482311
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 10:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhLaJpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 04:45:32 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:33017 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229498AbhLaJpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 04:45:31 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V0QXbkT_1640943927;
Received: from 30.225.24.30(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V0QXbkT_1640943927)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 31 Dec 2021 17:45:28 +0800
Message-ID: <2c056f5a-0cd1-e7a6-6318-b2368946ae96@linux.alibaba.com>
Date:   Fri, 31 Dec 2021 17:45:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
From:   Wen Gu <guwen@linux.alibaba.com>
Subject: Re: [RFC PATCH net v2 2/2] net/smc: Resolve the race between SMC-R
 link access and clear
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com
References: <1640704432-76825-1-git-send-email-guwen@linux.alibaba.com>
 <1640704432-76825-3-git-send-email-guwen@linux.alibaba.com>
 <7311029c-2c56-d9c7-9ed5-87bc6a36511f@linux.ibm.com>
In-Reply-To: <7311029c-2c56-d9c7-9ed5-87bc6a36511f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your reply.

On 2021/12/29 8:51 pm, Karsten Graul wrote:
> On 28/12/2021 16:13, Wen Gu wrote:
>> We encountered some crashes caused by the race between SMC-R
>> link access and link clear triggered by link group termination
>> in abnormal case, like port error.
> 
> Without to dig deeper into this, there is already a refcount for links, see smc_wr_tx_link_hold().
> In smc_wr_free_link() there are waits for the refcounts to become zero.
> 

Thanks for reminding. we also noticed link->wr_tx_refcnt when trying to fix this issue.

In my humble opinions, link->wr_tx_refcnt is used for fixing the race between the waiters for a
tx work request buffer (mainly LLC/CDC msgs) and the link down processing that finally clears the
link.

But the issue in this patch is about the race between the access to link by the connections
above it (like in listen or connect processing) and the link clear processing that memset the link
as zero and release the resource. So it seems that the two should not share the same reference count?

> Why do you need to introduce another refcounting instead of using the existing?
> And if you have a good reason, do we still need the existing refcounting with your new
> implementation?
> 

Yes, we still need it.

In my humble opinion, link->wr_tx_refcnt can ensure that the CDC/LLC message sends won't wait for
an already cleared link. And LLC messages may be triggered by underlying events like net device
ports add/error.

But this patch's implementation only ensures that the access to link by connections is safe and
smc connections won't get something that already freed during its life cycle, like in listen/connect
processing. It can't cover the link access by LLC messages, which may be triggered by underlying
events.

> Maybe its enough to use the existing refcounting in the other functions like smc_llc_flow_initiate()?
> 
> Btw: it is interesting what kind of crashes you see, we never met them in our setup.

This kind of crashes and the link group free crashes mentioned in the [1/2] patch can be reproduced
by up/down net device frequently during the testing.

> Its great to see you evaluating SMC in a cloud environment!

Thanks! Hope that SMC will be widely used. It is an amazing protocal!

Cheers,
Wen Gu
