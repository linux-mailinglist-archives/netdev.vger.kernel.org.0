Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5F91139C7E
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 23:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgAMWbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 17:31:47 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45707 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgAMWbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 17:31:47 -0500
Received: by mail-lj1-f196.google.com with SMTP id j26so11961165ljc.12
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 14:31:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=e74JGoY1ojHAtLAhiWMAFpQFNt52SQK2CW+q5dprebc=;
        b=YyWUFUX5S5aTlmidhrgT2cM157XASQX91W+Fpl5omKHy3WW7Bk/6Y/gk+LKj4b9brQ
         tq8nDWCdrSIy6+WN+tfVR7XVtu4rdiovyI9Jc+7PvWqYwtet5E6X/BhzYsiONdNI7Shx
         AMgPU2gsvjOhI06wZIT9p7oZX2upctykXbHmc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=e74JGoY1ojHAtLAhiWMAFpQFNt52SQK2CW+q5dprebc=;
        b=f97jMNdU1VbE7dZHs0w11jWX1TUM6ei4AVtRua41iPDuEs+2VloFeu6YotesH4IW/l
         8WTJEPn+75PsXCN1X/4OfVb0H7LUgXXzQRit77JW33T5lB2KTjIn0VPGc0B1bsTJAQHe
         i4nX4b0Mx2YITZs015NosFitIrjZKS7MUchVdjJJd0mp5xufGAJYH46YpPzRy68Z/2uc
         fB3X599xJfR64SpzGtEMn0vLVZoXGRkvBLxiPeViGdZ5sum7uz80jI8e5S44+Lh69LMD
         n33X9DnGJevV5uzQQiGii2rdW+xSM9wx9t7Su3o0EosrZzX/lPRAtWelsvtOKHxa4eJH
         xugQ==
X-Gm-Message-State: APjAAAVUSPp+Q6HKirqzonlen+PON+dXqJNU0Rgv4UDMeC572L5Bbqv7
        /v7cuYS6A1B3Ky9ou3ngU+YOLQ==
X-Google-Smtp-Source: APXvYqxX26oDY+WvfgPZeQyhs3z0Dx4CL26PCTQFhVlKVc06Vujs5oDxPbT0tv3W/KgJYCI04FUJwA==
X-Received: by 2002:a2e:9716:: with SMTP id r22mr12715781lji.224.1578954705203;
        Mon, 13 Jan 2020 14:31:45 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id d11sm6339255lfj.3.2020.01.13.14.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 14:31:44 -0800 (PST)
References: <20200110105027.257877-1-jakub@cloudflare.com> <20200110105027.257877-5-jakub@cloudflare.com> <5e1a5ed97885d_1e7f2b0c859c45c0d7@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Eric Dumazet <edumazet@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v2 04/11] tcp_bpf: Don't let child socket inherit parent protocol ops on copy
In-reply-to: <5e1a5ed97885d_1e7f2b0c859c45c0d7@john-XPS-13-9370.notmuch>
Date:   Mon, 13 Jan 2020 23:31:43 +0100
Message-ID: <87h80zrnsg.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 12, 2020 at 12:48 AM CET, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> Prepare for cloning listening sockets that have their protocol callbacks
>> overridden by sk_msg. Child sockets must not inherit parent callbacks that
>> access state stored in sk_user_data owned by the parent.
>> 
>> Restore the child socket protocol callbacks before the it gets hashed and
>> any of the callbacks can get invoked.
>> 
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>  include/net/tcp.h        |  1 +
>>  net/ipv4/tcp_bpf.c       | 13 +++++++++++++
>>  net/ipv4/tcp_minisocks.c |  2 ++
>>  3 files changed, 16 insertions(+)
>> 
>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>> index 9dd975be7fdf..7cbf9465bb10 100644
>> --- a/include/net/tcp.h
>> +++ b/include/net/tcp.h
>> @@ -2181,6 +2181,7 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>>  		    int nonblock, int flags, int *addr_len);
>>  int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
>>  		      struct msghdr *msg, int len, int flags);
>> +void tcp_bpf_clone(const struct sock *sk, struct sock *child);
>>  
>>  /* Call BPF_SOCK_OPS program that returns an int. If the return value
>>   * is < 0, then the BPF op failed (for example if the loaded BPF
>> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
>> index f6c83747c71e..6f96320fb7cf 100644
>> --- a/net/ipv4/tcp_bpf.c
>> +++ b/net/ipv4/tcp_bpf.c
>> @@ -586,6 +586,19 @@ static void tcp_bpf_close(struct sock *sk, long timeout)
>>  	saved_close(sk, timeout);
>>  }
>>  
>> +/* If a child got cloned from a listening socket that had tcp_bpf
>> + * protocol callbacks installed, we need to restore the callbacks to
>> + * the default ones because the child does not inherit the psock state
>> + * that tcp_bpf callbacks expect.
>> + */
>> +void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
>> +{
>> +	struct proto *prot = newsk->sk_prot;
>> +
>> +	if (prot->recvmsg == tcp_bpf_recvmsg)
>> +		newsk->sk_prot = sk->sk_prot_creator;
>> +}
>> +
>
> ^^^^ probably needs to go into tcp.h wrapped in ifdef NET_SOCK_MSG with
> a stub for ifndef NET_SOCK_MSG case.
>
> Looks like build bot also caught this.

Oops, I need to add NET_SOCK_MSG to my build matrix :-)
