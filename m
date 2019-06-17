Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D77E648ABE
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 19:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfFQRqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 13:46:48 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36827 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfFQRqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 13:46:48 -0400
Received: by mail-qt1-f195.google.com with SMTP id p15so11786396qtl.3;
        Mon, 17 Jun 2019 10:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sEeLyWIWaH8yI5NmJgm9tYs+wDDYp+k6X7WJXQxU9Kk=;
        b=i5kKTxj35ZuRu49cy7EVfO+BE0FVenJWi19z6yNiyB2f/Y9QSHuX9eXqW2ThX5+eXS
         TLnTNF+Us+6ZUvUbyhZu0AKu1BU7hdsW+gNkev7HHfKyuJILEKS3Wj/CVe3pXBaUZKfH
         t3LpJMpojH0vXS0NMwx5Pg7caX6wf7qIS8nyfg2HmKHYGNdjVSTOlXEWOhnXq6ZldTwO
         1M8R8L9wx0cBgQT4sMp7Gfi2JnmVFykABA6csoaeHo+0LeQmkjcUmidD+SBxHADWPDm/
         jQX3h+URcK5MsShKDM5NOIbK3Z/IpWvzTyaLFMhhrsjnh+ge7X7UFqbjtVD2iiEk3q9p
         MvkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sEeLyWIWaH8yI5NmJgm9tYs+wDDYp+k6X7WJXQxU9Kk=;
        b=Vj7YdDxsqLg5LuhXBKrajktdGpO+lYWwELDWOBSUmBeoOljORAxkKySd55V/B3fUAV
         J2pTQGosQp8JrBZrKglOoP/oeVrXmsDaht1/20MZ7HdzZam5qXrinOWREBT0U7NZYh2g
         PaGKU1tb9CmCp8CfU6CP7uJ74b1MyHI/Hb/y4f/rLjJjTHni5F9ZMUBxy9MnqHungOel
         RQO7DQvBhHlJMxW7LH0X70NAvyoaj/Wy9RtqJIMxbiuiqqvAUEK6m9WHSt2hY8APwexq
         uxJnoraQt+hWezjN1QkNGnUB9Y7suVQtBQ7NYS3yiWlEfgCJRa6vj/l7Tq6XRkvbOHpt
         xDBQ==
X-Gm-Message-State: APjAAAVvzju1UJ3EnDCs9T6HiCDHn0oLaaJh9UQX71UCKkTRr8/ytiQc
        02HrFX2P097ZcAO/2sbo/oeCLd/UuqQLYRuHBeQ=
X-Google-Smtp-Source: APXvYqwPNxBYMedmrITaWowP1jKt0wA9g6fV5eP/gSDyN6PhXLy/3tJGpG9GvJZbcCZfIuO44nTOnGnSEmpxACLxsHI=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr6798241qty.141.1560793605756;
 Mon, 17 Jun 2019 10:46:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190611044747.44839-1-andriin@fb.com> <20190611044747.44839-3-andriin@fb.com>
 <CAPhsuW6kAN=gMjtXiAJazDFTszuq4xE-9OQTP_GhDX2cxym0NQ@mail.gmail.com> <CAPhsuW5AhXxiRj9x-EWLWy-3Akzh=2y83XxuG2Ma269FjkprrA@mail.gmail.com>
In-Reply-To: <CAPhsuW5AhXxiRj9x-EWLWy-3Akzh=2y83XxuG2Ma269FjkprrA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 17 Jun 2019 10:46:34 -0700
Message-ID: <CAEf4BzZttxRDchhpPY22rV-96_V7Hh512LosNi2prB7zJJz3+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/8] libbpf: extract BTF loading and simplify ELF
 parsing logic
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 1:28 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Sat, Jun 15, 2019 at 1:25 PM Song Liu <liu.song.a23@gmail.com> wrote:
> >
> > On Mon, Jun 10, 2019 at 9:49 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > >
> > > As a preparation for adding BTF-based BPF map loading, extract .BTF and
> > > .BTF.ext loading logic. Also simplify error handling in
> > > bpf_object__elf_collect() by returning early, as there is no common
> > > clean up to be done.
>
> Maybe separate bpf_object__load_btf() and other cleanup in two patches?
> (I won't complain if you keep them together)

Split into two.

>
> Thanks,
> Song
>
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 137 ++++++++++++++++++++++-------------------
> > >  1 file changed, 75 insertions(+), 62 deletions(-)

<snip>
