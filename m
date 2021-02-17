Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0761331E2E9
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 00:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhBQXHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 18:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhBQXHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 18:07:12 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7725C061574;
        Wed, 17 Feb 2021 15:06:31 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id g5so24006ejt.2;
        Wed, 17 Feb 2021 15:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HnAA5Jv9N7pYCxyjAmYE96d/xuWolcb+NLoxsAxALxo=;
        b=tQo0yQAGy6D1Uv/gart5kNyv5mxF5ERRHWPCziZUfhpCPjmyak+RW4x+T7lwmT1pVI
         YVLYM5DFzIWQNa3K9VWF0fG0DudE9MY8bpKrK1WDBHWsZGv9IbNxIHmYwl0T8tW4KRRv
         1jq7HQMHaIa0apDrAyaIVavXAqIagOmvC52hKz6l4n1wZ/Jfayo8lM194HrHCdEWUw72
         U49wsJyxf4EzvIrvodNgp6P2TKPq2CegHgY3pZbqjtyRAeXA0x+r6qqXjRyT5MbN0Is9
         a6DGQgmJZaVVVZ7dqBxrVZ0mJt5J5fk9fDQQm92yhBV0ozyDNmxBaIQb+GkKdOAFAkZ2
         6/jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HnAA5Jv9N7pYCxyjAmYE96d/xuWolcb+NLoxsAxALxo=;
        b=mdV73saFxkV/ir7xDSEEvL8ChHo0gN1azkCEWWXaTUGe3G5to3sPUgX0ECKhKqrcMo
         y35kppIVb7dsOGvZuqSlcZMIIn5ZCutDz3VoWoZcqVc3u1iHOasXh6fn9BC05uKwrHnN
         kY7EKk4hgnDeyClqOqowjN6kWdF4Y3rb5yo1c3QoCsaskDzMxBBKkuonscAmmTDwdpUi
         0HCGPwtT1XaRKT2FzNUKEEEwoFdWdXNpgRVpGiBMHROPUItlkhHi22+GEWnSs3hQnDIY
         CUZ8JZnGnUnk9pAh2VqUsSyCoJCpHW2q2k3TZjB+IKTVcxfmkDpF/a2YDDUfU8Hqxw1I
         TgbQ==
X-Gm-Message-State: AOAM530zRgWUux7Okbwtqaq21br63Jy9hj/hQj/d8yRlBrMtXLWN8LbU
        hYXBLbypWhGcz6Q+4UxvQmUeuuGLav9C9NzCoSZluRFB
X-Google-Smtp-Source: ABdhPJwKpcjsJY/30giwzE8IQyqG7eD9/3/z9HPLWywU2vhQ8gnTU+CIDnKu6eWs9Z5zU1ifAFT9sVIEDslZerpYuD0=
X-Received: by 2002:a17:907:20e8:: with SMTP id rh8mr1221451ejb.119.1613603190503;
 Wed, 17 Feb 2021 15:06:30 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9qfXFZKZfO-uc7GC3xguSq99_CqrTtzmgp_984MSfNbgA@mail.gmail.com>
 <CA+FuTSfHRtV7kP-y6ihW_BnYVmHE9Hv7jHgOdTwJhUXkd6L79w@mail.gmail.com> <CAHmME9qRkxeKDA6pOXTE7yXTkN-AsfaDfLfUX8J7EP7fbUiB0Q@mail.gmail.com>
In-Reply-To: <CAHmME9qRkxeKDA6pOXTE7yXTkN-AsfaDfLfUX8J7EP7fbUiB0Q@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 17 Feb 2021 18:05:54 -0500
Message-ID: <CAF=yD-+Fm7TuggoEeP=Wy7DEmfuC6nxmyBQxX=EzhyTQsiP2DQ@mail.gmail.com>
Subject: Re: possible stack corruption in icmp_send (__stack_chk_fail)
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 5:56 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Willem,
>
> On Wed, Feb 17, 2021 at 11:27 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> > A vmlinux image might help. I couldn't find one for this kernel.
>
> https://data.zx2c4.com/icmp_send-crash-e03b4a42-706a-43bf-bc40-1f15966b3216.tar.xz
> has .debs with vmlinuz in there, which you can extract to vmlinux, as
> well as my own vmlinux elf construction with the symbols added back in
> by extracting them from kallsyms. That's the best I've been able to
> do, as all of this is coming from somebody random emailing me.
>
> > But could it be
> > that the forwarded packet is not sensible IPv4? The skb->protocol is
> > inferred in wg_packet_consume_data_done->ip_tunnel_parse_protocol.
>
> The wg calls to icmp_ndo_send are gated by checking skb->protocol:
>
>         if (skb->protocol == htons(ETH_P_IP))
>                icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
>        else if (skb->protocol == htons(ETH_P_IPV6))
>                icmpv6_ndo_send(skb, ICMPV6_DEST_UNREACH,
> ICMPV6_ADDR_UNREACH, 0);
>
> On the other hand, that code is hit on an error path when
> wg_check_packet_protocol returns false:
>
> static inline bool wg_check_packet_protocol(struct sk_buff *skb)
> {
>        __be16 real_protocol = ip_tunnel_parse_protocol(skb);
>        return real_protocol && skb->protocol == real_protocol;
> }
>
> So that means, at least in theory, icmp_ndo_send could be called with
> skb->protocol != ip_tunnel_parse_protocol(skb). I guess I can address
> that. But... is it actually a problem?

For this forwarded packet that arrived on a wireguard tunnel,
skb->protocol was originally also set by ip_tunnel_parse_protocol.
So likely not.

The other issue seems more like a real bug. wg_xmit calling
icmp_ndo_send without clearing IPCB first.
