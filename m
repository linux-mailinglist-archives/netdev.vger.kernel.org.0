Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B050850E400
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 17:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242460AbiDYPI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 11:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbiDYPI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 11:08:57 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6C422BCE
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 08:05:51 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id w187so18168540ybe.2
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 08:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uFTNav1z5LSmioVIFxM+yd5bfsCUGOiyysRueZnybkU=;
        b=DTmx+h0LWCwrCRwn/0uESGGf63iWcuBCJF3sKl71mM88n3DYPXt5LiWHzryN2pQTlB
         Nt1Po/19e5MKXM2KtQQk0kzaGHOPGthd8Jbw8lQxGdqJvQG2Itnfvwwt2lB13J20UXue
         LoMp2g3yQCgmr5pwa6oeQLmFssmsMzmEPM/6ko29Sb2KNWf86rneTIx8ZpIh8QSa+MVM
         YmOntpLUa3sgOr+0EXaPmPm/brb/MTkc+Ir1xUaO6kjtN/lSW4o+/VlAw2s2AOr4T25C
         uEanmQyn5RC5dBqPUnNs1fsaslXsEzw5g0KL8s8eTODK47eGk2gcX1seK9iua5tGn5o3
         +2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uFTNav1z5LSmioVIFxM+yd5bfsCUGOiyysRueZnybkU=;
        b=fLD11aHdzi5oDNRqBF1UWAtNtcpkQOy2vP4iIkBh+yZDEUaqrVvUpE39I7nUx3bFWn
         SD+BSqJ+woAJUIvaZ9PWyJeVUFQq+rya4zemVKcYCMD5mJuKZI3Gph0wH4GIUoe/o8H8
         7C09ARI3MtxyMoJnQOvgy8N95l3ccCUhyicbP5aDrMFhUd71Qtxv1sT2VzHjDG7TWEHL
         zUZtBGNUjU/oDh8mvvAHZUuMT+REWZBrdNXMm4xSqF6CLBpiPj1SuxH//LNZgXzNKqqX
         8BxrfPeIRvSVBagpRFT9XxJR7mK0LTJwQgr/My6ZN/DhcD/jw4WJIrheYgRCAFugVcWv
         btlQ==
X-Gm-Message-State: AOAM533gZ0RrYN7kNGUk4TYAxVvBE7D5W2B30btbTW7wXM/PIFy04G9j
        3owhQT/xr96jWSuAWfg/aWzVaQUXnP9hAWpDPUyxu7mOf5H7IQ==
X-Google-Smtp-Source: ABdhPJxxfL23HUApgOQ+QNN1P5xP+P4r5SJLzaGYyILLLw3C4InUN4GdTn6vrt/ewfyDQYlTZt2TFeQI9DoWPMBTfR8=
X-Received: by 2002:a25:ea48:0:b0:644:e2e5:309 with SMTP id
 o8-20020a25ea48000000b00644e2e50309mr16291855ybe.407.1650899150745; Mon, 25
 Apr 2022 08:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220425003407.3002429-1-eric.dumazet@gmail.com> <CAA93jw7uoMCWT9oF52NhgozgCTJ4TAxpgNMNAZTaKqCpMR7uOg@mail.gmail.com>
In-Reply-To: <CAA93jw7uoMCWT9oF52NhgozgCTJ4TAxpgNMNAZTaKqCpMR7uOg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 25 Apr 2022 08:05:39 -0700
Message-ID: <CANn89iJ_tVji7LVm57Mp-NZZkza5eQf9-hqL802mvcUjs=yndQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Doug Porter <dsp@fb.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 6:16 AM Dave Taht <dave.taht@gmail.com> wrote:
>

>
> Thx! We have been having very good results with TCP_NOTSENT_LOWAT set
> to 32k or less behind an apache traffic server... and had some really
> puzzling ones at geosync RTTs. Now I gotta go retest.
>
> Side question: Is there a guide/set of recommendations to setting this
> value more appropriately, under what circumstances? Could it
> autoconfigure?

It is a tradeoff between memory usage in the kernel (storing data in
the socket transmit queue),
and the number of times the application is woken up to let it push
another chunk of data.

32k really means : No more than one skb at a time.  (An skb can
usually store about 64KB of payload)

At Google we have been using 2MB, but I suspect this was to work
around the bug I just fixed.
We probably could use a smaller value like 1MB, leading to one
EPOLLOUT for 1/2 MB.

Precise values also depend on how much work is needed in
tcp_sendmsg(), zerocopy can play a role here.

autoconfigure ? Not sure how. Once you have provisioned a server for a
given workload,
you are all set. No need to tune the value as a function of the load.

>
> net.ipv4.tcp_notsent_lowat =3D 32768

This probably has caused many stalls on long rtt / lossy links...

>
> --
> FQ World Domination pending: https://blog.cerowrt.org/post/state_of_fq_co=
del/
> Dave T=C3=A4ht CEO, TekLibre, LLC
