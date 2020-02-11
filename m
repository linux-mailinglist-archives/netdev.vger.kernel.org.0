Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79317159672
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 18:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgBKRog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 12:44:36 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:53041 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728434AbgBKRog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 12:44:36 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 4ac6d57d
        for <netdev@vger.kernel.org>;
        Tue, 11 Feb 2020 17:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=zDu+ndX72CXRiYMS2ynk5FqbORw=; b=PFGz3s
        Y90ouAMQBYEytfIx49eDLFY95aUOGec0RMc85Stm+i9Oul3owzgi+0AmPS3qtcik
        N0LR+Pz6DMV3tLnEUcLbhuO7Oq7LFuT1lsPkFp12gWZaw2/OYt88dH8o4UBeon8R
        ygz2723Nk5UDStWcC1u1So7rX+/CAtu9fL5WyusHLD5K1vx98z1uIpCMhLBI6Axc
        9XwZdyGfYWI09GC1oNgdnDorbpoc56WvwpYRAmrbac/AGVRa+BXeMH91ZGAo5b63
        wKdnQTH/AwLEw1rWqNIiLiuPHeeUMXthozZcqGVyBIeihq4ElPR86GSCrbGHE6Fg
        Rq4TXJjyCS6CINag==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1d10ed20 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 11 Feb 2020 17:42:49 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id z2so13601487oih.6
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 09:44:34 -0800 (PST)
X-Gm-Message-State: APjAAAU7aCEPA2yAPnECgV6vXselU50D3fNK+glXvpdJrGfnHzG85Ycr
        2w8Fv+wGcY45Pp0rWoofpTePIYCLt91EneJYu2k=
X-Google-Smtp-Source: APXvYqy9cqyMlkWv2hsFtFQw19hMSqBkuXzMGH6lQnn1FSEJcz/NZ6y/of2/bFKaQ9SkUEmHCEKHPBavgHiyY1SRp2c=
X-Received: by 2002:aca:815:: with SMTP id 21mr3736346oii.52.1581443073435;
 Tue, 11 Feb 2020 09:44:33 -0800 (PST)
MIME-Version: 1.0
References: <20200210141423.173790-2-Jason@zx2c4.com> <20200211150028.688073-1-Jason@zx2c4.com>
 <20200211150028.688073-8-Jason@zx2c4.com> <db688bb4-bafa-8e9b-34aa-7f1d5a04e10f@gmail.com>
In-Reply-To: <db688bb4-bafa-8e9b-34aa-7f1d5a04e10f@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 11 Feb 2020 18:44:21 +0100
X-Gmail-Original-Message-ID: <CAHmME9o07Ugxet7sKHc9GYU5DkgyDEYsx36+KyAt7PAVtQRiag@mail.gmail.com>
Message-ID: <CAHmME9o07Ugxet7sKHc9GYU5DkgyDEYsx36+KyAt7PAVtQRiag@mail.gmail.com>
Subject: Re: [PATCH v3 net 7/9] ipvlan: remove skb_share_check from xmit path
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <maheshb@google.com>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 6:39 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Yes, maybe, but can you elaborate in this changelog ?
>
> AFAIK net/core/pktgen.c can definitely provide shared skbs.
>
>      refcount_inc(&pkt_dev->skb->users);
>      ret = dev_queue_xmit(pkt_dev->skb);
>
> We might have to change pktgen to make sure we do not make skb shared
> just because it was convenient.
>
> Please do not give a link to some web page that might disappear in the future.
>
> Having to follow an old thread to understand the reasoning is not appealing
> for us having to fix bugs in the following years.

Well, I don't know really.

Florian said I should remove skb_share_check() from a function I was
adding, because according to him, the ndo_start_xmit path cannot
contain shared skbs. (See the 0/9 cover letter.) If this claim is
true, then this series is correct. If this claim is not true, then the
series needs to be adjusted.

I tried to trace these and couldn't totally make up my mind, hence the
ALL CAPS mention in the 0/9.

Do you know if this is a safe presumption to make? It sounds like your
opinion is "no" in light of pktgen.c? Should that simply be adjusted
instead?

Jason
