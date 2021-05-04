Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAF337243B
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 03:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhEDBX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 21:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhEDBX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 21:23:28 -0400
Received: from warlock.wand.net.nz (warlock.cms.waikato.ac.nz [IPv6:2001:df0:4:4000::250:15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579DDC061574
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 18:22:34 -0700 (PDT)
Received: from [209.85.210.170] (helo=mail-pf1-f170.google.com)
        by warlock.wand.net.nz with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.80)
        (envelope-from <rsanger@wand.net.nz>)
        id 1ldjlg-00004v-Go
        for netdev@vger.kernel.org; Tue, 04 May 2021 13:22:32 +1200
Received: by mail-pf1-f170.google.com with SMTP id q2so5768257pfh.13
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 18:22:29 -0700 (PDT)
X-Gm-Message-State: AOAM5313vpRQoPy0eSMN3KTjrac2CinbkV0jYi4E0Te+6whtFL3bifsx
        4YgXvzhToBvItkDSyMAvu05NrvsASaX4gvW8GUc=
X-Google-Smtp-Source: ABdhPJxEGHxCZxvdhQ2LIAv7CUfLVIFNW6e2PsNqOonAtrAAkvS9JNe4SDhSogKTU7p2fvZUL/A5HFLMJZ9WkVpReYI=
X-Received: by 2002:a65:41c6:: with SMTP id b6mr4469144pgq.135.1620091348813;
 Mon, 03 May 2021 18:22:28 -0700 (PDT)
MIME-Version: 1.0
References: <1620085579-5646-1-git-send-email-rsanger@wand.net.nz> <CA+FuTSeDTYMZzT3n3tfm9KPCRx_ObWU-HaU4JxZCSCm_8sf2XA@mail.gmail.com>
In-Reply-To: <CA+FuTSeDTYMZzT3n3tfm9KPCRx_ObWU-HaU4JxZCSCm_8sf2XA@mail.gmail.com>
From:   Richard Sanger <rsanger@wand.net.nz>
Date:   Tue, 4 May 2021 13:22:17 +1200
X-Gmail-Original-Message-ID: <CAN6QFNzj9+Y3W2eYTpHzVVjy_sYN+9d_Sa99HgQ0KgKyNmpeNw@mail.gmail.com>
Message-ID: <CAN6QFNzj9+Y3W2eYTpHzVVjy_sYN+9d_Sa99HgQ0KgKyNmpeNw@mail.gmail.com>
Subject: Re: [PATCH] net: packetmmap: fix only tx timestamp on request
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Received-SPF: softfail client-ip=209.85.210.170; envelope-from=rsanger@wand.net.nz; helo=mail-pf1-f170.google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

This is to match up with the documented behaviour; see the timestamping section
at the bottom of
https://www.kernel.org/doc/html/latest/networking/packet_mmap.html

If no call to setsockopt(fd, SOL_PACKET, PACKET_TIMESTAMP, ...) is made then
the tx path ring should not return timestamps, or timestamp flags set in
tp_status.

As noted in b9c32fb27170
("packet: if hw/sw ts enabled in rx/tx ring, report which ts we got")
this is to retain backwards compatibility with old code.

However, currently, a timestamp can be returned without setting
PACKET_TIMESTAMP, in the case that skb->tstamp includes a timestamp.
I only noticed this recently due to:
aa4e689ed1 (veth: add software timestamping)
which means skb->tstamp now includes a timestamp.

The issue this bug causes for old/non-timestamp aware code is that tp_status
may incorrectly have the TP_STATUS_TS_SOFTWARE flag set, so the documented
check (tp_status == TP_STATUS_AVAILABLE) that a frame in the ring is free fails.
Causing such code to hang infinitely.

This patch corrects the behaviour for the tx path. But, doesn't change the
behaviour on the rx path. The rx path still includes a timestamp (hence
the patch always sets the SOF_TIMESTAMPING_SOFTWARE flag on rx).

Thanks,
Richard


On Tue, May 4, 2021 at 12:36 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, May 3, 2021 at 8:04 PM Richard Sanger <rsanger@wand.net.nz> wrote:
> >
> > The packetmmap tx ring should only return timestamps if requested,
> > as documented. This allows compatibility with non-timestamp aware
> > user-space code which checks tp_status == TP_STATUS_AVAILABLE;
> > not expecting additional timestamp flags to be set.
>
> This is an established interface.
>
> Passing the status goes back to 2013, since commit b9c32fb27170
> ("packet: if hw/sw ts enabled in rx/tx ring, report which ts we got").
>
> Passing a timestamp itself in tp_sec/tp_usec goes back to before git,
> probably to the introduction of the ring.
>
> I don't think we can change this now. That will likely break
> applications that have come to expect current behavior.
>
> Is it documented somewhere that the ring works differently? Or are you
> referring to the general SO_TIMESTAMPING behavior, which is a separate
> timestamp interface.
