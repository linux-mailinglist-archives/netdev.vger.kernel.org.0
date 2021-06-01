Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8129396DDF
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 09:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhFAHXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 03:23:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231928AbhFAHXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 03:23:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 533CB61396
        for <netdev@vger.kernel.org>; Tue,  1 Jun 2021 07:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622532115;
        bh=tlEwOIYfyR+OavcAkBRzWA6HZ6XD6VhyOTfadbFLfIA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SVjhmMnEbLbevBFCQgyX3n8kAzUtn21hYsK5pJrqb9hh/Q/8x09bGAU0RFK/bz9v9
         7ZJEKjQnXXclmFPHqmt3g1venXcMbUxQEn5nKQJnZWAPNjUldg7zdN06sBCBX9UGVy
         qRKUH8ohZJwIvMM5moFk0XV2oqeM4fc5LqyRIwv4fAjhuKt0A+H2b7N8xG/22oTYkt
         DOw/MUtny8TQIsFWtovubERzMuvo46Nfx0FueuMFSk2jBM8d48KrqBMKOZeimS826S
         s0KrsFnbkTMbkaUojXTdDEgPN/8hF30YwaT8c+ak4fINiS88UJWaZkfsrpinErARvP
         L9iLR1HrxDnAw==
Received: by mail-wm1-f44.google.com with SMTP id o2-20020a05600c4fc2b029019a0a8f959dso1255470wmq.1
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 00:21:55 -0700 (PDT)
X-Gm-Message-State: AOAM532HUCZ06tSGHoQMDsEdaEJ6za3PNZdeTaPwJancM9ENLOd4qMGL
        oyOL9mgQvOmvlSrbr0RCI4y4HP4sum4TM/+vbiI=
X-Google-Smtp-Source: ABdhPJx73lIkjqqg5TsZIx7QM1gRtv+Nl8GErDobbRJkoOFdcGezOr4SMpnbZDocNxC90c0Vxzlrnqh5n41FMK14tPE=
X-Received: by 2002:a1c:c90f:: with SMTP id f15mr3133540wmb.142.1622532113910;
 Tue, 01 Jun 2021 00:21:53 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
 <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
In-Reply-To: <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 1 Jun 2021 09:20:17 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
Message-ID: <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Nikolai Zhubr <zhubr.2@gmail.com>, netdev <netdev@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 1, 2021 at 12:31 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> On 01.06.2021 00:18, Nikolai Zhubr wrote:
> > But meanwhile, I tried a dumb thing instead, and it worked!
> > I've put back The Loop:
> > ---------------------------
> > +       int boguscnt = 20;
> >
> >         spin_lock (&tp->lock);
> > +       do {
> >         status = RTL_R16 (IntrStatus);
> >
> >         /* shared irq? */
> > @@ -2181,6 +2183,8 @@
> >                 if (status & TxErr)
> >                         RTL_W16 (IntrStatus, TxErr);
> >         }
> > +       boguscnt--;
> > +       } while (boguscnt > 0);
> >   out:
> > ---------------------------
> > With this added, connection works fine again. Of course it is silly, but hopefully it gives a path for a real fix.
> >
>
> What was discussed here 16 yrs ago should sound familiar to you.
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg92234.html
> "It was an option in my BIOS PCI level/edge settings as I posted."
> You could check whether you have same/similar option in your BIOS
> and play with it.

So it appears that the interrupt is lost if new TX events come in after the
status register is read, and that checking it again manages to make that
race harder to hit, but maybe not reliably.

The best idea I have for a proper fix would be to move the TX processing
into the poll function as well, making sure that by the end of that function
the driver is either still in napi polling mode, or both RX and TX interrupts
are enabled and acked.

         Arnd
