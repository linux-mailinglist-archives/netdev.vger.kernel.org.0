Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADE33771B
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 16:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbfFFOs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 10:48:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:53768 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727309AbfFFOs1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 10:48:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 63012AFE1;
        Thu,  6 Jun 2019 14:48:26 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id A0B6BE00E3; Thu,  6 Jun 2019 16:48:25 +0200 (CEST)
Date:   Thu, 6 Jun 2019 16:48:25 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     sameehj@amazon.com, davem@davemloft.net, dwmw@amazon.com,
        zorik@amazon.com, matua@amazon.com, saeedb@amazon.com,
        msw@amazon.com, aliguori@amazon.com, nafea@amazon.com,
        gtzalik@amazon.com, netanel@amazon.com, alisaidi@amazon.com,
        benh@amazon.com, akiyano@amazon.com
Subject: Re: [PATCH V1 net-next 5/6] net: ena: add ethtool function for
 changing io queue sizes
Message-ID: <20190606144825.GB21536@unicorn.suse.cz>
References: <20190606115520.20394-1-sameehj@amazon.com>
 <20190606115520.20394-6-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606115520.20394-6-sameehj@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 06, 2019 at 02:55:19PM +0300, sameehj@amazon.com wrote:
> From: Sameeh Jubran <sameehj@amazon.com>
> 
> Implement the set_ringparam() function of the ethtool interface
> to enable the changing of io queue sizes.
> 
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_ethtool.c | 25 +++++++++++++++++++
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  | 14 +++++++++++
>  drivers/net/ethernet/amazon/ena/ena_netdev.h  |  5 +++-
>  3 files changed, 43 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> index 101d93f16..33e28ad71 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
> @@ -495,6 +495,30 @@ static void ena_get_ringparam(struct net_device *netdev,
>  	ring->rx_pending = adapter->rx_ring[0].ring_size;
>  }
>  
> +static int ena_set_ringparam(struct net_device *netdev,
> +			     struct ethtool_ringparam *ring)
> +{
> +	struct ena_adapter *adapter = netdev_priv(netdev);
> +	u32 new_tx_size, new_rx_size;
> +
> +	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> +		return -EINVAL;

This check is superfluous as ethtool_set_ringparam() checks supplied
values against maximum returned by ->get_ringparam() which will be 0 in
this case.

> +
> +	new_tx_size = clamp_val(ring->tx_pending, ENA_MIN_RING_SIZE,
> +				adapter->max_tx_ring_size);
> +	new_tx_size = rounddown_pow_of_two(new_tx_size);
> +
> +	new_rx_size = clamp_val(ring->rx_pending, ENA_MIN_RING_SIZE,
> +				adapter->max_rx_ring_size);
> +	new_rx_size = rounddown_pow_of_two(new_rx_size);

For the same reason, clamping from below would suffice here.

Michal Kubecek

> +
> +	if (new_tx_size == adapter->requested_tx_ring_size &&
> +	    new_rx_size == adapter->requested_rx_ring_size)
> +		return 0;
> +
> +	return ena_update_queue_sizes(adapter, new_tx_size, new_rx_size);
> +}
