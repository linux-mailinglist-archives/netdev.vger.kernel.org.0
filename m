Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573293E4ECD
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236474AbhHIV5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235126AbhHIV5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 17:57:42 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFB7C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 14:57:21 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id q10so72795wro.2
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 14:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i6r1YDsft4PMj0Q8J5QEQRpw7a88njvmVwr10GKJnUE=;
        b=kAkq6gm13RT/x8amBshy7/N2YQ7u2CyJuJX7SbarPzZa/v+V/wnKB8lFChxjes+Us+
         WoovD1EKNMX+UVxVM89qWSak1Ufj6DwcccONqn3eg0x8+03ffXmPl6sBRRvaDvi8ycUg
         yS1jJjxm9k4LM7Gc1oe6NwEthm99B4s5sUsdp+V+xDKfxSxeHTX/l15bfGymghd2Wmli
         wwSMjaYzubdeTOiSzeCAbx328JVf0C4a6Y3HHbILSuLCxDD7Z9Jxx6MipN+Robktws6m
         Naqxz0izIYmFhdw7h++KPCZpKsuF7T/EcFJPPwU6ofRKU4LHG/vybpXwN/Ds4qZZQcbP
         nW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i6r1YDsft4PMj0Q8J5QEQRpw7a88njvmVwr10GKJnUE=;
        b=WxxZK8tp1nIZsGExcSV86JhFF90ssxMbe9s0A1sML8PpC0TrxEM/KCe5u95V9fhpZG
         iRgFLdETsqOsKzDT8ZTOe0KOssWSZKUeOkrp3cVef7towwr2AyHRxzpSc2j//NwxKmXt
         NTh4i5j99nn/IqRlfmf0UeBMty95nAotplki1jQcnDBqiMaq2KfgmEBoD4+OjJTjC5XR
         bVCzZWYAms/42x4lkAM8ssHz1wnh6Qtz927AmpepcICyjuLjxHPl/iZQCHlxRZxn+ess
         Oviokyf5V0380D/osWbZaZjS7SoUk1TENKrOMq6w7YN6njNH7dbk9uNQkRmqe3hkjqLI
         PgpA==
X-Gm-Message-State: AOAM531LMT1W7fKvGKJ2Kd6g+nvIRRaiq6gyE9ntWuJSb/NIO3URSjQm
        kheF+IHHa2VIIuXsbB2eBOpK0mPE0KP5RBjgqE7BRA==
X-Google-Smtp-Source: ABdhPJxRzhCsy1l4UMk0AkoUOnNRd2nZ6qMMfi9hjs7tSccocS2oHTUwv1I2SEBndqbyWs0p9niWl9YJf87+MXKqZJU=
X-Received: by 2002:adf:ba4d:: with SMTP id t13mr5834797wrg.424.1628546239802;
 Mon, 09 Aug 2021 14:57:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210809185314.38187-1-tom@herbertland.com>
In-Reply-To: <20210809185314.38187-1-tom@herbertland.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Mon, 9 Aug 2021 14:56:42 -0700
Message-ID: <CAK6E8=eV9KgcvXRGH1E6eK2NQGRUfpKLH4xmkyj-CjydVZfKXQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/3] txhash: Make hash rethink configurable
 and change the default
To:     Tom Herbert <tom@herbertland.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, brakmo@fb.com,
        eric.dumazet@gmail.com, a.e.azimov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 9, 2021 at 11:53 AM Tom Herbert <tom@herbertland.com> wrote:
>
> Alexander Azimov performed some nice analysis of the feature in Linux
> stack where the IPv6 flow label is changed when the stack detects a
> connection is failing. The idea of the algorithm is to try to find a
> better path. His reults are quite impressive, and show that this form
> of source routing can work effectively.
>
> Alex raised an issue in that if the server endpoint is an IP anycast
> address, the connection might break if the flow label changes routing
> of packets on the connection. Anycast is known to be susceptible to
> route changes, not just those caused be flow label. The concern is that
> flow label modulation might increases the chances that anycast
> connections might break, especially if the rethink occurs after just
> one RTO which is the current behavior.
>
> This patch set makes the rethink behavior granular and configurable.
> It allows control of when to do the hash rethink: upon negative advice,
> at RTO in SYN state, at RTO when not in SYN state. The behavior can
> be configured by sysctl and by a socket option.
>
> This patch set the defautl rethink behavior to be to do a rethink only
> on negative advice. This is reverts back to the original behavior of
> the hash rethink mechanism. This less aggressive with the intent of
Thanks for offering knobs to the txhash mechanism.

Any reason why reverting the default behavior (that was changed in
2013) is necessary? systems now rely on this RTO tx-rehash to work
around link failures will now have to manually re-enable it. Some
users may have to learn from higher connection failures to eventually
identify this kernel change.

> mitigating potentail breakages when anycast addresses are present.> For those users that are benefitting from changing the hash at the
> first RTO, they would retain that behavior by setting the sysctl.
> *** BLURB HERE ***
>
> Tom Herbert (3):
>   txhash: Make rethinking txhash behavior configurable via sysctl
>   txhash: Add socket option to control TX hash rethink behavior
>   txhash: Change default rethink behavior to be less aggressive
>
>  arch/alpha/include/uapi/asm/socket.h  |  2 ++
>  arch/mips/include/uapi/asm/socket.h   |  2 ++
>  arch/parisc/include/uapi/asm/socket.h |  2 ++
>  arch/sparc/include/uapi/asm/socket.h  |  3 ++-
>  include/net/netns/core.h              |  2 ++
>  include/net/sock.h                    | 32 +++++++++++++++++++--------
>  include/uapi/asm-generic/socket.h     |  2 ++
>  include/uapi/linux/socket.h           | 13 +++++++++++
>  net/core/net_namespace.c              |  4 ++++
>  net/core/sock.c                       | 16 ++++++++++++++
>  net/core/sysctl_net_core.c            |  7 ++++++
>  net/ipv4/tcp_input.c                  |  2 +-
>  net/ipv4/tcp_timer.c                  |  5 ++++-
>  13 files changed, 80 insertions(+), 12 deletions(-)
>
> --
> 2.25.1
>
