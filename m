Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37916A9167
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 08:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCCHDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 02:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCCHDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 02:03:47 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5956113507;
        Thu,  2 Mar 2023 23:03:46 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id u9so6619445edd.2;
        Thu, 02 Mar 2023 23:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xJj6g5A3EsKcFos+5MP0A2Xe3JFrizoalt104xyCj2Q=;
        b=QA9Riv9qHb3w/RgnuVewzfMzEQs5KQ3OTfZihdwrSmTqrejvFYps+3IQBDvJ6j90xI
         AjX8Ka7oKhQFmEg1geEVs/f8jnRAeii+pW59DOnnNoNDlH2Vvwr2yBYmw1dYD3sChfIR
         ShDah4aEzzG3yv3/Jif2lkPn9WcOh9C6K42eAO9D/rhytFBOElqGv7bD/TGOw8yjSZnk
         hv99oFgmtyKquIJU3MHtCkqBN+RYOpRtZ4zXPFqedGnFh+F75L3ghHvNRZvAXAWjznZO
         vJ/B1f1+zwtwAUnEHhafeO3nBHpL0KWckbJx1Nn63f60GeP2YLJNCXDtHcvIwOfv9psI
         PJig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xJj6g5A3EsKcFos+5MP0A2Xe3JFrizoalt104xyCj2Q=;
        b=3g5glcV8HcRXGMMV6dzJdUlPt9Q5efneLY3nuz4YKmHkUtNaRaTLl9wtm89dOXWca1
         Rs5QWc8O79xlhgKEkQaCsU3ZeZqj9iGrt7dWw7MkVRmjEuzrDKC0czd6lW+STok9X+74
         eJf8j7lsB4Qu6Xn2YUTP23PXvG2puiJ+SFphOGLDAptqflP459Py/qUsQGV74P0KKZGE
         N9YlBW5dYk4BccstHKKouTZ+5UTDcfQ1CmG/5SOoHOidmhQBnr6U+qIkirFfqj0YQp1X
         XJdkCfsEOfW0ekL+31+XlZ5HR9eJUNijVpi6ig7wU+Ll8FqAo18q9n3Mf1ofS0KWEjLt
         a1GA==
X-Gm-Message-State: AO0yUKWAiVhqTiFXWDSZ9iTN7tZCFzjyNAfsBmMjdcYs9U9dWvf3My2A
        9M93UUEOnvq3eMIeQJRZve258WhZdlJkjm8+rMQ=
X-Google-Smtp-Source: AK7set+e+2Nr+ilgHj6+YiTHCbHjGEGuvVT3qG5GskK+rylNwb0hrlrEDEAa5O3i5wyGoSUqfKa95yQ9ElF9+P8ONno=
X-Received: by 2002:a17:906:a00a:b0:8ae:9f1e:a1c5 with SMTP id
 p10-20020a170906a00a00b008ae9f1ea1c5mr294433ejy.3.1677827024705; Thu, 02 Mar
 2023 23:03:44 -0800 (PST)
MIME-Version: 1.0
References: <20230223120212.1604148-1-liujian56@huawei.com> <63fdbd07b3593_5f4ac208eb@john.notmuch>
In-Reply-To: <63fdbd07b3593_5f4ac208eb@john.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 2 Mar 2023 23:03:33 -0800
Message-ID: <CAADnVQLs=Cc06Pvu+zcXxSsB4zxsJm2DT-6me6NLm1hEjfDkTw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf, sockmap: fix an infinite loop error when len is
 0 in tcp_bpf_recvmsg_parser()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Liu Jian <liujian56@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 12:36=E2=80=AFAM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Liu Jian wrote:
> > When the buffer length of the recvmsg system call is 0, we got the
> > flollowing soft lockup problem:
> >
> > watchdog: BUG: soft lockup - CPU#3 stuck for 27s! [a.out:6149]
> > CPU: 3 PID: 6149 Comm: a.out Kdump: loaded Not tainted 6.2.0+ #30
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01=
/2014
> > RIP: 0010:remove_wait_queue+0xb/0xc0
> > Code: 5e 41 5f c3 cc cc cc cc 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90=
 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 41 57 <41> 56 41 55 =
41 54 55 48 89 fd 53 48 89 f3 4c 8d 6b 18 4c 8d 73 20
> > RSP: 0018:ffff88811b5978b8 EFLAGS: 00000246
> > RAX: 0000000000000000 RBX: ffff88811a7d3780 RCX: ffffffffb7a4d768
> > RDX: dffffc0000000000 RSI: ffff88811b597908 RDI: ffff888115408040
> > RBP: 1ffff110236b2f1b R08: 0000000000000000 R09: ffff88811a7d37e7
> > R10: ffffed10234fa6fc R11: 0000000000000001 R12: ffff88811179b800
> > R13: 0000000000000001 R14: ffff88811a7d38a8 R15: ffff88811a7d37e0
> > FS:  00007f6fb5398740(0000) GS:ffff888237180000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000000020000000 CR3: 000000010b6ba002 CR4: 0000000000370ee0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <TASK>
> >  tcp_msg_wait_data+0x279/0x2f0
> >  tcp_bpf_recvmsg_parser+0x3c6/0x490
> >  inet_recvmsg+0x280/0x290
> >  sock_recvmsg+0xfc/0x120
> >  ____sys_recvmsg+0x160/0x3d0
> >  ___sys_recvmsg+0xf0/0x180
> >  __sys_recvmsg+0xea/0x1a0
> >  do_syscall_64+0x3f/0x90
> >  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> >
> > The logic in tcp_bpf_recvmsg_parser is as follows:
> >
> > msg_bytes_ready:
> >       copied =3D sk_msg_recvmsg(sk, psock, msg, len, flags);
> >       if (!copied) {
> >               wait data;
> >               goto msg_bytes_ready;
> >       }
> >
> > In this case, "copied" alway is 0, the infinite loop occurs.
> >
> > According to the Linux system call man page, 0 should be returned in th=
is
> > case. Therefore, in tcp_bpf_recvmsg_parser(), if the length is 0, direc=
tly
> > return.
> >
> > Also modify several other functions with the same problem.
> >
> > Fixes: 1f5be6b3b063 ("udp: Implement udp_bpf_recvmsg() for sockmap")
> > Fixes: 9825d866ce0d ("af_unix: Implement unix_dgram_bpf_recvmsg()")
> > Fixes: c5d2177a72a1 ("bpf, sockmap: Fix race in ingress receive verdict=
 with redirect to self")
> > Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface=
")
> > Signed-off-by: Liu Jian <liujian56@huawei.com>
> > ---
>
> Thanks.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Thanks John.

Liu,

could you please change if (len =3D=3D 0) to if (!len) and respin with John=
's ack.
Thanks
