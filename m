Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B77D232055
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgG2O3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgG2O3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 10:29:03 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C6DC0619D4
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 07:29:03 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x5so2909697wmi.2
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 07:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=5lOk5/IjM4Kivdv0hUHvAQZc4qCXG9zQibXbSDtbUdk=;
        b=mXfye9BX8+b3RDATjFt6WT/1RpQYT5H0NnqbySS/v383E2XpMdG4iVtxyb8yT25gEx
         wCcEj6lgn3WpKGQVquSzsIPiOFLv3bCNgrCsQcS0LMDCy/1te3Ht7NgWuWnqa36I95vu
         wjTd1e6/AUdXK1/llygDlqUrc0SREe9SDaHs8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=5lOk5/IjM4Kivdv0hUHvAQZc4qCXG9zQibXbSDtbUdk=;
        b=QADTq2QGyMao+3OqOAV9qfnJYD1owqs2CF6GDrSDw+8u5JcRGy0xohyD+H8WUVMOKx
         wxhhHEwxLTH1xBSBBndkS7b6cdVXDsOIkBq24XXYcqN0KR8iiU40AJFw6/p3Bc51TUCl
         r2j2mmIvu+QukGZh5ctAEgUsu4RIQOcqzpKdXn8H3A0Mjg7RPZEUrq8JrtqkyDRwVMBe
         6UEWxJkaWSrrQHLh6huR9RrUN9TMCeKP/psK9pGDH/9MbyRUo0XC4hzdZ9I3gIDCCmMv
         adLtQ+iFK32mXkt41QbwWcf0q2D/VLlfStiqj6xD4GnfUS5P2FZRC0g+F148TGfPq6on
         wNow==
X-Gm-Message-State: AOAM531q7eT2MXd5r+oUPsyDC2IEjd03Aql7cfkVo482oS3T+UGYNGln
        1kUgcX6ARN93Zr7IlbyDI0TQxA==
X-Google-Smtp-Source: ABdhPJymj02zHisgqHwORjvU/qXus/k98Koel0aZUvfTGgt/4syNv7yitji/Hc8ZekRfW4GHf+ts6A==
X-Received: by 2002:a05:600c:2d1:: with SMTP id 17mr8919961wmn.15.1596032941868;
        Wed, 29 Jul 2020 07:29:01 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id w16sm6931996wrg.95.2020.07.29.07.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 07:29:01 -0700 (PDT)
References: <20200729040913.2815687-1-andriin@fb.com> <20200729040913.2815687-2-andriin@fb.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Song Liu <songliubraving@fb.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 bpf 2/2] selftests/bpf: extend map-in-map selftest to detect memory leaks
In-reply-to: <20200729040913.2815687-2-andriin@fb.com>
Date:   Wed, 29 Jul 2020 16:29:00 +0200
Message-ID: <87k0ymwg2b.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 06:09 AM CEST, Andrii Nakryiko wrote:
> Add test validating that all inner maps are released properly after skeleton
> is destroyed. To ensure determinism, trigger kernel-side synchronize_rcu()
> before checking map existence by their IDs.
>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../selftests/bpf/prog_tests/btf_map_in_map.c | 124 ++++++++++++++++--
>  1 file changed, 110 insertions(+), 14 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> index f7ee8fa377ad..f6eee3fb933c 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf_map_in_map.c
> @@ -5,10 +5,60 @@
>
>  #include "test_btf_map_in_map.skel.h"
>
> +static int duration;
> +
> +static __u32 bpf_map_id(struct bpf_map *map)
> +{
> +	struct bpf_map_info info;
> +	__u32 info_len = sizeof(info);
> +	int err;
> +
> +	memset(&info, 0, info_len);
> +	err = bpf_obj_get_info_by_fd(bpf_map__fd(map), &info, &info_len);
> +	if (err)
> +		return 0;
> +	return info.id;
> +}
> +
> +/*
> + * Trigger synchronize_cpu() in kernel.

Nit: synchronize_*r*cu().

> + *
> + * ARRAY_OF_MAPS/HASH_OF_MAPS lookup/update operations trigger
> + * synchronize_rcu(), if looking up/updating non-NULL element. Use this fact
> + * to trigger synchronize_cpu(): create map-in-map, create a trivial ARRAY
> + * map, update map-in-map with ARRAY inner map. Then cleanup. At the end, at
> + * least one synchronize_rcu() would be called.
> + */

That's a cool trick. I'm a bit confused by "looking up/updating non-NULL
element". It looks like you're updating an element that is NULL/unset in
the code below. What am I missing?

> +static int kern_sync_rcu(void)
> +{
> +	int inner_map_fd, outer_map_fd, err, zero = 0;
> +
> +	inner_map_fd = bpf_create_map(BPF_MAP_TYPE_ARRAY, 4, 4, 1, 0);
> +	if (CHECK(inner_map_fd < 0, "inner_map_create", "failed %d\n", -errno))
> +		return -1;
> +
> +	outer_map_fd = bpf_create_map_in_map(BPF_MAP_TYPE_ARRAY_OF_MAPS, NULL,
> +					     sizeof(int), inner_map_fd, 1, 0);
> +	if (CHECK(outer_map_fd < 0, "outer_map_create", "failed %d\n", -errno)) {
> +		close(inner_map_fd);
> +		return -1;
> +	}
> +
> +	err = bpf_map_update_elem(outer_map_fd, &zero, &inner_map_fd, 0);
> +	if (err)
> +		err = -errno;
> +	CHECK(err, "outer_map_update", "failed %d\n", err);
> +	close(inner_map_fd);
> +	close(outer_map_fd);
> +	return err;
> +}
> +
>  void test_btf_map_in_map(void)
>  {
> -	int duration = 0, err, key = 0, val;
> -	struct test_btf_map_in_map* skel;
> +	int err, key = 0, val, i;
> +	struct test_btf_map_in_map *skel;
> +	int outer_arr_fd, outer_hash_fd;
> +	int fd, map1_fd, map2_fd, map1_id, map2_id;
>
>  	skel = test_btf_map_in_map__open_and_load();
>  	if (CHECK(!skel, "skel_open", "failed to open&load skeleton\n"))
> @@ -18,32 +68,78 @@ void test_btf_map_in_map(void)
>  	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
>  		goto cleanup;
>
> +	map1_fd = bpf_map__fd(skel->maps.inner_map1);
> +	map2_fd = bpf_map__fd(skel->maps.inner_map2);
> +	outer_arr_fd = bpf_map__fd(skel->maps.outer_arr);
> +	outer_hash_fd = bpf_map__fd(skel->maps.outer_hash);
> +
>  	/* inner1 = input, inner2 = input + 1 */
> -	val = bpf_map__fd(skel->maps.inner_map1);
> -	bpf_map_update_elem(bpf_map__fd(skel->maps.outer_arr), &key, &val, 0);
> -	val = bpf_map__fd(skel->maps.inner_map2);
> -	bpf_map_update_elem(bpf_map__fd(skel->maps.outer_hash), &key, &val, 0);
> +	map1_fd = bpf_map__fd(skel->maps.inner_map1);
> +	bpf_map_update_elem(outer_arr_fd, &key, &map1_fd, 0);
> +	map2_fd = bpf_map__fd(skel->maps.inner_map2);
> +	bpf_map_update_elem(outer_hash_fd, &key, &map2_fd, 0);
>  	skel->bss->input = 1;
>  	usleep(1);
>
> -	bpf_map_lookup_elem(bpf_map__fd(skel->maps.inner_map1), &key, &val);
> +	bpf_map_lookup_elem(map1_fd, &key, &val);
>  	CHECK(val != 1, "inner1", "got %d != exp %d\n", val, 1);
> -	bpf_map_lookup_elem(bpf_map__fd(skel->maps.inner_map2), &key, &val);
> +	bpf_map_lookup_elem(map2_fd, &key, &val);
>  	CHECK(val != 2, "inner2", "got %d != exp %d\n", val, 2);
>
>  	/* inner1 = input + 1, inner2 = input */
> -	val = bpf_map__fd(skel->maps.inner_map2);
> -	bpf_map_update_elem(bpf_map__fd(skel->maps.outer_arr), &key, &val, 0);
> -	val = bpf_map__fd(skel->maps.inner_map1);
> -	bpf_map_update_elem(bpf_map__fd(skel->maps.outer_hash), &key, &val, 0);
> +	bpf_map_update_elem(outer_arr_fd, &key, &map2_fd, 0);
> +	bpf_map_update_elem(outer_hash_fd, &key, &map1_fd, 0);
>  	skel->bss->input = 3;
>  	usleep(1);
>
> -	bpf_map_lookup_elem(bpf_map__fd(skel->maps.inner_map1), &key, &val);
> +	bpf_map_lookup_elem(map1_fd, &key, &val);
>  	CHECK(val != 4, "inner1", "got %d != exp %d\n", val, 4);
> -	bpf_map_lookup_elem(bpf_map__fd(skel->maps.inner_map2), &key, &val);
> +	bpf_map_lookup_elem(map2_fd, &key, &val);
>  	CHECK(val != 3, "inner2", "got %d != exp %d\n", val, 3);
>
> +	for (i = 0; i < 5; i++) {
> +		val = i % 2 ? map1_fd : map2_fd;
> +		err = bpf_map_update_elem(outer_hash_fd, &key, &val, 0);
> +		if (CHECK_FAIL(err)) {
> +			printf("failed to update hash_of_maps on iter #%d\n", i);
> +			goto cleanup;
> +		}
> +		err = bpf_map_update_elem(outer_arr_fd, &key, &val, 0);
> +		if (CHECK_FAIL(err)) {
> +			printf("failed to update hash_of_maps on iter #%d\n", i);
> +			goto cleanup;
> +		}
> +	}
> +
> +	map1_id = bpf_map_id(skel->maps.inner_map1);
> +	map2_id = bpf_map_id(skel->maps.inner_map2);
> +	CHECK(map1_id == 0, "map1_id", "failed to get ID 1\n");
> +	CHECK(map2_id == 0, "map2_id", "failed to get ID 2\n");
> +
> +	test_btf_map_in_map__destroy(skel);
> +	skel = NULL;
> +
> +	/* we need to either wait for or force synchronize_rcu(), before
> +	 * checking for "still exists" condition, otherwise map could still be
> +	 * resolvable by ID, causing false positives.
> +	 *
> +	 * Older kernels (5.8 and earlier) freed map only after two
> +	 * synchronize_rcu()s, so trigger two, to be entirely sure.
> +	 */
> +	CHECK(kern_sync_rcu(), "sync_rcu", "failed\n");
> +	CHECK(kern_sync_rcu(), "sync_rcu", "failed\n");
> +
> +	fd = bpf_map_get_fd_by_id(map1_id);
> +	if (CHECK(fd >= 0, "map1_leak", "inner_map1 leaked!\n")) {
> +		close(fd);
> +		goto cleanup;
> +	}
> +	fd = bpf_map_get_fd_by_id(map2_id);
> +	if (CHECK(fd >= 0, "map2_leak", "inner_map2 leaked!\n")) {
> +		close(fd);
> +		goto cleanup;
> +	}
> +
>  cleanup:
>  	test_btf_map_in_map__destroy(skel);
>  }
