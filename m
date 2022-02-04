Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952584AA398
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354849AbiBDWya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354649AbiBDWy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:54:28 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D73DC06134A;
        Fri,  4 Feb 2022 14:54:27 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id d188so9222594iof.7;
        Fri, 04 Feb 2022 14:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vCkdPfVzbZRmoCkfxTWH8cGwNvFJNjovWa70f8T1pb8=;
        b=FoUghU6cg8+TMx8kcEZGrlZl/WGl1P1xa9vjFXPtMMU68aGIoxmScnentFod0+eUM3
         QXRreByTgxUBUVtYWl8zAgAosjYWWdJjx3C8WMSoc/lTDhAzx4+eGYuVNBq8xBHQmJ97
         8Kniz/SZ3bmliRiag/yJEUVr4mxNFSJfmCUooZjDjJDO82QqhwQVbyBxO12eDywg2PAy
         yMsrxfap+wfAVCiLsrgBQTqu28HJycz7gNm4jCDvWntc5IHVOY1wMS46TJSuW1+3oUqn
         I5XEBruqffIo6lYEjRLz95WFLSlPT5tfxKr4BrJ7fYMMmNTm0m6i2E4N+iHNBwdbY5tX
         3Ugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vCkdPfVzbZRmoCkfxTWH8cGwNvFJNjovWa70f8T1pb8=;
        b=jo1a08YZVJRzuEdWRLsnHIrsLRb6kT9b5Qt7b9CQ6YFnMMfQRcS/jtYnt6qcp+0FsU
         oL8z8VNYoUyWh1sdblbjoqNtmTmNkaZWVPehquwyJin0Orz3G+3P2ibnrHJJ1dpBHSwL
         RtC2ot3x0XLG/9+y3ijQmxygODOzPLOFkp9Qv6MhwFhIo70QXgJxRKTFXOLMepHZ7Pmp
         mX8PcMbzmXvWhj0XvBHbHk/FXV0LJLffJE6WCd75ILWDVS1IYH9ZHmoLUB4+zCUJjx4u
         xl+A4Nk2135XVrvA5q1FBssz4rPkKgdyGJRUdKEP7cK3RJ2FsjcnW9a0Ot0hexLSVXYD
         8TUg==
X-Gm-Message-State: AOAM531GDjvF5rIOyiSCSLn+mWWDfvK6iQTPUvaUM2QNaQCdG+EIneaz
        /3mZIGvFZubhIFH2Jye8DuSg51IgZLnLkAk+/L2UwX/y13g=
X-Google-Smtp-Source: ABdhPJxUijWrN5W6U7dqYUtPUEAuw+80DQGoWUC2TOUKd+OmaqIR416dtEk9lkjb5gtyEDKXNVdmfHsXWX7XKVPJuws=
X-Received: by 2002:a05:6638:d88:: with SMTP id l8mr661714jaj.234.1644015266474;
 Fri, 04 Feb 2022 14:54:26 -0800 (PST)
MIME-Version: 1.0
References: <20220204220435.301896-1-mauricio@kinvolk.io> <CAHap4zuWvKru+rMztAPdJk+BES5pZCJy-tOegV4h03TX3vbkjQ@mail.gmail.com>
In-Reply-To: <CAHap4zuWvKru+rMztAPdJk+BES5pZCJy-tOegV4h03TX3vbkjQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Feb 2022 14:54:15 -0800
Message-ID: <CAEf4BzaTWa9fELJLh+bxnOb0P1EMQmaRbJVG0L+nXZdy0b8G3Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Fix strict mode calculation
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
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

On Fri, Feb 4, 2022 at 2:24 PM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> On Fri, Feb 4, 2022 at 5:05 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io=
> wrote:
> >
> > The correct formula to get all possible values is
> > ((__LIBBPF_STRICT_LAST - 1) * 2 - 1) as stated in
> > libbpf_set_strict_mode().
> >
> > Fixes: 93b8952d223a ("libbpf: deprecate legacy BPF map definitions")
> >
> > Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
>
> This patch fixes the problem but I'm not totally convinced it's the
> right approach. As a user I'd expected that `LIBBPF_STRICT_ALL &
> ~LIBBPF_STRICT_MAP_DEFINITIONS` disables
> `LIBBPF_STRICT_MAP_DEFINITIONS`, but it doesn't work because the test
> at libbpf_set_strict_mode() returns -EINVAL.
>
> What about using one of the following ideas instead?
> 1. Remove the check from libbpf_set_strict_mode().
> 2. Define `LIBBPF_STRICT_ALL` containing only the bits set of the
> existing options. `LIBBPF_STRICT_ALL =3D ((__LIBBPF_STRICT_LAST - 1) *
> 2)- 1`.

can't do the 2) because the point was that applications that compiled
against older libbpf_legacy.h would still be opting into latest
LIBBPF_STRICT_ALL features. I think removing entire check in
libbpf_set_strict_mode() is ok. Let's do that and simplify selftests
and bpftool by straightforward turning off of the bit with
LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS.
