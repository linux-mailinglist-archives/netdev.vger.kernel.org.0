Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F6B2A9E83
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 21:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgKFUQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 15:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbgKFUQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 15:16:47 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFECC0613CF
        for <netdev@vger.kernel.org>; Fri,  6 Nov 2020 12:16:47 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id gn41so3645325ejc.4
        for <netdev@vger.kernel.org>; Fri, 06 Nov 2020 12:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tSocQ9VOFDzbDNSqCChWlVbt3WlT7+kP+hQoEvBJV34=;
        b=MBJApWcIzbnmUtUxj4RFudvBLZHF/knqw+jbNWPJC7h+9kRmrMhnVY7QCHampWo4Xb
         yLLemwVsjksOeRi17VtuO3ySCZ6+MsrINmjxGh8x8rJ4K6PWF+pt5+tJBMq/Xk0tXign
         p2WQjRenWj3JGeW+LoGI26h+KeEQ0EW3eWoCzIPKm3cTqE/+rpx+Bd3ZPIfb1b6DLth1
         VOTjvWHRPJZFeENYbSSHS7bvsMmXPXLFdUrnDuSzGka6HBG+h1RayGrUtcUQ0na47+07
         gCpzX4aZre8staBGHpgX+aKV7gUitDmPMrZdxiQY8Wmzo6B/eMn2fEKh1/mgGX28AILM
         AHIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tSocQ9VOFDzbDNSqCChWlVbt3WlT7+kP+hQoEvBJV34=;
        b=Mg8aUDedQycb0Qx2xKcjdztjwCIPMIDJt0INBBQa2mWoLFk8hMnaH9JATnNsrydx9i
         OrKS1jRQDPyL0ShCLSt+iZtwQR6odm7MPw1ZulkgWhTPQaD6TL0oYnfbvFacaf2t6tvT
         rSVdMWRqmhY8OuUZf5rI2mNvYZobpvNO+1wdW/OQgoKft9wU3trZfByu2LfM6wev69b/
         Sag2zuOoq0QVCbnAsV0DnZVGrHH5i96McyfJDncpxxAjA1AzSVFBDrmqWCYF6nVQwwSR
         kWno01mKJEYuxWetYP+Aoggs/8Q/JN43I0yp6H0MRGKW4XopYkUiZPOTLFVAZajC2lVb
         gB0w==
X-Gm-Message-State: AOAM530xDHGGtqzfN7kD+ydUtmt4hQSqqOvu/vJS2hc/J82uWPqJAyqo
        aaaVz5qCNI6HDasKNSUg1Dvp82YDva6blMtb1BlWpqJddBo=
X-Google-Smtp-Source: ABdhPJw2mD/YKOseWYkybZTMXaIV+qwA6Y8WUXbTkRocpvdNYbphPD2nGXQ9y1G075ji4e5KgOORrMu1qt2N986Q7iI=
X-Received: by 2002:a17:906:5793:: with SMTP id k19mr3892499ejq.410.1604693805635;
 Fri, 06 Nov 2020 12:16:45 -0800 (PST)
MIME-Version: 1.0
References: <20201103174651.590586-1-awogbemila@google.com>
 <20201103174651.590586-4-awogbemila@google.com> <02019e49d43ba71d86f9caed761dbfe64a77331b.camel@kernel.org>
In-Reply-To: <02019e49d43ba71d86f9caed761dbfe64a77331b.camel@kernel.org>
From:   David Awogbemila <awogbemila@google.com>
Date:   Fri, 6 Nov 2020 12:16:34 -0800
Message-ID: <CAL9ddJeWcWYQKtgT36To_hpbMhf6=U2+iKKncmSwNrwtvdwRJg@mail.gmail.com>
Subject: Re: [PATCH 3/4] gve: Rx Buffer Recycling
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 4:01 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Tue, 2020-11-03 at 09:46 -0800, David Awogbemila wrote:
> > This patch lets the driver reuse buffers that have been freed by the
> > networking stack.
> >
> > In the raw addressing case, this allows the driver avoid allocating
> > new
> > buffers.
> > In the qpl case, the driver can avoid copies.
> >
> > Signed-off-by: David Awogbemila <awogbemila@google.com>
> > ---
> >  drivers/net/ethernet/google/gve/gve.h    |  10 +-
> >  drivers/net/ethernet/google/gve/gve_rx.c | 194 +++++++++++++++----
> > ----
>
> > +     if (len <= priv->rx_copybreak) {
> > +             /* Just copy small packets */
> > +             skb = gve_rx_copy(dev, napi, page_info, len);
> > +             u64_stats_update_begin(&rx->statss);
> > +             rx->rx_copied_pkt++;
> > +             rx->rx_copybreak_pkt++;
> > +             u64_stats_update_end(&rx->statss);
> > +     } else {
> > +             bool can_flip = gve_rx_can_flip_buffers(dev);
> > +             int recycle = 0;
> > +
> > +             if (can_flip) {
> > +                     recycle = gve_rx_can_recycle_buffer(page_info-
> > >page);
> > +                     if (recycle < 0) {
> > +                             gve_schedule_reset(priv);
>
> How would a reset solve anything if your driver is handling pages with
> "bad" refcount, i don't agree here that reset is the best course of
> action, all you can do here is warn and leak the page ...
> this is a critical driver bug and not something that user should
> expect.
>
Thanks for pointing this out. For the raw addressing case it would be
fine to warn and leak the page, but for the qpl (non raw addressing)
case, the driver pre-allocates a set of pages which it registers with
the NIC so we'd want to avoid leaking pages - a reset will help here
because we'd allocate a new set of pages and register them with the
NIC.
I will handle both cases separately:
- in raw addressing mode, just warn and leak the page
- in qpl mode, schedule a reset.


> > +
> > +             } else {
> > +                     /* It is possible that the networking stack has
> > already
> > +                      * finished processing all outstanding packets
> > in the buffer
> > +                      * and it can be reused.
> > +                      * Flipping is unnecessary here - if the
> > networking stack still
> > +                      * owns half the page it is impossible to tell
> > which half. Either
> > +                      * the whole page is free or it needs to be
> > replaced.
> > +                      */
> > +                     int recycle =
> > gve_rx_can_recycle_buffer(page_info->page);
> > +
> > +                     if (recycle < 0) {
> > +                             gve_schedule_reset(priv);
> > +                             return false;
>
> Same.
>
>
