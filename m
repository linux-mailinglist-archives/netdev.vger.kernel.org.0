Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 759ABA1420
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 10:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbfH2IwL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Aug 2019 04:52:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:43426 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbfH2IwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 04:52:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0F5C2AFE8;
        Thu, 29 Aug 2019 08:52:10 +0000 (UTC)
Date:   Thu, 29 Aug 2019 10:52:09 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 06/15] net: sgi: ioc3-eth: get rid of
 ioc3_clean_rx_ring()
Message-Id: <20190829105209.0c27c3d4d1c4a2cfb622d464@suse.de>
In-Reply-To: <20190828160246.7b211f8a@cakuba.netronome.com>
References: <20190828140315.17048-1-tbogendoerfer@suse.de>
        <20190828140315.17048-7-tbogendoerfer@suse.de>
        <20190828160246.7b211f8a@cakuba.netronome.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 16:02:46 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Wed, 28 Aug 2019 16:03:05 +0200, Thomas Bogendoerfer wrote:
> > Clean rx ring is just called once after a new ring is allocated, which
> > is per definition clean. So there is not need for this function.
> > 
> > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> > ---
> >  drivers/net/ethernet/sgi/ioc3-eth.c | 21 ---------------------
> >  1 file changed, 21 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
> > index 6ca560d4ab79..39631e067b71 100644
> > --- a/drivers/net/ethernet/sgi/ioc3-eth.c
> > +++ b/drivers/net/ethernet/sgi/ioc3-eth.c
> > @@ -761,26 +761,6 @@ static void ioc3_mii_start(struct ioc3_private *ip)
> >  	add_timer(&ip->ioc3_timer);
> >  }
> >  
> > -static inline void ioc3_clean_rx_ring(struct ioc3_private *ip)
> > -{
> > -	struct ioc3_erxbuf *rxb;
> > -	struct sk_buff *skb;
> > -	int i;
> > -
> > -	for (i = ip->rx_ci; i & 15; i++) {
> > -		ip->rx_skbs[ip->rx_pi] = ip->rx_skbs[ip->rx_ci];
> > -		ip->rxr[ip->rx_pi++] = ip->rxr[ip->rx_ci++];
> > -	}
> > -	ip->rx_pi &= RX_RING_MASK;
> > -	ip->rx_ci &= RX_RING_MASK;
> > -
> > -	for (i = ip->rx_ci; i != ip->rx_pi; i = (i + 1) & RX_RING_MASK) {
> > -		skb = ip->rx_skbs[i];
> > -		rxb = (struct ioc3_erxbuf *)(skb->data - RX_OFFSET);
> > -		rxb->w0 = 0;
> 
> There's gotta be some purpose to setting this w0 word to zero no?
> ioc3_rx() uses that to see if the descriptor is done, and dutifully
> clears it after..

you are right. I thought this is already done in alloc_rx_bufs, but it isn't.
I'll add it there and put it into this patch. /me wonders why testing
didn't show this...

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 247165 (AG München)
Geschäftsführer: Felix Imendörffer
