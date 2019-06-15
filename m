Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4264347240
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 23:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfFOVpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 17:45:17 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35174 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfFOVpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 17:45:17 -0400
Received: by mail-lj1-f195.google.com with SMTP id x25so5780903ljh.2;
        Sat, 15 Jun 2019 14:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=exVM99lG/xDC8wNkJ4onOek50O5CPQsnZ8sIW3tB6IQ=;
        b=Nnwr4t7Yh8+1DIk01779PsaXwLkAFCIZ2HBMljGP+BmOH0B0M1ESanqlM7aGabFfmb
         CTDQSu3WzOh+c25JkGv/wulvBd/GT8zjVJbwPPIgtMd4e+OW8BfTQZXnFhcBdmjcFN8E
         Ze1o+Pae5TgPJAGnFbQ+0yH//xhU4eUBFn0GDW8NNl40CB2H6P/+EV0bz8QvqdzPshSv
         ZtFMjBTJNHPsdXD1xKRorYPsTUPErBb3nwT9R9T6jIIXjvSn6XrVuLMKw6m7Au1sGhV9
         rono3M6RAUBc2bCQY1uYBf+X0nJls+lTjQFQLwhZHYWBmCR3UGQGRcSdtOY0hKiC6Xe6
         9rIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=exVM99lG/xDC8wNkJ4onOek50O5CPQsnZ8sIW3tB6IQ=;
        b=Xu1uNKiuGsYGP3wvEDs50xFcgvZX4igRX3r7EBJNMEWOMp8eRFToWktsMrafylncFM
         PUrQq7mGVDFt5vCOlZ7dLOgS32yYqbCBGeQo5Ge1WFbKbbhHS3HSLKNIftjd05MH+e9n
         Mio4k70T/WjzIeil5b947SUfbmpiXFqVcwTUDqPYjkk7adoO45wNhpXGjOpqm+9Lrmju
         zVTIG8/fO5W/Cwdyn6i7qGGG2Rk1i2vHO2Kz9XqaJ4mW8W+40epyrqoi4lzvmmtenwHz
         Fp7mLw5EebPPpn5RK9ece1Y1XjadUPny4M/X53INFI6kIns480HnUdWs8OkVXcmSFzNy
         oPcg==
X-Gm-Message-State: APjAAAWE0D3JO+NnIpHc/iBYzSxrJThpj/VLeBEi3OGeVf5uzi7/mpzn
        ZqHuL2dyOf3jAjNmR+nQHzBqy0S+78QXOyuGP4k=
X-Google-Smtp-Source: APXvYqyf1l0pf8ewxKoqr1WSEO1NAiGpZ/Skjl1A+u3J2wfYV8Kqxtd9kMf8z1Yeo94+dVZEUVRFQcgJExtsF+8RlWc=
X-Received: by 2002:a2e:9758:: with SMTP id f24mr2787891ljj.58.1560635114849;
 Sat, 15 Jun 2019 14:45:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190614093728.622-1-afabre@cloudflare.com> <CAEf4BzZNO8Px2BRcs5WMxfrfRaekxF=_fz_p2A+eL94L0DrfQg@mail.gmail.com>
 <6aaa3a2f-5da5-525f-89a1-59dddc1cfa53@iogearbox.net>
In-Reply-To: <6aaa3a2f-5da5-525f-89a1-59dddc1cfa53@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 15 Jun 2019 14:45:03 -0700
Message-ID: <CAADnVQK6=90Yu6jhEhE52ptS4vgbRVpyj2oZZsO6gcrScU9bsw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpf: sk_storage: Fix out of bounds memory access
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arthur Fabre <afabre@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 3:36 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> >> Force the minimum number of locks to two.
> >>
> >> Signed-off-by: Arthur Fabre <afabre@cloudflare.com>
> >> Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
>
> The offending commit is already in Linus tree hence if so bpf tree. Arthur, please
> elaborate why bpf-next is targeted specifically here?

It's certainly should be in bpf tree.
It didn't apply directly, so I tweaked it a tiny bit,
reduced verbosity of commit log and pushed to bpf tree.
Thanks for the fix!
