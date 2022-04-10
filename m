Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B914FAB36
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 02:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbiDJAlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 20:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiDJAlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 20:41:50 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C491611A03
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 17:39:41 -0700 (PDT)
Received: from fsav118.sakura.ne.jp (fsav118.sakura.ne.jp [27.133.134.245])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 23A0cF5K072417;
        Sun, 10 Apr 2022 09:38:15 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav118.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp);
 Sun, 10 Apr 2022 09:38:15 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav118.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 23A0cF8h072414
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 10 Apr 2022 09:38:15 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <af8a3cc6-ee2f-f1ab-ee78-8e5988a9a2f8@I-love.SAKURA.ne.jp>
Date:   Sun, 10 Apr 2022 09:38:12 +0900
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
 <CANn89i+rkip6uQ2SySspG+3WX6mR-CTHbQFLw1qUo4G4W5cn8g@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CANn89i+rkip6uQ2SySspG+3WX6mR-CTHbQFLw1qUo4G4W5cn8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/04/10 1:46, Eric Dumazet wrote:
> Try removing NFS from your kernel .config ? If your repro still works,
> then another user of kernel TCP socket needs some care.

Since my .config is CONFIG_NETWORK_FILESYSTEMS=n, NFS is irrelevant.

On 2022/04/10 2:47, Eric Dumazet wrote:
> So please add to your tree the NFS fix:
> 
> commit f00432063db1a0db484e85193eccc6845435b80e
> Author: Trond Myklebust <trond.myklebust@hammerspace.com>
> Date:   Sun Apr 3 15:58:11 2022 -0400
> 
>     SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()

Since CONFIG_SUNRPC depends on CONFIG_NETWORK_FILESYSTEMS=y,
this NFS fix will be also irrelevant.

On 2022/04/10 2:55, Eric Dumazet wrote:
> Side note: We will probably be able to revert this patch, that perhaps
> was working around the real issue.
> 
> commit 4ee806d51176ba7b8ff1efd81f271d7252e03a1d
> Author: Dan Streetman <ddstreet@ieee.org>
> Date:   Thu Jan 18 16:14:26 2018 -0500
> 
>     net: tcp: close sock if net namespace is exiting

I uploaded my .config at https://I-love.SAKURA.ne.jp/tmp/config-5.17
so that you can try this reproducer using my .config file.

I haven't identified where the socket

[  260.295512][    C0] BUG: Trying to access destroyed net=ffff888036278000 sk=ffff88800e2d8000
[  260.301941][    C0] sk->sk_family=10 sk->sk_prot_creator->name=TCPv6 sk->sk_state=11 sk->sk_flags=0x30b net->ns.count=0

came from. Can you identify the location?

