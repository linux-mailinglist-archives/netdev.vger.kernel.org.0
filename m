Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A761FFD48
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbgFRVRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:17:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:58282 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgFRVRa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 17:17:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BFC9CB001;
        Thu, 18 Jun 2020 21:17:26 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 47C0660389; Thu, 18 Jun 2020 23:17:26 +0200 (CEST)
Date:   Thu, 18 Jun 2020 23:17:26 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        Alice Michael <alice.michael@intel.com>, nhorman@redhat.com,
        sassmann@redhat.com, Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next 13/15] iecm: Add ethtool
Message-ID: <20200618211726.ijsafmx52ha3lamz@lion.mk-sys.cz>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
 <20200618051344.516587-14-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618051344.516587-14-jeffrey.t.kirsher@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 10:13:42PM -0700, Jeff Kirsher wrote:
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
> ---
[...]
> +static int iecm_set_channels(struct net_device *netdev,
> +			     struct ethtool_channels *ch)
> +{
> +	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
> +	int num_req_q = ch->combined_count;
> +
> +	if (num_req_q == max(vport->num_txq, vport->num_rxq))
> +		return 0;
> +
> +	/* All of these should have already been checked by ethtool before this
> +	 * even gets to us, but just to be sure.
> +	 */
> +	if (num_req_q <= 0 || num_req_q > IECM_MAX_Q)
> +		return -EINVAL;
> +
> +	if (ch->rx_count || ch->tx_count || ch->other_count != IECM_MAX_NONQ)
> +		return -EINVAL;

I don't see much sense in duplicating the checks. Having the checks in
common code allows us to simplify driver callbacks.

> +	vport->adapter->config_data.num_req_qs = num_req_q;
> +
> +	return iecm_initiate_soft_reset(vport, __IECM_SR_Q_CHANGE);
> +}
[...]
> +static int iecm_set_ringparam(struct net_device *netdev,
> +			      struct ethtool_ringparam *ring)
> +{
> +	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
> +	u32 new_rx_count, new_tx_count;
> +
> +	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
> +		return -EINVAL;
> +
> +	new_tx_count = clamp_t(u32, ring->tx_pending,
> +			       IECM_MIN_TXQ_DESC,
> +			       IECM_MAX_TXQ_DESC);
> +	new_tx_count = ALIGN(new_tx_count, IECM_REQ_DESC_MULTIPLE);
> +
> +	new_rx_count = clamp_t(u32, ring->rx_pending,
> +			       IECM_MIN_RXQ_DESC,
> +			       IECM_MAX_RXQ_DESC);
> +	new_rx_count = ALIGN(new_rx_count, IECM_REQ_DESC_MULTIPLE);

Same here. This is actually a bit misleading as it seems that count
exceeding maximum would be silently clamped to it but such value would
be rejected by common code.

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
[...]
> +/* For now we have one and only one private flag and it is only defined
> + * when we have support for the SKIP_CPU_SYNC DMA attribute.  Instead
> + * of leaving all this code sitting around empty we will strip it unless
> + * our one private flag is actually available.
> + */

The code below will always return 1 for ETH_SS_PRIV_FLAGS in
iecm_get_sset_count() and an array of one string in iecm_get_strings().
This would e.g. result in "ethtool -i" saying "supports-priv-flags: yes"
but then "ethtool --show-priv-flags" failing with -EOPNOTSUPP. IMHO you
should not return bogus string set if private flags are not implemented.

Michal

> +struct iecm_priv_flags {
> +	char flag_string[ETH_GSTRING_LEN];
> +	bool read_only;
> +	u32 flag;
> +};
> +
> +#define IECM_PRIV_FLAG(_name, _flag, _read_only) { \
> +	.read_only = _read_only, \
> +	.flag_string = _name, \
> +	.flag = _flag, \
> +}
> +
> +static const struct iecm_priv_flags iecm_gstrings_priv_flags[] = {
> +	IECM_PRIV_FLAG("", 0, 0),
> +};
> +
> +#define IECM_PRIV_FLAGS_STR_LEN ARRAY_SIZE(iecm_gstrings_priv_flags)
[...]
> +static void iecm_get_priv_flag_strings(struct net_device *netdev, u8 *data)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < IECM_PRIV_FLAGS_STR_LEN; i++) {
> +		snprintf((char *)data, ETH_GSTRING_LEN, "%s",
> +			 iecm_gstrings_priv_flags[i].flag_string);
> +		data += ETH_GSTRING_LEN;
> +	}
> +}
