Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 740E91543FD
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 13:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgBFM0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 07:26:36 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39724 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgBFM0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 07:26:36 -0500
Received: by mail-wm1-f67.google.com with SMTP id c84so6907792wme.4
        for <netdev@vger.kernel.org>; Thu, 06 Feb 2020 04:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=4IqGG90hzs/rSeSyZlWCzvOfVkyWTnP3OPmi4HPtnac=;
        b=kvnlldKAOEWtv9L4cvgc2+kQBBKi0f3EU5UPhPSwxvq4Z6YndBuF4UdShoEwwlDbMv
         HUNKWldMOSZep+NRpPzE+xy86NtpH+CK97crbFffDiW8NVe20GGukHcp32qPNfwqagnF
         6huWrs3zTZ1ZZ7ZjJmFykJrncXFFWU3t1GNQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=4IqGG90hzs/rSeSyZlWCzvOfVkyWTnP3OPmi4HPtnac=;
        b=U1yPCFjAsRp3W782TZtvyy6LFrMbVVkSEYg8h8Gnr+9ogAPvtggojO4TKtMlobg9XL
         CojWCGyG0Or1FyQXzJmOLLDiaXyar3RUJPm9A2KCQ6ZnTxUugndAZuWsNErAz+0zHS5/
         rMZvKZdlJ3YrOQhaXXrt9oz0ZKx+suOfFMG9hwB8W5yDfMLmL+THxObZWBgbAwf+34td
         /JrlZVhLjg7puQu1o6IKTBMaChTCJiBJX04aL1u7y29sXI0ynKO4izbTxGftD5z284YC
         Q6YhpCBt/Ym1ODsacEVf0fcYxNZsGmrqPRNZroWN0ScFAC7A0jbGXiS2HON6esMIWukn
         Hq8Q==
X-Gm-Message-State: APjAAAV0Y335weMi39R7Rq237HV9fYPf1uLja0EKFYHPMjwjWqxpiAmY
        ytEOWibcouSIh0TcvtbW3p32Uw==
X-Google-Smtp-Source: APXvYqw5kEFIKIbx/Y0Im1n2EpW6nOkN2LSVe/Qzg0jWTSXr86kfe13lT8IZKDZLiWGUhGtGAzLISA==
X-Received: by 2002:a1c:48c1:: with SMTP id v184mr4315520wma.5.1580991992526;
        Thu, 06 Feb 2020 04:26:32 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id a26sm3691058wmm.18.2020.02.06.04.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 04:26:31 -0800 (PST)
References: <20200111061206.8028-1-john.fastabend@gmail.com> <20200111061206.8028-3-john.fastabend@gmail.com> <8736boor55.fsf@cloudflare.com> <5e3ba96ca7889_6b512aafe4b145b812@john-XPS-13-9370.notmuch>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, song@kernel.org, jonathan.lemon@gmail.com
Subject: Re: [bpf PATCH v2 2/8] bpf: sockmap, ensure sock lock held during tear down
In-reply-to: <5e3ba96ca7889_6b512aafe4b145b812@john-XPS-13-9370.notmuch>
Date:   Thu, 06 Feb 2020 13:26:30 +0100
Message-ID: <871rr7oqa1.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 06, 2020 at 06:51 AM CET, John Fastabend wrote:
> Jakub Sitnicki wrote:
>> On Sat, Jan 11, 2020 at 07:12 AM CET, John Fastabend wrote:
>> > The sock_map_free() and sock_hash_free() paths used to delete sockmap
>> > and sockhash maps walk the maps and destroy psock and bpf state associated
>> > with the socks in the map. When done the socks no longer have BPF programs
>> > attached and will function normally. This can happen while the socks in
>> > the map are still "live" meaning data may be sent/received during the walk.
>> >
>> > Currently, though we don't take the sock_lock when the psock and bpf state
>> > is removed through this path. Specifically, this means we can be writing
>> > into the ops structure pointers such as sendmsg, sendpage, recvmsg, etc.
>> > while they are also being called from the networking side. This is not
>> > safe, we never used proper READ_ONCE/WRITE_ONCE semantics here if we
>> > believed it was safe. Further its not clear to me its even a good idea
>> > to try and do this on "live" sockets while networking side might also
>> > be using the socket. Instead of trying to reason about using the socks
>> > from both sides lets realize that every use case I'm aware of rarely
>> > deletes maps, in fact kubernetes/Cilium case builds map at init and
>> > never tears it down except on errors. So lets do the simple fix and
>> > grab sock lock.
>> >
>> > This patch wraps sock deletes from maps in sock lock and adds some
>> > annotations so we catch any other cases easier.
>> >
>> > Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
>> > Cc: stable@vger.kernel.org
>> > Acked-by: Song Liu <songliubraving@fb.com>
>> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
>> > ---
>> >  net/core/skmsg.c    | 2 ++
>> >  net/core/sock_map.c | 7 ++++++-
>> >  2 files changed, 8 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
>> > index ded2d5227678..3866d7e20c07 100644
>> > --- a/net/core/skmsg.c
>> > +++ b/net/core/skmsg.c
>> > @@ -594,6 +594,8 @@ EXPORT_SYMBOL_GPL(sk_psock_destroy);
>> >
>> >  void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
>> >  {
>> > +	sock_owned_by_me(sk);
>> > +
>> >  	sk_psock_cork_free(psock);
>> >  	sk_psock_zap_ingress(psock);
>> >
>> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
>> > index eb114ee419b6..8998e356f423 100644
>> > --- a/net/core/sock_map.c
>> > +++ b/net/core/sock_map.c
>> > @@ -241,8 +241,11 @@ static void sock_map_free(struct bpf_map *map)
>> >  		struct sock *sk;
>> >
>> >  		sk = xchg(psk, NULL);
>> > -		if (sk)
>> > +		if (sk) {
>> > +			lock_sock(sk);
>> >  			sock_map_unref(sk, psk);
>> > +			release_sock(sk);
>> > +		}
>> >  	}
>> >  	raw_spin_unlock_bh(&stab->lock);
>> >  	rcu_read_unlock();
>>
>> John, I've noticed this is triggering warnings that we might sleep in
>> lock_sock while (1) in RCU read-side section, and (2) holding a spin
>> lock:

[...]

>>
>> Here's an idea how to change the locking. I'm still wrapping my head
>> around what protects what in sock_map_free, so please bear with me:
>>
>> 1. synchronize_rcu before we iterate over the array is not needed,
>>    AFAICT. We are not free'ing the map just yet, hence any readers
>>    accessing the map via the psock are not in danger of use-after-free.
>
> Agreed. When we added 2bb90e5cc90e ("bpf: sockmap, synchronize_rcu before
> free'ing map") we could have done this.
>
>>
>> 2. rcu_read_lock is needed to protect access to psock inside
>>    sock_map_unref, but we can't sleep while in RCU read-side.  So push
>>    it down, after we grab the sock lock.
>
> yes this looks better.
>
>>
>> 3. Grabbing stab->lock seems not needed, either. We get called from
>>    bpf_map_free_deferred, after map refcnt dropped to 0, so we're not
>>    racing with any other map user to modify its contents.
>
> This I'll need to think on a bit. We have the link-lock there so
> probably should be safe to drop. But will need to trace this through
> git history to be sure.
>

[...]

>> WDYT?
>
> Can you push the fix to bpf but leave the stab->lock for now. I think
> we can do a slightly better cleanup on stab->lock in bpf-next.

Here it is:

https://lore.kernel.org/bpf/20200206111652.694507-1-jakub@cloudflare.com/T/#t

I left the "extra" synchronize_rcu before walking the map. On second
thought, this isn't a bug. Just adds extra wait. bpf-next material?

>
>>
>> Reproducer follows.
>
> push reproducer into selftests?

Included the reproducer with the fixes. If it gets dropped from the
series, I'll resubmit it once bpf-next reopens.
