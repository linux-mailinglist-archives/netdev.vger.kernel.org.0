Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19DA53082F
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 06:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242056AbiEWECo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 00:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231687AbiEWECl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 00:02:41 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A3C101C7
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 21:02:40 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id jx22so12615324ejb.12
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 21:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LKAJkiWmW+IPGP1bXDKaiFUYpV46xzegx9oR3356eFs=;
        b=gVnl8EntcpMgwE29/c+bjMIurGfrhaKvHuVgNwokXlHj8f0HpRtVO2iTuf2t84JtcC
         4T8IWNKbLcn4nS8C8o54KCWd2cK+9MGM+jMuIbj4JCyR7HUtw+Hfe5LSZl4Mo/IfVzMY
         D4Ai8Dmf6YrLPSwpNE0xjpX1Lrp517SuOajXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LKAJkiWmW+IPGP1bXDKaiFUYpV46xzegx9oR3356eFs=;
        b=3Xx70EHpZA0PmTWZLQmfxrrq8xlWLv0Kt99XxOAjjk2u5ACVE0/I77Y0ZAA/DGbK36
         otTwFmeSqSrwK1T9OXUd4zFK2wZZ/YQMdfxFgpjjsWAvneRusoWdTXhgU/j6xEuR6UQA
         AegMFhhtsh8LJ6DURWj6vDZhxSm8oCsCdFIK00ZvvN0UMpTEejiSL2mJ/mNeNdH12nPv
         q1ihP3NjztkJDjFhymBzD+aTOu8F7cokqOaRMznnbuZLlaKF0N2guXrG5euPOwbBRL35
         qr0jJ/nKf5KJyGKAyjP1qwFlNmalc6VSY8wonGVUChUrz/Kh4OaozzFQ86j4i7fuRJiF
         9yPQ==
X-Gm-Message-State: AOAM533j6MHPgoZjSVwB+a8klJs1F9ax42GraHgtB8zpTSXsqdy+r1Ml
        IqKueDUlO3bnW3DsXM44bIPkPEzXruqbF6e4
X-Google-Smtp-Source: ABdhPJzXxCpRJJF6j8VLxArhnxhy5HeFt0sHdRpqDeycd7vsIYmIUmfNy01rpDPJUsrm1V/1nswHwQ==
X-Received: by 2002:a17:907:948e:b0:6fe:27b:bc8f with SMTP id dm14-20020a170907948e00b006fe027bbc8fmr18176489ejc.715.1653278558643;
        Sun, 22 May 2022 21:02:38 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id cq3-20020a056402220300b0042617ba63c2sm7704403edb.76.2022.05.22.21.02.38
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 21:02:38 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id q21so5869515ejm.1
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 21:02:38 -0700 (PDT)
X-Received: by 2002:a5d:5484:0:b0:20f:bf64:cae1 with SMTP id
 h4-20020a5d5484000000b0020fbf64cae1mr10390593wrv.281.1653278194596; Sun, 22
 May 2022 20:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c1925305ac997812@google.com> <000000000000b6b4eb05dfa1b325@google.com>
In-Reply-To: <000000000000b6b4eb05dfa1b325@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 22 May 2022 20:56:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=whH5pmgyzE6+6C==p2VQFUgGiPhSwX=R2zKs+iHZuX7_A@mail.gmail.com>
Message-ID: <CAHk-=whH5pmgyzE6+6C==p2VQFUgGiPhSwX=R2zKs+iHZuX7_A@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in corrupted (4)
To:     syzbot <syzbot+48135e34de22e3a82c99@syzkaller.appspotmail.com>
Cc:     applications@thinkbigglobal.in, David Miller <davem@davemloft.net>,
        gustavo@padovan.org, Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Ingo Molnar <mingo@redhat.com>, Michal Marek <mmarek@suse.com>,
        Netdev <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 22, 2022 at 4:01 PM syzbot
<syzbot+48135e34de22e3a82c99@syzkaller.appspotmail.com> wrote:
>
> The issue was bisected to:
>
> commit c470abd4fde40ea6a0846a2beab642a578c0b8cd
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Feb 19 22:34:00 2017 +0000
>
>     Linux 4.10

Heh. That looks very unlikely, so the bisection seems to sadly have
failed at some point.

At least one of the KASAN reports (that "final oops") does look very
much like the bug fixed by commit 1bff51ea59a9 ("Bluetooth: fix
use-after-free error in lock_sock_nested()"), so this may already be
fixed, but who knows...

But that "update Makefile to 4.10" is not the cause...

               Linus
