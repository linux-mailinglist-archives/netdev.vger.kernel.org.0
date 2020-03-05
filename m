Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B8F179DFE
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 03:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgCECqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 21:46:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgCECqn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 21:46:43 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF5AB2084E;
        Thu,  5 Mar 2020 02:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583376402;
        bh=pcr4zuh6fquwEiLsMBl08y7uf/DXuYgwMgu2gg/uwsA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u7eOXjjLnScDu54NbqJvG+y9o9Qs1Mib8tqWdxkfGLaMrwADCd7BKxIWOvjbUz0HR
         ZjDG+4VOQAhG7p5RiCJEaxtFXS3qn/Fuu+wwadAE/Jaldd5jM04UUbIR3J2K7Ulkcg
         57Ldcsor4BYnPs9iT5RSMSB/S4CqJlz5Zwsbpu/w=
Date:   Wed, 4 Mar 2020 18:46:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Tony Nguyen <anthony.l.nguyen@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Henry Tieman <henry.w.tieman@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 05/16] ice: Add support for tunnel offloads
Message-ID: <20200304184638.12845fc7@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200304232136.4172118-6-jeffrey.t.kirsher@intel.com>
References: <20200304232136.4172118-1-jeffrey.t.kirsher@intel.com>
        <20200304232136.4172118-6-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Mar 2020 15:21:25 -0800 Jeff Kirsher wrote:
> From: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> Create a boost TCAM entry for each tunnel port in order to get a tunnel
> PTYPE. Update netdev feature flags and implement the appropriate logic to
> get and set values for hardware offloads.
> 
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

> +/**
> + * ice_create_tunnel
> + * @hw: pointer to the HW structure
> + * @type: type of tunnel
> + * @port: port to use for vxlan tunnel
> + *
> + * Creates a tunnel

I was going to comment how useless this kdoc is, then I realized that
it's not only useless but incorrect - port doesn't have to be vxlan,
you support geneve..

> + */
> +enum ice_status
> +ice_create_tunnel(struct ice_hw *hw, enum ice_tunnel_type type, u16 port)
> +{
> +	struct ice_boost_tcam_section *sect_rx, *sect_tx;
> +	enum ice_status status = ICE_ERR_MAX_LIMIT;
> +	struct ice_buf_build *bld;
> +	u16 index;
> +
> +	if (ice_tunnel_port_in_use(hw, port, NULL))
> +		return ICE_ERR_ALREADY_EXISTS;

Could you explain how ref counting of ports works? It's possible to
have multiple tunnels on the same port. Looks like this is just bailing
without even making a note of the request. So delete will just remove
the port whenever the first tunnel with this port goes down?

> +	if (!ice_find_free_tunnel_entry(hw, type, &index))
> +		return ICE_ERR_OUT_OF_RANGE;
> +
> +	bld = ice_pkg_buf_alloc(hw);
> +	if (!bld)
> +		return ICE_ERR_NO_MEMORY;
> +
> +	/* allocate 2 sections, one for Rx parser, one for Tx parser */
> +	if (ice_pkg_buf_reserve_section(bld, 2))
> +		goto ice_create_tunnel_err;
> +
> +	sect_rx = (struct ice_boost_tcam_section *)
> +		ice_pkg_buf_alloc_section(bld, ICE_SID_RXPARSER_BOOST_TCAM,

this function returns void, the extremely ugly casts are unnecessary

> +					  sizeof(*sect_rx));
> +	if (!sect_rx)
> +		goto ice_create_tunnel_err;
> +	sect_rx->count = cpu_to_le16(1);
> +
> +	sect_tx = (struct ice_boost_tcam_section *)
> +		ice_pkg_buf_alloc_section(bld, ICE_SID_TXPARSER_BOOST_TCAM,

and here

> +					  sizeof(*sect_tx));
> +	if (!sect_tx)
> +		goto ice_create_tunnel_err;
> +	sect_tx->count = cpu_to_le16(1);
> +
> +	/* copy original boost entry to update package buffer */
> +	memcpy(sect_rx->tcam, hw->tnl.tbl[index].boost_entry,
> +	       sizeof(*sect_rx->tcam));
> +
> +	/* over-write the never-match dest port key bits with the encoded port
> +	 * bits
> +	 */
> +	ice_set_key((u8 *)&sect_rx->tcam[0].key, sizeof(sect_rx->tcam[0].key),
> +		    (u8 *)&port, NULL, NULL, NULL,
> +		    offsetof(struct ice_boost_key_value, hv_dst_port_key),
> +		    sizeof(sect_rx->tcam[0].key.key.hv_dst_port_key));
> +
> +	/* exact copy of entry to Tx section entry */
> +	memcpy(sect_tx->tcam, sect_rx->tcam, sizeof(*sect_tx->tcam));
> +
> +	status = ice_update_pkg(hw, ice_pkg_buf(bld), 1);
> +	if (!status) {
> +		hw->tnl.tbl[index].port = port;
> +		hw->tnl.tbl[index].in_use = true;
> +	}
> +
> +ice_create_tunnel_err:
> +	ice_pkg_buf_free(hw, bld);
> +
> +	return status;
> +}

> +/**
> + * ice_udp_tunnel_add - Get notifications about UDP tunnel ports that come up
> + * @netdev: This physical port's netdev
> + * @ti: Tunnel endpoint information
> + */
> +static void
> +ice_udp_tunnel_add(struct net_device *netdev, struct udp_tunnel_info *ti)
> +{
> +	struct ice_netdev_priv *np = netdev_priv(netdev);
> +	struct ice_vsi *vsi = np->vsi;
> +	struct ice_pf *pf = vsi->back;
> +	enum ice_tunnel_type tnl_type;
> +	u16 port = ntohs(ti->port);
> +	enum ice_status status;
> +
> +	switch (ti->type) {
> +	case UDP_TUNNEL_TYPE_VXLAN:
> +		tnl_type = TNL_VXLAN;
> +		break;
> +	case UDP_TUNNEL_TYPE_GENEVE:
> +		tnl_type = TNL_GENEVE;
> +		break;
> +	default:
> +		netdev_err(netdev, "Unknown tunnel type\n");
> +		return;
> +	}
> +
> +	status = ice_create_tunnel(&pf->hw, tnl_type, port);
> +	if (status == ICE_ERR_ALREADY_EXISTS)
> +		dev_dbg(ice_pf_to_dev(pf), "port %d already exists in UDP tunnels list\n",
> +			port);
> +	else if (status == ICE_ERR_OUT_OF_RANGE)
> +		netdev_err(netdev, "Max tunneled UDP ports reached, port %d not added\n",
> +			   port);

error is probably a little much for resource exhaustion since it's not
going to cause any problem other than a slow down?

> +	else if (status)
> +		netdev_err(netdev, "Error adding UDP tunnel - %d\n",
> +			   status);
> +}
> +
> +/**
> + * ice_udp_tunnel_del - Get notifications about UDP tunnel ports that go away
> + * @netdev: This physical port's netdev
> + * @ti: Tunnel endpoint information
> + */
> +static void
> +ice_udp_tunnel_del(struct net_device *netdev, struct udp_tunnel_info *ti)
> +{
> +	struct ice_netdev_priv *np = netdev_priv(netdev);
> +	struct ice_vsi *vsi = np->vsi;
> +	struct ice_pf *pf = vsi->back;
> +	u16 port = ntohs(ti->port);
> +	enum ice_status status;
> +	bool retval;
> +	u16 index;
> +
> +	retval = ice_tunnel_port_in_use(&pf->hw, port, &index);

nit: index is never used

> +	if (!retval) {
> +		netdev_err(netdev, "port %d not found in UDP tunnels list\n",
> +			   port);
> +		return;
> +	}
> +
> +	status = ice_destroy_tunnel(&pf->hw, port, false);
> +	if (status)
> +		netdev_err(netdev, "error deleting port %d from UDP tunnels list\n",
> +			   port);
> +}

> @@ -5294,4 +5380,6 @@ static const struct net_device_ops ice_netdev_ops = {
>  	.ndo_bpf = ice_xdp,
>  	.ndo_xdp_xmit = ice_xdp_xmit,
>  	.ndo_xsk_wakeup = ice_xsk_wakeup,
> +	.ndo_udp_tunnel_add = ice_udp_tunnel_add,
> +	.ndo_udp_tunnel_del = ice_udp_tunnel_del,
>  };
