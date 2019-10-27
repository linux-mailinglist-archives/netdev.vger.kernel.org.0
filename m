Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85408E654A
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 21:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfJ0UMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 16:12:34 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37566 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbfJ0UMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 16:12:34 -0400
Received: by mail-qt1-f194.google.com with SMTP id g50so11619797qtb.4;
        Sun, 27 Oct 2019 13:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xupQM6JMEdEOCvp9UzoLIeIJ9/WCiwtN9ZW91tyEnEA=;
        b=VtlEiJsmciElqosiZmCq/mjr+9yOdcdXXSuWohaFYDO8GPrh/urQTr8xQHQBhWmsAB
         GTtPCM0JFqw2rJ1AyHqSF8AKdVn8ZgS6RPiDMYYjkFCIU5s6Tv6lL5cni9Z7XPpmG0WW
         wd66R2aaLhCiqPCF1Rz/6RR5fkSapprQ6LutJX4e5y7DIybq4mSqQwgdFe8IDDxZTlhb
         m8uERWFpquWEWYdfsGU7gsxqmY2dD6LO1onFrJD/jhBYSQCd8GJHcu0fGtyE9mgVo3Uq
         tO+TwH4pilFWJebolJhvjk3qL9I7RizoiGRjOs2RC6rM7srFjF2AeH5VrHY7jeK9md+z
         sItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xupQM6JMEdEOCvp9UzoLIeIJ9/WCiwtN9ZW91tyEnEA=;
        b=K/G4hzmlsxfRtBGBogRCQtMaROKr/EMhlTz12p7aJ/cSegyexj7RzLQFoCD/7NFvMB
         HBhiNyJmVn0zxyaDum7yVivKZCmPdofr1Q7T97sGmlGSbCNp0Cr5PWrbSmBzwbMCNnQ0
         p4xrI9g+ffQ87nTYwRSMu+XBIbmQEhy262hCOWwyvbLoKG2/l2vLFw3DS07FTbtzk38B
         vydU5/x79BvTH/jVRs08RJcnQO2Q4D8P83ZsYgzkYWVJtgxxY4Z5VZQhdHRxC7xiJcNZ
         zA5RzALfAmJkdCA6Le9t/Ay7V5PZ8f+L8OTwpNhpEBNzpzYkR6EUehxruOL9BfAKJJ3k
         LlSw==
X-Gm-Message-State: APjAAAUsslt5tohjVo/wHSYPjjEPKAmRO8gQvuUM7FCnSH8uYoBubCgp
        HMHWTxQMkZ3L4ynIUodJtbUfudcI65zICv9T+zc=
X-Google-Smtp-Source: APXvYqy0ac0uxBQGsqh38LsQBMxfQdQE6nJ3QcWWk28RYRxVXcIPy8HIikYdevZrshVjNWx2ZGKggtKd30wIWsq5SbM=
X-Received: by 2002:ac8:199d:: with SMTP id u29mr13403733qtj.93.1572207153122;
 Sun, 27 Oct 2019 13:12:33 -0700 (PDT)
MIME-Version: 1.0
References: <157192269744.234778.11792009511322809519.stgit@toke.dk>
 <157192270189.234778.14607584397750494265.stgit@toke.dk> <CAEf4BzbBmm3GfytbEtHwoD71p2XfuxuSYjhbb7rqPwUaYqvk7g@mail.gmail.com>
 <87pniijsx8.fsf@toke.dk>
In-Reply-To: <87pniijsx8.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 27 Oct 2019 13:12:21 -0700
Message-ID: <CAEf4Bzbn-wFJdhn5DCss8J4d7HNpHjUTrGKQqppv+ykjVAqMCA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] libbpf: Add option to auto-pin maps when
 opening BPF object
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 27, 2019 at 5:04 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Thu, Oct 24, 2019 at 6:11 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> With the functions added in previous commits that can automatically pi=
n
> >> maps based on their 'pinning' setting, we can support auto-pinning of =
maps
> >> by the simple setting of an option to bpf_object__open.
> >>
> >> Since auto-pinning only does something if any maps actually have a
> >> 'pinning' BTF attribute set, we default the new option to enabled, on =
the
> >> assumption that seamless pinning is what most callers want.
> >>
> >> When a map has a pin_path set at load time, libbpf will compare the ma=
p
> >> pinned at that location (if any), and if the attributes match, will re=
-use
> >> that map instead of creating a new one. If no existing map is found, t=
he
> >> newly created map will instead be pinned at the location.
> >>
> >> Programs wanting to customise the pinning can override the pinning pat=
hs
> >> using bpf_map__set_pin_path() before calling bpf_object__load().
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >
> > How have you tested this? From reading the code, all the maps will be
> > pinned irregardless of their .pinning setting?
>
> No, build_pin_path() checks map->pinning :)

subtle... build_pin_path() definitely doesn't imply that it's a "maybe
build pin path?", but see below for pin_path setting.

>
> > Please add proper tests to test_progs, testing various modes and
> > overrides.
>
> Can do.
>
> > You keep trying to add more and more knobs :) Please stop doing that,
> > even if we have a good mechanism for extensibility, it doesn't mean we
> > need to increase a proliferation of options.
>
> But I like options! ;)
>
> > Each option has to be tested. In current version of your patches, you
> > have something like 4 or 5 different knobs, do you really want to
> > write tests testing each of them? ;)
>
> Heh, I guess I can cut down the number of options to the number of tests =
:P
>
> > Another high-level feedback. I think having separate passes over all
> > maps (build_map_pin_paths, reuse, then we already have create_maps) is
> > actually making everything more verbose and harder to extend. I'm
> > thinking about all these as sub-steps of map creation. Can you please
> > try refactoring so all these steps are happening per each map in one
> > place: if map needs to be pinned, check if it can be reused, if not -
> > create it. This actually will allow to handle races better, because
> > you will be able to retry easily, while if it's all spread in
> > independent passes, it becomes much harder. Please consider that.
>
> We'll need at least two passes: set pin_path on open, and check reuse /
> create / pin on load. Don't have any objections to consolidating the
> other passes into create_maps; will fix, along with your comments below.

for BTF-defined maps, can't we just set a pin_path right when we are
reading map definition? With that, we won't even need to store
.pinning field. Would that work?

>
> -Toke
