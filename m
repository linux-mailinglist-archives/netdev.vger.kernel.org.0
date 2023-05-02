Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1E76F45F9
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 16:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbjEBOX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 10:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234105AbjEBOX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 10:23:56 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1A6C7;
        Tue,  2 May 2023 07:23:55 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-54f99770f86so54797907b3.1;
        Tue, 02 May 2023 07:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683037434; x=1685629434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c0tlagjndETqb4vyl9KGLxF15wJn4anPJZnJmgfkl/c=;
        b=K0PkrtQ+McSujB9A84EzlIqNHv14cBXmdu0ZfjZR66RfrojtRlfd1cM89jykYnoLas
         ahin8shKK2L9dFH6MUWrR55xDe8f8gh5x9odaYy4mgE7Pr+Bg3XSDh+uqQiFcMK48cBw
         tzaoPg/s531lh3IhLmKWRF5rlfBCTxm1mJUs/XJHd2SqUwbJqgZTOk9EE7/iVclcXygo
         LKjBGqwshg8Eyf7N9FLItvApIk3tw7tGZui91egVoayoQJSvp4u2k1fOt6fb6yctB69P
         0aiJn3KQjVKeoLpjwXJ2TNkBPeFyAU3REy3BwpbtWZgKMJxjOBSAMrfB4Cln6O2B1P7D
         s8dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683037434; x=1685629434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c0tlagjndETqb4vyl9KGLxF15wJn4anPJZnJmgfkl/c=;
        b=Fpah8PIDxNHNQswxrsY8JYHdS9JL0P9Li2d+d6twNANN0RvnlFSww9mCXgOgjstyX3
         glF+Xp8nUgUWzSamUIkkZC7amuYwaSeNXKcd28XB6hdkBPDewvgTxIvFSO62gHIh9fGI
         2Bpr89YnVzpVIiYF5YOkLvUGuOk6jSc9mEN2MFm3B/7AOw/ZpnH2+9wu/Kkc4mOMmXcn
         qLa+lM9i+feEX83p40CpkazpxoHRDfkxc8Ax+5VAYulZBX742pPirhkKMm1iPyMLDNz9
         5stDeS9mq48mlXRgWMSQwq9OKaIVcLQaX9C8mOEah8pO4mTrVkcPE0un0hh7epCFpnJC
         68Hg==
X-Gm-Message-State: AC+VfDyZejIoeC5+z83xT5pVxolVwwFR44RXwbsqBNUMbE7oIrwgxO7m
        FyUQ6eMxgfOOfTF5+632HYdzK7VzicWWwKKZlIc=
X-Google-Smtp-Source: ACHHUZ612ecIhlT53wUK861pkbcYeetJfXMcpglfdDpv12oWa8U2/fHmhebQXi0TgNnTn4mW2dnC+YzD9TX5x1MML18=
X-Received: by 2002:a0d:d087:0:b0:55a:613c:8480 with SMTP id
 s129-20020a0dd087000000b0055a613c8480mr5494440ywd.51.1683037434369; Tue, 02
 May 2023 07:23:54 -0700 (PDT)
MIME-Version: 1.0
References: <ZFD6UgOFeUCbbIOC@corigine.com> <20230502130316.2680585-1-Ilia.Gavrilov@infotecs.ru>
In-Reply-To: <20230502130316.2680585-1-Ilia.Gavrilov@infotecs.ru>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 2 May 2023 10:23:35 -0400
Message-ID: <CADvbK_cFyMqw1BxTtq9nz2T-V=hLL4fwiUd_vv0pPkzA=v3Faw@mail.gmail.com>
Subject: Re: [PATCH net v2] sctp: fix a potential buffer overflow in sctp_sched_set_sched()
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
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

On Tue, May 2, 2023 at 9:03=E2=80=AFAM Gavrilov Ilia <Ilia.Gavrilov@infotec=
s.ru> wrote:
>
> The 'sched' index value must be checked before accessing an element
> of the 'sctp_sched_ops' array. Otherwise, it can lead to buffer overflow.
>
> Note that it's harmless since the 'sched' parameter is checked before
> calling 'sctp_sched_set_sched'.
>
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
>
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
> ---
> V2:
>  - Change the order of local variables
>  - Specify the target tree in the subject
>  net/sctp/stream_sched.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
> index 330067002deb..4d076a9b8592 100644
> --- a/net/sctp/stream_sched.c
> +++ b/net/sctp/stream_sched.c
> @@ -146,18 +146,19 @@ static void sctp_sched_free_sched(struct sctp_strea=
m *stream)
>  int sctp_sched_set_sched(struct sctp_association *asoc,
>                          enum sctp_sched_type sched)
>  {
> -       struct sctp_sched_ops *n =3D sctp_sched_ops[sched];
>         struct sctp_sched_ops *old =3D asoc->outqueue.sched;
>         struct sctp_datamsg *msg =3D NULL;
> +       struct sctp_sched_ops *n;
>         struct sctp_chunk *ch;
>         int i, ret =3D 0;
>
> -       if (old =3D=3D n)
> -               return ret;
> -
>         if (sched > SCTP_SS_MAX)
>                 return -EINVAL;
>
> +       n =3D sctp_sched_ops[sched];
> +       if (old =3D=3D n)
> +               return ret;
> +
>         if (old)
>                 sctp_sched_free_sched(&asoc->stream);
>
> --
> 2.30.2

Reviewed-by: Xin Long <lucien.xin@gmail.com>
