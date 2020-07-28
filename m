Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6CA231041
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731533AbgG1Q7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:60052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731478AbgG1Q7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:59:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 645C22053B;
        Tue, 28 Jul 2020 16:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595955559;
        bh=oRHLTRCZOWxH2aGzdKpv7FSkpcAsX+GbgEX4zj+ATGM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OeIY1Fpbnkh47mvgxHH1hai696D2n0pZZ6DxoFbtgzilOzUvJO8qfSsFGqIqT39GQ
         X6fsUGR6iMBAyUt8AsPCQCm+DE6nG2mO66n5tgyEZOPi+HwRavc7w9qaTnyBpDaTsz
         4Zf8Zzl70PUnVyi6g8fGMBAF6EdA+px/X5RzdZ0U=
Date:   Tue, 28 Jul 2020 09:59:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/2] mlx5: convert to new udp_tunnel
 infrastructure
Message-ID: <20200728095917.2e290d57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b9e4f45f6478b4447d5fa34bc7e02716d0f77d89.camel@mellanox.com>
References: <20200725025146.3770263-1-kuba@kernel.org>
        <20200725025146.3770263-3-kuba@kernel.org>
        <b9e4f45f6478b4447d5fa34bc7e02716d0f77d89.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jul 2020 08:35:53 +0000 Saeed Mahameed wrote:
> On Fri, 2020-07-24 at 19:51 -0700, Jakub Kicinski wrote:
> > Allocate nic_info dynamically - n_entries is not constant.
> > 
> > Drop the ndo callbacks from the reprs, those should be local to
> > the same netns as the main netdev, no need to get the same callbacks
> > multiple times.
> 
> Isn't this a problem ? so it seems this is the root cause of the
> regression failure we saw with this patch.
> 
> in a switchdev mode the "main" netdev is unregistered

Oh! I didn't realize you unregister the "main" one!

> and we register
> another netdev with ndos: "mlx5e_netdev_ops_uplink_rep" as the new main
> netdev (the uplink representor) where you removed the vxlan ndos, 
> see below.. 
>
> >  	.ndo_has_offload_stats	 = mlx5e_rep_has_offload_stats,
> >  	.ndo_get_offload_stats	 = mlx5e_rep_get_offload_stats,
> >  	.ndo_change_mtu          = mlx5e_uplink_rep_change_mtu,
> > -	.ndo_udp_tunnel_add      = mlx5e_add_vxlan_port,
> > -	.ndo_udp_tunnel_del      = mlx5e_del_vxlan_port,  
> 
> Here, this is uplink representor (i.e main netdev).
> we need the udp_tunnel_ndos.
> 
> also we need to add:
> mlx5_vxlan_set_netdev_info(mdev->vxlan, netdev);
> 
> in mlx5e_build_rep_netdev() under 
> if (rep->vport == MLX5_VPORT_UPLINK) statement.

Makes sense, thanks for the review!
