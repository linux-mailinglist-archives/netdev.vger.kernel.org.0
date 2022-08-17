Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E321A59798C
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 00:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242109AbiHQWSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 18:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiHQWSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 18:18:04 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF11AB078;
        Wed, 17 Aug 2022 15:18:03 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id y13so26854496ejp.13;
        Wed, 17 Aug 2022 15:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=xf/0pL40fk81Xehk3Tde2o3yX1m58ng0ryVCU7Q5aVc=;
        b=exdBoqaJRzgYlWt+pw3wzyB9xqC6ylyW2LKSwEMFc23Au9mzM/JRGwchT9xwW7ymFM
         riUNS2tm9aLHyPpfPISR3iEZR+pGZhtaWv4+QhHNcv9qK5JWhkpwH6i9fYTYeW/pnJoA
         i07Ad0IGQ9juf1jswK8tf6QklO42UYzQg9CQkaoifqNmGrVQqU5VadgYivY8ZVjPR7Gs
         W6V6ZJg1ZB+qDYGUDYW6bYRG3BdWcX7Kkm3aT2sgOl+BCEMqp4WoBrCwnephreL5/W6/
         LVIVBlZwK0Jak7Z1mnrGJ08yZLYfBdvpE8AmQ1UZH5T/Z/2SK6/IJaZfHufZOlo6iXKI
         vgqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=xf/0pL40fk81Xehk3Tde2o3yX1m58ng0ryVCU7Q5aVc=;
        b=z5BLjXnfmz2Qxr0rdDlmihLcRVnl/lf9a3n6ZsdnjZKdAKlrzAJ28VIR9eiMQJU4KC
         EUhkNXWDo/piD0JKmKDgskjKY/O84smRJvxarN/fs7QpucFldXiAAjtniAL+a+x3J1Vp
         aWHYtQjT5JMkzf1JFLm4tdltECIeZbBDSBuE76XeILYeG1pBe/OFT4jNYCoJ5t7hEEyd
         KPa5sDGYVNxC4PqeQkce8JZhop0BghiO7yjOzPJfZRlD+bkkYtgLDwO//M6/er1kARiw
         bUuDGZYWfn9TMk6FdEA7TX03G558GqoAjYNB65uCnvlybeFH8l8HtbHlmGehLCXoEjfF
         Lebw==
X-Gm-Message-State: ACgBeo2NSuCTuaZMuBf9wbUyvL+DeV/cbVKSHQDQcJJ1egEZgfldZACA
        P72zwJfYSUnUIlgKeRpzG+p+pB4pO9oN785yJBCpKJNB5pg=
X-Google-Smtp-Source: AA6agR49DtyFRE+rOR146nFkZg70tI/m/D/coDUuTmtgbLRuYhSRCLeYvWL4NfXmbzExnugKEWa0eKS4t4uGT/N/rLc=
X-Received: by 2002:a17:906:a089:b0:72f:826b:e084 with SMTP id
 q9-20020a170906a08900b0072f826be084mr71140ejy.708.1660774681436; Wed, 17 Aug
 2022 15:18:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220816153431.1479265-2-sharmasagarika@google.com>
In-Reply-To: <20220816153431.1479265-2-sharmasagarika@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 17 Aug 2022 15:17:50 -0700
Message-ID: <CAADnVQ+sgpyau=1psyFL9Z-kMmqg8nFju1PxOnTBhz5gzOdgNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] use prefetch function in bpf_map_lookup_batch()
To:     Sagarika Sharma <sharmasagarika@google.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Sagarika Sharma <sagarikashar@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 8:35 AM Sagarika Sharma
<sharmasagarika@google.com> wrote:
>
> This patch introduces the use of a module parameter n_prefetch
> which enables prefetching within the bpf_map_lookup_batch function
> for a faster lookup. Benefits depend on the platform, relative
> density of the map, and the setting of the module parameter as
> described below.
>
> For multiprocessor machines, for a particular key in a bpf map,
> each cpu has a value associated with that key. This patch=E2=80=99s
> change is as follows: when copying each of these values to
> userspace in bpf_map_lookup_batch, the value for a cpu
> n_prefetch ahead is prefetched.
>
> MEASUREMENTS:
> The benchmark test added in this patch series was used to
> measure the effect of prefetching as well as determine the
> optimal setting of n_prefetch given the different parameters:
> the test was run on many different platforms (with varying
> number of cpus), with a range of settings of n_prefetch, and with
> saturated, dense, and sparse maps (num_entries/capacity_of_map).
> The benchmark test measures the average time for a single entry
> lookup (t =3D num_entries_looked_up/total_time) given the varied
> factors as mentioned above. The overhead of the
> bpf_map_lookup_batch syscall introduces some error.
>
> Here are the experimental results:
>
> amd machine with 256 cores (rome zen 2)
> Density of map  n_prefetch      single entry lookup time (ns/op)
> --------------------------------------------------------------------
> 40k / 40k       0               16176.471
>                 1               13095.238
>                 5               7432.432
>                 12              5188.679
>                 20              9482.759
>
> 10k / 40k       0               13253.012
>                 5               7482.993
>                 12              5164.319
>                 20              9649.123
>
> 2.5k / 40k      0               7394.958
>                 5               7201.309
>                 13              4721.030
>                 20              8118.081
>
> For denser maps, the experiments suggest that as n_prefetch
> increases, there is a significant time benefit (~66% decrease)
> until a certain point after which the time benefit begins to
> decrease. For sparser maps, there is a less pronounced speedup
> from prefetching. Additionally, this experiment seems to suggest
> the optimal n_prefetch range on this particular machine is 12-13,
> but a setting of n_prefetch =3D 5 can still improve the single
> entry lookup time.
>
> intel-skylake (with 112 cores)
> Density of map  n_prefetch      single entry lookup time (ns/op)
> ------------------------------------------------------------------
> 40k / 40k       0               5729.167
>                 1               5092.593
>                 5               3395.062
>                 20              6875.000
>
> 10k / 40k       0               2029.520
>                 5               2989.130
>                 20              5820.106
>
> 2.5k / 40k      0               1598.256
>                 5               2935.290
>                 20              4867.257
>
> For this particular machine, the experimental results suggest that
> there is only a significant benefit in prefetching with denser maps.
> Prefetching within bpf_map_lookup_batch can provide significant
> benefit depending on the use case. Across the many different
> platforms experiments were performed on, a setting of n_prefetch =3D 5,
> although not the optimal setting, significantly decreased the single
> entry lookup time for denser maps.
>
> Signed-off-by: Sagarika Sharma <sharmasagarika@google.com>
> ---
>  kernel/bpf/hashtab.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 8392f7f8a8ac..eb70c4bbe246 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -15,6 +15,9 @@
>  #include "bpf_lru_list.h"
>  #include "map_in_map.h"
>
> +static uint n_prefetch;
> +module_param(n_prefetch, uint, 0644);

module_param is no go. sorry.

> +
>  #define HTAB_CREATE_FLAG_MASK                                          \
>         (BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |    \
>          BPF_F_ACCESS_MASK | BPF_F_ZERO_SEED)
> @@ -1743,9 +1746,13 @@ __htab_map_lookup_and_delete_batch(struct bpf_map =
*map,
>                 if (is_percpu) {
>                         int off =3D 0, cpu;
>                         void __percpu *pptr;
> +                       int num_cpus =3D num_possible_cpus();
>
>                         pptr =3D htab_elem_get_ptr(l, map->key_size);
>                         for_each_possible_cpu(cpu) {
> +                               if (n_prefetch > 0 && (cpu + n_prefetch) =
<=3D num_cpus)
> +                                       prefetch(per_cpu_ptr(pptr, cpu + =
n_prefetch));
> +

prefetch is a decent technique, but doesn't look like it helps
in all cases. Your numbers suggest that it may hurt too.
Whatever you're doing with map lookups you need a different
strategy than micro-optimizing this loop with prefetch.
Have you considering using for_each bpf side helper or user
space side map iterator to aggregate and copy values?

Or iterate over all map elements on one cpu first and
then on other cpus ? Essentially swapping
hlist_nulls_for_each_entry_safe and for_each_possible_cpu ?
