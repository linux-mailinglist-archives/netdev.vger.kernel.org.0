Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552B52F3FBE
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405105AbhALWdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 17:33:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbhALWds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 17:33:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610490741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fks7S4sWATCTrvgOGnefCKrK3VzEzfrq2t139PnWz5s=;
        b=Km4rCVB2pSDluRQya3ONB2oBY1qvPbdxG4s8GwVdN4c0v4iM7FR/rBkEjQDguryU9ePk6P
        6yi4bn2ELZjkIO8mq1R8RDt0pwBXN34nVbd6xy/hRjz1FECfTuu3mLm+a1DdOhxTMucTbT
        1gQGd9KsjyCT3QZuNzy8gqHPw9now4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-Z82Ggr4cMQy_P00oAJMsZg-1; Tue, 12 Jan 2021 17:32:19 -0500
X-MC-Unique: Z82Ggr4cMQy_P00oAJMsZg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0380BE75C;
        Tue, 12 Jan 2021 22:32:18 +0000 (UTC)
Received: from redhat.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C098D1F0;
        Tue, 12 Jan 2021 22:32:16 +0000 (UTC)
Date:   Tue, 12 Jan 2021 17:32:14 -0500
From:   Jarod Wilson <jarod@redhat.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] bonding: add a vlan+srcmac tx hashing option
Message-ID: <20210112223214.GJ476710@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com>
 <21784.1608337139@famine>
 <20210108000340.GC29828@redhat.com>
 <20210112211216.GI476710@redhat.com>
 <30207.1610487550@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30207.1610487550@famine>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 01:39:10PM -0800, Jay Vosburgh wrote:
> Jarod Wilson <jarod@redhat.com> wrote:
> 
> >On Thu, Jan 07, 2021 at 07:03:40PM -0500, Jarod Wilson wrote:
> >> On Fri, Dec 18, 2020 at 04:18:59PM -0800, Jay Vosburgh wrote:
> >> > Jarod Wilson <jarod@redhat.com> wrote:
> >> > 
> >> > >This comes from an end-user request, where they're running multiple VMs on
> >> > >hosts with bonded interfaces connected to some interest switch topologies,
> >> > >where 802.3ad isn't an option. They're currently running a proprietary
> >> > >solution that effectively achieves load-balancing of VMs and bandwidth
> >> > >utilization improvements with a similar form of transmission algorithm.
> >> > >
> >> > >Basically, each VM has it's own vlan, so it always sends its traffic out
> >> > >the same interface, unless that interface fails. Traffic gets split
> >> > >between the interfaces, maintaining a consistent path, with failover still
> >> > >available if an interface goes down.
> >> > >
> >> > >This has been rudimetarily tested to provide similar results, suitable for
> >> > >them to use to move off their current proprietary solution.
> >> > >
> >> > >Still on the TODO list, if these even looks sane to begin with, is
> >> > >fleshing out Documentation/networking/bonding.rst.
> >> > 
> >> > 	I'm sure you're aware, but any final submission will also need
> >> > to include netlink and iproute2 support.
> >> 
> >> I believe everything for netlink support is already included, but I'll
> >> double-check that before submitting something for inclusion consideration.
> >
> >I'm not certain if what you actually meant was that I'd have to patch
> >iproute2 as well, which I've definitely stumbled onto today, but it's a
> >2-line patch, and everything seems to be working fine with it:
> 
> 	Yes, that's what I meant.
> 
> >$ sudo ip link set bond0 type bond xmit_hash_policy 5
> 
> 	Does the above work with the text label (presumably "vlansrc")
> as well as the number, and does "ip link add test type bond help" print
> the correct text for XMIT_HASH_POLICY?

All of the above looks correct to me, output below. Before submitting...
Could rename it from vlansrc to vlan+srcmac or some variation thereof if
it's desired. I tried to keep it relatively short, but it's perhaps a bit
less succinct like I have it now, and other modes include a +.

$ sudo modprobe bonding mode=2 max_bonds=1 xmit_hash_policy=0
$ sudo ip link set bond0 type bond xmit_hash_policy vlansrc
$ cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v4.18.0-272.el8.vstx.x86_64

Bonding Mode: load balancing (xor)
Transmit Hash Policy: vlansrc (5)
MII Status: down
MII Polling Interval (ms): 0
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

$ sudo ip link add test type bond help
Usage: ... bond [ mode BONDMODE ] [ active_slave SLAVE_DEV ]
                [ clear_active_slave ] [ miimon MIIMON ]
                [ updelay UPDELAY ] [ downdelay DOWNDELAY ]
                [ peer_notify_delay DELAY ]
                [ use_carrier USE_CARRIER ]
                [ arp_interval ARP_INTERVAL ]
                [ arp_validate ARP_VALIDATE ]
                [ arp_all_targets ARP_ALL_TARGETS ]
                [ arp_ip_target [ ARP_IP_TARGET, ... ] ]
                [ primary SLAVE_DEV ]
                [ primary_reselect PRIMARY_RESELECT ]
                [ fail_over_mac FAIL_OVER_MAC ]
                [ xmit_hash_policy XMIT_HASH_POLICY ]
                [ resend_igmp RESEND_IGMP ]
                [ num_grat_arp|num_unsol_na NUM_GRAT_ARP|NUM_UNSOL_NA ]
                [ all_slaves_active ALL_SLAVES_ACTIVE ]
                [ min_links MIN_LINKS ]
                [ lp_interval LP_INTERVAL ]
                [ packets_per_slave PACKETS_PER_SLAVE ]
                [ tlb_dynamic_lb TLB_DYNAMIC_LB ]
                [ lacp_rate LACP_RATE ]
                [ ad_select AD_SELECT ]
                [ ad_user_port_key PORTKEY ]
                [ ad_actor_sys_prio SYSPRIO ]
                [ ad_actor_system LLADDR ]

BONDMODE := balance-rr|active-backup|balance-xor|broadcast|802.3ad|balance-tlb|balance-alb
ARP_VALIDATE := none|active|backup|all
ARP_ALL_TARGETS := any|all
PRIMARY_RESELECT := always|better|failure
FAIL_OVER_MAC := none|active|follow
XMIT_HASH_POLICY := layer2|layer2+3|layer3+4|encap2+3|encap3+4|vlansrc
LACP_RATE := slow|fast
AD_SELECT := stable|bandwidth|count


-- 
Jarod Wilson
jarod@redhat.com

