Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A98145F058
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 16:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378024AbhKZPKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 10:10:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349060AbhKZPIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 10:08:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637939116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IO+C/3rawAgeGRYUtQ56maJ/2k1VmaEzaZ5DWryIbo4=;
        b=ZZzw7QIU/CVITzLZFHWjtY8pUBuJ8uUOmj6keUjGkmG1CvaLmBwReZNAicGcpxVuMNxswt
        SqeI93qYn7VfYAuFVay1dutEuwZw1fSF59em0z1OuYW4opPn7wa0/VxeBqMQlcPKq+pZgv
        oKeLEvh0SM/lFkGkRL2qJjrAyAIyhcc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-y9-J2xE2MbqAQZo_V_JnDg-1; Fri, 26 Nov 2021 10:05:15 -0500
X-MC-Unique: y9-J2xE2MbqAQZo_V_JnDg-1
Received: by mail-ed1-f71.google.com with SMTP id y9-20020aa7c249000000b003e7bf7a1579so8240858edo.5
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 07:05:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IO+C/3rawAgeGRYUtQ56maJ/2k1VmaEzaZ5DWryIbo4=;
        b=qw+AnYpXp3cuCiM4AxhrMC6jJWIlyJKIOb6/OMRVmMLXse1mYNA4agxeHkLmllsnB8
         LQgebqeiEia1X9uTXnbfykvBWkYD0Fp0HRDoDp58cV+eqqr+Oh5w2it/acgD9Tp67aLF
         HlwrC4Ks627eu6maP7R+lsUvosq4CQ2ZQ4FwxeIoZag6xtotLX0I+NmMO+Ee568ElOuU
         sV0yZZwfzrbaWC7X/i8RX6mPQ+rMuno5vYvbfYyOxXUx9lRcpoG3YvyvQ17E09mlcc8k
         4QSzDFvXdAEnzOaGF2e6/UkVHzIEkxIDrHCFegosjLACx4yhX2a4d9Q6dkB9XNA2ybvv
         QUsg==
X-Gm-Message-State: AOAM5322QIfTmwkWQ8AhCoawl1/Gzwds7hYsEiqciQhuZWXy+J4/BdYj
        h4svp5CeCSXOY/xVAdd4wDNm2ciGqFK68uIkUUauQH0y5sKbR7eSK7yqyxb8O6M5Gjnh28OsitJ
        EiljBe8KIy5Tq5qq6
X-Received: by 2002:a17:906:9144:: with SMTP id y4mr37084918ejw.98.1637939112278;
        Fri, 26 Nov 2021 07:05:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyu5JhD5QYxYY97wMXxDlILLc9Sd/EVrcVrtnxbwrgq8e1L+xvbmyAT9IG4w2O0x96lu00tAg==
X-Received: by 2002:a17:906:9144:: with SMTP id y4mr37084826ejw.98.1637939111461;
        Fri, 26 Nov 2021 07:05:11 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-234-118.dyn.eolo.it. [146.241.234.118])
        by smtp.gmail.com with ESMTPSA id z7sm3858302edj.51.2021.11.26.07.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 07:05:11 -0800 (PST)
Message-ID: <169f6a93856664dd4001840081c82f792ae1dc99.camel@redhat.com>
Subject: Re: [PATCH net] tcp: fix page frag corruption on page fault
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Steffen Froemer <sfroemer@redhat.com>
Date:   Fri, 26 Nov 2021 16:05:10 +0100
In-Reply-To: <CANn89iJdg0qFvnykrtGx5OrV3zQTEtm2htTOFtaK-nNwNmOmDA@mail.gmail.com>
References: <d77eb546e29ce24be9ab88c47a66b70c52ce8109.1637923678.git.pabeni@redhat.com>
         <CANn89iJdg0qFvnykrtGx5OrV3zQTEtm2htTOFtaK-nNwNmOmDA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2021-11-26 at 06:18 -0800, Eric Dumazet wrote:
> On Fri, Nov 26, 2021 at 4:00 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > 
> > Steffen reported a TCP stream corruption for HTTP requests
> > served by the apache web-server using a cifs mount-point
> > and memory mapping the relevant file.
> > 
> > The root cause is quite similar to the one addressed by
> > commit 20eb4f29b602 ("net: fix sk_page_frag() recursion from
> > memory reclaim"). Here the nested access to the task page frag
> > is caused by a page fault on the (mmapped) user-space memory
> > buffer coming from the cifs file.
> > 
> > The page fault handler performs an smb transaction on a different
> > socket, inside the same process context. Since sk->sk_allaction
> > for such socket does not prevent the usage for the task_frag,
> > the nested allocation modify "under the hood" the page frag
> > in use by the outer sendmsg call, corrupting the stream.
> > 
> > The overall relevant stack trace looks like the following:
> > 
> > httpd 78268 [001] 3461630.850950:      probe:tcp_sendmsg_locked:
> >         ffffffff91461d91 tcp_sendmsg_locked+0x1
> >         ffffffff91462b57 tcp_sendmsg+0x27
> >         ffffffff9139814e sock_sendmsg+0x3e
> >         ffffffffc06dfe1d smb_send_kvec+0x28
> >         [...]
> >         ffffffffc06cfaf8 cifs_readpages+0x213
> >         ffffffff90e83c4b read_pages+0x6b
> >         ffffffff90e83f31 __do_page_cache_readahead+0x1c1
> >         ffffffff90e79e98 filemap_fault+0x788
> >         ffffffff90eb0458 __do_fault+0x38
> >         ffffffff90eb5280 do_fault+0x1a0
> >         ffffffff90eb7c84 __handle_mm_fault+0x4d4
> >         ffffffff90eb8093 handle_mm_fault+0xc3
> >         ffffffff90c74f6d __do_page_fault+0x1ed
> >         ffffffff90c75277 do_page_fault+0x37
> >         ffffffff9160111e page_fault+0x1e
> >         ffffffff9109e7b5 copyin+0x25
> >         ffffffff9109eb40 _copy_from_iter_full+0xe0
> >         ffffffff91462370 tcp_sendmsg_locked+0x5e0
> >         ffffffff91462370 tcp_sendmsg_locked+0x5e0
> >         ffffffff91462b57 tcp_sendmsg+0x27
> >         ffffffff9139815c sock_sendmsg+0x4c
> >         ffffffff913981f7 sock_write_iter+0x97
> >         ffffffff90f2cc56 do_iter_readv_writev+0x156
> >         ffffffff90f2dff0 do_iter_write+0x80
> >         ffffffff90f2e1c3 vfs_writev+0xa3
> >         ffffffff90f2e27c do_writev+0x5c
> >         ffffffff90c042bb do_syscall_64+0x5b
> >         ffffffff916000ad entry_SYSCALL_64_after_hwframe+0x65
> > 
> > A possible solution would be adding the __GFP_MEMALLOC flag
> > to the cifs allocation. That looks dangerous, as the memory
> > allocated by the cifs fs will not be free soon and such
> > allocation will not allow for more memory to be freed.
> > 
> > Instead, this patch changes the tcp_sendmsg() code to avoid
> > touching the page frag after performing the copy from the
> > user-space buffer. Any page fault or memory reclaim operation
> > there is now free to touch the task page fragment without
> > corrupting the state used by the outer sendmsg().
> > 
> > As a downside, if the user-space copy fails, there will be
> > some additional atomic operations due to the reference counting
> > on the faulty fragment, but that looks acceptable for a slow
> > error path.
> > 
> > Reported-by: Steffen Froemer <sfroemer@redhat.com>
> > Fixes: 5640f7685831 ("net: use a per task frag allocator")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> >  net/ipv4/tcp.c | 20 ++++++++++++--------
> >  1 file changed, 12 insertions(+), 8 deletions(-)
> > 
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index bbb3d39c69af..2d85636c1577 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -1304,6 +1304,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
> >                         bool merge = true;
> >                         int i = skb_shinfo(skb)->nr_frags;
> >                         struct page_frag *pfrag = sk_page_frag(sk);
> > +                       unsigned int offset;
> > 
> >                         if (!sk_page_frag_refill(sk, pfrag))
> >                                 goto wait_for_space;
> > @@ -1331,14 +1332,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
> >                         if (!sk_wmem_schedule(sk, copy))
> >                                 goto wait_for_space;
> > 
> > -                       err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
> > -                                                      pfrag->page,
> > -                                                      pfrag->offset,
> > -                                                      copy);
> > -                       if (err)
> > -                               goto do_error;
> > -
> > -                       /* Update the skb. */
> > +                       /* Update the skb before accessing the user space buffer
> > +                        * so that we leave the task frag in a consistent state.
> > +                        * Just in case the page_fault handler need to use it
> > +                        */
> > +                       offset = pfrag->offset;
> >                         if (merge) {
> >                                 skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
> >                         } else {
> > @@ -1347,6 +1345,12 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
> >                                 page_ref_inc(pfrag->page);
> >                         }
> >                         pfrag->offset += copy;
> > +
> > +                       err = skb_copy_to_page_nocache(sk, &msg->msg_iter, skb,
> > +                                                      pfrag->page,
> > +                                                      offset, copy);
> > +                       if (err)
> > +                               goto do_error;
> >                 } else {
> >                         /* First append to a fragless skb builds initial
> >                          * pure zerocopy skb
> > --
> > 2.33.1
> > 
> 
> This patch is completely wrong, you just horribly broke TCP.

Double checking I understood correctly: the problem is that in case of
skb_copy_to_page_nocache() error, if the skb is not empty, random data
will be introduced into the TCP stream, or something else/more? I
obviously did not see that before the submission, nor tests cached it,
sorry.

> Please investigate CIFS and gfpflags_normal_context() tandem to fix
> this issue instead.

Do you mean changing gfpflags_normal_context() definition so that cifs
allocation are excluded? Something alike the following should do:

---
diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index b976c4177299..f9286aeeded5 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -379,8 +379,8 @@ static inline bool gfpflags_allow_blocking(const gfp_t gfp_flags)
  */
 static inline bool gfpflags_normal_context(const gfp_t gfp_flags)
 {
-       return (gfp_flags & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC)) ==
-               __GFP_DIRECT_RECLAIM;
+       return (gfp_flags & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC | __GFP_FS)) ==
+               (__GFP_DIRECT_RECLAIM | __GFP_FS);
 }
---
If so there is a caveat: dlm is currently using
gfpflags_normal_context() - apparently to check for non blocking
context. If I'll change gfpflags_normal_context() definition I likely
will have to replace gfpflags_normal_context() with
gfpflags_allow_blocking() in dlm.

In that case the relevant patch should touch both the mm and the fs
subsystem. In that case I guess I should go via the fs tree first and
the via mm?

Thanks!

Paolo

