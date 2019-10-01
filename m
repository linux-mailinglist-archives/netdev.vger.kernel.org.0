Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4579C3A4B
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfJAQTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:19:24 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:33884 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbfJAQTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:19:23 -0400
Received: by mail-pf1-f174.google.com with SMTP id b128so8362220pfa.1
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 09:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7svuOTnUUJTmauXeYKO+JPYVLuQjkrIxKbb6+9qEDhU=;
        b=LW2R3qo2Sn+sZVeH8twR3+G1ED8JVIhf/Hs1rcQXipNPswVPdwvsNHVUlslIl7PtZt
         OXD1p9OymLZhuOKpbEC1EZlZzNga64bkPxnQHvYrLKSSHuOWxYJHSha12XYkOwJWKZ5Z
         XlV8XFq+RUm7HMgRcxIqI6fsNslq3EY3UCmcAKHYW9qRIyNTYE7cuMrArk+quo5yQ+pL
         oqVR6g1ta5aSpdfP4kLo+4zTO/BTKVq6W/dnq99qbvtNPUfDmJ9rnc5uoM7f+BsSlVZ2
         xGjrJBSskzlHoBIjYEdDvaJAJhCWo1qIG1QNbsLVD2Wl0d9sFWVpFpW4Zov6n8yJCESm
         LyOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7svuOTnUUJTmauXeYKO+JPYVLuQjkrIxKbb6+9qEDhU=;
        b=Je8QlWd3PWiHE9kOOxs2fp4yBQOjzxi88M64eCBlykV/MX0hhup/fC9TybQa6jfgnG
         hcIOWFxW5Zyhdah7tIUR1vnVV8CgyECl+4IsRgJzrt17cPFBN7GqQJ0/p0KNwSmIyxoR
         OKEwFXjK2azwN0J6t9x1ekM06MO68ka7obwaBZEGD7pWLa81yVx28NKGbn5o8e0CkTiT
         C/WD8UqYGmKzm8CPbxwHoQgzNXzmrO6ptZZXXNElrmmSlQVfC/aPNCOpiZcyev734yqp
         o2pPABuTCfLIXmPQI5Ss/XFDl8MnDRIkPz7hL6LiDsSpcU57Zhwithk52Jyj2kwyLTef
         ZW2Q==
X-Gm-Message-State: APjAAAVObo8L9jfq/OAx+rxGjHRz5nfL2bLU2iJ2W8RcTS3E2800MaHI
        uxKup2fy9fqQanNCBb+atzJEmSET
X-Google-Smtp-Source: APXvYqwGM1tnb58NnXiJQfCqHje5MycMJxtcYmq7WgbLo67Nu7OgFS/+eTX8rxtxff95HCijiy6J1Q==
X-Received: by 2002:a63:531d:: with SMTP id h29mr31781759pgb.52.1569946761388;
        Tue, 01 Oct 2019 09:19:21 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id s3sm2753267pjq.32.2019.10.01.09.19.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Oct 2019 09:19:20 -0700 (PDT)
Subject: Re: BUG: sk_backlog.len can overestimate
To:     John Ousterhout <ouster@cs.stanford.edu>
Cc:     netdev@vger.kernel.org
References: <CAGXJAmwQw1ohc48NfAvMyNDpDgHGkdVO89Jo8B0j0TuMr7wLpA@mail.gmail.com>
 <CAGXJAmz5izfnamHA3Y_hU-AT1CX5K2MN=6BPjRXXcTCWvPeWng@mail.gmail.com>
 <01ac3ff4-4c06-7a6c-13fc-29ca9ed3ad88@gmail.com>
 <CAGXJAmxmJ-Vm379N4nbjXeQCAgY9ur53wmr0HZy23dQ_t++r-Q@mail.gmail.com>
 <f4520c32-3133-fb3b-034e-d492d40eb066@gmail.com>
 <CAGXJAmygtKtt18nKV6qRCKXfO93DoK4C2Gv_RaMuahsZG3TS6A@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c5886aed-8448-fe62-b2a3-4ae8fe23e2a6@gmail.com>
Date:   Tue, 1 Oct 2019 09:19:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAGXJAmygtKtt18nKV6qRCKXfO93DoK4C2Gv_RaMuahsZG3TS6A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/19 8:48 AM, John Ousterhout wrote:
> On Mon, Sep 30, 2019 at 6:53 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>> On 9/30/19 5:41 PM, John Ousterhout wrote:
>>> On Mon, Sep 30, 2019 at 5:14 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>>
>>>> On 9/30/19 4:58 PM, John Ousterhout wrote:
>>>>> As of 4.16.10, it appears to me that sk->sk_backlog_len does not
>>>>> provide an accurate estimate of backlog length; this reduces the
>>>>> usefulness of the "limit" argument to sk_add_backlog.
>>>>>
>>>>> The problem is that, under heavy load, sk->sk_backlog_len can grow
>>>>> arbitrarily large, even though the actual amount of data in the
>>>>> backlog is small. This happens because __release_sock doesn't reset
>>>>> the backlog length until it gets completely caught up. Under heavy
>>>>> load, new packets can be arriving continuously  into the backlog
>>>>> (which increases sk_backlog.len) while other packets are being
>>>>> serviced. This can go on forever, so sk_backlog.len never gets reset
>>>>> and it can become arbitrarily large.
>>>>
>>>> Certainly not.
>>>>
>>>> It can not grow arbitrarily large, unless a backport gone wrong maybe.
>>>
>>> Can you help me understand what would limit the growth of this value?
>>> Suppose that new packets are arriving as quickly as they are
>>> processed. Every time __release_sock calls sk_backlog_rcv, a new
>>> packet arrives during the call, which is added to the backlog,
>>> incrementing sk_backlog.len. However, sk_backlog_len doesn't get
>>> decreased when sk_backlog_rcv completes, since the backlog hasn't
>>> emptied (as you said, it's not "safe"). As a result, sk_backlog.len
>>> has increased, but the actual backlog length is unchanged (one packet
>>> was added, one was removed). Why can't this process repeat
>>> indefinitely, until eventually sk_backlog.len reaches whatever limit
>>> the transport specifies when it invokes sk_add_backlog? At this point
>>> packets will be dropped by the transport even though the backlog isn't
>>> actually very large.
>>
>> The process is bounded by socket sk_rcvbuf + sk_sndbuf
>>
>> bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb)
>> {
>>         u32 limit = sk->sk_rcvbuf + sk->sk_sndbuf;
>>
>>         ...
>>         if (unlikely(sk_add_backlog(sk, skb, limit))) {
>>             ...
>>             __NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPBACKLOGDROP);
>>         ...
>> }
>>
>>
>> Once the limit is reached, sk_backlog.len wont be touched, unless __release_sock()
>> has processed the whole queue.
> 
> Sorry if I'm missing something obvious here, but when you say
> "sk_backlog.len won't be touched", doesn't that mean that incoming
> packets will have to be dropped?

Yes packets are dropped if the socket has exhausted its memory budget.

Presumably the sender is trying to fool us.

 And can't this occur even though the
> true size of the backlog might be way less than sk_rcvbuf + sk_sndbuf,
> as I described above? It seems to me that the basic problem is that
> sk_backlog.len could exceed any given limit, even though there aren't
> actually that many bytes still left in the backlog.
> 

Sorry, I have no idea what is the problem you see.

