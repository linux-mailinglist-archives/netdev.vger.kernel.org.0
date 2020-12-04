Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712202CF25F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgLDQwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729906AbgLDQwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:52:04 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7DDC0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 08:51:18 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id k8so5789098ilr.4
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 08:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qWacdQiQJUJcaQsWaUdm9yI/RjddeUUPXCcFKJxryfE=;
        b=NF02XSYWP0YXa0gNHj4DXgSOCct6TSmhH5WBm9EFjZ7dYFFBbz3auahRXVdoGOqCvM
         OmHCZmIFgvVYwvuHe5k/yVvalKQpjlJWG7YV6AKeoX3iJPmngwUTT9/ew7cQvm6RRp7f
         RfLkiQWvtCjhLnoUxNe7vHaBDzYyzBzVjog6gAcGzyBU9OCqJwULFdYSHxD/NSaLLDtl
         qHRFyRg0WY46judmz+6E/ohX59mw51KfxnYKK74o/NFLk+WbQFXHaG8gEeSp15KFb6g+
         CKn9vYnr+OomHKSe+2WitudfkU1fg+ir7of7g1R5RdFcQRV2RtmtvQ0ZcKYawyXwGLyN
         MTLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qWacdQiQJUJcaQsWaUdm9yI/RjddeUUPXCcFKJxryfE=;
        b=FyZ6xjs2Bk6mk0HIV107ZK5ACrtzrwH4aCkYsb3Kwb9YKXBAZvsp0x+ouTE3/wHJV2
         w1NOUQvzoP0nsrenYnTJvGtFczlwc2QRZ3edj7WnT4QsGaA5PjiFK3dFwW7DjYRgPMBA
         nLUllnoSyc/Ir1YwP67qohjgGkI33aSQmKTtJvO6iGbkaq8aU3v3WZcZslBd+7lSqFRX
         IOPeLQXi/wZU/xB1KWsp/kuj40OjqMTsS8ymHspBtsGNtFV/J2G7mBsDCi3uU5m0/Qyq
         0iGywZddB21Dr1ke+DFLzU1pmSxWEvYzA+vb3oasTfv9JhixlLwXkKoh32E53EHhnPHJ
         LkaQ==
X-Gm-Message-State: AOAM532+24N31dyERiBQKuk25JdJMJ456YiQx0CKjMs3+mhovjrg0v1R
        sW++H1wdM9/OLauJz82RGPb81Uj2yyUXlUmsF1teY5CRPQh3sDV2
X-Google-Smtp-Source: ABdhPJwB4KQEbvvCTtYRmtqXlhBgIqIGc35cgNB5S/m5ZQQQ5cMZa8AficDeiFdihVyVTpRZc0ogDqdB/jQYa/jyl18=
X-Received: by 2002:a92:da48:: with SMTP id p8mr7811440ilq.216.1607100677873;
 Fri, 04 Dec 2020 08:51:17 -0800 (PST)
MIME-Version: 1.0
References: <20201204162428.2583119-1-eric.dumazet@gmail.com> <cac552ce70a747f078738a7167f0a75bc52fac7c.camel@sipsolutions.net>
In-Reply-To: <cac552ce70a747f078738a7167f0a75bc52fac7c.camel@sipsolutions.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Dec 2020 17:51:06 +0100
Message-ID: <CANn89iKkKaD+rFfwaoWCMKmYhGd4jE_=nMWyVTaZQ4EXBKRZXQ@mail.gmail.com>
Subject: Re: [PATCH net] mac80211: mesh: fix mesh_pathtbl_init() error path
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 5:26 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Fri, 2020-12-04 at 08:24 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > If tbl_mpp can not be allocated, we call mesh_table_free(tbl_path)
> > while tbl_path rhashtable has not yet been initialized, which causes
> > panics.
>
> Thanks Eric!
>
> I was going to ask how you ran into this ...
>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
>
> Until I saw this - but doesn't syzbot normally want a
> "syzbot+somehashid@..." as the reported-by?

Do not worry about this, I will not release the syzbot publicly, no
need to add more noise to various mailing lists for such a trivial
patch.
(This particular syzbot report included yet a buggy bisection, lets
not get yet another replies from annoyed developers )

This is why we add a Reported-by: syzbot <syzkaller@googlegroups.com>,
only to let the syzbot teams count the number of syzbot bugs fixed.
