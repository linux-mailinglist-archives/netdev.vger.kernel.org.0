Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4EC48D944
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 14:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiAMNqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 08:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiAMNqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 08:46:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A474AC06173F;
        Thu, 13 Jan 2022 05:46:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 800BAB82192;
        Thu, 13 Jan 2022 13:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5259C36AED;
        Thu, 13 Jan 2022 13:46:16 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="nr1wVcyN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642081572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZDOEmJ/+j9elr0DybCikYtZEeZoImIpow5xqJFYgrf4=;
        b=nr1wVcyNt+isfDsyUsVmED0FfvcK8Pje9K+YaEHYuBWB+GmnJqx+0hlTypFGGSfxch3Ha7
        JeQsVLcZZFgpZ8+wXHK+x7NdAoyehpv/0l3sTPIPWDXABAHYC3TlXgCcDEoy0iGTzzZNV4
        kgjR/mdp76cq2Z2/D62V6rnHhQzQiAk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 37d63b2e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 13 Jan 2022 13:46:12 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id i68so374302ybg.7;
        Thu, 13 Jan 2022 05:46:12 -0800 (PST)
X-Gm-Message-State: AOAM530O3+ZsEwNWdGAATgAlj/j5enaIBlsvoMtumdBCzs/Hj+Ojmsq+
        SL5Ey4x4IbqX8uyixDTPY1qXm4oDt9v8KDUp4UM=
X-Google-Smtp-Source: ABdhPJztE9spksv6CQCLnB+dBbXGVk+3Cc3jcgbnD4ieM23/u7v/2fuOkMasB3pjmeMN2MRVs2vc98KAn2ie/iqOzq0=
X-Received: by 2002:a25:ae8d:: with SMTP id b13mr6747304ybj.255.1642081570673;
 Thu, 13 Jan 2022 05:46:10 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-3-Jason@zx2c4.com>
 <87r19cftbr.fsf@toke.dk> <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
 <55d185a8-31ea-51d0-d9be-debd490cd204@stressinduktion.org>
 <CAMj1kXGz7_98B_b=SJER6-Q2g-nOT5X3cfN=nfhYoH0eHep5bw@mail.gmail.com> <87ilung3uo.fsf@toke.dk>
In-Reply-To: <87ilung3uo.fsf@toke.dk>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 13 Jan 2022 14:45:59 +0100
X-Gmail-Original-Message-ID: <CAHmME9onde38SNBBsmypzr_QDSDiQ_0opPiqJ7sU5X-iMDtncQ@mail.gmail.com>
Message-ID: <CAHmME9onde38SNBBsmypzr_QDSDiQ_0opPiqJ7sU5X-iMDtncQ@mail.gmail.com>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address calculation
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Erik Kline <ek@google.com>,
        Fernando Gont <fgont@si6networks.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        YOSHIFUJI Hideaki <hideaki.yoshifuji@miraclelinux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

On Thu, Jan 13, 2022 at 2:30 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
> Right, but that implies we need to work on a transition mechanism. For
> newly deployed systems changing the hash is obviously fine, it's the
> "reboot and you have a new address" problem.
>
> We could introduce new values to the addr_gen_mode? I.e. values of 4 and
> 5 would be equivalent to 2 and 3 (respectively), but with the new
> hashing algorithm? And then document that 2 and 3 are considered
> deprecated to be removed at some point in the future...

Right, so this is exactly the flow of conversation I anticipated.
"Let's change it!" "No, we can't." "Okay, let's add a knob."

The knob I was thinking about, though, was actually a compile-time one
CONFIG_NET_OBSOLETE_INSECURE_ADDRCONF_HASH, which itself is a `depends
on CONFIG_OLD_N_CRUSTY` or something. This way we could gate the
inclusion of sha1.c/sha1.o on that at compile time, and shave down
vmlinux a bit, which would make Geert happy.

Then, at some point down the road, we can talk about removing
CONFIG_NET_OBSOLETE_INSECURE_ADDRCONF_HASH too.

Jason
