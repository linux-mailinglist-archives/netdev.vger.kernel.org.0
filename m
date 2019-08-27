Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 063BA9DD21
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 07:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbfH0FXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 01:23:25 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38805 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfH0FXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 01:23:21 -0400
Received: by mail-qk1-f196.google.com with SMTP id u190so16079613qkh.5
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 22:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sC2NjC8+A0TKELBjbIVVNtKDnT9aRehN1CXf+Kpbi1M=;
        b=X4NiWjJimWS+yY7P9ODH4dTSXcADuJFv2Dzvp7EpZLt1KWavXUOtnEMzZafunw9qIk
         5di4G0Sx5gZ6kgyKqos7Sfws36gBgXsVJTWxo/5TNgAYLJf3p8N3i1oBKl0m89QGBnEN
         RVpYGnp3cQwzaxHxYiJjQhTCbcVR1ACjqiB1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sC2NjC8+A0TKELBjbIVVNtKDnT9aRehN1CXf+Kpbi1M=;
        b=c7pvhv3cgwv1qIeCeMXWM+MO82VYMYRYSOEFlKHmwCtZ01yy5qoh41tQLhnsxKQXDt
         enwxCPdhiYTWcYsEoCgjFV0jg508y9n1K0y8fJLEQsev/f4xh/foGA88mHETmdXQHBFH
         sQzUuIAN2l087fgQFLKy3x9KoUj6PT5wnd9e1/j/MQCR6eA+e3XOluxFdJjNrWM23Krt
         XpyIIBgqT4NZF8qyXcJnGmGF3kAguNmuJaq+hACJH8Z5fiet79AxJlvCNd66sBzQqEkG
         HmnKF+2St96ppn94xWx3hfEtt6w2uC4p3tdnrklFqBw2rlt3kQL8buM2JZgMHo4l6MWv
         fJOw==
X-Gm-Message-State: APjAAAUCIBPT1wwvqwFFN5fvDzeegHjCjUqWsc1zHaBogc5/YqIEAe/F
        dmq9Xt7Q0KOJZYp2N/wWM+brDp6ZGFu1w/2CE5RBKA==
X-Google-Smtp-Source: APXvYqwF7HM8zQgP6LqbFjZvM0l7BwT2ajiN3bPb5DfDxjuUJzojQGxg6ldKtJzgynvs1cI1K+pN2ixAS5TPReXhdz8=
X-Received: by 2002:ae9:f301:: with SMTP id p1mr20356780qkg.353.1566883399611;
 Mon, 26 Aug 2019 22:23:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190827003326.147452-1-drinkcat@chromium.org> <36878f3488f047978038c844daedd02f@aptaiexm02f.ap.qualcomm.com>
In-Reply-To: <36878f3488f047978038c844daedd02f@aptaiexm02f.ap.qualcomm.com>
From:   Nicolas Boichat <drinkcat@chromium.org>
Date:   Tue, 27 Aug 2019 13:23:08 +0800
Message-ID: <CANMq1KDTBJOnQZQihH91FDj+jOZcODV-xYEx5umukV7+UEPR1g@mail.gmail.com>
Subject: Re: [PATCH, RFC] ath10k: Fix skb->len (properly) in ath10k_sdio_mbox_rx_packet
To:     Wen Gong <wgong@qti.qualcomm.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Alagu Sankar <alagusankar@silex-india.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "wgong@codeaurora.org" <wgong@codeaurora.org>,
        "niklas.cassel@linaro.org" <niklas.cassel@linaro.org>,
        "tientzu@chromium.org" <tientzu@chromium.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 11:34 AM Wen Gong <wgong@qti.qualcomm.com> wrote:
>
> > -----Original Message-----
> > From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Nicolas
> > Boichat
> > Sent: Tuesday, August 27, 2019 8:33 AM
> > To: kvalo@codeaurora.org
> > Cc: Alagu Sankar <alagusankar@silex-india.com>; netdev@vger.kernel.org;
> > briannorris@chromium.org; linux-wireless@vger.kernel.org; linux-
> > kernel@vger.kernel.org; ath10k@lists.infradead.org;
> > wgong@codeaurora.org; niklas.cassel@linaro.org; tientzu@chromium.org;
> > David S . Miller <davem@davemloft.net>
> > Subject: [EXT] [PATCH, RFC] ath10k: Fix skb->len (properly) in
> > ath10k_sdio_mbox_rx_packet
> >
> > (not a formal patch, take this as a bug report for now, I can clean
> > up depending on the feedback I get here)
> >
> > There's at least 3 issues here, and the patch fixes 2/3 only, I'm not sure
> > how/if 1 should be handled.
> >  1. ath10k_sdio_mbox_rx_alloc allocating skb of a incorrect size (too
> >     small)
> >  2. ath10k_sdio_mbox_rx_packet calling skb_put with that incorrect size.
> >  3. ath10k_sdio_mbox_rx_process_packet attempts to fixup the size, but
> >     does not use proper skb_put commands to do so, so we end up with
> >     a mismatch between skb->head + skb->tail and skb->data + skb->len.
> >
> > Let's start with 3, this is quite serious as this and causes corruptions
> > in the TCP stack, as the stack tries to coalesce packets, and relies on
> > skb->tail being correct (that is, skb_tail_pointer must point to the
> > first byte _after_ the data): one must never manipulate skb->len
> > directly.
> >
> > Instead, we need to use skb_put to allocate more space (which updates
> > skb->len and skb->tail). But it seems odd to do that in
> > ath10k_sdio_mbox_rx_process_packet, so I move the code to
> > ath10k_sdio_mbox_rx_packet (point 2 above).
> >
> > However, there is still something strange (point 1 above), why is
> > ath10k_sdio_mbox_rx_alloc allocating packets of the incorrect
> > (too small?) size? What happens if the packet is bigger than alloc_len?
> > Does this lead to corruption/lost data?
> >
> > Fixes: 8530b4e7b22bc3b ("ath10k: sdio: set skb len for all rx packets")
> > Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>
> >
> > ---
> >
> > One simple way to test this is this scriplet, that sends a lot of
> > small packets over SSH:
> > (for i in `seq 1 300`; do echo $i; sleep 0.1; done) | ssh $IP cat
> >
> > In my testing it rarely ever reach 300 without failure.
> >
> >  drivers/net/wireless/ath/ath10k/sdio.c | 18 ++++++++++++------
> >  1 file changed, 12 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/sdio.c
> > b/drivers/net/wireless/ath/ath10k/sdio.c
> > index 8ed4fbd8d6c3888..a9f5002863ee7bb 100644
> > --- a/drivers/net/wireless/ath/ath10k/sdio.c
> > +++ b/drivers/net/wireless/ath/ath10k/sdio.c
> > @@ -381,16 +381,14 @@ static int
> > ath10k_sdio_mbox_rx_process_packet(struct ath10k *ar,
> >       struct ath10k_htc_hdr *htc_hdr = (struct ath10k_htc_hdr *)skb->data;
> >       bool trailer_present = htc_hdr->flags &
> > ATH10K_HTC_FLAG_TRAILER_PRESENT;
> >       enum ath10k_htc_ep_id eid;
> > -     u16 payload_len;
> >       u8 *trailer;
> >       int ret;
> >
> > -     payload_len = le16_to_cpu(htc_hdr->len);
> > -     skb->len = payload_len + sizeof(struct ath10k_htc_hdr);
> > +     /* TODO: Remove this? */
> If the pkt->act_len has set again in ath10k_sdio_mbox_rx_packet, seems not needed.

Sure, will drop.

> > +     WARN_ON(skb->len != le16_to_cpu(htc_hdr->len) + sizeof(*htc_hdr));
> >
> >       if (trailer_present) {
> > -             trailer = skb->data + sizeof(*htc_hdr) +
> > -                       payload_len - htc_hdr->trailer_len;
> > +             trailer = skb->data + skb->len - htc_hdr->trailer_len;
> >
> >               eid = pipe_id_to_eid(htc_hdr->eid);
> >
> > @@ -637,8 +635,16 @@ static int ath10k_sdio_mbox_rx_packet(struct
> > ath10k *ar,
> >       ret = ath10k_sdio_readsb(ar, ar_sdio->mbox_info.htc_addr,
> >                                skb->data, pkt->alloc_len);
> >       pkt->status = ret;
> > -     if (!ret)
> > +     if (!ret) {
> > +             /* Update actual length. */
> > +             /* FIXME: This looks quite wrong, why is pkt->act_len not
> > +              * correct in the first place?
> > +              */
> Firmware will do bundle for rx packet, and the aligned length by block size(256) of each packet's len is same
> in a bundle.
>
> Eg.
> packet 1 len: 300, aligned length:512
> packet 2 len: 400, aligned length:512
> packet 3 len: 200, aligned length:256
> packet 4 len: 100, aligned length:256
> packet 5 len: 700, aligned length:768
> packet 6 len: 600, aligned length:768
>
> then packet 1,2 will in bundle 1, packet 3,4 in a bundle 2, packet 5,6 in a bundle 3.
>
> For bundle 1, packet 1,2 will both allocate with len 512, and act_len is 300 first,
> then packet 2's len will be overwrite to 400.
>
> For bundle 2, packet 3,4 will both allocate with len 256, and act_len is 200 first,
> then packet 4's len will be overwrite to 100.
>
> For bundle 3, packet 5,6 will both allocate with len 768, and act_len is 700 first,
> then packet 6's len will be overwrite to 600.

Ok thanks, I'll send a v2 with an improved description.

> > +             struct ath10k_htc_hdr *htc_hdr =
> > +                     (struct ath10k_htc_hdr *)skb->data;
> > +             pkt->act_len = le16_to_cpu(htc_hdr->len) + sizeof(*htc_hdr);
> >               skb_put(skb, pkt->act_len);
> > +     }
> >
> >       return ret;
> >  }
> > --
> > 2.23.0.187.g17f5b7556c-goog
> >
> >
> > _______________________________________________
> > ath10k mailing list
> > ath10k@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/ath10k
