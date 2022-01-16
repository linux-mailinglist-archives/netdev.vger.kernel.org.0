Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5481348FBDA
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 09:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234705AbiAPIyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 03:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiAPIyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 03:54:24 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0330C061574
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 00:54:23 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id v186so36737312ybg.1
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 00:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U6wXN0d2QTkJfstgGkmb0IOMTxqQ7H+4DlN60M4XZaM=;
        b=ApLSq0bFfc0VZ3T+nRKZK/XLIs23KK6ysApaB/VHgWU5a9TsyYZf0MLb59ZdNkAmDX
         eJdRNdjoCHPt21VtLijbuK5gmJ+1iB4n/laaTpLz/F7TsEpeMOesviTDmcvSdlsa52Z/
         jtl8HB7SkK07rUlwc72gOOnhCgtWTIRBbeLyBWoV7BA4KZglzi5cT2lZ/uZwjOzlZDON
         jttb13pWwkP6HQtStv2YSS5xsA+ls5pBe/w8oNJoSdOAivM7rffE+uZwXU+d/HWW9Wb+
         SsvTnjcbvPKDVY6S4i9oq3Khyi8Yc7/zcEPVPYcxikGflW2zZ01MGdn+z7Ilc3e+1Y1M
         5BoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U6wXN0d2QTkJfstgGkmb0IOMTxqQ7H+4DlN60M4XZaM=;
        b=qVN9ZvvuFO9yip4hy05V3uGZwlSY1Gbomo6llpOqw5KSlfVPhgJSWMhzbH/jVntrGD
         t4HIbIoYtQ/uMEaqlt/VxcG9yJZtiKUYe6j2zwy5u7LMEvPhX9yp5yLDCkZ9fk9Xr0FW
         kjvIaGoB4tg+yeS8I/FkDB1jkNAWdEY7ch8dmMrvyJpwgqwi93Qy6C1VdGIn/fA8zL5U
         280HROqXuRobK+3pYEr9cwD7uDvi+N5oVF5BEiQk3JwAH5LpLWoJmBO3civ28ZpMcveN
         7D8LAqKNDHYYvffVSpaWbcgAlb4XYZqdfFv6NQmcwEKtyRsXEncufCm3r6kxgw2PP0mt
         /HtA==
X-Gm-Message-State: AOAM53396VkY4CZ8eKZLSWe3qMqm91NAWWXJscnwhE5N7GlfFb2aIZsz
        fsqmWzeclHBKYrAKnrFbacRqee0anR4ncWL28Piln2+nY/M=
X-Google-Smtp-Source: ABdhPJzjJUnp137g4EWqTGcInhw0fzubkWxgPLvKLCQJTa82ctSeJmP1U2rGo+uUdNGaZd24U4p1K40JHO/9cdgMHBQ=
X-Received: by 2002:a25:2385:: with SMTP id j127mr5745352ybj.711.1642323262692;
 Sun, 16 Jan 2022 00:54:22 -0800 (PST)
MIME-Version: 1.0
References: <20220114153902.1989393-1-eric.dumazet@gmail.com>
 <2f8ea7358c17449682f7e72eaed1ce54@AcuMS.aculab.com> <CANn89iKA32qt8X6VzFsissZwxHpar6pDEJT_dgYhnxfROcaqRA@mail.gmail.com>
 <YePbZ1FBOrZ5RufS@shredder>
In-Reply-To: <YePbZ1FBOrZ5RufS@shredder>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 16 Jan 2022 00:54:11 -0800
Message-ID: <CANn89iJA+7nM4OYRW-q2zhGnTLr1ezHgRekTQWkEwd0_+NKvNg@mail.gmail.com>
Subject: Re: [PATCH net] ipv4: make fib_info_cnt atomic
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Laight <David.Laight@aculab.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
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

On Sun, Jan 16, 2022 at 12:46 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> Thanks for the fix. Looks OK to me. The counter is incremented under the
> lock when adding to the hash table(s) and decremented under the lock
> upon removal. Do you intend to submit this version instead of the first
> one?

Yes, I will send a V2, thanks !
