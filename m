Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF412F3D5E
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438164AbhALViK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:38:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437126AbhALVNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 16:13:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610485943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WovaxjFL+2/INxiHqZ8PGQNi33N0CO0yRS5E4jp/8rU=;
        b=cRMzhdw9N+iFPF7iHwX5CszUJRIfgYKMOQ+dzpAeTmkVK9VTae+P4rGVv/RQBmuuCN332A
        +wNguvcAh2BAwKjfGCfMl6+odn6VT8ksKgUrXaaFiegAkvfbCq4Q8n3cXFe32yqSD90sdx
        cUJr6AQoTQ5uxe4enP19rrSRXkq0QWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-5SVhPJB4P4e29EdjMkSy-A-1; Tue, 12 Jan 2021 16:12:22 -0500
X-MC-Unique: 5SVhPJB4P4e29EdjMkSy-A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6ED6107ACF7;
        Tue, 12 Jan 2021 21:12:19 +0000 (UTC)
Received: from redhat.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A2EAE10013BD;
        Tue, 12 Jan 2021 21:12:18 +0000 (UTC)
Date:   Tue, 12 Jan 2021 16:12:16 -0500
From:   Jarod Wilson <jarod@redhat.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] bonding: add a vlan+srcmac tx hashing option
Message-ID: <20210112211216.GI476710@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com>
 <21784.1608337139@famine>
 <20210108000340.GC29828@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108000340.GC29828@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 07:03:40PM -0500, Jarod Wilson wrote:
> On Fri, Dec 18, 2020 at 04:18:59PM -0800, Jay Vosburgh wrote:
> > Jarod Wilson <jarod@redhat.com> wrote:
> > 
> > >This comes from an end-user request, where they're running multiple VMs on
> > >hosts with bonded interfaces connected to some interest switch topologies,
> > >where 802.3ad isn't an option. They're currently running a proprietary
> > >solution that effectively achieves load-balancing of VMs and bandwidth
> > >utilization improvements with a similar form of transmission algorithm.
> > >
> > >Basically, each VM has it's own vlan, so it always sends its traffic out
> > >the same interface, unless that interface fails. Traffic gets split
> > >between the interfaces, maintaining a consistent path, with failover still
> > >available if an interface goes down.
> > >
> > >This has been rudimetarily tested to provide similar results, suitable for
> > >them to use to move off their current proprietary solution.
> > >
> > >Still on the TODO list, if these even looks sane to begin with, is
> > >fleshing out Documentation/networking/bonding.rst.
> > 
> > 	I'm sure you're aware, but any final submission will also need
> > to include netlink and iproute2 support.
> 
> I believe everything for netlink support is already included, but I'll
> double-check that before submitting something for inclusion consideration.

I'm not certain if what you actually meant was that I'd have to patch
iproute2 as well, which I've definitely stumbled onto today, but it's a
2-line patch, and everything seems to be working fine with it:

$ sudo ip link set bond0 type bond xmit_hash_policy 5
$ ip -d link show bond0
11: bond0: <BROADCAST,MULTICAST,MASTER> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether ce:85:5e:24:ce:90 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535
    bond mode balance-xor miimon 0 updelay 0 downdelay 0 peer_notify_delay 0 use_carrier 1 arp_interval 0 arp_validate none arp_all_targets any primary_reselect always fail_over_mac none xmit_hash_policy vlansrc resend_igmp 1 num_grat_arp 1 all_slaves_active 0 min_links 0 lp_interval 1 packets_per_slave 1 lacp_rate slow ad_select stable tlb_dynamic_lb 1 addrgenmode eui64 numtxqueues 16 numrxqueues 16 gso_max_size 65536 gso_max_segs 65535
$ grep Hash /proc/net/bonding/bond0
Transmit Hash Policy: vlansrc (5)

Nothing bad seems to happen on an older kernel if one tries to set the new
hash, you just get told that it's an invalid argument.

I *think* this is all ready for submission then, so I'll get both the kernel
and iproute2 patches out soon.

-- 
Jarod Wilson
jarod@redhat.com

