Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA4A4BC4F0
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 11:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395220AbfIXJgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 05:36:10 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:52867 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391886AbfIXJgJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 05:36:09 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3fd36e3c;
        Tue, 24 Sep 2019 08:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to
        :content-type; s=mail; bh=ChSHAXqyn3Ncl6cEq2PRPZaHfB8=; b=S58XLE
        QA3dHV4z8Jl4LexM8aaT7HSeMG29CVH+0RosC4IpwNyom42LeBYOmA9slK0FfWfF
        1aqBwMLpF741WWKrmnDlYZXfmJA/7BPJvwAcLyga0VCRgJwm0wY1JWJGbfaafVMy
        KExefBq8nTHu0FZkHArOgCEmcGxvPclmQVIeSFdm0eYyata4b0WZ0DqgD0jSJeWd
        gAtRb+MgaFUx8/OeQSGGZSoP2OBGCHenlnuKRw5TTaZrkwyYjvMnpZxCgFPXruOD
        v8/cAW0G2tL+oz/f1dn4Fa6iaOjr7VtBDJQypfGBQpQWIpKmPTCsuHW9hyxNxf/s
        x/mLvJG3j4NeYNpQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 220ea439 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 24 Sep 2019 08:50:30 +0000 (UTC)
Received: by mail-oi1-f173.google.com with SMTP id k25so1018735oiw.13;
        Tue, 24 Sep 2019 02:36:06 -0700 (PDT)
X-Gm-Message-State: APjAAAUrHTbGRB6/1sLHiXtyvNDs8TCLBmzEY2LkmtqwR0GcWuoul1rO
        1ogABMd7QYiZfpCaSEb6VJqugHUvKAgU9NBoD9Y=
X-Google-Smtp-Source: APXvYqzLuNmz55IapdVuTxSTQ4+LBZumFVg64K+c4MEqi2IVBK/qyzpRMWi+eR2HMN21J87pQAryxyfdbuLs1qSuhBA=
X-Received: by 2002:a54:4807:: with SMTP id j7mr1208315oij.122.1569317765847;
 Tue, 24 Sep 2019 02:36:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190924073615.31704-1-Jason@zx2c4.com>
In-Reply-To: <20190924073615.31704-1-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 24 Sep 2019 11:35:54 +0200
X-Gmail-Original-Message-ID: <CAHmME9qQUMYdNjTanF-C5PcBTgm3CioYw7zkXsDgA2mWOk_KOA@mail.gmail.com>
Message-ID: <CAHmME9qQUMYdNjTanF-C5PcBTgm3CioYw7zkXsDgA2mWOk_KOA@mail.gmail.com>
Subject: Re: [PATCH] ipv6: do not free rt if FIB_LOOKUP_NOREF is set on
 suppress rule
To:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Wei,

I meant to CC you but slipped up. Sorry about that. Take a look at
this thread if you have a chance.

Thanks,
Jason

On Tue, Sep 24, 2019 at 10:03 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Commit 7d9e5f422150 removed references from certain dsts, but accounting
> for this never translated down into the fib6 suppression code. This bug
> was triggered by WireGuard users who use wg-quick(8), which uses the
> "suppress-prefix" directive to ip-rule(8) for routing all of their
> internet traffic without routing loops. The test case in the link of
> this commit reliably triggers various crashes due to the use-after-free
> caused by the reference underflow.
>
> Cc: stable@vger.kernel.org
> Fixes: 7d9e5f422150 ("ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF")
> Test-case: https://git.zx2c4.com/WireGuard/commit/?id=ad66532000f7a20b149e47c5eb3a957362c8e161
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  net/ipv6/fib6_rules.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> index d22b6c140f23..f9e8fe3ff0c5 100644
> --- a/net/ipv6/fib6_rules.c
> +++ b/net/ipv6/fib6_rules.c
> @@ -287,7 +287,8 @@ static bool fib6_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg
>         return false;
>
>  suppress_route:
> -       ip6_rt_put(rt);
> +       if (!(arg->flags & FIB_LOOKUP_NOREF))
> +               ip6_rt_put(rt);
>         return true;
>  }
>
> --
> 2.21.0

On Tue, Sep 24, 2019 at 10:03 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Commit 7d9e5f422150 removed references from certain dsts, but accounting
> for this never translated down into the fib6 suppression code. This bug
> was triggered by WireGuard users who use wg-quick(8), which uses the
> "suppress-prefix" directive to ip-rule(8) for routing all of their
> internet traffic without routing loops. The test case in the link of
> this commit reliably triggers various crashes due to the use-after-free
> caused by the reference underflow.
>
> Cc: stable@vger.kernel.org
> Fixes: 7d9e5f422150 ("ipv6: convert major tx path to use RT6_LOOKUP_F_DST_NOREF")
> Test-case: https://git.zx2c4.com/WireGuard/commit/?id=ad66532000f7a20b149e47c5eb3a957362c8e161
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  net/ipv6/fib6_rules.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> index d22b6c140f23..f9e8fe3ff0c5 100644
> --- a/net/ipv6/fib6_rules.c
> +++ b/net/ipv6/fib6_rules.c
> @@ -287,7 +287,8 @@ static bool fib6_rule_suppress(struct fib_rule *rule, struct fib_lookup_arg *arg
>         return false;
>
>  suppress_route:
> -       ip6_rt_put(rt);
> +       if (!(arg->flags & FIB_LOOKUP_NOREF))
> +               ip6_rt_put(rt);
>         return true;
>  }
>
> --
> 2.21.0



-- 
Jason A. Donenfeld
Deep Space Explorer
fr: +33 6 51 90 82 66
us: +1 513 476 1200
