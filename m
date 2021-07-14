Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74AA3C91E4
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 22:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbhGNUSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 16:18:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55308 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235375AbhGNUSV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 16:18:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=altrnMbv/SB0Yb2YLSOF3NFD8ceIafb8UlwRDHdGk5c=; b=Kf2bamw41gyVk9J93clDShPKGc
        7NnRaxZ51iRZoISV69nj9kWVt4wHFdbNTM38lQmeQTWBpYsz8N9t90xMqv4e49tpq6BK1MXXpei/n
        g2+IGvtR4t5ZmqWRupR2aoiFiWwU2cOZ4zublW+95owFClINB5E8ct9TVd1EIsq+E3Oc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m3lHs-00DOVJ-87; Wed, 14 Jul 2021 22:15:20 +0200
Date:   Wed, 14 Jul 2021 22:15:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: tag_ksz: dont let the hardware process the
 layer 4 checksum
Message-ID: <YO9F2LhTizvr1l11@lunn.ch>
References: <20210714191723.31294-1-LinoSanfilippo@gmx.de>
 <20210714191723.31294-3-LinoSanfilippo@gmx.de>
 <20210714194812.stay3oqyw3ogshhj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714194812.stay3oqyw3ogshhj@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 10:48:12PM +0300, Vladimir Oltean wrote:
> Hi Lino,
> 
> On Wed, Jul 14, 2021 at 09:17:23PM +0200, Lino Sanfilippo wrote:
> > If the checksum calculation is offloaded to the network device (e.g due to
> > NETIF_F_HW_CSUM inherited from the DSA master device), the calculated
> > layer 4 checksum is incorrect. This is since the DSA tag which is placed
> > after the layer 4 data is seen as a part of the data portion and thus
> > errorneously included into the checksum calculation.
> > To avoid this, always calculate the layer 4 checksum in software.
> > 
> > Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> > ---
> 
> This needs to be solved more generically for all tail taggers. Let me
> try out a few things tomorrow and come with a proposal.

Maybe the skb_linearize() is also a generic problem, since many of the
tag drivers are using skb_put()? It looks like skb_linearize() is
cheap because checking if the skb is already linear is cheap. So maybe
we want to do it unconditionally?

      Andrew
