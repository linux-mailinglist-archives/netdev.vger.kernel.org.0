Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC1A4AA31E
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349257AbiBDWYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347604AbiBDWYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:24:51 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229E4D3B5467
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 14:24:49 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id o17so10442896ljp.1
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 14:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N54sf+iIhght26Vz13JszBtsuz/tfVBuwvPWIP5OlAw=;
        b=iuhBwcue9AaxsAgIGQkyYXsAvagyI95r3iozYysQIYzfoI7TGDF6/qrxQGlj5qBkyS
         DlPvPxfmyPRNpgoFkx7odqS2CukeMYmBbRs+0su7gzcZwWnnnhBHJQVogexqAYITC2bw
         eyR8cVIxApaSDk5fiRf5JuJ2NlCwShJAFSc44=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N54sf+iIhght26Vz13JszBtsuz/tfVBuwvPWIP5OlAw=;
        b=We6hQKQKJedk3SJXWz6QtMb5Im4t88PRCf1MC6T4epZkM9Y+e64Ne/ZZ9e9RwbXO30
         Q5MawGAH1OzLml5LvDRXUuPbao9BFLDR91z5ap4hnMnboz/A3Kot093vYiRPFqbvzE1i
         E8Kne3vfXvC6fFxztT0o9dnRgw0Ha1Kijk39zz6tLFUUiZ4SvKdxfZnh9yJ9G0V6yXpA
         qFYRN+Bs8VbQr2n76dCM4Tp8EDulfP6PgUiD4rE+xlg/6mC5kXi84vpUdc4+HUmq2Nr0
         FeoHtaaHy6owsAlR6JbAjgOcT8GKwKN6zC+f+i1msuF4WBXr/MZr/ezuRrUDEcy4S2Ei
         Wtyw==
X-Gm-Message-State: AOAM533ss/hk0ndfOljjFgWEmimcZMDRH7YIZAVFntItWVOQrJ4uwx0f
        jGcjx1lXrg5PSbtzBxRIO2kFgqwx2H29RlsAlLP5y8B+kFrgTA==
X-Google-Smtp-Source: ABdhPJxyvGT8nD8ZyJmBlQMt8OGN3pH+9/5bMLKUdB8M9gQD/Jvxf4vJ+Ey1dUjDCMQN+m9OyvfXNLiwRG2z6jP/0f8=
X-Received: by 2002:a2e:908a:: with SMTP id l10mr644231ljg.310.1644013486775;
 Fri, 04 Feb 2022 14:24:46 -0800 (PST)
MIME-Version: 1.0
References: <20220204220435.301896-1-mauricio@kinvolk.io>
In-Reply-To: <20220204220435.301896-1-mauricio@kinvolk.io>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Fri, 4 Feb 2022 17:24:35 -0500
Message-ID: <CAHap4zuWvKru+rMztAPdJk+BES5pZCJy-tOegV4h03TX3vbkjQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Fix strict mode calculation
To:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 5:05 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io> =
wrote:
>
> The correct formula to get all possible values is
> ((__LIBBPF_STRICT_LAST - 1) * 2 - 1) as stated in
> libbpf_set_strict_mode().
>
> Fixes: 93b8952d223a ("libbpf: deprecate legacy BPF map definitions")
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>

This patch fixes the problem but I'm not totally convinced it's the
right approach. As a user I'd expected that `LIBBPF_STRICT_ALL &
~LIBBPF_STRICT_MAP_DEFINITIONS` disables
`LIBBPF_STRICT_MAP_DEFINITIONS`, but it doesn't work because the test
at libbpf_set_strict_mode() returns -EINVAL.

What about using one of the following ideas instead?
1. Remove the check from libbpf_set_strict_mode().
2. Define `LIBBPF_STRICT_ALL` containing only the bits set of the
existing options. `LIBBPF_STRICT_ALL =3D ((__LIBBPF_STRICT_LAST - 1) *
2)- 1`.
