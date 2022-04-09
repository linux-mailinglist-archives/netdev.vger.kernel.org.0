Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0064FA9FD
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 19:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242930AbiDIRtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 13:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242928AbiDIRtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 13:49:21 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86C01959D7
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 10:47:12 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id w134so20413167ybe.10
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 10:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qI4armxGzDReIwGljpwLgpJQ3FDL2p9Wo1aUPWtF/cw=;
        b=LGLhbljB34RXaRgmUgmfdIC3R9quwR8tPWlvxsB3Ho24otdS4JsDhiVNQONtLRWsKR
         Fl7J7/D8KkWKgu7U4GdZyTSuwuq7JItSpmEVtIoPMBjFMdilEXki6zrAoEELvcveOTZq
         61dUxQE0ts6z53ZS6kPxPDBSs/llSlma9HpcROpsY2Vbyo4m5O+c680FCD9fB9qFMdiV
         9vGhTCeTuywV0CgH2z5XdzMaDrDM3f91q8AJetKbbTrAI7DuojR7L1AM9R0KmNOgclnY
         BfXDudSuN145h2dlod4i8A0z+kvwdjYZ3ROCx5OIro7JNwRwjDoUKdCrKRFne4sr0ou2
         k4RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qI4armxGzDReIwGljpwLgpJQ3FDL2p9Wo1aUPWtF/cw=;
        b=7vNAlcX06VYsTpVjTjGjnQIRlSLPru43AlIIq9gcCY5q/2IfyVTlEfh+AaHhrFjBDL
         8e4FHPrYxgro1R4r2tYYGrfQ59xxgwj4IhP+7hAfFwPl0lerrIDG+cUK5+H1rU3hs/XU
         LpbI0pJNkpjVa4OE1LZjQjmqkuuF9r1nW4LfvJ5Som0fvOTtJsTGtrnPSM5R4XP4xq3j
         ptyvBpou+rwnTJxgYm51wsTZ9Unepyhq1DasanAAeW+fhFwrMcp1zfC2NjtR6AtZCHby
         qCSXDfjhntCCaukVOXZCoBdo1bLFQUAdbnlym3K6DxBAskiPYsH9BbZHleu8YZqptk8n
         jD5A==
X-Gm-Message-State: AOAM532qnzuUIcIgeOqB7ug9KeyZuGUDvAyB7dMD2JOVagUsZYMrKBUu
        S9fM3L44xCCR3P2+oPhOWYYC7XyNmf7G13FslYKNtQ==
X-Google-Smtp-Source: ABdhPJwH59LLCiZ74DA9bXeOfEA99kSzoOjLB9CY3Icu1lCe4Sxi8Xc7+T6I/PQ65SzP57zksFbH/2q/1eWYwarfunA=
X-Received: by 2002:a25:8382:0:b0:63d:6201:fa73 with SMTP id
 t2-20020a258382000000b0063d6201fa73mr16933933ybk.55.1649526431506; Sat, 09
 Apr 2022 10:47:11 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000045dc96059f4d7b02@google.com> <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp> <CANn89i+wAtSy0aajXqbZBgAh+M4_-t7mDb9TfqQTRG3aHQkmrQ@mail.gmail.com>
In-Reply-To: <CANn89i+wAtSy0aajXqbZBgAh+M4_-t7mDb9TfqQTRG3aHQkmrQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 9 Apr 2022 10:47:00 -0700
Message-ID: <CANn89i+484ffqb93aQm1N-tjxxvb3WDKX0EbD7318RwRgsatjw@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in tcp_retransmit_timer (5)
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     bpf <bpf@vger.kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tpa@hlghospital.com, Yonghong Song <yhs@fb.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Trond Myklebust <trondmy@hammerspace.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 9, 2022 at 9:46 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Apr 9, 2022 at 1:19 AM Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> >
> > Hello, bpf developers.
> >
> > syzbot is reporting use-after-free increment at __NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPTIMEOUTS).
>
>
> Try removing NFS from your kernel .config ? If your repro still works,
> then another user of kernel TCP socket needs some care.
>
> NFS maintainers and other folks are already working on fixing this issue,
> which is partly caused by fs/file_table.c being able to delay fput(),
> look at code in fput_many()
>
> Kernel TCP sockets are tricky, they (for good reasons) do not take a
> reference on the net namespace.
>
> This also means that users of such sockets need to make sure the
> various tcp timers have been completed,
> as sk_stop_timer() is not using del_timer_sync()
>
> Even after a synchronous fput(), there is no guarantee that another
> cpu is not running some of the socket timers functions.

So please add to your tree the NFS fix:

commit f00432063db1a0db484e85193eccc6845435b80e
Author: Trond Myklebust <trond.myklebust@hammerspace.com>
Date:   Sun Apr 3 15:58:11 2022 -0400

    SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()

    We must ensure that all sockets are closed before we call xprt_free()
    and release the reference to the net namespace. The problem is that
    calling fput() will defer closing the socket until delayed_fput() gets
    called.
    Let's fix the situation by allowing rpciod and the transport teardown
    code (which runs on the system wq) to call __fput_sync(), and directly
    close the socket.

    Reported-by: Felix Fu <foyjog@gmail.com>
    Acked-by: Al Viro <viro@zeniv.linux.org.uk>
    Fixes: a73881c96d73 ("SUNRPC: Fix an Oops in udp_poll()")
    Cc: stable@vger.kernel.org # 5.1.x: 3be232f11a3c: SUNRPC: Prevent
immediate close+reconnect
    Cc: stable@vger.kernel.org # 5.1.x: 89f42494f92f: SUNRPC: Don't
call connect() more than once on a TCP socket
    Cc: stable@vger.kernel.org # 5.1.x
    Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>

Then on top of that, add the following fix (I will formally submit
this one once back to work, Monday morning)

diff --git a/include/net/inet_connection_sock.h
b/include/net/inet_connection_sock.h
index 3908296d103fd2de9284adea64dba94fe6b8720f..e2c856ae4fdbef5bd3c7728e376786b804e2d4f1
100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -171,6 +171,7 @@ void inet_csk_init_xmit_timers(struct sock *sk,
                               void (*delack_handler)(struct timer_list *),
                               void (*keepalive_handler)(struct timer_list *));
 void inet_csk_clear_xmit_timers(struct sock *sk);
+void inet_csk_clear_xmit_timers_sync(struct sock *sk);

 static inline void inet_csk_schedule_ack(struct sock *sk)
 {
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 1e5b53c2bb2670fc90b789e853458f5c86a00c27..aab83b766014d0a091a73bdc13376d9cdae99b27
100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -581,6 +581,17 @@ void inet_csk_clear_xmit_timers(struct sock *sk)
 }
 EXPORT_SYMBOL(inet_csk_clear_xmit_timers);

+void inet_csk_clear_xmit_timers_sync(struct sock *sk)
+{
+       struct inet_connection_sock *icsk = inet_csk(sk);
+
+       icsk->icsk_pending = icsk->icsk_ack.pending = 0;
+
+       sk_stop_timer_sync(sk, &icsk->icsk_retransmit_timer);
+       sk_stop_timer_sync(sk, &icsk->icsk_delack_timer);
+       sk_stop_timer_sync(sk, &sk->sk_timer);
+}
+
 void inet_csk_delete_keepalive_timer(struct sock *sk)
 {
        sk_stop_timer(sk, &sk->sk_timer);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e31cf137c6140f76f838b4a0dcddf9f104ad653b..3dacd202bf2af43c55ffe820c08316150d2018ea
100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2928,6 +2928,8 @@ void tcp_close(struct sock *sk, long timeout)
        lock_sock(sk);
        __tcp_close(sk, timeout);
        release_sock(sk);
+       if (!sk->sk_net_refcnt)
+               inet_csk_clear_xmit_timers_sync(sk);
        sock_put(sk);
 }
 EXPORT_SYMBOL(tcp_close);
