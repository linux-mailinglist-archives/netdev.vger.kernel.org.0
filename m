Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B07B452411
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 02:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244244AbhKPBf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 20:35:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379111AbhKPBaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 20:30:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BE9461027;
        Tue, 16 Nov 2021 01:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637026043;
        bh=ejw5DSWAYfxDZtzp+bb98cqbsDSFko0lVTF/qo2BNRc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vPQ+taYLxWguYZM3jINyxjIM/C9a3YUpZHGdjnoPQk6yeKqdwGAYyXZjsDvEaQMCX
         JYuDzjr2SO8We1pypuVN4ODETQ2rAZYH6u/sfPJqhHKBRbvtfMETmXfwQDuPpDUNQn
         LFWR3wTCij5Rh/rlBuPjMBMCz/HVvPkQNOrbES6pB/F6F/KQYdp0G44GxkiX4EJG/t
         trTu3e75st7o93p+TkApscEetp2J44UcptAaTmlAKF5OmdsT4XOa2FmgRxlyuba7XK
         gltlKEUxmwpXvxPJnPi1jumLGDv+vGMA+IALJph1FZXaX+9Fe/9XEk4+uKWqeLaAA6
         8DXZTKPo/JIHQ==
Date:   Mon, 15 Nov 2021 17:27:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Pavel Skripkin <paskripkin@gmail.com>, ioana.ciornei@nxp.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] net: dpaa2-eth: fix use-after-free in dpaa2_eth_remove
Message-ID: <20211115172722.6a582623@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211115080817.GE27562@kadam>
References: <20211113172013.19959-1-paskripkin@gmail.com>
        <20211115080817.GE27562@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 11:08:17 +0300 Dan Carpenter wrote:
> > @Dan, is there a smatch checker for straigthforward use after free bugs?
> > Like acessing pointer after free was called? I think, adding
> > free_netdev() to check list might be good idea
> > 
> > I've skimmed througth smatch source and didn't find one, so can you,
> > please, point out to it if it exists.  
> 
> It's check_free_strict.c.
> 
> It does cross function analysis but free_netdev() is tricky because it
> doesn't free directly, it just drops the reference count.  Also it
> delays freeing in the NETREG_UNREGISTERING path so this check might
> cause false positives?

I'd ignore that path, it's just special casing that's supposed to keep
the driver-visible API sane. Nobody should be touching netdev past
free_netdev(). Actually if you can it'd be interesting to add checks
for using whatever netdev_priv(ndev) returned past free_netdev(ndev).

Most UAFs that come to mind from the past were people doing something
like:

	struct my_priv *mine = netdev_priv(ndev);

	netdev_unregister(ndev);
	free_netdev(ndev);

	free(mine->bla); /* UAF, free_netdev() frees the priv */

> I'll add free_netdev() to the list of free
> functions and test it overnight tonight.
> 
> 	register_free_hook("free_netdev", &match_free, 0);

