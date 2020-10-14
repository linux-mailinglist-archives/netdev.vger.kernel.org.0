Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2808B28E4FD
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 19:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731436AbgJNRDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 13:03:06 -0400
Received: from mailout06.rmx.de ([94.199.90.92]:34745 "EHLO mailout06.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726517AbgJNRDG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 13:03:06 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout06.rmx.de (Postfix) with ESMTPS id 4CBJdL0RVlz9xXn;
        Wed, 14 Oct 2020 19:03:02 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CBJd31FtYz2TTMH;
        Wed, 14 Oct 2020 19:02:47 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.12) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 14 Oct
 2020 19:02:14 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net] net: dsa: ksz: fix padding size of skb
Date:   Wed, 14 Oct 2020 19:02:13 +0200
Message-ID: <3253541.RgjG7ZtOS4@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201014165410.fzvzdk3odsdjljpq@skbuf>
References: <20201014161719.30289-1-ceggers@arri.de> <20201014164750.qelb6vssiubadslj@skbuf> <20201014165410.fzvzdk3odsdjljpq@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.12]
X-RMX-ID: 20201014-190253-4CBJd31FtYz2TTMH-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Wednesday, 14 October 2020, 18:54:10 CEST, Vladimir Oltean wrote:
> On Wed, Oct 14, 2020 at 07:47:50PM +0300, Vladimir Oltean wrote:
> > On Wed, Oct 14, 2020 at 06:17:19PM +0200, Christian Eggers wrote:
> > > __skb_put_padto() is called in order to ensure a minimal size of the
> > > sk_buff. The required minimal size is ETH_ZLEN + the size required for
> > > the tail tag.
> > > 
> > > The current argument misses the size for the tail tag. The expression
> > > "skb->len + padlen" can be simplified to ETH_ZLEN.
> > > 
> > > Too small sk_buffs typically result from cloning in
> > > dsa_skb_tx_timestamp(). The cloned sk_buff may not meet the minimum size
> > > requirements.
> > > 
> > > Fixes: e71cb9e00922 ("net: dsa: ksz: fix skb freeing")
> > > Signed-off-by: Christian Eggers <ceggers@arri.de>
> > > ---
> > 
> > Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> 
> Actually no, I take that back.
> 
> This statement:
> > The expression "skb->len + padlen" can be simplified to ETH_ZLEN.
> 
> is false.
> skb->len + padlen == ETH_ZLEN only if skb->len is less than ETH_ZLEN.
ok, my comment is false.

> Otherwise, skb->len + padlen == skb->len.
> 
> Otherwise said, the frame must be padded to
> max(skb->len, ETH_ZLEN) + tail tag length.
At first I thought the same when working on this. But IMHO the padding must 
only ensure the minimum required size, there is no need to pad to the "real" 
size of the skb. The check for the tailroom above ensures that enough memory 
for the "real" size is available.

> So please keep the "skb->len + padlen + len".
> 
> Thanks,
> -Vladimir
Best regards
Christian



