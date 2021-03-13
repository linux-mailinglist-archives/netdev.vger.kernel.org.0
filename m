Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED769339F85
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 18:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbhCMRcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 12:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbhCMRc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 12:32:29 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099FBC061574;
        Sat, 13 Mar 2021 09:32:29 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id e2so8114244pld.9;
        Sat, 13 Mar 2021 09:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+U3v67ZcAJvdEJUggEAgpmcaOAsRI2kJ9FS0FPxtlAE=;
        b=ps+P2/Pynal3tUPeUkjTQxrLiNycs7ufr6o02gudwuVnu8I2MOG5BihBN35HKzLmls
         VZmgx2Dy70DfNYGmSQBzg4NM4S7XCqIqzxPwDWSQqDMo7atlNVO1ypzOuKNy1TNwwM/f
         o4/H58+udyDaAtDHSld7AKPOw0ZknXOvKQb1ab6EKxGMrrGBNzwiVJdeVjqwsVIZkeVT
         sLaaNx7+PAJizWxI7k65vlYGyF3uuexN4RDvdFJALdihVsEbkbh9XtyVuLfDp72w7JxJ
         6gV7WJh1uE4KoPW5sDikYDvxfT88YJJ4hhvohctXlS1h/EH3lj3LQDP6UEfrBI29ytVA
         c0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+U3v67ZcAJvdEJUggEAgpmcaOAsRI2kJ9FS0FPxtlAE=;
        b=AEyTrC84PVMfSveQpUZHRW7b5OiNIm49UHhlKLGMwTyp7L7LLlS7fHKUGoZPi2+bYY
         xTQP6WUuKnctnsjxglXunjuCea879KDKPZT4crFPTwCxYRmZ6qxJFRDomfj9Bxcs9aEA
         3Gtk53soNlgyrTyUCV+sd/tvjmK4EM/g0RCeJ8buGBqicoiMeOmSy33+PG+ZDxxfFQSX
         2FJWa9UzmWIUCyTJbcoqMRsDfwkwQBTQgr8kMtzZWiFdmYqx1OhT8aDbLCJq2Vv5AR3+
         pPdmzzFApMHs2QN6zV9FYQYoFB8J6B/wfbw4CZ5AaBiBIsMSiNhBpZEkUwxTP9OVvh0P
         olCg==
X-Gm-Message-State: AOAM5330K0cNyA/JCQrVzAvfHGb9ZJe+5OpbvEYeeJfe/lyS8ZxMYAnV
        ur2g4oMaExHCZHweENHGHgZ11JWLRjTwF27MSJRp5CpXCSDj1A==
X-Google-Smtp-Source: ABdhPJyMRUD342QPg9Kn2MbF/oXsQ4fGcSnyoQSx5PIrAgky0lwVtNSRwd/AY47oBJKnImoBimjc/dsAPUXtuvTciBU=
X-Received: by 2002:a17:90a:9f8c:: with SMTP id o12mr4489047pjp.215.1615656748545;
 Sat, 13 Mar 2021 09:32:28 -0800 (PST)
MIME-Version: 1.0
References: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
 <20210310053222.41371-5-xiyou.wangcong@gmail.com> <87y2es37i3.fsf@cloudflare.com>
In-Reply-To: <87y2es37i3.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 13 Mar 2021 09:32:17 -0800
Message-ID: <CAM_iQpVmtHPqzGHEUPhtVroxCeWSBvahKMrbLrEq4gNNVGq2zg@mail.gmail.com>
Subject: Re: [Patch bpf-next v4 04/11] skmsg: avoid lock_sock() in sk_psock_backlog()
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 12, 2021 at 4:02 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Wed, Mar 10, 2021 at 06:32 AM CET, Cong Wang wrote:
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index dd53a7771d7e..26ba47b099f1 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -1540,6 +1540,7 @@ void sock_map_close(struct sock *sk, long timeout)
> >       saved_close = psock->saved_close;
> >       sock_map_remove_links(sk, psock);
> >       rcu_read_unlock();
> > +     sk_psock_purge(psock);
> >       release_sock(sk);
> >       saved_close(sk, timeout);
> >  }
>
> Nothing stops sk_psock_backlog from running after sk_psock_purge:
>
>
> CPU 1                                                   CPU 2
>
> sk_psock_skb_redirect()
>   sk_psock(sk_other)
>   sock_flag(sk_other, SOCK_DEAD)
>   sk_psock_test_state(psock_other,
>                       SK_PSOCK_TX_ENABLED)
>                                                         sk_psock_purge()
>   skb_queue_tail(&psock_other->ingress_skb, skb)
>   schedule_work(&psock_other->work)
>
>
> And sock_orphan can run while we're in sendmsg/sendpage_unlocked:
>
>
> CPU 1                                                   CPU 2
>
> sk_psock_backlog
>   ...
>   sendmsg_unlocked
>     sock = sk->sk_socket
>                                                         tcp_close
>                                                           __tcp_close
>                                                             sock_orphan
>     kernel_sendmsg(sock, msg, vec, num, size)
>
>
> So, after this change, without lock_sock in sk_psock_backlog, we will
> not block tcp_close from running.
>
> This makes me think that the process socket can get released from under
> us, before kernel_sendmsg/sendpage runs.

I think you are right, I thought socket is orphaned in inet_release(), clearly
I was wrong. But, I'd argue in the above scenario, the packet should not
be even queued in the first place, as SK_PSOCK_TX_ENABLED is going
to be cleared, so I think the right fix is probably to make clearing psock
state and queuing the packet under a spinlock.

Thanks.
