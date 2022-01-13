Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479A648D94E
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 14:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbiAMNur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 08:50:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35590 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiAMNuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 08:50:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FBE7B82192;
        Thu, 13 Jan 2022 13:50:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F83AC36AF3;
        Thu, 13 Jan 2022 13:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642081842;
        bh=0dPnfDAfzWwfREwcw1ihA3ioqPWcTtvFnrsR1ynBa9Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OtTYdDc/o4zDLIFuBQAnZtOmd5hVrMnHhC0+DsB4nMA7RX5vnGM8GxDG62UyuVBjL
         6ANjgzVR35OZqa3K2SawWs2EzC/yiGEW50WWAJ7ree7oCoFxwFdEmjPlRvpl/30MO5
         TsD+ANnvMvBuZfz4EUjKNMaKrSzv9HtFwUzdJVYfPgW8Ni61IsGvKAjn3dTNY986Qu
         qrPPZeQwAIv+vZ4NwsxTXolRqnaql3q7tZR8DoyoZH8rlrQRr3M4dAPnrXLDSwCyp5
         vtOyIG7Nr3cwAelCkJx826rKCjFDO2CwmqVkQ0VjMkjCZUu5aS9AtSftG/JI+KEVdT
         HmIGmDiYJ+t3w==
Received: by mail-wr1-f46.google.com with SMTP id o3so10177615wrh.10;
        Thu, 13 Jan 2022 05:50:42 -0800 (PST)
X-Gm-Message-State: AOAM5309Qxaszzx+No/G7KBRn0LT5io7je4OO4ZMp9KMoUXrPSpvMc8c
        t7Iqir/UnKq05lYXwr2YaD84ggw2ZYlyAHV0D68=
X-Google-Smtp-Source: ABdhPJyiD6bYcb9SP1t9QjTKJFY4EUulWBo1nrWfh5lWKTe2cZrNA2ULiqQqsHhp4xS9MmxioRGvKkI7vhfunT1Sc1I=
X-Received: by 2002:a5d:6541:: with SMTP id z1mr1620838wrv.550.1642081840416;
 Thu, 13 Jan 2022 05:50:40 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-3-Jason@zx2c4.com>
 <87r19cftbr.fsf@toke.dk> <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
 <55d185a8-31ea-51d0-d9be-debd490cd204@stressinduktion.org>
 <CAMj1kXGz7_98B_b=SJER6-Q2g-nOT5X3cfN=nfhYoH0eHep5bw@mail.gmail.com>
 <87ilung3uo.fsf@toke.dk> <CAHmME9onde38SNBBsmypzr_QDSDiQ_0opPiqJ7sU5X-iMDtncQ@mail.gmail.com>
In-Reply-To: <CAHmME9onde38SNBBsmypzr_QDSDiQ_0opPiqJ7sU5X-iMDtncQ@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 13 Jan 2022 14:50:28 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE0Hhi1kgXx2vNchoKOrQOZEBg1V6c5w7if3yN4_GNn8g@mail.gmail.com>
Message-ID: <CAMj1kXE0Hhi1kgXx2vNchoKOrQOZEBg1V6c5w7if3yN4_GNn8g@mail.gmail.com>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address calculation
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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

On Thu, 13 Jan 2022 at 14:46, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Toke,
>
> On Thu, Jan 13, 2022 at 2:30 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> > Right, but that implies we need to work on a transition mechanism. For
> > newly deployed systems changing the hash is obviously fine, it's the
> > "reboot and you have a new address" problem.
> >
> > We could introduce new values to the addr_gen_mode? I.e. values of 4 an=
d
> > 5 would be equivalent to 2 and 3 (respectively), but with the new
> > hashing algorithm? And then document that 2 and 3 are considered
> > deprecated to be removed at some point in the future...
>
> Right, so this is exactly the flow of conversation I anticipated.
> "Let's change it!" "No, we can't." "Okay, let's add a knob."
>
> The knob I was thinking about, though, was actually a compile-time one
> CONFIG_NET_OBSOLETE_INSECURE_ADDRCONF_HASH, which itself is a `depends
> on CONFIG_OLD_N_CRUSTY` or something. This way we could gate the
> inclusion of sha1.c/sha1.o on that at compile time, and shave down
> vmlinux a bit, which would make Geert happy.
>
> Then, at some point down the road, we can talk about removing
> CONFIG_NET_OBSOLETE_INSECURE_ADDRCONF_HASH too.
>

What is the point of having CONFIG_OLD_N_CRUSTY if all distros are
going to enable it indefinitely?
