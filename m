Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2BE733C80D
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhCOUz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232350AbhCOUzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 16:55:42 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61E0C06175F
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 13:55:41 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id s17so17921569ljc.5
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 13:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=/SNE60mYRVXIP2k5tkIo6vUZ3UuFytnbu0QAv8b7r1I=;
        b=YDH6+dQ6z0cyr/awfNDOGSZuLJCLEWCPrxEPJKIMNDy2ZAeNmRPMWKVk6cdz6jJuWO
         G7NZDA0+KnOK9XhZZAaj5YzDmIZTY3OG5x/9CwnfnrtgomvC5kfa9/FmiHL6FqKx6K5a
         1uZ8wYBdqUz0VLraJOeOBWCqMrE1xb+hkjoCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=/SNE60mYRVXIP2k5tkIo6vUZ3UuFytnbu0QAv8b7r1I=;
        b=kXByOyABxa7Alce+uRt/scjlE5W4/oDyKbkWGnjerhT+H0GfC6K49+HlBsNOF3V8hT
         86N76XyP87hg60Qp6T4NbXBjtu6eA2XmbVN3xHDk+TQ3ZM8BnBxQzCUQxsb8ZV0DQpBY
         1NQZMNwpfcYUIxAwwxtQeSWZ7bhgd3EcBH84ctM6qgjL/qRc+X3SuhXpFjA8rCk3LBsU
         Ra8lZ+gBUJMtbSgHCaB72YWMKhToVPgYIX6whrV35caOa04HxcYFecRVPALnYm/qtR6h
         WCd7qD7QxaogWKuNz1EItp6r7LbTVYYPc/l4yhCeho8clGFwgssWejsDsFvp/qT+RbWq
         t71A==
X-Gm-Message-State: AOAM5319jnSZxTcOvXJsVnGdAgmgFtZwJqE2kQXAmo8GIKbgrXb7jP7W
        e3pcb5P3I2ZgrC174Bm3QAVSGA==
X-Google-Smtp-Source: ABdhPJwCBSrzS2qfzHSrnTXn5Y9DeD4/xuXWPEZRvbgEP+BOYlgYAbx/m9oShSW0/dY8szlr8h2cMg==
X-Received: by 2002:a2e:302:: with SMTP id 2mr546896ljd.159.1615841740199;
        Mon, 15 Mar 2021 13:55:40 -0700 (PDT)
Received: from cloudflare.com (83.31.58.229.ipv4.supernova.orange.pl. [83.31.58.229])
        by smtp.gmail.com with ESMTPSA id q7sm2852305lfc.260.2021.03.15.13.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 13:55:39 -0700 (PDT)
References: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
 <20210310053222.41371-5-xiyou.wangcong@gmail.com>
 <87y2es37i3.fsf@cloudflare.com>
 <CAM_iQpVmtHPqzGHEUPhtVroxCeWSBvahKMrbLrEq4gNNVGq2zg@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next v4 04/11] skmsg: avoid lock_sock() in
 sk_psock_backlog()
In-reply-to: <CAM_iQpVmtHPqzGHEUPhtVroxCeWSBvahKMrbLrEq4gNNVGq2zg@mail.gmail.com>
Date:   Mon, 15 Mar 2021 21:55:38 +0100
Message-ID: <87v99s2l2t.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 13, 2021 at 06:32 PM CET, Cong Wang wrote:
> On Fri, Mar 12, 2021 at 4:02 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> On Wed, Mar 10, 2021 at 06:32 AM CET, Cong Wang wrote:
>> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
>> > index dd53a7771d7e..26ba47b099f1 100644
>> > --- a/net/core/sock_map.c
>> > +++ b/net/core/sock_map.c
>> > @@ -1540,6 +1540,7 @@ void sock_map_close(struct sock *sk, long timeout)
>> >       saved_close = psock->saved_close;
>> >       sock_map_remove_links(sk, psock);
>> >       rcu_read_unlock();
>> > +     sk_psock_purge(psock);
>> >       release_sock(sk);
>> >       saved_close(sk, timeout);
>> >  }
>>
>> Nothing stops sk_psock_backlog from running after sk_psock_purge:
>>
>>
>> CPU 1                                                   CPU 2
>>
>> sk_psock_skb_redirect()
>>   sk_psock(sk_other)
>>   sock_flag(sk_other, SOCK_DEAD)
>>   sk_psock_test_state(psock_other,
>>                       SK_PSOCK_TX_ENABLED)
>>                                                         sk_psock_purge()
>>   skb_queue_tail(&psock_other->ingress_skb, skb)
>>   schedule_work(&psock_other->work)
>>
>>
>> And sock_orphan can run while we're in sendmsg/sendpage_unlocked:
>>
>>
>> CPU 1                                                   CPU 2
>>
>> sk_psock_backlog
>>   ...
>>   sendmsg_unlocked
>>     sock = sk->sk_socket
>>                                                         tcp_close
>>                                                           __tcp_close
>>                                                             sock_orphan
>>     kernel_sendmsg(sock, msg, vec, num, size)
>>
>>
>> So, after this change, without lock_sock in sk_psock_backlog, we will
>> not block tcp_close from running.
>>
>> This makes me think that the process socket can get released from under
>> us, before kernel_sendmsg/sendpage runs.
>
> I think you are right, I thought socket is orphaned in inet_release(), clearly
> I was wrong. But, I'd argue in the above scenario, the packet should not
> be even queued in the first place, as SK_PSOCK_TX_ENABLED is going
> to be cleared, so I think the right fix is probably to make clearing psock
> state and queuing the packet under a spinlock.

Sounds like a good idea. The goal, I understand, is to guarantee that
psock holds a ref count on proces socket for the duration of
sk_psock_backlog() run.

That would not only let us get rid of lock_sock(), with finer grained
queue locks, but also the sock_flag(psock->sk, SOCK_DEAD) check.
