Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF677682BB8
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231556AbjAaLpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbjAaLpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:45:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B291739
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:45:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ED1C614CD
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F9FC433D2;
        Tue, 31 Jan 2023 11:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675165514;
        bh=EXKEYvKS50cYpKk8qnKLeBR5BTH7Ki1u7X4RT7YQvb4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YUwZD9gcfTsjlu+/PLxVTdEX244osap5zyT4DcqXcuVRIfLn+frk5HZaMDct0Dlg9
         tOWUfwXYiBib1jHdyEfP+J/4UXM72jk1xohpZbtD+05j4GCyqkhyDEQAIccr58TL5u
         DDAMrQ7gqbwQ8P7wYzAfAeQunPV6S0uHlxK/D4RFGJvuCOOVgTI+mPGCsMAoCaVaEL
         49B0rDsG4BIG/jGuDAjoW1XPjRrUhngI78gFuiqmiJF0WwgNyhh8d8ZGXOEwJACYpV
         t7unPz40VDbtEj2+24PIh++Uq3ZhIFIaXApfAA+SMVNho0CO8aGk/Zsn4ukQQXcJWD
         0HoTIAnZ6I+Pg==
Date:   Tue, 31 Jan 2023 13:45:10 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yanguo Li <yanguo.li@corigine.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net] nfp: flower: avoid taking mutex in atomic context
Message-ID: <Y9j/Rvi9CSYX2qSk@unreal>
References: <20230131080313.2076060-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131080313.2076060-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 09:03:13AM +0100, Simon Horman wrote:
> From: Yanguo Li <yanguo.li@corigine.com>
> 
> A mutex may sleep, which is not permitted in atomic context.
> Avoid a case where this may arise by moving the to
> nfp_flower_lag_get_info_from_netdev() in nfp_tun_write_neigh() spinlock.
> 
> Fixes: abc210952af7 ("nfp: flower: tunnel neigh support bond offload")
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Yanguo Li <yanguo.li@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> index a8678d5612ee..060a77f2265d 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> @@ -460,6 +460,7 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
>  			    sizeof(struct nfp_tun_neigh_v4);
>  	unsigned long cookie = (unsigned long)neigh;
>  	struct nfp_flower_priv *priv = app->priv;
> +	struct nfp_tun_neigh_lag lag_info;
>  	struct nfp_neigh_entry *nn_entry;
>  	u32 port_id;
>  	u8 mtype;
> @@ -468,6 +469,11 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
>  	if (!port_id)
>  		return;
>  
> +	if ((port_id & NFP_FL_LAG_OUT) == NFP_FL_LAG_OUT) {
> +		memset(&lag_info, 0, sizeof(struct nfp_tun_neigh_lag));

This memset can be removed if you initialize lag_info to zero.
struct nfp_tun_neigh_lag lag_info = {};

Thanks

> +		nfp_flower_lag_get_info_from_netdev(app, netdev, &lag_info);
> +	}
> +
>  	spin_lock_bh(&priv->predt_lock);
>  	nn_entry = rhashtable_lookup_fast(&priv->neigh_table, &cookie,
>  					  neigh_table_params);
> @@ -515,7 +521,7 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
>  		neigh_ha_snapshot(common->dst_addr, neigh, netdev);
>  
>  		if ((port_id & NFP_FL_LAG_OUT) == NFP_FL_LAG_OUT)
> -			nfp_flower_lag_get_info_from_netdev(app, netdev, lag);
> +			memcpy(lag, &lag_info, sizeof(struct nfp_tun_neigh_lag));
>  		common->port_id = cpu_to_be32(port_id);
>  
>  		if (rhashtable_insert_fast(&priv->neigh_table,
> -- 
> 2.30.2
> 
