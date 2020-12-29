Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8A62E7243
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 17:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgL2Q0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 11:26:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43744 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726256AbgL2Q0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Dec 2020 11:26:09 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kuHoA-00Eso0-9C; Tue, 29 Dec 2020 17:25:14 +0100
Date:   Tue, 29 Dec 2020 17:25:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Cc:     Moshe Shemesh <moshe@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: Re: [PATCH net-next v2 0/2] Add support for DSFP transceiver type
Message-ID: <X+tYamjmow0MfFxz@lunn.ch>
References: <1606123198-6230-1-git-send-email-moshe@mellanox.com>
 <20201124011459.GD2031446@lunn.ch>
 <20201124131608.1b884063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <98319caa-de5f-6f5e-9c9e-ee680e5abdc0@nvidia.com>
 <20201125141822.GI2075216@lunn.ch>
 <a9835ab6-70a1-5a15-194e-977ff9c859ec@nvidia.com>
 <20201126152113.GM2073444@lunn.ch>
 <6a9bbcb0-c0c4-92fe-f3c1-581408d1e7da@nvidia.com>
 <20201127155637.GS2073444@lunn.ch>
 <0f021f89-35d4-4d99-b0b1-451f09636e58@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f021f89-35d4-4d99-b0b1-451f09636e58@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> 
> Following this conversation, I wrote some pseudocode checking if I'm on
> right path here.
> Please review:
> 
> struct eeprom_page {
>         u8 page_number;
>         u8 bank_number;
>         u16 offset;
>         u16 data_length;
>         u8 *data;
> }

I'm wondering about offset and data_length, in this context. I would
expect you always ask the kernel for the full page, not part of
it. Even when user space asks for just part of a page. That keeps you
cache management simpler. But maybe some indicator of low/high is
needed, since many pages are actually 1/2 pages?

The other thing to consider is SFF-8472 and its use of two different
i2c addresses, A0h and A2h. These are different to pages and banks.

> print_human_readable()
> {
>         spec_id = cache_get_page(0, 0, 0, 128)->data[0];
>         switch (spec_id) {
>         case sff_xxxx:
>                 print_sff_xxxx();
>         case cmis_y:
>                 print_cmis_y();
>         default:
>                 print_hex();
>         }
> }

You want to keep as much of the existing ethtool code as you can, but
the basic idea looks O.K.

> getmodule_reply_cb()
> {
>         if (offset || hex || bank_number || page number)
>                 print_hex();
>         else
>                 // if _human_readable() decoder needs more than page 00, it
> will
>                 // fetch it on demand
>                 print_human_readable();
> }

Things get interesting here. Say this is page 0, and
print_human_readable() finds a bit indicating page 1 is valid. So it
requests page 1. We go recursive. While deep down in
print_human_readable(), we send the next netlink message and call
getmodule_reply_cb() when the answer appears. I've had problems with
some of the netlink code not liking recursive calls.

So i suggest you try to find a different structure for the code. Try
to complete the netlink call before doing the decoding. So add the
page to the cache and then return. Do the decode after
nlsock_sendmsg() has returned.

> Driver
> It is required to implement get_module_eeprom_page() ndo, where it queries
> its EEPROM and copies to u8 *data array allocated by the kernel previously.
> The ndo has the following prototype:
> int get_module_eeprom_page(struct net_device *, u16 offset, u16 length,
>                            u8 page_number, u8 bank_number, u8 *data);


I would include extack here, so we can get better error messages.

  Andrew
