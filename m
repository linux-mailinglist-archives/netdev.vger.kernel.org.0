Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DE14CF439
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 10:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiCGJGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 04:06:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233248AbiCGJGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 04:06:48 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0C6F60DA2
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 01:05:53 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id x26-20020a4a621a000000b00320d7d4af22so3648845ooc.4
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 01:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ztngf9+MdlcLgreckyutp7phnfad7vjULE3nGwaq1pk=;
        b=lxSIl7lSq07stQpDez6F/q9h9VOxYtFSO16aBOHyMbdmr5R5r7QzR13lBVNsoJ6yvV
         4gSE/w9fXHx+AlvXj82IhHt/wqERYdb5dUud5fE2wm1yrLp9DnWpcFDbGpvjcjFcrWSa
         P7WgseEC3ZwvsC244yXehwHCpfBbj4kGesPXEsbv4wH6acfi2pxQxLDpvMaLAYyrr5ul
         r7Osq8aMI624hIwAVleuLH20XaQYh+EURl25SuFnA/J+0k+ffAmyZ+I2PlGKO3/Nc09S
         pSJyEISaUBBxskb7Bm4Rf94bF9d5mI+KGNRyaaEekb1jC2sjweqJnK3gI5xXwDzlaJlt
         dKuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ztngf9+MdlcLgreckyutp7phnfad7vjULE3nGwaq1pk=;
        b=LQVcnsKYRqHZsboX93pQBR7J9b+VlxQrif7aZkVhrXunh2QwPuN/JBrBmuV3M9ChvO
         1YMstavlODi+eXF68HaiElGWFBU77vxvipu59Kh9EMwfupkxsuhUZh9IEVPHJKjHRXnG
         Lg1dozhmo1Jjwi6ncMZEf+9oeqOOCsODjAGdvrdzZOn+cNqqPPk2wnFt3d9cXFJwNtlm
         UlEqWov0JyzvttBIzDwqdFk1yGpwYGu/BlFxJbCMxB1Dq6JM7kmX66edbuknb9wdoTwt
         uHAuoWePGe+V+85zgWTG7xwhEf+DP5Yxky6s4zMh5KufiNMX2JzL3w9dRBJV8RV7wfie
         D4kQ==
X-Gm-Message-State: AOAM53134CCjl1cm2ZdoyEBWvP0oTRrqxv0YQfvATkfZN61JF0EX3UV9
        ZWdXFWw7VdLMylUfhtk426HSiWMwW92GhNoKQYQBiw==
X-Google-Smtp-Source: ABdhPJz1hiiZuTDEmdXhOVtipiWmCRWHLh+d4MW9veF/fSA7TB54rK3/sZmVY7tHUvV+cjjJMcf15W/FQd20KAyeHyQ=
X-Received: by 2002:a05:6870:95a1:b0:da:b3f:2b34 with SMTP id
 k33-20020a05687095a100b000da0b3f2b34mr5588255oao.211.1646643952796; Mon, 07
 Mar 2022 01:05:52 -0800 (PST)
MIME-Version: 1.0
References: <00000000000024a1f805d8ac1da3@google.com> <2c775ec8-6fcb-cdeb-9b7c-35822c74bbde@gmail.com>
In-Reply-To: <2c775ec8-6fcb-cdeb-9b7c-35822c74bbde@gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 7 Mar 2022 10:05:41 +0100
Message-ID: <CACT4Y+a8M7NyCiKZp2tnDHfOZ5bM4XhYjL+=Upr+Xx0MH=7=Cw@mail.gmail.com>
Subject: Re: [syzbot] KMSAN: uninit-value in asix_check_host_enable
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     syzbot <syzbot+8f5f07bb9d6935e2f8d9@syzkaller.appspotmail.com>,
        andrew@lunn.ch, davem@davemloft.net, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux@rempel-privat.de,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022 at 12:01, Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On 2/23/22 12:30, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    724946410067 x86: kmsan: enable KMSAN builds for x86
> > git tree:       https://github.com/google/kmsan.git master
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11c85246700000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=76f99026248b24e4
> > dashboard link: https://syzkaller.appspot.com/bug?extid=8f5f07bb9d6935e2f8d9
> > compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11674fe2700000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1497324c700000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+8f5f07bb9d6935e2f8d9@syzkaller.appspotmail.com
> >
>
> Should be fixed by [1], but it's only in next for now.
>
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=920a9fa27e7805499cfe78491b36fed2322c02ec

Let's tell syzbot so that it reports new bugs in future:
#syz fix: net: asix: add proper error handling of usb read errors
