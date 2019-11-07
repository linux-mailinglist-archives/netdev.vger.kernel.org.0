Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F431F2D2A
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 12:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387927AbfKGLPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 06:15:21 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42695 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbfKGLPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 06:15:20 -0500
Received: by mail-wr1-f66.google.com with SMTP id a15so2521566wrf.9
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 03:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lkhKlP+nRmdiHSeBByl2uzBydDfCxHRYE22JZBDwszc=;
        b=gI9Ei2/E5vg3K70OQbtvyLQFKNCmpvb02EzBVRHawvo509ZV+i6q/NuFzM512blCCw
         w8FivJLQ5+sD4Ra7JGG0QBRBuIXkqRGvlu7nUHq/1/r0Ctb95RbMva/tTYnOfc2m4+bA
         DGor7b9uEfdoemUrrH8DPT4lzzaIekGREGHXI7zuCcfSW7Yf7GtXVVDw8TQBIgM0ro6J
         RD6hFqkl1hT65pOS0RUCZXqYFWjtDyk0FEHuEpeYtglM2Br8ox9jY1KV86BGABMINWhb
         0PtfO7a2lKsxYBooRqTroJiMScICvc06lhMJBwprgyF889dZsiXge/vY4Xf2sSaiFHey
         z5mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lkhKlP+nRmdiHSeBByl2uzBydDfCxHRYE22JZBDwszc=;
        b=XB8vOU5GPTzjYBWkHvGD/hBoihg9yMZ2zX0az4U7MVLFX4Ivmvc/+T2WdaCh/4QAPJ
         Wazx1EShkseQZmRmWvmG+XyXy4UCGbUpRDs5m96ChFsWioioWS8tW/Zqv28HfC3HrzAy
         XRkBvEXjUQjEVvBMva/aSGK7xLPLyXPyBl5wmCPE9mcY8A7zF6s2Hbkq7umNOxt/NHTw
         /kF4GeafpBIdQhnUtWSr+5+GXJD7iS/J4uXg9o81TTdbipY0Shl/iIuU5Nf3O5nOR+U2
         z3Tfq9/NK3z4LK2GvdhyxPE1eyFDaND5dj3an1ZyI0nDGsytB5K6AjepkY9rghCk0iRc
         wnMQ==
X-Gm-Message-State: APjAAAXyEAbHIvdJpNT45l0JutFIKtcq9y9W+X0yv6CLBh5KxzEQqqmV
        fPKpuvHFa7GBOTiSYn0HZQXOMyX8SqFLoHyUDI7elQ==
X-Google-Smtp-Source: APXvYqz7YI76LF+j2pFIef8kTkDy0Is83JgCQNNutw3kIaS4vQMomuB1a03nTsKljJfzzgJey6bPXaX4wzbgLLbrR2g=
X-Received: by 2002:a5d:4ecd:: with SMTP id s13mr2419196wrv.216.1573125315730;
 Thu, 07 Nov 2019 03:15:15 -0800 (PST)
MIME-Version: 1.0
References: <20191106222208.26815-1-labbott@redhat.com>
In-Reply-To: <20191106222208.26815-1-labbott@redhat.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Thu, 7 Nov 2019 12:15:04 +0100
Message-ID: <CAG_fn=X=UGmyADzX0nMe8r=FOhAm5YsD46fqrz+4Ofo2N=uyUA@mail.gmail.com>
Subject: Re: [PATCH] mm: slub: Really fix slab walking for init_on_free
To:     Laura Abbott <labbott@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>, clipos@ssi.gouv.fr,
        Vlastimil Babka <vbabka@suse.cz>,
        Thibaut Sautereau <thibaut.sautereau@clip-os.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 11:22 PM Laura Abbott <labbott@redhat.com> wrote:
>
> Commit 1b7e816fc80e ("mm: slub: Fix slab walking for init_on_free")
> fixed one problem with the slab walking but missed a key detail:
> When walking the list, the head and tail pointers need to be updated
> since we end up reversing the list as a result. Without doing this,
> bulk free is broken. One way this is exposed is a NULL pointer with
> slub_debug=3DF:
Thanks for the fix!
Is it possible to reproduce the problem on a small test case that
could be added to lib/test_meminit.c?

> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> BUG skbuff_head_cache (Tainted: G                T): Object already free
> -------------------------------------------------------------------------=
----
>
> INFO: Slab 0x000000000d2d2f8f objects=3D16 used=3D3 fp=3D0x00000000643090=
71 flags=3D0x3fff00000000201
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> PGD 0 P4D 0
> Oops: 0000 [#1] PREEMPT SMP PTI
> CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    B           T 5.3.8 #1
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
> RIP: 0010:print_trailer+0x70/0x1d5
> Code: 28 4d 8b 4d 00 4d 8b 45 20 81 e2 ff 7f 00 00 e8 86 ce ef ff 8b 4b 2=
0 48 89 ea 48 89 ee 4c 29 e2 48 c7 c7 90 6f d4 89 48 01 e9 <48> 33 09 48 33=
 8b 70 01 00 00 e8 61 ce ef ff f6 43 09 04 74 35 8b
> RSP: 0018:ffffbf7680003d58 EFLAGS: 00010046
> RAX: 000000000000005d RBX: ffffa3d2bb08e540 RCX: 0000000000000000
> RDX: 00005c2d8fdc2000 RSI: 0000000000000000 RDI: ffffffff89d46f90
> RBP: 0000000000000000 R08: 0000000000000242 R09: 000000000000006c
> R10: 0000000000000000 R11: 0000000000000030 R12: ffffa3d27023e000
> R13: fffff11080c08f80 R14: ffffa3d2bb047a80 R15: 0000000000000002
> FS:  0000000000000000(0000) GS:ffffa3d2be400000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000007a6c4000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  free_debug_processing.cold.37+0xc9/0x149
>  ? __kfree_skb_flush+0x30/0x40
>  ? __kfree_skb_flush+0x30/0x40
>  __slab_free+0x22a/0x3d0
>  ? tcp_wfree+0x2a/0x140
>  ? __sock_wfree+0x1b/0x30
>  kmem_cache_free_bulk+0x415/0x420
>  ? __kfree_skb_flush+0x30/0x40
>  __kfree_skb_flush+0x30/0x40
>  net_rx_action+0x2dd/0x480
>  __do_softirq+0xf0/0x246
>  irq_exit+0x93/0xb0
>  do_IRQ+0xa0/0x110
>  common_interrupt+0xf/0xf
>  </IRQ>
>
> Given we're now almost identical to the existing debugging
> code which correctly walks the list, combine with that.
>
> Link: https://lkml.kernel.org/r/20191104170303.GA50361@gandi.net
> Reported-by: Thibaut Sautereau <thibaut.sautereau@clip-os.org>
> Fixes: 1b7e816fc80e ("mm: slub: Fix slab walking for init_on_free")
> Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Alexander Potapenko <glider@google.com>
> ---
>  mm/slub.c | 39 +++++++++------------------------------
>  1 file changed, 9 insertions(+), 30 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index dac41cf0b94a..d2445dd1c7ed 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1432,12 +1432,15 @@ static inline bool slab_free_freelist_hook(struct=
 kmem_cache *s,
>         void *old_tail =3D *tail ? *tail : *head;
>         int rsize;
>
> -       if (slab_want_init_on_free(s)) {
> -               void *p =3D NULL;
> +       /* Head and tail of the reconstructed freelist */
> +       *head =3D NULL;
> +       *tail =3D NULL;
>
> -               do {
> -                       object =3D next;
> -                       next =3D get_freepointer(s, object);
> +       do {
> +               object =3D next;
> +               next =3D get_freepointer(s, object);
> +
> +               if (slab_want_init_on_free(s)) {
>                         /*
>                          * Clear the object and the metadata, but don't t=
ouch
>                          * the redzone.
> @@ -1447,29 +1450,8 @@ static inline bool slab_free_freelist_hook(struct =
kmem_cache *s,
>                                                            : 0;
>                         memset((char *)object + s->inuse, 0,
>                                s->size - s->inuse - rsize);
> -                       set_freepointer(s, object, p);
> -                       p =3D object;
> -               } while (object !=3D old_tail);
> -       }
> -
> -/*
> - * Compiler cannot detect this function can be removed if slab_free_hook=
()
> - * evaluates to nothing.  Thus, catch all relevant config debug options =
here.
> - */
> -#if defined(CONFIG_LOCKDEP)    ||              \
> -       defined(CONFIG_DEBUG_KMEMLEAK) ||       \
> -       defined(CONFIG_DEBUG_OBJECTS_FREE) ||   \
> -       defined(CONFIG_KASAN)
>
> -       next =3D *head;
> -
> -       /* Head and tail of the reconstructed freelist */
> -       *head =3D NULL;
> -       *tail =3D NULL;
> -
> -       do {
> -               object =3D next;
> -               next =3D get_freepointer(s, object);
> +               }
>                 /* If object's reuse doesn't have to be delayed */
>                 if (!slab_free_hook(s, object)) {
>                         /* Move object to the new freelist */
> @@ -1484,9 +1466,6 @@ static inline bool slab_free_freelist_hook(struct k=
mem_cache *s,
>                 *tail =3D NULL;
>
>         return *head !=3D NULL;
> -#else
> -       return true;
> -#endif
>  }
>
>  static void *setup_object(struct kmem_cache *s, struct page *page,
> --
> 2.21.0
>


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
