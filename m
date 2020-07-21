Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83FB8228834
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 20:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbgGUS2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 14:28:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbgGUS2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 14:28:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18397206E9;
        Tue, 21 Jul 2020 18:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595356079;
        bh=I6hz/u8h2Bg7VVRXYTdkA4BcNdsWgMx7Oa6CM4WmdNA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DorOR6F83mcK/IlQYhrCVop9jdyNohYY6eTSDMc/HEHPPX8eC+ZG7U9cev3raXMvx
         JLaCDiVNZupDdizg8q7ll/zGV1oerYd0cRmmHUv4Tyvn2pZqhdH9tMpnBMhl7H8RJn
         PLTZv7hoazgKPW7enN7uE8R12oMrm9a3eeSIsXNs=
Date:   Tue, 21 Jul 2020 11:27:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
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
Subject: Re: [net-next v4 13/15] iecm: Add ethtool
Message-ID: <20200721112757.4c38ea8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721003810.2770559-14-anthony.l.nguyen@intel.com>
References: <20200721003810.2770559-1-anthony.l.nguyen@intel.com>
        <20200721003810.2770559-14-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 17:38:08 -0700 Tony Nguyen wrote:
> +/**
> + * iecm_set_rxfh - set the Rx flow hash indirection table
> + * @netdev: network interface device structure
> + * @indir: indirection table
> + * @key: hash key
> + * @hfunc: hash function to use
> + *
> + * Returns -EINVAL if the table specifies an invalid queue id, otherwise
> + * returns 0 after programming the table.
> + */
> +static int iecm_set_rxfh(struct net_device *netdev, const u32 *indir,
> +			 const u8 *key, const u8 hfunc)
> +{
> +	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
> +	struct iecm_adapter *adapter;
> +	u16 *qid_list;
> +	u16 lut;
> +
> +	adapter = vport->adapter;
> +
> +	if (!iecm_is_cap_ena(adapter, VIRTCHNL_CAP_RSS)) {
> +		dev_info(&adapter->pdev->dev, "RSS is not supported on this device\n");
> +		return 0;
> +	}
> +	if (adapter->state != __IECM_UP)
> +		return 0;
> +
> +	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
> +		return -EOPNOTSUPP;
> +
> +	if (key)
> +		memcpy(adapter->rss_data.rss_key, key,
> +		       adapter->rss_data.rss_key_size);
> +
> +	qid_list = kcalloc(vport->num_rxq, sizeof(u16), GFP_KERNEL);
> +	if (!qid_list)
> +		return -ENOMEM;
> +
> +	iecm_get_rx_qid_list(vport, qid_list);
> +
> +	if (indir) {
> +		for (lut = 0; lut < adapter->rss_data.rss_lut_size; lut++) {
> +			int index = indir[lut];
> +
> +			if (index >= vport->num_rxq) {
> +				kfree(qid_list);
> +				return -EINVAL;
> +			}

Core checks this already.

> +			adapter->rss_data.rss_lut[lut] = qid_list[index];
> +		}
> +	} else {
> +		iecm_fill_dflt_rss_lut(vport, qid_list);

indir == NULL means no change, not reset.

> +	}
> +
> +	kfree(qid_list);
> +
> +	return iecm_config_rss(vport);
> +}
> +
> +/**
> + * iecm_get_channels: get the number of channels supported by the device
> + * @netdev: network interface device structure
> + * @ch: channel information structure
> + *
> + * Report maximum of TX and RX. Report one extra channel to match our mailbox
> + * Queue.
> + */
> +static void iecm_get_channels(struct net_device *netdev,
> +			      struct ethtool_channels *ch)
> +{
> +	struct iecm_vport *vport = iecm_netdev_to_vport(netdev);
> +
> +	/* Report maximum channels */
> +	ch->max_combined = IECM_MAX_Q;
> +
> +	ch->max_other = IECM_MAX_NONQ;
> +	ch->other_count = IECM_MAX_NONQ;
> +
> +	ch->combined_count = max(vport->num_txq, vport->num_rxq);

If you allow different counts of rxq and txq - the calculation is 

combined = min(rxq, txq)
rx = rxq - combined
tx = txq - combined

not very intuitive, but that's my interpretation of the API.

Can rxq != txq?

> +}

> +static void iecm_get_drvinfo(struct net_device *netdev,
> +			     struct ethtool_drvinfo *drvinfo)
> +{
> +	struct iecm_adapter *adapter = iecm_netdev_to_adapter(netdev);
> +
> +	strlcpy(drvinfo->driver, iecm_drv_name, 32);
> +	strlcpy(drvinfo->fw_version, "N/A", 4);

I think we agreed to remove this, what happened?

> +	strlcpy(drvinfo->bus_info, pci_name(adapter->pdev), 32);
> +}

