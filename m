Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2885F1CB297
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgEHPNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgEHPNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:13:24 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1AAC061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 08:13:24 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id f5so1104205ybo.4
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 08:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DKpTqkjAnviw6zqXamQ6vXKxTa/70Egj1B44LG78reU=;
        b=MIxiHaRTfMwe2KMjWpEktjt8zmAgT34C2uT3C6O92wxhPSOEwnw+VLnFp5vKRooHWm
         BvDIY30iqOw1GGO3fOdlFI5dc4TE9e4RyAh3tS4vS3gVevmeynYPX3qDkypydxWHW+qk
         J9wioUq0+0LckbGBdfYXoiI6NQDgAU78SlEaKCVh9/LDtUyOE2waMCtLLFYhxWiYNZtB
         kMMtCmM1eWgacVjCPijxpCupdBaA1iy/ccB9T0irc+0oIEnZRQ8zxXxDkOI1+jHPya3f
         ur8VUQgZegILPcI5jBeNZluEYuTcQmICNRfhyBwDR7r6UXaFqOFqQEEGvDP9J+MWSrrZ
         PlzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DKpTqkjAnviw6zqXamQ6vXKxTa/70Egj1B44LG78reU=;
        b=Bl92uQqkTPKVposcnbru7NPqQHhU2UopCmHmx8j4CbCaWRRw5GH3KQopBK1DVwJKq0
         Z/Vxf5dzFOkXRe0OB8zmV3eT2S2WqFCmPmgYltV7Uxa299x33//lT3f3/ayYuJbRM/yz
         +7D2fu5HL2hqTimKyt2ZO7ZktX/OSwk0z10mbh4hOJj1gmI9qmR8QC1nkWPuK5BFzdNs
         0qLWjInpJkiEuTLcF66aML8TrCoBXz0Q0vfqMkqtn0P0z5zuJ4pXIGA0OkgbIrmkBGJh
         xIlzPppYV/nW/gtCMbbTxbo+ztOt5KdrNeMxldTDcfLFug57vV3gZ5fXjDlXLmxjUInG
         mYzA==
X-Gm-Message-State: AGi0PubF0cV0/gY5QgECVjC31gVB9J++b4kwaFsWERd/CNsigWH2O4BC
        4WmlpaGnEC1Av1S+IKnlhWkYMIygH14bs6fQgRsLVADb
X-Google-Smtp-Source: APiQypJ0Fs3PcwKfkKcHyjgGgxhfZuNgVa8e5iaXVKwFo+zNUp9biaTLwEjGUEdLemWZY4+uL2UF7KcIqKLjdPeKCrU=
X-Received: by 2002:a25:abcc:: with SMTP id v70mr5165263ybi.364.1588950803175;
 Fri, 08 May 2020 08:13:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200508143414.42022-1-edumazet@google.com> <362c2030-6e7f-512d-4285-d904b4a433b6@gmail.com>
 <a5f381b0-e2bf-05f9-a849-d9d45aa38212@gmail.com> <92c6ab11-3022-a01a-95db-13f6da8637cc@gmail.com>
In-Reply-To: <92c6ab11-3022-a01a-95db-13f6da8637cc@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 8 May 2020 08:13:11 -0700
Message-ID: <CANn89iJFZCid4eKEx+HW25rLEfyDTzLvPK391aT5tCZzSBCX5w@mail.gmail.com>
Subject: Re: [PATCH net-next] ipv6: use DST_NOCOUNT in ip6_rt_pcpu_alloc()
To:     David Ahern <dsahern@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        David Ahern <dsahern@kernel.org>, Wei Wang <weiwan@google.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 8:04 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/8/20 8:43 AM, Eric Dumazet wrote:
> > This patch can be backported without any pains ;)
>
> sure, but you tagged it as net-next, not net.

Because it is not a recent regression.
We are late in rc cycle.

I tend to push patches on net-next, then ask later for stable
backports once we are sure no regression was added,
even for patches that look 'very safe'  ;)



>
> >
> > Getting rid of limits, even for exceptions ?
>
> Running through where dst entries are created in IPv6:
> 1. pcpu cache
> 2. uncached_list
> 3. exceptions like pmtu and redirect
>
> All of those match IPv4 and as I recall IPv4 does not have any limits,
> even on exceptions and redirect. If IPv4 does not have limits, why
> should IPv6? And if the argument is uncontrolled memory consumption, is
> there an expectation that IPv6 generates more exceptions?
>
> My argument really just boils down to consistency between them. IPv4
> does not use DST_NOCOUNT, so why put that burden on v6?

That is something that needs further investigation.
Too many fires at this moment on my plate.

My patch stops bleeding right now.

Thanks.
