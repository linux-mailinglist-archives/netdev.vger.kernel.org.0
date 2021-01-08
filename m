Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9DAB2EF82B
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 20:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbhAHTeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 14:34:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbhAHTeJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 14:34:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5487C23A9B;
        Fri,  8 Jan 2021 19:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610134409;
        bh=28TkOfMVI7Dy5cBTd2MudGl6ui5UY23rsirRRbz208g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ekgGU3A31/Z596e4haEP3OiLD4KoT/TkuwOZ1SJJ6q/31QvpMxGdcfeQTMlHQ+zMA
         Syg9PzcJ7QJMzd6r6kBWpTTxoSAq79EzqAzVcvzKDKY1aCFJSUYQN4IzwIcUSYsN9o
         0ivsQIFFCShKK2srtmHPsJCMRnLcH3JT6UfHR6orI4PdNhK+8weU3hp20u3jS/w6nX
         WgQiWrbzpf+0c3xnn/MCQkHdoAIAVnL2XH8PaP1+J15TSXByBX9or9g/OaTf0l1Oqc
         M/NvjI8/EbibZUf12J31Wseb9AYJsgCRYR9qCGTS1vGfGnjdAOH7colduMnPf+eCS6
         yzaae1C4A0MdQ==
Message-ID: <273dd2b5296531588a839d3abb765f89ee87bf43.camel@kernel.org>
Subject: Re: [PATCH v3 net-next 10/12] net: bonding: ensure .ndo_get_stats64
 can sleep
From:   Saeed Mahameed <saeed@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Date:   Fri, 08 Jan 2021 11:33:27 -0800
In-Reply-To: <CANn89iLm7nwckUVjoHsH-gYwQwEsscK+D2brG+NgndLZaUy_5g@mail.gmail.com>
References: <20210107094951.1772183-1-olteanv@gmail.com>
         <20210107094951.1772183-11-olteanv@gmail.com>
         <CANn89i+NfBw7ZpL-DTDA3QGBK=neT2R7qKYn_pcvDmRAOkaUsQ@mail.gmail.com>
         <20210107113313.q4e42cj6jigmdmbs@skbuf>
         <CANn89iJ_qbo6dP3YqXCeDPfopjBFZ8h6JxbpufVBGUpsG=D7+Q@mail.gmail.com>
         <ac66e1838894f96d2bb460b7969b6c9b903fee6a.camel@kernel.org>
         <CANn89iLm7nwckUVjoHsH-gYwQwEsscK+D2brG+NgndLZaUy_5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-01-08 at 10:14 +0100, Eric Dumazet wrote:
> On Fri, Jan 8, 2021 at 4:59 AM Saeed Mahameed <saeed@kernel.org>
> wrote:
> > Eric, about two years ago you were totally against sleeping in
> > ndo_get_stats, what happened ? :)
> > https://lore.kernel.org/netdev/4cc44e85-cb5e-502c-30f3-c6ea564fe9ac@gmail.com/
> > 
> > My approach to solve this was much simpler and didn't require  a
> > new
> > mutex nor RTNL lock, all i did is to reduce the rcu critical
> > section to
> > not include the call to the driver by simply holding the netdev via
> > dev_hold()
> > 
> 
> Yeah, and how have you dealt with bonding at that time ?
> 

I needed to get the ack on the RFC first, imagine if I'd changed the
whole stack and then got a nack :)

> Look, it seems to me Vladimir's work is more polished.
> 
> If you disagree, repost a rebased patch series so that we can
> test/compare and choose the best solution.
> 

I will need to carefully look at Vladimir's series first.

> And make sure to test it with LOCKDEP enabled ;)
> 

Indeed :)



