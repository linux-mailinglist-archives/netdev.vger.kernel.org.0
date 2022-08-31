Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC7745A766C
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiHaGQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiHaGP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:15:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102EB40BDD
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 23:15:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B06F61738
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2F5C433C1;
        Wed, 31 Aug 2022 06:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661926555;
        bh=LKR6tz6MWsgcsnnBiVkZGtbOtyPQfx0HOt5/lSc9S1w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LYOdt7+mSqBI5inxYChrLyAUp09V9kL9glwsXjKI3qPLQGJPl42tLAuGTLm2q15b5
         mvuOMVW+Ra/QeYdog9H/lU6TQ8TCujPE59LcIclcbc+9OaNtEWlPKr8Pa2NKMefQPY
         q0rEqnQl74Qk2PiZhPoK+UYGWFAUEzvKmgDTxObD92S4lNCR4LK1YPhcXLVXlCv18U
         h9riTrfFbfNoinHEJomm9+PbWtErojBiY2Ctc4Jp24W+3sX1H1ZoInxGHE8hst86NL
         CWaGlaV5En5hhH04bFJY6BsWb3CwLfTlEMOd4pgDp0e/0FFRKcp1jf5aXl2knFzyyG
         CO/zfcYsIedxA==
Date:   Tue, 30 Aug 2022 23:15:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, alexandr.lobakin@intel.com,
        dan.carpenter@oracle.com
Subject: Re: [PATCH net-next 1/1] net/mlx5e: Fix returning uninitialized err
Message-ID: <20220830231554.19eb87b7@kernel.org>
In-Reply-To: <0a6b1f5f-e470-a747-e45d-56648860d510@nvidia.com>
References: <20220830122024.2900197-1-roid@nvidia.com>
        <0a6b1f5f-e470-a747-e45d-56648860d510@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Aug 2022 08:40:28 +0300 Roi Dayan wrote:
> On 2022-08-30 3:20 PM, Roi Dayan wrote:
> > In the cited commit the function mlx5e_rep_add_meta_tunnel_rule()
> > was added and in success flow, err was returned uninitialized.
> > Fix it.
> > 
> > Fixes: 430e2d5e2a98 ("net/mlx5: E-Switch, Move send to vport meta rule creation")
> > Reported-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> > Signed-off-by: Roi Dayan <roid@nvidia.com>
> > Reviewed-by: Maor Dickman <maord@nvidia.com>
> > ---
> >   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 10 +++-------
> >   1 file changed, 3 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > index 914bddbfc1d7..e09bca78df75 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> > @@ -471,22 +471,18 @@ mlx5e_rep_add_meta_tunnel_rule(struct mlx5e_priv *priv)
> >   	struct mlx5_eswitch_rep *rep = rpriv->rep;
> >   	struct mlx5_flow_handle *flow_rule;
> >   	struct mlx5_flow_group *g;
> > -	int err;
> >   
> >   	g = esw->fdb_table.offloads.send_to_vport_meta_grp;
> >   	if (!g)
> >   		return 0;
> >   
> >   	flow_rule = mlx5_eswitch_add_send_to_vport_meta_rule(esw, rep->vport);
> > -	if (IS_ERR(flow_rule)) {
> > -		err = PTR_ERR(flow_rule);
> > -		goto out;
> > -	}
> > +	if (IS_ERR(flow_rule))
> > +		return PTR_ERR(flow_rule);
> >   
> >   	rpriv->send_to_vport_meta_rule = flow_rule;
> >   
> > -out:
> > -	return err;
> > +	return 0;
> >   }
> >   
> >   static void  
> 
> just noticed same patch from Nathan Chancellor.
> so can ignore this one.
> 
> [PATCH net-next] net/mlx5e: Do not use err uninitialized in 
> mlx5e_rep_add_meta_tunnel_rule()

Oh, I thought Saeed will take Nathan's patch thru his tree but since
there was no reply let me take it directly..
