Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96602301F9
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgG1Fmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:42:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgG1Fmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 01:42:46 -0400
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9829D21883;
        Tue, 28 Jul 2020 05:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595914965;
        bh=lj3FNQ1UDqad2e0mCQmLxeBO4aVJvqcXp3FfYr1yaKs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Hirz63esA2VGBgqPzEHyFgMOc8WlNGlLrR1ie0210JBHeNfO9ib9yDnUl7QnJLKbE
         VsrFxtJIDPwuaP1BAQ9lRkC6vC2da4X6yGZ6Uftx+uXoQSm+N2yMywFwJ1zuEDDWQy
         0NmvkeOp2iaY3uzgpPyX0NQtpiO6q+YYqGfgSoq4=
Received: by mail-lf1-f45.google.com with SMTP id j22so4416877lfm.2;
        Mon, 27 Jul 2020 22:42:45 -0700 (PDT)
X-Gm-Message-State: AOAM531bgJIRP56/zQ2xxYkJMb7s/iwYqqLQkDiDQZ5syzWsuL9cJWRg
        GzgDUb5UZ7NP0FHcSW4TxTx0ZB5LccUJ46El4Rc=
X-Google-Smtp-Source: ABdhPJwyH+WSjHjYgU1gw0yiKhX4F2dJYfdOacs8MdbY26DOXkMyXb0Jk/TQrnIt3t9PjDKoB60Duy4DkaZsdJuuHGY=
X-Received: by 2002:a19:be53:: with SMTP id o80mr13458103lff.33.1595914963845;
 Mon, 27 Jul 2020 22:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-27-guro@fb.com>
In-Reply-To: <20200727184506.2279656-27-guro@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 22:42:32 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5cXxf8E-QR4k7tXJXqfgBRapBEvvWMUCLSDrU-0MU5dw@mail.gmail.com>
Message-ID: <CAPhsuW5cXxf8E-QR4k7tXJXqfgBRapBEvvWMUCLSDrU-0MU5dw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 26/35] bpf: eliminate rlimit-based memory
 accounting for xskmap maps
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:21 PM Roman Gushchin <guro@fb.com> wrote:
>
> Do not use rlimit-based memory accounting for xskmap maps.
> It has been replaced with the memcg-based memory accounting.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>


> ---
>  net/xdp/xskmap.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
>
> diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
> index e574b22defe5..0366013f13c6 100644
> --- a/net/xdp/xskmap.c
> +++ b/net/xdp/xskmap.c
> @@ -74,7 +74,6 @@ static void xsk_map_sock_delete(struct xdp_sock *xs,
>
>  static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
>  {
> -       struct bpf_map_memory mem;
>         int err, numa_node;
>         struct xsk_map *m;
>         u64 size;
> @@ -90,18 +89,11 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
>         numa_node = bpf_map_attr_numa_node(attr);
>         size = struct_size(m, xsk_map, attr->max_entries);
>
> -       err = bpf_map_charge_init(&mem, size);
> -       if (err < 0)
> -               return ERR_PTR(err);
> -
>         m = bpf_map_area_alloc(size, numa_node);
> -       if (!m) {
> -               bpf_map_charge_finish(&mem);
> +       if (!m)
>                 return ERR_PTR(-ENOMEM);
> -       }
>
>         bpf_map_init_from_attr(&m->map, attr);
> -       bpf_map_charge_move(&m->map.memory, &mem);
>         spin_lock_init(&m->lock);
>
>         return &m->map;
> --
> 2.26.2
>
