Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA9827216
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 00:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfEVWOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 18:14:05 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37728 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727269AbfEVWOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 18:14:05 -0400
Received: by mail-qt1-f196.google.com with SMTP id o7so4426999qtp.4;
        Wed, 22 May 2019 15:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6v5ZNf+eM3rr/ZvYNB7ePCdQNiBWhUlLdtbZnWmsYV0=;
        b=KUZSWPIXZBWenGsoO+okfQnoVWHiWghlht30mYlXHu9YXNwRPrOrYCSBkrj5LRIFFN
         hNWPmwuZ0cPAshLnjiJsKiYTtJ7TpXX7WmczuBikwedUS58RRyljL6qg6D6w9z5DJCF4
         gdosCXLJuSbgvbbLg7VhbZUD8iXIcmKJnl3UeCh769tFHo5yd8Qk3Geit1TPCWcomdPJ
         ZkM/yyYhjdHYbbPOXu/157jkittGY83bVaEiTiSGMuvoELwqTraS7KEy54GDyBz3i8gZ
         na7o2SYjC/3cR1cCs1ZtQDsHLC3XhGqdLtolXUahokAN3tWvWh9+FsgkD20rgLK6wGWF
         5YGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6v5ZNf+eM3rr/ZvYNB7ePCdQNiBWhUlLdtbZnWmsYV0=;
        b=Q9lsqliqO20rjJS/VC4cf8iPg0S86NKhEldiHKLeBAkk0AkOoma7Hl8XQ0XQdBfuxB
         uMig9nEJvqmfsFHxsw9GmxA2HUufpK6ViNdK1Dgd0iAwRzlQ12QNp5D7PmriMWitdHb9
         T90LKn59hVT3DWkgS5Xy9vuxi031A1hl40CXzeyiNNqs5XCKFnKtIrZanvYYv7nY3e9o
         FDeCwyqaWz2LGjlXzmaqFvCetQOAOVfV0DsoSADyLN6n76djC9U9QIk0Dk7eEqaBYQlM
         O3tErNkZblhiGapBDagy77vGI6Mfkkh53/MJ3FBBGVP1GMg7E94JZ7sedFKq/yVggY3T
         YG/g==
X-Gm-Message-State: APjAAAXdSySdo20InAAfAyOcrQOQeK4gq91mZUXUmc+TkcaB3NK0c3Pu
        bmi93Gc8M+vfKm+pHyI92UTqGNbnO8HLxs8eLS4=
X-Google-Smtp-Source: APXvYqy8+K2+PfNHGAVENI3jNl0h8clZoNcOHf4SImy580BlRq5IxtA8YK74PTkY2Y0YfM57v3JqdFJWSkuz1LZ4aMw=
X-Received: by 2002:ac8:30d3:: with SMTP id w19mr75006726qta.171.1558563244163;
 Wed, 22 May 2019 15:14:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190522195053.4017624-1-andriin@fb.com> <20190522195053.4017624-6-andriin@fb.com>
 <20190522203032.GO10244@mini-arch>
In-Reply-To: <20190522203032.GO10244@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 May 2019 15:13:53 -0700
Message-ID: <CAEf4BzZi6A1vcFUFdwSQrbag_ptoU9+imdWhHdVKCLB8yvPSTw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 05/12] libbpf: add resizable non-thread safe
 internal hashmap
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 1:30 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 05/22, Andrii Nakryiko wrote:
> > There is a need for fast point lookups inside libbpf for multiple use
> > cases (e.g., name resolution for BTF-to-C conversion, by-name lookups in
> > BTF for upcoming BPF CO-RE relocation support, etc). This patch
> > implements simple resizable non-thread safe hashmap using single linked
> > list chains.
> Didn't really look into the details, but any reason you're not using
> linux/hashtable.h? It's exported in tools/include and I think perf
> is using it. It's probably not resizable, but should be easy to
> implement rebalancing on top of it.

There are multiple reasons.
1. linux/hashtable.h is pretty bare-bones, it's just hlist_node and a
bunch of macro to manipulate array or chains of them. I wanted to have
higher-level API with lookup by key, insertion w/ various strategies,
etc. Preferrably one not requiring to manipulate hlist_node directly
as part of its API, even if at some performance cost of hiding that
low-level detail.
2. Resizing is a big chunk of resizable hashmap logic, so I'd need to
write a bunch of additional code anyway.
3. Licensing. linux/hashtable.h is under GPL, while libbpf is
dual-licensed under GPL and BSD. When syncing libbpf from kernel to
github, we have to re-implement all the parts from kernel that are not
under BSD license anyway.
4. hlist_node keeps two pointers per item, which is unnecessary for
hashmap which does deletion by key (by searching for node first, then
deleting), so we can also have lower memory overhead per entry.

So in general, I feel like there is little benefit to reusing
linux/hashlist.h for use cases I'm targeting this hashmap for.

>
> > Four different insert strategies are supported:
> >  - HASHMAP_ADD - only add key/value if key doesn't exist yet;
> >  - HASHMAP_SET - add key/value pair if key doesn't exist yet; otherwise,
> >    update value;
> >  - HASHMAP_UPDATE - update value, if key already exists; otherwise, do
> >    nothing and return -ENOENT;
> >  - HASHMAP_APPEND - always add key/value pair, even if key already exists.
> >    This turns hashmap into a multimap by allowing multiple values to be
> >    associated with the same key. Most useful read API for such hashmap is
> >    hashmap__for_each_key_entry() iteration. If hashmap__find() is still
> >    used, it will return last inserted key/value entry (first in a bucket
> >    chain).
> >
> > For HASHMAP_SET and HASHMAP_UPDATE, old key/value pair is returned, so
> > that calling code can handle proper memory management, if necessary.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/Build     |   2 +-
> >  tools/lib/bpf/hashmap.c | 229 ++++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/hashmap.h | 173 ++++++++++++++++++++++++++++++
> >  3 files changed, 403 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/lib/bpf/hashmap.c
> >  create mode 100644 tools/lib/bpf/hashmap.h
> >
> >
