Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44AD0595F34
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 17:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbiHPPgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 11:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235740AbiHPPf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 11:35:58 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD6F7FE46
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:34:57 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id w12-20020a17090a780c00b001f76ed0a1easo4268452pjk.0
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:from:to:cc;
        bh=L+xobS5y5Ec7VAq1FxaOkxSFabwHd5aQYcMyJajK4oo=;
        b=Zq/zzA4FtSl6ULJysM43vn8cKKIlXu+inY1vRHHMg1a7HOQN56N0NBOpvKhjdPtGwK
         URjBEUVePYFZuk/gmNfDxawiJk/yh8WqRe0t2/nxEdhUN4Vi3cYXoYKtHF4A/q2BjbpN
         fxnFVwjQJrAiC5tYE2KtezVieyFf18wC5N4Pzwf9q/WdMz3XBTuKj6iPc/2RBH/xoY/7
         lKPjZeF2+M9CCs3R6xnaIowgDCwP8A2/Ys37YbxTicfU+Azb+V97YYkE08VDqlu34ktn
         11dfLZaVQ7ciOAwp4zkofofSokExrd4GS+ol6WDuvmsx8dWTOttbLqxsZdAH3jsN8Duy
         /Ucw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:x-gm-message-state:from:to:cc;
        bh=L+xobS5y5Ec7VAq1FxaOkxSFabwHd5aQYcMyJajK4oo=;
        b=As52SuHsq7YbPEzp6sL4Xz/Z1cdxqMtXg6Hdrp4tlMWfR8XUHh8JCY7gKhFDoksLN/
         LTCLDlJKtJApCGf68hjt88+xPwUmVDveHY5x2zej0oyeX5S0Ee/KVRznkPnvDb1vQn6h
         N+Hfyb6w+h6Q3rPdh2qLgJKSbBGl1vHmYiq0mdvqxJ1zFcBZQ8ndLeLKfWzlRRxaW7t3
         o7iwon1lQc8LReZnjWO8zEV64omEfOdfSX58jc4pjTQkKMecKhKOE/KfWEAo5nAjm7N6
         e3coe7+lVgs0W+R8iqFg0v4rHZo0YNx1X/ywhPc6OhlOukqbaamNh+Q88orjMqucoStQ
         fveA==
X-Gm-Message-State: ACgBeo1Sthc/wbBkGCdIpKwW0x/J+oaK/u1bpqqZEiN7MOxUS/UIC4nw
        9ZbsXdsrc24dv5wcnFv7bDlmWeX9ukV1I/nnOWkLlA==
X-Google-Smtp-Source: AA6agR7PcAiX5mlJ0MbRBRpZYKtYWPIflsN2NzjzOR29+X1HAiUm9BblVn9n/I8ODS22EQxQT3PGpnKvdh/06rRPRzGSdw==
X-Received: from sagarika.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5714])
 (user=sharmasagarika job=sendgmr) by 2002:a65:41ca:0:b0:41d:17df:1d0e with
 SMTP id b10-20020a6541ca000000b0041d17df1d0emr18846473pgq.112.1660664096796;
 Tue, 16 Aug 2022 08:34:56 -0700 (PDT)
Date:   Tue, 16 Aug 2022 15:34:31 +0000
Message-Id: <20220816153431.1479265-2-sharmasagarika@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH bpf-next 2/2] use prefetch function in bpf_map_lookup_batch()
From:   Sagarika Sharma <sharmasagarika@google.com>
To:     Brian Vazquez <brianvv@google.com>,
        Sagarika Sharma <sagarikashar@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Sagarika Sharma <sharmasagarika@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the use of a module parameter n_prefetch
which enables prefetching within the bpf_map_lookup_batch function
for a faster lookup. Benefits depend on the platform, relative
density of the map, and the setting of the module parameter as
described below.

For multiprocessor machines, for a particular key in a bpf map,
each cpu has a value associated with that key. This patch=E2=80=99s
change is as follows: when copying each of these values to
userspace in bpf_map_lookup_batch, the value for a cpu
n_prefetch ahead is prefetched.

MEASUREMENTS:
The benchmark test added in this patch series was used to
measure the effect of prefetching as well as determine the
optimal setting of n_prefetch given the different parameters:
the test was run on many different platforms (with varying
number of cpus), with a range of settings of n_prefetch, and with
saturated, dense, and sparse maps (num_entries/capacity_of_map).
The benchmark test measures the average time for a single entry
lookup (t =3D num_entries_looked_up/total_time) given the varied
factors as mentioned above. The overhead of the
bpf_map_lookup_batch syscall introduces some error.

Here are the experimental results:

amd machine with 256 cores (rome zen 2)
Density of map	n_prefetch	single entry lookup time (ns/op)
--------------------------------------------------------------------
40k / 40k	0		16176.471
		1		13095.238
		5		7432.432
		12		5188.679
		20		9482.759

10k / 40k	0		13253.012
		5		7482.993
		12		5164.319
		20		9649.123

2.5k / 40k	0		7394.958
		5		7201.309
		13		4721.030
		20		8118.081

For denser maps, the experiments suggest that as n_prefetch
increases, there is a significant time benefit (~66% decrease)
until a certain point after which the time benefit begins to
decrease. For sparser maps, there is a less pronounced speedup
from prefetching. Additionally, this experiment seems to suggest
the optimal n_prefetch range on this particular machine is 12-13,
but a setting of n_prefetch =3D 5 can still improve the single
entry lookup time.

intel-skylake (with 112 cores)
Density of map	n_prefetch	single entry lookup time (ns/op)
------------------------------------------------------------------
40k / 40k	0		5729.167
		1		5092.593
		5		3395.062
		20		6875.000

10k / 40k	0		2029.520
		5		2989.130
		20		5820.106

2.5k / 40k	0		1598.256
		5		2935.290
		20		4867.257

For this particular machine, the experimental results suggest that
there is only a significant benefit in prefetching with denser maps.
Prefetching within bpf_map_lookup_batch can provide significant
benefit depending on the use case. Across the many different
platforms experiments were performed on, a setting of n_prefetch =3D 5,
although not the optimal setting, significantly decreased the single
entry lookup time for denser maps.

Signed-off-by: Sagarika Sharma <sharmasagarika@google.com>
---
 kernel/bpf/hashtab.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 8392f7f8a8ac..eb70c4bbe246 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -15,6 +15,9 @@
 #include "bpf_lru_list.h"
 #include "map_in_map.h"
=20
+static uint n_prefetch;
+module_param(n_prefetch, uint, 0644);
+
 #define HTAB_CREATE_FLAG_MASK						\
 	(BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |	\
 	 BPF_F_ACCESS_MASK | BPF_F_ZERO_SEED)
@@ -1743,9 +1746,13 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *m=
ap,
 		if (is_percpu) {
 			int off =3D 0, cpu;
 			void __percpu *pptr;
+			int num_cpus =3D num_possible_cpus();
=20
 			pptr =3D htab_elem_get_ptr(l, map->key_size);
 			for_each_possible_cpu(cpu) {
+				if (n_prefetch > 0 && (cpu + n_prefetch) <=3D num_cpus)
+					prefetch(per_cpu_ptr(pptr, cpu + n_prefetch));
+
 				bpf_long_memcpy(dst_val + off,
 						per_cpu_ptr(pptr, cpu), size);
 				off +=3D size;
--=20
2.37.1.595.g718a3a8f04-goog

