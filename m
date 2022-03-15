Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A854D91B5
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239891AbiCOAqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241328AbiCOAqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:46:24 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6B0764A
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1647305114; x=1678841114;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iAz0JnL5BLWKfQtcThpjAz1jV2tm1YoFmZisB2NBzRU=;
  b=ZVt7lxMDG/FJ0zAclVEVqfmg/M7W4xOqj8AWL0H73BRfI2JPTNeQ/kdy
   goVLJAUXZa4llmiwfWANGNKeXSJ2Z5jBvwgNwkv64QAeXHQjUn4n5IKC5
   LjmZcxGZkb/Qv2qO1F24vhR/8+isNggqXO30tRh0PC9rxCVCssLV0xPKn
   4=;
X-IronPort-AV: E=Sophos;i="5.90,181,1643673600"; 
   d="scan'208";a="184581742"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 15 Mar 2022 00:45:13 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-87b71607.us-east-1.amazon.com (Postfix) with ESMTPS id 3762214109C;
        Tue, 15 Mar 2022 00:45:10 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Tue, 15 Mar 2022 00:45:10 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.250) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 15 Mar 2022 00:45:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <netdev@vger.kernel.org>,
        <rao.shoaib@oracle.com>
Subject: Re: [PATCH net] af_unix: Support POLLPRI for OOB.
Date:   Tue, 15 Mar 2022 09:45:03 +0900
Message-ID: <20220315004503.46906-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <14f3c8e3-1b8f-7152-224b-6a4c9a0b6e61@gmail.com>
References: <14f3c8e3-1b8f-7152-224b-6a4c9a0b6e61@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.250]
X-ClientProxiedBy: EX13D18UWC002.ant.amazon.com (10.43.162.88) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Mon, 14 Mar 2022 17:26:54 -0700
> On 3/14/22 11:10, Shoaib Rao wrote:
>>
>> On 3/14/22 10:42, Eric Dumazet wrote:
>>>
>>> On 3/13/22 22:21, Kuniyuki Iwashima wrote:
>>>> The commit 314001f0bf92 ("af_unix: Add OOB support") introduced OOB for
>>>> AF_UNIX, but it lacks some changes for POLLPRI.  Let's add the missing
>>>> piece.
>>>>
>>>> In the selftest, normal datagrams are sent followed by OOB data, so 
>>>> this
>>>> commit replaces `POLLIN | POLLPRI` with just `POLLPRI` in the first 
>>>> test
>>>> case.
>>>>
>>>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>>>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>>>> ---
>>>>   net/unix/af_unix.c                                  | 2 ++
>>>>   tools/testing/selftests/net/af_unix/test_unix_oob.c | 6 +++---
>>>>   2 files changed, 5 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>>>> index c19569819866..711d21b1c3e1 100644
>>>> --- a/net/unix/af_unix.c
>>>> +++ b/net/unix/af_unix.c
>>>> @@ -3139,6 +3139,8 @@ static __poll_t unix_poll(struct file *file, 
>>>> struct socket *sock, poll_table *wa
>>>>           mask |= EPOLLIN | EPOLLRDNORM;
>>>>       if (sk_is_readable(sk))
>>>>           mask |= EPOLLIN | EPOLLRDNORM;
>>>> +    if (unix_sk(sk)->oob_skb)
>>>> +        mask |= EPOLLPRI;
>>>
>>>
>>> This adds another data-race, maybe add something to avoid another 
>>> syzbot report ?
>>
>> It's not obvious to me how there would be a race as it is just a check.
>>
> 
> KCSAN will detect that whenever unix_poll() reads oob_skb,
> 
> its value can be changed by another cpu.
> 
> 
> unix_poll() runs without holding a lock.

Thanks for pointing out!
So, READ_ONCE() is necessary here, right?
oob_skb is written under the lock, so I think there is no paired
WRITE_ONCE(), but is it ok?


> 
> 
> 
>> Also this change should be under #if IS_ENABLED(CONFIG_AF_UNIX_OOB)

And thanks, Shoaib!
Will add the condition in v2.


>>
>> Thanks,
>>
>> Shoaib
>>
>>>
>>>
>>>>         /* Connection-based need to check for termination and 
>>>> startup */
>>>>       if ((sk->sk_type == SOCK_STREAM || sk->sk_type == 
>>>> SOCK_SEQPACKET) &&
>>>> diff --git a/tools/testing/selftests/net/af_unix/test_unix_oob.c 
>>>> b/tools/testing/selftests/net/af_unix/test_unix_oob.c
>>>> index 3dece8b29253..b57e91e1c3f2 100644
>>>> --- a/tools/testing/selftests/net/af_unix/test_unix_oob.c
>>>> +++ b/tools/testing/selftests/net/af_unix/test_unix_oob.c
>>>> @@ -218,10 +218,10 @@ main(int argc, char **argv)
>>>>         /* Test 1:
>>>>        * veriyf that SIGURG is
>>>> -     * delivered and 63 bytes are
>>>> -     * read and oob is '@'
>>>> +     * delivered, 63 bytes are
>>>> +     * read, oob is '@', and POLLPRI works.
>>>>        */
>>>> -    wait_for_data(pfd, POLLIN | POLLPRI);
>>>> +    wait_for_data(pfd, POLLPRI);
>>>>       read_oob(pfd, &oob);
>>>>       len = read_data(pfd, buf, 1024);
>>>>       if (!signal_recvd || len != 63 || oob != '@') {
