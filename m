Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26EC04FB32D
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 07:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244714AbiDKFWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 01:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244412AbiDKFWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 01:22:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E6ADF3;
        Sun, 10 Apr 2022 22:20:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CF94B80E7A;
        Mon, 11 Apr 2022 05:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5BCC385A3;
        Mon, 11 Apr 2022 05:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649654405;
        bh=IdJ+r6qpszbDCHPdlyVv4t4TpGEHFhC8/8LTRC2f6CU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eBc+YraGmAzilJlGKb9dK1lG2ZxEiWPiRJIHV1CHw3z4HTBBDFjz1JtbJXM5PYJvJ
         0vv4MlwlqUWY68S3VlmHa7+rb69kQuoVeXb5TAOH6v1nYiKsGdBwvQjNNPwN/IXXuZ
         yOOg5k1TIbURBMN7ItYoq/6G0KC53vtu3oLE0ry/kEXWIG4eEufukINI3IdvjHP6IY
         3rjxhFgk0HA/ARkO5D3D+4umCrVBfoKCtmYiEUBb6MBwMkg3sYIYQRDOmV/bD+s9SC
         9i6B2zAPpWogRQRlLUhw2r7toH+eFiOfUcRM9MpOZtj+VrYEfmNYdgIGGAY6HuqSOY
         L3/eoPxr9SL+A==
Received: by mail-yb1-f170.google.com with SMTP id t67so8663140ybi.2;
        Sun, 10 Apr 2022 22:20:05 -0700 (PDT)
X-Gm-Message-State: AOAM531g68F7HAOE/7EzFzRRVZZSUG/hMS3MEwjha+NI6Aaeosz+0WtL
        NfoWRfwvCRrrN2IDr3YO83xaqqOdrFiv1ExLKec=
X-Google-Smtp-Source: ABdhPJwIfYde/CjvRfxvCcqBgIOi5l2Ewe3FQxgyU41O9+nVqj0O2WUzv82XBleIysOnMFgXIcgZ6v4Omr4knVoTDlk=
X-Received: by 2002:a25:6909:0:b0:63d:afc8:8b01 with SMTP id
 e9-20020a256909000000b0063dafc88b01mr21154400ybc.561.1649654404745; Sun, 10
 Apr 2022 22:20:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220409213053.3117305-1-toke@redhat.com>
In-Reply-To: <20220409213053.3117305-1-toke@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Sun, 10 Apr 2022 22:19:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5cWzSzFXDgP-hQr7vRfLE7LN2NsE0n7Q659dosfgbhOw@mail.gmail.com>
Message-ID: <CAPhsuW5cWzSzFXDgP-hQr7vRfLE7LN2NsE0n7Q659dosfgbhOw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Fix release of page_pool in BPF_PROG_RUN
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>,
        Paolo Abeni <pabeni@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 9, 2022 at 2:31 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> The live packet mode in BPF_PROG_RUN allocates a page_pool instance for
> each test run instance and uses it for the packet data. On setup it creat=
es
> the page_pool, and calls xdp_reg_mem_model() to allow pages to be returne=
d
> properly from the XDP data path. However, xdp_reg_mem_model() also raises
> the reference count of the page_pool itself, so the single
> page_pool_destroy() count on teardown was not enough to actually release
> the pool. To fix this, add an additional xdp_unreg_mem_model() call on
> teardown.
>
> Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN=
")
> Reported-by: Freysteinn Alfredsson <freysteinn.alfredsson@kau.se>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  net/bpf/test_run.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index e7b9c2636d10..af709c182674 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -108,6 +108,7 @@ struct xdp_test_data {
>         struct page_pool *pp;
>         struct xdp_frame **frames;
>         struct sk_buff **skbs;
> +       struct xdp_mem_info mem;
>         u32 batch_size;
>         u32 frame_cnt;
>  };
> @@ -147,7 +148,6 @@ static void xdp_test_run_init_page(struct page *page,=
 void *arg)
>
>  static int xdp_test_run_setup(struct xdp_test_data *xdp, struct xdp_buff=
 *orig_ctx)
>  {
> -       struct xdp_mem_info mem =3D {};
>         struct page_pool *pp;
>         int err =3D -ENOMEM;
>         struct page_pool_params pp_params =3D {
> @@ -174,7 +174,7 @@ static int xdp_test_run_setup(struct xdp_test_data *x=
dp, struct xdp_buff *orig_c
>         }
>
>         /* will copy 'mem.id' into pp->xdp_mem_id */
> -       err =3D xdp_reg_mem_model(&mem, MEM_TYPE_PAGE_POOL, pp);
> +       err =3D xdp_reg_mem_model(&xdp->mem, MEM_TYPE_PAGE_POOL, pp);
>         if (err)
>                 goto err_mmodel;
>
> @@ -202,6 +202,7 @@ static int xdp_test_run_setup(struct xdp_test_data *x=
dp, struct xdp_buff *orig_c
>
>  static void xdp_test_run_teardown(struct xdp_test_data *xdp)
>  {
> +       xdp_unreg_mem_model(&xdp->mem);
>         page_pool_destroy(xdp->pp);
>         kfree(xdp->frames);
>         kfree(xdp->skbs);
> --
> 2.35.1
>
