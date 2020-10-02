Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015DE280F6A
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 11:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgJBJDu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 2 Oct 2020 05:03:50 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:60069 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725993AbgJBJDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 05:03:49 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-QlEWHUDMNjed8ouX9iMDPw-1; Fri, 02 Oct 2020 05:03:46 -0400
X-MC-Unique: QlEWHUDMNjed8ouX9iMDPw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4461918C89EA;
        Fri,  2 Oct 2020 09:03:29 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-115-83.ams2.redhat.com [10.36.115.83])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D3522C31E;
        Fri,  2 Oct 2020 09:03:26 +0000 (UTC)
Date:   Fri, 2 Oct 2020 11:03:23 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 08/12] ipv6: advertise IFLA_LINK_NETNSID when dumping
 ipv6 addresses
Message-ID: <20201002090323.GC3565727@bistromath.localdomain>
References: <cover.1600770261.git.sd@queasysnail.net>
 <00ecfc1804b58d8dbb23b8a6e7e5c0646f0100e1.1600770261.git.sd@queasysnail.net>
 <40925424-06ff-c0c5-0456-c7a9d58dff91@6wind.com>
MIME-Version: 1.0
In-Reply-To: <40925424-06ff-c0c5-0456-c7a9d58dff91@6wind.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-10-01, 17:58:40 +0200, Nicolas Dichtel wrote:
> Le 01/10/2020 à 09:59, Sabrina Dubroca a écrit :
> > Currently, we're not advertising link-netnsid when dumping IPv6
> > addresses, so the "ip -6 addr" command will not correctly interpret
> > the value of the IFLA_LINK attribute.
> > 
> > For example, we'll get:
> >     9: macvlan0@macvlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state UP qlen 1000
> >         <snip>
> > 
> > Instead of:
> >     9: macvlan0@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 state UP qlen 1000 link-netns main
> >         <snip>
> > 
> > ndisc_ifinfo_sysctl_change calls inet6_fill_ifinfo without rcu or
> > rtnl, so I'm adding rcu_read_lock around rtnl_fill_link_netnsid.
> I don't think this is needed.
> ndisc_ifinfo_sysctl_change() takes a reference on the idev (with in6_dev_get(dev)).

The problem is veth's get_link_net implementation, even after my change in patch 6:

    static struct net *veth_get_link_net(const struct net_device *dev)
    {
    	struct veth_priv *priv = netdev_priv(dev);
    	struct net_device *peer = rcu_dereference_rtnl(priv->peer);
    
    	return peer ? dev_net(peer) : dev_net(dev);
    }


These commands:

    ip link add type veth
    sysctl net.ipv6.neigh.veth0.retrans_time_ms=2000

cause this splat:

[   91.426764] =============================
[   91.427445] WARNING: suspicious RCU usage
[   91.428129] 5.9.0-rc6-net-00331-gae48bef8808b-dirty #266 Not tainted
[   91.429209] -----------------------------
[   91.433898] drivers/net/veth.c:1436 suspicious rcu_dereference_check() usage!
[   91.435127] 
               other info that might help us debug this:

[   91.436515] 
               rcu_scheduler_active = 2, debug_locks = 1
[   91.437636] 1 lock held by sysctl/3718:
[   91.438310]  #0: ffff88806488c430 (sb_writers#5){.+.+}-{0:0}, at: vfs_write+0x2a7/0x350
[   91.439769] 
               stack backtrace:
[   91.440552] CPU: 2 PID: 3718 Comm: sysctl Not tainted 5.9.0-rc6-net-00331-gae48bef8808b-dirty #266
[   91.442132] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.14.0-1 04/01/2014
[   91.443742] Call Trace:
[   91.444204]  dump_stack+0x9a/0xd0
[   91.444810]  veth_get_link_net+0xa6/0xb0
[   91.445534]  rtnl_fill_link_netnsid+0xa2/0x130
[   91.446330]  ? rtnl_put_cacheinfo+0x190/0x190
[   91.447120]  ? memcpy+0x39/0x60
[   91.447717]  inet6_fill_ifinfo+0x2f7/0x480



I guess I could push the rcu_read_lock down into veth and vxcan's
handlers instead of the rcu_dereference_rtnl change in patch 6 and
adding this rcu_read_lock.

-- 
Sabrina

