Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC61980D1
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 18:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbfHUQ51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 12:57:27 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41980 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728810AbfHUQ51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 12:57:27 -0400
Received: by mail-io1-f68.google.com with SMTP id j5so5954204ioj.8;
        Wed, 21 Aug 2019 09:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wCEZNrYU/5ppBxRNJA9n1HgdSaVTKFRs/1eid1avNfw=;
        b=dkRgj4Mi9Zklnd9c2qIHIa13rUDGB6PqiCoGPTawJV+toT1h8vw5oLAZOLnqbH+mGN
         gvBnQ7GKEgVj9IJVyfEFoS7lSkgdfwWj5WqtAW3+7GJHalLUJManVBxHZKXyacE+Ibc6
         6b9RO56Vz06OWsRWQwBEQ0/LKbtXsgyg0BOwabgh7Kmm8shbc7rshlxWEcRIl5t88Q43
         y/hJmwUtSm4+Q+A4zYLMrj1ROhOUmrtVYhg+gvs04C4lFh2KiDsYcPheI1CxV73VwiXW
         tdk1u0aKYY8b0VUgJ8LsDpx5StGoyqFXGLcKatH0zT3feX5IJ0eOivrwVrjCFOrc8Y5F
         Re9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wCEZNrYU/5ppBxRNJA9n1HgdSaVTKFRs/1eid1avNfw=;
        b=NR/jLoFL6xfdrIytsPQwUeUu0i1R4Bi1FyITsDN1TCtT7QhBl7QYa1LRkRy8CvohsX
         /0g4Z9JYEznmHf8odT3ih2aSl6ANguSA7jgTFo+DHy/4QHdArGib24F1UkE+WasWfEN/
         FIPWekupNJ1hG2xUcYNII6ZxcpcEX/HNkNCRMBfKQLSGeli6Kb8uSsUq9IQXsEX8GCLv
         GknB0xuXy3vUXVvD5umUq8PB1kwJbadse4NDorkFW2eCLacIsNwv2ts1rGCWbaYqE1OH
         3cTJ3Qp4lcZSN5EZhwcqmHz8DKWC+Wxb000scFQZ5NGRmbIjwcciMB5r2zhxUvw5/wy/
         zMaA==
X-Gm-Message-State: APjAAAW0PHIaIta0IAItej5x3KLZixgLbGZL/EvJQpO8H9KZPZYkrSwL
        XStvxrv5CKNuWGBjnVM1Gn6ZiASCyyfSKnheeYI=
X-Google-Smtp-Source: APXvYqy5ER/jZPFQpXJhtg7vrUBIju/JR5g17iCTaerGnhqLDbkPmYKy2G/d3Owf4mg8glr1mvcKJ65SkpcrEw9ExXg=
X-Received: by 2002:a5e:8c11:: with SMTP id n17mr28082811ioj.64.1566406645836;
 Wed, 21 Aug 2019 09:57:25 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190820151644eucas1p179d6d1da42bb6be0aad8f58ac46624ce@eucas1p1.samsung.com>
 <20190820151611.10727-1-i.maximets@samsung.com> <CAKgT0Udn0D0_f=SOH2wpBRWV_u4rb1Qe2h7gguXnRNzJ_VkRzg@mail.gmail.com>
 <625791af-c656-1e42-b60e-b3a5cedcb4c4@samsung.com> <CAKgT0Uc27+ucd=a_sgTmv5g7_+ZTg1zK4isYJ0H7YWQj3d=Ejg@mail.gmail.com>
 <f7d0f7a5-e664-8b72-99c7-63275aff4c18@samsung.com>
In-Reply-To: <f7d0f7a5-e664-8b72-99c7-63275aff4c18@samsung.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 21 Aug 2019 09:57:14 -0700
Message-ID: <CAKgT0UcCKiM1Ys=vWxctprN7fzWcBCk-PCuKB-8=RThM=CqLSQ@mail.gmail.com>
Subject: Re: [PATCH net] ixgbe: fix double clean of tx descriptors with xdp
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 21, 2019 at 9:22 AM Ilya Maximets <i.maximets@samsung.com> wrot=
e:
>
> On 21.08.2019 4:17, Alexander Duyck wrote:
> > On Tue, Aug 20, 2019 at 8:58 AM Ilya Maximets <i.maximets@samsung.com> =
wrote:
> >>
> >> On 20.08.2019 18:35, Alexander Duyck wrote:
> >>> On Tue, Aug 20, 2019 at 8:18 AM Ilya Maximets <i.maximets@samsung.com=
> wrote:
> >>>>
> >>>> Tx code doesn't clear the descriptor status after cleaning.
> >>>> So, if the budget is larger than number of used elems in a ring, som=
e
> >>>> descriptors will be accounted twice and xsk_umem_complete_tx will mo=
ve
> >>>> prod_tail far beyond the prod_head breaking the comletion queue ring=
.
> >>>>
> >>>> Fix that by limiting the number of descriptors to clean by the numbe=
r
> >>>> of used descriptors in the tx ring.
> >>>>
> >>>> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
> >>>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> >>>
> >>> I'm not sure this is the best way to go. My preference would be to
> >>> have something in the ring that would prevent us from racing which I
> >>> don't think this really addresses. I am pretty sure this code is safe
> >>> on x86 but I would be worried about weak ordered systems such as
> >>> PowerPC.
> >>>
> >>> It might make sense to look at adding the eop_desc logic like we have
> >>> in the regular path with a proper barrier before we write it and afte=
r
> >>> we read it. So for example we could hold of on writing the bytecount
> >>> value until the end of an iteration and call smp_wmb before we write
> >>> it. Then on the cleanup we could read it and if it is non-zero we tak=
e
> >>> an smp_rmb before proceeding further to process the Tx descriptor and
> >>> clearing the value. Otherwise this code is going to just keep popping
> >>> up with issues.
> >>
> >> But, unlike regular case, xdp zero-copy xmit and clean for particular
> >> tx ring always happens in the same NAPI context and even on the same
> >> CPU core.
> >>
> >> I saw the 'eop_desc' manipulations in regular case and yes, we could
> >> use 'next_to_watch' field just as a flag of descriptor existence,
> >> but it seems unnecessarily complicated. Am I missing something?
> >>
> >
> > So is it always in the same NAPI context?. I forgot, I was thinking
> > that somehow the socket could possibly make use of XDP for transmit.
>
> AF_XDP socket only triggers tx interrupt on ndo_xsk_async_xmit() which
> is used in zero-copy mode. Real xmit happens inside
> ixgbe_poll()
>  -> ixgbe_clean_xdp_tx_irq()
>     -> ixgbe_xmit_zc()
>
> This should be not possible to bound another XDP socket to the same netde=
v
> queue.
>
> It also possible to xmit frames in xdp_ring while performing XDP_TX/REDIR=
ECT
> actions. REDIRECT could happen from different netdev with different NAPI
> context, but this operation is bound to specific CPU core and each core h=
as
> its own xdp_ring.
>
> However, I'm not an expert here.
> Bj=C3=B6rn, maybe you could comment on this?
>
> >
> > As far as the logic to use I would be good with just using a value you
> > are already setting such as the bytecount value. All that would need
> > to happen is to guarantee that the value is cleared in the Tx path. So
> > if you clear the bytecount in ixgbe_clean_xdp_tx_irq you could
> > theoretically just use that as well to flag that a descriptor has been
> > populated and is ready to be cleaned. Assuming the logic about this
> > all being in the same NAPI context anyway you wouldn't need to mess
> > with the barrier stuff I mentioned before.
>
> Checking the number of used descs, i.e. next_to_use - next_to_clean,
> makes iteration in this function logically equal to the iteration inside
> 'ixgbe_xsk_clean_tx_ring()'. Do you think we need to change the later
> function too to follow same 'bytecount' approach? I don't like having
> two different ways to determine number of used descriptors in the same fi=
le.
>
> Best regards, Ilya Maximets.

As far as ixgbe_clean_xdp_tx_irq() vs ixgbe_xsk_clean_tx_ring(), I
would say that if you got rid of budget and framed things more like
how ixgbe_xsk_clean_tx_ring was framed with the ntc !=3D ntu being
obvious I would prefer to see us go that route.

Really there is no need for budget in ixgbe_clean_xdp_tx_irq() if you
are going to be working with a static ntu value since you will only
ever process one iteration through the ring anyway. It might make more
sense if you just went through and got rid of budget and i, and
instead used ntc and ntu like what was done in
ixgbe_xsk_clean_tx_ring().

Thanks.

- Alex
