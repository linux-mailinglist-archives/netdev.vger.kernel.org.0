Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF75309D8B
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 16:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhAaP0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 10:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231270AbhAaP0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 10:26:20 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDE8C061574;
        Sun, 31 Jan 2021 07:25:39 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id q7so13836958wre.13;
        Sun, 31 Jan 2021 07:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GhEHGUi/3x7MT7H9Mn5ltAw8hDBUJl2hwLBKiqP3I+0=;
        b=ewu+JpRJrihfRy3GqoS/jsRKyfq/31+fXXGZJy/U8ueFvzqtjaj116hn1nnyF9DylQ
         +6kWKcR7Girjy1sd69DBaFzCIsI1KdlDVIKbpK23ZY9avVs1XWH6rhSyZUU3uygM5t/7
         V9TOVQqZHcj+8ayfAdOWk6ues1fwuM3JapCXgEeGj5FxjDy5NUiIPjg1meJRQnvTCR0y
         +b8oJurs1zRHe18W1CNUytflx6Tbsr9zvd4XpDiVEyTZGYdnTzdmT5yARWY30UTqRrQi
         EmnP9AmwyAG/g86YTUToyzs7xx4eOCoeqPE0Q5i2sHLNFP6hm+L5Kr2LnWk9/pCaBEGa
         6p3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GhEHGUi/3x7MT7H9Mn5ltAw8hDBUJl2hwLBKiqP3I+0=;
        b=IBwoZVXXgOL0yUj4/kf98vmQiOJ/1+XypZVov3hnSt4zlHvIbb9NxCvXiDBxRxmzTC
         /mUhDZi964QYVP8ZZVNiadz9zMyAWUVSMgtDDLMZ6BmW+WJ1a8w+qwuP4ivrTY0yTVka
         dFNZGfPhQouu8a/Lt+HmDL0KyWLGlhX3oElIvAXqXvZMXXjGWb/+GHwgmy+K8x8jPzx+
         0EMxvEAu1lps0gLzUylgP+0iv7ulUSFqQmfS/PT792+dHF1OzJxVnVXKEptSstuVDiIS
         uhcJ0s7lVw3iRPvW+BMyCqf/DvFXnrSdevddAJIx1TC+dorlN8uM/KEaETLX7h92aBX1
         HDaA==
X-Gm-Message-State: AOAM533U4SLKzM+Yw+DwDR2GAltbjnpmkSuu9pyTb9aGrJLXo9GJBVNd
        nJSvLT/BI4ZOpdbNm6cpQN3OO/G3K6mG7ntOso/V3TAFqrQ=
X-Google-Smtp-Source: ABdhPJzhLyDDHAozPJChY+HCFGKTS0PVBcXBZPEBQiFl356hneSOMPCqnYEBjUp2TG6ckqHgKPgu+XX0Z/LusxmqK8g=
X-Received: by 2002:adf:ed02:: with SMTP id a2mr2806786wro.197.1612106738119;
 Sun, 31 Jan 2021 07:25:38 -0800 (PST)
MIME-Version: 1.0
References: <20210129195240.31871-1-TheSven73@gmail.com> <20210129195240.31871-3-TheSven73@gmail.com>
 <MN2PR11MB3662C081B6CDB8BC1143380FFAB79@MN2PR11MB3662.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB3662C081B6CDB8BC1143380FFAB79@MN2PR11MB3662.namprd11.prod.outlook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Sun, 31 Jan 2021 10:25:27 -0500
Message-ID: <CAGngYiVvuNYC4WPCRfPOfjr98S_BGBNGjPze11AiHY9Pq1eJsA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
To:     Bryan Whitehead <Bryan.Whitehead@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 2:06 AM <Bryan.Whitehead@microchip.com> wrote:
>
> >  static int lan743x_rx_process_packet(struct lan743x_rx *rx)  {
> It looks like this function no longer processes a packet, but rather only processes a single buffer.
> So perhaps it should be renamed to lan743x_rx_process_buffer, so it is not misleading.

Agreed, will do.

>
> If lan743x_rx_init_ring_element fails to allocate an skb,
> Then lan743x_rx_reuse_ring_element will be called.
> But that function expects the skb is already allocated and dma mapped.
> But the dma was unmapped above.

Good catch. I think you're right, the skb allocation always has to come before
the unmap. Because if we unmap, and then the skb allocation fails, there is no
guarantee that we can remap the old skb we've just unmapped (it could fail).
And then we'd end up with a broken driver.

BUT I actually joined skb alloc and init_ring_element, because of a very subtle
synchronization bug I was seeing: if someone changes the mtu _in_between_
skb alloc and init_ring_element, things will go haywire, because the skb and
mapping lengths would be different !

We could fix that by using a spinlock I guess, but synchronization primitives
in "hot paths" like these are far from ideal... Would be nice if we could
avoid that.

Here's an idea: what if we fold "unmap from dma" into init_ring_element()?
That way, we get the best of both worlds: length cannot change in the middle,
and the function can always "back out" without touching the ring element
in case an allocation or mapping fails.

Pseudo-code:

init_ring_element() {
    /* single "sampling" of mtu, so no synchronization required */
    length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;

    skb = alloc(length);
    if (!skb) return FAIL;
    dma_ptr = dma_map(skb, length);
    if (!dma_ptr) {
        free(skb);
        return FAIL;
    }
    if (buffer_info->dma_ptr)
        dma_unmap(buffer_info->dma_ptr, buffer_info->buffer_length);
    buffer_info->skb = skb;
    buffer_info->dma_ptr = dma_ptr;
    buffer_info->buffer_length = length;

    return SUCCESS;
}

What do you think?

>
> Also if lan743x_rx_init_ring_element fails to allocate an skb.
> Then control will jump to process_extension and therefor
> the currently received skb will not be added to the skb list.
> I assume that would corrupt the packet? Or am I missing something?
>

Yes if an skb alloc failure in the middle of a multi-buffer frame, will corrupt
the packet inside the frame. A chunk will be missing. I had assumed that this
would be caught by an upper network layer, some checksum would be incorrect?

Are there current networking devices that would send a corrupted packet to
Linux if there is a corruption on the physical link? Especially if they don't
support checksumming?

Maybe my assumption is naive.
I'll fix this up if you believe that it could be an issue.

> ...
> > -               if (!skb) {
> > -                       result = RX_PROCESS_RESULT_PACKET_DROPPED;
> It looks like this return value is no longer used.
> If there is no longer a case where a packet will be dropped
> then maybe this return value should be deleted from the header file.

Agreed, will do.

>
> ...
> >  move_forward:
> > -               /* push tail and head forward */
> > -               rx->last_tail = real_last_index;
> > -               rx->last_head = lan743x_rx_next_index(rx, real_last_index);
> > -       }
> > +       /* push tail and head forward */
> > +       rx->last_tail = rx->last_head;
> > +       rx->last_head = lan743x_rx_next_index(rx, rx->last_head);
> > +       result = RX_PROCESS_RESULT_PACKET_RECEIVED;
>
> Since this function handles one buffer at a time,
>   The return value RX_PROCESS_RESULT_PACKET_RECEIVED is now misleading.
>   Can you change it to RX_PROCESS_RESULT_BUFFER_RECEIVED.

Agreed, will do.

RX_PROCESS_RESULT_XXX can now only take two values (RECEIVED and NOTHING_TO_DO),
so in theory it could be replaced by a bool. But perhaps we should keep the
current names, because they are clearer to the reader?

>
>
