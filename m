Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B4F66DBC5
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbjAQLEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236546AbjAQLEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:04:22 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D1A2A99B
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:04:22 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id e130so4010314yba.7
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aAfo2Y319trh43eUAoJNNENY6gtEC5QJw8qHDn4W8rI=;
        b=bFgI3I6LjMANGF/RslmXGUvjxm+swqvpJwh360h86k2DFwYqB9MNqMFXQ/yFCcH7BL
         JoxxMblhZXc+LI5z7c5zB0naTBiKKgcyChqojkovV16OGecKIb8CcoaN9wA8J1HJiZD5
         riiMjoeCPT+pukaWfFET+hM6GbjvAwQid23mBvdj/LB/wn+9eM4qilTZgArx2jTKB40U
         66Ash+3kTxhNbbBgJfKLUH0x5i8oSebKko4zlLlCki3tgv0WquBxsSsHtRYsqAybbGpV
         5iUgzMEmSTvIFaMSl+XmjddLDwMTr2cuAd6Y4cwUupViTNcwBB0EPk+G14gGcmIBI1mA
         l+/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aAfo2Y319trh43eUAoJNNENY6gtEC5QJw8qHDn4W8rI=;
        b=ro9XKO7loT9ypYqw04M6fXkjoin9LpNj4xO1S3yyYhCjtqxO+URFwRhK1QE602ouYm
         Gt8YgIZYrOd2AIoDGhi5eg9XFctOcj7dmAwGHX7ZkUe132BcP/hIn4DNzs1GhOKPC7Lg
         lOaVm93UimbYLTg0oncQTcEz9gj/TIsv/UNweAbbDY0yDQDNkLO/67akggH1/RzY2izm
         LQXXh8OPlF3WDqj/sQ4YcyvWy0szeUhIWlupe7GXbTdFjmdVd2h1Av3MINonP5ThHenv
         db/wnh/9nPxaF15aDEyTAHeBt49RQosouxjxuhURJ//lkP2VlyuZqttY+zcqg8n48Ogx
         z+xA==
X-Gm-Message-State: AFqh2kqGzkm/AWCLmM7TTlvZJ/dBmbNGhMPcseHkKefC1r0iTkJGddtd
        1bNB7VcrYGgXb2ur26phgNDnP8BwBevVMVBIc/+CKQ==
X-Google-Smtp-Source: AMrXdXtxliEkOlWU6QEHyBIGrnT+GSa55LDeXA6zNSj1Rf6tjmCe6J2Guu4OkvKCIhR7ETkdOKWCdvd+Ux1Tl4Psq8E=
X-Received: by 2002:a25:d117:0:b0:703:8a9c:fd with SMTP id i23-20020a25d117000000b007038a9c00fdmr406575ybg.231.1673953461262;
 Tue, 17 Jan 2023 03:04:21 -0800 (PST)
MIME-Version: 1.0
References: <000000000000fbb2d505f27398cb@google.com>
In-Reply-To: <000000000000fbb2d505f27398cb@google.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 17 Jan 2023 12:04:10 +0100
Message-ID: <CANn89iK46vtck1m2TvpT+gfDkAi=txd-8VD5qdBhoZqiL2-XEw@mail.gmail.com>
Subject: Re: [syzbot] possible deadlock in release_sock
To:     syzbot <syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com>
Cc:     cong.wang@bytedance.com, davem@davemloft.net, gnault@redhat.com,
        jakub@cloudflare.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 11:59 AM syzbot
<syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    87b93b678e95 octeontx2-pf: Avoid use of GFP_KERNEL in atom..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=1032dd91480000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2b6ecad960fc703e
> dashboard link: https://syzkaller.appspot.com/bug?extid=bbd35b345c7cab0d9a08
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1716b3a1480000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14e57a91480000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/191e8cc30fff/disk-87b93b67.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d34dd6d2fffd/vmlinux-87b93b67.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ad9344e76aaf/bzImage-87b93b67.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com

Fix under review :
https://patchwork.kernel.org/project/netdevbpf/patch/20230117110131.1362738-1-edumazet@google.com/
