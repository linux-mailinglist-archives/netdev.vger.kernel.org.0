Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8DE6DDB23
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjDKMrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjDKMrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:47:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C046F2D63
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 05:47:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A42761CEA
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 12:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40391C433EF;
        Tue, 11 Apr 2023 12:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681217255;
        bh=DxcezAwFe3nKSveHy+rOWYFpKqezwqAU05kit3IxdFI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N/XTf+v0Ej2zfTskH6kLXpSV+i3GX9JftEAegTayTBVPXfjtZuFuEWrcFiUDZXQ+p
         HnCBOoffZB2mtF/Y6QdmqkW3xjbgAC7SzMJMMA0V/N5JpArDUt6JrchnI8bV5qDRTH
         x+Ac4PVGbIqsLq0jtsvl/hMUFSWIdhOunmS2frnLFoLMZmQ5HoNowqxuXxbX2+X3jK
         6jhOkxV7+9pl+HSiYJHza9MMbUSp3KVR1YPGCpRuF3+3Bn6+pNujW39ZtkIRAINuME
         0se2LJFYzwMZst18/Oa1dc9LOqu9yn5KH/G43Kx53Q7HfNgp9laJFEYNvQyssTN7MI
         WUPel38p2FMhg==
Date:   Tue, 11 Apr 2023 15:47:31 +0300
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
Message-ID: <20230411124731.GY182481@unreal>
References: <cover.1681106636.git.leonro@nvidia.com>
 <ee971aa614d3264c9fe88eb77a6f61687a3ff363.1681106636.git.leonro@nvidia.com>
 <ZDQdNV+SRG6EVYlJ@corigine.com>
 <20230410164920.GU182481@unreal>
 <ZDRRBiT6umIH0rcR@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDRRBiT6umIH0rcR@corigine.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 08:10:14PM +0200, Simon Horman wrote:
> On Mon, Apr 10, 2023 at 07:49:20PM +0300, Leon Romanovsky wrote:
> > On Mon, Apr 10, 2023 at 04:29:09PM +0200, Simon Horman wrote:
> > > On Mon, Apr 10, 2023 at 09:19:11AM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Current hardware doesn't support double encapsulation which is
> > > > happening when IPsec packet offload tunnel mode is configured
> > > > together with eswitch encap option.
> > > > 
> > > > Any user attempt to add new SA/policy after he/she sets encap mode, will
> > > > generate the following FW syndrome:
> > > > 
> > > >  mlx5_core 0000:08:00.0: mlx5_cmd_out_err:803:(pid 1904): CREATE_FLOW_TABLE(0x930) op_mod(0x0) failed,
> > > >  status bad parameter(0x3), syndrome (0xa43321), err(-22)
> > > > 
> > > > Make sure that we block encap changes before creating flow steering tables.
> > > > This is applicable only for packet offload in tunnel mode, while packet
> > > > offload in transport mode and crypto offload, don't have such limitation
> > > > as they don't perform encapsulation.
> > > > 
> > > > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Hi Raed and Leon,
> > > 
> > > some minor feedback from me below.
> > > 
> > > > ---
> > > >  .../mellanox/mlx5/core/en_accel/ipsec.c       |  7 ++++
> > > >  .../mellanox/mlx5/core/en_accel/ipsec.h       |  1 +
> > > >  .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 33 +++++++++++++++++--
> > > >  3 files changed, 38 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > > > index b64281fd4142..e95004ac7a20 100644
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > > > @@ -668,6 +668,13 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
> > > >  	if (err)
> > > >  		goto err_hw_ctx;
> > > >  
> > > > +	if (x->props.mode == XFRM_MODE_TUNNEL &&
> > > > +	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET &&
> > > > +	    !mlx5e_ipsec_fs_tunnel_enabled(sa_entry)) {
> > > > +		NL_SET_ERR_MSG_MOD(extack, "Packet offload tunnel mode is disabled due to encap settings");
> > > > +		goto err_add_rule;
> > > 
> > > The err_add_rule will return err.
> > > But err is zero here.
> > > Perhaps it should be set to an negative error code?
> > 
> > Thanks, I overlooked it.
> > 
> > > 
> > > Flagged by Smatch as:
> > > 
> > > drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c:753 mlx5e_xfrm_free_state() error: we previously assumed 'sa_entry->work' could be null (see line 744)
> > 
> > I don't get such warnings from my CI, will try to understand why.
> > 
> > What are the command line arguments you use to run smatch?
> 
> Hi Leon,
> 
> I run Smatch like this:
> 
> .../smatch/smatch_scripts/kchecker \
> 	drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.o
> 
> > What is the version of smatch?
> 
> I see this with Smatch 1.73.
> 
> 
> In writing this email, I noticed that Smatch seems to flag
> a problem in net-next. Which seems to be a valid concern.
> 
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c:753 mlx5e_xfrm_free_state() error: we previously assumed 'sa_entry->work' could be null (see line 744)

Thanks, I'll take a look when will return to the office.
