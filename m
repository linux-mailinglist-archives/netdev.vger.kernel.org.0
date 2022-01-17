Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744D4490564
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 10:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbiAQJsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 04:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236027AbiAQJsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 04:48:33 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A5CC061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 01:48:33 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id j134so18451084ybj.6
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 01:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5QP7IYPTybfpG7/fvJjm/xyrO4xpPEBhpBFVa42zi3U=;
        b=gT2PfrE8QlYRap5iFpsJ7c2e2vbC2sWOalLeytIBUt+coQjQ2HfhKmIIxzcH2Dq+B+
         Jz91bVM+QuLDMwQ6coSstDGH55/WEYTyOGVX8XrknQ2HZL2WEMQcv/V1N6sVgmCv7pc6
         As+4l0LDrButZwtmBWdKXrXoxPF7E1MSwJnN/hz/095rXEwEKnqzAEzKyN9nbe4w1RBq
         Oginp3JyhOgYU9iUVRP7eaYEhR4jjIMTBUipZ5JvrzUWMEnAreHfFD65/mi4EjmCzP5z
         vxIzGZLp0oOrdrw2pe0cwtPETegJ+9jElfYInUcNaV1sBGzIAroWutWIIEbq1itZEv+m
         tFxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5QP7IYPTybfpG7/fvJjm/xyrO4xpPEBhpBFVa42zi3U=;
        b=bMiflqTljBaQCxKFCwMihwp+/wXUwTr6nfmBnrmUjpaBAiwADEG96gL0yHoJ51itBY
         SbTxJy1P6jMR2/zfm8QqQ/dgmIY8mIGzO4tq1i9q1rzwfBY7V3KwGY8OEFgcAPJOwBiu
         0r99WGRdvJVepbbahXYlmIM7gGkA40uEqiGSvByeYjDjqLq5O2nBzyCUXI3hIcN1guhZ
         1XQhmRjtIW5N++cKcUorugzWRVtIzii/Wb20TDmSr0atuIJcgWCzetX9aGVFxZjagncG
         L2dstaiAPaZONat7TUIk8Ro64psx6dvrluqoShnXF/6NbMZwXurWZhibUCpqornB+kb/
         7u9Q==
X-Gm-Message-State: AOAM530Fw6u+HIOUWLB049fwJ5Xqtu19p07Xq4O8BNwBRHUXyIDNxK6x
        BEfv6cxFTps2XRCSo5BwK2SZKmx3rFLlLSBagLE3yQ==
X-Google-Smtp-Source: ABdhPJy2ZvgTYNfzDH62WJdp+F2NuLnQmvtNbFlC30ZrFNXhZbOYM39zfaoyJ+R0Y3x9XWctJUfVUVHhiR8V52s/Ktc=
X-Received: by 2002:a25:cf06:: with SMTP id f6mr9836658ybg.296.1642412912067;
 Mon, 17 Jan 2022 01:48:32 -0800 (PST)
MIME-Version: 1.0
References: <20220116090220.2378360-1-eric.dumazet@gmail.com> <20a08d9d62f442fcb710a2bbfae47289@AcuMS.aculab.com>
In-Reply-To: <20a08d9d62f442fcb710a2bbfae47289@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 17 Jan 2022 01:48:20 -0800
Message-ID: <CANn89iJnJJpNJtw+8v9hJfbRiamw59wu7cywZPZwZ9fvoGFUsw@mail.gmail.com>
Subject: Re: [PATCH v2 net] ipv4: update fib_info_cnt under spinlock protection
To:     David Laight <David.Laight@aculab.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 16, 2022 at 7:23 PM David Laight <David.Laight@aculab.com> wrote:
>
> From: Eric Dumazet
> > Sent: 16 January 2022 09:02
> >
> > In the past, free_fib_info() was supposed to be called
> > under RTNL protection.
> >
> > This eventually was no longer the case.
> >
> > Instead of enforcing RTNL it seems we simply can
> > move fib_info_cnt changes to occur when fib_info_lock
> > is held.
> >
> > v2: David Laight suggested to update fib_info_cnt
> > only when an entry is added/deleted to/from the hash table,
> > as fib_info_cnt is used to make sure hash table size
> > is optimal.
>
> Already applied, but
> acked-by: David Laight
>
> ...
> If you are going to add READ_ONCE() markers then one on
> 'fib_info_hash_size' would be much more appropriate since
> this value is used twice.
>
> >       err = -ENOBUFS;
> > -     if (fib_info_cnt >= fib_info_hash_size) {
> > +
> > +     /* Paired with WRITE_ONCE() in fib_release_info() */
> > +     if (READ_ONCE(fib_info_cnt) >= fib_info_hash_size) {
> >               unsigned int new_size = fib_info_hash_size << 1;
> >               struct hlist_head *new_info_hash;
> >               struct hlist_head *new_laddrhash;
> > @@ -1462,7 +1467,6 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
>
> If is also possible for two (or many) threads to decide to
> increase the hash table size at the same time.
>
> The code that moves the items to the new hash tables should
> probably discard the new tables is they aren't larger than
> the existing ones.
> The copy does look safe - just a waste of time.
>
> It is also technically possible (but very unlikely) that the table
> will get shrunk!
> It will grow again on the next allocate.
>
> But this is a different bug.
>

There is no bug.

fib_create_info() is called with RTNL held.



> I also though Linus said that the WRITE_ONCE() weren't needed
> here because the kernel basically assumes the compiler isn't
> stupid enough to do 'write tearing' on word sized items
> (or just write zero before every write).
>

That is not true. READ_ONCE()/WRITE_ONCE() have their own purpose,
we can not assume a compiler will follow arbitrary rules about word sizes.
