Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7BC2EF849
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 20:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbhAHTjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 14:39:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:40184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727893AbhAHTjk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 14:39:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90ECC23A79;
        Fri,  8 Jan 2021 19:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610134739;
        bh=27ig/dENc3xUl4N4X2Hk5tN9yPtwWwl+RbQTalNRqb8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DVad764+4x9XyccyElFQEwf81uXHXQgao8mIGNgIOwPVtrQ9tpSqbyrLzo78UklGF
         u8o7O9a5ILwuMA19siaxqAcvRhtoVel37NHkK9xlmGYDUFS4o1l5fRo3Xsm59ThmXU
         9bilaPVyqpWI8G5MwvqhgOZQYJWNhgNABgkbG5/dx+2DJZUsh5z09m8nuu/JCFyo5W
         UoPw0IRqn8DpGCzG/rvbc/iu6qOJP+1bXNA1yg9tA5mvNS+e9LJrtjr25nSqHofSfA
         uOmol6elX3u/JjP0KlJVqoOTiAqxYvfRVmdY4CVov4lBJqbBnikpbQDda93Sf0e7uI
         Pn0J5z1hDbuJQ==
Message-ID: <0c2b5e3ee14addfb86f023f2108bacc4e5c5652b.camel@kernel.org>
Subject: Re: [PATCH v3 net-next 10/12] net: bonding: ensure .ndo_get_stats64
 can sleep
From:   Saeed Mahameed <saeed@kernel.org>
To:     Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
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
Date:   Fri, 08 Jan 2021 11:38:57 -0800
In-Reply-To: <CANn89i+1KEyGDm-9RXpK4H6aWtn5Zmo3rgj_+zWYwFXhxm8bvg@mail.gmail.com>
References: <20210107094951.1772183-1-olteanv@gmail.com>
         <20210107094951.1772183-11-olteanv@gmail.com>
         <CANn89i+NfBw7ZpL-DTDA3QGBK=neT2R7qKYn_pcvDmRAOkaUsQ@mail.gmail.com>
         <20210107113313.q4e42cj6jigmdmbs@skbuf>
         <CANn89iJ_qbo6dP3YqXCeDPfopjBFZ8h6JxbpufVBGUpsG=D7+Q@mail.gmail.com>
         <ac66e1838894f96d2bb460b7969b6c9b903fee6a.camel@kernel.org>
         <CANn89iLm7nwckUVjoHsH-gYwQwEsscK+D2brG+NgndLZaUy_5g@mail.gmail.com>
         <20210108092125.adwhc3afwaaleoef@skbuf>
         <CANn89i+1KEyGDm-9RXpK4H6aWtn5Zmo3rgj_+zWYwFXhxm8bvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-01-08 at 10:27 +0100, Eric Dumazet wrote:
> On Fri, Jan 8, 2021 at 10:21 AM Vladimir Oltean <olteanv@gmail.com>
> wrote:
> > On Fri, Jan 08, 2021 at 10:14:01AM +0100, Eric Dumazet wrote:
> > > If you disagree, repost a rebased patch series so that we can
> > > test/compare and choose the best solution.
> > 
> > I would rather use Saeed's time as a reviewer to my existing and
> > current
> > patch set.
> 
> Yes, same feeling here, but Saeed brought back his own old
> implementation, so maybe he does not feel the same way ?

Agreed, Vladimir's work is more complete than mine, my work was just a
RFC to show the concept, it was far from being ready or testable with
some use cases such as bonding/bridge/ovs/etc...

Let me take a look at the current series, and if I see that the
rcu/dev_hold approach is more lightweight then i will suggest it to
Vladimir and he can make the final decision.






