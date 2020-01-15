Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1134D13CFD5
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgAOWKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:10:09 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44192 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729203AbgAOWKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 17:10:08 -0500
Received: by mail-lj1-f196.google.com with SMTP id u71so20263470lje.11;
        Wed, 15 Jan 2020 14:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Daw8rroguTTwo1dHrJV6J5E7u5lhzY+MHJz6rMDPfs=;
        b=HaWMAk+v5hSFyw6J0JOYGjkt4PLXTcB9Ol0Jl+j+IvIZL05WyFamc3qXvQMrXNpga9
         SjVedmjpkjGs2SDPZ1ZOtuiJkn9iRu8UVCrW/pmIjBROOfP+tD/3TzeEYnXoVkN43Qqr
         55/+HApqZjT+MKrH8Ut6c//Is3EF6FCpkRfktQ+Xi2e493B6Cv426Jk7o9e00BBYT+HN
         2qkIFKHtD0CoM1wtnjcaDwiyTWOaeIzquMRbgcEZQPNIg+kn9/K75QUxD8upDnh5BB3y
         PL7w0Y0NbSJe+vZ1Lb4YmWtznXlTFx4kEA1lX0tROpsit/9YO1y9HWBaPjKr4RgcNZTP
         XG1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Daw8rroguTTwo1dHrJV6J5E7u5lhzY+MHJz6rMDPfs=;
        b=DirTicyDPfPWeE7frLvBqlOu19I7dWA28rz73WOSEO3pEVr14NH0uEFVDUomiyP52b
         d5jBU0oRHVwdu5fOCwtCSj2E9yFdkHkKAZ2cPGVBJZfEYHonCPFYyS66WDsjqIMkPzZM
         Smg/jr3wv9VCPS9mhZwkvd5wun8Bmm99HVbAnksvnzGIRP7qX0GpmobOv48kbAUPdqrP
         A4aDQ08rlevj/rmlRdAeu/o8FOo9VZ7dSSAVuNs2KgIkTqUQdNkIMNdE+ckgyb2rMurF
         y+4EgAbsxEQk6ohkocGmYyLvhYWMqYo6aMU7svwfXCZxz9o1Zj6C5ngeDHlIGvXMZoDN
         SfKQ==
X-Gm-Message-State: APjAAAUoOszcL8WwpzyCn3HzrlJv03Fnou8cZH30qgUCUZgCFMr9leiS
        qHcXa9eG6BeZlPb9XNQJwXTgo+ufwyhKgW0ZEl0=
X-Google-Smtp-Source: APXvYqzuZcfQxHGqhbLZO8OFGaRgCwwVeLpLhbttjmN5MCmZQ7M5gG+m4GAyZTXAUYjnlw0peH/6IJO+on+P/qQNe2s=
X-Received: by 2002:a2e:b55c:: with SMTP id a28mr311117ljn.260.1579126205990;
 Wed, 15 Jan 2020 14:10:05 -0800 (PST)
MIME-Version: 1.0
References: <20200115184308.162644-1-brianvv@google.com> <0ed19302-a43c-c04e-110e-eb1f0a72146f@fb.com>
In-Reply-To: <0ed19302-a43c-c04e-110e-eb1f0a72146f@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 15 Jan 2020 14:09:54 -0800
Message-ID: <CAADnVQK5sBx7PFwqMGZi_6+6xFZQoE9deTujL4ewNBQzOi1q6Q@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/9] add bpf batch ops to process more than 1 elem
To:     Yonghong Song <yhs@fb.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 12:13 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 1/15/20 10:42 AM, Brian Vazquez wrote:
> > This patch series introduce batch ops that can be added to bpf maps to
> > lookup/lookup_and_delete/update/delete more than 1 element at the time,
> > this is specially useful when syscall overhead is a problem and in case
> > of hmap it will provide a reliable way of traversing them.
> >
> > The implementation inclues a generic approach that could potentially be
> > used by any bpf map and adds it to arraymap, it also includes the specific
> > implementation of hashmaps which are traversed using buckets instead
> > of keys.
> >
> > The bpf syscall subcommands introduced are:
> >
> >    BPF_MAP_LOOKUP_BATCH
> >    BPF_MAP_LOOKUP_AND_DELETE_BATCH
> >    BPF_MAP_UPDATE_BATCH
> >    BPF_MAP_DELETE_BATCH
> >
> > The UAPI attribute is:
> >
> >    struct { /* struct used by BPF_MAP_*_BATCH commands */
> >           __aligned_u64   in_batch;       /* start batch,
> >                                            * NULL to start from beginning
> >                                            */
> >           __aligned_u64   out_batch;      /* output: next start batch */
> >           __aligned_u64   keys;
> >           __aligned_u64   values;
> >           __u32           count;          /* input/output:
> >                                            * input: # of key/value
> >                                            * elements
> >                                            * output: # of filled elements
> >                                            */
> >           __u32           map_fd;
> >           __u64           elem_flags;
> >           __u64           flags;
> >    } batch;
> >
> >
> > in_batch and out_batch are only used for lookup and lookup_and_delete since
> > those are the only two operations that attempt to traverse the map.
> >
> > update/delete batch ops should provide the keys/values that user wants
> > to modify.
> >
> > Here are the previous discussions on the batch processing:
> >   - https://lore.kernel.org/bpf/20190724165803.87470-1-brianvv@google.com/
> >   - https://lore.kernel.org/bpf/20190829064502.2750303-1-yhs@fb.com/
> >   - https://lore.kernel.org/bpf/20190906225434.3635421-1-yhs@fb.com/
> >
> > Changelog sinve v4:
> >   - Remove unnecessary checks from libbpf API (Andrii Nakryiko)
> >   - Move DECLARE_LIBBPF_OPTS with all var declarations (Andrii Nakryiko)
> >   - Change bucket internal buffer size to 5 entries (Yonghong Song)
> >   - Fix some minor bugs in hashtab batch ops implementation (Yonghong Song)
> >
> > Changelog sinve v3:
> >   - Do not use copy_to_user inside atomic region (Yonghong Song)
> >   - Use _opts approach on libbpf APIs (Andrii Nakryiko)
> >   - Drop generic_map_lookup_and_delete_batch support
> >   - Free malloc-ed memory in tests (Yonghong Song)
> >   - Reverse christmas tree (Yonghong Song)
> >   - Add acked labels
> >
> > Changelog sinve v2:
> >   - Add generic batch support for lpm_trie and test it (Yonghong Song)
> >   - Use define MAP_LOOKUP_RETRIES for retries (John Fastabend)
> >   - Return errors directly and remove labels (Yonghong Song)
> >   - Insert new API functions into libbpf alphabetically (Yonghong Song)
> >   - Change hlist_nulls_for_each_entry_rcu to
> >     hlist_nulls_for_each_entry_safe in htab batch ops (Yonghong Song)
> >
> > Changelog since v1:
> >   - Fix SOB ordering and remove Co-authored-by tag (Alexei Starovoitov)
> >
> > Changelog since RFC:
> >   - Change batch to in_batch and out_batch to support more flexible opaque
> >     values to iterate the bpf maps.
> >   - Remove update/delete specific batch ops for htab and use the generic
> >     implementations instead.
> >
> > Brian Vazquez (5):
> >    bpf: add bpf_map_{value_size,update_value,map_copy_value} functions
> >    bpf: add generic support for lookup batch op
> >    bpf: add generic support for update and delete batch ops
> >    bpf: add lookup and update batch ops to arraymap
> >    selftests/bpf: add batch ops testing to array bpf map
> >
> > Yonghong Song (4):
> >    bpf: add batch ops to all htab bpf map
> >    tools/bpf: sync uapi header bpf.h
> >    libbpf: add libbpf support to batch ops
> >    selftests/bpf: add batch ops testing for htab and htab_percpu map
> >
> >   include/linux/bpf.h                           |  18 +
> >   include/uapi/linux/bpf.h                      |  21 +
> >   kernel/bpf/arraymap.c                         |   2 +
> >   kernel/bpf/hashtab.c                          | 264 +++++++++
> >   kernel/bpf/syscall.c                          | 554 ++++++++++++++----
> >   tools/include/uapi/linux/bpf.h                |  21 +
> >   tools/lib/bpf/bpf.c                           |  58 ++
> >   tools/lib/bpf/bpf.h                           |  22 +
> >   tools/lib/bpf/libbpf.map                      |   4 +
> >   .../bpf/map_tests/array_map_batch_ops.c       | 129 ++++
> >   .../bpf/map_tests/htab_map_batch_ops.c        | 283 +++++++++
> >   11 files changed, 1248 insertions(+), 128 deletions(-)
> >   create mode 100644 tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
> >   create mode 100644 tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c
>
> Thanks for the work! LGTM. Ack for the whole series.
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied. Thanks!
