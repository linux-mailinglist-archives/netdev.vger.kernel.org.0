Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33094C097C
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbiBWCof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238142AbiBWCnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:43:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE8354BF2;
        Tue, 22 Feb 2022 18:37:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAB8961526;
        Wed, 23 Feb 2022 02:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F28C340E8;
        Wed, 23 Feb 2022 02:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583829;
        bh=s9BOfYjtfR3/ei4Ry69xVXoQbSlqAO5tMLRCWBm+dQs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Dou2LJJB1YroYxY1ODiiNPrgTAQR1O4SUnKF7nCxU6gZLa+D3Eum4Eq7/Kmn3eTUO
         XQWQqa7Qe3Ezzm4Xh2zCmdGY+RVqaijVsZyRNK8He7/8Ko9DNBWhOD2MmPaLa5tWki
         oMjp2rVGyJSQ3o1SlPPo4yvgdWVOSt6BVLtjtd7uzoqcOsbrK1klAJIQwtLtJZsgBg
         3p7Lq7toRyy2ZhiWSAsnLD6XSHkmSoSe21wZSnwyiYO54HqsICVfbolfjdoPNHLuuH
         sOndmDNtiOo2xUbHiPr6VenTi1Xh4QXPbz/r3DujOA4bCv+LAaeG4Bo8YbTF/9DdsC
         8mDYjah3mia9Q==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-2d6923bca1aso187037667b3.9;
        Tue, 22 Feb 2022 18:37:09 -0800 (PST)
X-Gm-Message-State: AOAM533Us+KL4BmZR/3F+w3SXegwqEkIBeb0A7zR/ivikD6XEI0ks5pI
        sVUbE0d8sJVP/sobRZHuKp1QrLpjK4S+igP8c20=
X-Google-Smtp-Source: ABdhPJyJqgux9C1W9fSyYCOrRN98nGV1pst/hI5c9sxS6nj70qq9pX0DrkDO9yEtgrVd9r/0TvdvrNTEJ1Ew2WUwt48=
X-Received: by 2002:a81:c47:0:b0:2d6:beec:b381 with SMTP id
 68-20020a810c47000000b002d6beecb381mr22304797ywm.148.1645583828298; Tue, 22
 Feb 2022 18:37:08 -0800 (PST)
MIME-Version: 1.0
References: <20220222204236.2192513-1-stijn@linux-ipv6.be>
In-Reply-To: <20220222204236.2192513-1-stijn@linux-ipv6.be>
From:   Song Liu <song@kernel.org>
Date:   Tue, 22 Feb 2022 18:36:57 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6WgjL_atKCivbk5iMNBFHuSGcjAC0tdZYag2fOesUBKA@mail.gmail.com>
Message-ID: <CAPhsuW6WgjL_atKCivbk5iMNBFHuSGcjAC0tdZYag2fOesUBKA@mail.gmail.com>
Subject: Re: [PATCH] libbpf: fix BPF_MAP_TYPE_PERF_EVENT_ARRAY auto-pinning
To:     Stijn Tintel <stijn@linux-ipv6.be>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 12:51 PM Stijn Tintel <stijn@linux-ipv6.be> wrote:
>
> When a BPF map of type BPF_MAP_TYPE_PERF_EVENT_ARRAY doesn't have the
> max_entries parameter set, this parameter will be set to the number of
> possible CPUs. Due to this, the map_is_reuse_compat function will return
> false, causing the following error when trying to reuse the map:
>
> libbpf: couldn't reuse pinned map at '/sys/fs/bpf/m_logging': parameter mismatch
>
> Fix this by checking against the number of possible CPUs if the
> max_entries parameter is not set in the map definition.
>
> Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF objects")
> Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>

Acked-by: Song Liu <songliubraving@fb.com>

I think the following fix would be more future proof, but the patch
as-is is better for
stable backport? How about we add a follow up patch on top of current
patch to fix
def->max_entries once for all?

Thanks,
Song

diff --git i/tools/lib/bpf/libbpf.c w/tools/lib/bpf/libbpf.c
index ad43b6ce825e..a1bc1c80bc69 100644
--- i/tools/lib/bpf/libbpf.c
+++ w/tools/lib/bpf/libbpf.c
@@ -4881,10 +4881,9 @@ static int bpf_object__create_map(struct
bpf_object *obj, struct bpf_map *map, b
                        return nr_cpus;
                }
                pr_debug("map '%s': setting size to %d\n", map->name, nr_cpus);
-               max_entries = nr_cpus;
-       } else {
-               max_entries = def->max_entries;
+               def->max_entries = nr_cpus;
        }
+       max_entries = def->max_entries;

        if (bpf_map__is_struct_ops(map))
                create_attr.btf_vmlinux_value_type_id =
map->btf_vmlinux_value_type_id;
