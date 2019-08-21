Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDEE296EBE
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 03:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfHUBRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 21:17:13 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:41486 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfHUBRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 21:17:12 -0400
Received: by mail-io1-f67.google.com with SMTP id j5so1246592ioj.8;
        Tue, 20 Aug 2019 18:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kZWHrTprV1/7KUdKW3G6OHYWGjOaGD0IoU996R//irc=;
        b=PW/FNmKOjoHqHBgeKuzcejPrWtquvNRR8hFw19cBinEnE7gl0RdKyYw2XhZFsMK5l8
         jSWcbl+meQnv7sxj8jqKKU3UIX3V+6MXUy8oV7zb9opsXDeeAi4xDzQRHCGUp6E7iFrN
         8bWY7qXYx+av2KfejCyBNsCYm3VxnL7YaA6eajUZ3RFxY6mAR/YLmt003MKqW0/tIbX1
         qcLZKcc7MA7q9HnC9CmAv6ZQxtd3J9rVvcvNdIWPW4hm+wlvNikXZqVM4e7cOCiD4/vZ
         DnA2tCTB5rUV7i43BoOjjvGGEWYorK7nKtvSlDicQz7tL3nrLpg8pa1gaUgFwVF2TwCF
         nYdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kZWHrTprV1/7KUdKW3G6OHYWGjOaGD0IoU996R//irc=;
        b=P674LPmtp7bPIRbsWYBdCYFk6ZrCdQaHT9C9WYbqfixnUBC5T74jrTsqZGJjZgIj0j
         Ymi8bHtKkMBC/V8at5KpEVyGmURLN/PUZLd2gpFOwua+hxKRUiKhX0f5mQX3fsLCqzc2
         YQnBnSylcPlkfmhzPLz/5cE4d/kTdt1KHOtFzqeWRaZWHgHQYaX/V6rirZbwNZRhzxsj
         7vnuYjzyJy1AlvdSWo5mqoSxvuGcvrHtsM+kxorfnPvjw6ErIgON8ti0DUQhbzcFffIe
         L1XIhct+dRewCc1+V0c0TPUWFzIudBu5YFwn7MEnmnkXfrDtWwDXQCvuwviDU2K0p3KI
         mKkw==
X-Gm-Message-State: APjAAAWs5CGHkozDZUE0HxvOoibumzZl7prYiM8mE5gdxT+pL9gm0D+8
        OCs2exrBS+eOZgT1IDdQPFedDTGW4wGf9kPN7nA=
X-Google-Smtp-Source: APXvYqwKPD7A/87E2z38qYXby7iIyyIj1fffBmYKZ1eCq5AuMAqrR+2V+Rth31D1/5dIoKoaLHfgabFG9o2gT1w9NOY=
X-Received: by 2002:a5d:8b47:: with SMTP id c7mr24228155iot.42.1566350231784;
 Tue, 20 Aug 2019 18:17:11 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20190820151644eucas1p179d6d1da42bb6be0aad8f58ac46624ce@eucas1p1.samsung.com>
 <20190820151611.10727-1-i.maximets@samsung.com> <CAKgT0Udn0D0_f=SOH2wpBRWV_u4rb1Qe2h7gguXnRNzJ_VkRzg@mail.gmail.com>
 <625791af-c656-1e42-b60e-b3a5cedcb4c4@samsung.com>
In-Reply-To: <625791af-c656-1e42-b60e-b3a5cedcb4c4@samsung.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 20 Aug 2019 18:17:00 -0700
Message-ID: <CAKgT0Uc27+ucd=a_sgTmv5g7_+ZTg1zK4isYJ0H7YWQj3d=Ejg@mail.gmail.com>
Subject: Re: [PATCH net] ixgbe: fix double clean of tx descriptors with xdp
To:     Ilya Maximets <i.maximets@samsung.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 8:58 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>
> On 20.08.2019 18:35, Alexander Duyck wrote:
> > On Tue, Aug 20, 2019 at 8:18 AM Ilya Maximets <i.maximets@samsung.com> wrote:
> >>
> >> Tx code doesn't clear the descriptor status after cleaning.
> >> So, if the budget is larger than number of used elems in a ring, some
> >> descriptors will be accounted twice and xsk_umem_complete_tx will move
> >> prod_tail far beyond the prod_head breaking the comletion queue ring.
> >>
> >> Fix that by limiting the number of descriptors to clean by the number
> >> of used descriptors in the tx ring.
> >>
> >> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
> >> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> >
> > I'm not sure this is the best way to go. My preference would be to
> > have something in the ring that would prevent us from racing which I
> > don't think this really addresses. I am pretty sure this code is safe
> > on x86 but I would be worried about weak ordered systems such as
> > PowerPC.
> >
> > It might make sense to look at adding the eop_desc logic like we have
> > in the regular path with a proper barrier before we write it and after
> > we read it. So for example we could hold of on writing the bytecount
> > value until the end of an iteration and call smp_wmb before we write
> > it. Then on the cleanup we could read it and if it is non-zero we take
> > an smp_rmb before proceeding further to process the Tx descriptor and
> > clearing the value. Otherwise this code is going to just keep popping
> > up with issues.
>
> But, unlike regular case, xdp zero-copy xmit and clean for particular
> tx ring always happens in the same NAPI context and even on the same
> CPU core.
>
> I saw the 'eop_desc' manipulations in regular case and yes, we could
> use 'next_to_watch' field just as a flag of descriptor existence,
> but it seems unnecessarily complicated. Am I missing something?
>

So is it always in the same NAPI context?. I forgot, I was thinking
that somehow the socket could possibly make use of XDP for transmit.

As far as the logic to use I would be good with just using a value you
are already setting such as the bytecount value. All that would need
to happen is to guarantee that the value is cleared in the Tx path. So
if you clear the bytecount in ixgbe_clean_xdp_tx_irq you could
theoretically just use that as well to flag that a descriptor has been
populated and is ready to be cleaned. Assuming the logic about this
all being in the same NAPI context anyway you wouldn't need to mess
with the barrier stuff I mentioned before.

- Alex
