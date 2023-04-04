Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF436D563E
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 03:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbjDDBqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 21:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbjDDBqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 21:46:42 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9684BBD
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 18:46:39 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id v20-20020a05600c471400b003ed8826253aso276584wmo.0
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 18:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680572798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9UGKRf6WwmEqeiYClMrVY84NYga1ubuTTskKkh4+x3A=;
        b=kLWH9k2BrcsjCnABMWX+jk5alczoWLQ7Cdafi9DioMAbggfZ/4Lser6Jc00uQVynDx
         QpoTmmeS5wQvJOuE10zhDju4pXMqOOkydxYuTYVV8VRj/WuivpV28x0UQdfFN7vkQEXG
         UOrPR94UPhMB4KbAEoJJC/XyI9S2I9pYfaD5gA9mfU6v7TwQmYA0W8sJLi5oOK7R9O65
         WqFzWFE8RvOdJh1B/8p59N/d3HUQnkwmRoovHge0jOKyTO5Nw2fnunLPKcQCyfcYx579
         5sr/abxpKgpqbPswLI2Z4CgVfZg7UjSvQS26Ef66NNfY8x2KsY6y1RAM2OGJWTRPTFZz
         UQ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680572798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9UGKRf6WwmEqeiYClMrVY84NYga1ubuTTskKkh4+x3A=;
        b=BWWDRXP02dhE+0V77ZUsYz7clPm4Pr59OLORpv2t9E5eUmgDUXelGOPS6yalouqCsL
         aFaNBuEcx478o8oKHTd8dWb3P6t4Q15ajCpYS+jVODRmcOidMWlaoSAmVK2Mo/Z8DPCA
         E/EkAjo+Lg2/ysnQMpvLh3wBMMANF8hAuoxDQL904XyBHkIH+l7Dd6otnh/PgNgzNq2B
         M41iEDQ5wEHEbYFBoot2L/rFE3LQX4nSt2iquGasjc5wlJnT+SJfBqBZzLJn4+uEbgjm
         SSIPkzDN+IgviaFPFukJfhERfQsAS2+EngvZdJIpOuZFxZqLBrvECWNfGeo4wrcslxkx
         PD6A==
X-Gm-Message-State: AAQBX9fp83NB5z9OgWY8VlweZBlub4LXKW50r6AJRsG0P2PupSkIpgu1
        e0ZXonWVGPgvdCR/kBiIsyuqoVunCy35ejz4S9ZTnA==
X-Google-Smtp-Source: AKy350bM8HvFZliW2LA3sJc8tj7jqJL40eTIzNxyB6q2pck++QLf+bXCuNOcSa0fypwlHZ7waTSg4ms9DHLTW3P11/Y=
X-Received: by 2002:a7b:ca4f:0:b0:3ed:d6cb:d025 with SMTP id
 m15-20020a7bca4f000000b003edd6cbd025mr337877wml.0.1680572797906; Mon, 03 Apr
 2023 18:46:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230403194959.48928-1-kuniyu@amazon.com> <20230403194959.48928-2-kuniyu@amazon.com>
In-Reply-To: <20230403194959.48928-2-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Apr 2023 03:46:25 +0200
Message-ID: <CANn89i+b5DwKtAVe2PF5Qh+r8mL6bZEL_2bpjAHAMOu_52QmFg@mail.gmail.com>
Subject: Re: [PATCH v1 net 1/2] raw: Fix NULL deref in raw_get_next().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>,
        "Dae R . Jeong" <threeearcat@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 3, 2023 at 9:51=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.com=
> wrote:
>
> Dae R. Jeong reported a NULL deref in raw_get_next() [0].
>
> It seems that the repro was running these sequences in parallel so
> that one thread was iterating on a socket that was being freed in
> another netns.
>
>   unshare(0x40060200)
>   r0 =3D syz_open_procfs(0x0, &(0x7f0000002080)=3D'net/raw\x00')
>   socket$inet_icmp_raw(0x2, 0x3, 0x1)
>   pread64(r0, &(0x7f0000000000)=3D""/10, 0xa, 0x10000000007f)
>
> After commit 0daf07e52709 ("raw: convert raw sockets to RCU"), we
> use RCU and hlist_nulls_for_each_entry() to iterate over SOCK_RAW
> sockets.  However, we should use spinlock for slow paths to avoid
> the NULL deref.
>
> Also, SOCK_RAW does not use SLAB_TYPESAFE_BY_RCU, and the slab object
> is not reused during iteration in the grace period.  In fact, the
> lockless readers do not check the nulls marker with get_nulls_value().
> So, SOCK_RAW should use hlist instead of hlist_nulls.
>
> Instead of adding an unnecessary barrier by sk_nulls_for_each_rcu(),
> let's convert hlist_nulls to hlist and use sk_for_each_rcu() for
> fast paths and sk_for_each() and spinlock for /proc/net/raw.
>
> Fixes: 0daf07e52709 ("raw: convert raw sockets to RCU")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Reported-by: Dae R. Jeong <threeearcat@gmail.com>
> Link: https://lore.kernel.org/netdev/ZCA2mGV_cmq7lIfV@dragonet/
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  include/net/raw.h   |  4 ++--
>  net/ipv4/raw.c      | 36 +++++++++++++++++++-----------------
>  net/ipv4/raw_diag.c | 10 ++++------
>  net/ipv6/raw.c      | 10 ++++------
>  4 files changed, 29 insertions(+), 31 deletions(-)
>

SGTM, thanks a lot.
Reviewed-by: Eric Dumazet <edumazet@google.com>
