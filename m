Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B674D99B3
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 11:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347665AbiCOKzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 06:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347651AbiCOKym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 06:54:42 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E28119C2F
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 03:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1647341579; x=1678877579;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LiqUksPg8GVWJtzDef4BoGt1OXVzHZaxw3XRlIYI0SE=;
  b=Nw1lgY68vgF8W0boi60cRA+6NJzZ4VyJdVTKE3dyNWAYSep5/q4owQQD
   nzcYVBDKyfLz5Ell8MHNi95det0dWz7xGnIN/s9P9gjw2wSJUaDrUPV5E
   He/vlsu8gDXSVRSPlac+a28DeZcwraOezKnO72tO6FgCj55DCj2t2cmAY
   M=;
X-IronPort-AV: E=Sophos;i="5.90,183,1643673600"; 
   d="scan'208";a="181454499"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 15 Mar 2022 10:52:57 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-4ba5c7da.us-east-1.amazon.com (Postfix) with ESMTPS id B5DA39EFFE;
        Tue, 15 Mar 2022 10:52:55 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Tue, 15 Mar 2022 10:52:54 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.148) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 15 Mar 2022 10:52:51 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuniyu@amazon.co.jp>
CC:     <davem@davemloft.net>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <netdev@vger.kernel.org>,
        <rao.shoaib@oracle.com>
Subject: Re: [PATCH net] af_unix: Support POLLPRI for OOB.
Date:   Tue, 15 Mar 2022 19:52:46 +0900
Message-ID: <20220315105246.77468-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220315053040.70545-1-kuniyu@amazon.co.jp>
References: <20220315053040.70545-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.148]
X-ClientProxiedBy: EX13D21UWA003.ant.amazon.com (10.43.160.184) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date:   Tue, 15 Mar 2022 14:30:40 +0900
> From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Date:   Tue, 15 Mar 2022 09:45:03 +0900
>> From:   Eric Dumazet <eric.dumazet@gmail.com>
>> Date:   Mon, 14 Mar 2022 17:26:54 -0700
>>> On 3/14/22 11:10, Shoaib Rao wrote:
>>>>
>>>> On 3/14/22 10:42, Eric Dumazet wrote:
>>>>>
>>>>> On 3/13/22 22:21, Kuniyuki Iwashima wrote:
>>>>>> The commit 314001f0bf92 ("af_unix: Add OOB support") introduced OOB for
>>>>>> AF_UNIX, but it lacks some changes for POLLPRI.  Let's add the missing
>>>>>> piece.
>>>>>>
>>>>>> In the selftest, normal datagrams are sent followed by OOB data, so 
>>>>>> this
>>>>>> commit replaces `POLLIN | POLLPRI` with just `POLLPRI` in the first 
>>>>>> test
>>>>>> case.
>>>>>>
>>>>>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>>>>>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>>>>>> ---
>>>>>>   net/unix/af_unix.c                                  | 2 ++
>>>>>>   tools/testing/selftests/net/af_unix/test_unix_oob.c | 6 +++---
>>>>>>   2 files changed, 5 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>>>>>> index c19569819866..711d21b1c3e1 100644
>>>>>> --- a/net/unix/af_unix.c
>>>>>> +++ b/net/unix/af_unix.c
>>>>>> @@ -3139,6 +3139,8 @@ static __poll_t unix_poll(struct file *file, 
>>>>>> struct socket *sock, poll_table *wa
>>>>>>           mask |= EPOLLIN | EPOLLRDNORM;
>>>>>>       if (sk_is_readable(sk))
>>>>>>           mask |= EPOLLIN | EPOLLRDNORM;
>>>>>> +    if (unix_sk(sk)->oob_skb)
>>>>>> +        mask |= EPOLLPRI;
>>>>>
>>>>>
>>>>> This adds another data-race, maybe add something to avoid another 
>>>>> syzbot report ?
>>>>
>>>> It's not obvious to me how there would be a race as it is just a check.
>>>>
>>> 
>>> KCSAN will detect that whenever unix_poll() reads oob_skb,
>>> 
>>> its value can be changed by another cpu.
>>> 
>>> 
>>> unix_poll() runs without holding a lock.
>> 
>> Thanks for pointing out!
>> So, READ_ONCE() is necessary here, right?
>> oob_skb is written under the lock, so I think there is no paired
>> WRITE_ONCE(), but is it ok?

I have misunderstood this, the lock has nothing to do with WRITE_ONCE()
this time.  The write of oob_skb can be teared by GCC, which leads to a
data race at the read side even with READ_ONCE(), so the paired one is
needed.

I will respin v3 with READ_ONCE() and WRITE_ONCE().


> 
> I've tested the prog below and KCSAN repoted the race.
> Also, READ_ONCE() suppressed it.
> 
> Thank you Eric!
> I'll post v2 with READ_ONCE().
