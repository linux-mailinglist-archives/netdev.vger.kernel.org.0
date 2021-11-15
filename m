Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A35D45082B
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbhKOPZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:25:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:50800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236405AbhKOPZH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 10:25:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E77EE61AA5;
        Mon, 15 Nov 2021 15:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636989728;
        bh=LYHyyDxw+fkw7Qpj63Y+bbXJh3cpxa/7tIYdjpyAAa0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tMGTzAAoFW81I1se350f9ba0pm1HsRmHclMPFvcwAtPKfgyVWshgxbiwSt08wLVGy
         uDRRDgCCHmYm4UESgBYJSeEnr9oS+lQxDWHgI4VeFn7zjpbwu7PFmxbbcFDPlfexqY
         IktSo5eA2/4E/neecXyve0V3oyhwD28vz/DfAZZ9WKDiV53yXnyBtlFtDU+pP+2x4i
         Hl5WwfTkPsHSmKOZAWKJnjZc9jGBLEsR7homItPyX/W+jscTK7Tlfq2KulR1WPBjJ4
         0UfaPmMPckRNfBoRcCsGltnf6awsf/+SZ4bX6QvWQUGFvbEcVm5mtIoEuGduGlGjee
         wjwZc9kfNHU5Q==
Date:   Mon, 15 Nov 2021 07:22:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211115072206.72435d60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211115150931.GA2386342@nvidia.com>
References: <20211109153335.GH1740502@nvidia.com>
        <20211109082042.31cf29c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211109182427.GJ1740502@nvidia.com>
        <YY0G90fJpu/OtF8L@nanopsycho>
        <YY0J8IOLQBBhok2M@unreal>
        <YY4aEFkVuqR+vauw@nanopsycho>
        <YZCqVig9GQi/o1iz@unreal>
        <YZJCdSy+wzqlwrE2@nanopsycho>
        <20211115125359.GM2105516@nvidia.com>
        <YZJx8raQt+FkKaeY@nanopsycho>
        <20211115150931.GA2386342@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 11:09:31 -0400 Jason Gunthorpe wrote:
> On Mon, Nov 15, 2021 at 03:42:58PM +0100, Jiri Pirko wrote:
> > >Sorry, I don't agree that registering a net notifier in an aux device
> > >probe function is non-standard or wrong.  
> > 
> > Listening to events which happen in different namespaces and react to
> > them is the non-standard behaviour which I refered to. If you would not
> > need to do it, you could just use netns notofier which would solve your
> > issue. You know it.  
> 
> Huh?
> 
> It calls the bog standard
> 
>  register_netdevice_notifier() 
> 
> Like hundreds of other drivers do from their probe functions
> 
> Which does:
> 
> int register_netdevice_notifier(struct notifier_block *nb)
> {
> 	struct net *net;
> 	int err;
> 
> 	/* Close race with setup_net() and cleanup_net() */
> 	down_write(&pernet_ops_rwsem);
> 
> And deadlocks because devlink hols the pernet_ops_rwsem when it
> triggers reload in some paths.
> 
> There is nothing wrong with a driver doing this standard pattern.
> 
> There is only one place in the entire kernel calling the per-ns
> register_netdevice_notifier_dev_net() and it is burred inside another
> part of mlx5 for some reason..
> 
> I believe Parav already looked at using that in rdma and it didn't
> work for some reason I've forgotten. 
> 
> It is not that we care about events in different namespaces, it is
> that rdma, like everything else, doesn't care about namespaces and
> wants events from the netdev no matter where it is located.

devlink now allows drivers to be net ns-aware, and they should 
obey if they declare support.  Can we add a flag / capability 
to devlink and make it an explicit opt-in for drivers who care?
