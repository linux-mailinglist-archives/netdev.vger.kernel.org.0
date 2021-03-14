Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF2433A50A
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 14:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbhCNNn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 09:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229870AbhCNNnc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 09:43:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A719964EE2;
        Sun, 14 Mar 2021 13:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615729412;
        bh=Swr164D6rrxhMZzAEciuPuxQV8rLfTsuyG3xXEH/9dk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HhywN1WGu/YEMDUJjVeDLSIbpsS2atWChiCVa2AE81tB5EjBfFYuKtrnzzJ2gyk6n
         Wro79rgr091TtDdyV4dWYhUXo4YpTbNU14GXjv7t2yDSmC2eUm7xZn3EjuP2KxRPRn
         9bWQjDE80ZSVmyUGCU/KKxjwvJbyoO6EFCWI2n/OyaU4ye5RGz8s2tMiS0eFh9EpoU
         ZAZKua2hQOUHvCTW1/NT5PhzMp7INgUV8wKYeUFYO8JmYTkXdMg8BRyxxmwDyvFaa1
         6Mh3FBzOevMEzn38aj34A8i1GR5v9VBoXtAUgr7D/6hvcnp0TeGXm7hxz+NS4lvj9m
         AhKaye5FdB1Mg==
Date:   Sun, 14 Mar 2021 15:43:28 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Offload bridge port flags
Message-ID: <YE4TAIf+rlczLYJw@unreal>
References: <20210314125208.17378-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210314125208.17378-1-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 01:52:08PM +0100, Kurt Kanzenbach wrote:
> The switch implements unicast and multicast filtering per port.
> Add support for it. By default filtering is disabled.
>
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> ---
>  drivers/net/dsa/hirschmann/hellcreek.c | 129 ++++++++++++++++++++-----
>  1 file changed, 104 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
> index c1f873a4fbc4..6cba02307bda 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek.c
> @@ -600,6 +600,83 @@ static void hellcreek_setup_vlan_membership(struct dsa_switch *ds, int port,
>  		hellcreek_unapply_vlan(hellcreek, upstream, vid);
>  }
>
> +static void hellcreek_port_set_ucast_flood(struct hellcreek *hellcreek,
> +					   int port, bool enable)
> +{
> +	struct hellcreek_port *hellcreek_port;
> +	u16 val;
> +
> +	hellcreek_port = &hellcreek->ports[port];
> +
> +	dev_dbg(hellcreek->dev, "%s unicast flooding on port %d\n",
> +		enable ? "Enable" : "Disable", port);
> +
> +	mutex_lock(&hellcreek->reg_lock);
> +
> +	hellcreek_select_port(hellcreek, port);
> +	val = hellcreek_port->ptcfg;
> +	if (enable)
> +		val &= ~HR_PTCFG_UUC_FLT;
> +	else
> +		val |= HR_PTCFG_UUC_FLT;
> +	hellcreek_write(hellcreek, val, HR_PTCFG);
> +	hellcreek_port->ptcfg = val;
> +
> +	mutex_unlock(&hellcreek->reg_lock);
> +}
> +
> +static void hellcreek_port_set_mcast_flood(struct hellcreek *hellcreek,
> +					   int port, bool enable)
> +{
> +	struct hellcreek_port *hellcreek_port;
> +	u16 val;
> +
> +	hellcreek_port = &hellcreek->ports[port];
> +
> +	dev_dbg(hellcreek->dev, "%s multicast flooding on port %d\n",
> +		enable ? "Enable" : "Disable", port);
> +
> +	mutex_lock(&hellcreek->reg_lock);
> +
> +	hellcreek_select_port(hellcreek, port);
> +	val = hellcreek_port->ptcfg;
> +	if (enable)
> +		val &= ~HR_PTCFG_UMC_FLT;
> +	else
> +		val |= HR_PTCFG_UMC_FLT;
> +	hellcreek_write(hellcreek, val, HR_PTCFG);
> +	hellcreek_port->ptcfg = val;
> +
> +	mutex_unlock(&hellcreek->reg_lock);
> +}
> +
> +static int hellcreek_pre_bridge_flags(struct dsa_switch *ds, int port,
> +				      struct switchdev_brport_flags flags,
> +				      struct netlink_ext_ack *extack)
> +{
> +	if (flags.mask & ~(BR_FLOOD | BR_MCAST_FLOOD))
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int hellcreek_bridge_flags(struct dsa_switch *ds, int port,
> +				  struct switchdev_brport_flags flags,
> +				  struct netlink_ext_ack *extack)
> +{
> +	struct hellcreek *hellcreek = ds->priv;
> +
> +	if (flags.mask & BR_FLOOD)
> +		hellcreek_port_set_ucast_flood(hellcreek, port,
> +					       !!(flags.val & BR_FLOOD));
> +
> +	if (flags.mask & BR_MCAST_FLOOD)
> +		hellcreek_port_set_mcast_flood(hellcreek, port,
> +					       !!(flags.val & BR_MCAST_FLOOD));
> +
> +	return 0;
> +}
> +
>  static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
>  				      struct net_device *br)
>  {
> @@ -1719,31 +1796,33 @@ static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
>  }
>
>  static const struct dsa_switch_ops hellcreek_ds_ops = {
> -	.get_ethtool_stats   = hellcreek_get_ethtool_stats,
> -	.get_sset_count	     = hellcreek_get_sset_count,
> -	.get_strings	     = hellcreek_get_strings,
> -	.get_tag_protocol    = hellcreek_get_tag_protocol,
> -	.get_ts_info	     = hellcreek_get_ts_info,
> -	.phylink_validate    = hellcreek_phylink_validate,
> -	.port_bridge_join    = hellcreek_port_bridge_join,
> -	.port_bridge_leave   = hellcreek_port_bridge_leave,
> -	.port_disable	     = hellcreek_port_disable,
> -	.port_enable	     = hellcreek_port_enable,
> -	.port_fdb_add	     = hellcreek_fdb_add,
> -	.port_fdb_del	     = hellcreek_fdb_del,
> -	.port_fdb_dump	     = hellcreek_fdb_dump,
> -	.port_hwtstamp_set   = hellcreek_port_hwtstamp_set,
> -	.port_hwtstamp_get   = hellcreek_port_hwtstamp_get,
> -	.port_prechangeupper = hellcreek_port_prechangeupper,
> -	.port_rxtstamp	     = hellcreek_port_rxtstamp,
> -	.port_setup_tc	     = hellcreek_port_setup_tc,
> -	.port_stp_state_set  = hellcreek_port_stp_state_set,
> -	.port_txtstamp	     = hellcreek_port_txtstamp,
> -	.port_vlan_add	     = hellcreek_vlan_add,
> -	.port_vlan_del	     = hellcreek_vlan_del,
> -	.port_vlan_filtering = hellcreek_vlan_filtering,
> -	.setup		     = hellcreek_setup,
> -	.teardown	     = hellcreek_teardown,
> +	.get_ethtool_stats     = hellcreek_get_ethtool_stats,
> +	.get_sset_count	       = hellcreek_get_sset_count,
> +	.get_strings	       = hellcreek_get_strings,
> +	.get_tag_protocol      = hellcreek_get_tag_protocol,
> +	.get_ts_info	       = hellcreek_get_ts_info,
> +	.phylink_validate      = hellcreek_phylink_validate,
> +	.port_bridge_flags     = hellcreek_bridge_flags,
> +	.port_bridge_join      = hellcreek_port_bridge_join,
> +	.port_bridge_leave     = hellcreek_port_bridge_leave,
> +	.port_disable	       = hellcreek_port_disable,
> +	.port_enable	       = hellcreek_port_enable,
> +	.port_fdb_add	       = hellcreek_fdb_add,
> +	.port_fdb_del	       = hellcreek_fdb_del,
> +	.port_fdb_dump	       = hellcreek_fdb_dump,
> +	.port_hwtstamp_set     = hellcreek_port_hwtstamp_set,
> +	.port_hwtstamp_get     = hellcreek_port_hwtstamp_get,
> +	.port_pre_bridge_flags = hellcreek_pre_bridge_flags,
> +	.port_prechangeupper   = hellcreek_port_prechangeupper,
> +	.port_rxtstamp	       = hellcreek_port_rxtstamp,
> +	.port_setup_tc	       = hellcreek_port_setup_tc,
> +	.port_stp_state_set    = hellcreek_port_stp_state_set,
> +	.port_txtstamp	       = hellcreek_port_txtstamp,
> +	.port_vlan_add	       = hellcreek_vlan_add,
> +	.port_vlan_del	       = hellcreek_vlan_del,
> +	.port_vlan_filtering   = hellcreek_vlan_filtering,
> +	.setup		       = hellcreek_setup,
> +	.teardown	       = hellcreek_teardown,
>  };

This patch is a perfect example why vertical space alignment is a bad thing.
Addition of one function caused to so much churn at the end.

Thanks

>
>  static int hellcreek_probe(struct platform_device *pdev)
> --
> 2.30.2
>
