Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC38296270
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 18:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901491AbgJVQOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 12:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896380AbgJVQOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 12:14:38 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 787A224182;
        Thu, 22 Oct 2020 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603383278;
        bh=qT5RFGbgn6gkVO33iGkjXMTfVjNxJsiE1YfENa0kNXg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G874NIHNGt7/Ipm7+KKRNqPm0wjZ4qc8b0Ym8PvlnwwsTXIzYy2yUaj24JG4kS84E
         gKzaCbImZNVD+loQM3T13PxABdKwtfm8DMOqitMAlBe1LtDIFyRTFW6fvAsDWHWoRd
         fNdKS/jdRJ+cJd8eNCM7duAwD7+y//5BLxIUJvdA=
Date:   Thu, 22 Oct 2020 09:14:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: vxcan: Fix memleak in vxcan_newlink
Message-ID: <20201022091435.2449cf41@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <986c27bf-29b4-a4f7-1dcd-4cb5a446334b@hartkopp.net>
References: <20201021052150.25914-1-dinghao.liu@zju.edu.cn>
        <986c27bf-29b4-a4f7-1dcd-4cb5a446334b@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Oct 2020 13:20:16 +0200 Oliver Hartkopp wrote:
> On 21.10.20 07:21, Dinghao Liu wrote:
> > When rtnl_configure_link() fails, peer needs to be
> > freed just like when register_netdevice() fails.
> > 
> > Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>  
> 
> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> Btw. as the vxcan.c driver bases on veth.c the same issue can be found 
> there!
> 
> At this point:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/veth.c#L1398
> 
> err_register_dev:
>          /* nothing to do */
> err_configure_peer:
>          unregister_netdevice(peer);
>          return err; <<<<<<<<<<<<<<<<<<<<<<<
> 
> err_register_peer:
>          free_netdev(peer);
>          return err;
> }
> 
> IMO the return must be removed to fall through the next label and free 
> the netdevice too.
> 
> Would you like so send a patch for veth.c too?

Ah, this is where Liu Dinghao got the veth suggestion :)

Does vxcan actually need this patch?

static void vxcan_setup(struct net_device *dev)
{
	[...]
        dev->needs_free_netdev  = true;
