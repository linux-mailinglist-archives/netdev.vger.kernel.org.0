Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 395B0309073
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhA2XJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 18:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhA2XJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 18:09:30 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82189C061573;
        Fri, 29 Jan 2021 15:08:49 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id g3so15273077ejb.6;
        Fri, 29 Jan 2021 15:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IeBu9dlbnETh/snav+HDoMJthQ1+kr8O/vbgPiiEFL0=;
        b=Wyv8T26bqt/kmb8iKqaN8ZuX8hZXmzVqUQ8C2V8SPJgnSPeGf5WF8QVEGoH8B2eu4X
         eebRxFWASpXjVhHGMFET7hUxAd6iaocufFEPDbkZnp7hG7e08mRM5jg5MeHiEyBbeWSv
         x0du3SMyQ9lpvaYTAW0V2wLz/UB7j6+ocmf4wHX8s6eRbtzRZYqMWIxWjtjULqP6C4bW
         M0GKLOras0u4RG033SXS4TutL8/YxHe84MuQg5qMSsuHA46fFNh5GYLNUlw5zt6rLFpH
         lPamz0aOtWif0L8Xwd9y6IuDzF88WL9U9/Wrkz6w/ojzy4yseSxncEM/gdPXapoBRiye
         OD2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IeBu9dlbnETh/snav+HDoMJthQ1+kr8O/vbgPiiEFL0=;
        b=EyoTPxZ6zIFXTvr7XOpQTD/RykQLZjHP3xMRFuK6kexX9NpslXzXHhloVDxh/1ZhNP
         IJrKZaME8EMJ7PGB1NG4J/LzSJQoVMRTG6KEgAssFNBZAPt/1RdD/7ft2hiw77xKEXvq
         uJhpPwAlXhqsqjjm2waQdnaGhzeCsLinOckA1Xg5wIiCgtSOi2Z09MIB5SeZwiNFR+8K
         vzFjUGDl0B0qb1xZYe7JqDvRrEBsUnquCRBhTU5A4poguJuE3jFPQpNuUtPxykz6in5K
         s3YQutFT5QqSBFPYxtwun88iQyyhQ5yv+Tw4Beo/F8KCekeAOuw6Wcto6Ob0J9xZkkZm
         vXyw==
X-Gm-Message-State: AOAM530rNcLpXfaqm5QuXaRV3sWGdYF5e9n7ImNanZjgJqgAjCXARV9l
        OnMEQa6stXNqpn1xMQlq0IBF2VJY58+suWU8wZA=
X-Google-Smtp-Source: ABdhPJxl7vGHmUQKL2IDBs7BWNlfr/eQKKVjXS1kHwEt26Q3o0lgqgVK5VfRWIJs6YdqkGfT7anczm2no+OOQuAgrrM=
X-Received: by 2002:a17:906:3f8d:: with SMTP id b13mr6596740ejj.464.1611961728181;
 Fri, 29 Jan 2021 15:08:48 -0800 (PST)
MIME-Version: 1.0
References: <20210129195240.31871-1-TheSven73@gmail.com> <20210129195240.31871-3-TheSven73@gmail.com>
 <CAF=yD-KBc=1SvpLET_NKjdaCTUP4r6P9hRU8QteBkw6W3qeP_A@mail.gmail.com> <CAGngYiW-omAi4cpXExX5aRNGTO-LX4kb6bnS7Q=JfBvYV55QCQ@mail.gmail.com>
In-Reply-To: <CAGngYiW-omAi4cpXExX5aRNGTO-LX4kb6bnS7Q=JfBvYV55QCQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 Jan 2021 18:08:11 -0500
Message-ID: <CAF=yD-JaD3oO6r0sGp7t5t3TLxUpi8a4jzX04MSfxrPBWuj0gA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 6:03 PM Sven Van Asbroeck <thesven73@gmail.com> wrote:
>
> Hoi Willem, thanks a lot for reviewing this patch, much appreciated !!
>
> On Fri, Jan 29, 2021 at 5:11 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > > +static struct sk_buff *
> > > +lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
> > > +{
> > > +       if (skb_linearize(skb)) {
> >
> > Is this needed? That will be quite expensive
>
> The skb will only be non-linear when it's created from a multi-buffer frame.
> Multi-buffer frames are only generated right after a mtu change - fewer than
> 32 frames will be non-linear after an mtu increase. So as long as people don't
> change the mtu in a tight loop, skb_linearize is just a single comparison,
> 99.999999+% of the time.

Ah. I had missed the temporary state of this until the buffers are
reinitialized. Yes, then there is no reason to worry. Same for the
frag_list vs frags comment I made.

> >
> > Is it possible to avoid the large indentation change, or else do that
> > in a separate patch? It makes it harder to follow the functional
> > change.
>
> It's not immediately obvious, but I have replaced the whole function
> with slightly different logic, and the replacement content has a much
> flatter indentation structure, and should be easier to follow.
>
> Or perhaps I am misinterpreting your question?

Okay. I found it a bit hard to parse how much true code change was
mixed in with just reindenting existing code. If a lot, then no need
to split of the code refactor.

>
> > > +
> > > +       /* add buffers to skb via skb->frag_list */
> > > +       if (is_first) {
> > > +               skb_reserve(skb, RX_HEAD_PADDING);
> > > +               skb_put(skb, buffer_length - RX_HEAD_PADDING);
> > > +               if (rx->skb_head)
> > > +                       dev_kfree_skb_irq(rx->skb_head);
> > > +               rx->skb_head = skb;
> > > +       } else if (rx->skb_head) {
> > > +               skb_put(skb, buffer_length);
> > > +               if (skb_shinfo(rx->skb_head)->frag_list)
> > > +                       rx->skb_tail->next = skb;
> > > +               else
> > > +                       skb_shinfo(rx->skb_head)->frag_list = skb;
> >
> > Instead of chaining skbs into frag_list, you could perhaps delay skb
> > alloc until after reception, allocate buffers stand-alone, and link
> > them into the skb as skb_frags? That might avoid a few skb alloc +
> > frees. Though a bit change, not sure how feasible.
>
> The problem here is this (copypasta from somewhere else in this patch):
>
> /* Only the last buffer in a multi-buffer frame contains the total frame
> * length. All other buffers have a zero frame length. The chip
> * occasionally sends more buffers than strictly required to reach the
> * total frame length.
> * Handle this by adding all buffers to the skb in their entirety.
> * Once the real frame length is known, trim the skb.
> */
>
> In other words, the chip sometimes sends more buffers than strictly needed to
> fit the frame. linearize + trim deals with this thorny issue perfectly.
>
> If the skb weren't linearized, we would run into trouble when trying to trim
> (remove from the end) a chunk bigger than the last skb fragment.
>
> > > +process_extension:
> > > +       if (extension_index >= 0) {
> > > +               u32 ts_sec;
> > > +               u32 ts_nsec;
> > > +
> > > +               ts_sec = le32_to_cpu(desc_ext->data1);
> > > +               ts_nsec = (le32_to_cpu(desc_ext->data2) &
> > > +                         RX_DESC_DATA2_TS_NS_MASK_);
> > > +               if (rx->skb_head) {
> > > +                       hwtstamps = skb_hwtstamps(rx->skb_head);
> > > +                       if (hwtstamps)
> >
> > This is always true.
> >
> > You can just call skb_hwtstamps(skb)->hwtstamp = ktime_set(ts_sec, ts_nsec);
>
> Thank you, will do !
>
> >
> > Though I see that this is existing code just moved due to
> > aforementioned indentation change.
>
> True, but I can make the change anyway.
