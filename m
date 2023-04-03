Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA356D42AB
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbjDCKzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjDCKzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:55:19 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AC811E91;
        Mon,  3 Apr 2023 03:55:04 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id e65so34159131ybh.10;
        Mon, 03 Apr 2023 03:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680519303;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pdJ+2OkpH3kcFUdvPltIiLBUjSuE10EzF0P+o63JPsg=;
        b=g5AJO/632OK5MiPYEr7+oeU8KzMREkM6lQk2VI5/BCqLnTgcX0AJ0lNPXtAUkRr5jf
         cl0oojbpBdczWw+tRRhbRntjxYMVStMRNz+mXSjYeVe45seSCnROUCDUG8J5dDgVYKjh
         vXNIsvUSfcUGYZDScc5e1g+T+XkZn30tW7VtrKnFI3Lg+RRwhdHsLfP+w0RfywYlt8dv
         84mIUaMW+ONL/y0m09uQhTUxMN7YFisE7h9G2Htv9xo/vD4bQUSJ7aVQFOVDhZUYFSAw
         /vcwDJoZWB6kDIjqK0UVl3cZDAoM8cbyfRP6fFGBqU7jnBqNT3c/XQScNSFGT5suCp+a
         mSDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680519303;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pdJ+2OkpH3kcFUdvPltIiLBUjSuE10EzF0P+o63JPsg=;
        b=NL94XFmxm504Z9PnEvOY+VIOWEywOMWy1cUSda4dahyR5psD41J2hibFlnzK81EzAN
         OoJ2VMvQfIVOqW5j4o+c7fGvnBAyWYvdDHmE7sI1yxlH3un0VPGe3XWZL1vaUuEdANSQ
         g/c9wURX6+U03Fr4w+rDI2L9vVFHfc7hc/iGKS9nlScp8RdrD1leJlwbGf3lZzvRNLz7
         gX8pnSWXaDKtvwxMrmsJtjK5Ubh4Jvlxks6tr8vF2ADEZ7BMpuV7qg/p3PnEevxy6bkF
         b5r82QCZaYSp/eQLn5+OkoH3G8CuEPRXkqYFoB11iLsR6jmRTcYZE3RLFqwh2W9aiEI9
         GMVw==
X-Gm-Message-State: AAQBX9cw0LARBUvZVataqIMtc9mqqPPoDwylQr8H7yN9glzhhxHQcDLD
        CMrAy0BiqsTmKrgKQKN5KtkmypLTyWEdKfENiHg=
X-Google-Smtp-Source: AKy350aUpJujtPD04sy3aWWIOxoosJlvc8WdC10yThSqw0quEU1Wq/iRvmhcr1e9vht5ZYb63UsNwsMFqF7/cHuBNyM=
X-Received: by 2002:a25:ef0e:0:b0:b6a:5594:5936 with SMTP id
 g14-20020a25ef0e000000b00b6a55945936mr22530962ybd.5.1680519303108; Mon, 03
 Apr 2023 03:55:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230329180502.1884307-1-kal.conley@dectris.com> <20230329180502.1884307-5-kal.conley@dectris.com>
In-Reply-To: <20230329180502.1884307-5-kal.conley@dectris.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 3 Apr 2023 12:54:52 +0200
Message-ID: <CAJ8uoz1cGV1_3HQQddbkExVnm=wngP3ECJZNS5gOtQtfi=mPnA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 04/10] selftests: xsk: Deflakify
 STATS_RX_DROPPED test
To:     Kal Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 at 20:11, Kal Conley <kal.conley@dectris.com> wrote:
>
> Fix flaky STATS_RX_DROPPED test. The receiver calls getsockopt after
> receiving the last (valid) packet which is not the final packet sent in
> the test (valid and invalid packets are sent in alternating fashion with
> the final packet being invalid). Since the last packet may or may not
> have been dropped already, both outcomes must be allowed.
>
> This issue could also be fixed by making sure the last packet sent is
> valid. This alternative is left as an exercise to the reader (or the
> benevolent maintainers of this file).
>
> This problem was quite visible on certain setups. On one machine this
> failure was observed 50% of the time.
>
> Also, remove a redundant assignment of pkt_stream->nb_pkts. This field
> is already initialized by __pkt_stream_alloc.

This has been bugging me for a while so thanks for fixing this. Please
break this commit out of this patch set and send it as a separate bug
fix.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Fixes: 27e934bec35b ("selftests: xsk: make stat tests not spin on getsockopt")
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 34a1f32fe752..1a4bdd5aa78c 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -633,7 +633,6 @@ static struct pkt_stream *pkt_stream_generate(struct xsk_umem_info *umem, u32 nb
>         if (!pkt_stream)
>                 exit_with_error(ENOMEM);
>
> -       pkt_stream->nb_pkts = nb_pkts;
>         for (i = 0; i < nb_pkts; i++) {
>                 pkt_set(umem, &pkt_stream->pkts[i], (i % umem->num_frames) * umem->frame_size,
>                         pkt_len);
> @@ -1141,7 +1140,14 @@ static int validate_rx_dropped(struct ifobject *ifobject)
>         if (err)
>                 return TEST_FAILURE;
>
> -       if (stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2)
> +       /* The receiver calls getsockopt after receiving the last (valid)
> +        * packet which is not the final packet sent in this test (valid and
> +        * invalid packets are sent in alternating fashion with the final
> +        * packet being invalid). Since the last packet may or may not have
> +        * been dropped already, both outcomes must be allowed.
> +        */
> +       if (stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2 ||
> +           stats.rx_dropped == ifobject->pkt_stream->nb_pkts / 2 - 1)
>                 return TEST_PASS;
>
>         return TEST_FAILURE;
> --
> 2.39.2
>
