Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB36358F8C
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbhDHV42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:56:28 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:40568 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232158AbhDHV40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 17:56:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1617918971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E8c9jpFWITAOlT7m5p8zO+XndS8kVhIlBnFNm7YNzCI=;
        b=GtjVOs3XfNptCCR15XckGdJGWug0G7ZvYVcqi+hSoWm7kTKYImxHBS+3wbXFS6CBEz/uZb
        Xte6O20rHqpIo8RZyjRP4cmE7cZe2HdjnZaIiDZlh+ZZbuCRQdGkBD2aSHPUNFtV2ykg9H
        97c96WbtxaUJAqVLIk4/1nOYc9vD9Bw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b9c7ebea (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 8 Apr 2021 21:56:11 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id j206so4331730ybj.11;
        Thu, 08 Apr 2021 14:56:11 -0700 (PDT)
X-Gm-Message-State: AOAM532Hp4h268A85hbef0Rzzx+9dUeYVIf4vQffOtYIKEBpN3aei5Nq
        HWIQiWr3TR03p6vAosgXth2KQQoWVpDpv3WFB28=
X-Google-Smtp-Source: ABdhPJzWPJe5ATvftmVbz5f6ipcWLhvh1LLBmESrELmqDCFR2qyYQfVheLfR6Yicc5IlYSrvpMYDwkVxXUYqsqwxaCk=
X-Received: by 2002:a05:6902:1003:: with SMTP id w3mr9879167ybt.123.1617918970511;
 Thu, 08 Apr 2021 14:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com> <c47d99b9d0efeea4e6cd238c2affc0fbe296b53c.camel@redhat.com>
In-Reply-To: <c47d99b9d0efeea4e6cd238c2affc0fbe296b53c.camel@redhat.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 8 Apr 2021 15:55:59 -0600
X-Gmail-Original-Message-ID: <CAHmME9pRSOANrdvegLm9x8VTNWKcMtoymYrgStuSx+nsu=jpwA@mail.gmail.com>
Message-ID: <CAHmME9pRSOANrdvegLm9x8VTNWKcMtoymYrgStuSx+nsu=jpwA@mail.gmail.com>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
To:     Simo Sorce <simo@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 8, 2021 at 7:55 AM Simo Sorce <simo@redhat.com> wrote:
> > I'm not sure this makes so much sense to do _in wireguard_. If you
> > feel like the FIPS-allergic part is actually blake, 25519, chacha, and
> > poly1305, then wouldn't it make most sense to disable _those_ modules
> > instead? And then the various things that rely on those (such as
> > wireguard, but maybe there are other things too, like
> > security/keys/big_key.c) would be naturally disabled transitively?
>
> The reason why it is better to disable the whole module is that it
> provide much better feedback to users. Letting init go through and then
> just fail operations once someone tries to use it is much harder to
> deal with in terms of figuring out what went wrong.
> Also wireguard seem to be poking directly into the algorithms
> implementations and not use the crypto API, so disabling individual
> algorithm via the regular fips_enabled mechanism at runtime doesn't
> work.

What I'm suggesting _would_ work in basically the exact same way as
this patch. Namely, something like:

diff --git a/lib/crypto/curve25519.c b/lib/crypto/curve25519.c
index 288a62cd29b2..b794f49c291a 100644
--- a/lib/crypto/curve25519.c
+++ b/lib/crypto/curve25519.c
@@ -12,11 +12,15 @@
 #include <crypto/curve25519.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/fips.h>

 bool curve25519_selftest(void);

 static int __init mod_init(void)
 {
+ if (!fips_enabled)
+ return -EOPNOTSUPP;
+
  if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER_DISABLE_TESTS) &&
      WARN_ON(!curve25519_selftest()))
  return -ENODEV;

Making the various lib/crypto/* modules return EOPNOTSUPP will in turn
mean that wireguard will refuse to load, due to !fips_enabled. It has
the positive effect that all other things that use it will also be
EOPNOTSUPP.

For example, what are you doing about big_key.c? Right now, I assume
nothing. But this way, you'd get all of the various effects for free.
Are you going to continuously audit all uses of non-FIPS crypto and
add `if (!fips_enabled)` to every new use case, always, everywhere,
from now into the boundless future? By adding `if (!fips_enabled)` to
wireguard, that's what you're signing yourself up for. Instead, by
restricting the lib/crypto/* modules to !fips_enabled, you can get all
of those transitive effects without having to do anything additional.

Alternatively, I agree with Eric - why not just consider this outside
your boundary?

Jason
