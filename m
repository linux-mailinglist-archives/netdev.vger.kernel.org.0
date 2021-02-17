Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67D0631E2D7
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 23:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhBQW44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 17:56:56 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:49508 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232953AbhBQW4y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 17:56:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1613602570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a+IvpyKzSNnla/+PLMoHPA0EpqHUtnND/kL3l63t4Ao=;
        b=D+HuXq+7DuxMMA1R1cSCF5nlEThvRTyDKmmMHayRIrsIGMFezddx2tuRCDQIUFrWTUton1
        ZC+RtaVQUl7wDuVgrRTP+6G1m7PexIHaceuJnjCIm7EDgEVwNyPstgNevN+qmxnLdP99ES
        IfW19TFgjTciuxdn0gWJJk1PZ5598+0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id dc0cb23b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 17 Feb 2021 22:56:09 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id n195so271335ybg.9;
        Wed, 17 Feb 2021 14:56:09 -0800 (PST)
X-Gm-Message-State: AOAM5333xEf71yxd0KXETydUfzvTX5IMJNVk8PCw4cfW+rEf12agrlU7
        xBekExorPb+EEnu7Hvi/GqgCjFbGwTFkGj7xdLE=
X-Google-Smtp-Source: ABdhPJylgLkI1BQaJoQciNWYkgipl8YQS8lh9vEnA7b6wH7F/v1v0TWw5wDe90xraE/F40YhWoylb8oBWgtwMZuPh40=
X-Received: by 2002:a25:80c9:: with SMTP id c9mr2477741ybm.279.1613602569273;
 Wed, 17 Feb 2021 14:56:09 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9qfXFZKZfO-uc7GC3xguSq99_CqrTtzmgp_984MSfNbgA@mail.gmail.com>
 <CA+FuTSfHRtV7kP-y6ihW_BnYVmHE9Hv7jHgOdTwJhUXkd6L79w@mail.gmail.com>
In-Reply-To: <CA+FuTSfHRtV7kP-y6ihW_BnYVmHE9Hv7jHgOdTwJhUXkd6L79w@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 17 Feb 2021 23:55:58 +0100
X-Gmail-Original-Message-ID: <CAHmME9qRkxeKDA6pOXTE7yXTkN-AsfaDfLfUX8J7EP7fbUiB0Q@mail.gmail.com>
Message-ID: <CAHmME9qRkxeKDA6pOXTE7yXTkN-AsfaDfLfUX8J7EP7fbUiB0Q@mail.gmail.com>
Subject: Re: possible stack corruption in icmp_send (__stack_chk_fail)
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

On Wed, Feb 17, 2021 at 11:27 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
> A vmlinux image might help. I couldn't find one for this kernel.

https://data.zx2c4.com/icmp_send-crash-e03b4a42-706a-43bf-bc40-1f15966b3216.tar.xz
has .debs with vmlinuz in there, which you can extract to vmlinux, as
well as my own vmlinux elf construction with the symbols added back in
by extracting them from kallsyms. That's the best I've been able to
do, as all of this is coming from somebody random emailing me.

> But could it be
> that the forwarded packet is not sensible IPv4? The skb->protocol is
> inferred in wg_packet_consume_data_done->ip_tunnel_parse_protocol.

The wg calls to icmp_ndo_send are gated by checking skb->protocol:

        if (skb->protocol == htons(ETH_P_IP))
               icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0);
       else if (skb->protocol == htons(ETH_P_IPV6))
               icmpv6_ndo_send(skb, ICMPV6_DEST_UNREACH,
ICMPV6_ADDR_UNREACH, 0);

On the other hand, that code is hit on an error path when
wg_check_packet_protocol returns false:

static inline bool wg_check_packet_protocol(struct sk_buff *skb)
{
       __be16 real_protocol = ip_tunnel_parse_protocol(skb);
       return real_protocol && skb->protocol == real_protocol;
}

So that means, at least in theory, icmp_ndo_send could be called with
skb->protocol != ip_tunnel_parse_protocol(skb). I guess I can address
that. But... is it actually a problem?

Jason
