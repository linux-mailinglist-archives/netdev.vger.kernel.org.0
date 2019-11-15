Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAF93FE8A1
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 00:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfKOX2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 18:28:10 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44949 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfKOX2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 18:28:10 -0500
Received: by mail-qk1-f193.google.com with SMTP id m16so9486509qki.11;
        Fri, 15 Nov 2019 15:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Kxl0NCmx96CQwbKlbO5u7GOr2Xfl/IStj54xSMPDjA=;
        b=h3/0tVyDrLC02W/xMP5WmjA+y0Itw9N1seCs6W2lE4BrNhtzkrhLlxFKf2pp2dDTcy
         dAV92h6751tjxYIWL6fY/ytigu5XZK9fHvMrviE6PVyPinGdyyKgieB3O00t40Uy1D/k
         /bfwIwJUqt2vHmJGQs6Maqbbxl73GJM9jLHhEapcR0+T8HKIP/Kl3CJFQ2rBHtzkB6oB
         BEb4ASc+OilnqNNSR2WB/GUneIJxinTvqHC5Oo8P1IlhHSBVO0TtRNxOOXGySVUBgVr+
         ACv47P6lkaLxU9ll1jvJ5r3l08Kpbo50pUrkdYUxXCFDmxt1KKzwplysBUtkeua9f3iO
         DQBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Kxl0NCmx96CQwbKlbO5u7GOr2Xfl/IStj54xSMPDjA=;
        b=S4rUN8v8xUxMUV8tcUGtz7VHn5VpD1Ml+77GhfYpXmnkGi86wxEBlkvFnfy5PIp91T
         cLmDjXOi7j5cZq+qU+o9HJtFQKtkm6eGTwGBBpl7b6p1Qcl3EMrLscmL5G9XiH/s+t36
         YI17PGPtd+o/If11rG5nE8L91ufC6/F54+GGqAr9vTQMVmAlRJihmXyQEivr/GDRnGSG
         HUZ5il3RpwCwhYsOlAkhfJR9HhvlVeV1KnERYQg4YGjaHS0KxEjzGb4U7wlVgepXFkox
         qHS+RCQXtQAU6Nh52qnfckZehsjYvUjNAQDRq2uhEJ4zZQwzrq1ODZ5NxWj/SRh0Fvf+
         Mf5Q==
X-Gm-Message-State: APjAAAVxbtj3HV3OwwP07e8zJDhpNEZp/ltOWjKB2tdBdIHugcZlJF+V
        8mSpP+OsBSrIyjqM+HO1hlKTSryjCAlxrhjxa8k=
X-Google-Smtp-Source: APXvYqxunHoF4P8z/MqBkLqxv1bSNAxdraTKesqIinJolBAcjhRIzcMBWywJpB3O+xbLQMdN23tI6A/V8+O4GJ2sBdM=
X-Received: by 2002:a05:620a:1011:: with SMTP id z17mr15097774qkj.39.1573860489263;
 Fri, 15 Nov 2019 15:28:09 -0800 (PST)
MIME-Version: 1.0
References: <20191115040225.2147245-1-andriin@fb.com> <20191115040225.2147245-2-andriin@fb.com>
 <7032bc3c-9375-876d-8d97-1ed21e94ae92@iogearbox.net>
In-Reply-To: <7032bc3c-9375-876d-8d97-1ed21e94ae92@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 Nov 2019 15:27:58 -0800
Message-ID: <CAEf4Bzagc7ZdbLGbeCfQ_9qwbXwaKztHqZN3Vfb_EpVf8gN1dg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/4] bpf: switch bpf_map ref counter to 64bit
 so bpf_map_inc never fails
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 15, 2019 at 3:24 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/15/19 5:02 AM, Andrii Nakryiko wrote:
> > 92117d8443bc ("bpf: fix refcnt overflow") turned refcounting of bpf_map into
> > potentially failing operation, when refcount reaches BPF_MAX_REFCNT limit
> > (32k). Due to using 32-bit counter, it's possible in practice to overflow
> > refcounter and make it wrap around to 0, causing erroneous map free, while
> > there are still references to it, causing use-after-free problems.
>
> You mention 'it's possible in practice' to overflow in relation to bpf map
> refcount, do we need any fixing for bpf tree here?

I meant without existing 32k limit. With limit we currently have, no,
we'll just fail bpf_map_inc instead. So no need to do anything about
bpf tree.

>
> > But having a failing refcounting operations are problematic in some cases. One
> > example is mmap() interface. After establishing initial memory-mapping, user
> > is allowed to arbitrarily map/remap/unmap parts of mapped memory, arbitrarily
> > splitting it into multiple non-contiguous regions. All this happening without
> > any control from the users of mmap subsystem. Rather mmap subsystem sends
> > notifications to original creator of memory mapping through open/close
> > callbacks, which are optionally specified during initial memory mapping
> > creation. These callbacks are used to maintain accurate refcount for bpf_map
> > (see next patch in this series). The problem is that open() callback is not
> > supposed to fail, because memory-mapped resource is set up and properly
> > referenced. This is posing a problem for using memory-mapping with BPF maps.
> >
> > One solution to this is to maintain separate refcount for just memory-mappings
> > and do single bpf_map_inc/bpf_map_put when it goes from/to zero, respectively.
> > There are similar use cases in current work on tcp-bpf, necessitating extra
> > counter as well. This seems like a rather unfortunate and ugly solution that
> > doesn't scale well to various new use cases.
> >
> > Another approach to solve this is to use non-failing refcount_t type, which
> > uses 32-bit counter internally, but, once reaching overflow state at UINT_MAX,
> > stays there. This utlimately causes memory leak, but prevents use after free.
> >

[...]

> >
> > +/* prog's refcnt limit */
> > +#define BPF_MAX_REFCNT 32768
> > +
>
> Would it make sense in this context to also convert prog refcount over to atomic64
> so we have both in one go in order to align them again? This could likely simplify
> even more wrt error paths.
>

Yes, of course, I was just trying to minimize amount of changes, but I
can go and do the same for prog refcnt.

> >   struct bpf_prog *bpf_prog_add(struct bpf_prog *prog, int i)
> >   {
> >       if (atomic_add_return(i, &prog->aux->refcnt) > BPF_MAX_REFCNT) {
