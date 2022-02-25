Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DACE4C3CA2
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 04:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237113AbiBYDss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 22:48:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbiBYDsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 22:48:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673BF100740;
        Thu, 24 Feb 2022 19:48:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20B1BB82AB8;
        Fri, 25 Feb 2022 03:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECC2C36AE7;
        Fri, 25 Feb 2022 03:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645760893;
        bh=XbIdx5w3wAprKXy+9pfHp8DmIKHPkFnU3GHbmyvUfIA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PTsKY8KvrAMKpjcPQRV+T71bV3SdCbVYzuBinz9JIyrKnj45DxpR6nXk92NW7MEBk
         0CzovK3Z9cIrJWuF26NvBKI1n8GE5rkNDfW3qbgcJj2OOGfjEX9sfDDfxUsO3RI/qk
         81TCenbM7mVCaHgcS4u8i3BjwvgjvkdCL6OZOvmSQm+FkaB8Vlqx7cEQ5jvDIrJznQ
         E9C5egYT1iyhLt4FH+P65Mo9UcMdz3B1rdt0pFV6AU1s34Po9HOkXaOUI9qnt458Qg
         gj5zO2TOehM53nvUnqLoSWkupD9tuf+gffOyhXWP57O2/hHTSXVuqlqCQ3L5xubj82
         ASsxGYl45Ludg==
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-2d310db3812so20384727b3.3;
        Thu, 24 Feb 2022 19:48:13 -0800 (PST)
X-Gm-Message-State: AOAM533/B59SyY+9o7VwzTGVV6oU/sYRZJIl5qPP8YX41ttjXhJNHyh1
        /RxZ+Sj1mCEJu8mZvqTirjHPKF5XEKgnIl72FNM=
X-Google-Smtp-Source: ABdhPJwQM86r4Sixnh1yTXwfI63TPAC3DtPXFZhtEmQogtSq7YSAXfVhJCZfIHNuyz9fM+4qGsiTz/p+00srd/ZEsVQ=
X-Received: by 2002:a0d:fb45:0:b0:2d0:d09a:576c with SMTP id
 l66-20020a0dfb45000000b002d0d09a576cmr5794606ywf.447.1645760892770; Thu, 24
 Feb 2022 19:48:12 -0800 (PST)
MIME-Version: 1.0
References: <20220222204236.2192513-1-stijn@linux-ipv6.be> <CAPhsuW6WgjL_atKCivbk5iMNBFHuSGcjAC0tdZYag2fOesUBKA@mail.gmail.com>
 <CAEf4BzYuk2Rur-pae7gbuXSb=ayJ0fUREStdWyorWgd_q1D9zQ@mail.gmail.com>
 <ac624e07-5310-438a-dce3-d2edb01e8031@linux-ipv6.be> <0f1fb86b-f8df-b209-9a89-512cbc142e04@linux-ipv6.be>
In-Reply-To: <0f1fb86b-f8df-b209-9a89-512cbc142e04@linux-ipv6.be>
From:   Song Liu <song@kernel.org>
Date:   Thu, 24 Feb 2022 19:48:01 -0800
X-Gmail-Original-Message-ID: <CAPhsuW42TC=uM4P-+35zZ7d-s7FigOA4_1+-QneYGW9JmnF0sA@mail.gmail.com>
Message-ID: <CAPhsuW42TC=uM4P-+35zZ7d-s7FigOA4_1+-QneYGW9JmnF0sA@mail.gmail.com>
Subject: Re: [PATCH] libbpf: fix BPF_MAP_TYPE_PERF_EVENT_ARRAY auto-pinning
To:     Stijn Tintel <stijn@linux-ipv6.be>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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

On Thu, Feb 24, 2022 at 7:38 AM Stijn Tintel <stijn@linux-ipv6.be> wrote:
>
> On 24/02/2022 12:08, Stijn Tintel wrote:
> > On 24/02/2022 01:15, Andrii Nakryiko wrote:
> >> On Tue, Feb 22, 2022 at 6:37 PM Song Liu <song@kernel.org> wrote:
> >>> On Tue, Feb 22, 2022 at 12:51 PM Stijn Tintel <stijn@linux-ipv6.be> wrote:
> >>>> When a BPF map of type BPF_MAP_TYPE_PERF_EVENT_ARRAY doesn't have the
> >>>> max_entries parameter set, this parameter will be set to the number of
> >>>> possible CPUs. Due to this, the map_is_reuse_compat function will return
> >>>> false, causing the following error when trying to reuse the map:
> >>>>
> >>>> libbpf: couldn't reuse pinned map at '/sys/fs/bpf/m_logging': parameter mismatch
> >>>>
> >>>> Fix this by checking against the number of possible CPUs if the
> >>>> max_entries parameter is not set in the map definition.
> >>>>
> >>>> Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF objects")
> >>>> Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
> >>> Acked-by: Song Liu <songliubraving@fb.com>
> >>>
> >>> I think the following fix would be more future proof, but the patch
> >>> as-is is better for
> >>> stable backport? How about we add a follow up patch on top of current
> >>> patch to fix
> >>> def->max_entries once for all?
> >> Keeping special logic for PERF_EVENT_ARRAY in one place is
> >> preferrable. With this, the changes in map_is_reuse_compat() shouldn't
> >> be necessary at all. Stijn, can you please send v2 with Song's
> >> proposed changes?
> >>
> > Will do!
>
> Unfortunately that doesn't work. In bpf_object__create_maps, we call
> bpf_object__reuse_map and map_is_reuse_compat before
> bpf_object__create_map, so we check map_info.max_entries ==
> map->def.max_entries before the latter is being overwritten.
>
> So I propose to send a v2 based on my initial submission, but use __u32
> for def_max_entries instead of int, unless someone has another suggestion?

How about we move

if (def->type == BPF_MAP_TYPE_PERF_EVENT_ARRAY && !def->max_entries) {
  ...
}

to bpf_object__create_maps() before bpf_object__reuse_map(). And maybe add
a helper function with it?

Thanks,
Song
