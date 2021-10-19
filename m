Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E13433EF8
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 21:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhJSTJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 15:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhJSTJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 15:09:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B9D36128B;
        Tue, 19 Oct 2021 19:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634670415;
        bh=AXSOkY7Mcf7e8JYLN4hVaBs7Lp9bwvDRFybLH77JABA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=onAcnHjpFPVGjsIIlUEbPv72fc1H6A+wfqosFMSCH0mmWJzaJLigqAFBuB1A5GkQk
         Qsjo3Y+vSRZBkBxVNRDi9MK7aqcU292AwSVftd7hmWafiWIvOn74O4Pga86Rb1DTXJ
         0lA9MFJ+LXfrjtDNSzuV7dNSDs9MKvFEZQUoZrT9U2u3w2BTeHDXRsdupjKMGkXNPY
         KiAR+Z1h+MSj4jgUvcOK2NHLnmkqpxwLtcgXwFlQ7JB64aIgrOTrWTH1yDkvqP/Jui
         YfzpyGou4hziijkjXcQfZLp+aAbnJPbMOlfqko5d/JkTu9TlbMByy4PDfBmUjNqz6K
         Xxr8cVXQvkcQA==
Date:   Tue, 19 Oct 2021 12:06:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sven@narfation.org
Cc:     netdev@vger.kernel.org, mareklindner@neomailbox.ch,
        b.a.t.m.a.n@lists.open-mesh.org, a@unstable.cc,
        sw@simonwunderlich.de
Subject: Re: [PATCH] batman-adv: use eth_hw_addr_set() instead of
 ether_addr_copy()
Message-ID: <20211019120654.6dee21b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211019163927.1386289-1-kuba@kernel.org>
References: <20211019163927.1386289-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 09:39:27 -0700 Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> Convert batman from ether_addr_copy() to eth_hw_addr_set():
> 
>   @@
>   expression dev, np;
>   @@
>   - ether_addr_copy(dev->dev_addr, np)
>   + eth_hw_addr_set(dev, np)
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Extending CC list.

> diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
> index 0604b0279573..7ee09337fc40 100644
> --- a/net/batman-adv/soft-interface.c
> +++ b/net/batman-adv/soft-interface.c
> @@ -134,7 +134,7 @@ static int batadv_interface_set_mac_addr(struct net_device *dev, void *p)
>  		return -EADDRNOTAVAIL;
>  
>  	ether_addr_copy(old_addr, dev->dev_addr);
> -	ether_addr_copy(dev->dev_addr, addr->sa_data);
> +	eth_hw_addr_set(dev, addr->sa_data);
>  
>  	/* only modify transtable if it has been initialized before */
>  	if (atomic_read(&bat_priv->mesh_state) != BATADV_MESH_ACTIVE)

