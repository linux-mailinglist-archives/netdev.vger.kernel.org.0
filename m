Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E7929AD5C
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 14:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752145AbgJ0Nc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 09:32:56 -0400
Received: from mx.der-flo.net ([193.160.39.236]:45338 "EHLO mx.der-flo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752128AbgJ0Ncy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 09:32:54 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Oct 2020 09:32:53 EDT
Received: by mx.der-flo.net (Postfix, from userid 110)
        id D349F442C1; Tue, 27 Oct 2020 14:26:30 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mx.der-flo.net
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=4.0 tests=ALL_TRUSTED,SORTED_RECIPS
        autolearn=no autolearn_force=no version=3.4.2
Received: from localhost (unknown [IPv6:2a02:1203:ecb0:3930:1751:4157:4d75:a5e2])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.der-flo.net (Postfix) with ESMTPSA id 35558442C1;
        Tue, 27 Oct 2020 14:25:53 +0100 (CET)
Date:   Tue, 27 Oct 2020 14:25:42 +0100
From:   Florian Lehner <dev@der-flo.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        dev@der-flo.net, john.fastabend@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3] bpf: Lift hashtab key_size limit
Message-ID: <20201027132542.GA2902@der-flo.net>
References: <20201024080541.51683-1-dev@der-flo.net>
 <CAEf4BzY-bNN7fx2eAvRBq89pDHptEqoftgSSF=0dv_GgeNACvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEf4BzY-bNN7fx2eAvRBq89pDHptEqoftgSSF=0dv_GgeNACvw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 04:07:58PM -0700, Andrii Nakryiko wrote:
> >
> > Signed-off-by: Florian Lehner <dev@der-flo.net>
> > ---
> 
> You dropped the ack from John, btw.

I was not sure if it is ok to keep the ACK for an updated patch. So I
did not include it.

> >  kernel/bpf/hashtab.c                          | 16 +++----
> >  .../selftests/bpf/prog_tests/hash_large_key.c | 28 ++++++++++++
> >  .../selftests/bpf/progs/test_hash_large_key.c | 45 +++++++++++++++++++
> >  tools/testing/selftests/bpf/test_maps.c       |  2 +-
> >  4 files changed, 79 insertions(+), 12 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/hash_large_key.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_hash_large_key.c
> >
> > diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> > index 1815e97d4c9c..10097d6bcc35 100644
> > --- a/kernel/bpf/hashtab.c
> > +++ b/kernel/bpf/hashtab.c
> > @@ -390,17 +390,11 @@ static int htab_map_alloc_check(union bpf_attr *attr)
> >             attr->value_size == 0)
> >                 return -EINVAL;
> >
> > -       if (attr->key_size > MAX_BPF_STACK)
> > -               /* eBPF programs initialize keys on stack, so they cannot be
> > -                * larger than max stack size
> > -                */
> > -               return -E2BIG;
> > -
> > -       if (attr->value_size >= KMALLOC_MAX_SIZE -
> > -           MAX_BPF_STACK - sizeof(struct htab_elem))
> > -               /* if value_size is bigger, the user space won't be able to
> > -                * access the elements via bpf syscall. This check also makes
> > -                * sure that the elem_size doesn't overflow and it's
> > +       if ((attr->key_size + attr->value_size) >= KMALLOC_MAX_SIZE -
> 
> key_size+value_size can overflow, can't it? So probably want to cast
> to (size_t) or __u64?
> 

I will add this cast to u64.

> > +           sizeof(struct htab_elem))
> > +               /* if key_size + value_size is bigger, the user space won't be
> > +                * able to access the elements via bpf syscall. This check
> > +                * also makes sure that the elem_size doesn't overflow and it's
> >                  * kmalloc-able later in htab_map_update_elem()
> >                  */
> >                 return -E2BIG;
> > diff --git a/tools/testing/selftests/bpf/prog_tests/hash_large_key.c b/tools/testing/selftests/bpf/prog_tests/hash_large_key.c
> > new file mode 100644
> > index 000000000000..962f56060b76
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/hash_large_key.c
> > @@ -0,0 +1,28 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +// Copyright (c) 2020 Florian Lehner
> > +
> > +#include <test_progs.h>
> > +
> > +void test_hash_large_key(void)
> > +{
> > +       const char *file = "./test_hash_large_key.o";
> > +       int prog_fd, map_fd[2];
> > +       struct bpf_object *obj = NULL;
> > +       int err = 0;
> > +
> > +       err = bpf_prog_load(file, BPF_PROG_TYPE_CGROUP_SKB, &obj, &prog_fd);
> 
> Please utilize the BPF skeleton in the new tests.
> 

I will update the test and utilize the BPF skeleton.

> > +       if (CHECK_FAIL(err)) {
> > +               printf("test_hash_large_key: bpf_prog_load errno %d", errno);
> > +               goto close_prog;
> > +       }
> > +
> > +       map_fd[0] = bpf_find_map(__func__, obj, "hash_map");
> > +       if (CHECK_FAIL(map_fd[0] < 0))
> > +               goto close_prog;
> > +       map_fd[1] = bpf_find_map(__func__, obj, "key_map");
> > +       if (CHECK_FAIL(map_fd[1] < 0))
> > +               goto close_prog;
> 
> You are not really checking much here.
> 
> Why don't you check that the value was set to 42 here? Consider also
> using big global variables as your key and value. You can specify them
> from user-space with BPF skeleton easily to any custom value (not just
> zeroes).
> 
> 
> > +
> > +close_prog:
> > +       bpf_object__close(obj);
> > +}
> 
> [...]
