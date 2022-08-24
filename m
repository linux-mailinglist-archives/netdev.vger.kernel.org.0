Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F959FD82
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 16:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238818AbiHXOqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 10:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237850AbiHXOqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 10:46:34 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0BC7B7B2
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 07:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661352393; x=1692888393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HS1Fp1bGgwqC0hZtLUOqx8VKDLu7QN1Ud2w8Ro6VG20=;
  b=NAhLFZ9gjrXY+wpYYMD2ZmMF0wzu+cXYGhazJ5Z3nfCtGjqglLkopCDn
   F4sUO3ve3cmvjB88sXj6VyforHE5FQcJgVZPqL06/Z8S+xniikxmjbaMx
   UGS6fBnjvmXviA68u80yd3EIUBITKKfVOG8/rs4fepv2MY7tOfUlh98mM
   XV87GnasEDThYW8gd+4L1ic4/8YXM8CKqPJO9Uedp0uTp4Zw73nTb3dla
   oK730p+ko30VTT2GPmXUnl4+fVvRIqnZsq6gAXyRcDkmqIq3F0mylup0Y
   MDW/s9dG5UrVB3j548gnDzpkdrC5WDliDayRA759XRpLAoNb8Q4bbnEvI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="292730363"
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="292730363"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 07:46:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,260,1654585200"; 
   d="scan'208";a="609783201"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 24 Aug 2022 07:46:30 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27OEkSuw017047;
        Wed, 24 Aug 2022 15:46:28 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Maor Dickman <maord@nvidia.com>
Subject: Re: [net-next 14/15] net/mlx5: E-Switch, Move send to vport meta rule creation
Date:   Wed, 24 Aug 2022 16:43:29 +0200
Message-Id: <20220824144328.1535198-1-olek@wotan.strafe.russland>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823055533.334471-15-saeed@kernel.org>
References: <20220823055533.334471-1-saeed@kernel.org> <20220823055533.334471-15-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeed@kernel.org>
Date: Mon, 22 Aug 2022 22:55:32 -0700

> From: Roi Dayan <roid@nvidia.com>
> 
> Move the creation of the rules from offloads fdb table init to
> per rep vport init.
> This way the driver will creating the send to vport meta rule
> on any representor, e.g. SF representors.
> 
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Mark Bloch <mbloch@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en_main.c |   4 +-
>  .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  53 ++++++++-
>  .../net/ethernet/mellanox/mlx5/core/en_rep.h  |   9 +-
>  .../net/ethernet/mellanox/mlx5/core/eswitch.c |   1 -
>  .../net/ethernet/mellanox/mlx5/core/eswitch.h |   5 +-
>  .../mellanox/mlx5/core/eswitch_offloads.c     | 112 +++++-------------
>  6 files changed, 90 insertions(+), 94 deletions(-)

[...]

> +static int
> +mlx5e_rep_add_meta_tunnel_rule(struct mlx5e_priv *priv)
> +{
> +	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
> +	struct mlx5e_rep_priv *rpriv = priv->ppriv;
> +	struct mlx5_eswitch_rep *rep = rpriv->rep;
> +	struct mlx5_flow_handle *flow_rule;
> +	struct mlx5_flow_group *g;
> +	int err;
> +
> +	g = esw->fdb_table.offloads.send_to_vport_meta_grp;
> +	if (!g)
> +		return 0;
> +
> +	flow_rule = mlx5_eswitch_add_send_to_vport_meta_rule(esw, rep->vport);
> +	if (IS_ERR(flow_rule)) {
> +		err = PTR_ERR(flow_rule);
> +		goto out;
> +	}
> +
> +	rpriv->send_to_vport_meta_rule = flow_rule;
> +
> +out:
> +	return err;
> +}

On my system (LLVM, CONFIG_WERROR=y):

drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:481:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
        if (IS_ERR(flow_rule)) {
            ^~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:489:9: note: uninitialized use occurs here
        return err;
               ^~~

I believe you can just

	if (IS_ERR(flow_rule))
		return PTR_ERR(flow_rule);

	rpriv->send_to_vport_meta_rule = flow_rule;

	return 0;
}

?

> +
> +static void
> +mlx5e_rep_del_meta_tunnel_rule(struct mlx5e_priv *priv)
> +{
> +	struct mlx5e_rep_priv *rpriv = priv->ppriv;
> +
> +	if (rpriv->send_to_vport_meta_rule)
> +		mlx5_eswitch_del_send_to_vport_meta_rule(rpriv->send_to_vport_meta_rule);
> +}

[...]

> -- 
> 2.37.1

Thanks,
Olek
