Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777E948230B
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 10:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhLaJoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 04:44:25 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:33896 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhLaJoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 04:44:24 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V0QblSr_1640943860;
Received: from 30.225.24.30(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V0QblSr_1640943860)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 31 Dec 2021 17:44:22 +0800
Message-ID: <0a972bf8-1d7b-a211-2c11-50e86c87700e@linux.alibaba.com>
Date:   Fri, 31 Dec 2021 17:44:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
From:   Wen Gu <guwen@linux.alibaba.com>
Subject: Re: [RFC PATCH net v2 1/2] net/smc: Resolve the race between link
 group access and termination
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dust.li@linux.alibaba.com,
        tonylu@linux.alibaba.com
References: <1640704432-76825-1-git-send-email-guwen@linux.alibaba.com>
 <1640704432-76825-2-git-send-email-guwen@linux.alibaba.com>
 <4ec6e460-96d1-fedc-96ff-79a98fd38de8@linux.ibm.com>
In-Reply-To: <4ec6e460-96d1-fedc-96ff-79a98fd38de8@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Karsten,

Thanks for your suggestions.

Wish you and your family a happy New Year!


On 2021/12/29 8:56 pm, Karsten Graul wrote:

> On 28/12/2021 16:13, Wen Gu wrote:
>> We encountered some crashes caused by the race between the access
>> and the termination of link groups.
> 
> While I agree with the problems you found I am not sure if the solution is the right one.
> At the moment conn->lgr is checked all over the code as indication if a connection
> still has a valid link group. When you change this semantic by leaving conn->lgr set
> after the connection was unregistered from its link group then I expect various new problems
> to happen.

Actually we also thought about this semantic mismatch problem. But we haven't encountered any
problems caused by leaving conn->lgr set in our tests. After careful consideration, we chose
to use this patch as a trade off against the more serious problems -- the crashes in mutliple
places caused by abnormal termination.

If any specific problems caused by leaving conn->lgr set can be expected, please inform us.
Thanks.

> 
> For me the right solution would be to use correct locking  before conn->lgr is checked and used.
> 

In my humble opinion, the key point is not avoiding access to a NULL pointer (conn->lgr)
by checking it before, but avoiding access link group after it is freed, which becomes a
piece of dirty memory. This patch focuses on how to ensure the safe access to link group,
which is from conn->lgr or link->lgr.

> In smc_lgr_unregister_conn() the lgr->conns_lock is used when conn->lgr is unset (note that
> it is better to have that "conn->lgr = NULL;" line INSIDE the lock in this function).
> 

I think lgr->conns_lock is used to make the read and modify to lgr->conns_all mutually
exclusive. As mentioned above, we are aimed to avoid access link group after it is freed.
It might be inappropriate to avoid access to a freed lgr by lgr->conns_lock.

> And on any places in the code where conn->lgr is used you get the read_lock while lgr is accessed.
> This could solve the problem, using existing mechanisms, right? Opinions?

We also considered to protect the access to link group by locking at the beginning as you
suggested, like RCU. But we found some imperfections of this way.

1) It is hard to cover all the race.

    link group is referred to all over the code and link group termination may be triggered
    at any time. So it is hard to find all the exact potential race code and protected each
    one respectively by locking. The discover of race code will rely heavily on testing and
    we may have to continuously add patches to fix each new race we find.

2) It is hard to hold lock during all the link group access.

    Only checking conn->lgr before accessing to link group is not safe even with correct
    locking. Even though conn->lgr is checked, link group may have been freed during the
    following access.

    access                         termination
    -----------------------------------------------------------
    if (conn->lgr)               |
                                 | kfree(lgr)
    access to lgr (undesired)    |

    To ensure link group access safe, we need to hold the lock before every link group
    access and not put until link group access finishes, it will cover too much codes and
    we need to pay attention to the behavior in the lock-holding section.

So we chose to use reference count and consider this issue from a life cycle perspective.
Introducing reference count can overcome the imperfections mentioned above by:

1) Prolonging the life cycle of link group.

    Instead of finding all the race, the main idea of the patch is to prolong the life cycle
    of link group, making it longer than the access cycle of connections and links over the
    link group. So even link group is being terminated, the free of link group is later than
    all the access to it.

    We think the access cycle to link group of connections is from smc_lgr_register_conn() to
    smc_conn_free() and the access cycle to link group of links is from smcr_link_init() to
    smcr_link_clear().

2) Introducing reference count.

    Instead of using lock, we use reference count to ensure link group is freed only when no
    one refers to it. No need to find every place which needs holding lock and pay attention
    to the behavior in lock-holding sections.


What do you think about it?

Thanks,
Wen Gu



