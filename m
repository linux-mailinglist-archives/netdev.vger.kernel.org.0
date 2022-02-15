Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E59A4B7AC2
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 23:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244658AbiBOWzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 17:55:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235253AbiBOWzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 17:55:40 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010B890FCD;
        Tue, 15 Feb 2022 14:55:29 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id g21so495235vsp.6;
        Tue, 15 Feb 2022 14:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KljjfGaV0qNt4Ev1SWfuB6ILy2vnkwj3ke0c4tgXkDM=;
        b=mbMo0Q4i+HlaNWhZT8LNGMSW0FdRYfBAJLjE0PFzMRGRJMdjKbxitQn7gU/vWHJ/q6
         HvfVRRq974rn1gScL5uXeVg/cZA9VLS+gVSXcEH0MufIw0Edw6MfBbmocdtGf2FvyPle
         N/6zSvrIUlLSlwNS7sU88ZX/JG4K5rprCbAiRuPxIc2qihmi0LQa747PkghiL+Eb1NG/
         SP4m16K9wANZQuk62vp0PkOGuM1K6tR4vMO91QNWtyKgZwU/muop4jzJdRV+MWFEoOMk
         ZPWSwpqYhPQeJNb7zIdWdQkZ17dnVC6cCBQI8AT0qOznenonzJgv90icdxeFDlwA4+Ip
         FkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KljjfGaV0qNt4Ev1SWfuB6ILy2vnkwj3ke0c4tgXkDM=;
        b=4jKXNTQX2/WEIKj8PYo6CPY9lxpHwqWenuN3XdNnyOoC8ptSMuKMv21q72AmfYpUC0
         6IeXP+ynmP5dmQ3JxI2CS0vndMLjJXK92on3jjk9p0QzumkmhZsI3l5Psn2VDxuqPrK3
         8OhSj7jJW4mzsk5Gmgt/nVVlwQSxiv7NxkBIS7G05Cm1bm+6mMpxyJjtPMe0wPyUswma
         bQbSbEwbZ9c10Oul6e0hBupnp0JI7vbwhBjqMAyaT14zMEQWqG7z4qgbYFvsZRhpIGJn
         OxQ4wgO/D2v/wOceBqrbcxVfv43D6aFKOUfW7ad1wZbTn+Mk1bidLaQ8RK9YCT6NKTto
         ellg==
X-Gm-Message-State: AOAM532CRUcS6xuPB3I3AM1K5IYy8B5ryD/Hd/ior/wWjBdeagFVlu5b
        s2sIF49PU9h+Nf5cMOxwYQFyZxHIqod1LQYNOUIIbvCMiJFV
X-Google-Smtp-Source: ABdhPJybrisSKT22sdMBiVzA1X9BxupYuQBcoJrjdciqXqEyZPvh8/tXEC6HfbTugPH1cYBwKz7hnpp4xQ4CAhBglSY=
X-Received: by 2002:a05:6102:c11:: with SMTP id x17mr452025vss.4.1644965729117;
 Tue, 15 Feb 2022 14:55:29 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9r4+ENUhZ6u26rAbq0iCWoKqTPYA7=_LWbGG98KvaCE6g@mail.gmail.com>
 <20220215162812.195716-1-Jason@zx2c4.com>
In-Reply-To: <20220215162812.195716-1-Jason@zx2c4.com>
From:   Rui Salvaterra <rsalvaterra@gmail.com>
Date:   Tue, 15 Feb 2022 22:55:18 +0000
Message-ID: <CALjTZvZb9oFLT5zOvxgt3ZrsOc+id8o3KXGFJobO6ks6UZtgWg@mail.gmail.com>
Subject: Re: [PATCH] ath9k: use hw_random API instead of directly dumping into random.c
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     miaoqing@codeaurora.org, Jason Cooper <jason@lakedaemon.net>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
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

Hi, Jason,

On Tue, 15 Feb 2022 at 22:44, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hardware random number generators are supposed to use the hw_random
> framework. This commit turns ath9k's kthread-based design into a proper
> hw_random driver.
>
> This compiles, but I have no hardware or other ability to determine
> whether it works. I'll leave further development up to the ath9k
> and hw_random maintainers.
>
> Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

[patch snipped]

On my laptop, with a=E2=80=A6

02:00.0 Network controller: Qualcomm Atheros AR9462 Wireless Network
Adapter (rev 01)

=E2=80=A6 I have the following=E2=80=A6

rui@arrandale:~$ cat /sys/devices/virtual/misc/hw_random/rng_available
ath9k
rui@arrandale:~$ cat /sys/devices/virtual/misc/hw_random/rng_current
ath9k
rui@arrandale:~$

=E2=80=A6 and sure enough, /dev/hwrng is created and outputs a stream of
random data, as expected. I haven't done any serious randomness
quality testing, but it should be the same as the one produced by the
original code. I consider this patch thus

Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>

Thanks,
Rui
