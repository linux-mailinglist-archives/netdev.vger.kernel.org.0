Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499F857E511
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 19:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbiGVRIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 13:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiGVRIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 13:08:36 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0941F2C66C
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:08:36 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id i206so9080408ybc.5
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 10:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1oonNDNw04BLhR0qEHb+lAr6PC1qbpR5yOT7gcigi1Q=;
        b=KFTLe1RLPoWSz0ZZ7f5813V9RQhBaeBSsr/vgvrcyRK1Vm3KXgt7vB9ZxWySi5Pl52
         xknqw1rJps23uRnYDNI0jxDSRtj5Q7AIZW7Cl1KhFCz/Pdp15blbBUIU8GJAR/0RKEcK
         Wi/37qpK6cmBbvBe19CN3edjAWjt/SDEZP01geNe3QiFhG2GWG7wbDxSSU/w5mDzElh8
         /QOYvqK4rE0m6WhLrDv0mKScrgj364UDNETM5qh2wX+ww8JxdeHIgLj5g/6JdBWJJ5Zs
         tu3LZMwF12eSrNxilM1BND3J//QZ4uIrfJa9eUq1RW4NuTPQn1ovny5uU9cUCzxNdu1I
         G0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1oonNDNw04BLhR0qEHb+lAr6PC1qbpR5yOT7gcigi1Q=;
        b=h+PKJkidbqelDgLmPyBV20n6mLiRuiUjNO3v3Gj7rZ7DC+nr+m9dzFhQpLBNNOgR9d
         7Ax5zZ4Ve+KQ+UQ/T6e385LFN9q/5vGGaU4WcF2ufg7i6BF5hS3F32qajgsqWrSNEe8J
         pMZ+7ViVXorVXMn5FUMgyvjP0N1S0DzusH5SVbT+baHFMnxyQkzwNW3qwfUK6Kze9WWN
         JsB/E65KWE/bE7hbWNhsHfEVDzmqF0RUfSIU2DjeBmBQ134UtldYRrWb4bbczpFQ9DY+
         p6Pl94Itic/SGZfaZlUTtr8CyoGeHLz779qcYR1m5KBttpd1BYPaVy3OPLlY9ZrURJTI
         WDOQ==
X-Gm-Message-State: AJIora+A7DAZ+eP0xJoKlmdOvA9tUKLS3wI08wtIBjEhbOrvrG2QywPh
        chcssQPJ1HTMnf5TsXbZIVQwNg9cHM1t9IzPddL0RA==
X-Google-Smtp-Source: AGRyM1uYKk0ciWyA19Qlb0O0UOsAE6m3O3EotWKFR6pnyDUzXbFPP6WmHUjBSzJYwb8ay3L8lkLEfSlgMGiQGX79zPA=
X-Received: by 2002:a25:13c8:0:b0:670:6a55:5fad with SMTP id
 191-20020a2513c8000000b006706a555fadmr825049ybt.598.1658509714941; Fri, 22
 Jul 2022 10:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220722170635.14847-1-ap420073@gmail.com>
In-Reply-To: <20220722170635.14847-1-ap420073@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Jul 2022 19:08:23 +0200
Message-ID: <CANn89iLW5dbuepQ1m-haz=ji4rQv1JVp=uAGacdKCsGfdrUaFA@mail.gmail.com>
Subject: Re: [PATCH net v2] net: mld: fix reference count leak in mld_{query | report}_work()
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Jul 22, 2022 at 7:06 PM Taehee Yoo <ap420073@gmail.com> wrote:
>
> mld_{query | report}_work() processes queued events.
> If there are too many events in the queue, it re-queue a work.
> And then, it returns without in6_dev_put().
> But if queuing is failed, it should call in6_dev_put(), but it doesn't.
> So, a reference count leak would occur.
>
> THREAD0                         THREAD1
> mld_report_work()
>                                 spin_lock_bh()
>                                 if (!mod_delayed_work())
>                                         in6_dev_hold();
>                                 spin_unlock_bh()
>         spin_lock_bh()
>         schedule_delayed_work()
>         spin_unlock_bh()
>
> Script to reproduce(by Hangbin Liu):
>    ip netns add ns1
>    ip netns add ns2
>    ip netns exec ns1 sysctl -w net.ipv6.conf.all.force_mld_version=1
>    ip netns exec ns2 sysctl -w net.ipv6.conf.all.force_mld_version=1
>
>    ip -n ns1 link add veth0 type veth peer name veth0 netns ns2
>    ip -n ns1 link set veth0 up
>    ip -n ns2 link set veth0 up
>
>    for i in `seq 50`; do
>            for j in `seq 100`; do
>                    ip -n ns1 addr add 2021:${i}::${j}/64 dev veth0
>                    ip -n ns2 addr add 2022:${i}::${j}/64 dev veth0
>            done
>    done
>    modprobe -r veth
>    ip -a netns del
>

> Tested-by: Hangbin Liu <liuhangbin@gmail.com>
> Fixes: f185de28d9ae ("mld: add new workqueues for process mld events")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
