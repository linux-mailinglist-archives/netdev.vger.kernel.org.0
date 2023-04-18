Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5CC66E59A9
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 08:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjDRGtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 02:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjDRGtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 02:49:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6586A4E
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 23:48:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78DAD61DE2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 06:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7671BC433EF;
        Tue, 18 Apr 2023 06:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681800510;
        bh=u3cqFh4U/u7pMKP6cilCx9p0issGtXr/UZ3OAU12VFM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CFGXFyxK/suknsjYpSboXyjjSoE+POh3+Rm54FGZnRUGJcvDO/ardE8PGKZiTo19v
         A6XUUVclwZ/l09Rk1ScfHMDwOGOWpfS+08/zaJnKp/+5jj2AreVp2rqB3ISxdCaBLd
         RBebd08n3HoOtLSZuxlUIDjq9l/Sk68bmWpikirro4pOoHCAFXgurlcmPPZQklmqI/
         bksyKhkcCh6vZoiBaiAAMsmBcEI/z2qEHbVVIYpol1tkL45ICwLyPLQNMvih4jbeqe
         OyNLIATmQV9BI684S1sKxTb7U1gU+/v7ncVNCjeBVi1tR53XKx0rKqLxJAVFWySytx
         ziiqRhoNX7XoA==
Date:   Tue, 18 Apr 2023 09:48:27 +0300
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
Message-ID: <20230418064827.GA9740@unreal>
References: <cover.1681388425.git.leonro@nvidia.com>
 <bad0c22f37a3591aa1abed4d8a8e677b92e034f5.1681388425.git.leonro@nvidia.com>
 <ZD1Ia0ZB6mbZkQEC@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD1Ia0ZB6mbZkQEC@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 03:23:55PM +0200, Simon Horman wrote:
> On Thu, Apr 13, 2023 at 03:29:24PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Extend mlx5 driver with logic to support IPsec TX packet offload
> > in tunnel mode.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

<...>

> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > @@ -271,6 +271,18 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
> >  		neigh_ha_snapshot(addr, n, netdev);
> >  		ether_addr_copy(attrs->smac, addr);
> >  		break;
> > +	case XFRM_DEV_OFFLOAD_OUT:
> > +		ether_addr_copy(attrs->smac, addr);
> > +		n = neigh_lookup(&arp_tbl, &attrs->daddr.a4, netdev);
> > +		if (!n) {
> > +			n = neigh_create(&arp_tbl, &attrs->daddr.a4, netdev);
> > +			if (IS_ERR(n))
> > +				return;
> > +			neigh_event_send(n, NULL);
> > +		}
> > +		neigh_ha_snapshot(addr, n, netdev);
> > +		ether_addr_copy(attrs->dmac, addr);
> > +		break;
> 
> I see no problem with the above code.
> However, it does seem very similar to the code for the previous case,
> XFRM_DEV_OFFLOAD_IN. Perhaps this could be refactored somehow.

Yes, it can be refactored to something like this:

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 59b9927ac90f..55b38544422f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -252,6 +252,8 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	struct net_device *netdev;
 	struct neighbour *n;
 	u8 addr[ETH_ALEN];
+	const void *pkey;
+	u8 *dst, *src;
 
 	if (attrs->mode != XFRM_MODE_TUNNEL ||
 	    attrs->type != XFRM_DEV_OFFLOAD_PACKET)
@@ -262,36 +264,31 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	mlx5_query_mac_address(mdev, addr);
 	switch (attrs->dir) {
 	case XFRM_DEV_OFFLOAD_IN:
-		ether_addr_copy(attrs->dmac, addr);
-		n = neigh_lookup(&arp_tbl, &attrs->saddr.a4, netdev);
-		if (!n) {
-			n = neigh_create(&arp_tbl, &attrs->saddr.a4, netdev);
-			if (IS_ERR(n))
-				return;
-			neigh_event_send(n, NULL);
-			attrs->drop = true;
-			break;
-		}
-		neigh_ha_snapshot(addr, n, netdev);
-		ether_addr_copy(attrs->smac, addr);
+		src = attrs->dmac;
+		dst = attrs->smac;
+		pkey = &attrs->saddr.a4;
 		break;
 	case XFRM_DEV_OFFLOAD_OUT:
-		ether_addr_copy(attrs->smac, addr);
-		n = neigh_lookup(&arp_tbl, &attrs->daddr.a4, netdev);
-		if (!n) {
-			n = neigh_create(&arp_tbl, &attrs->daddr.a4, netdev);
-			if (IS_ERR(n))
-				return;
-			neigh_event_send(n, NULL);
-			attrs->drop = true;
-			break;
-		}
-		neigh_ha_snapshot(addr, n, netdev);
-		ether_addr_copy(attrs->dmac, addr);
+		src = attrs->smac;
+		dst = attrs->dmac;
+		pkey = &attrs->daddr.a4;
 		break;
 	default:
 		return;
 	}
+
+	ether_addr_copy(src, addr);
+	n = neigh_lookup(&arp_tbl, pkey, netdev);
+	if (!n) {
+		n = neigh_create(&arp_tbl, pkey, netdev);
+		if (IS_ERR(n))
+			return;
+		neigh_event_send(n, NULL);
+		attrs->drop = true;
+	} else {
+		neigh_ha_snapshot(addr, n, netdev);
+		ether_addr_copy(dst, addr);
+	}
 	neigh_release(n);
 }
 

Thanks
