Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6501D1B9E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389689AbgEMQzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbgEMQzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 12:55:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9297520671;
        Wed, 13 May 2020 16:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589388918;
        bh=hPqtkikMV38zyz/7NxymVobbIfrw+h5td3YMP8oEhQg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wU4jeU49CYu1yhHfOsY5xToaFYuDZzjpF3Ay9L608Sch0YpMq4K9YAPXV8Wl9WKwP
         1Ifnrdjm8/iFc4jszQRawoVLiCowSF0Jybx1swhwSgwJhtBDNnQKzo0ZQd4KUdss2o
         ElaiG432O2dakTN/9eCTx8+7xVNdr3VgndPayyZY=
Date:   Wed, 13 May 2020 09:55:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH net-net] nfp: flower: inform firmware of flower features
 in the driver
Message-ID: <20200513095516.2535c778@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200513081723.17624-1-simon.horman@netronome.com>
References: <20200513081723.17624-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020 10:17:23 +0200 Simon Horman wrote:
> From: Louis Peens <louis.peens@netronome.com>
> 
> For backwards compatibility it may be required for the firmware to
> disable certain features depending on the features supported by
> the host. Combine the host feature bits and firmware feature bits
> and write this back to the firmware.
> 
> Signed-off-by: Louis Peens <louis.peens@netronome.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>

> diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
> index d8ad9346a26a..2830c1203c76 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/main.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
> @@ -665,6 +665,81 @@ static int nfp_flower_vnic_init(struct nfp_app *app, struct nfp_net *nn)
>  	return err;
>  }
>  
> +static void nfp_flower_wait_host_bit(struct nfp_app *app)
> +{
> +	unsigned long err_at;
> +	u64 feat;
> +	int err;
> +
> +	/* Wait for HOST_ACK flag bit to propagate */
> +	feat = nfp_rtsym_read_le(app->pf->rtbl,
> +				 "_abi_flower_combined_feat_global",
> +				 &err);
> +	err_at = jiffies + HZ / 100;

msecs_to_jiffies() ?


> +	while (!err && !(feat & NFP_FL_FEATS_HOST_ACK)) {
> +		usleep_range(1000, 2000);
> +		feat = nfp_rtsym_read_le(app->pf->rtbl,
> +					 "_abi_flower_combined_feat_global",
> +					 &err);
> +		if (time_is_before_eq_jiffies(err_at)) {
> +			nfp_warn(app->cpp,
> +				 "HOST_ACK bit not propagated in FW.\n");
> +			break;
> +		}

Probably could be better off with a do {} while (), but okay :)

> +	}

No warning here if reading fails (err is set) ?

> +}
> +
> +static int nfp_flower_sync_feature_bits(struct nfp_app *app)
> +{
> +	struct nfp_flower_priv *app_priv = app->priv;
> +	int err = 0;

No need to init err.

> +	/* Tell the firmware of the host supported features. */
> +	err = nfp_rtsym_write_le(app->pf->rtbl, "_abi_flower_host_mask",
> +				 app_priv->flower_ext_feats |
> +				 NFP_FL_FEATS_HOST_ACK);
> +	if (!err) {
> +		nfp_flower_wait_host_bit(app);
> +	} else if (err == -ENOENT) {
> +		nfp_info(app->cpp,
> +			 "Telling FW of host capabilities not supported.\n");

Is this really important enough for users to know?

> +		err = 0;

No need.

> +	} else {
> +		return err;
> +	}
> +
> +	/* Tell the firmware that the driver supports lag. */
> +	err = nfp_rtsym_write_le(app->pf->rtbl,
> +				 "_abi_flower_balance_sync_enable", 1);
> +	if (!err) {
> +		app_priv->flower_ext_feats |= NFP_FL_FEATS_LAG;
> +		nfp_flower_lag_init(&app_priv->nfp_lag);
> +	} else if (err == -ENOENT) {
> +		nfp_warn(app->cpp, "LAG not supported by FW.\n");
> +		err = 0;
> +	} else {
> +		return err;
> +	}
> +
> +	if (app_priv->flower_ext_feats & NFP_FL_FEATS_FLOW_MOD) {
> +		/* Tell the firmware that the driver supports flow merging. */
> +		err = nfp_rtsym_write_le(app->pf->rtbl,
> +					 "_abi_flower_merge_hint_enable", 1);
> +		if (!err) {
> +			app_priv->flower_ext_feats |= NFP_FL_FEATS_FLOW_MERGE;
> +			nfp_flower_internal_port_init(app_priv);
> +		} else if (err == -ENOENT) {
> +			nfp_warn(app->cpp,
> +				 "Flow merge not supported by FW.\n");
> +			err = 0;
> +		}

Could you just add an  else { return err; } here and..

> +	} else {
> +		nfp_warn(app->cpp, "Flow mod/merge not supported by FW.\n");
> +	}
> +
> +	return err;

.. make this return 0? Then you won't have to clear err in all the
-ENOENT branches. Someone may forget to do that one day, and we'd have
a bug.

> +}
> +
>  static int nfp_flower_init(struct nfp_app *app)
>  {
>  	u64 version, features, ctx_count, num_mems;

> diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
> index d55d0d33bc45..dfc07611603e 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/main.h
> +++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
> @@ -44,9 +44,20 @@ struct nfp_app;
>  #define NFP_FL_FEATS_FLOW_MOD		BIT(5)
>  #define NFP_FL_FEATS_PRE_TUN_RULES	BIT(6)
>  #define NFP_FL_FEATS_IPV6_TUN		BIT(7)
> +#define NFP_FL_FEATS_HOST_ACK		BIT(31)
>  #define NFP_FL_FEATS_FLOW_MERGE		BIT(30)
>  #define NFP_FL_FEATS_LAG		BIT(31)

Could we perhaps rename those two bits and use a different variable to
store them (separate patch)? Looks a little suspicious that we reuse
BIT(31) now..

> +#define NFP_FL_FEATS_HOST \
> +	(NFP_FL_FEATS_GENEVE | \
> +	NFP_FL_NBI_MTU_SETTING | \
> +	NFP_FL_FEATS_GENEVE_OPT | \
> +	NFP_FL_FEATS_VLAN_PCP | \
> +	NFP_FL_FEATS_VF_RLIM | \
> +	NFP_FL_FEATS_FLOW_MOD | \
> +	NFP_FL_FEATS_PRE_TUN_RULES | \
> +	NFP_FL_FEATS_IPV6_TUN)
> +
>  struct nfp_fl_mask_id {
>  	struct circ_buf mask_id_free_list;
>  	ktime_t *last_used;

