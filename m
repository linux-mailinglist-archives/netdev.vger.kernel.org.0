Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B185F1465D5
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgAWKeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:34:14 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33847 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgAWKeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:34:13 -0500
Received: by mail-wm1-f66.google.com with SMTP id s144so1544840wme.1
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 02:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=dRs1hZ1O3p0kTDo1ICQQAh+9EI2D7V0csE6IMjfrz50=;
        b=CXKHf7lODc6V8eWGUrEelhjAYRezinjM/RtYDqL16AcuBYfPBaXI2NSCR2neYdUKMQ
         BZtoWCT5wPBjRDnRRnvBcXECgnXQ4CBq/F4eesyrqZDec2JhPda4kp6RZ26j68a7pWyI
         YN9mNLS5YzDDpurtouPcn+qf2Pvjeojz/dpMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=dRs1hZ1O3p0kTDo1ICQQAh+9EI2D7V0csE6IMjfrz50=;
        b=hwst6NqqOpvGOfGFAx00IWWft7Psmcdw6SXUQL6E67vUMLTdppWWe+nzyASv/woiwT
         sIgE537Pr2NrfdKLvpC3ZTa/FBFPH6/t0Yca0OrQh0mv/cjx+GvL51p/C1qSYIMhaJAu
         GhZBua+Zsfm/KAdi1bVKGejOBcaUsiXXUPz0NpIVsSa7CX8uoALRQSpfi1v2iObUt4SZ
         W57+Qr6KXNm9jiC8dNW/5z1d6z5IgJlRzzCZc0TWdIQTW8pIpWcjb3IUVe8L+kcmnP2k
         Qtrmqevh7lKrD1hmnC7PKSj2n5hJhb+wBH6kAj3I10F/mBCQQ/sVG247fBeO+rQiItLu
         MnBg==
X-Gm-Message-State: APjAAAXQOHCHnD0wkMnWVzaFBW5PkUhc8RqE7u3mKhEqzSPCwGKJBtd9
        OwJfNy2xc01X7bM1SNdHQj9TQg==
X-Google-Smtp-Source: APXvYqzbnfozQMSyOAGC01KVLGL3rl2FDCMrQgukBajPMoYXj+0emIY06KYeqv/YywS4zeK4ydDNXg==
X-Received: by 2002:a1c:988a:: with SMTP id a132mr3331305wme.113.1579775651455;
        Thu, 23 Jan 2020 02:34:11 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id g9sm2462116wro.67.2020.01.23.02.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 02:34:10 -0800 (PST)
References: <20200122130549.832236-1-jakub@cloudflare.com> <20200122130549.832236-5-jakub@cloudflare.com> <20200122203538.juspsqgwki7rn45q@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team\@cloudflare.com" <kernel-team@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 04/12] tcp_bpf: Don't let child socket inherit parent protocol ops on copy
In-reply-to: <20200122203538.juspsqgwki7rn45q@kafai-mbp.dhcp.thefacebook.com>
Date:   Thu, 23 Jan 2020 11:34:10 +0100
Message-ID: <878sly31i5.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 09:35 PM CET, Martin Lau wrote:
> On Wed, Jan 22, 2020 at 02:05:41PM +0100, Jakub Sitnicki wrote:
>> Prepare for cloning listening sockets that have their protocol callbacks
>> overridden by sk_msg. Child sockets must not inherit parent callbacks that
>> access state stored in sk_user_data owned by the parent.
>> 
>> Restore the child socket protocol callbacks before it gets hashed and any
>> of the callbacks can get invoked.
>> 
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>  include/net/tcp.h        |  7 +++++++
>>  net/ipv4/tcp_bpf.c       | 13 +++++++++++++
>>  net/ipv4/tcp_minisocks.c |  2 ++
>>  3 files changed, 22 insertions(+)
>> 
>> diff --git a/include/net/tcp.h b/include/net/tcp.h
>> index 9dd975be7fdf..ac205d31e4ad 100644
>> --- a/include/net/tcp.h
>> +++ b/include/net/tcp.h
>> @@ -2181,6 +2181,13 @@ int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
>>  		    int nonblock, int flags, int *addr_len);
>>  int __tcp_bpf_recvmsg(struct sock *sk, struct sk_psock *psock,
>>  		      struct msghdr *msg, int len, int flags);
>> +#ifdef CONFIG_NET_SOCK_MSG
>> +void tcp_bpf_clone(const struct sock *sk, struct sock *child);
> nit.  "struct sock *child" vs ...
>
>> +#else
>> +static inline void tcp_bpf_clone(const struct sock *sk, struct sock *child)
>> +{
>> +}
>> +#endif
>>  
>>  /* Call BPF_SOCK_OPS program that returns an int. If the return value
>>   * is < 0, then the BPF op failed (for example if the loaded BPF
>> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
>> index 4f25aba44ead..16060e0893a1 100644
>> --- a/net/ipv4/tcp_bpf.c
>> +++ b/net/ipv4/tcp_bpf.c
>> @@ -582,6 +582,19 @@ static void tcp_bpf_close(struct sock *sk, long timeout)
>>  	saved_close(sk, timeout);
>>  }
>>  
>> +/* If a child got cloned from a listening socket that had tcp_bpf
>> + * protocol callbacks installed, we need to restore the callbacks to
>> + * the default ones because the child does not inherit the psock state
>> + * that tcp_bpf callbacks expect.
>> + */
>> +void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
> "struct sock *newsk" here.
>
> Could be a follow-up.
>
> Other than that,
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Will fix in v4. Thanks!
