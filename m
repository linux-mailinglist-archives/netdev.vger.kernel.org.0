Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F4A55725A
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiFWEur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbiFWEsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 00:48:54 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6DE45538
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:42:34 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id q132so236394ybg.10
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 21:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4iW6SQbrl4tK6SGKbb60gU7a3SBpPlo+vf+kq4WldJo=;
        b=OSdxExzR8fmlbbHIyQ4TdsUziOKviIq19CVD5M0eSB9BD1Rh8B4qOPvtw1fCgMATfe
         PPznvkdib+rPEyjvH1LpwQHil0U35M+8lXdQRjaY3l0QGr/8Xdv9oiXZ5P3VA1sEuJwm
         st94p729nzb3hM5IjOBiXFjVsRsZIXwu0o/P7l9F9mbOmXleVfdodBeWzNd0X5DeQPRd
         T5wS662rv/dbOJVB/Kg9zKVHu6WPYDSH92NHsMc/2Z+9bpLOCBHU0/IqLNAvYz5ydggq
         Zz801BZZYsYlduB2bDQIu6jyH0CiDGEM4kwUqwoAQiGJ44EjcBM8I55FExN977nz0Pax
         o9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4iW6SQbrl4tK6SGKbb60gU7a3SBpPlo+vf+kq4WldJo=;
        b=vS3Yiq/g65YRzHfn16Gwhx4gCxJSEp/wSMIcfpzkAbMF7pGmxUhrrHOlSg45w64FVi
         3xFHT1+gBohlKlvyj1sQnRFb88EWmmuMt0QyENXNsdO9TPA+/9D0Ik+pAvUjKFFV6jh0
         yKWFRUWVu98uqBmQ54VuD0OYpHROA7mqtt26FEeaFF1TludcfplcYKa6PCLTstv50wYk
         kUeWqIJKJNorE2paqCGVHEHi1BKjPRFKrkC9ecsBepPBA95ovzzKh+0cxhkR3hMTk15q
         rJ/X487W88SGSI82wC+aMLHmum4fULAn7dojoS8QTxl8mOAgSpTnB+xu0Pa2xhbxIf8O
         /Gsw==
X-Gm-Message-State: AJIora989jXKBStxCrAVWM0nE8ijQF93vpPQKqHFODbQUwYkBlX/6Ydr
        L4rS0pBz/Sj4cvj5psNcoLhs/RUNoeZ6w3gdszEY+g==
X-Google-Smtp-Source: AGRyM1vez/noetu41uNulqFawtfQXXyq+0cTlkuvwdzxvEpMZg81xlF4Ungc7jQSjmKg+0UMEkU8unZNv4A31Gh3pBc=
X-Received: by 2002:a25:23c3:0:b0:669:b1df:a249 with SMTP id
 j186-20020a2523c3000000b00669b1dfa249mr540360ybj.387.1655959352434; Wed, 22
 Jun 2022 21:42:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220622150220.1091182-1-edumazet@google.com> <4d281429-8ac0-c85b-5f8d-3f6fc925d9b7@kernel.dk>
In-Reply-To: <4d281429-8ac0-c85b-5f8d-3f6fc925d9b7@kernel.dk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 23 Jun 2022 06:42:21 +0200
Message-ID: <CANn89iJWdVjR16fRv=-ijZv37bmoUexjxi49EhmA6oKuxnxa8A@mail.gmail.com>
Subject: Re: [PATCH net] net: clear msg_get_inq in __sys_recvfrom() and __copy_msghdr_from_user()
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Potapenko <glider@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
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

On Wed, Jun 22, 2022 at 5:24 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/22/22 9:02 AM, Eric Dumazet wrote:
> > syzbot reported uninit-value in tcp_recvmsg() [1]
> >
> > Issue here is that msg->msg_get_inq should have been cleared,
> > otherwise tcp_recvmsg() might read garbage and perform
> > more work than needed, or have undefined behavior.
> >
> > Given CONFIG_INIT_STACK_ALL_ZERO=y is probably going to be
> > the default soon, I chose to change __sys_recvfrom() to clear
> > all fields but msghdr.addr which might be not NULL.
> >
> > For __copy_msghdr_from_user(), I added an explicit clear
> > of kmsg->msg_get_inq.
> >
> > [1]
> > BUG: KMSAN: uninit-value in tcp_recvmsg+0x6cf/0xb60 net/ipv4/tcp.c:2557
> > tcp_recvmsg+0x6cf/0xb60 net/ipv4/tcp.c:2557
> > inet_recvmsg+0x13a/0x5a0 net/ipv4/af_inet.c:850
> > sock_recvmsg_nosec net/socket.c:995 [inline]
> > sock_recvmsg net/socket.c:1013 [inline]
> > __sys_recvfrom+0x696/0x900 net/socket.c:2176
> > __do_sys_recvfrom net/socket.c:2194 [inline]
> > __se_sys_recvfrom net/socket.c:2190 [inline]
> > __x64_sys_recvfrom+0x122/0x1c0 net/socket.c:2190
> > do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
> > entry_SYSCALL_64_after_hwframe+0x46/0xb0
> >
> > Local variable msg created at:
> > __sys_recvfrom+0x81/0x900 net/socket.c:2154
> > __do_sys_recvfrom net/socket.c:2194 [inline]
> > __se_sys_recvfrom net/socket.c:2190 [inline]
> > __x64_sys_recvfrom+0x122/0x1c0 net/socket.c:2190
> >
> > CPU: 0 PID: 3493 Comm: syz-executor170 Not tainted 5.19.0-rc3-syzkaller-30868-g4b28366af7d9 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>
> Thanks Eric, looks good to me:
>
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
>
> --
> Jens Axboe
>

Alexander tested the patch as well:

Tested-by: Alexander Potapenko<glider@google.com>

Thanks !
