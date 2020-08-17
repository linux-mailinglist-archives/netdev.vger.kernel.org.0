Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1890424685D
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 16:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgHQOaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 10:30:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57184 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728669AbgHQO3z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 10:29:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7g92-009jtJ-Rp; Mon, 17 Aug 2020 16:29:52 +0200
Date:   Mon, 17 Aug 2020 16:29:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, amcohen@nvidia.com, danieller@nvidia.com,
        mlxsw@nvidia.com, roopa@nvidia.com, dsahern@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 6/6] mlxsw: spectrum_nve: Expose VXLAN
 counters via devlink-metric
Message-ID: <20200817142952.GC2291654@lunn.ch>
References: <20200817125059.193242-1-idosch@idosch.org>
 <20200817125059.193242-7-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817125059.193242-7-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mlxsw_sp1_nve_vxlan_metrics_init(struct mlxsw_sp *mlxsw_sp)
> +{
> +	struct mlxsw_sp_nve_metrics *metrics = &mlxsw_sp->nve->metrics;
> +	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
> +	int err;
> +
> +	err = mlxsw_sp1_nve_vxlan_counters_clear(mlxsw_sp);
> +	if (err)
> +		return err;
> +
> +	metrics->counter_encap =
> +		devlink_metric_counter_create(devlink, "nve_vxlan_encap",
> +					      &mlxsw_sp1_nve_vxlan_encap_ops,
> +					      mlxsw_sp);
> +	if (IS_ERR(metrics->counter_encap))
> +		return PTR_ERR(metrics->counter_encap);
> +
> +	metrics->counter_decap =
> +		devlink_metric_counter_create(devlink, "nve_vxlan_decap",
> +					      &mlxsw_sp1_nve_vxlan_decap_ops,
> +					      mlxsw_sp);
> +	if (IS_ERR(metrics->counter_decap)) {
> +		err = PTR_ERR(metrics->counter_decap);
> +		goto err_counter_decap;
> +	}
> +
> +	metrics->counter_decap_errors =
> +		devlink_metric_counter_create(devlink, "nve_vxlan_decap_errors",
> +					      &mlxsw_sp1_nve_vxlan_decap_errors_ops,
> +					      mlxsw_sp);
> +	if (IS_ERR(metrics->counter_decap_errors)) {
> +		err = PTR_ERR(metrics->counter_decap_errors);
> +		goto err_counter_decap_errors;
> +	}
> +
> +	metrics->counter_decap_discards =
> +		devlink_metric_counter_create(devlink, "nve_vxlan_decap_discards",
> +					      &mlxsw_sp1_nve_vxlan_decap_discards_ops,
> +					      mlxsw_sp);
> +	if (IS_ERR(metrics->counter_decap_discards)) {
> +		err = PTR_ERR(metrics->counter_decap_discards);
> +		goto err_counter_decap_discards;
> +	}
> +
> +	return 0;

Looking at this, i wonder about the scalability of this API. With just
4 counters it looks pretty ugly. What about 50 counters?

Maybe move the name into the ops structure. Then add a call
devlink_metric_counters_create() where you can pass an array and array
size of op structures? There are plenty of other examples in the
kernel, e.g. sysfs groups, hwmon, etc. where you register a large
bunch of things with the core with a single call.

> +static void mlxsw_sp1_nve_vxlan_metrics_fini(struct mlxsw_sp *mlxsw_sp)
> +{
> +	struct mlxsw_sp_nve_metrics *metrics = &mlxsw_sp->nve->metrics;
> +	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
> +
> +	devlink_metric_destroy(devlink, metrics->counter_decap_discards);
> +	devlink_metric_destroy(devlink, metrics->counter_decap_errors);
> +	devlink_metric_destroy(devlink, metrics->counter_decap);
> +	devlink_metric_destroy(devlink, metrics->counter_encap);
> +}

I guess the most frequent use case is to remove all counters,
e.g. driver unload, or when probe fails. So maybe provide a
devlink_metric_destroy_all(devlink) ?

    Andrew
