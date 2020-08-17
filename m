Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBFA2474F9
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730635AbgHQTRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730599AbgHQPi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 11:38:27 -0400
Received: from localhost (104.sub-72-107-126.myvzw.com [72.107.126.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D7EC22C9F;
        Mon, 17 Aug 2020 15:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678706;
        bh=Gyl9MQ8xkPwfq3EZhRpFOHOqF/dyf7RLgybf/ma6nF4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Iu7VfTG+yTKDSgs3Q6nXRs9PfAM7kKQtC3Lh+8HQEOEsJffynR3M3UIJMmObTQdtE
         Sr/DPnMeMv4hJFX+WujtKzZuvIciAt8WcYtrjdrCBul+fAI00BXpo9YcqLvip8QyHv
         6ECpZ5gpQb5m9ePToklVFU/2poN/HjgU7nz/uK8w=
Date:   Mon, 17 Aug 2020 10:38:24 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 03/11] mlxsw: spectrum_policer: Add policer core
Message-ID: <20200817153824.GA1420904@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715082733.429610-4-idosch@idosch.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

You've likely seen this already, but Coverity found this problem:

  *** CID 1466147:  Control flow issues  (DEADCODE)
  /drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c: 380 in mlxsw_sp_policers_init()
  374     	}
  375     
  376     	return 0;
  377     
  378     err_family_register:
  379     	for (i--; i >= 0; i--) {
  >>>     CID 1466147:  Control flow issues  (DEADCODE)
  >>>     Execution cannot reach this statement: "struct mlxsw_sp_policer_fam...".
  380     		struct mlxsw_sp_policer_family *family;
  381     
  382     		family = mlxsw_sp->policer_core->family_arr[i];
  383     		mlxsw_sp_policer_family_unregister(mlxsw_sp, family);
  384     	}
  385     err_init:

I think the problem is that MLXSW_SP_POLICER_TYPE_MAX is 0 because

> +enum mlxsw_sp_policer_type {
> +	MLXSW_SP_POLICER_TYPE_SINGLE_RATE,
> +
> +	__MLXSW_SP_POLICER_TYPE_MAX,
> +	MLXSW_SP_POLICER_TYPE_MAX = __MLXSW_SP_POLICER_TYPE_MAX - 1,
> +};

so we can only execute the family_register loop once, with i == 0,
and if we get to err_family_register via the error exit:

> +	for (i = 0; i < MLXSW_SP_POLICER_TYPE_MAX + 1; i++) {
> +		err = mlxsw_sp_policer_family_register(mlxsw_sp, mlxsw_sp_policer_family_arr[i]);
> +		if (err)
> +			goto err_family_register;

i will be 0, so i-- sets i to -1, so we don't enter the
family_unregister loop body since -1 is not >= 0.

This code is now upstream as 8d3fbae70d8d ("mlxsw: spectrum_policer:
Add policer core").

Bjorn

On Wed, Jul 15, 2020 at 11:27:25AM +0300, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Add common code to handle all policer-related functionality in mlxsw.
> Currently, only policer for policy engines are supported, but it in the
> future more policer families will be added such as CPU (trap) policers
> and storm control policers.
> 
> The API allows different modules to add / delete policers and read their
> drop counter.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/Makefile  |   2 +-
>  .../net/ethernet/mellanox/mlxsw/spectrum.c    |  12 +
>  .../net/ethernet/mellanox/mlxsw/spectrum.h    |  32 ++
>  .../mellanox/mlxsw/spectrum_policer.c         | 403 ++++++++++++++++++
>  4 files changed, 448 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/Makefile b/drivers/net/ethernet/mellanox/mlxsw/Makefile
> index 3709983fbd77..892724380ea2 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/Makefile
> +++ b/drivers/net/ethernet/mellanox/mlxsw/Makefile
> @@ -31,7 +31,7 @@ mlxsw_spectrum-objs		:= spectrum.o spectrum_buffers.o \
>  				   spectrum_qdisc.o spectrum_span.o \
>  				   spectrum_nve.o spectrum_nve_vxlan.o \
>  				   spectrum_dpipe.o spectrum_trap.o \
> -				   spectrum_ethtool.o
> +				   spectrum_ethtool.o spectrum_policer.o
>  mlxsw_spectrum-$(CONFIG_MLXSW_SPECTRUM_DCB)	+= spectrum_dcb.o
>  mlxsw_spectrum-$(CONFIG_PTP_1588_CLOCK)		+= spectrum_ptp.o
>  obj-$(CONFIG_MLXSW_MINIMAL)	+= mlxsw_minimal.o
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
> index 4ac634bd3571..c6ab61818800 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
> @@ -2860,6 +2860,12 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
>  		goto err_fids_init;
>  	}
>  
> +	err = mlxsw_sp_policers_init(mlxsw_sp);
> +	if (err) {
> +		dev_err(mlxsw_sp->bus_info->dev, "Failed to initialize policers\n");
> +		goto err_policers_init;
> +	}
> +
>  	err = mlxsw_sp_traps_init(mlxsw_sp);
>  	if (err) {
>  		dev_err(mlxsw_sp->bus_info->dev, "Failed to set traps\n");
> @@ -3019,6 +3025,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
>  err_devlink_traps_init:
>  	mlxsw_sp_traps_fini(mlxsw_sp);
>  err_traps_init:
> +	mlxsw_sp_policers_fini(mlxsw_sp);
> +err_policers_init:
>  	mlxsw_sp_fids_fini(mlxsw_sp);
>  err_fids_init:
>  	mlxsw_sp_kvdl_fini(mlxsw_sp);
> @@ -3046,6 +3054,7 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
>  	mlxsw_sp->port_type_speed_ops = &mlxsw_sp1_port_type_speed_ops;
>  	mlxsw_sp->ptp_ops = &mlxsw_sp1_ptp_ops;
>  	mlxsw_sp->span_ops = &mlxsw_sp1_span_ops;
> +	mlxsw_sp->policer_core_ops = &mlxsw_sp1_policer_core_ops;
>  	mlxsw_sp->listeners = mlxsw_sp1_listener;
>  	mlxsw_sp->listeners_count = ARRAY_SIZE(mlxsw_sp1_listener);
>  	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP1;
> @@ -3074,6 +3083,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
>  	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
>  	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
>  	mlxsw_sp->span_ops = &mlxsw_sp2_span_ops;
> +	mlxsw_sp->policer_core_ops = &mlxsw_sp2_policer_core_ops;
>  	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP2;
>  
>  	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
> @@ -3100,6 +3110,7 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
>  	mlxsw_sp->port_type_speed_ops = &mlxsw_sp2_port_type_speed_ops;
>  	mlxsw_sp->ptp_ops = &mlxsw_sp2_ptp_ops;
>  	mlxsw_sp->span_ops = &mlxsw_sp3_span_ops;
> +	mlxsw_sp->policer_core_ops = &mlxsw_sp2_policer_core_ops;
>  	mlxsw_sp->lowest_shaper_bs = MLXSW_REG_QEEC_LOWEST_SHAPER_BS_SP3;
>  
>  	return mlxsw_sp_init(mlxsw_core, mlxsw_bus_info, extack);
> @@ -3129,6 +3140,7 @@ static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
>  	mlxsw_sp_buffers_fini(mlxsw_sp);
>  	mlxsw_sp_devlink_traps_fini(mlxsw_sp);
>  	mlxsw_sp_traps_fini(mlxsw_sp);
> +	mlxsw_sp_policers_fini(mlxsw_sp);
>  	mlxsw_sp_fids_fini(mlxsw_sp);
>  	mlxsw_sp_kvdl_fini(mlxsw_sp);
>  }
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
> index c00811178637..82227e87ef7c 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
> @@ -151,6 +151,7 @@ struct mlxsw_sp {
>  	struct mlxsw_afa *afa;
>  	struct mlxsw_sp_acl *acl;
>  	struct mlxsw_sp_fid_core *fid_core;
> +	struct mlxsw_sp_policer_core *policer_core;
>  	struct mlxsw_sp_kvdl *kvdl;
>  	struct mlxsw_sp_nve *nve;
>  	struct notifier_block netdevice_nb;
> @@ -173,6 +174,7 @@ struct mlxsw_sp {
>  	const struct mlxsw_sp_port_type_speed_ops *port_type_speed_ops;
>  	const struct mlxsw_sp_ptp_ops *ptp_ops;
>  	const struct mlxsw_sp_span_ops *span_ops;
> +	const struct mlxsw_sp_policer_core_ops *policer_core_ops;
>  	const struct mlxsw_listener *listeners;
>  	size_t listeners_count;
>  	u32 lowest_shaper_bs;
> @@ -1196,4 +1198,34 @@ extern const struct ethtool_ops mlxsw_sp_port_ethtool_ops;
>  extern const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_port_type_speed_ops;
>  extern const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_port_type_speed_ops;
>  
> +/* spectrum_policer.c */
> +extern const struct mlxsw_sp_policer_core_ops mlxsw_sp1_policer_core_ops;
> +extern const struct mlxsw_sp_policer_core_ops mlxsw_sp2_policer_core_ops;
> +
> +enum mlxsw_sp_policer_type {
> +	MLXSW_SP_POLICER_TYPE_SINGLE_RATE,
> +
> +	__MLXSW_SP_POLICER_TYPE_MAX,
> +	MLXSW_SP_POLICER_TYPE_MAX = __MLXSW_SP_POLICER_TYPE_MAX - 1,
> +};
> +
> +struct mlxsw_sp_policer_params {
> +	u64 rate;
> +	u64 burst;
> +	bool bytes;
> +};
> +
> +int mlxsw_sp_policer_add(struct mlxsw_sp *mlxsw_sp,
> +			 enum mlxsw_sp_policer_type type,
> +			 const struct mlxsw_sp_policer_params *params,
> +			 struct netlink_ext_ack *extack, u16 *p_policer_index);
> +void mlxsw_sp_policer_del(struct mlxsw_sp *mlxsw_sp,
> +			  enum mlxsw_sp_policer_type type,
> +			  u16 policer_index);
> +int mlxsw_sp_policer_drops_counter_get(struct mlxsw_sp *mlxsw_sp,
> +				       enum mlxsw_sp_policer_type type,
> +				       u16 policer_index, u64 *p_drops);
> +int mlxsw_sp_policers_init(struct mlxsw_sp *mlxsw_sp);
> +void mlxsw_sp_policers_fini(struct mlxsw_sp *mlxsw_sp);
> +
>  #endif
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c
> new file mode 100644
> index 000000000000..74766e936e0a
> --- /dev/null
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_policer.c
> @@ -0,0 +1,403 @@
> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
> +/* Copyright (c) 2020 Mellanox Technologies. All rights reserved */
> +
> +#include <linux/idr.h>
> +#include <linux/log2.h>
> +#include <linux/mutex.h>
> +#include <linux/netlink.h>
> +
> +#include "spectrum.h"
> +
> +struct mlxsw_sp_policer_family {
> +	enum mlxsw_sp_policer_type type;
> +	enum mlxsw_reg_qpcr_g qpcr_type;
> +	struct mlxsw_sp *mlxsw_sp;
> +	u16 start_index; /* Inclusive */
> +	u16 end_index; /* Exclusive */
> +	struct idr policer_idr;
> +	struct mutex lock; /* Protects policer_idr */
> +	const struct mlxsw_sp_policer_family_ops *ops;
> +};
> +
> +struct mlxsw_sp_policer {
> +	struct mlxsw_sp_policer_params params;
> +	u16 index;
> +};
> +
> +struct mlxsw_sp_policer_family_ops {
> +	int (*init)(struct mlxsw_sp_policer_family *family);
> +	void (*fini)(struct mlxsw_sp_policer_family *family);
> +	int (*policer_index_alloc)(struct mlxsw_sp_policer_family *family,
> +				   struct mlxsw_sp_policer *policer);
> +	struct mlxsw_sp_policer * (*policer_index_free)(struct mlxsw_sp_policer_family *family,
> +							u16 policer_index);
> +	int (*policer_init)(struct mlxsw_sp_policer_family *family,
> +			    const struct mlxsw_sp_policer *policer);
> +	int (*policer_params_check)(const struct mlxsw_sp_policer_family *family,
> +				    const struct mlxsw_sp_policer_params *params,
> +				    struct netlink_ext_ack *extack);
> +};
> +
> +struct mlxsw_sp_policer_core {
> +	struct mlxsw_sp_policer_family *family_arr[MLXSW_SP_POLICER_TYPE_MAX + 1];
> +	const struct mlxsw_sp_policer_core_ops *ops;
> +	u8 lowest_bs_bits;
> +	u8 highest_bs_bits;
> +};
> +
> +struct mlxsw_sp_policer_core_ops {
> +	int (*init)(struct mlxsw_sp_policer_core *policer_core);
> +};
> +
> +static u64 mlxsw_sp_policer_rate_bytes_ps_kbps(u64 rate_bytes_ps)
> +{
> +	return div_u64(rate_bytes_ps, 1000) * BITS_PER_BYTE;
> +}
> +
> +static u8 mlxsw_sp_policer_burst_bytes_hw_units(u64 burst_bytes)
> +{
> +	/* Provided burst size is in bytes. The ASIC burst size value is
> +	 * (2 ^ bs) * 512 bits. Convert the provided size to 512-bit units.
> +	 */
> +	u64 bs512 = div_u64(burst_bytes, 64);
> +
> +	if (!bs512)
> +		return 0;
> +
> +	return fls64(bs512) - 1;
> +}
> +
> +static int
> +mlxsw_sp_policer_single_rate_family_init(struct mlxsw_sp_policer_family *family)
> +{
> +	struct mlxsw_core *core = family->mlxsw_sp->core;
> +
> +	/* CPU policers are allocated from the first N policers in the global
> +	 * range, so skip them.
> +	 */
> +	if (!MLXSW_CORE_RES_VALID(core, MAX_GLOBAL_POLICERS) ||
> +	    !MLXSW_CORE_RES_VALID(core, MAX_CPU_POLICERS))
> +		return -EIO;
> +
> +	family->start_index = MLXSW_CORE_RES_GET(core, MAX_CPU_POLICERS);
> +	family->end_index = MLXSW_CORE_RES_GET(core, MAX_GLOBAL_POLICERS);
> +
> +	return 0;
> +}
> +
> +static void
> +mlxsw_sp_policer_single_rate_family_fini(struct mlxsw_sp_policer_family *family)
> +{
> +}
> +
> +static int
> +mlxsw_sp_policer_single_rate_index_alloc(struct mlxsw_sp_policer_family *family,
> +					 struct mlxsw_sp_policer *policer)
> +{
> +	int id;
> +
> +	mutex_lock(&family->lock);
> +	id = idr_alloc(&family->policer_idr, policer, family->start_index,
> +		       family->end_index, GFP_KERNEL);
> +	mutex_unlock(&family->lock);
> +
> +	if (id < 0)
> +		return id;
> +
> +	policer->index = id;
> +
> +	return 0;
> +}
> +
> +static struct mlxsw_sp_policer *
> +mlxsw_sp_policer_single_rate_index_free(struct mlxsw_sp_policer_family *family,
> +					u16 policer_index)
> +{
> +	struct mlxsw_sp_policer *policer;
> +
> +	mutex_lock(&family->lock);
> +	policer = idr_remove(&family->policer_idr, policer_index);
> +	mutex_unlock(&family->lock);
> +
> +	WARN_ON(!policer);
> +
> +	return policer;
> +}
> +
> +static int
> +mlxsw_sp_policer_single_rate_init(struct mlxsw_sp_policer_family *family,
> +				  const struct mlxsw_sp_policer *policer)
> +{
> +	u64 rate_kbps = mlxsw_sp_policer_rate_bytes_ps_kbps(policer->params.rate);
> +	u8 bs = mlxsw_sp_policer_burst_bytes_hw_units(policer->params.burst);
> +	struct mlxsw_sp *mlxsw_sp = family->mlxsw_sp;
> +	char qpcr_pl[MLXSW_REG_QPCR_LEN];
> +
> +	mlxsw_reg_qpcr_pack(qpcr_pl, policer->index, MLXSW_REG_QPCR_IR_UNITS_K,
> +			    true, rate_kbps, bs);
> +	mlxsw_reg_qpcr_clear_counter_set(qpcr_pl, true);
> +
> +	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qpcr), qpcr_pl);
> +}
> +
> +static int
> +mlxsw_sp_policer_single_rate_params_check(const struct mlxsw_sp_policer_family *family,
> +					  const struct mlxsw_sp_policer_params *params,
> +					  struct netlink_ext_ack *extack)
> +{
> +	struct mlxsw_sp_policer_core *policer_core = family->mlxsw_sp->policer_core;
> +	u64 rate_bps = params->rate * BITS_PER_BYTE;
> +	u8 bs;
> +
> +	if (!params->bytes) {
> +		NL_SET_ERR_MSG_MOD(extack, "Only bandwidth policing is currently supported by single rate policers");
> +		return -EINVAL;
> +	}
> +
> +	if (!is_power_of_2(params->burst)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size is not power of two");
> +		return -EINVAL;
> +	}
> +
> +	bs = mlxsw_sp_policer_burst_bytes_hw_units(params->burst);
> +
> +	if (bs < policer_core->lowest_bs_bits) {
> +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size lower than limit");
> +		return -EINVAL;
> +	}
> +
> +	if (bs > policer_core->highest_bs_bits) {
> +		NL_SET_ERR_MSG_MOD(extack, "Policer burst size higher than limit");
> +		return -EINVAL;
> +	}
> +
> +	if (rate_bps < MLXSW_REG_QPCR_LOWEST_CIR_BITS) {
> +		NL_SET_ERR_MSG_MOD(extack, "Policer rate lower than limit");
> +		return -EINVAL;
> +	}
> +
> +	if (rate_bps > MLXSW_REG_QPCR_HIGHEST_CIR_BITS) {
> +		NL_SET_ERR_MSG_MOD(extack, "Policer rate higher than limit");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct mlxsw_sp_policer_family_ops mlxsw_sp_policer_single_rate_ops = {
> +	.init			= mlxsw_sp_policer_single_rate_family_init,
> +	.fini			= mlxsw_sp_policer_single_rate_family_fini,
> +	.policer_index_alloc	= mlxsw_sp_policer_single_rate_index_alloc,
> +	.policer_index_free	= mlxsw_sp_policer_single_rate_index_free,
> +	.policer_init		= mlxsw_sp_policer_single_rate_init,
> +	.policer_params_check	= mlxsw_sp_policer_single_rate_params_check,
> +};
> +
> +static const struct mlxsw_sp_policer_family mlxsw_sp_policer_single_rate_family = {
> +	.type		= MLXSW_SP_POLICER_TYPE_SINGLE_RATE,
> +	.qpcr_type	= MLXSW_REG_QPCR_G_GLOBAL,
> +	.ops		= &mlxsw_sp_policer_single_rate_ops,
> +};
> +
> +static const struct mlxsw_sp_policer_family *mlxsw_sp_policer_family_arr[] = {
> +	[MLXSW_SP_POLICER_TYPE_SINGLE_RATE]	= &mlxsw_sp_policer_single_rate_family,
> +};
> +
> +int mlxsw_sp_policer_add(struct mlxsw_sp *mlxsw_sp,
> +			 enum mlxsw_sp_policer_type type,
> +			 const struct mlxsw_sp_policer_params *params,
> +			 struct netlink_ext_ack *extack, u16 *p_policer_index)
> +{
> +	struct mlxsw_sp_policer_family *family;
> +	struct mlxsw_sp_policer *policer;
> +	int err;
> +
> +	family = mlxsw_sp->policer_core->family_arr[type];
> +
> +	err = family->ops->policer_params_check(family, params, extack);
> +	if (err)
> +		return err;
> +
> +	policer = kmalloc(sizeof(*policer), GFP_KERNEL);
> +	if (!policer)
> +		return -ENOMEM;
> +	policer->params = *params;
> +
> +	err = family->ops->policer_index_alloc(family, policer);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to allocate policer index");
> +		goto err_policer_index_alloc;
> +	}
> +
> +	err = family->ops->policer_init(family, policer);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to initialize policer");
> +		goto err_policer_init;
> +	}
> +
> +	*p_policer_index = policer->index;
> +
> +	return 0;
> +
> +err_policer_init:
> +	family->ops->policer_index_free(family, policer->index);
> +err_policer_index_alloc:
> +	kfree(policer);
> +	return err;
> +}
> +
> +void mlxsw_sp_policer_del(struct mlxsw_sp *mlxsw_sp,
> +			  enum mlxsw_sp_policer_type type, u16 policer_index)
> +{
> +	struct mlxsw_sp_policer_family *family;
> +	struct mlxsw_sp_policer *policer;
> +
> +	family = mlxsw_sp->policer_core->family_arr[type];
> +	policer = family->ops->policer_index_free(family, policer_index);
> +	kfree(policer);
> +}
> +
> +int mlxsw_sp_policer_drops_counter_get(struct mlxsw_sp *mlxsw_sp,
> +				       enum mlxsw_sp_policer_type type,
> +				       u16 policer_index, u64 *p_drops)
> +{
> +	struct mlxsw_sp_policer_family *family;
> +	char qpcr_pl[MLXSW_REG_QPCR_LEN];
> +	int err;
> +
> +	family = mlxsw_sp->policer_core->family_arr[type];
> +
> +	MLXSW_REG_ZERO(qpcr, qpcr_pl);
> +	mlxsw_reg_qpcr_pid_set(qpcr_pl, policer_index);
> +	mlxsw_reg_qpcr_g_set(qpcr_pl, family->qpcr_type);
> +	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(qpcr), qpcr_pl);
> +	if (err)
> +		return err;
> +
> +	*p_drops = mlxsw_reg_qpcr_violate_count_get(qpcr_pl);
> +
> +	return 0;
> +}
> +
> +static int
> +mlxsw_sp_policer_family_register(struct mlxsw_sp *mlxsw_sp,
> +				 const struct mlxsw_sp_policer_family *tmpl)
> +{
> +	struct mlxsw_sp_policer_family *family;
> +	int err;
> +
> +	family = kmemdup(tmpl, sizeof(*family), GFP_KERNEL);
> +	if (!family)
> +		return -ENOMEM;
> +
> +	family->mlxsw_sp = mlxsw_sp;
> +	idr_init(&family->policer_idr);
> +	mutex_init(&family->lock);
> +
> +	err = family->ops->init(family);
> +	if (err)
> +		goto err_family_init;
> +
> +	if (WARN_ON(family->start_index >= family->end_index)) {
> +		err = -EINVAL;
> +		goto err_index_check;
> +	}
> +
> +	mlxsw_sp->policer_core->family_arr[tmpl->type] = family;
> +
> +	return 0;
> +
> +err_index_check:
> +	family->ops->fini(family);
> +err_family_init:
> +	mutex_destroy(&family->lock);
> +	idr_destroy(&family->policer_idr);
> +	kfree(family);
> +	return err;
> +}
> +
> +static void
> +mlxsw_sp_policer_family_unregister(struct mlxsw_sp *mlxsw_sp,
> +				   struct mlxsw_sp_policer_family *family)
> +{
> +	family->ops->fini(family);
> +	mutex_destroy(&family->lock);
> +	WARN_ON(!idr_is_empty(&family->policer_idr));
> +	idr_destroy(&family->policer_idr);
> +	kfree(family);
> +}
> +
> +int mlxsw_sp_policers_init(struct mlxsw_sp *mlxsw_sp)
> +{
> +	struct mlxsw_sp_policer_core *policer_core;
> +	int i, err;
> +
> +	policer_core = kzalloc(sizeof(*policer_core), GFP_KERNEL);
> +	if (!policer_core)
> +		return -ENOMEM;
> +	mlxsw_sp->policer_core = policer_core;
> +	policer_core->ops = mlxsw_sp->policer_core_ops;
> +
> +	err = policer_core->ops->init(policer_core);
> +	if (err)
> +		goto err_init;
> +
> +	for (i = 0; i < MLXSW_SP_POLICER_TYPE_MAX + 1; i++) {
> +		err = mlxsw_sp_policer_family_register(mlxsw_sp, mlxsw_sp_policer_family_arr[i]);
> +		if (err)
> +			goto err_family_register;
> +	}
> +
> +	return 0;
> +
> +err_family_register:
> +	for (i--; i >= 0; i--) {
> +		struct mlxsw_sp_policer_family *family;
> +
> +		family = mlxsw_sp->policer_core->family_arr[i];
> +		mlxsw_sp_policer_family_unregister(mlxsw_sp, family);
> +	}
> +err_init:
> +	kfree(mlxsw_sp->policer_core);
> +	return err;
> +}
> +
> +void mlxsw_sp_policers_fini(struct mlxsw_sp *mlxsw_sp)
> +{
> +	int i;
> +
> +	for (i = MLXSW_SP_POLICER_TYPE_MAX; i >= 0; i--) {
> +		struct mlxsw_sp_policer_family *family;
> +
> +		family = mlxsw_sp->policer_core->family_arr[i];
> +		mlxsw_sp_policer_family_unregister(mlxsw_sp, family);
> +	}
> +
> +	kfree(mlxsw_sp->policer_core);
> +}
> +
> +static int
> +mlxsw_sp1_policer_core_init(struct mlxsw_sp_policer_core *policer_core)
> +{
> +	policer_core->lowest_bs_bits = MLXSW_REG_QPCR_LOWEST_CBS_BITS_SP1;
> +	policer_core->highest_bs_bits = MLXSW_REG_QPCR_HIGHEST_CBS_BITS_SP1;
> +
> +	return 0;
> +}
> +
> +const struct mlxsw_sp_policer_core_ops mlxsw_sp1_policer_core_ops = {
> +	.init = mlxsw_sp1_policer_core_init,
> +};
> +
> +static int
> +mlxsw_sp2_policer_core_init(struct mlxsw_sp_policer_core *policer_core)
> +{
> +	policer_core->lowest_bs_bits = MLXSW_REG_QPCR_LOWEST_CBS_BITS_SP2;
> +	policer_core->highest_bs_bits = MLXSW_REG_QPCR_HIGHEST_CBS_BITS_SP2;
> +
> +	return 0;
> +}
> +
> +const struct mlxsw_sp_policer_core_ops mlxsw_sp2_policer_core_ops = {
> +	.init = mlxsw_sp2_policer_core_init,
> +};
> -- 
> 2.26.2
> 
