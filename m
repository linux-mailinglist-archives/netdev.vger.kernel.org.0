Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40FF655E34
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 04:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbfFZCTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 22:19:09 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37104 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbfFZCTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 22:19:09 -0400
Received: by mail-qt1-f195.google.com with SMTP id y57so756300qtk.4;
        Tue, 25 Jun 2019 19:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X4NAySBY1O56X8ZQvRrmtff7Avwv2E7wobqj17OL218=;
        b=Vm8BfQU5DOriwXitLqr3ONWk6SoKnvjxwQyxryja400NoI1ZleC9WoYpS4Vzj6p5D8
         jnfU79A1lfkdte7fN70xBvtpaJDuWvtXkT4DgJrlF8tdKIkUqbWvnSU6hVJD783Ou+sj
         A64g8v9aQRRNjq70lAtpfWZSDRPRUUJCPyNYOTa1FHw1RYaB/mLRur84TPL3TSI2RUdR
         pL6HxPNI9RwFAJSdQEYmpbYP2Gbj4BiovEXQDnU83+awzLuOsSFrm7vzQYwNu2V/Vbyn
         7RLmfUxgtnXl3Ts5PZ5vxcuRaDMiVhNfcWolYzmWNYC3E91XYwA4ajQkFrmqFfHgColL
         4edQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X4NAySBY1O56X8ZQvRrmtff7Avwv2E7wobqj17OL218=;
        b=WNtzHAC+2yvGx9vVBgElemy7gBN1ehcZGhVjWkTf4FV5/QJEiOaQZpd13AFVnzfSQ7
         Jg6REN1LxsXU//C0A2JEDCqE8XEKM/i2obrezNvNQBgMWhHAFvgX/iSNi0K2LZF9l3iq
         ngfQ7bGIalxacLN0anJk5/tFCR6q068J8GY1PwHeFHNlMX1t2eXuq4nc8wUr9PSg4kqR
         MHeeEsrfB98Riy0CdgNlk1UOSNyG4L0gD6raRevWfWW4lFk81+JPr8TBTWNr+wOzF8Uy
         OcaMsXeS9dk/mC2ft62yONt78ElgnyYVUj+3BpWFFEsQiaJcZgpKOp0qb4ArqXVFm7nh
         o3Pw==
X-Gm-Message-State: APjAAAVXnKJjTPijsCB/FJKv7QhcarRxGQjeNf840mwzeD+FMlrryWAS
        tXhGhTbCXfa09+E/4ZtnXnEuUQovaFwhKlci4Jg=
X-Google-Smtp-Source: APXvYqyoeE/oaBpmJeXAj9MgVsygvEFvG9l+Fm/SyV8vg4PDqbkQ+lhgFtzQZ4PyzxwNdWTi9MS2elV5zUCEKAhy15Y=
X-Received: by 2002:aed:3b66:: with SMTP id q35mr1503008qte.118.1561515548290;
 Tue, 25 Jun 2019 19:19:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190625232601.3227055-1-andriin@fb.com> <20190625232601.3227055-2-andriin@fb.com>
In-Reply-To: <20190625232601.3227055-2-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 25 Jun 2019 19:18:57 -0700
Message-ID: <CAPhsuW6FeBHHNgT3OA6x6i9kVsKutnVR46DFdkeG0cggaKbTnQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] libbpf: add perf buffer reading API
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 4:28 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> BPF_MAP_TYPE_PERF_EVENT_ARRAY map is often used to send data from BPF program
> to user space for additional processing. libbpf already has very low-level API
> to read single CPU perf buffer, bpf_perf_event_read_simple(), but it's hard to
> use and requires a lot of code to set everything up. This patch adds
> perf_buffer abstraction on top of it, abstracting setting up and polling
> per-CPU logic into simple and convenient API, similar to what BCC provides.
>
> perf_buffer__new() sets up per-CPU ring buffers and updates corresponding BPF
> map entries. It accepts two user-provided callbacks: one for handling raw
> samples and one for get notifications of lost samples due to buffer overflow.
>
> perf_buffer__poll() is used to fetch ring buffer data across all CPUs,
> utilizing epoll instance.
>
> perf_buffer__free() does corresponding clean up and unsets FDs from BPF map.
>
> All APIs are not thread-safe. User should ensure proper locking/coordination if
> used in multi-threaded set up.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Overall looks good. Some nit below.

> ---
>  tools/lib/bpf/libbpf.c   | 282 +++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h   |  12 ++
>  tools/lib/bpf/libbpf.map |   5 +-
>  3 files changed, 298 insertions(+), 1 deletion(-)

[...]

> +struct perf_buffer *perf_buffer__new(struct bpf_map *map, size_t page_cnt,
> +                                    perf_buffer_sample_fn sample_cb,
> +                                    perf_buffer_lost_fn lost_cb, void *ctx)
> +{
> +       char msg[STRERR_BUFSIZE];
> +       struct perf_buffer *pb;
> +       int err, cpu;
> +
> +       if (bpf_map__def(map)->type != BPF_MAP_TYPE_PERF_EVENT_ARRAY) {
> +               pr_warning("map '%s' should be BPF_MAP_TYPE_PERF_EVENT_ARRAY\n",
> +                          bpf_map__name(map));
> +               return ERR_PTR(-EINVAL);
> +       }
> +       if (bpf_map__fd(map) < 0) {
> +               pr_warning("map '%s' doesn't have associated FD\n",
> +                          bpf_map__name(map));
> +               return ERR_PTR(-EINVAL);
> +       }
> +       if (page_cnt & (page_cnt - 1)) {
> +               pr_warning("page count should be power of two, but is %zu\n",
> +                          page_cnt);
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       pb = calloc(1, sizeof(*pb));
> +       if (!pb)
> +               return ERR_PTR(-ENOMEM);
> +
> +       pb->sample_cb = sample_cb;
> +       pb->lost_cb = lost_cb;

I think we need to check sample_cb != NULL && lost_cb != NULL.

> +       pb->ctx = ctx;
> +       pb->page_size = getpagesize();
> +       pb->mmap_size = pb->page_size * page_cnt;
> +       pb->mapfd = bpf_map__fd(map);
> +
> +       pb->epfd = epoll_create1(EPOLL_CLOEXEC);
[...]
> +perf_buffer__process_record(struct perf_event_header *e, void *ctx)
> +{
> +       struct perf_buffer *pb = ctx;
> +       void *data = e;
> +
> +       switch (e->type) {
> +       case PERF_RECORD_SAMPLE: {
> +               struct perf_sample_raw *s = data;
> +
> +               pb->sample_cb(pb->ctx, s->data, s->size);
> +               break;
> +       }
> +       case PERF_RECORD_LOST: {
> +               struct perf_sample_lost *s = data;
> +
> +               if (pb->lost_cb)
> +                       pb->lost_cb(pb->ctx, s->lost);

OK, we test lost_cb here, so not necessary at init time.

[...]
>                 bpf_program__attach_perf_event;
>                 bpf_program__attach_raw_tracepoint;
>                 bpf_program__attach_tracepoint;
>                 bpf_program__attach_uprobe;
> +               btf__parse_elf;

Why move btf__parse_elf ?

Thanks,
Song
