Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 342823A40E
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 08:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfFIGwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 02:52:40 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43645 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfFIGwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 02:52:39 -0400
Received: by mail-qt1-f194.google.com with SMTP id z24so546638qtj.10
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 23:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/nmJUSdK6VIlAECS9kwIeH9I0bVe4ZWCQIHHy6GIY2k=;
        b=MncpmTyrepDkUH39SNRZniPxWcJcOMxZJyOdM68O4HWCnjDfakShcu5b1DU8SUkodX
         CyEVbldaZDqShmQ0dcdXCNQHzZYd4QnlcN6wWhaWComPiw5kmCkeifRWWSiS+0/J/lis
         gDhTV4047YOuN37lUMVfHS9MiI3Z1MRe5GVUcgEDnU8gUwkmmHGcWZ27c68f949cv+DW
         WbPDus7glcPMGKYsSSlt1Xi9WPYKJfleqOnwVBxWaiucgaVrjonVBTjofLq6S2KdzGjw
         lqRxHM4Z0j722BeA3BwwF2wr6mFmIGqlSdGR761PKI/qun9nh/l4uPxnfX5GlFfTJgN8
         vtwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/nmJUSdK6VIlAECS9kwIeH9I0bVe4ZWCQIHHy6GIY2k=;
        b=jxoa7TAVJLMVorwXObychtX2o2QE/Cv3ClFyoF/4WukkEG7oF/t3l7FcibtB8TCmXM
         BdsObPzS32DpwcueNXxa6n7VTnQLLnBekVoJQprUOVP2Q378ht8KsQbaJIOY5dI4xnih
         df2HSWSt511/2gec5+IZwomi2hbhQlE093ULFxvZjhZDU6C8jtZpbrrZdZ+pPTpncNEi
         qxMooLQsIEwueMvOuq4euNwLeGjEPiCrSoadpxUZiZ4hH24xcJRXkhnFAu9fbKgX0pup
         AlSsLzn5+GBaqYHq8MgaekI5VBppCvTRcinBd6NLFe4R3W7UNKAtYKXQOQKspQjQ5OCh
         dh1Q==
X-Gm-Message-State: APjAAAVN+E4pUII9y9Lgx7tIl8LQbKqShSklmW4u064gln6d5zqxSrV5
        b4Z9O2zV3P88yBrxaYKJeitKOfmetbGHXSEcXKs=
X-Google-Smtp-Source: APXvYqyn8SyiyDYJQr23QLwDic2ApInTuuazlvMHtQv1a+CoHiLpsVP8Z0e/YffD+zU04bWitQ3qSGYZvoL9Gmp3yAg=
X-Received: by 2002:ac8:4442:: with SMTP id m2mr31921788qtn.107.1560063158862;
 Sat, 08 Jun 2019 23:52:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190606205943.818795-1-jonathan.lemon@gmail.com>
In-Reply-To: <20190606205943.818795-1-jonathan.lemon@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sun, 9 Jun 2019 08:52:25 +0200
Message-ID: <CAJ+HfNgL56oxWUM7qGxyQOH0AyKjYJWu6z=77xcMw7K+iqZ0WQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/4] Better handling of xskmap entries
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jun 2019 at 00:30, Jonathan Lemon <jonathan.lemon@gmail.com> wrot=
e:
>
> Currently, the AF_XDP code uses a separate map in order to
> determine if an xsk is bound to a queue.  Have the xskmap
> lookup return a XDP_SOCK pointer on the kernel side, which
> the verifier uses to extract relevant values.
>

Very nice! Thanks for doing this, Jonathan.

Again, for the series:

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> Patches:
>  1 - adds XSK_SOCK type
>  2 - sync bpf.h with tools
>  3 - add tools selftest
>  4 - update lib/bpf, removing qidconf
>
> v4->v5:
>  - xskmap lookup now returns XDP_SOCK type instead of pointer to element.
>  - no changes lib/bpf/xsk.c
>
> v3->v4:
>  - Clarify error handling path.
>
> v2->v3:
>  - Use correct map type.
>
> Jonathan Lemon (4):
>   bpf: Allow bpf_map_lookup_elem() on an xskmap
>   bpf/tools: sync bpf.h
>   tools/bpf: Add bpf_map_lookup_elem selftest for xskmap
>   libbpf: remove qidconf and better support external bpf programs.
>
>  include/linux/bpf.h                           |   8 ++
>  include/net/xdp_sock.h                        |   4 +-
>  include/uapi/linux/bpf.h                      |   4 +
>  kernel/bpf/verifier.c                         |  26 ++++-
>  kernel/bpf/xskmap.c                           |   7 ++
>  net/core/filter.c                             |  40 +++++++
>  tools/include/uapi/linux/bpf.h                |   4 +
>  tools/lib/bpf/xsk.c                           | 103 +++++-------------
>  .../bpf/verifier/prevent_map_lookup.c         |  15 ---
>  tools/testing/selftests/bpf/verifier/sock.c   |  18 +++
>  10 files changed, 135 insertions(+), 94 deletions(-)
>
> --
> 2.17.1
>
