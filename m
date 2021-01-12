Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446012F3D76
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392413AbhALVkj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 12 Jan 2021 16:40:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42300 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731887AbhALVkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 16:40:00 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kzRNg-00021C-EU; Tue, 12 Jan 2021 21:39:12 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id BF9355FEE8; Tue, 12 Jan 2021 13:39:10 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id BA10E9FAB0;
        Tue, 12 Jan 2021 13:39:10 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] bonding: add a vlan+srcmac tx hashing option
In-reply-to: <20210112211216.GI476710@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com> <21784.1608337139@famine> <20210108000340.GC29828@redhat.com> <20210112211216.GI476710@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Tue, 12 Jan 2021 16:12:16 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <30206.1610487550.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 12 Jan 2021 13:39:10 -0800
Message-ID: <30207.1610487550@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>On Thu, Jan 07, 2021 at 07:03:40PM -0500, Jarod Wilson wrote:
>> On Fri, Dec 18, 2020 at 04:18:59PM -0800, Jay Vosburgh wrote:
>> > Jarod Wilson <jarod@redhat.com> wrote:
>> > 
>> > >This comes from an end-user request, where they're running multiple VMs on
>> > >hosts with bonded interfaces connected to some interest switch topologies,
>> > >where 802.3ad isn't an option. They're currently running a proprietary
>> > >solution that effectively achieves load-balancing of VMs and bandwidth
>> > >utilization improvements with a similar form of transmission algorithm.
>> > >
>> > >Basically, each VM has it's own vlan, so it always sends its traffic out
>> > >the same interface, unless that interface fails. Traffic gets split
>> > >between the interfaces, maintaining a consistent path, with failover still
>> > >available if an interface goes down.
>> > >
>> > >This has been rudimetarily tested to provide similar results, suitable for
>> > >them to use to move off their current proprietary solution.
>> > >
>> > >Still on the TODO list, if these even looks sane to begin with, is
>> > >fleshing out Documentation/networking/bonding.rst.
>> > 
>> > 	I'm sure you're aware, but any final submission will also need
>> > to include netlink and iproute2 support.
>> 
>> I believe everything for netlink support is already included, but I'll
>> double-check that before submitting something for inclusion consideration.
>
>I'm not certain if what you actually meant was that I'd have to patch
>iproute2 as well, which I've definitely stumbled onto today, but it's a
>2-line patch, and everything seems to be working fine with it:

	Yes, that's what I meant.

>$ sudo ip link set bond0 type bond xmit_hash_policy 5

	Does the above work with the text label (presumably "vlansrc")
as well as the number, and does "ip link add test type bond help" print
the correct text for XMIT_HASH_POLICY?

	-J

>$ ip -d link show bond0
>11: bond0: <BROADCAST,MULTICAST,MASTER> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>    link/ether ce:85:5e:24:ce:90 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535
>    bond mode balance-xor miimon 0 updelay 0 downdelay 0 peer_notify_delay 0 use_carrier 1 arp_interval 0 arp_validate none arp_all_targets any primary_reselect always fail_over_mac none xmit_hash_policy vlansrc resend_igmp 1 num_grat_arp 1 all_slaves_active 0 min_links 0 lp_interval 1 packets_per_slave 1 lacp_rate slow ad_select stable tlb_dynamic_lb 1 addrgenmode eui64 numtxqueues 16 numrxqueues 16 gso_max_size 65536 gso_max_segs 65535
>$ grep Hash /proc/net/bonding/bond0
>Transmit Hash Policy: vlansrc (5)
>
>Nothing bad seems to happen on an older kernel if one tries to set the new
>hash, you just get told that it's an invalid argument.
>
>I *think* this is all ready for submission then, so I'll get both the kernel
>and iproute2 patches out soon.
>
>-- 
>Jarod Wilson
>jarod@redhat.com

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
