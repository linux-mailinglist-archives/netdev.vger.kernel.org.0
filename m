Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248A8413D63
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbhIUWP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:15:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235209AbhIUWPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 18:15:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632262449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zexsU+MZj4Zo5PMns9FOoUI+A274gOTlKpGMASTVn3w=;
        b=Vye2t37mH/39erz+TSZfD1lHIB/cyZWpHeL9VwIAJy19HLlqdAshpeqRvpCo+skojr2tSV
        SJnOu9aove2NSwVURWKJBSItkG/y1KAsdS6rZP45zeGaZXc6RHn14mOA5D8c82SouLQ0G0
        AuxYLWuzSVl0pjFc5pFXNO/JPLabdtc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-KtlMT_xpPwKnainC526BKw-1; Tue, 21 Sep 2021 18:14:08 -0400
X-MC-Unique: KtlMT_xpPwKnainC526BKw-1
Received: by mail-ed1-f72.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so589712ede.16
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 15:14:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=zexsU+MZj4Zo5PMns9FOoUI+A274gOTlKpGMASTVn3w=;
        b=lAUhXiNscC9YfgZvAfNey8mSmNZR7W9hyXL/oyB/gnwV2IlslyN4CK6NbFQDaDZvjd
         ISFbGFAYNFpd57ERplC0BPA+rGPp/LYkQWV98tdJPZ8ZK/SsEdpulyvG2Z5L51/5indl
         B+Kr+6lWDxYgv99ARfbii6IqlOkVvspzzFPHUexJS/nzF+rcYDJiatig7K/XnE2iY7jO
         o+uzAEaG41AHV+D23bEPN5Pf8uEzXydP4xvGvAfyiOVHM63wUY9N2vq8bNEvU9Q9u6gy
         7ExEOtk+vSvw+/27lKpzGktmEXxAUJap/FwZBnaJYNMI2tnboI/xSMDp6vLAs71kM+XX
         HsXA==
X-Gm-Message-State: AOAM5302zx/zEZ88OrupXMZq34i5D3p1c+s8hJFFOVr//MAAxen+OOJM
        sugE/MutBsX4v4FC/XEt1t3pVxLfmqasmxTzZP+ab+YONeEl4bD+sfZeUfDG4Tq2zAoAjqDMe2H
        rKGGbvepxmM2Pk94t
X-Received: by 2002:a17:906:dc0d:: with SMTP id yy13mr9655060ejb.88.1632262446714;
        Tue, 21 Sep 2021 15:14:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwIuouLakkJQO98LMJoHFcq1lT4+2CgW/YpmU2ABsEsTx8Is5IsAXpnd4fRlv8UcB4KnWwK6w==
X-Received: by 2002:a17:906:dc0d:: with SMTP id yy13mr9655018ejb.88.1632262446276;
        Tue, 21 Sep 2021 15:14:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id lb20sm86361ejc.40.2021.09.21.15.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 15:14:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C1CCF18034A; Wed, 22 Sep 2021 00:14:04 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Zvi Effron <zeffron@riotgames.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf <bpf@vger.kernel.org>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
In-Reply-To: <CAC1LvL3yQd_T5srJb78rGxv8YD-QND2aRgJ-p5vOQkbvrwJWSw@mail.gmail.com>
References: <87o88l3oc4.fsf@toke.dk>
 <CAC1LvL1xgFMjjE+3wHH79_9rumwjNqDAS2Yg2NpSvmewHsYScA@mail.gmail.com>
 <87ilyt3i0y.fsf@toke.dk>
 <CAC1LvL3yQd_T5srJb78rGxv8YD-QND2aRgJ-p5vOQkbvrwJWSw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 22 Sep 2021 00:14:04 +0200
Message-ID: <87fstx37bn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zvi Effron <zeffron@riotgames.com> writes:

> On Tue, Sep 21, 2021 at 11:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>>
>> Zvi Effron <zeffron@riotgames.com> writes:
>>
>> > On Tue, Sep 21, 2021 at 9:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> Hi Lorenz (Cc. the other people who participated in today's discussio=
n)
>> >>
>> >> Following our discussion at the LPC session today, I dug up my previo=
us
>> >> summary of the issue and some possible solutions[0]. Seems no on
>> >> actually replied last time, which is why we went with the "do nothing"
>> >> approach, I suppose. I'm including the full text of the original email
>> >> below; please take a look, and let's see if we can converge on a
>> >> consensus here.
>> >>
>> >> First off, a problem description: If an existing XDP program is expos=
ed
>> >> to an xdp_buff that is really a multi-buffer, while it will continue =
to
>> >> run, it may end up with subtle and hard-to-debug bugs: If it's parsing
>> >> the packet it'll only see part of the payload and not be aware of that
>> >> fact, and if it's calculating the packet length, that will also only =
be
>> >> wrong (only counting the first fragment).
>> >>
>> >> So what to do about this? First of all, to do anything about it, XDP
>> >> programs need to be able to declare themselves "multi-buffer aware" (=
but
>> >> see point 1 below). We could try to auto-detect it in the verifier by
>> >> which helpers the program is using, but since existing programs could=
 be
>> >> perfectly happy to just keep running, it probably needs to be somethi=
ng
>> >> the program communicates explicitly. One option is to use the
>> >> expected_attach_type to encode this; programs can then declare it in =
the
>> >> source by section name, or the userspace loader can set the type for
>> >> existing programs if needed.
>> >>
>> >> With this, the kernel will know if a given XDP program is multi-buff
>> >> aware and can decide what to do with that information. For this we ca=
me
>> >> up with basically three options:
>> >>
>> >> 1. Do nothing. This would make it up to users / sysadmins to avoid
>> >>    anything breaking by manually making sure to not enable multi-buff=
er
>> >>    support while loading any XDP programs that will malfunction if
>> >>    presented with an mb frame. This will probably break in interesting
>> >>    ways, but it's nice and simple from an implementation PoV. With th=
is
>> >>    we don't need the declaration discussed above either.
>> >>
>> >> 2. Add a check at runtime and drop the frames if they are mb-enabled =
and
>> >>    the program doesn't understand it. This is relatively simple to
>> >>    implement, but it also makes for difficult-to-understand issues (w=
hy
>> >>    are my packets suddenly being dropped?), and it will incur runtime
>> >>    overhead.
>> >>
>> >> 3. Reject loading of programs that are not MB-aware when running in an
>> >>    MB-enabled mode. This would make things break in more obvious ways,
>> >>    and still allow a userspace loader to declare a program "MB-aware"=
 to
>> >>    force it to run if necessary. The problem then becomes at what lev=
el
>> >>    to block this?
>> >>
>> >
>> > I think there's another potential problem with this as well: what happ=
ens to
>> > already loaded programs that are not MB-aware? Are they forcibly unloa=
ded?
>>
>> I'd say probably the opposite: You can't toggle whatever switch we end
>> up with if there are any non-MB-aware programs (you'd have to unload
>> them first)...
>>
>
> How would we communicate that issue? dmesg? I'm not very familiar with
> how sysctl change failure causes are communicated to users, so this
> might be a solved problem, but if I run `sysctl -w net.xdp.multibuffer
> 1` (or whatever ends up actually being the toggle) to active
> multi-buffer, and it fails because there's a loaded non-aware program,
> that seems like a potential for a lot of administrator pain.

Hmm, good question. Document that this only fails if there's a
non-mb-aware XDP program loaded? Or use some other mechanism with better
feedback?

>> >>    Doing this at the driver level is not enough: while a particular
>> >>    driver knows if it's running in multi-buff mode, we can't know for
>> >>    sure if a particular XDP program is multi-buff aware at attach tim=
e:
>> >>    it could be tail-calling other programs, or redirecting packets to
>> >>    another interface where it will be processed by a non-MB aware
>> >>    program.
>> >>
>> >>    So another option is to make it a global toggle: e.g., create a new
>> >>    sysctl to enable multi-buffer. If this is set, reject loading any =
XDP
>> >>    program that doesn't support multi-buffer mode, and if it's unset,
>> >>    disable multi-buffer mode in all drivers. This will make it explic=
it
>> >>    when the multi-buffer mode is used, and prevent any accidental sub=
tle
>> >>    malfunction of existing XDP programs. The drawback is that it's a
>> >>    mode switch, so more configuration complexity.
>> >>
>> >
>> > Could we combine the last two bits here into a global toggle that does=
n't
>> > require a sysctl? If any driver is put into multi-buffer mode, then th=
e system
>> > switches to requiring all programs be multi-buffer? When the last mult=
i-buffer
>> > enabled driver switches out of multi-buffer, remove the system-wide
>> > restriction?
>>
>> Well, the trouble here is that we don't necessarily have an explicit
>> "multi-buf mode" for devices. For instance, you could raise the MTU of a
>> device without it necessarily involving any XDP multi-buffer stuff (if
>> you're not running XDP on that device). So if we did turn "raising the
>> MTU" into such a mode switch, we would end up blocking any MTU changes
>> if any XDP programs are loaded. Or having an MTU change cause a
>> force-unload of all XDP programs.
>
> Maybe I missed something then, but you had stated that "while a
> particular driver knows if it's running in multi-buff mode" so I
> assumed that the driver would be able to tell when to toggle the mode
> on.

Well, a driver knows when it is attaching an XDP program whether it (the
driver) is configured in a way such that this XDP program could
encounter a multi-buf.

> I had been thinking that when a driver turned multi-buffer off, it
> could trigger a check of all drivers, but that also seems like it
> could just be a global refcount of all the drivers that have requested
> multi-buffer mode. When a driver enables multi-buffer for itself, it
> increments the refcount, and when it disables, it decrements. A
> non-zero count means the system is in multi-buffer mode.

I guess we could do a refcount-type thing when an multi-buf XDP program
is first attached (as per above). But I think it may be easier to just
do it at load-time, then, so it doesn't have to be in the driver, but
the BPF core could just enforce it.

This would basically amount to a rule saying "you can't mix mb-aware and
non-mb-aware programs", and the first type to be loaded determines which
mode the system is in. This would be fairly simple to implement and
enforce, I suppose. The drawback is that it's potentially racy in the
order programs are loaded...

-Toke

