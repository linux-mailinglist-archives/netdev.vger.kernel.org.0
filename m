Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40952B98A7
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgKSQzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbgKSQzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 11:55:15 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CE3C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:55:15 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id a19so175813ilm.3
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 08:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L0naunBkrM+FiT0qsIjEmpp8Io+t41akUly/TkuBwJc=;
        b=FMCbJVQzn5HLmFdxK0qpDa5ryTPMLFujdjvrozlUOqD63d0M53SUyrtSqDYsYGQ3sf
         1TNoB3taZ7myuQzCwIYjqjiQ0b8I7/Oaz1uJSF0wLO0s90thyBuzr/0nmSggND0bdSCp
         Balc8SRhv2G4FSlKDp7rDspLpPZwFJrsNxgv3deAiPHUa1Eihv3atvuy4s2qrrJUra/Q
         jsl0ZcVyhV0uPgr6dt4bYW6yRNoefMJ2shps6UlMoOPd7BSJ2oAPbJLasHcy9X19Gebv
         4mMj6Xkq9gC0m7hnirsHAHDaixAog0Y7n9OcZLUqkldfI/Cv0zpQXgLEm9gkkwUh0Zyu
         aQEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L0naunBkrM+FiT0qsIjEmpp8Io+t41akUly/TkuBwJc=;
        b=M4lnvjjCT8H5zL0zsYbjRPmAhN7ycfdcFEucy5lnDcoUgOwr4c2mJhu9BFrsTFJFUT
         S4VPrdombitIZA6XoBUc9PpvBG1nvYirG5GsFmutEtn741oXcuv8uKfm4D02aKc3dsFa
         IztRPa9FR7fZb7PvGxDAkiW+80CLBYyg4UDfQDjktaU6BKfqm91tJ0netQ0PwkeHS7dP
         kOWnPeQj+Jag+7APaEw7tm7ZM0YmkQpw1YERmcpduBen44fJpk6e3w5KAzYSxUEPx9zS
         GyzLJ+VmKtgQKxLcNVk9FwNBEi3SBA7D0Pu0c7j5ENIsuzyvwhHESwYt9U6q/tqyh6VK
         Hy7w==
X-Gm-Message-State: AOAM531SP4mcdXkot3Cb8CeZ1jks5ajhXzX9kurgXkP+4wbk/+kRuCZD
        FKNWcf2/0tR1m3ntCzpMCBA12JkoAj6PdUnel3XmPnkghA4=
X-Google-Smtp-Source: ABdhPJwRaU2CAJotkFmjcVyEulhcjk+a0+VynTkOU/U4u8JzPpljKEdmyJVI/Tn938YXpDHGl0xoDnDSMwQ1rtDWiLM=
X-Received: by 2002:a05:6e02:120f:: with SMTP id a15mr19871837ilq.97.1605804914323;
 Thu, 19 Nov 2020 08:55:14 -0800 (PST)
MIME-Version: 1.0
References: <20201109233659.1953461-1-awogbemila@google.com>
 <20201109233659.1953461-4-awogbemila@google.com> <CAKgT0UcFxqsdWQDxueMA4X90BWM11eDR3Z5f0JhEtbezR226+g@mail.gmail.com>
 <CAL9ddJfa3dpie_zjFG+6jyJ0H9wXGWXWs_TTaL540kQbGO4U+Q@mail.gmail.com>
In-Reply-To: <CAL9ddJfa3dpie_zjFG+6jyJ0H9wXGWXWs_TTaL540kQbGO4U+Q@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 19 Nov 2020 08:55:02 -0800
Message-ID: <CAKgT0Uc8LdPKw27T-js5O-2g+e8o=QMwasA+57hjZt9ih_-T-w@mail.gmail.com>
Subject: Re: [PATCH net-next v6 3/4] gve: Rx Buffer Recycling
To:     David Awogbemila <awogbemila@google.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 2:50 PM David Awogbemila <awogbemila@google.com> wrote:
>
> On Wed, Nov 11, 2020 at 9:20 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Mon, Nov 9, 2020 at 3:39 PM David Awogbemila <awogbemila@google.com> wrote:
> > >
> > > This patch lets the driver reuse buffers that have been freed by the
> > > networking stack.
> > >
> > > In the raw addressing case, this allows the driver avoid allocating new
> > > buffers.
> > > In the qpl case, the driver can avoid copies.
> > >
> > > Signed-off-by: David Awogbemila <awogbemila@google.com>
> > > ---

<snip>

> > > +static int gve_rx_can_recycle_buffer(struct page *page)
> > > +{
> > > +       int pagecount = page_count(page);
> > > +
> > > +       /* This page is not being used by any SKBs - reuse */
> > > +       if (pagecount == 1)
> > > +               return 1;
> > > +       /* This page is still being used by an SKB - we can't reuse */
> > > +       else if (pagecount >= 2)
> > > +               return 0;
> > > +       WARN(pagecount < 1, "Pagecount should never be < 1");
> > > +       return -1;
> > > +}
> > > +
> >
> > So using a page count of 1 is expensive. Really if you are going to do
> > this you should probably look at how we do it currently in ixgbe.
> > Basically you want to batch the count updates to avoid expensive
> > atomic operations per skb.
>
> A separate patch will be coming along to change the way the driver
> tracks page count.
> I thought it would be better to have that reviewed separately since
> it's a different issue from what this patch addresses.

Okay, you might want to call that out in your patch description then
that this is just a temporary placeholder. Back when I did this for
ixgbe I think we had it doing a single page update for a few years,
however that code had a bug in it that would cause page count
corruption as I wasn't aware at the time that the mm tree had
functions that would take a reference on the page without us ever
handing it out.

> >
> > >  static struct sk_buff *
> > >  gve_rx_raw_addressing(struct device *dev, struct net_device *netdev,
> > >                       struct gve_rx_slot_page_info *page_info, u16 len,
> > >                       struct napi_struct *napi,
> > > -                     struct gve_rx_data_slot *data_slot)
> > > +                     struct gve_rx_data_slot *data_slot, bool can_flip)
> > >  {
> > > -       struct sk_buff *skb = gve_rx_add_frags(napi, page_info, len);
> > > +       struct sk_buff *skb;
> > >
> > > +       skb = gve_rx_add_frags(napi, page_info, len);
> >
> > Why split this up?It seemed fine as it was.
>
> It was based on a comment from v3 of the patchset.

Do you recall the comment? This just seems like noise to me since it
is moving code and doesn't seem to address either a formatting issue,
nor a functional issue.

> >
> > >         if (!skb)
> > >                 return NULL;
> > >
> > > +       /* Optimistically stop the kernel from freeing the page by increasing
> > > +        * the page bias. We will check the refcount in refill to determine if
> > > +        * we need to alloc a new page.
> > > +        */
> > > +       get_page(page_info->page);
> > > +       page_info->can_flip = can_flip;
> > > +
> >
> > Why pass can_flip and page_info only to set it here? Also I don't get
> > why you are taking an extra reference on the page without checking the
> > can_flip variable. It seems like this should be set in the page_info
> > before you call this function and then you call get_page if
> > page_info->can_flip is true.
>
> I think it's important to call get_page here even for buffers we know
> will not be flipped so that if the skb does a put_page twice we would
> not run into the WARNing in gve_rx_can_recycle_buffer when trying to
> refill buffers.
> (Also please note that a future patch changes the way the driver uses
> page refcounts)

It was your buffer recycling bit that I hadn't noticed. So you have
cases where if your page count gets to 2 you push it to 3 in the hopes
that the 2 that are already out there will be freed and you are left
holding the one remaining count. However I am not sure how much of an
advantage there is to that. If the page flipping is already failing I
wonder what percentage of the time you are able to recover from that.
It might be worthwhile to look at adding a couple of counters to track
the number of times you couldn't flip versus the number of times you
recycled the frame. You may find that the buffer recycling is adding
more overhead for very little gain versus just doing the page
flipping.
