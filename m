Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C5B469D14
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 16:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245276AbhLFP2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 10:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376892AbhLFPX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 10:23:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D0BC08EB22
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 07:15:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3485B81129
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 15:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523CAC341C6;
        Mon,  6 Dec 2021 15:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638803720;
        bh=BCtDFMcbFix1CA+CofnYaFWZXb9HT6RbKhP4wAC5iLs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pUT5yUBDBENKvOCQ/uVfhJK+PUjQJvXJZdjIs1stvZ/jRtwq/a8WfogmY8/HnZ8Ye
         B1QKUwbwbLn+O99cpOCo87AE/EcZ0X4vlnyLorXEwwXiyezsNufhHBjHuUEtxIdOjt
         UhFqEykywhEWvdKojiDyhhYbF2XhbZYpIfFMZMLWvZ80wcqA0/ypKxqkoBwUIIkFbI
         9v0lY2tRYLW0FBjQDGSFXquUo86ISUYBvuCipaf1tVpEXZACO9/e6GHhE/8jj3J3v6
         bFFy8AKlhHJEk/mbRKKzCIx8aa862Dw+t2HKBURsOU8KfcrxWj0wobqJtflXNXO4nA
         ft9xz2gnf+hnQ==
Date:   Mon, 6 Dec 2021 07:15:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        alexander.duyck@gmail.com, mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH net] ethtool: do not perform operations on net devices
 being unregistered
Message-ID: <20211206071520.1fe7e18b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <07f2df6c-d7e5-9781-dae4-b0c2411c946c@linux.ibm.com>
References: <20211203101318.435618-1-atenart@kernel.org>
        <07f2df6c-d7e5-9781-dae4-b0c2411c946c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021 11:46:35 +0200 Julian Wiedmann wrote:
> On 03.12.21 12:13, Antoine Tenart wrote:
> > There is a short period between a net device starts to be unregistered
> > and when it is actually gone. In that time frame ethtool operations
> > could still be performed, which might end up in unwanted or undefined
> > behaviours[1].
> > 
> > Do not allow ethtool operations after a net device starts its
> > unregistration. This patch targets the netlink part as the ioctl one
> > isn't affected: the reference to the net device is taken and the
> > operation is executed within an rtnl lock section and the net device
> > won't be found after unregister.
> > [...]
> > +++ b/net/ethtool/netlink.c
> > @@ -40,7 +40,8 @@ int ethnl_ops_begin(struct net_device *dev)
> >  	if (dev->dev.parent)
> >  		pm_runtime_get_sync(dev->dev.parent);
> >  
> > -	if (!netif_device_present(dev)) {
> > +	if (!netif_device_present(dev) ||
> > +	    dev->reg_state == NETREG_UNREGISTERING) {
> >  		ret = -ENODEV;
> >  		goto err;
> >  	}
> >   
> 
> Wondering if other places would also benefit from a netif_device_detach()
> in the unregistration sequence ...

Sounds like a good idea but maybe as a follow up to net-next? 
The likelihood of that breaking things is low, but non-zero.
