Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CBB5AA7E7
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 08:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbiIBGPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 02:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbiIBGPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 02:15:46 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0875B7B1FC;
        Thu,  1 Sep 2022 23:15:46 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so4553392pja.4;
        Thu, 01 Sep 2022 23:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=uI8Pg9oik5wbpVQ38T64kzAVrJGjyN0eDmTJ2VrDPKY=;
        b=fNTPySEIj7KPHE8EqHb7fXpGGv3hZywUzfShG7i8VtqGxdwFl91S3gAwihJ3wKmYmv
         fePtXkjMkl6cwwfO6/CRfKl1tJ80PAuOhcwpb68fGDnbA8kfwBcXGCv/dXpRLGckVx5R
         hyc6aN049B2ZDpiGFn+wHoAFZSPaNRyCV4QtOI+du1TAy9yusHnCGOWjfUSmnJ1nDYob
         aGPpJy1f38QXODEpYrK0jw7RrzJACxZ2Z0DiodSBQbUpqmkWmyOGMN2m6nr5PT4iMFXK
         F+PyJ3XmLcjQQc3McB9rfb33aek6HzLYapwHgE6uqVQ1cnx6n0KmVecxjaTMyC3QsRoN
         DbNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=uI8Pg9oik5wbpVQ38T64kzAVrJGjyN0eDmTJ2VrDPKY=;
        b=Hpl1T4m5femT916PIDmrMgY/U3wrcV3iqIS70Q3hGtgsCAT1sG7OXoq26r2F3v2qKt
         CPXhIbW6cGjpVbgkjQGi55o8PZREIlGtG2poebI7F+SZXiPbrq8ATL2M1GComhd2XdTN
         G4sCvcj2TfKHIPOSizCUVcFIkc0xGX5ch+Ir6Fq2m0IRfA4DW3NAfbKShAOddKpWGiUZ
         KbypQ4SKy/hWQ9Hg4hR6lMXvMhKKbKu/rq3t3G0dOaEYUGNArU+1RT798mfoH8LHs60F
         modlXvdHOYNHopOUs61UBPsa4SwUWOOy0ElOEnaEhv76lLovpSCH+ZKsJQ4Ug39DG5Ux
         uTFA==
X-Gm-Message-State: ACgBeo3f2+z7pRGjPPeUQoy+236QgLSjaAekxuPAdVKynrtu+aju7bUQ
        m6tWqs1K37L/CQImMaU5UHIAqQxNrDgwW9UnbrQ=
X-Google-Smtp-Source: AA6agR4aNy6J7kNSnprb9Q1xqC9EzkQCAYpnyQ0QXI5eye0pGuYALcheSxUW1hji1p74i5LzI0u3pgrgAc3dLum3kyY=
X-Received: by 2002:a17:90b:350f:b0:1fb:479b:8e51 with SMTP id
 ls15-20020a17090b350f00b001fb479b8e51mr3185156pjb.46.1662099345453; Thu, 01
 Sep 2022 23:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220901202645.1463552-1-irogers@google.com>
In-Reply-To: <20220901202645.1463552-1-irogers@google.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 2 Sep 2022 08:15:34 +0200
Message-ID: <CAJ8uoz0RXAFPfu1v_1UuV-iUZ846ZbHNNB=oCQ=sV=pbLSzvxw@mail.gmail.com>
Subject: Re: [PATCH v1] selftests/xsk: Avoid use-after-free on ctx
To:     Ian Rogers <irogers@google.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 1, 2022 at 10:56 PM Ian Rogers <irogers@google.com> wrote:
>
> The put lowers the reference count to 0 and frees ctx, reading it
> afterwards is invalid. Move the put after the uses and determine the
> last use by the reference count being 1.

Thanks for spotting and fixing this Ian.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Fixes: 39e940d4abfa ("selftests/xsk: Destroy BPF resources only when ctx refcount drops to 0")
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/testing/selftests/bpf/xsk.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xsk.c b/tools/testing/selftests/bpf/xsk.c
> index f2721a4ae7c5..0b3ff49c740d 100644
> --- a/tools/testing/selftests/bpf/xsk.c
> +++ b/tools/testing/selftests/bpf/xsk.c
> @@ -1237,15 +1237,15 @@ void xsk_socket__delete(struct xsk_socket *xsk)
>         ctx = xsk->ctx;
>         umem = ctx->umem;
>
> -       xsk_put_ctx(ctx, true);
> -
> -       if (!ctx->refcount) {
> +       if (ctx->refcount == 1) {
>                 xsk_delete_bpf_maps(xsk);
>                 close(ctx->prog_fd);
>                 if (ctx->has_bpf_link)
>                         close(ctx->link_fd);
>         }
>
> +       xsk_put_ctx(ctx, true);
> +
>         err = xsk_get_mmap_offsets(xsk->fd, &off);
>         if (!err) {
>                 if (xsk->rx) {
> --
> 2.37.2.789.g6183377224-goog
>
