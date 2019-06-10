Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7053B4AA
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 14:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389983AbfFJMVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 08:21:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:44724 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388952AbfFJMVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 08:21:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AF613AE9A;
        Mon, 10 Jun 2019 12:21:02 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 0AEDBE00E3; Mon, 10 Jun 2019 14:21:02 +0200 (CEST)
Date:   Mon, 10 Jun 2019 14:21:02 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     "Jubran, Samih" <sameehj@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>
Subject: Re: [PATCH V1 net-next 5/6] net: ena: add ethtool function for
 changing io queue sizes
Message-ID: <20190610122102.GD31797@unicorn.suse.cz>
References: <20190606115520.20394-1-sameehj@amazon.com>
 <20190606115520.20394-6-sameehj@amazon.com>
 <20190606144825.GB21536@unicorn.suse.cz>
 <45419c297d5241d9a7768b4d9af7d9f6@EX13D11EUB003.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45419c297d5241d9a7768b4d9af7d9f6@EX13D11EUB003.ant.amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 07:46:08AM +0000, Jubran, Samih wrote:
> > -----Original Message-----
> > From: Michal Kubecek <mkubecek@suse.cz>
> > Sent: Thursday, June 6, 2019 5:48 PM
> > To: netdev@vger.kernel.org
> > Cc: Jubran, Samih <sameehj@amazon.com>; davem@davemloft.net;
> > Woodhouse, David <dwmw@amazon.co.uk>; Machulsky, Zorik
> > <zorik@amazon.com>; Matushevsky, Alexander <matua@amazon.com>;
> > Bshara, Saeed <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>;
> > Liguori, Anthony <aliguori@amazon.com>; Bshara, Nafea
> > <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>; Belgazal,
> > Netanel <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>;
> > Herrenschmidt, Benjamin <benh@amazon.com>; Kiyanovski, Arthur
> > <akiyano@amazon.com>
> > Subject: Re: [PATCH V1 net-next 5/6] net: ena: add ethtool function for
> > changing io queue sizes
> > 
> > On Thu, Jun 06, 2019 at 02:55:19PM +0300, sameehj@amazon.com wrote:
> > > From: Sameeh Jubran <sameehj@amazon.com>
> > >
> > > Implement the set_ringparam() function of the ethtool interface to
> > > enable the changing of io queue sizes.
> > >
> > > Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> > > Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> > > ---
> > >  drivers/net/ethernet/amazon/ena/ena_ethtool.c | 25
> > > +++++++++++++++++++
> > drivers/net/ethernet/amazon/ena/ena_netdev.c  |
> > > 14 +++++++++++  drivers/net/ethernet/amazon/ena/ena_netdev.h  |  5
> > > +++-
> > >  3 files changed, 43 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > > b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > > index 101d93f16..33e28ad71 100644
> > > --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > > +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> > > @@ -495,6 +495,30 @@ static void ena_get_ringparam(struct net_device
> > *netdev,
> > >  	ring->rx_pending = adapter->rx_ring[0].ring_size;  }
> > >
> > > +static int ena_set_ringparam(struct net_device *netdev,
> > > +			     struct ethtool_ringparam *ring) {
> > > +	struct ena_adapter *adapter = netdev_priv(netdev);
> > > +	u32 new_tx_size, new_rx_size;
> > > +
> > > +	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> > > +		return -EINVAL;
> > 
> > This check is superfluous as ethtool_set_ringparam() checks supplied values
> > against maximum returned by ->get_ringparam() which will be 0 in this case.
> > 
> > > +
> > > +	new_tx_size = clamp_val(ring->tx_pending, ENA_MIN_RING_SIZE,
> > > +				adapter->max_tx_ring_size);
> > > +	new_tx_size = rounddown_pow_of_two(new_tx_size);
> > > +
> > > +	new_rx_size = clamp_val(ring->rx_pending, ENA_MIN_RING_SIZE,
> > > +				adapter->max_rx_ring_size);
> > > +	new_rx_size = rounddown_pow_of_two(new_rx_size);
> > 
> > For the same reason, clamping from below would suffice here.
> > 
> > Michal Kubecek
> > 
> > > +
> > > +	if (new_tx_size == adapter->requested_tx_ring_size &&
> > > +	    new_rx_size == adapter->requested_rx_ring_size)
> > > +		return 0;
> > > +
> > > +	return ena_update_queue_sizes(adapter, new_tx_size,
> > new_rx_size); }
> 
> You are right with both arguments the way the code is written now,
> however, in the future the code might change and we prefer to be extra
> cautious.

If we accept this logic, commit 37e2d99b59c4 ("ethtool: Ensure new ring
parameters are within bounds during SRINGPARAM") would be useless as
every driver would have to duplicate the checks anyway.

Michal Kubecek
