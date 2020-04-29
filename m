Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A931BE6AB
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgD2SyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 14:54:03 -0400
Received: from mga06.intel.com ([134.134.136.31]:37119 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgD2SyD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 14:54:03 -0400
IronPort-SDR: zR4mm5YGT9oOWpWX3pb2Ckm97XaXVkCRUKzYk53N36ju3Pinv4C8ASj7R5gUViXje+g+XPFdSs
 zGXNOmnbmv6g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 11:54:02 -0700
IronPort-SDR: 3Y/iB9fjpJ44uLq88VCkxqawCGRBIIyijovrdCG7MZEP7FHUSfB3XVcbgkRGMtABTBvvL6KEgk
 L+v8YzmFY8Gg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,333,1583222400"; 
   d="scan'208";a="405137750"
Received: from jdfowle1-mobl1.amr.corp.intel.com ([10.254.111.23])
  by orsmga004.jf.intel.com with ESMTP; 29 Apr 2020 11:54:02 -0700
Date:   Wed, 29 Apr 2020 11:54:02 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@jdfowle1-mobl1.amr.corp.intel.com
To:     Paolo Abeni <pabeni@redhat.com>
cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: Re: [PATCH net 2/5] mptcp: move option parsing into
 mptcp_incoming_options()
In-Reply-To: <aa86653cfe250462144b5635e235a92279eaf288.1588156257.git.pabeni@redhat.com>
Message-ID: <alpine.OSX.2.22.394.2004291151040.42484@jdfowle1-mobl1.amr.corp.intel.com>
References: <cover.1588156257.git.pabeni@redhat.com> <aa86653cfe250462144b5635e235a92279eaf288.1588156257.git.pabeni@redhat.com>
User-Agent: Alpine 2.22 (OSX 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 29 Apr 2020, Paolo Abeni wrote:

> The mptcp_options_received structure carries several per
> packet flags (mp_capable, mp_join, etc.). Such fields must
> be cleared on each packet, even on dropped ones or packet
> not carrying any MPTCP options, but the current mptcp
> code clears them only on TCP option reset.
>
> On several races/corner cases we end-up with stray bits in
> incoming options, leading to WARN_ON splats. e.g.:
>
> [  171.164906] Bad mapping: ssn=32714 map_seq=1 map_data_len=32713
> [  171.165006] WARNING: CPU: 1 PID: 5026 at net/mptcp/subflow.c:533 warn_bad_map (linux-mptcp/net/mptcp/subflow.c:533 linux-mptcp/net/mptcp/subflow.c:531)
> [  171.167632] Modules linked in: ip6_vti ip_vti ip_gre ipip sit tunnel4 ip_tunnel geneve ip6_udp_tunnel udp_tunnel macsec macvtap tap ipvlan macvlan 8021q garp mrp xfrm_interface veth netdevsim nlmon dummy team bonding vcan bridge stp llc ip6_gre gre ip6_tunnel tunnel6 tun binfmt_misc intel_rapl_msr intel_rapl_common rfkill kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel joydev virtio_balloon pcspkr i2c_piix4 sunrpc ip_tables xfs libcrc32c crc32c_intel serio_raw virtio_console ata_generic virtio_blk virtio_net net_failover failover ata_piix libata
> [  171.199464] CPU: 1 PID: 5026 Comm: repro Not tainted 5.7.0-rc1.mptcp_f227fdf5d388+ #95
> [  171.200886] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-2.fc30 04/01/2014
> [  171.202546] RIP: 0010:warn_bad_map (linux-mptcp/net/mptcp/subflow.c:533 linux-mptcp/net/mptcp/subflow.c:531)
> [  171.206537] Code: c1 ea 03 0f b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 1d 8b 55 3c 44 89 e6 48 c7 c7 20 51 13 95 e8 37 8b 22 fe <0f> 0b 48 83 c4 08 5b 5d 41 5c c3 89 4c 24 04 e8 db d6 94 fe 8b 4c
> [  171.220473] RSP: 0018:ffffc90000150560 EFLAGS: 00010282
> [  171.221639] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [  171.223108] RDX: 0000000000000000 RSI: 0000000000000008 RDI: fffff5200002a09e
> [  171.224388] RBP: ffff8880aa6e3c00 R08: 0000000000000001 R09: fffffbfff2ec9955
> [  171.225706] R10: ffffffff9764caa7 R11: fffffbfff2ec9954 R12: 0000000000007fca
> [  171.227211] R13: ffff8881066f4a7f R14: ffff8880aa6e3c00 R15: 0000000000000020
> [  171.228460] FS:  00007f8623719740(0000) GS:ffff88810be00000(0000) knlGS:0000000000000000
> [  171.230065] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  171.231303] CR2: 00007ffdab190a50 CR3: 00000001038ea006 CR4: 0000000000160ee0
> [  171.232586] Call Trace:
> [  171.233109]  <IRQ>
> [  171.233531] get_mapping_status (linux-mptcp/net/mptcp/subflow.c:691)
> [  171.234371] mptcp_subflow_data_available (linux-mptcp/net/mptcp/subflow.c:736 linux-mptcp/net/mptcp/subflow.c:832)
> [  171.238181] subflow_state_change (linux-mptcp/net/mptcp/subflow.c:1085 (discriminator 1))
> [  171.239066] tcp_fin (linux-mptcp/net/ipv4/tcp_input.c:4217)
> [  171.240123] tcp_data_queue (linux-mptcp/./include/linux/compiler.h:199 linux-mptcp/net/ipv4/tcp_input.c:4822)
> [  171.245083] tcp_rcv_established (linux-mptcp/./include/linux/skbuff.h:1785 linux-mptcp/./include/net/tcp.h:1774 linux-mptcp/./include/net/tcp.h:1847 linux-mptcp/net/ipv4/tcp_input.c:5238 linux-mptcp/net/ipv4/tcp_input.c:5730)
> [  171.254089] tcp_v4_rcv (linux-mptcp/./include/linux/spinlock.h:393 linux-mptcp/net/ipv4/tcp_ipv4.c:2009)
> [  171.258969] ip_protocol_deliver_rcu (linux-mptcp/net/ipv4/ip_input.c:204 (discriminator 1))
> [  171.260214] ip_local_deliver_finish (linux-mptcp/./include/linux/rcupdate.h:651 linux-mptcp/net/ipv4/ip_input.c:232)
> [  171.261389] ip_local_deliver (linux-mptcp/./include/linux/netfilter.h:307 linux-mptcp/./include/linux/netfilter.h:301 linux-mptcp/net/ipv4/ip_input.c:252)
> [  171.265884] ip_rcv (linux-mptcp/./include/linux/netfilter.h:307 linux-mptcp/./include/linux/netfilter.h:301 linux-mptcp/net/ipv4/ip_input.c:539)
> [  171.273666] process_backlog (linux-mptcp/./include/linux/rcupdate.h:651 linux-mptcp/net/core/dev.c:6135)
> [  171.275328] net_rx_action (linux-mptcp/net/core/dev.c:6572 linux-mptcp/net/core/dev.c:6640)
> [  171.280472] __do_softirq (linux-mptcp/./arch/x86/include/asm/jump_label.h:25 linux-mptcp/./include/linux/jump_label.h:200 linux-mptcp/./include/trace/events/irq.h:142 linux-mptcp/kernel/softirq.c:293)
> [  171.281379] do_softirq_own_stack (linux-mptcp/arch/x86/entry/entry_64.S:1083)
> [  171.282358]  </IRQ>
>
> We could address the issue clearing explicitly the relevant fields
> in several places - tcp_parse_option, tcp_fast_parse_options,
> possibly others.
>
> Instead we move the MPTCP option parsing into the already existing
> mptcp ingress hook, so that we need to clear the fields in a single
> place.
>
> This allows us dropping an MPTCP hook from the TCP code and
> removing the quite large mptcp_options_received from the tcp_sock
> struct. On the flip side, the MPTCP sockets will traverse the
> option space twice (in tcp_parse_option() and in
> mptcp_incoming_options(). That looks acceptable: we already
> do that for syn and 3rd ack packets, plain TCP socket will
> benefit from it, and even MPTCP sockets will experience better
> code locality, reducing the jumps between TCP and MPTCP code.
>
> Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---

Hi Paolo -

This doesn't apply cleanly to the net tree.


--
Mat Martineau
Intel
