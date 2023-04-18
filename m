Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24486E5B11
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 09:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjDRH6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 03:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjDRH6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 03:58:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D26E44
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 00:58:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43B956224A
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47621C433EF;
        Tue, 18 Apr 2023 07:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681804685;
        bh=21bAb41aoI32/7Xmp0IkMLqhBFn+cLVFnnudlXzXOfU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cQTpr5W/MZJB8VRoLVEZbaRHAkG3QHQcXQ3iQoN5A79bhrJcX28/hNj7IYmwvnf+X
         rvMvs+aEHCk7vgS12kLtm/QsNCEPcXMk8FYbDiBA0av3s0Ll1iV+1jauXtCdnJpfMP
         qnGamZoyA4PfIYvFPKvnKtnDzxBg0trRprPxdQ7tKLsUP2xZUatwQ0T0/FxmPXNVnv
         +3DLorJH3fC88gGrogRSgZkp2iKGi74z3+XX/MPuXFQB7I3aX+dOu1I7clwxt+Wz4B
         +1IPbSZsXGJLuqR3H8/erIbXNmag7CCwT7aGg23WPCXHpvPqwDwYNwQAcGrsiR4/Dg
         7GQw/SMOR4NVw==
Date:   Tue, 18 Apr 2023 10:58:02 +0300
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
Subject: Re: [PATCH net-next v1 06/10] net/mlx5e: Support IPsec TX packet
 offload in tunnel mode
Message-ID: <20230418075802.GC9740@unreal>
References: <cover.1681388425.git.leonro@nvidia.com>
 <bad0c22f37a3591aa1abed4d8a8e677b92e034f5.1681388425.git.leonro@nvidia.com>
 <ZD1Ia0ZB6mbZkQEC@corigine.com>
 <20230418064827.GA9740@unreal>
 <ZD5CGQZQ2tWBeXQ1@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD5CGQZQ2tWBeXQ1@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 09:09:13AM +0200, Simon Horman wrote:
> On Tue, Apr 18, 2023 at 09:48:27AM +0300, Leon Romanovsky wrote:
> > On Mon, Apr 17, 2023 at 03:23:55PM +0200, Simon Horman wrote:
> > > On Thu, Apr 13, 2023 at 03:29:24PM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Extend mlx5 driver with logic to support IPsec TX packet offload
> > > > in tunnel mode.
> > > > 
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > 
> > <...>
> > 
> > > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > > > @@ -271,6 +271,18 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
> > > >  		neigh_ha_snapshot(addr, n, netdev);
> > > >  		ether_addr_copy(attrs->smac, addr);
> > > >  		break;
> > > > +	case XFRM_DEV_OFFLOAD_OUT:
> > > > +		ether_addr_copy(attrs->smac, addr);
> > > > +		n = neigh_lookup(&arp_tbl, &attrs->daddr.a4, netdev);
> > > > +		if (!n) {
> > > > +			n = neigh_create(&arp_tbl, &attrs->daddr.a4, netdev);
> > > > +			if (IS_ERR(n))
> > > > +				return;
> > > > +			neigh_event_send(n, NULL);
> > > > +		}
> > > > +		neigh_ha_snapshot(addr, n, netdev);
> > > > +		ether_addr_copy(attrs->dmac, addr);
> > > > +		break;
> > > 
> > > I see no problem with the above code.
> > > However, it does seem very similar to the code for the previous case,
> > > XFRM_DEV_OFFLOAD_IN. Perhaps this could be refactored somehow.
> > 
> > Yes, it can be refactored to something like this:
> 
> Thanks Leon,
> 
> this looks good to me.

Awesome, will prepare patch, test and send.

Thanks
