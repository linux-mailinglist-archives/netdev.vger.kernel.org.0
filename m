Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F391FBFBD
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 22:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731536AbgFPUL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 16:11:28 -0400
Received: from correo.us.es ([193.147.175.20]:35692 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731513AbgFPUL2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 16:11:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 134F0F2364
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 22:11:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04A70DA78A
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 22:11:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0403EDA789; Tue, 16 Jun 2020 22:11:25 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 907B0DA72F;
        Tue, 16 Jun 2020 22:11:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jun 2020 22:11:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 71D86426CCB9;
        Tue, 16 Jun 2020 22:11:22 +0200 (CEST)
Date:   Tue, 16 Jun 2020 22:11:22 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, davem@davemloft.net, vladbu@mellanox.com
Subject: Re: [PATCH net v3 1/4] flow_offload: fix incorrect cleanup for
 flowtable indirect flow_blocks
Message-ID: <20200616201122.GA26932@salvia>
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
 <1592277580-5524-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592277580-5524-2-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 11:19:37AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The cleanup operation based on the setup callback. But in the mlx5e
> driver there are tc and flowtable indrict setup callback and shared
> the same release callbacks. So when the representor is removed,
> then identify the indirect flow_blocks that need to be removed by  
> the release callback.
> 
> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c        | 2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 2 +-
>  drivers/net/ethernet/netronome/nfp/flower/main.c    | 2 +-
>  drivers/net/ethernet/netronome/nfp/flower/main.h    | 3 +--
>  drivers/net/ethernet/netronome/nfp/flower/offload.c | 6 +++---
>  include/net/flow_offload.h                          | 2 +-
>  net/core/flow_offload.c                             | 9 +++++----
>  7 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> index 0eef4f5..ef7f6bc 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
> @@ -2074,7 +2074,7 @@ void bnxt_shutdown_tc(struct bnxt *bp)
>  		return;
>  
>  	flow_indr_dev_unregister(bnxt_tc_setup_indr_cb, bp,
> -				 bnxt_tc_setup_indr_block_cb);
> +				 bnxt_tc_setup_indr_rel);
>  	rhashtable_destroy(&tc_info->flow_table);
>  	rhashtable_destroy(&tc_info->l2_table);
>  	rhashtable_destroy(&tc_info->decap_l2_table);
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> index 80713123..a62bcf0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> @@ -496,7 +496,7 @@ int mlx5e_rep_tc_netdevice_event_register(struct mlx5e_rep_priv *rpriv)
>  void mlx5e_rep_tc_netdevice_event_unregister(struct mlx5e_rep_priv *rpriv)
>  {
>  	flow_indr_dev_unregister(mlx5e_rep_indr_setup_cb, rpriv,
> -				 mlx5e_rep_indr_setup_tc_cb);
> +				 mlx5e_rep_indr_block_unbind);
>  }
>  
>  #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
> index c393276..bb448c8 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/main.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
> @@ -861,7 +861,7 @@ static void nfp_flower_clean(struct nfp_app *app)
>  	flush_work(&app_priv->cmsg_work);
>  
>  	flow_indr_dev_unregister(nfp_flower_indr_setup_tc_cb, app,
> -				 nfp_flower_setup_indr_block_cb);
> +				 nfp_flower_setup_indr_tc_release);
>  
>  	if (app_priv->flower_ext_feats & NFP_FL_FEATS_VF_RLIM)
>  		nfp_flower_qos_cleanup(app);
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
> index 6c3dc3b..c983337 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/main.h
> +++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
> @@ -460,8 +460,7 @@ int nfp_flower_setup_qos_offload(struct nfp_app *app, struct net_device *netdev,
>  void nfp_flower_stats_rlim_reply(struct nfp_app *app, struct sk_buff *skb);
>  int nfp_flower_indr_setup_tc_cb(struct net_device *netdev, void *cb_priv,
>  				enum tc_setup_type type, void *type_data);
> -int nfp_flower_setup_indr_block_cb(enum tc_setup_type type, void *type_data,
> -				   void *cb_priv);
> +void nfp_flower_setup_indr_tc_release(void *cb_priv);
>  
>  void
>  __nfp_flower_non_repr_priv_get(struct nfp_flower_non_repr_priv *non_repr_priv);
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> index 695d24b9..28de905 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
> @@ -1619,8 +1619,8 @@ struct nfp_flower_indr_block_cb_priv {
>  	return NULL;
>  }
>  
> -int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
> -				   void *type_data, void *cb_priv)
> +static int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
> +					  void *type_data, void *cb_priv)
>  {
>  	struct nfp_flower_indr_block_cb_priv *priv = cb_priv;
>  	struct flow_cls_offload *flower = type_data;
> @@ -1637,7 +1637,7 @@ int nfp_flower_setup_indr_block_cb(enum tc_setup_type type,
>  	}
>  }
>  
> -static void nfp_flower_setup_indr_tc_release(void *cb_priv)
> +void nfp_flower_setup_indr_tc_release(void *cb_priv)
>  {
>  	struct nfp_flower_indr_block_cb_priv *priv = cb_priv;
>  
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index f2c8311..3a2d6b4 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -536,7 +536,7 @@ typedef int flow_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
>  
>  int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv);
>  void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
> -			      flow_setup_cb_t *setup_cb);
> +			      void (*release)(void *cb_priv));
>  int flow_indr_dev_setup_offload(struct net_device *dev,
>  				enum tc_setup_type type, void *data,
>  				struct flow_block_offload *bo,
> diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
> index 0cfc35e..b288d2f 100644
> --- a/net/core/flow_offload.c
> +++ b/net/core/flow_offload.c
> @@ -372,13 +372,14 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
>  }
>  EXPORT_SYMBOL(flow_indr_dev_register);
>  
> -static void __flow_block_indr_cleanup(flow_setup_cb_t *setup_cb, void *cb_priv,
> +static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
> +				      void *cb_priv,
>  				      struct list_head *cleanup_list)
>  {
>  	struct flow_block_cb *this, *next;
>  
>  	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
> -		if (this->cb == setup_cb &&
> +		if (this->release == release &&
>  		    this->cb_priv == cb_priv) {
>  			list_move(&this->indr.list, cleanup_list);
>  			return;
> @@ -397,7 +398,7 @@ static void flow_block_indr_notify(struct list_head *cleanup_list)
>  }
>  
>  void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
> -			      flow_setup_cb_t *setup_cb)
> +			      void (*release)(void *cb_priv))

If you use cb_priv to identify the callback, then this should be
instead cb_ident?
