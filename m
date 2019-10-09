Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 785AED06A5
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 06:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbfJIEiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 00:38:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:34610 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbfJIEiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 00:38:00 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id x994b9XK015980;
        Tue, 8 Oct 2019 23:37:11 -0500
Message-ID: <95e215664612c0487808c02232852ef2188c95a5.camel@kernel.crashing.org>
Subject: Re: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     Joel Stanley <joel@jms.id.au>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vijay Khemka <vijaykhemka@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        linux-aspeed <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Date:   Wed, 09 Oct 2019 15:37:09 +1100
In-Reply-To: <CACPK8XcS4iKfKigPbPg0BFbmjbT-kdyjiPDXjk1k5XaS5bCdAA@mail.gmail.com>
References: <20190910213734.3112330-1-vijaykhemka@fb.com>
         <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
         <CACPK8XcS4iKfKigPbPg0BFbmjbT-kdyjiPDXjk1k5XaS5bCdAA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-09-11 at 14:48 +0000, Joel Stanley wrote:
> Hi Ben,
> 
> On Tue, 10 Sep 2019 at 22:05, Florian Fainelli <f.fainelli@gmail.com>
> wrote:
> > 
> > On 9/10/19 2:37 PM, Vijay Khemka wrote:
> > > HW checksum generation is not working for AST2500, specially with
> > > IPV6
> > > over NCSI. All TCP packets with IPv6 get dropped. By disabling
> > > this
> > > it works perfectly fine with IPV6.
> > > 
> > > Verified with IPV6 enabled and can do ssh.
> > 
> > How about IPv4, do these packets have problem? If not, can you
> > continue
> > advertising NETIF_F_IP_CSUM but take out NETIF_F_IPV6_CSUM?
> > 
> > > 
> > > Signed-off-by: Vijay Khemka <vijaykhemka@fb.com>
> > > ---
> > >  drivers/net/ethernet/faraday/ftgmac100.c | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/faraday/ftgmac100.c
> > > b/drivers/net/ethernet/faraday/ftgmac100.c
> > > index 030fed65393e..591c9725002b 100644
> > > --- a/drivers/net/ethernet/faraday/ftgmac100.c
> > > +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> > > @@ -1839,8 +1839,9 @@ static int ftgmac100_probe(struct
> > > platform_device *pdev)
> > >       if (priv->use_ncsi)
> > >               netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
> > > 
> > > -     /* AST2400  doesn't have working HW checksum generation */
> > > -     if (np && (of_device_is_compatible(np, "aspeed,ast2400-
> > > mac")))
> > > +     /* AST2400  and AST2500 doesn't have working HW checksum
> > > generation */
> > > +     if (np && (of_device_is_compatible(np, "aspeed,ast2400-
> > > mac") ||
> > > +                of_device_is_compatible(np, "aspeed,ast2500-
> > > mac")))
> 
> Do you recall under what circumstances we need to disable hardware
> checksumming?

Any news on this ? AST2400 has no HW checksum logic in HW, AST2500
should work for IPV4 fine, we should only selectively disable it for
IPV6.

Can you do an updated patch ?

Cheers,
Ben.

