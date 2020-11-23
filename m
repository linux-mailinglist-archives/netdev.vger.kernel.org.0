Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEAD2C0267
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 10:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgKWJkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 04:40:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727874AbgKWJka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 04:40:30 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C225BC0613CF;
        Mon, 23 Nov 2020 01:40:30 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w4so13713598pgg.13;
        Mon, 23 Nov 2020 01:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ySaaDJj3FNEmrbWbcGYLmfeN18a4YdousMGDCBvU6jk=;
        b=unPNP+t9GaBpFqpa9me97hdsQ/OBmpl48spMDQfiA1k0V21CTihfYEU7yZayAozEN/
         kXVQ4p4TRZDrylTUKyXahesyy+sivDq47lTZOPkq5AhHkINTdr4UqZ02c/Er0VR4LV+L
         TqKL1PAOHlZS7MN/z11lyf7V1vTl5LOsE7XbRd4rT4NLrIc5B2s30uKil+p+dav1x8B8
         qDSeZPY+3MKS1MaCF+PHrBGHr72kultchvZCvPz9142LPzoyWmNxNRbKKzgNOfeGD/GR
         uRxLI3q70ZgTW3xVW0J1bIc5qfDfAoWuaD8wylWVAknK0ceUcilEiPuecuaSb4Fa9HdH
         xoeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ySaaDJj3FNEmrbWbcGYLmfeN18a4YdousMGDCBvU6jk=;
        b=nMkH/1Azb7+FCAO8PzTO4D6mJeNsvzJUwfygF4DpzVwk4TlbVS+49pWlkNmbibsP93
         XRBep84xYaAlO1i8HkGbJkxFKTRlcqza3lx5Ov90MCn7GkAvjSMKDCf3BP5OjA0KRssq
         ScTdCZwnCZ0b+lwBiJQgE3CaHbF2t7iQcy18kI6ZzdxXS2Q2m51OzrqDnKvOsnWufapy
         vfHhUfoY/FMGAXubmkE+dfy0BwVKryrjStfOqh7Xewk29S9afbNh/8BCmkuNBiVMC5og
         D2l/bQYGTm8AU7DIiE15eKbhLOWlH2jkoX/7UbH2MydRU2cPb9gAPHRG7rWaG8TWcPl7
         hZKA==
X-Gm-Message-State: AOAM532BcugWgUO0z0Ciwc0eM8xMZRuOAlio0vQN3Ww1aCBfNG6/KxIF
        PiMZBh+xJa2qwqtOVu3y2WUydk9At5OaDY+Rn1b/ir8eZplxnLnB
X-Google-Smtp-Source: ABdhPJxlSdyRLYA8cIXJOOFc10Rd1EjyFau7MY37/lMw/uxdiT6KcFNnJgtf/c8+MgkjyQfx2yqGJxeHlDuKqaPESXY=
X-Received: by 2002:a62:445:0:b029:196:61fc:2756 with SMTP id
 66-20020a6204450000b029019661fc2756mr24783083pfe.12.1606124430231; Mon, 23
 Nov 2020 01:40:30 -0800 (PST)
MIME-Version: 1.0
References: <1606050623-22963-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1606050623-22963-1-git-send-email-lirongqing@baidu.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 23 Nov 2020 10:40:19 +0100
Message-ID: <CAJ8uoz3d4x9pWWNxmd9+ozt7ei7WUE=S=FnKE1sLZOqoKRwMJQ@mail.gmail.com>
Subject: Re: [PATCH] libbpf: add support for canceling cached_cons advance
To:     Li RongQing <lirongqing@baidu.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 22, 2020 at 2:21 PM Li RongQing <lirongqing@baidu.com> wrote:
>
> It is possible to fail receiving packets after calling
> xsk_ring_cons__peek, at this condition, cached_cons has
> been advanced, should be cancelled.

Thanks RongQing,

I have needed this myself in various situations, so I think we should
add this. But your motivation in the commit message is somewhat
confusing. How about something like this?

Add a new function for returning descriptors the user received after
an xsk_ring_cons__peek call. After the application has gotten a number
of descriptors from a ring, it might not be able to or want to process
them all for various reasons. Therefore, it would be useful to have an
interface for returning or cancelling a number of them so that they
are returned to the ring. This patch adds a new function called
xsk_ring_cons__cancel that performs this operation on nb descriptors
counted from the end of the batch of descriptors that was received
through the peek call.

Replace your commit message with this, fix the bug below, send a v2
and then I am happy to ack this.

/Magnus

> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  tools/lib/bpf/xsk.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 1069c46364ff..4128215c246b 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -153,6 +153,12 @@ static inline size_t xsk_ring_cons__peek(struct xsk_ring_cons *cons,
>         return entries;
>  }
>
> +static inline void xsk_ring_cons__cancel(struct xsk_ring_cons *cons,
> +                                        size_t nb)
> +{
> +       rx->cached_cons -= nb;

cons-> not rx->. Please make sure the v2 compiles and passes checkpatch.

> +}
> +
>  static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, size_t nb)
>  {
>         /* Make sure data has been read before indicating we are done
> --
> 2.17.3
>
