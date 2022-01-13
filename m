Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC46D48D93A
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 14:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiAMNlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 08:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiAMNlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 08:41:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9AFC06173F;
        Thu, 13 Jan 2022 05:41:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F14D61CDF;
        Thu, 13 Jan 2022 13:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E50C36AE3;
        Thu, 13 Jan 2022 13:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642081268;
        bh=aI0baOAfGLEbzn1+gJDDb+wqah4YdfQIOCyxUvi/QtQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dmsnjr8EslOCeNV9FtA9wE28oLSjpZ4GryUG3dVO5xjBG9sXMLcrW8SqSa/bH82yy
         hXQbuIjPWElqQfbyVhL3NBHyAmX8tFH6UBw+Wx80ESmDane1irFG9ypOn/7q1YDnv5
         WGudccOfQmG/W7Z3gRx7kNFHoseSAATrB+JRGmVuw083o4VMWB2TmewVzzFDoffc94
         63ki5xOM43VkGP2nTvrk7O1ShWCPUHSEXBz7anVz3Zkv3LlInR9yMAftuIQgWGbuvD
         e7TZ3oL087/M0O7z81pW+myOAqXFkKN6L3/stHZPiun9w8wJz+bZSobOWJk/ga9Z+g
         qaXdxX0pLLEZQ==
Received: by mail-wr1-f42.google.com with SMTP id q8so10100653wra.12;
        Thu, 13 Jan 2022 05:41:08 -0800 (PST)
X-Gm-Message-State: AOAM531NlqVPmHxaZb0rYoVWyaWhcHruRMRgnVV0LSIHgBqVWztJaPxH
        eGS0NPHAaQTpw1lzWNgj25dQv3ZR2CceGWMABSc=
X-Google-Smtp-Source: ABdhPJww58s7pauhu/LDRd3XbQ6pxAj6eTRRmW8kFxVLKzhyG7nk8rJ9JOkPOsj9VIzSTATnIh8OzIG/TpAgZoF87Fg=
X-Received: by 2002:a5d:6210:: with SMTP id y16mr3833704wru.454.1642081267090;
 Thu, 13 Jan 2022 05:41:07 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-3-Jason@zx2c4.com>
 <87r19cftbr.fsf@toke.dk> <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
 <55d185a8-31ea-51d0-d9be-debd490cd204@stressinduktion.org>
 <CAMj1kXGz7_98B_b=SJER6-Q2g-nOT5X3cfN=nfhYoH0eHep5bw@mail.gmail.com> <87ilung3uo.fsf@toke.dk>
In-Reply-To: <87ilung3uo.fsf@toke.dk>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 13 Jan 2022 14:40:55 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHg0A_jNsSpjuWizhLubhQEsFQiUfjBB6RpPZg_JsWsQQ@mail.gmail.com>
Message-ID: <CAMj1kXHg0A_jNsSpjuWizhLubhQEsFQiUfjBB6RpPZg_JsWsQQ@mail.gmail.com>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address calculation
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
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
        hideaki.yoshifuji@miraclelinux.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022 at 14:30, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> Ard Biesheuvel <ardb@kernel.org> writes:
>
> > On Thu, 13 Jan 2022 at 12:15, Hannes Frederic Sowa
> > <hannes@stressinduktion.org> wrote:
> >>
> >> Hello,
> >>
> >> On 13.01.22 00:31, Jason A. Donenfeld wrote:
> >> > On 1/13/22, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote=
:
> >> >> However, if we make this change, systems setting a stable_secret an=
d
> >> >> using addr_gen_mode 2 or 3 will come up with a completely different
> >> >> address after a kernel upgrade. Which would be bad for any operator
> >> >> expecting to be able to find their machine again after a reboot,
> >> >> especially if it is accessed remotely.
> >> >>
> >> >> I haven't ever used this feature myself, though, or seen it in use.=
 So I
> >> >> don't know if this is purely a theoretical concern, or if the
> >> >> stable_address feature is actually used in this way in practice. If=
 it
> >> >> is, I guess the switch would have to be opt-in, which kinda defeats=
 the
> >> >> purpose, no (i.e., we'd have to keep the SHA1 code around
> >>
> >> Yes, it is hard to tell if such a change would have real world impact
> >> due to not knowing its actual usage in the field - but I would avoid
> >> such a change. The reason for this standard is to have stable addresse=
s
> >> across reboots. The standard is widely used but most servers or deskto=
ps
> >> might get their stable privacy addresses being generated by user space
> >> network management systems (NetworkManager/networkd) nowadays. I would
> >> guess it could be used in embedded installations.
> >>
> >> The impact of this change could be annoying though: users could sudden=
ly
> >> lose connectivity due to e.g. changes to the default gateway after an
> >> upgrade.
> >>
> >> > I'm not even so sure that's true. That was my worry at first, but
> >> > actually, looking at this more closely, DAD means that the address c=
an
> >> > be changed anyway - a byte counter is hashed in - so there's no
> >> > gurantee there.
> >>
> >> The duplicate address detection counter is a way to merely provide bas=
ic
> >> network connectivity in case of duplicate addresses on the network
> >> (maybe some kind misconfiguration or L2 attack). Such detected address=
es
> >> would show up in the kernel log and an administrator should investigat=
e
> >> and clean up the situation. Afterwards bringing the interface down and
> >> up again should revert the interface to its initial (dad_counter =3D=
=3D 0)
> >> address.
> >>
> >> > There's also the other aspect that open coding sha1_transform like
> >> > this and prepending it with the secret (rather than a better
> >> > construction) isn't so great... Take a look at the latest version of
> >> > this in my branch to see a really nice simplification and security
> >> > improvement:
> >> >
> >> > https://git.zx2c4.com/linux-dev/log/?h=3Dremove-sha1
> >>
> >> All in all, I consider the hash produced here as being part of uAPI
> >> unfortunately and thus cannot be changed. It is unfortunate that it
> >> can't easily be improved (I assume a separate mode for this is not
> >> reasonable). The patches definitely look like a nice cleanup.
> >>
> >> Would this be the only user of sha_transform left?
> >>
> >
> > The question is not whether but when we can/will change this.
> >
> > SHA-1 is broken and should be removed at *some* point, so unless the
> > feature itself is going to be obsolete, its implementation will need
> > to switch to a PRF that fulfils the requirements in RFC7217 once SHA-1
> > ceases to do so.
> >
> > And I should also point out that the current implementation does not
> > even use SHA-1 correctly, as it omits the finalization step. This may
> > or may not matter in practice, but it deviates from crypto best
> > practices, as well as from RFC7217
>
> Right, but that implies we need to work on a transition mechanism. For
> newly deployed systems changing the hash is obviously fine, it's the
> "reboot and you have a new address" problem.
>
> We could introduce new values to the addr_gen_mode? I.e. values of 4 and
> 5 would be equivalent to 2 and 3 (respectively), but with the new
> hashing algorithm? And then document that 2 and 3 are considered
> deprecated to be removed at some point in the future...
>

I guess that for the time being, we could use assignments of
stable_secret by user space as a hint that we should switch to the old
scheme. We'd also need a knob to opt into the new scheme in that case,
and maybe print a warning otherwise? That would at least give us a
path forward where we can rip it out /some/ point in the future.
