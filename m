Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C220130906B
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhA2XDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 18:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231156AbhA2XDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 18:03:42 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E842FC061574;
        Fri, 29 Jan 2021 15:03:01 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id s7so7403231wru.5;
        Fri, 29 Jan 2021 15:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RmvtJwhTzh4vq5D1j1JdBUXH8p8rCNm+ETl3sHiGSV4=;
        b=Am1zJOtSfps6TPVx5z5tlmaW3W1lYDf8I4EFYiWpoQ/eM0n4oaFqrWIHuDdkmeOZ0O
         wtEs8vWwvq8GeoWnv9VYVzag/g1ebvui7HMFLzGuoJxtiddSF2Kfw41skaDJXtKPet7b
         gYM4buqIbO7CGHh7ZokKFHgidDdKM0DOmRBP4b5PzjpeVshlWmwzMIY9APxV7uwx84/j
         qLRN7On9JOaAH1GyyOBDZPPXGA4aAlscHQi0kVLKo9ESnyUB4KhgtaR1asjToNVziHPA
         hzjpPDWM60PsrHv6Jybn4rq/s+qR3J7sKDptIbnOoT96JVCOm+KY9hQOalo4DHoCB0JS
         zofA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RmvtJwhTzh4vq5D1j1JdBUXH8p8rCNm+ETl3sHiGSV4=;
        b=Fn9lpDYJnuExC86igp/tO2MC89zJ2BmeAJpdmSpbiXeL+GWdQS45XdR8pKHrVVr1Ec
         4XSsCaaI70zZxz5FyXjGOEmboBslDHTWmtKMB/ZoTPBTj+ET1bXOS1/eMuw/Gzq2IQEN
         kUVXcQu/dH2KoGOCmgmWC4HlKF6oT44VnG82u2YN5/oc8OlazkJZ0rCFHV/DZVI3bm2e
         2uVHDelP2ZcdBIVd9UywB4CWbh2lGowiDt6Z+JvxG4uAYNzcYBMUXBUsE8+EUUXuDc4Q
         OC3afzr3ubJV6IUqDLRLt6oTH6gmjs1pwvGmkTP7udKnXb7wLTzcimXKWPnXtjprwkLZ
         CPfA==
X-Gm-Message-State: AOAM5310gQqIhMaLu1vJfKxYmTWUtxdqBDMQOnl4Qqu6ZL/XnEyQo1Ft
        4ozN87r/e+A4B8LOmtbP8tOv7zlNbWxU0YiWYBY=
X-Google-Smtp-Source: ABdhPJwY3OD0cT44lO18NY4d+UDHl0m9JqUGoZ9OLOskLq0zflh5PmhtbS7AdQ4vskFEDq306Qk1JwSkar0KCqg1u3A=
X-Received: by 2002:a5d:60c6:: with SMTP id x6mr6774946wrt.85.1611961380540;
 Fri, 29 Jan 2021 15:03:00 -0800 (PST)
MIME-Version: 1.0
References: <20210129195240.31871-1-TheSven73@gmail.com> <20210129195240.31871-3-TheSven73@gmail.com>
 <CAF=yD-KBc=1SvpLET_NKjdaCTUP4r6P9hRU8QteBkw6W3qeP_A@mail.gmail.com>
In-Reply-To: <CAF=yD-KBc=1SvpLET_NKjdaCTUP4r6P9hRU8QteBkw6W3qeP_A@mail.gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Fri, 29 Jan 2021 18:02:49 -0500
Message-ID: <CAGngYiW-omAi4cpXExX5aRNGTO-LX4kb6bnS7Q=JfBvYV55QCQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
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

Hoi Willem, thanks a lot for reviewing this patch, much appreciated !!

On Fri, Jan 29, 2021 at 5:11 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> > +static struct sk_buff *
> > +lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
> > +{
> > +       if (skb_linearize(skb)) {
>
> Is this needed? That will be quite expensive

The skb will only be non-linear when it's created from a multi-buffer frame.
Multi-buffer frames are only generated right after a mtu change - fewer than
32 frames will be non-linear after an mtu increase. So as long as people don't
change the mtu in a tight loop, skb_linearize is just a single comparison,
99.999999+% of the time.

>
> Is it possible to avoid the large indentation change, or else do that
> in a separate patch? It makes it harder to follow the functional
> change.

It's not immediately obvious, but I have replaced the whole function
with slightly different logic, and the replacement content has a much
flatter indentation structure, and should be easier to follow.

Or perhaps I am misinterpreting your question?

> > +
> > +       /* add buffers to skb via skb->frag_list */
> > +       if (is_first) {
> > +               skb_reserve(skb, RX_HEAD_PADDING);
> > +               skb_put(skb, buffer_length - RX_HEAD_PADDING);
> > +               if (rx->skb_head)
> > +                       dev_kfree_skb_irq(rx->skb_head);
> > +               rx->skb_head = skb;
> > +       } else if (rx->skb_head) {
> > +               skb_put(skb, buffer_length);
> > +               if (skb_shinfo(rx->skb_head)->frag_list)
> > +                       rx->skb_tail->next = skb;
> > +               else
> > +                       skb_shinfo(rx->skb_head)->frag_list = skb;
>
> Instead of chaining skbs into frag_list, you could perhaps delay skb
> alloc until after reception, allocate buffers stand-alone, and link
> them into the skb as skb_frags? That might avoid a few skb alloc +
> frees. Though a bit change, not sure how feasible.

The problem here is this (copypasta from somewhere else in this patch):

/* Only the last buffer in a multi-buffer frame contains the total frame
* length. All other buffers have a zero frame length. The chip
* occasionally sends more buffers than strictly required to reach the
* total frame length.
* Handle this by adding all buffers to the skb in their entirety.
* Once the real frame length is known, trim the skb.
*/

In other words, the chip sometimes sends more buffers than strictly needed to
fit the frame. linearize + trim deals with this thorny issue perfectly.

If the skb weren't linearized, we would run into trouble when trying to trim
(remove from the end) a chunk bigger than the last skb fragment.

> > +process_extension:
> > +       if (extension_index >= 0) {
> > +               u32 ts_sec;
> > +               u32 ts_nsec;
> > +
> > +               ts_sec = le32_to_cpu(desc_ext->data1);
> > +               ts_nsec = (le32_to_cpu(desc_ext->data2) &
> > +                         RX_DESC_DATA2_TS_NS_MASK_);
> > +               if (rx->skb_head) {
> > +                       hwtstamps = skb_hwtstamps(rx->skb_head);
> > +                       if (hwtstamps)
>
> This is always true.
>
> You can just call skb_hwtstamps(skb)->hwtstamp = ktime_set(ts_sec, ts_nsec);

Thank you, will do !

>
> Though I see that this is existing code just moved due to
> aforementioned indentation change.

True, but I can make the change anyway.
