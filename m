Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B726BBA4D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 17:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbjCOQzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 12:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbjCOQzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 12:55:35 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7D67C3E7;
        Wed, 15 Mar 2023 09:55:20 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id o12so78081263edb.9;
        Wed, 15 Mar 2023 09:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678899319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mgS8VFFM3FOHWNwMGzUjyUFSlBOOEnmdBLa6dghYuqY=;
        b=okplCCD2Rlw+ZLxfIDG4JxtgR5IuDMndqcMJElzGNW77Lv8Dqc65iSTrnrU27ogwYZ
         SIW1z1Z7LGfy7nBf+X18RTdyVPmuMNYzgDHu0KC1CmzGYpgcROkiRmT4DsiJmCXhPgjs
         vzGoaz/vsa6I3XE1EXUTImHLBw7QGciY7o00KixcbMpAIo/AsM87blamQjazgjeMLINK
         YwI9BbHd3VV/8Ur3jUVdVyvewRQ/xQ/Kje1AlWNBGqMfgt9BXr30blpaS4DB2sqE22Sb
         m7WOb2JVrH17ZtdpcE28rxIapXVZMFmpaAcLrR3iWFs/4kNklwovpRMDIuItvkiyULyE
         hDBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678899319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mgS8VFFM3FOHWNwMGzUjyUFSlBOOEnmdBLa6dghYuqY=;
        b=jYZA1UBOsl23M8i0xD1J3mNLON9vYFPspdhQ/qi7U0eIP8NYETgGfW0neM91H+F3p/
         Axj/u7T/02vxGpEYS8ZTQcRn3+efvOeKObUX30OBgwZmNthxuwAJy5S/+AekZDLpv6Ck
         0+Zt8G2CAYkxiyQHak6fM/FyAj12wK4jvxchRy4sd3YrtHhwT+pqX8OP/fCY14w+3CvR
         mqa8XYVvlwL7yjUY+wzdcrxJazFr7v2BuvEagRXvM9+vQQ5HwVE3LJo5l8looMR7mFO7
         yGXMF+E2fqfPTY8qG8MQshKaJtkzy2V3v69m2vC1bkAf1kYoaxf+/Csgu55D2VE5Xt1Y
         UKvw==
X-Gm-Message-State: AO0yUKW4nHRrvYX9oI5aH889Pw6s6xYl/WrTXKGH+vI9AR0dHRmRdByM
        0B6NXYG+D32zteBayowuK4HVRoLaWoRXGi7tIMs=
X-Google-Smtp-Source: AK7set/8htQNDu9vw6MqBmuHITLHgilvlNICkFVmVWaeqbVwlQe53D0I/DfeboAQL7oGJRUHoen+ASl5vxGniJLKHkM=
X-Received: by 2002:a17:906:8552:b0:8ae:9f1e:a1c5 with SMTP id
 h18-20020a170906855200b008ae9f1ea1c5mr3436507ejy.3.1678899318811; Wed, 15 Mar
 2023 09:55:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
 <ca1385b5-b3f8-73f3-276c-a2a08ec09aa0@intel.com> <CAADnVQJDz3hBEJ7kohXJ4HUZWZdbRRamfJbrZ6KUaRubBKQmfA@mail.gmail.com>
 <CAADnVQ+B_JOU+EpP=DKhbY9yXdN6GiRPnpTTXfEZ9sNkUeb-yQ@mail.gmail.com>
 <5b360c35-1671-c0b8-78ca-517c7cd535ae@intel.com> <2bda95d8-6238-f9ef-7dce-aa9320013a13@intel.com>
In-Reply-To: <2bda95d8-6238-f9ef-7dce-aa9320013a13@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 15 Mar 2023 09:55:07 -0700
Message-ID: <CAADnVQLRq7H_-L_agV1Dh9mkdvekZZt9inbbXYFdTRumcBy85g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/4] xdp: recycle Page Pool backed skbs built
 from XDP frames
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 3:55=E2=80=AFAM Alexander Lobakin
<aleksander.lobakin@intel.com> wrote:
>
> From: Alexander Lobakin <aleksander.lobakin@intel.com>
> Date: Wed, 15 Mar 2023 10:56:25 +0100
>
> > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Date: Tue, 14 Mar 2023 16:54:25 -0700
> >
> >> On Tue, Mar 14, 2023 at 11:52=E2=80=AFAM Alexei Starovoitov
> >> <alexei.starovoitov@gmail.com> wrote:
> >
> > [...]
> >
> >> test_xdp_do_redirect:PASS:prog_run 0 nsec
> >> test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
> >> test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
> >> test_xdp_do_redirect:FAIL:pkt_count_tc unexpected pkt_count_tc: actual
> >> 220 !=3D expected 9998
> >> test_max_pkt_size:PASS:prog_run_max_size 0 nsec
> >> test_max_pkt_size:PASS:prog_run_too_big 0 nsec
> >> close_netns:PASS:setns 0 nsec
> >> #289 xdp_do_redirect:FAIL
> >> Summary: 270/1674 PASSED, 30 SKIPPED, 1 FAILED
> >>
> >> Alex,
> >> could you please take a look at why it's happening?
> >>
> >> I suspect it's an endianness issue in:
> >>         if (*metadata !=3D 0x42)
> >>                 return XDP_ABORTED;
> >> but your patch didn't change that,
> >> so I'm not sure why it worked before.
> >
> > Sure, lemme fix it real quick.
>
> Hi Ilya,
>
> Do you have s390 testing setups? Maybe you could take a look, since I
> don't have one and can't debug it? Doesn't seem to be Endianness issue.
> I mean, I have this (the below patch), but not sure it will fix
> anything -- IIRC eBPF arch always matches the host arch ._.
> I can't figure out from the code what does happen wrongly :s And it
> happens only on s390.
>
> Thanks,
> Olek
> ---
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/t=
ools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> index 662b6c6c5ed7..b21371668447 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
> @@ -107,7 +107,7 @@ void test_xdp_do_redirect(void)
>                             .attach_point =3D BPF_TC_INGRESS);
>
>         memcpy(&data[sizeof(__u32)], &pkt_udp, sizeof(pkt_udp));
> -       *((__u32 *)data) =3D 0x42; /* metadata test value */
> +       *((__u32 *)data) =3D htonl(0x42); /* metadata test value */
>
>         skel =3D test_xdp_do_redirect__open();
>         if (!ASSERT_OK_PTR(skel, "skel"))
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c b/t=
ools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> index cd2d4e3258b8..2475bc30ced2 100644
> --- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <vmlinux.h>
> +#include <bpf/bpf_endian.h>
>  #include <bpf/bpf_helpers.h>
>
>  #define ETH_ALEN 6
> @@ -28,7 +29,7 @@ volatile int retcode =3D XDP_REDIRECT;
>  SEC("xdp")
>  int xdp_redirect(struct xdp_md *xdp)
>  {
> -       __u32 *metadata =3D (void *)(long)xdp->data_meta;
> +       __be32 *metadata =3D (void *)(long)xdp->data_meta;
>         void *data_end =3D (void *)(long)xdp->data_end;
>         void *data =3D (void *)(long)xdp->data;
>
> @@ -44,7 +45,7 @@ int xdp_redirect(struct xdp_md *xdp)
>         if (metadata + 1 > data)
>                 return XDP_ABORTED;
>
> -       if (*metadata !=3D 0x42)
> +       if (*metadata !=3D __bpf_htonl(0x42))
>                 return XDP_ABORTED;

Looks sane to me.
I'd probably use 'u8 * metadata' instead. Both in bpf and user space
just not to worry about endianness.
Could you please submit an official patch and let CI judge?
