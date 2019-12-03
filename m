Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5C511051C
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:30:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfLCTan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:30:43 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:36457 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfLCTam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:30:42 -0500
Received: by mail-yb1-f195.google.com with SMTP id v2so2022301ybo.3
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 11:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4uvjUXCNBQO6VcOIIjQGWtziZakEDZPN02PceSw0AGg=;
        b=FP3gh5sfGaAOnBPUKS/0rM8109LJXUF7GFvsNqwtbTb0l5pAcudy3d4/NmI2TGmdXe
         92tEgDH+Ca2U6cuugDZEGSEUp/YjakhKY6fgrvsHmNkEDjTMDgLLs3zO4o+2HbpClDnu
         mbM+A2jLnduFsh4FglEVzrSTj0K1qw27Nu5kHWGafTLrV0C9jpRzIKETUdxhflAbC60I
         BYkpUgXrHj1EwMciCSquqg2BEdWWy7wbTeVazWEO9XZpNpJJxUfiJXvWTDIhIXFCHXTX
         /g8i34wUh9R97qD1I/6u6AaRAIFHsUbWytyYzx5q6xC0c3SQqwt/q+ctb9HRUPkHCvW9
         +hEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4uvjUXCNBQO6VcOIIjQGWtziZakEDZPN02PceSw0AGg=;
        b=ghDL6vcXxcDk7V5zrDw38+QkNDFCjASsDZ5XbbwbC2A+eJEaECExBVtwdQD+7PSm7L
         2LmKYMucZIDIgYCjciTNZE4NT92ZZqljL33Oo/a2uk1KQDJnUjGWR3Nht50ArwDhfcQg
         CS/cGYDYS1+uDsRfUSpUtCkmyYVc9gqAOxZZFVGgt32ahed1V+C33uJ4HNcrZ02ZOgmT
         tmz/9+Hao0P+uwBY1QLKEWyDW9fzfErS5lxuK34RS8TlW6QLmnRqr6VxpeYGGUWtNSu6
         FYAhfotYHNdhafPNGt0nKuuSExqhA7sFIB+EVRfxoLvrgx+JgPVf1CTx6UaG6s7o3eGA
         G6sg==
X-Gm-Message-State: APjAAAU4dXMxqKUZ1A0o3THsSyMiJ7THsUR4tiyX2Zl9plcb+n7Pxdxw
        CuBiUh7es8QF0CWHwEEVRzYTYtEIelTogqJ0DK6lBA==
X-Google-Smtp-Source: APXvYqwEw8ACzXbwWiBT7AQhuNfF7w+y986zfHF52E+pDdWAdjzH7a0gm6Yk6BQbmqWayQDyk6q8mzlb6fGqqn4odaQ=
X-Received: by 2002:a25:808b:: with SMTP id n11mr5491246ybk.395.1575401441247;
 Tue, 03 Dec 2019 11:30:41 -0800 (PST)
MIME-Version: 1.0
References: <20191203160552.31071-1-edumazet@google.com> <20191203191314.GA2734645@kroah.com>
 <CANn89i+LK6wHWStHTn3swgx8KDGQ2VMULk59JaRWi599=yx2pw@mail.gmail.com> <20191203192234.GA2735936@kroah.com>
In-Reply-To: <20191203192234.GA2735936@kroah.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 3 Dec 2019 11:30:29 -0800
Message-ID: <CANn89iLWjbVMw_UhR0wGC9iA3DoWYz7XtuTTgMmvq8x3zA2H4w@mail.gmail.com>
Subject: Re: [PATCH net] tcp: refactor tcp_retransmit_timer()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 3, 2019 at 11:22 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Dec 03, 2019 at 11:15:31AM -0800, Eric Dumazet wrote:
> > On Tue, Dec 3, 2019 at 11:13 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Dec 03, 2019 at 08:05:52AM -0800, Eric Dumazet wrote:
> > > > It appears linux-4.14 stable needs a backport of commit
> > > > 88f8598d0a30 ("tcp: exit if nothing to retransmit on RTO timeout")
> > > >
> > > > Since tcp_rtx_queue_empty() is not in pre 4.15 kernels,
> > > > let's refactor tcp_retransmit_timer() to only use tcp_rtx_queue_head()
> > >
> > > So does that mean that 4.19.y should get 88f8598d0a30 ("tcp: exit if
> > > nothing to retransmit on RTO timeout") as-is?
> > >
> >
> > Yes indeed. All stable versions need it.
>
> So 4.4.y and 4.9.y as well?

They should be fine, since they do not have yet :

ba2ddb43f270e6492ccce4fc42fc32c611de8f68 tcp: Don't dequeue
SYN/FIN-segments from write-queue
f1dcc5ed4bea3f2d63b74ad86617ec12b1e5e9d4 tcp: Reset send_head when
removing skb from write-queue
8e6521f6404e704fac313ab2479923be1f741f73 tcp: remove empty skb from
write queue in error cases

I would leave them untouched, to limit further problems :/
