Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7929436EFF
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 02:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhJVAur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 20:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhJVAuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 20:50:46 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9B4C061764;
        Thu, 21 Oct 2021 17:48:30 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x66so2131617pfx.13;
        Thu, 21 Oct 2021 17:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tmArOx3eYbE8ZFWrrAoTrYxAAmYaBp16jR3G3fSQSgI=;
        b=nf3TuOxGm1K7Yh7YGWAyXmEF9/PDd6596H3aUHCtBc7x2Cs3ACk4VvT/8b6jkCVLIk
         ZjdfGHkyNMKNP7JXp1lDGxOSNe05+TOhezLpsDV9P9AEomYX/mLSRKkGTkPgo6XuHw8y
         5NOJvqqIQZHteQHv2smMS4aI1KQk1CUXSXl5QW8QASdqmSP1lTVvAVq38ueWd7R3fhH6
         XbUCO4ALZsTaaDXitC+PSzZOOdYeasWh2gs8g7gxCkitb0LAg4Oj9tDkcSObHIEM3aIl
         qtubGnjAVZ3hcrnrPibziStV6hlb8EcrBJj5CSnFjLdSV0jGypI3KVJ6K6vd0MxakMzp
         Wv6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tmArOx3eYbE8ZFWrrAoTrYxAAmYaBp16jR3G3fSQSgI=;
        b=8RheaN6KWKZt2MqkoxEuJRCT46n+VvUujiDaP/ktKWNS+xLlbMxDFGVvx4hS1sDZBr
         QOxig4aMqW0+5t6wsJKkmYxivo3PU7lQw2KtHS5wutCgsitlTKJFk8m5t+X3WLAMC/Zs
         RB9ObNabqfaGg3YCv0tDFobxtMKih2pJt5uYMy0/Z5P1ADhavk3BNPntddFd0SDvy9E5
         0pRlnH3wDhC7ABT5vsBG5damb4Af1WfgEhaqJTk9RnZ1emF4i+9Iey59RaJLA/IyyZ1w
         0wCwpV7gH8S5vMDcXv7n9dRkhRA/4JwK6YHcqWUtugSq5Si6KCk/3XiefMpkjLli8fRb
         x67w==
X-Gm-Message-State: AOAM530gC/MCD/aD8rDA6VtF20FeAz6IDqXEHHKNCGcgVu5DK0vL788p
        6qXsnmb5b2Fa28IJ0emQW6Ma7TH5gQH457TTT4Q=
X-Google-Smtp-Source: ABdhPJykVtN09BVssZyNEZU0GfBcUWhYDoLm1kfIrtKQ5vVxYX8+WTsZU33vRf2e6iF2uSjXPWl3E+jbElPsyOtuOws=
X-Received: by 2002:aa7:9f8f:0:b0:44c:cf63:ec7c with SMTP id
 z15-20020aa79f8f000000b0044ccf63ec7cmr8957531pfr.77.1634863709799; Thu, 21
 Oct 2021 17:48:29 -0700 (PDT)
MIME-Version: 1.0
References: <20211021183951.169905-1-toke@redhat.com>
In-Reply-To: <20211021183951.169905-1-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 21 Oct 2021 17:48:18 -0700
Message-ID: <CAADnVQLPBLc0T32nqM7Q_LBEGWiJRp3JvGaY2Lsmf9yqJW+Yfw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix potential race in tail call compatibility check
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 21, 2021 at 11:40 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
> +       map_type =3D READ_ONCE(array->aux->type);
> +       if (!map_type) {
> +               /* There's no owner yet where we could check for compatib=
ility.
> +                * Do an atomic swap to prevent racing with another invoc=
ation
> +                * of this branch (via simultaneous map_update syscalls).
>                  */
> -               array->aux->type  =3D fp->type;
> -               array->aux->jited =3D fp->jited;
> +               if (cmpxchg(&array->aux->type, 0, prog_type))
> +                       return false;

Other fields might be used in the compatibility check in the future.
This hack is too fragile.
Just use a spin_lock.
