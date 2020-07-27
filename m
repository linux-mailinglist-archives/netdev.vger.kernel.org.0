Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60FD22FBC3
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 00:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgG0WCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 18:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgG0WCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 18:02:30 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B729C061794;
        Mon, 27 Jul 2020 15:02:30 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id l6so16840131qkc.6;
        Mon, 27 Jul 2020 15:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p7qPUX9AfSEfT/d5vE+RQ31eLoNG6DmwgKTcfsE/tv0=;
        b=ooVItlrKRIwt6CQxq6+yqfNDx2ZKjsCzJ0oO6zQYS3QRlE4uediO7HnVEfViW8QgO2
         ho+SP2AtBj1sgmMnjwqb3yw03/8nEnOUqXVC/Dai05Vxskr/FOLwk2ao5qLuMkqLQISP
         DsWY0RNAnbdDfNJ7q4IAYo8h5MsRsoXkZ3QpOjrSlNG9UwmDySR6VH2v1iAAVM+gpubE
         BnpoohhvaliTy0VXRV3OPKRcew4siyYMkaX/efXu3OXgqeW8/pCJx0EAdntDIiRDGurb
         cOZPcfQOlEOzBqXm7mKUq/+llsxAzbkNP0+MJnpI8VqmU+QlBP25VYT5q/UCBuebvz2f
         gWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p7qPUX9AfSEfT/d5vE+RQ31eLoNG6DmwgKTcfsE/tv0=;
        b=SfYtBwdO3NIzPkiBtfrdoEaw8qQDBIngnD6jAk4dAhsMpOzxy2MPjv3vvzUTIoTaGw
         GtUy37XNR9OQ1j+jYvfAwTP9MEkO51OArtKtpV1YACVTE0b1U8QmKxuTtUUoU6ZUBpzI
         0IguxAyijXPg3veFtGpo9Foh7OfeBse3Le9MNUVAXs2unVlwUw15BzcQfSrn7HmvwZ+m
         PD5QLOQsGGYH7fIfoq4AIcAYoEdgG+fZ04XWe7RFMai43TOjFdovgf9ttzmbJLUxMA4D
         SYN+8tBuofJG7Bb3lJCd9m8iMi2Om2A2TrPjcasPGNqwL2iNmN3BegXC2CnKMFythjKB
         vWGw==
X-Gm-Message-State: AOAM530QvZ/7NEMBUkCGwbVsILenKcPa3nYDtJLUHJywZh/cP6wc6CSi
        ygGYu6w/vQYzYcq0tK0aAiC56QKDyGqEbr14bp4=
X-Google-Smtp-Source: ABdhPJyWyfuPBwNsMps1LLop+y20zsQpyxDvUoMkGhTqJWIfW/Be4ldA+NNa7zLpBIO81ZWCxn+A8EcNrKYmi4CVwyk=
X-Received: by 2002:a37:2c45:: with SMTP id s66mr26380618qkh.449.1595887349398;
 Mon, 27 Jul 2020 15:02:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200724011700.2854734-1-andriin@fb.com> <20200724011700.2854734-2-andriin@fb.com>
 <CAPhsuW68tUDQf7kgB-r5aJFH3Bk_5_b_0eokqjYe9-8YpHX3zg@mail.gmail.com>
In-Reply-To: <CAPhsuW68tUDQf7kgB-r5aJFH3Bk_5_b_0eokqjYe9-8YpHX3zg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jul 2020 15:02:18 -0700
Message-ID: <CAEf4BzZUN-kH8LzPp76BHW-8iBX=QUKCHmpxid0hxapbZ6t9rw@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: extend map-in-map selftest to
 detect memory leaks
To:     Song Liu <song@kernel.org>
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

On Mon, Jul 27, 2020 at 1:53 PM Song Liu <song@kernel.org> wrote:
>
> On Thu, Jul 23, 2020 at 6:17 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Add test validating that all inner maps are released properly after skeleton
> > is destroyed. To ensure determinism, trigger kernel-size synchronize_rcu()
> > before checking map existence by their IDs.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  .../selftests/bpf/prog_tests/btf_map_in_map.c | 104 +++++++++++++++---
> >  1 file changed, 91 insertions(+), 13 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> > index f7ee8fa377ad..043e8ffe03d1 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> > @@ -5,10 +5,50 @@
> >
> >  #include "test_btf_map_in_map.skel.h"
> >
> > +static int duration;
> > +
> > +int bpf_map_id(struct bpf_map *map)
> Should this return __u32?

yeah, probably, will change

>
> > +{
> > +       struct bpf_map_info info;
> > +       __u32 info_len = sizeof(info);
> > +       int err;
> > +
> > +       memset(&info, 0, info_len);
> > +       err = bpf_obj_get_info_by_fd(bpf_map__fd(map), &info, &info_len);
> > +       if (err)
> > +               return 0;
> > +       return info.id;
> > +}
> > +
> > +int kern_sync_rcu() {
>
> int kern_sync_rcu(void)
> {
> ...
>
> A comment for this function would be nice too.

Sure.

>
> > +       int inner_map_fd, outer_map_fd, err, zero = 0;
> > +
> > +       inner_map_fd = bpf_create_map(BPF_MAP_TYPE_ARRAY, 4, 4, 1, 0);
> > +       if (CHECK(inner_map_fd < 0, "inner_map_create", "failed %d\n", -errno))
> > +               return -1;
> > +
> > +       outer_map_fd = bpf_create_map_in_map(BPF_MAP_TYPE_ARRAY_OF_MAPS, NULL,
> > +                                            sizeof(int), inner_map_fd, 1, 0);
> > +       if (CHECK(outer_map_fd < 0, "outer_map_create", "failed %d\n", -errno)) {
> > +               close(inner_map_fd);
> > +               return -1;
> > +       }
> > +
> > +       err = bpf_map_update_elem(outer_map_fd, &zero, &inner_map_fd, 0);
> > +       if (err)
> > +               err = -errno;
> > +       CHECK(err, "outer_map_update", "failed %d\n", err);
> > +       close(inner_map_fd);
> > +       close(outer_map_fd);
> > +       return err;
> > +}
> > +
> >  void test_btf_map_in_map(void)
> >  {
> > -       int duration = 0, err, key = 0, val;
> > +       int err, key = 0, val, i;
> >         struct test_btf_map_in_map* skel;
> > +       int outer_arr_fd, outer_hash_fd;
> > +       int fd, map1_fd, map2_fd, map1_id, map2_id;
> nit: reverse Christmas tree.

We don't enforce that and it hasn't been a requirement for a long
time. It's better to minimize a code churn rather than preserving
pretty line ordering.


>
> >
> >         skel = test_btf_map_in_map__open_and_load();
> >         if (CHECK(!skel, "skel_open", "failed to open&load skeleton\n"))
> > @@ -18,32 +58,70 @@ void test_btf_map_in_map(void)
> >         if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
> >                 goto cleanup;
> >

[...]
