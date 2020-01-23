Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8163114713C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 19:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgAWS45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 13:56:57 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38100 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728655AbgAWS45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 13:56:57 -0500
Received: by mail-lf1-f68.google.com with SMTP id r14so3156801lfm.5
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 10:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=CQPPZJ77X2MZ75IKPgLYEnXAztH6FsMlkSGPLhgdfS8=;
        b=iIkgkyZjHobkEZV5iiQwI9SkPQRGzWSfQPnLhCHIiAOyFzt7qPxxvNyx24QJjBhVAi
         fZziYMu5tmiaKAA64FZMFmUr44Z+pf0jv2v5M6ysSSNNGK771PV95DkyZHHHh0qmO2QM
         qOtCiNqm/SdQ3M24Mkfi4+Bm8iUDZUUbAA0uk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=CQPPZJ77X2MZ75IKPgLYEnXAztH6FsMlkSGPLhgdfS8=;
        b=j4ONJNYdUOvidv4vpWMmyi1Ej8nfXrVGZWz+a2+99WRzhlGyaDFaOhhB5BuLR0MuRi
         YbGmK/xToI73GDSA7HzJPF/lwH50lH8/2UPXcXjjPT0gJedd90Olny7ZKhlad6LiuUQF
         F+6sdPHdSBkTTYgEaZxvSHiq04zfOJanczbhA0SMMO0QR2hSB0cwLFHbH9lX82X0UbBt
         c/mxe6IQ7YbPnYMaiFNLD8S16rBInm1cVkkVJVUELrLAnoO1PyoQWepTCFK/YRioBGMy
         KvYebsUsJionp8ypobtpSVzp/EiutWT9tERhtM+53ljzqfFp9Vnfemx1hHzuoWmmQQkb
         0CGQ==
X-Gm-Message-State: APjAAAVz1S1keQjpnFgTdE/v/hfgSFOsySF1Ip5QgwZYS7vGchDQkN4G
        1xR3HIQnhpdI+J/QfLglfDsuXH+3wrvBdQ==
X-Google-Smtp-Source: APXvYqwhrdtLBI6JojvnQM0OSVwglpYWiAP0jhmVXzTYMm6AsLHWZRiFdd5ucsNidxU46cs+f/HdGQ==
X-Received: by 2002:a05:6512:15d:: with SMTP id m29mr5578510lfo.51.1579805815180;
        Thu, 23 Jan 2020 10:56:55 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id m24sm2098164ljb.81.2020.01.23.10.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 10:56:54 -0800 (PST)
References: <20200123155534.114313-1-jakub@cloudflare.com> <20200123155534.114313-3-jakub@cloudflare.com> <a6bf279e-a998-84ab-4371-cd6c1ccbca5d@gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v4 02/12] net, sk_msg: Annotate lockless access to sk_prot on clone
In-reply-to: <a6bf279e-a998-84ab-4371-cd6c1ccbca5d@gmail.com>
Date:   Thu, 23 Jan 2020 19:56:53 +0100
Message-ID: <874kwm2e8a.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 06:18 PM CET, Eric Dumazet wrote:
> On 1/23/20 7:55 AM, Jakub Sitnicki wrote:
>> sk_msg and ULP frameworks override protocol callbacks pointer in
>> sk->sk_prot, while tcp accesses it locklessly when cloning the listening
>> socket, that is with neither sk_lock nor sk_callback_lock held.
>>
>> Once we enable use of listening sockets with sockmap (and hence sk_msg),
>> there will be shared access to sk->sk_prot if socket is getting cloned
>> while being inserted/deleted to/from the sockmap from another CPU:
>>
>> Read side:
>>
>> tcp_v4_rcv
>>   sk = __inet_lookup_skb(...)
>>   tcp_check_req(sk)
>>     inet_csk(sk)->icsk_af_ops->syn_recv_sock
>>       tcp_v4_syn_recv_sock
>>         tcp_create_openreq_child
>>           inet_csk_clone_lock
>>             sk_clone_lock
>>               READ_ONCE(sk->sk_prot)
>>
>> Write side:
>>
>> sock_map_ops->map_update_elem
>>   sock_map_update_elem
>>     sock_map_update_common
>>       sock_map_link_no_progs
>>         tcp_bpf_init
>>           tcp_bpf_update_sk_prot
>>             sk_psock_update_proto
>>               WRITE_ONCE(sk->sk_prot, ops)
>>
>> sock_map_ops->map_delete_elem
>>   sock_map_delete_elem
>>     __sock_map_delete
>>      sock_map_unref
>>        sk_psock_put
>>          sk_psock_drop
>>            sk_psock_restore_proto
>>              tcp_update_ulp
>>                WRITE_ONCE(sk->sk_prot, proto)
>>
>> Mark the shared access with READ_ONCE/WRITE_ONCE annotations.
>>
>> Acked-by: Martin KaFai Lau <kafai@fb.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>  include/linux/skmsg.h | 3 ++-
>>  net/core/sock.c       | 5 +++--
>>  net/ipv4/tcp_bpf.c    | 4 +++-
>>  net/ipv4/tcp_ulp.c    | 3 ++-
>>  net/tls/tls_main.c    | 3 ++-
>>  5 files changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
>> index 41ea1258d15e..55c834a5c25e 100644
>> --- a/include/linux/skmsg.h
>> +++ b/include/linux/skmsg.h
>> @@ -352,7 +352,8 @@ static inline void sk_psock_update_proto(struct sock *sk,
>>  	psock->saved_write_space = sk->sk_write_space;
>>
>>  	psock->sk_proto = sk->sk_prot;
>> -	sk->sk_prot = ops;
>> +	/* Pairs with lockless read in sk_clone_lock() */
>> +	WRITE_ONCE(sk->sk_prot, ops);
>
>
> Note there are dozens of calls like
>
> if (sk->sk_prot->handler)
>     sk->sk_prot->handler(...);
>
> Some of them being done lockless.
>
> I know it is painful, but presumably we need
>
> const struct proto *ops = READ_ONCE(sk->sk_prot);
>
> if (ops->handler)
>     ops->handler(....);

Yikes! That will be quite an audit. Thank you for taking a look.

Now I think I understand what John had in mind when asking for pushing
these annotations to the bpf tree as well [0].

Considering these are lacking today, can I do it as a follow up?

[0] https://lore.kernel.org/bpf/20200110105027.257877-1-jakub@cloudflare.com/T/#m6a4f84a922a393719a7ea7b33dafdb6c66b72827
