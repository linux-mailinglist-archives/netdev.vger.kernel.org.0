Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6CE242C4E
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 17:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgHLPrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 11:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbgHLPrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 11:47:19 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79F5C061384
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 08:47:19 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id s16so1794783qtn.7
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 08:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AqtIjZGnF/YoWS6U85MsRctEA34IzLKpCIZZ8q1HDHA=;
        b=s4LooCt0XRZNigxnyEEdagbjMIEFL4vsZWtcMANW3oso9wVko68kSVK7J+NNQJRcoj
         A1QKNtGTPwuHkyRN9LzA9iMxpmtEDDSOPqpqD6lRe8JJ53a7Hie4MuKM0axaerkYTiwA
         DVFBTyuPpVGn4MePa6vQo0bkCEcuy3O8Uf0F1P3D2DNZ1KiN0SdRspXHYVwQyPxYyP00
         lf7qtwQ8msPa53mb8H7NfPAp/sFLsZresAgXJ1G6z/cHIXNAHNlmEwEu8XUkPAmIRsJ6
         csW+hAzkxRm1cr4XktWJjsfzOLGSfa5QtEgY/g9rIP7iv1VZ91EBI3P8jQBJIS5DDWTE
         DstQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AqtIjZGnF/YoWS6U85MsRctEA34IzLKpCIZZ8q1HDHA=;
        b=e0VbagkQK80BJajr7xaD5oJekY+2vJdRbPSPZQBb2xm2EzcpM18dQfoWtsTe8Ln/2E
         0J3z+PLVjRyXRVwkYDv1ftjs8Hadyzc+u8h2hm/z0UYBYYhws7Lm5h5onq0KgkP9ZsrI
         VGk08jusPLNur5E0lJOn+NJLaAiuLUyK82ipUU8t28yyymRABbwiiPZ7FTgxWjz6rN4f
         PAq0B0l8Os2MS+uk1h61RSmwawHhEcfcFqA8GVNR9gMnZ05FxS/jJ66KD2KDgXCaMItn
         d+P0M/xAb3eZy+T5B2Ar8VVNpWsMUm5Bi9m9UJCSOl/PeuXBJyh86uzfDs0m8lZkxL/t
         TCBQ==
X-Gm-Message-State: AOAM532ybd6hWCSVFlYmRknepiqKbMIq8pRm1RrX7EcBws7nTtnIRmnb
        CJPHG5srSNqh6RBEmwRg0JTbxj/OgPjjmkweZC0KpQ==
X-Google-Smtp-Source: ABdhPJxIcQFDoLKMo668z6GQjaJZbrtLV7n6RgX63h/b6wZG+TBWfA7NGOv36Nea+b7AsuZfSI0foU+yNqLshfe8/gs=
X-Received: by 2002:ac8:4e2f:: with SMTP id d15mr252258qtw.20.1597247237751;
 Wed, 12 Aug 2020 08:47:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200812022923.1217922-1-andriin@fb.com> <87imdo1ajl.fsf@toke.dk>
In-Reply-To: <87imdo1ajl.fsf@toke.dk>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 12 Aug 2020 08:47:06 -0700
Message-ID: <CAKH8qBuz48Ww6S=DCzKRr3f46Eq3LyknvTjDGP_5QRPxtGZ_Hw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix XDP FD-based attach/detach logic around XDP_FLAGS_UPDATE_IF_NOEXIST
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 2:24 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > Enforce XDP_FLAGS_UPDATE_IF_NOEXIST only if new BPF program to be attac=
hed is
> > non-NULL (i.e., we are not detaching a BPF program).
> >
> > Reported-by: Stanislav Fomichev <sdf@google.com>
> > Fixes: d4baa9368a5e ("bpf, xdp: Extract common XDP program attachment l=
ogic")
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
That fixed it for me, thank you!

Tested-by: Stanislav Fomichev <sdf@google.com>
