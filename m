Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBDE132A358
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382121AbhCBI4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:56:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1835969AbhCBGb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 01:31:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C76116186A;
        Tue,  2 Mar 2021 06:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614666645;
        bh=EPbOnkQQcY42gIMqCP33MRMRht0g1yyJCnfNd6DURw0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Vknkfdwry8Rf7wq+QHyVs59vzLyLPBJ3FNX9in5VQTfCb3VM/6nFmjzbdDSvWMTkh
         oYO94LgUveAu359jlk/l+Zr/jV8lnufS7eqHP34PR4DS+7YSvFFNlOHBXlgd/lxvxz
         2kwCJNBLbhOWqVn6t0w6sMS3uh4YPGKDt4LKhrT4VJdsyePQ/mb3xj2PpU0taGvs0j
         +S9i4V11E1Tvz7lsG6gGrHcRUCAIREE3zpR9eLrlWR+FqjMldQMGe71Hgw5p7Qxu5t
         I8QLopPfyQBmzcP7sWtiZuNZQGi4K9/bMb+Bu3K1vzwK0MNzNpiySL+gQv7rv4tPnG
         wRaAowKyT6OCA==
Message-ID: <df0c36cedb1944cd67563db56dacbee69f226463.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5e: fix mlx5e_tc_tun_update_header_ipv6 dummy
 definition
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>, Arnd Bergmann <arnd@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Eli Britstein <elibr@mellanox.com>,
        Eli Cohen <eli@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 01 Mar 2021 22:30:43 -0800
In-Reply-To: <ygnho8g3gprp.fsf@nvidia.com>
References: <20210225125501.1792072-1-arnd@kernel.org>
         <ygnho8g3gprp.fsf@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-01 at 11:57 +0200, Vlad Buslov wrote:
> On Thu 25 Feb 2021 at 14:54, Arnd Bergmann <arnd@kernel.org> wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > The alternative implementation of this function in a header file
> > is declared as a global symbol, and gets added to every .c file
> > that includes it, which leads to a link error:
> > 
> > arm-linux-gnueabi-ld:
> > drivers/net/ethernet/mellanox/mlx5/core/en_rx.o: in function
> > `mlx5e_tc_tun_update_header_ipv6':
> > en_rx.c:(.text+0x0): multiple definition of
> > `mlx5e_tc_tun_update_header_ipv6';
> > drivers/net/ethernet/mellanox/mlx5/core/en_main.o:en_main.c:(.text+
> > 0x0): first defined here
> > 
> > Mark it 'static inline' like the other functions here.
> > 
> > Fixes: c7b9038d8af6 ("net/mlx5e: TC preparation refactoring for
> > routing update event")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h | 10 ++++++---
> > -
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
> > b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
> > index 67de2bf36861..89d5ca91566e 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
> > @@ -76,10 +76,12 @@ int mlx5e_tc_tun_update_header_ipv6(struct
> > mlx5e_priv *priv,
> >  static inline int
> >  mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
> >                                 struct net_device *mirred_dev,
> > -                               struct mlx5e_encap_entry *e) {
> > return -EOPNOTSUPP; }
> > -int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
> > -                                   struct net_device *mirred_dev,
> > -                                   struct mlx5e_encap_entry *e)
> > +                               struct mlx5e_encap_entry *e)
> > +{ return -EOPNOTSUPP; }
> > +static inline int
> > +mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
> > +                               struct net_device *mirred_dev,
> > +                               struct mlx5e_encap_entry *e)
> >  { return -EOPNOTSUPP; }
> >  #endif
> >  int mlx5e_tc_tun_route_lookup(struct mlx5e_priv *priv,
> 
> Thanks Arnd!
> 
> Reviewed-by: Vlad Buslov <vladbu@nvidia.com>

Applied to net-mlx5, 

Thanks.


