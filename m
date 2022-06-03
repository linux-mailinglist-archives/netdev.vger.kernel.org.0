Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F7A53D237
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 21:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349064AbiFCTI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 15:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349036AbiFCTI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 15:08:56 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5787839178;
        Fri,  3 Jun 2022 12:08:55 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id x190so453739vkc.9;
        Fri, 03 Jun 2022 12:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=b1C3mx7cWdTSh5LdHqF6IMGq/78DF/hK//5Y/LdUgog=;
        b=B6sG99pnrbh8z2XmvEjW2ESlDOZUy9IwAWFNeLR8WLsaxWDidjaxpIDuUKZZIZUwbm
         YNesHhr+5aCeQWPHDMHYKUW491FfJDtdLNwrHoiIIL4TuxG+DiPmywg/NFWxPUadwa35
         Ea6kCI7BYinNSLk7B10ig6MEEbCHQkkwlxqxaraAEqmkhTNN0X7quEas5Ja4dyc1T4D+
         vq/jmsDC0oIZ9tOnZ6UgokSFPu4u8rVfdHJw8RKAOvkb6C/E1Q/IL8y4hMMHyvVJOX7u
         wyxPA0FPkhTfGWORyjLGmnEWR5JfQ0h47xI40AyZFlT2+iw4G6S8tHmXHoxUVb4YGGNi
         zz1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=b1C3mx7cWdTSh5LdHqF6IMGq/78DF/hK//5Y/LdUgog=;
        b=1D0vlOajT/Enyso67mee87TV6Ff+gNlpETzKdmPoQOltxYdvf+I9un99SxtQ/YvIi/
         r5pHwDxSfhcoRKBDi255CDnBtua0VFPKVDRuWo2xVjJyoXEHc0TzsHeVLMXo1Ih6/ZK/
         h+VNCMEtbtMcSf77Q7j+K8LviVpt0y8rqdIFN/pstJiUKG0GOiopr4pSwIi9bDIIjEF+
         qw9PZRhkZyqhNQfJlvkbegYryk3TmqSfibGsKaPsDuLKPD2eotkt2PNo6vIMOPzfxIge
         1EVoNPnDWp2dxHgc6OKJCVlTPez2BGeWD7oHtDkNPYL2rSl7OxsoBTvGvW0fafKeONoo
         F2tA==
X-Gm-Message-State: AOAM530f+9OjLqrqR1SYPUYVOc/ad9afEe8zzQkeBQNNIxNfHU9UQ1n8
        wOSTKh0X5JpHlmovNuhoSDkSE9NYwcURBh71R5X+bZQo
X-Google-Smtp-Source: ABdhPJxBW76JZY06YxlUvaV0gjNppS15ZXq2lEOURo/UBz/vfJsn1eA0N5S8ttRxaTt+hsQkyfsDTofKZ7IOJNldQ7A=
X-Received: by 2002:a1f:a9cc:0:b0:35c:8338:24f8 with SMTP id
 s195-20020a1fa9cc000000b0035c833824f8mr4967074vke.14.1654283334460; Fri, 03
 Jun 2022 12:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220603154028.24904-1-toke@redhat.com> <20220603154028.24904-2-toke@redhat.com>
In-Reply-To: <20220603154028.24904-2-toke@redhat.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Fri, 3 Jun 2022 12:08:43 -0700
Message-ID: <CAJnrk1Y-_pCPLZfgzyC-4aq2dXf=yLFEm9xFiU0f87YWNqdhhQ@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: Add selftest for calling global
 functions from freplace
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
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

On Fri, Jun 3, 2022 at 11:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Add a selftest that calls a global function with a context object paramet=
er
> from an freplace function to check that the program context type is
> correctly converted to the freplace target when fetching the context type
> from the kernel BTF.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 13 ++++++++++
>  .../bpf/progs/freplace_global_func.c          | 24 +++++++++++++++++++
>  2 files changed, 37 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/freplace_global_fun=
c.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/too=
ls/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> index d9aad15e0d24..6e86a1d92e97 100644
> --- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
> @@ -395,6 +395,17 @@ static void test_func_map_prog_compatibility(void)
>                                      "./test_attach_probe.o");
>  }
>
> +static void test_func_replace_global_func(void)
> +{
> +       const char *prog_name[] =3D {
> +               "freplace/test_pkt_access",
> +       };
> +       test_fexit_bpf2bpf_common("./freplace_global_func.o",
> +                                 "./test_pkt_access.o",
> +                                 ARRAY_SIZE(prog_name),
> +                                 prog_name, false, NULL);
> +}
> +
>  /* NOTE: affect other tests, must run in serial mode */
>  void serial_test_fexit_bpf2bpf(void)
>  {
> @@ -416,4 +427,6 @@ void serial_test_fexit_bpf2bpf(void)
>                 test_func_replace_multi();
>         if (test__start_subtest("fmod_ret_freplace"))
>                 test_fmod_ret_freplace();
> +       if (test__start_subtest("func_replace_global_func"))
> +               test_func_replace_global_func();
>  }
> diff --git a/tools/testing/selftests/bpf/progs/freplace_global_func.c b/t=
ools/testing/selftests/bpf/progs/freplace_global_func.c
> new file mode 100644
> index 000000000000..d9f8276229cc
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/freplace_global_func.c
> @@ -0,0 +1,24 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2019 Facebook */
nit: I think you meant 2022, not 2019? :)
> +#include <linux/stddef.h>
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_endian.h>
> +#include <bpf/bpf_tracing.h>
nit: I think the only headers you need here are the linux/bpf.h and
bpf/bpf_helpers.h ones.
> +
> +__attribute__ ((noinline))
> +int test_ctx_global_func(struct __sk_buff *skb)
> +{
> +       volatile int retval =3D 1;
> +       return retval;
> +}
> +
> +__u64 test_pkt_access_global_func =3D 0;
> +SEC("freplace/test_pkt_access")
> +int new_test_pkt_access(struct __sk_buff *skb)
> +{
> +       test_pkt_access_global_func =3D test_ctx_global_func(skb);
> +       return -1;
> +}
> +
> +char _license[] SEC("license") =3D "GPL";
> --
> 2.36.1
>
