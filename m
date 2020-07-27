Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A3322FAB7
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 22:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgG0Uxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 16:53:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbgG0Uxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 16:53:31 -0400
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC9020838;
        Mon, 27 Jul 2020 20:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595883211;
        bh=a6AU9sf1ZUMXutwnI1/Vf3w0L3i8tw6Su4jyOOk4+Q0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=x6rEsiY8NDPMoUxF1fHtYrbr1ZPeSBT/Mw0OP0+Rh+Cg5lMh40lQqnlr0W8Iz4eKY
         idEyOwbyHtYsxTDD+SFMA3oysFj3xELxCSoYH5XcJ8q4yKZPUqZ5rrFp8QCQBrK8/X
         X1/jk0Bn8aeavnLiBzm2NN95ZWm3yXAKrHmUkBs0=
Received: by mail-lf1-f51.google.com with SMTP id h8so9751826lfp.9;
        Mon, 27 Jul 2020 13:53:30 -0700 (PDT)
X-Gm-Message-State: AOAM533MzsB1p7HZ1PgxhimG9wVxCUFXZLhh2oKzfT4RMb/ZR67LwC7S
        lxEOkwjQgIKfSl83NCxqvZ6M4XXBg+uuKp0XSXQ=
X-Google-Smtp-Source: ABdhPJyNnQou0xCOihO3lXbU/vFYvhDWPuoM6oxOOcpjRATL+9dcHAhqWM6fz3p5Jg2cX9QiMWwZp48oKJfgeXRq/jI=
X-Received: by 2002:a19:c501:: with SMTP id w1mr11874138lfe.172.1595883209223;
 Mon, 27 Jul 2020 13:53:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200724011700.2854734-1-andriin@fb.com> <20200724011700.2854734-2-andriin@fb.com>
In-Reply-To: <20200724011700.2854734-2-andriin@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 13:53:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW68tUDQf7kgB-r5aJFH3Bk_5_b_0eokqjYe9-8YpHX3zg@mail.gmail.com>
Message-ID: <CAPhsuW68tUDQf7kgB-r5aJFH3Bk_5_b_0eokqjYe9-8YpHX3zg@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: extend map-in-map selftest to
 detect memory leaks
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 6:17 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add test validating that all inner maps are released properly after skeleton
> is destroyed. To ensure determinism, trigger kernel-size synchronize_rcu()
> before checking map existence by their IDs.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../selftests/bpf/prog_tests/btf_map_in_map.c | 104 +++++++++++++++---
>  1 file changed, 91 insertions(+), 13 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> index f7ee8fa377ad..043e8ffe03d1 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> @@ -5,10 +5,50 @@
>
>  #include "test_btf_map_in_map.skel.h"
>
> +static int duration;
> +
> +int bpf_map_id(struct bpf_map *map)
Should this return __u32?

> +{
> +       struct bpf_map_info info;
> +       __u32 info_len = sizeof(info);
> +       int err;
> +
> +       memset(&info, 0, info_len);
> +       err = bpf_obj_get_info_by_fd(bpf_map__fd(map), &info, &info_len);
> +       if (err)
> +               return 0;
> +       return info.id;
> +}
> +
> +int kern_sync_rcu() {

int kern_sync_rcu(void)
{
...

A comment for this function would be nice too.

> +       int inner_map_fd, outer_map_fd, err, zero = 0;
> +
> +       inner_map_fd = bpf_create_map(BPF_MAP_TYPE_ARRAY, 4, 4, 1, 0);
> +       if (CHECK(inner_map_fd < 0, "inner_map_create", "failed %d\n", -errno))
> +               return -1;
> +
> +       outer_map_fd = bpf_create_map_in_map(BPF_MAP_TYPE_ARRAY_OF_MAPS, NULL,
> +                                            sizeof(int), inner_map_fd, 1, 0);
> +       if (CHECK(outer_map_fd < 0, "outer_map_create", "failed %d\n", -errno)) {
> +               close(inner_map_fd);
> +               return -1;
> +       }
> +
> +       err = bpf_map_update_elem(outer_map_fd, &zero, &inner_map_fd, 0);
> +       if (err)
> +               err = -errno;
> +       CHECK(err, "outer_map_update", "failed %d\n", err);
> +       close(inner_map_fd);
> +       close(outer_map_fd);
> +       return err;
> +}
> +
>  void test_btf_map_in_map(void)
>  {
> -       int duration = 0, err, key = 0, val;
> +       int err, key = 0, val, i;
>         struct test_btf_map_in_map* skel;
> +       int outer_arr_fd, outer_hash_fd;
> +       int fd, map1_fd, map2_fd, map1_id, map2_id;
nit: reverse Christmas tree.

>
>         skel = test_btf_map_in_map__open_and_load();
>         if (CHECK(!skel, "skel_open", "failed to open&load skeleton\n"))
> @@ -18,32 +58,70 @@ void test_btf_map_in_map(void)
>         if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
>                 goto cleanup;
>
> +       map1_fd = bpf_map__fd(skel->maps.inner_map1);
> +       map2_fd = bpf_map__fd(skel->maps.inner_map2);
> +       outer_arr_fd = bpf_map__fd(skel->maps.outer_arr);
> +       outer_hash_fd = bpf_map__fd(skel->maps.outer_hash);
> +
>         /* inner1 = input, inner2 = input + 1 */
> -       val = bpf_map__fd(skel->maps.inner_map1);
> -       bpf_map_update_elem(bpf_map__fd(skel->maps.outer_arr), &key, &val, 0);
> -       val = bpf_map__fd(skel->maps.inner_map2);
> -       bpf_map_update_elem(bpf_map__fd(skel->maps.outer_hash), &key, &val, 0);
> +       map1_fd = bpf_map__fd(skel->maps.inner_map1);
> +       bpf_map_update_elem(outer_arr_fd, &key, &map1_fd, 0);
> +       map2_fd = bpf_map__fd(skel->maps.inner_map2);
> +       bpf_map_update_elem(outer_hash_fd, &key, &map2_fd, 0);
>         skel->bss->input = 1;
>         usleep(1);
>
> -       bpf_map_lookup_elem(bpf_map__fd(skel->maps.inner_map1), &key, &val);
> +       bpf_map_lookup_elem(map1_fd, &key, &val);
>         CHECK(val != 1, "inner1", "got %d != exp %d\n", val, 1);
> -       bpf_map_lookup_elem(bpf_map__fd(skel->maps.inner_map2), &key, &val);
> +       bpf_map_lookup_elem(map2_fd, &key, &val);
>         CHECK(val != 2, "inner2", "got %d != exp %d\n", val, 2);
>
>         /* inner1 = input + 1, inner2 = input */
> -       val = bpf_map__fd(skel->maps.inner_map2);
> -       bpf_map_update_elem(bpf_map__fd(skel->maps.outer_arr), &key, &val, 0);
> -       val = bpf_map__fd(skel->maps.inner_map1);
> -       bpf_map_update_elem(bpf_map__fd(skel->maps.outer_hash), &key, &val, 0);
> +       bpf_map_update_elem(outer_arr_fd, &key, &map2_fd, 0);
> +       bpf_map_update_elem(outer_hash_fd, &key, &map1_fd, 0);
>         skel->bss->input = 3;
>         usleep(1);
>
> -       bpf_map_lookup_elem(bpf_map__fd(skel->maps.inner_map1), &key, &val);
> +       bpf_map_lookup_elem(map1_fd, &key, &val);
>         CHECK(val != 4, "inner1", "got %d != exp %d\n", val, 4);
> -       bpf_map_lookup_elem(bpf_map__fd(skel->maps.inner_map2), &key, &val);
> +       bpf_map_lookup_elem(map2_fd, &key, &val);
>         CHECK(val != 3, "inner2", "got %d != exp %d\n", val, 3);
>
> +       for (i = 0; i < 5; i++) {
> +               val = i % 2 ? map1_fd : map2_fd;
> +               err = bpf_map_update_elem(outer_hash_fd, &key, &val, 0);
> +               if (CHECK_FAIL(err)) {
> +                       printf("failed to update hash_of_maps on iter #%d\n", i);
> +                       goto cleanup;
> +               }
> +               err = bpf_map_update_elem(outer_arr_fd, &key, &val, 0);
> +               if (CHECK_FAIL(err)) {
> +                       printf("failed to update hash_of_maps on iter #%d\n", i);
> +                       goto cleanup;
> +               }
> +       }
> +
> +       map1_id = bpf_map_id(skel->maps.inner_map1);
> +       map2_id = bpf_map_id(skel->maps.inner_map2);
> +       CHECK(map1_id == 0, "map1_id", "failed to get ID 1\n");
> +       CHECK(map2_id == 0, "map2_id", "failed to get ID 2\n");
> +
> +       test_btf_map_in_map__destroy(skel);
> +       skel = NULL;
> +
> +       CHECK(kern_sync_rcu(), "sync_rcu", "failed\n");
> +
> +       fd = bpf_map_get_fd_by_id(map1_id);
> +       if (CHECK(fd >= 0, "map1_leak", "inner_map1 leaked!\n")) {
> +               close(fd);
> +               goto cleanup;
> +       }
> +       fd = bpf_map_get_fd_by_id(map2_id);
> +       if (CHECK(fd >= 0, "map2_leak", "inner_map2 leaked!\n")) {
> +               close(fd);
> +               goto cleanup;
> +       }
> +
>  cleanup:
>         test_btf_map_in_map__destroy(skel);
>  }
> --
> 2.24.1
>
