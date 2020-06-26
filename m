Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713A720B94D
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 21:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbgFZT1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 15:27:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgFZT1p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 15:27:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDFE42070A;
        Fri, 26 Jun 2020 19:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593199664;
        bh=aXwiwz9qR1bOBtRd47Y5QWYlqu62vu8mjsV1GMx0LvE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xU+isBSBKo47cyDCy0GmgVcYg14YLA3UKFSsK9z2OU3nXa6ZyzmM4ynpSNeTZpg/H
         lbeUCUfNl32v9sd47W3MKCRYFqhqwVHVGSl7YBHGRpONFlbl4WAZVRMOM5u4lyoag4
         jab05mEwShD4IwXVoQiZBZYh6oAEcDXaiwtB41lU=
Date:   Fri, 26 Jun 2020 12:27:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next v3 13/15] iecm: Add ethtool
Message-ID: <20200626122742.20b47bb8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
        <20200626020737.775377-14-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 19:07:35 -0700 Jeff Kirsher wrote:
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


> +/* Helper macro to define an iecm_stat structure with proper size and type.
> + * Use this when defining constant statistics arrays. Note that @_type expects
> + * only a type name and is used multiple times.
> + */
> +#define IECM_STAT(_type, _name, _stat) { \
> +	.stat_string = _name, \
> +	.sizeof_stat = sizeof_field(_type, _stat), \
> +	.stat_offset = offsetof(_type, _stat) \
> +}
> +
> +/* Helper macro for defining some statistics related to queues */
> +#define IECM_QUEUE_STAT(_name, _stat) \
> +	IECM_STAT(struct iecm_queue, _name, _stat)
> +
> +/* Stats associated with a Tx queue */
> +static const struct iecm_stats iecm_gstrings_tx_queue_stats[] = {
> +	IECM_QUEUE_STAT("%s-%u.packets", q_stats.tx.packets),
> +	IECM_QUEUE_STAT("%s-%u.bytes", q_stats.tx.bytes),
> +};
> +
> +/* Stats associated with an Rx queue */
> +static const struct iecm_stats iecm_gstrings_rx_queue_stats[] = {
> +	IECM_QUEUE_STAT("%s-%u.packets", q_stats.rx.packets),
> +	IECM_QUEUE_STAT("%s-%u.bytes", q_stats.rx.bytes),
> +	IECM_QUEUE_STAT("%s-%u.generic_csum", q_stats.rx.generic_csum),
> +	IECM_QUEUE_STAT("%s-%u.basic_csum", q_stats.rx.basic_csum),

What's basic and generic? perhaps given them the Linux names?

> +	IECM_QUEUE_STAT("%s-%u.csum_err", q_stats.rx.csum_err),
> +	IECM_QUEUE_STAT("%s-%u.hsplit_buf_overflow", q_stats.rx.hsplit_hbo),
> +};

> +/**
> + * __iecm_set_q_coalesce - set ITR values for specific queue
> + * @ec: ethtool structure from user to update ITR settings
> + * @q: queue for which ITR values has to be set
> + *
> + * Returns 0 on success, negative otherwise.
> + */
> +static int
> +__iecm_set_q_coalesce(struct ethtool_coalesce *ec, struct iecm_queue *q)
> +{
> +	const char *q_type_str = (q->q_type == VIRTCHNL_QUEUE_TYPE_RX)
> +				  ? "Rx" : "Tx";
> +	u32 use_adaptive_coalesce, coalesce_usecs;
> +	struct iecm_vport *vport;
> +	u16 itr_setting;
> +
> +	itr_setting = IECM_ITR_SETTING(q->itr.target_itr);
> +	vport = q->vport;
> +	if (q->q_type == VIRTCHNL_QUEUE_TYPE_RX) {
> +		use_adaptive_coalesce = ec->use_adaptive_rx_coalesce;
> +		coalesce_usecs = ec->rx_coalesce_usecs;
> +	} else {
> +		use_adaptive_coalesce = ec->use_adaptive_tx_coalesce;
> +		coalesce_usecs = ec->tx_coalesce_usecs;
> +	}
> +
> +	if (itr_setting != coalesce_usecs && use_adaptive_coalesce) {
> +		netdev_info(vport->netdev, "%s ITR cannot be changed if adaptive-%s is enabled\n",
> +			    q_type_str, q_type_str);
> +		return -EINVAL;
> +	}
> +
> +	if (coalesce_usecs > IECM_ITR_MAX) {
> +		netdev_info(vport->netdev,
> +			    "Invalid value, %d-usecs range is 0-%d\n",
> +			    coalesce_usecs, IECM_ITR_MAX);
> +		return -EINVAL;
> +	}
> +
> +	/* hardware only supports an ITR granularity of 2us */
> +	if (coalesce_usecs % 2 != 0) {
> +		netdev_info(vport->netdev,
> +			    "Invalid value, %d-usecs must be even\n",
> +			    coalesce_usecs);
> +		return -EINVAL;
> +	}

Most drivers just round things up or down, but up to you.

> +	q->itr.target_itr = coalesce_usecs;
> +	if (use_adaptive_coalesce)
> +		q->itr.target_itr |= IECM_ITR_DYNAMIC;
> +	/* Update of static/dynamic ITR will be taken care when interrupt is
> +	 * fired
> +	 */
> +	return 0;
> +}
> +
> +/**
> + * iecm_set_q_coalesce - set ITR values for specific queue
> + * @vport: vport associated to the queue that need updating
> + * @ec: coalesce settings to program the device with
> + * @q_num: update ITR/INTRL (coalesce) settings for this queue number/index
> + * @is_rxq: is queue type Rx
> + *
> + * Return 0 on success, and negative on failure
> + */
> +static int
> +iecm_set_q_coalesce(struct iecm_vport *vport, struct ethtool_coalesce *ec,
> +		    int q_num, bool is_rxq)
> +{
> +	if (is_rxq) {
> +		struct iecm_queue *rxq = iecm_find_rxq(vport, q_num);
> +
> +		if (rxq && __iecm_set_q_coalesce(ec, rxq))
> +			return -EINVAL;
> +	} else {
> +		struct iecm_queue *txq = iecm_find_txq(vport, q_num);
> +
> +		if (txq && __iecm_set_q_coalesce(ec, txq))
> +			return -EINVAL;
> +	}

What's the point? Callers always call this function with tx, then rx.
Just set both.

> +	return 0;
> +}
> +
> +/**
> + * iecm_set_coalesce - set ITR values as requested by user
> + * @netdev: pointer to the netdev associated with this query
> + * @ec: coalesce settings to program the device with
> + *
> + * Return 0 on success, and negative on failure
> + */
> +static int
> +iecm_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec)
> +{
> +	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
> +	int i, err = 0;
> +
> +	if (vport->adapter->state != __IECM_UP)
> +		return 0;
> +
> +	for (i = 0; i < vport->num_txq; i++) {
> +		err = iecm_set_q_coalesce(vport, ec, i, false);
> +		if (err)
> +			goto set_coalesce_err;
> +	}
> +
> +	for (i = 0; i < vport->num_rxq; i++) {
> +		err = iecm_set_q_coalesce(vport, ec, i, true);
> +		if (err)
> +			goto set_coalesce_err;
> +	}
> +set_coalesce_err:

label is unnecessary, just return

> +	return err;
> +}
> +
> +/**
> + * iecm_set_per_q_coalesce - set ITR values as requested by user
> + * @netdev: pointer to the netdev associated with this query
> + * @q_num: queue for which the ITR values has to be set
> + * @ec: coalesce settings to program the device with
> + *
> + * Return 0 on success, and negative on failure
> + */
> +static int
> +iecm_set_per_q_coalesce(struct net_device *netdev, u32 q_num,
> +			struct ethtool_coalesce *ec)
> +{
> +	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
> +	int err;
> +
> +	if (vport->adapter->state != __IECM_UP)
> +		return 0;
> +
> +	err = iecm_set_q_coalesce(vport, ec, q_num, false);
> +	if (!err)
> +		err = iecm_set_q_coalesce(vport, ec, q_num, true);
> +
> +	return err;
> +}

> +/**
> + * iecm_get_link_ksettings - Get Link Speed and Duplex settings
> + * @netdev: network interface device structure
> + * @cmd: ethtool command
> + *
> + * Reports speed/duplex settings.
> + **/
> +static int iecm_get_link_ksettings(struct net_device *netdev,
> +				   struct ethtool_link_ksettings *cmd)
> +{
> +	struct iecm_netdev_priv *np = netdev_priv(netdev);
> +	struct iecm_adapter *adapter = np->vport->adapter;
> +
> +	ethtool_link_ksettings_zero_link_mode(cmd, supported);
> +	cmd->base.autoneg = AUTONEG_DISABLE;
> +	cmd->base.port = PORT_NONE;
> +	/* Set speed and duplex */
> +	switch (adapter->link_speed) {
> +	case VIRTCHNL_LINK_SPEED_40GB:
> +		cmd->base.speed = SPEED_40000;
> +		break;
> +	case VIRTCHNL_LINK_SPEED_25GB:
> +#ifdef SPEED_25000
> +		cmd->base.speed = SPEED_25000;
> +#else
> +		netdev_info(netdev,
> +			    "Speed is 25G, display not supported by this version of ethtool.\n");
> +#endif

Maybe drop the Intel review tags from this.

Clearly nobody looked at this patch :/

> +		break;
> +	case VIRTCHNL_LINK_SPEED_20GB:
> +		cmd->base.speed = SPEED_20000;
> +		break;
> +	case VIRTCHNL_LINK_SPEED_10GB:
> +		cmd->base.speed = SPEED_10000;
> +		break;
> +	case VIRTCHNL_LINK_SPEED_1GB:
> +		cmd->base.speed = SPEED_1000;
> +		break;
> +	case VIRTCHNL_LINK_SPEED_100MB:
> +		cmd->base.speed = SPEED_100;
> +		break;
> +	default:
> +		break;
> +	}
> +	cmd->base.duplex = DUPLEX_FULL;
> +
> +	return 0;
> +}
> +
> +/**
> + * iecm_get_drvinfo - Get driver info
> + * @netdev: network interface device structure
> + * @drvinfo: ethtool driver info structure
> + *
> + * Returns information about the driver and device for display to the user.
> + */
> +static void iecm_get_drvinfo(struct net_device *netdev,
> +			     struct ethtool_drvinfo *drvinfo)
> +{
> +	struct iecm_adapter *adapter = iecm_netdev_to_adapter(netdev);
> +
> +	strlcpy(drvinfo->driver, iecm_drv_name, 32);
> +	strlcpy(drvinfo->fw_version, "N/A", 4);

Then don't report it. 

The other two pieces of information are filled in by the core if the
callback is not set, so you can skip implementing this altogether.

> +	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev), 32);
> +}
