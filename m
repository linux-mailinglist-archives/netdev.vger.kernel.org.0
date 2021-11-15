Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D8C4525B3
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 02:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240494AbhKPB5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 20:57:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239615AbhKOSOs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 13:14:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF0D9633E1;
        Mon, 15 Nov 2021 17:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636998581;
        bh=yNKnuk1bL39Dgrvp3NQ6HDKeuMRMz+3ejwv+V0Z7Zj8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ldF8JwkSvIdI/iq6+4z8n4Skh5t1jnSEsNvpyVRaZ5vozrFq+ITpN8g5wmrPMq+Vs
         gCi9/xv1Q0DpNDyafOmJuBOolECFdY2UGLAqBxk+pm1FCPWP/tcvK6VwC0wj4h3P4y
         fvjte1NobHBLlebQxnvjwRZ0mE+Zzf3mq0r0zMt1oGx0Ph1Ayhr1VRY9dioQ/5Icyi
         +brunKE9f/OqNshhy/RuxsC4gCP6UV8bqJ2jy+M/rSAVR69xdNmaZ+1TEuJQgc/IIM
         prqibyBX1rxo70WR2ro1rkzYiGVEIOBM+SaEmbzP+ns82YgVCUbrQ3COFZVDMwhiEF
         iuEywHN4lJSzw==
Date:   Mon, 15 Nov 2021 09:49:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>, <davem@davemloft.net>,
        <jgg@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: vlan: fix a UAF in vlan_dev_real_dev()
Message-ID: <20211115094940.138d86dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87k0h9bb9x.fsf@nvidia.com>
References: <20211102021218.955277-1-william.xuanziyang@huawei.com>
        <87k0h9bb9x.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 18:04:42 +0100 Petr Machata wrote:
> Ziyang Xuan <william.xuanziyang@huawei.com> writes:
> 
> > diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> > index 55275ef9a31a..a3a0a5e994f5 100644
> > --- a/net/8021q/vlan.c
> > +++ b/net/8021q/vlan.c
> > @@ -123,9 +123,6 @@ void unregister_vlan_dev(struct net_device *dev, struct list_head *head)
> >  	}
> >  
> >  	vlan_vid_del(real_dev, vlan->vlan_proto, vlan_id);
> > -
> > -	/* Get rid of the vlan's reference to real_dev */
> > -	dev_put(real_dev);
> >  }
> >  
> >  int vlan_check_real_dev(struct net_device *real_dev,
> > diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
> > index 0c21d1fec852..aeeb5f90417b 100644
> > --- a/net/8021q/vlan_dev.c
> > +++ b/net/8021q/vlan_dev.c
> > @@ -843,6 +843,9 @@ static void vlan_dev_free(struct net_device *dev)
> >  
> >  	free_percpu(vlan->vlan_pcpu_stats);
> >  	vlan->vlan_pcpu_stats = NULL;
> > +
> > +	/* Get rid of the vlan's reference to real_dev */
> > +	dev_put(vlan->real_dev);
> >  }
> >  
> >  void vlan_setup(struct net_device *dev)  
> 
> This is causing reference counting issues when vetoing is involved.
> Consider the following snippet:
> 
>     ip link add name bond1 type bond mode 802.3ad
>     ip link set dev swp1 master bond1
>     ip link add name bond1.100 link bond1 type vlan protocol 802.1ad id 100
>     # ^ vetoed, no netdevice created
>     ip link del dev bond1
> 
> The setup process goes like this: vlan_newlink() calls
> register_vlan_dev() calls netdev_upper_dev_link() calls
> __netdev_upper_dev_link(), which issues a notifier
> NETDEV_PRECHANGEUPPER, which yields a non-zero error,
> because a listener vetoed it.
> 
> So it unwinds, skipping dev_hold(real_dev), but eventually the VLAN ends
> up decreasing reference count of the real_dev. Then when when the bond
> netdevice is removed, we get an endless loop of:
> 
>     kernel:unregister_netdevice: waiting for bond1 to become free. Usage count = 0 
> 
> Moving the dev_hold(real_dev) to always happen even if the
> netdev_upper_dev_link() call makes the issue go away.
> 
> I'm not sure why this wasn't happening before. After the veto,
> register_vlan_dev() follows with a goto out_unregister_netdev, which
> calls unregister_netdevice() calls unregister_netdevice_queue(), which
> issues a notifier NETDEV_UNREGISTER, which invokes vlan_device_event(),
> which calls unregister_vlan_dev(), which used to dev_put(real_dev),
> which seems like it should have caused the same issue. Dunno.

Does the notifier trigger unregister_vlan_dev()? I thought the notifier
triggers when lower dev is unregistered.

I think we should move the dev_hold() to ndo_init(), otherwise 
it's hard to reason if destructor was invoked or not if
register_netdevice() errors out.
