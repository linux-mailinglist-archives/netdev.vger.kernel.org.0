Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20274717DD
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 03:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhLLCoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 21:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbhLLCoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 21:44:08 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CAFC061714;
        Sat, 11 Dec 2021 18:44:08 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id v23so9464591pjr.5;
        Sat, 11 Dec 2021 18:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=r5m+EB93vaUnLwMUHnlU8mXWbcAF+nVW77ZhZ96ER7U=;
        b=DSyCguhqkb8oz1XCkBGhoDf8P5aqE+ZBrQcOvNTsLYDoTVi2xt8E596svg1mcps4dn
         oxUi0NOY2nnDN1tF7QmGbSU3wq326zYvxDulgE57j9skOF23yU9yKGOpy/cY0wXcd1tH
         faW8mHjJMw/vEXwlhQe/DUsdGcYgPoGtWcaqHIQzBv4HCfG6rbk4unjxzH4FIt8gjKoz
         MMGne37nnjkql/8bYBDBk/7aeR29lvPzL/ldbQGiRuPTCHNKncZYoPyUdWpLeOiTFDHB
         9JBiBZ6FNZTGynNOMuAKq1suDn/AfOQUkN8DvIGToY2cxRdhA44mp6OSx2fkD5ytkLxd
         y4Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r5m+EB93vaUnLwMUHnlU8mXWbcAF+nVW77ZhZ96ER7U=;
        b=IZq1v5BNKLcYqrpa0ZCz0BrGdL5swrO3QPxEK4d4532IUeV28Tl+ze0F+JKT2zCYrK
         9Suji3xzy2UWFKLVo/D1d6yHBzok7IFpeJliP1y8cY3/7fpTQmpIrPcZO9lr/XsCj+PT
         02Ltkmh7O58SaKv12mtchXFgCbTTFqtP7+NMov8WlrU5toe4uH6FkuHIxLAMvviim7d/
         zbjJR/376dnP3wnMgVEH/rSFLDQibYLXNoYsXAZUSC6xK1m8lJEtNOCwlg0ij72t4BJX
         gTLZblYzXHzLsPRdz4JR+84mZjX00f2VveAUBo2D4Td+DgpfpOWf3MY4hJ793O2uY1I1
         QTZA==
X-Gm-Message-State: AOAM533Mk9/F0B7DpB6b0HFauyfEmyUhHtTfZEhPo8XsCiy20n88fQK8
        UkiFBPOX/jKMTPs3z/pfyyI2zpuZP4RtCNWTOf0=
X-Google-Smtp-Source: ABdhPJyoirSOfqP/6kVZWn0ufFNfUcpKg5O1F6xqWu4uBnUkriu1hoQoIj4qHWZod5znAWv4LeojU2bq3+q1+zfgdr4=
X-Received: by 2002:a17:902:d491:b0:142:892d:a89 with SMTP id
 c17-20020a170902d49100b00142892d0a89mr84276618plg.20.1639277047729; Sat, 11
 Dec 2021 18:44:07 -0800 (PST)
MIME-Version: 1.0
References: <20211211184143.142003-1-toke@redhat.com> <20211211184143.142003-7-toke@redhat.com>
In-Reply-To: <20211211184143.142003-7-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 11 Dec 2021 18:43:56 -0800
Message-ID: <CAADnVQJYfyHs41H1x-1wR5WVSX+3ju69XMUQ4id5+1DLkTVDkg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 6/8] bpf: Add XDP_REDIRECT support to XDP for bpf_prog_run()
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
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 10:43 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
> +
> +static void bpf_test_run_xdp_teardown(struct bpf_test_timer *t)
> +{
> +       struct xdp_mem_info mem =3D {
> +               .id =3D t->xdp.pp->xdp_mem_id,
> +               .type =3D MEM_TYPE_PAGE_POOL,
> +       };

pls add a new line.

> +       xdp_unreg_mem_model(&mem);
> +}
> +
> +static bool ctx_was_changed(struct xdp_page_head *head)
> +{
> +       return (head->orig_ctx.data !=3D head->ctx.data ||
> +               head->orig_ctx.data_meta !=3D head->ctx.data_meta ||
> +               head->orig_ctx.data_end !=3D head->ctx.data_end);

redundant ()

>         bpf_test_timer_enter(&t);
>         old_ctx =3D bpf_set_run_ctx(&run_ctx.run_ctx);
>         do {
>                 run_ctx.prog_item =3D &item;
> -               if (xdp)
> +               if (xdp && xdp_redirect) {
> +                       ret =3D bpf_test_run_xdp_redirect(&t, prog, ctx);
> +                       if (unlikely(ret < 0))
> +                               break;
> +                       *retval =3D ret;
> +               } else if (xdp) {
>                         *retval =3D bpf_prog_run_xdp(prog, ctx);

Can we do this unconditionally without introducing a new uapi flag?
I mean "return bpf_redirect()" was a nop under test_run.
What kind of tests might break if it stops being a nop?
