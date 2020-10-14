Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6665D28EA4F
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389163AbgJOBjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389060AbgJOBjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 21:39:37 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE32C051132;
        Wed, 14 Oct 2020 16:09:45 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id s89so644477ybi.12;
        Wed, 14 Oct 2020 16:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SC/LgnBpbVfq5lqBs6M8hXan4SDJHmAPTG16R7Au4wQ=;
        b=ZiBMS/r4ErmGIOXAooeA7XmMrf9AmiXugqhDCTehrPjIR1eXGu/i6OSAOQDYBkSjWk
         Qt2puwFg/3MLqTEu3DLrteLBi4QgvEN3vGnvjpICJszy8B5a01uXci138I5P8ecxm0bY
         y/xOo2wj1MsWTRjjPshhR9XM5+GTkYu51x8d2qucS+ZAD9eHC3hDZ4kwMdAFWz1RzFAp
         x+tHbnefQ8kEOdJYEmJlZTMOPMNgPmJO4qAxRvxdfrdAksRMLJqg7erchJp9F5cEYnF6
         AILvHTgtulGgMuosoPxUF0nyO7HsIjubbFvwu/fKLa2j2p5Uc5DYXMriBqVXZRbZsXBU
         KSSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SC/LgnBpbVfq5lqBs6M8hXan4SDJHmAPTG16R7Au4wQ=;
        b=V4rBiJHfxTi55nRFjCZN21NlVrsMHnQlo71+Ie77r4tNsB8vWbmkLt4j4+V2bkxvQG
         q9QokfjEh2SYF7UlRTM5uBnD+SjxKtvnHzAAufFxUKHGGN2hgjFj91EcnJBeDAoAk4se
         V89dXRAvET6lnRSm3g9kv9GxvrJCFEy5aHJoFGb7Dh/TJ+ZDMu9m/IFzxE2oiOaIi4k8
         sISpE5s1uhFPtbRVr7kb+nXWKmAytcTKhrd/AMkIp5ZGnS3+8bt8wAY/NRwLrCpGonVe
         Zd2UP77FkSyBPyoea7N5U4kTVZeG6UTExoiYJvw53F9Z9vDTUI40Sb24sfItrnEjFTF0
         BeOg==
X-Gm-Message-State: AOAM532EKf01r+BqVpTOPKrbG30D7blojHhb+h114be2MiAMp0M4Iayl
        KEj6cVwi1X0MzRWm1wN3T9KGwvQtF0+J4Pgyt6c=
X-Google-Smtp-Source: ABdhPJyG8f/aMEuCgh8JKjtL23wyE26KKG0HVNdyETCDkBjWSurHxoPKI/9ZaVooW4yd8IbCg9zwSQvI42pkQPDlXX8=
X-Received: by 2002:a25:3443:: with SMTP id b64mr1516173yba.510.1602716984539;
 Wed, 14 Oct 2020 16:09:44 -0700 (PDT)
MIME-Version: 1.0
References: <20201014175608.1416-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20201014175608.1416-1-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Oct 2020 16:09:33 -0700
Message-ID: <CAEf4BzaF2fDWoRg8h3dUKftvcastYqzEhGS2TG6MoV462fd_8Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Fix register equivalence tracking.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 10:59 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> The 64-bit JEQ/JNE handling in reg_set_min_max() was clearing reg->id in either
> true or false branch. In the case 'if (reg->id)' check was done on the other
> branch the counter part register would have reg->id == 0 when called into
> find_equal_scalars(). In such case the helper would incorrectly identify other
> registers with id == 0 as equivalent and propagate the state incorrectly.
> Fix it by preserving ID across reg_set_min_max().
> In other words any kind of comparison operator on the scalar register
> should preserve its ID to recognize:
> r1 = r2
> if (r1 == 20) {
>   #1 here both r1 and r2 == 20
> } else if (r2 < 20) {
>   #2 here both r1 and r2 < 20
> }
>
> The patch is addressing #1 case. The #2 was working correctly already.
>
> Fixes: 75748837b7e5 ("bpf: Propagate scalar ranges through register assignments.")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Number of underscores is a bit subtle a difference, but this fixes the bug, so:

Acked-by: Andrii Nakryiko <andrii@kernel.org>


>  kernel/bpf/verifier.c                         | 38 ++++++++++++-------
>  .../testing/selftests/bpf/verifier/regalloc.c | 26 +++++++++++++
>  2 files changed, 51 insertions(+), 13 deletions(-)
>

[...]
