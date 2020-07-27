Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBF422FCE0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgG0XWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0XWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:22:55 -0400
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B1A620829;
        Mon, 27 Jul 2020 23:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892174;
        bh=neoNg6aLQ3HBDoqH28Cszm2AXNEiQWXsFwXzUporDEM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Y6xQ8wsvSS35bRQL73cQDAEPsEPublmmN5RrkIDlmbLWe927WJRRJFzV9cFZHFiOR
         FtZN+cJDERVKH6+vJh/pkHuiqZShBS+3qv4U4hc2NfztikDojTI5Yb61biZW1a+8f+
         tZJcrVj13SPIScw2KBSsJ65yWzMt20qk1SKjNyT0=
Received: by mail-lf1-f46.google.com with SMTP id j22so4050011lfm.2;
        Mon, 27 Jul 2020 16:22:54 -0700 (PDT)
X-Gm-Message-State: AOAM530npxPyAB+oCx30SBWIQ2kWLZGlIv6TdAjt5tHb24/afFla30On
        DVbX2XErNYchNMGIs/PuWWzp9vj4PvLVNzLxVTM=
X-Google-Smtp-Source: ABdhPJzoxs9usbDOXkjthb2o1ZCQeNkWmZgUCB99ykeGoSRvwa2URDSjP5m7ksMZEcNn4UUFDAiH2hDeeAE2VPLb51w=
X-Received: by 2002:a19:ec12:: with SMTP id b18mr12888686lfa.52.1595892172835;
 Mon, 27 Jul 2020 16:22:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200727231445.1227594-1-andriin@fb.com> <20200727231445.1227594-2-andriin@fb.com>
In-Reply-To: <20200727231445.1227594-2-andriin@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 16:22:41 -0700
X-Gmail-Original-Message-ID: <CAPhsuW77nCit0TweeBgermO=bHKztXEtKmh+pB7avXKH0hpZaQ@mail.gmail.com>
Message-ID: <CAPhsuW77nCit0TweeBgermO=bHKztXEtKmh+pB7avXKH0hpZaQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf 2/2] selftests/bpf: extend map-in-map selftest to
 detect memory leaks
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 4:15 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add test validating that all inner maps are released properly after skeleton
> is destroyed. To ensure determinism, trigger kernel-side synchronize_rcu()
> before checking map existence by their IDs.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

With a couple nit below.

> ---
>  .../selftests/bpf/prog_tests/btf_map_in_map.c | 121 ++++++++++++++++--
>  1 file changed, 108 insertions(+), 13 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> index f7ee8fa377ad..c06b61235212 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> @@ -5,10 +5,59 @@
>
>  #include "test_btf_map_in_map.skel.h"
>
> +static int duration;
> +
> +__u32 bpf_map_id(struct bpf_map *map)

Make the function static?

[...]

> +int kern_sync_rcu() {

static int kern_sync_rcu(void)
{

checkpatch.pl should complain here.

Thanks,
Song

[...]
