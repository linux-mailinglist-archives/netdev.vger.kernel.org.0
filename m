Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5752E2088
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgLWSml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:42:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbgLWSml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 13:42:41 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ks959-00DdSo-C0; Wed, 23 Dec 2020 19:41:55 +0100
Date:   Wed, 23 Dec 2020 19:41:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 1/2] net: mrp: fix definitions of MRP test packets
Message-ID: <20201223184155.GT3107610@lunn.ch>
References: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
 <20201223144533.4145-2-rasmus.villemoes@prevas.dk>
 <20201223175910.2ipmowhcn63mqtqt@soft-dev3.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223175910.2ipmowhcn63mqtqt@soft-dev3.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -96,7 +96,7 @@ struct br_mrp_ring_test_hdr {
> >         __be16 state;
> >         __be16 transitions;
> >         __be32 timestamp;
> > -};
> > +} __attribute__((__packed__));
> 
> Yes, I agree that this should be packed but it also needs to be 32 bit
> alligned, so extra 2 bytes are needed.

The full structure is:

struct br_mrp_ring_test_hdr {
	__be16 prio;	
	__u8 sa[ETH_ALEN];
	__be16 port_role;
	__be16 state;
	__be16 transitions;
	__be32 timestamp;
};

If i'm looking at this correctly, the byte offsets are:

0-1   prio
2-7   sa
8-9   port_role
10-11 state
12-13 transition

With packed you get

14-17 timestamp

which is not 32 bit aligned.

Do you mean the whole structure must be 32 bit aligned? We need to add
two reserved bytes to the end of the structure?

    Andrew
