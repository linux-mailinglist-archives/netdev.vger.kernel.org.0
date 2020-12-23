Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5002E215D
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 21:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgLWUdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 15:33:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgLWUdA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 15:33:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC490221F5;
        Wed, 23 Dec 2020 20:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608755540;
        bh=GRufdcMrRw9KM0Idcf/RAsLpTdNgrAxQ1W0c/FTO22o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bsc2LcIALrV3+Kw4zkHjEMmA2Gms8iMeRfZSs6YD5kWsFoEVfVC9J7W13N0cu/klm
         rL3q9Wnb2yWOKCOfrc96Uj/hdmAmCWtxuUmko/9rH4ubSsUdk5yIvCmjELPbd92V42
         2gz9Pagjv6BZ8lz4rBKxicmJcCUvqfpcTy29gdZM1xO21RwDL4Mmx/tFoH0keJj/mz
         7+l91C1suGHIzssl5cDHTLuELub4WncMboG9nuUL3pG7hg5u11XL9uQv/S7Ix1a3g6
         i59sXyce566w5+/UxkZuEVNgHOJARSRJ9LBhF5y9tSRZ6z+qQciyuCytDHjZP6gtFf
         e8Wkjpn1qoOMA==
Date:   Wed, 23 Dec 2020 12:32:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: Fix memleak in ethoc_probe
Message-ID: <20201223123218.1cf7d9cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201223153304.GD3198262@lunn.ch>
References: <20201223110615.31389-1-dinghao.liu@zju.edu.cn>
        <20201223153304.GD3198262@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 16:33:04 +0100 Andrew Lunn wrote:
> On Wed, Dec 23, 2020 at 07:06:12PM +0800, Dinghao Liu wrote:
> > When mdiobus_register() fails, priv->mdio allocated
> > by mdiobus_alloc() has not been freed, which leads
> > to memleak.
> > 
> > Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>  
> 
> Fixes: bfa49cfc5262 ("net/ethoc: fix null dereference on error exit path")
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Ooof, I applied without looking at your email and I added:

Fixes: e7f4dc3536a4 ("mdio: Move allocation of interrupts into core")

I believe this is the correct Fixes tag. Before the exit patch was
freeing both MDIO and the IRQ depending on the fact that kfree(NULL) 
is fine. Am I wrong? Not that we can fix it now :)
