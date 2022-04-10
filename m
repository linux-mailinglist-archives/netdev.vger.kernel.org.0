Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23CA4FADAE
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 13:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbiDJLjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 07:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiDJLjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 07:39:43 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6A163537
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 04:37:33 -0700 (PDT)
Received: from fsav117.sakura.ne.jp (fsav117.sakura.ne.jp [27.133.134.244])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 23ABa5c3091954;
        Sun, 10 Apr 2022 20:36:05 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav117.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav117.sakura.ne.jp);
 Sun, 10 Apr 2022 20:36:05 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav117.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 23ABa51S091951
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 10 Apr 2022 20:36:05 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <78cdbf25-4511-a567-bb09-0c07edae8b50@I-love.SAKURA.ne.jp>
Date:   Sun, 10 Apr 2022 20:36:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [syzbot] KASAN: use-after-free Read in tcp_retransmit_timer (5)
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
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
References: <00000000000045dc96059f4d7b02@google.com>
 <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
 <CANn89i+wAtSy0aajXqbZBgAh+M4_-t7mDb9TfqQTRG3aHQkmrQ@mail.gmail.com>
 <CANn89i+484ffqb93aQm1N-tjxxvb3WDKX0EbD7318RwRgsatjw@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CANn89i+484ffqb93aQm1N-tjxxvb3WDKX0EbD7318RwRgsatjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/04/10 2:47, Eric Dumazet wrote:
> So please add to your tree the NFS fix:
> 
> commit f00432063db1a0db484e85193eccc6845435b80e
> Author: Trond Myklebust <trond.myklebust@hammerspace.com>
> Date:   Sun Apr 3 15:58:11 2022 -0400
> 
>     SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()

OK. Since the socket is sk->sk_net_refcnt=0, adding

> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e31cf137c6140f76f838b4a0dcddf9f104ad653b..3dacd202bf2af43c55ffe820c08316150d2018ea
> 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2928,6 +2928,8 @@ void tcp_close(struct sock *sk, long timeout)
>         lock_sock(sk);
>         __tcp_close(sk, timeout);
>         release_sock(sk);
> +       if (!sk->sk_net_refcnt)
> +               inet_csk_clear_xmit_timers_sync(sk);
>         sock_put(sk);
>  }
>  EXPORT_SYMBOL(tcp_close);

part indeed helped avoiding use-after-free increment on sock_net(sk).
But it seems to me that __sk_destruct() is forever not called.

----------------------------------------
[   93.024086][    C1] sock: sk_clone_lock(): sk=ffff888110328000 net=ffff88810efb8000 sk->sk_family=10 sk->sk_net_refcnt=0 refcount_read(&net->ns.count)=2
[   93.030257][    C1] sock: sk_clone_lock(): newsk=ffff888110350000 net=ffff88810efb8000 newsk->sk_family=10 newsk->sk_net_refcnt=0 refcount_read(&net->ns.count)=2
(...snipped...)
[   93.170750][  T740] TCP: Calling inet_csk_clear_xmit_timers_sync() on sock=ffff888110350000
(...snipped...)
[  214.272450][    T8] TCP: Calling inet_csk_clear_xmit_timers_sync() on sock=ffff888110328000
(...snipped...)
[  214.358528][    C3] sock: __sk_destruct(): sk=ffff888110328000 family=10 net=ffff88810efb8000 sk->sk_net_refcnt=0
----------------------------------------

If I do

-		inet_csk_clear_xmit_timers_sync(sk);
+		write_pnet(&sk->sk_net, &init_net);

in this patch (i.e. just avoid use-after-free access), __sk_destruct() is called when timer fires.

----------------------------------------
[   81.969884][    C0] sock: sk_clone_lock(): sk=ffff8880156f8000 net=ffff8881030d8000 sk->sk_family=10 sk->sk_net_refcnt=0 refcount_read(&net->ns.count)=2
[   81.975329][    C0] sock: sk_clone_lock(): newsk=ffff8880156f8c40 net=ffff8881030d8000 newsk->sk_family=10 newsk->sk_net_refcnt=0 refcount_read(&net->ns.count)=2
(...snipped...)
[   82.078152][  T735] TCP: Resetting sk->sk_net on sock=ffff8880156f8c40
(...snipped...)
[  203.937701][  T735] TCP: Resetting sk->sk_net on sock=ffff8880156f8000
(...snipped...)
[  204.042570][    C1] sock: __sk_destruct(): sk=ffff8880156f8000 family=10 net=ffffffff84588cc0 sk->sk_net_refcnt=0
(...snipped...)
[  214.124851][    C1] sock: __sk_destruct(): sk=ffff8880156f8c40 family=10 net=ffffffff84588cc0 sk->sk_net_refcnt=0
----------------------------------------

Therefore, I guess that this patch is missing something here.

