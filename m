Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60F9F3C29DF
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 21:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbhGIT5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 15:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhGIT5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 15:57:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7ECD613BD;
        Fri,  9 Jul 2021 19:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625860471;
        bh=OJCz3BwmQw51P3Yucd33jNHKkb6R533edMplwNmsV7g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E1YeGWaeUYn91EUbu7pQ7/eUR5R/cw8lLQ/NPro/Wkv1QF5LyZycUx+lVHo2r5hmH
         5iQsesGdUaDch2IzP3j8ISLAHbK+fNz0fQ07lRtHLDCVhuowwyPW64kalIh98+/SP9
         qNmn/y2DTWdyRZtbpO8aLoCarPkksRX+WtjDXFvMRMVa9/Fbd0mNYGYtqR3jNpL+1r
         3Aq8gOcZs8Z0ZvwrqyMxd19YW3Y8t0q/hFb3+OD3VzOyUUkv3+zgCp3RmeK1Hng7K5
         +o9/2t3axNmyS0vNmN5TTlcJ6mdY2T1VAMJWNnOaEptnNU2RwU11ItEueaoclovqq0
         JMTzHo8+bv/Bg==
Date:   Fri, 9 Jul 2021 12:54:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        toke@redhat.com
Subject: Re: [RFC PATCH 1/3] veth: implement support for set_channel ethtool
 op
Message-ID: <20210709125431.3597a126@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
References: <cover.1625823139.git.pabeni@redhat.com>
        <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Jul 2021 11:39:48 +0200 Paolo Abeni wrote:
> +	/* accept changes only on rx/tx */
> +	if (ch->combined_count != min(dev->real_num_rx_queues, dev->real_num_tx_queues))
> +		return -EINVAL;

Ah damn, I must have missed the get_channels being added. I believe the
correct interpretation of the params is rx means NAPI with just Rx
queue(s), tx NAPI with just Tx queue(s) and combined has both.
IOW combined != min(rx, tx).
Instead real_rx = combined + rx; real_tx = combined + tx.
Can we still change this?

> +	/* respect contraint posed at device creation time */
> +	if (ch->rx_count > dev->num_rx_queues || ch->tx_count > dev->num_tx_queues)
> +		return -EINVAL;

Could you lift this check into ethtool core?

> +	if (!ch->rx_count || !ch->tx_count)
> +		return -EINVAL;

You wouldn't need this with the right interpretation of combined :(

> +	/* avoid braking XDP, if that is enabled */
> +	if (priv->_xdp_prog && ch->rx_count < priv->peer->real_num_tx_queues)
> +		return -EINVAL;
> +
> +	peer_priv = netdev_priv(priv->peer);
> +	if (peer_priv->_xdp_prog && ch->tx_count > priv->peer->real_num_rx_queues)
> +		return -EINVAL;
> +
> +	if (netif_running(dev))
> +		veth_close(dev);
> +
> +	priv->num_tx_queues = ch->tx_count;
> +	priv->num_rx_queues = ch->rx_count;
> +
> +	if (netif_running(dev))
> +		veth_open(dev);

