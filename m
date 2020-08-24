Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE28250B0F
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 23:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgHXVo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 17:44:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:41476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHXVo7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 17:44:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E7AA8ACBF;
        Mon, 24 Aug 2020 21:45:26 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 1613160326; Mon, 24 Aug 2020 23:44:56 +0200 (CEST)
Date:   Mon, 24 Aug 2020 23:44:56 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next v5 13/15] iecm: Add ethtool
Message-ID: <20200824214456.go72ij4wfqpse7qj@lion.mk-sys.cz>
References: <20200824173306.3178343-1-anthony.l.nguyen@intel.com>
 <20200824173306.3178343-14-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824173306.3178343-14-anthony.l.nguyen@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 10:33:04AM -0700, Tony Nguyen wrote:
> From: Alice Michael <alice.michael@intel.com>
> 
> Implement ethtool interface for the common module.
> 
> Signed-off-by: Alice Michael <alice.michael@intel.com>
> Signed-off-by: Alan Brady <alan.brady@intel.com>
> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
> Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
[...]
> +static void iecm_get_channels(struct net_device *netdev,
> +			      struct ethtool_channels *ch)
> +{
> +	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
> +	unsigned int combined;
> +
> +	combined = min(vport->num_txq, vport->num_rxq);
> +
> +	/* Report maximum channels */
> +	ch->max_combined = IECM_MAX_Q;
> +
> +	ch->max_other = IECM_MAX_NONQ;
> +	ch->other_count = IECM_MAX_NONQ;
> +
> +	ch->combined_count = combined;
> +	ch->rx_count = vport->num_rxq - combined;
> +	ch->tx_count = vport->num_txq - combined;
> +}

You don't set max_rx and max_tx so that they will be always reported
as 0. If vport->num_rxq != vport->num_txq, one of rx_count, tx_count
will be higher than corresponding maximum so that any "set channels"
request not touching that value will fail the sanity check in
ethnl_set_channels() or ethtool_set_channels().

> +
> +/**
> + * iecm_set_channels: set the new channel count
> + * @netdev: network interface device structure
> + * @ch: channel information structure
> + *
> + * Negotiate a new number of channels with CP. Returns 0 on success, negative
> + * on failure.
> + */
> +static int iecm_set_channels(struct net_device *netdev,
> +			     struct ethtool_channels *ch)
> +{
> +	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
> +	int num_req_q = ch->combined_count;
> +
> +	if (num_req_q == max(vport->num_txq, vport->num_rxq))
> +		return 0;
> +
> +	vport->adapter->config_data.num_req_qs = num_req_q;
> +
> +	return iecm_initiate_soft_reset(vport, __IECM_SR_Q_CHANGE);
> +}

In iecm_get_channels() you set combined_count to minimum of num_rxq and
num_txq but here you expect it to be the maximum. And you also
completely ignore everything else than combined_count. Can this ever
work correctly if num_rxq != num_txq?

> +static int iecm_set_ringparam(struct net_device *netdev,
> +			      struct ethtool_ringparam *ring)
> +{
> +	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
> +	u32 new_rx_count, new_tx_count;
> +
> +	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> +		return -EINVAL;

This will be caught by the generic sanity check in ethnl_set_rings() or
ethtool_set_ringparam().

Michal

> +
> +	new_tx_count = ALIGN(ring->tx_pending, IECM_REQ_DESC_MULTIPLE);
> +	new_rx_count = ALIGN(ring->rx_pending, IECM_REQ_DESC_MULTIPLE);
> +
> +	/* if nothing to do return success */
> +	if (new_tx_count == vport->txq_desc_count &&
> +	    new_rx_count == vport->rxq_desc_count)
> +		return 0;
> +
> +	vport->adapter->config_data.num_req_txq_desc = new_tx_count;
> +	vport->adapter->config_data.num_req_rxq_desc = new_rx_count;
> +
> +	return iecm_initiate_soft_reset(vport, __IECM_SR_Q_DESC_CHANGE);
> +}
