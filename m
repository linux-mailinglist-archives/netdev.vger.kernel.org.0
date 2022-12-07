Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF29645545
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 09:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiLGINS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 03:13:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLGINP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 03:13:15 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC4231FBB
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 00:13:12 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id 189so21714276ybe.8
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 00:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9PwBs2OW6KV67ZD6N5qY5Z5ZOtyNNcvY0UpEdencGE=;
        b=YvoabhEN5LkAlnAsj7FwPTX3hCLmWY46IgIkXkXbBLJzjwSepXsWfZFLj6pY8g6C63
         PQsgbo5hbcEG9ffKMMMalFfu70ZsB+x3oAZA1HYrQtSmB/1T6mydnloFZfQvknM99heQ
         tT2z487cne4nZ5KkxSWi11IWyeJBWFUCF5ZZd3utLKyBMYmhDAn41LLBY8+zWOJh/PL2
         U0MODsrglmbnb6z1EILfAjO7urtuBzcmupKyIDCHUtph2j3Vv/5/lpAscyf6uXEy8VeJ
         vQUhXYaOEqg3qnkjnHOzg491BRk9NY92NIzAlfUfeU/Dt5CHUK9iMKiJYhwg/3ubln0c
         0gSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q9PwBs2OW6KV67ZD6N5qY5Z5ZOtyNNcvY0UpEdencGE=;
        b=U7yVs8kav0IDULk5FvngVmBCvaHOGdAP8zM8ylbXzzxpf6zTu6srbsuZFoFMudEWKU
         qOq4NPo+lo14IwADnywd9D7/XZGSDh0o04WU5Bua2ha+yBjfYulRQdjmkI2y1VzmVaVF
         //tfH1u91PnPy46/N9qmBf1azGCgrFmoh9M6t0Oy3+QNZxtNfq5cuIc+yWkc+jLdGKbN
         PiJ0SO01aV+OUef6uF8umlE8dBo2SHEP4PY8kLdZJUaqaK0+Wg/ellQrLA34WQlPhH9P
         a6Jv1h9xgD7WzEDMTDPi6E97ucKiuTpIAlgTLZTHlFa5xGTCr0IVzluHCQ1o9tczc+kt
         dWsg==
X-Gm-Message-State: ANoB5pkaEiHSgWGIYliN43sl8nfaYWTZdIxx6YE+l3M4wvY0Oa9idnuL
        LfhCUZOsS965neaQHcta3pnjit4A14pnYG2AwysFog==
X-Google-Smtp-Source: AA0mqf60uLxT8YTLpBIXQE3IHpdSFumG4AgCRXD/7v6KrWZDTPRMYpjKDtwszvVrwSJB+SiUy1iAwHu+5U4PJc9XZqM=
X-Received: by 2002:a25:24d:0:b0:6fd:2917:cf60 with SMTP id
 74-20020a25024d000000b006fd2917cf60mr20430226ybc.427.1670400791161; Wed, 07
 Dec 2022 00:13:11 -0800 (PST)
MIME-Version: 1.0
References: <00000000000073b14905ef2e7401@google.com> <639034dda7f92_bb36208f5@john.notmuch>
In-Reply-To: <639034dda7f92_bb36208f5@john.notmuch>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 7 Dec 2022 09:12:59 +0100
Message-ID: <CANn89iK2UN1FmdUcH12fv_xiZkv2G+Nskvmq7fG6aA_6VKRf6g@mail.gmail.com>
Subject: Re: [syzbot] BUG: stack guard page was hit in inet6_release
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     syzbot <syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com>,
        bpf@vger.kernel.org, davem@davemloft.net, jakub@cloudflare.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 7:38 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    6a30d3e3491d selftests: net: Use "grep -E" instead of "egr..
> > git tree:       net
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=1576b11d880000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=cc4b2e0a8e8a8366
> > dashboard link: https://syzkaller.appspot.com/bug?extid=04c21ed96d861dccc5cd
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e1656b880000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1077da23880000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/bbee3d5fc908/disk-6a30d3e3.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/bf9e258de70e/vmlinux-6a30d3e3.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/afaa6696b9e0/bzImage-6a30d3e3.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+04c21ed96d861dccc5cd@syzkaller.appspotmail.com
> >
> > BUG: TASK stack guard page was hit at ffffc90003cd7fa8 (stack is ffffc90003cd8000..ffffc90003ce0000)
> > stack guard page: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 0 PID: 3636 Comm: syz-executor238 Not tainted 6.1.0-rc7-syzkaller-00135-g6a30d3e3491d #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> > RIP: 0010:mark_lock.part.0+0x26/0x1910 kernel/locking/lockdep.c:4593
> > Code: 00 00 00 00 41 57 41 56 41 55 41 89 d5 48 ba 00 00 00 00 00 fc ff df 41 54 49 89 f4 55 53 48 81 ec 38 01 00 00 48 8d 5c 24 38 <48> 89 3c 24 48 c7 44 24 38 b3 8a b5 41 48 c1 eb 03 48 c7 44 24 40
> > RSP: 0018:ffffc90003cd7fb8 EFLAGS: 00010096
> > RAX: 0000000000000004 RBX: ffffc90003cd7ff0 RCX: ffffffff8162a7bf
> > RDX: dffffc0000000000 RSI: ffff88801f65e238 RDI: ffff88801f65d7c0
> > RBP: ffff88801f65e25a R08: 0000000000000000 R09: ffffffff910f4aff
> > R10: fffffbfff221e95f R11: 0000000000000000 R12: ffff88801f65e238
> > R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000040000
> > FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffffc90003cd7fa8 CR3: 000000000c28e000 CR4: 00000000003506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  mark_lock kernel/locking/lockdep.c:4598 [inline]
> >  mark_usage kernel/locking/lockdep.c:4543 [inline]
> >  __lock_acquire+0x847/0x56d0 kernel/locking/lockdep.c:5009
> >  lock_acquire kernel/locking/lockdep.c:5668 [inline]
> >  lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
> >  lock_sock_nested+0x3a/0xf0 net/core/sock.c:3447
> >  lock_sock include/net/sock.h:1721 [inline]
> >  sock_map_close+0x75/0x7b0 net/core/sock_map.c:1610
>
> I'll take a look likely something recent.

Fact that sock_map_close  can call itself seems risky.
We might issue a one time warning and keep the host alive.

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 81beb16ab1ebfcb166f51f89a029fe1c28a629a4..a79771a6627b9b2f38ae6ce153ceff9e8c0be8d4
100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1612,17 +1612,25 @@ void sock_map_close(struct sock *sk, long timeout)
        psock = sk_psock_get(sk);
        if (unlikely(!psock)) {
                rcu_read_unlock();
+               saved_close = sk->sk_prot->close;
                release_sock(sk);
-               return sk->sk_prot->close(sk, timeout);
+       } else {
+               saved_close = psock->saved_close;
+               sock_map_remove_links(sk, psock);
+               rcu_read_unlock();
+               sk_psock_stop(psock);
+               release_sock(sk);
+               cancel_work_sync(&psock->work);
+               sk_psock_put(sk, psock);
+       }
+       /* Make sure we do not recurse to us.
+        * This is a bug, we can leak the socket instead
+        * of crashing on a stack overflow.
+        */
+       if (saved_close == sock_map_close) {
+               WARN_ON_ONCE(1);
+               return;
        }
-
-       saved_close = psock->saved_close;
-       sock_map_remove_links(sk, psock);
-       rcu_read_unlock();
-       sk_psock_stop(psock);
-       release_sock(sk);
-       cancel_work_sync(&psock->work);
-       sk_psock_put(sk, psock);
        saved_close(sk, timeout);
 }
 EXPORT_SYMBOL_GPL(sock_map_close);
