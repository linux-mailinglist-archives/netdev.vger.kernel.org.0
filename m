Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CC148579B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 18:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242522AbiAERqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 12:46:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56808 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242529AbiAERqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 12:46:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC1D76181A
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 17:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07324C36AE3;
        Wed,  5 Jan 2022 17:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641404811;
        bh=hIPWQ1WQK4tW0u7OC2jiY1n76ZAMKLNB2aF/zsbqC4A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=THftKJzl6gxQjwnmHGum58+fqkPPmkXWvFqMMxMn2xdirG5ww3Ot/6OaywNlWhx7G
         lYa2czIcgIyfW1OT53qX3uifgPuyY6a4mZtRAOmokQj9yRWJlswGbBcoKn0JzoIsG3
         QRyQYj+pnZtYFJ+J94Qd4HIvEy8DKNhxTkmqbQzeRtF6PjGHbcF58yIwG1bYeZMHH+
         sHWdrjNx+JUblfjak91DMIXeDdxJMWzRaTw3aMUJZtPgQYCTeLr6V/tZ3NoAw/10bZ
         GqNIFWAtA/ueiIvOVrdnbOyZ2Zk5/cPYZGunVaQ7ia/vJbuyLV5AeWhwQJJQygNd/x
         zzIdl7hjbDu9Q==
Date:   Wed, 5 Jan 2022 09:46:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v4 3/8] net/funeth: probing and netdev ops
Message-ID: <20220105094648.4ff74c9e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOkoqZmxHZ6KTZQPe+w23E_UPYWLNRiU8gVX32EFsNXgyzkucg@mail.gmail.com>
References: <20220104064657.2095041-1-dmichail@fungible.com>
        <20220104064657.2095041-4-dmichail@fungible.com>
        <20220104180739.572a80ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAOkoqZmxHZ6KTZQPe+w23E_UPYWLNRiU8gVX32EFsNXgyzkucg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jan 2022 07:52:21 -0800 Dimitris Michailidis wrote:
> On Tue, Jan 4, 2022 at 6:07 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon,  3 Jan 2022 22:46:52 -0800 Dimitris Michailidis wrote:  
> > > This is the first part of the Fungible ethernet driver. It deals with
> > > device probing, net_device creation, and netdev ops.  
> >  
> > > +static int fun_xdp_setup(struct net_device *dev, struct netdev_bpf *xdp)
> > > +{
> > > +     struct bpf_prog *old_prog, *prog = xdp->prog;
> > > +     struct funeth_priv *fp = netdev_priv(dev);
> > > +     bool reconfig;
> > > +     int rc, i;
> > > +
> > > +     /* XDP uses at most one buffer */
> > > +     if (prog && dev->mtu > XDP_MAX_MTU) {
> > > +             netdev_err(dev, "device MTU %u too large for XDP\n", dev->mtu);
> > > +             NL_SET_ERR_MSG_MOD(xdp->extack,
> > > +                                "Device MTU too large for XDP");
> > > +             return -EINVAL;
> > > +     }
> > > +
> > > +     reconfig = netif_running(dev) && (!!fp->xdp_prog ^ !!prog);
> > > +     if (reconfig) {
> > > +             rc = funeth_close(dev);  
> >
> > Please rework runtime reconfig to not do the close and then open thing.
> > This will prevent users from reconfiguring their NICs at runtime.
> > You should allocate the resources first, then take the datapath down,
> > reconfigure, swap and free the old resources.  
> 
> I imagine you have in mind something like nfp_net_ring_reconfig() but that
> doesn't work as well here. We have the linux part of the data path (ring memory,
> interrupts, etc) and the device part, handled by FW. I can't clone the device
> portion for a quick swap during downtime. Since it involves messages to FW
> updating the device portion is by far the bulk of the work and it needs to be
> during the downtime. Doing Linux allocations before downtime offers little
> improvement I think.

It does - real machines running real workloads will often be under
memory pressure. I've even seen XDP enable / disable fail just due 
to memory fragmentation, with plenty free memory when device rings
are large.

> There is ongoing work for FW to be able to modify live queues. When that
> is available I expect this function will be able to move in and out of XDP with
> no downtime.

> > > +static void fun_destroy_netdev(struct net_device *netdev)
> > > +{
> > > +     if (likely(netdev)) {  
> >
> > defensive programming?  
> 
> Looks that way but I'd rather have this function work with any input.

There's way too much defensive programming in this driver. Unless there
is a legit code path which can pass netdev == NULL you should remove
the check.
