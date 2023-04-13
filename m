Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57B86E0C5C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 13:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjDMLWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 07:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjDMLWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 07:22:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEF183E5
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:21:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E04AF63DAE
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 11:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE145C433EF;
        Thu, 13 Apr 2023 11:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681384918;
        bh=Sap8cDalcJVSL0auW9Bh0STpOlSgjhemvl4VUNqQCqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h1yRceE6X9Y/IhCzF1SBCaIsACxz/NsFccRdmGNP47RaDjcuwCEentLZymnS/CE0k
         IYCaHiYaZaBBnIpQsWd2W6WVEPH69zG+Uxiq64VtJc2tk2YSj2o9l7JyRof61ErK8N
         VZPGvzQ+KCZBoYPXyIa7GBGeNOHNgpPySlzLNM8epuHVZCEl7OoxCwD9u5UoZGXDpG
         hICW+VXtPvaxlWRDOV4RAVI9sCRnSMd1iHBel04WUBkQqVCpo61+MEAh8IC0E4VPcl
         PVxv4E/AV196b3pv91/JIAKE4/+5w+dm1r9Zm99HsrlDtXDkHKET/8KsmNLBhBM+Kn
         zs6GTXVs+1AlA==
Date:   Thu, 13 Apr 2023 14:21:53 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next 09/10] net/mlx5e: Create IPsec table with tunnel
 support only when encap is disabled
Message-ID: <20230413112153.GK17993@unreal>
References: <cover.1681106636.git.leonro@nvidia.com>
 <ee971aa614d3264c9fe88eb77a6f61687a3ff363.1681106636.git.leonro@nvidia.com>
 <ZDQdNV+SRG6EVYlJ@corigine.com>
 <20230410164920.GU182481@unreal>
 <ZDRRBiT6umIH0rcR@corigine.com>
 <20230411124731.GY182481@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411124731.GY182481@unreal>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 03:47:31PM +0300, Leon Romanovsky wrote:
> On Mon, Apr 10, 2023 at 08:10:14PM +0200, Simon Horman wrote:
> > On Mon, Apr 10, 2023 at 07:49:20PM +0300, Leon Romanovsky wrote:
> > > On Mon, Apr 10, 2023 at 04:29:09PM +0200, Simon Horman wrote:
> > > > On Mon, Apr 10, 2023 at 09:19:11AM +0300, Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > 
> > > > > Current hardware doesn't support double encapsulation which is
> > > > > happening when IPsec packet offload tunnel mode is configured
> > > > > together with eswitch encap option.
> > > > > 
> > > > > Any user attempt to add new SA/policy after he/she sets encap mode, will
> > > > > generate the following FW syndrome:
> > > > > 
> > > > >  mlx5_core 0000:08:00.0: mlx5_cmd_out_err:803:(pid 1904): CREATE_FLOW_TABLE(0x930) op_mod(0x0) failed,
> > > > >  status bad parameter(0x3), syndrome (0xa43321), err(-22)
> > > > > 
> > > > > Make sure that we block encap changes before creating flow steering tables.
> > > > > This is applicable only for packet offload in tunnel mode, while packet
> > > > > offload in transport mode and crypto offload, don't have such limitation
> > > > > as they don't perform encapsulation.
> > > > > 
> > > > > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Hi Raed and Leon,
> > > > 
> > > > some minor feedback from me below.
> > > > 
> > > > > ---
> > > > >  .../mellanox/mlx5/core/en_accel/ipsec.c       |  7 ++++
> > > > >  .../mellanox/mlx5/core/en_accel/ipsec.h       |  1 +
> > > > >  .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 33 +++++++++++++++++--
> > > > >  3 files changed, 38 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > > > > index b64281fd4142..e95004ac7a20 100644
> > > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > > > > @@ -668,6 +668,13 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
> > > > >  	if (err)
> > > > >  		goto err_hw_ctx;
> > > > >  
> > > > > +	if (x->props.mode == XFRM_MODE_TUNNEL &&
> > > > > +	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET &&
> > > > > +	    !mlx5e_ipsec_fs_tunnel_enabled(sa_entry)) {
> > > > > +		NL_SET_ERR_MSG_MOD(extack, "Packet offload tunnel mode is disabled due to encap settings");
> > > > > +		goto err_add_rule;
> > > > 
> > > > The err_add_rule will return err.
> > > > But err is zero here.
> > > > Perhaps it should be set to an negative error code?
> > > 
> > > Thanks, I overlooked it.
> > > 
> > > > 
> > > > Flagged by Smatch as:
> > > > 
> > > > drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c:753 mlx5e_xfrm_free_state() error: we previously assumed 'sa_entry->work' could be null (see line 744)
> > > 
> > > I don't get such warnings from my CI, will try to understand why.
> > > 
> > > What are the command line arguments you use to run smatch?
> > 
> > Hi Leon,
> > 
> > I run Smatch like this:
> > 
> > .../smatch/smatch_scripts/kchecker \
> > 	drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.o
> > 
> > > What is the version of smatch?
> > 
> > I see this with Smatch 1.73.
> > 
> > 
> > In writing this email, I noticed that Smatch seems to flag
> > a problem in net-next. Which seems to be a valid concern.
> > 
> > drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c:753 mlx5e_xfrm_free_state() error: we previously assumed 'sa_entry->work' could be null (see line 744)
> 
> Thanks, I'll take a look when will return to the office.

I tried it now and still don't get this warning.

Thanks
