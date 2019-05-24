Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC38029262
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389340AbfEXIF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:05:27 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:47033 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389156AbfEXIF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 04:05:27 -0400
Received: by mail-lj1-f193.google.com with SMTP id m15so7794855ljg.13
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 01:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=Pcqhbfv9rqEmXqsFiPsa69bQ6Ua63ntosq9KvMQBRiI=;
        b=DWhSy0nyYDte+0Pi3Os21/8r0ZznF52UC1eNh2Jj5UDAOwke4Q6mYiOhqiyZR3LisG
         Q3H/MCfMZwZyAuWm5mvNPI5S9//ZheiCRqpt3vTSx9Wua4dbmLr8U4raC2ETcVkH2fK5
         bhX8FPZlPuXjlSnKhPk7SGX0N5HoJyj5CmHr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=Pcqhbfv9rqEmXqsFiPsa69bQ6Ua63ntosq9KvMQBRiI=;
        b=EAUcC69SwvHmejEjc+Isy1RvGwegApIQ4QaGYiKEDWnH8hO7yc29e3tFDl+cqXNEQT
         0O6gP+j1ZwUeUl+QLAyScw82TtvazVEJibJ9lb/KunMfhb4uB5GUZo4UK4LiHCNjxshX
         MCX4SttTNJGlOJnfuTN2SWTeVMGvXlFm6klbiqWxUP60/RnzctNmefrcouUzoKWGJPbm
         /09zrMHEIDMJMj4pDMeXRH8oGFvkLk+76nA6N969O+N9/M/1evwY5kuWG7J0a6ePqp91
         nWibCZJZ7ATsolgz+eXuxfMi7l6e6QbepM38zOwkbMfpJY5qa9lh66zpXWiLC8ToomF7
         +sFw==
X-Gm-Message-State: APjAAAWJOaCinQRfNhZxELekEFs9yQ9LOUPXeJfndMR8K9m0WZ2qB1R4
        KPwgmaURmLb+Q6SOUuKPNTfc4OjWhRk=
X-Google-Smtp-Source: APXvYqxEhCw6YQWth+6DIx0tBGGC07dmJYBoUsJn8vJ/3LBm8CuiJjJ9bCp2kZa7w13d2yLKVWRmig==
X-Received: by 2002:a2e:91c6:: with SMTP id u6mr34472233ljg.143.1558685125146;
        Fri, 24 May 2019 01:05:25 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id h11sm452819lfh.8.2019.05.24.01.05.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 01:05:24 -0700 (PDT)
References: <20190211090949.18560-1-jakub@cloudflare.com> <5439765e-1288-c379-0ead-75597092a404@iogearbox.net> <871s423i6d.fsf@cloudflare.com> <5ce45a6fcd82d_48b72ac3337c45b85f@john-XPS-13-9360.notmuch> <87v9y2zqpz.fsf@cloudflare.com> <5ce6c32418618_64ba2ad730e1a5b44@john-XPS-13-9360.notmuch>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH net] sk_msg: Keep reference on socket file while psock lives
In-reply-to: <5ce6c32418618_64ba2ad730e1a5b44@john-XPS-13-9360.notmuch>
Date:   Fri, 24 May 2019 10:05:23 +0200
Message-ID: <87r28oz398.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 05:58 PM CEST, John Fastabend wrote:
> [...]
>
>>
>> Thanks for taking a look at it. Setting MSG_DONTWAIT works great for
>> me. No more crashes in sk_stream_wait_memory. I've tested it on top of
>> current bpf-next (f49aa1de9836). Here's my:
>>
>>   Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
>>
>> The actual I've tested is below, for completeness.
>>
>> BTW. I've ran into another crash which I haven't seen before while
>> testing sockmap-echo, but it looks unrelated:
>>
>>   https://lore.kernel.org/netdev/20190522100142.28925-1-jakub@cloudflare.com/
>>
>> -Jakub
>>
>> --- 8< ---
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index e89be6282693..4a7c656b195b 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -2337,6 +2337,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
>>                 kv.iov_base = skb->data + offset;
>>                 kv.iov_len = slen;
>>                 memset(&msg, 0, sizeof(msg));
>> +               msg.msg_flags = MSG_DONTWAIT;
>>
>>                 ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
>>                 if (ret <= 0)
>
> I went ahead and submitted this feel free to add your signed-off-by.

Thanks! The fix was all your idea :-)

Now that those pesky crashes are gone, we plan to look into drops when
doing echo with sockmap. Marek tried running echo-sockmap [1] with
latest bpf-next (plus mentioned crash fixes) and reports that not all
data bounces back:

$ yes| head -c $[1024*1024] | nc -q2 192.168.1.33 1234 |wc -c
971832
$ yes| head -c $[1024*1024] | nc -q2 192.168.1.33 1234 |wc -c
867352
$ yes| head -c $[1024*1024] | nc -q2 192.168.1.33 1234 |wc -c
952648

I'm tring to turn echo-sockmap into a selftest but as you can probably
guess over loopback all works fine.

-Jakub

[1] https://github.com/cloudflare/cloudflare-blog/blob/master/2019-02-tcp-splice/echo-sockmap.c
