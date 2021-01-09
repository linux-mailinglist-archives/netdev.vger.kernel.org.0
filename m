Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258AC2F0400
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 23:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbhAIWKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 17:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbhAIWKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 17:10:21 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E5AC06179F
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 14:09:41 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id x16so19372210ejj.7
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 14:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GkkHyELtJNyq2hUrVUkeiC3kElbc7If9URJuvU6i9W8=;
        b=M0NcmaDCCGl47rI//dCOsC6OoIldtgAPS9A1gJ2cRg242gDPul8XaKKNQdjOEdkOPG
         vKnEhCbkwjeiAsb6Cxq9/BnE0WoFwQjCkILgppKcARLjOZwDdvv0gdMvIRumgGU+02ht
         aCMVAEHBcay88jYr7L0Io06Yfyo6ehyaHahknMJiHwuXW2YJs69ekxfJE7o/1hcqOGUB
         rgmZaxhxG/h0jN/A7OOejnr/gwLNQpjg0EV7R4pu6u8MMPkJr0cUaPdu6JL7AL4PIT+8
         179ek61v23Fc5He5ncVnK6VhX7Vxit2jeEZtl8mdgV2YTGK1aeDVz41A36LBEcR0u0yh
         WTmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GkkHyELtJNyq2hUrVUkeiC3kElbc7If9URJuvU6i9W8=;
        b=oBoieTuIfH40q12g/GJpv3asF54w4xF19PIUIOZTz1ieS87q4QM+iqn82c9MzazKuk
         YoMaCPYBzfRImXiikLRarVKaQqdRHIDBjDsg7wT+W++pMMOATaR/53fv5C+qDJVoq3OK
         p4lAlWNPFTMbaDYA+y9+0oOchM6n81VgnlUQsAUV8bWm7m80TwK3S+xXkLxHdrshErli
         OJ7gyEe2WqhuLM4Mkrvvb8/QsgQKUgL+Qf5L6hjttPXjPt7/SypMiSeTJ7X4IgC/xxbd
         hZJk8/KuneINB1NZt4vFx2JLjZvXhlNqY4YIcGGars2R/LfItxPhJ9Rsvs1cmj1MlOI3
         NxYA==
X-Gm-Message-State: AOAM532PhWlJKl5PA/Wkpbq+oATJAwMvMOr0bNY5pCxCzd48N/tZGJY3
        tNS53TKgPDi4tbh2pdzd6pctO5Qb68ZObRZloscGGHtcY9E=
X-Google-Smtp-Source: ABdhPJwTMN0uzssC9b2mijOYTOxPMm5qJVcFUE14cwYqLhzensequ40Nv9o7hm5TQ0l8NeRY6Hb9j0pxnM0k3ZaHbiw=
X-Received: by 2002:a17:906:158c:: with SMTP id k12mr6652825ejd.119.1610230179715;
 Sat, 09 Jan 2021 14:09:39 -0800 (PST)
MIME-Version: 1.0
References: <20210108171152.2961251-1-willemdebruijn.kernel@gmail.com> <20210108171152.2961251-3-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210108171152.2961251-3-willemdebruijn.kernel@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 9 Jan 2021 17:09:03 -0500
Message-ID: <CAF=yD-Ko7_rkN-pgc5-3qXeBmwNMObD4igWjQfcFVVYY5ES2JQ@mail.gmail.com>
Subject: Re: [PATCH net 2/3] net: compound page support in skb_seq_read
To:     Network Development <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 8, 2021 at 12:11 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> skb_seq_read iterates over an skb, returning pointer and length of
> the next data range with each call.
>
> It relies on kmap_atomic to access highmem pages when needed.
>
> An skb frag may be backed by a compound page, but kmap_atomic maps
> only a single page. There are not enough kmap slots to always map all
> pages concurrently.
>
> Instead, if kmap_atomic is needed, iterate over each page.
>
> As this increases the number of calls, avoid this unless needed.
> The necessary condition is captured in skb_frag_must_loop.
>
> I tried to make the change as obvious as possible. It should be easy
> to verify that nothing changes if skb_frag_must_loop returns false.
>
> Tested:
>   On an x86 platform with
>     CONFIG_HIGHMEM=y
>     CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP=y
>     CONFIG_NETFILTER_XT_MATCH_STRING=y
>
>   Run
>     ip link set dev lo mtu 1500
>     iptables -A OUTPUT -m string --string 'badstring' -algo bm -j ACCEPT
>     dd if=/dev/urandom of=in bs=1M count=20
>     nc -l -p 8000 > /dev/null &
>     nc -w 1 -q 0 localhost 8000 < in
>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  include/linux/skbuff.h |  1 +
>  net/core/skbuff.c      | 28 +++++++++++++++++++++++-----
>  2 files changed, 24 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index c858adfb5a82..68ffd3f115c1 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1203,6 +1203,7 @@ struct skb_seq_state {
>         struct sk_buff  *root_skb;
>         struct sk_buff  *cur_skb;
>         __u8            *frag_data;
> +       __u16           frag_off;

frags can exceed 64k, so this needs to be __u32, like the other offsets.

I'll have to send a v2.

There's also something to be said for having a

  BUILD_BUG_ON(sizeof(struct skb_seq_state) > sizeof(skb->cb));

as it's getting close. But I won't do that in this stable fix.
