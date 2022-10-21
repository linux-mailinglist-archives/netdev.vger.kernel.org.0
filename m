Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46FC607497
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 12:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiJUKAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 06:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJUKAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 06:00:24 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0D35108243;
        Fri, 21 Oct 2022 03:00:22 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1112)
        id 8718020FEB47; Fri, 21 Oct 2022 03:00:22 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8718020FEB47
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1666346422;
        bh=cYIKrJC5k/BBGSDjkeleD8TAE2cOUtwAK2AhJ6I3N70=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hdisWQP0XbRm7V//OZw98Klj2Eptp2S5qfDXKyYQnxfJI5B8/vRPoF9cO8Hfj+f87
         b3mxQXv2+IFnljFKLraeHSY7JBrEaJoF5pzCGPtFa0Urct+UD6tp3RbcwqnJmeQZK+
         szLD6Gn/ErNJVla2zTQVr2cJfGQFx5VsM4DhYrZw=
Date:   Fri, 21 Oct 2022 03:00:22 -0700
From:   Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        seh@panix.com, Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: kernel BUG at net/core/skbuff.c:4219
Message-ID: <20221021100022.GA31916@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221011165611.GA8735@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <194f6b02-8ee7-b5d7-58f3-6a83b5ff275d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <194f6b02-8ee7-b5d7-58f3-6a83b5ff275d@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 11, 2022 at 10:57:05AM -0700, Eric Dumazet wrote:
> 
> On 10/11/22 09:56, Jeremi Piotrowski wrote:
> >Hi,
> >
> >One of our Flatcar users has been hitting the kernel BUG in the subject line
> >for the past year (https://github.com/flatcar/Flatcar/issues/378). This was
> >first reported when on 5.10.25, but has been happening across kernel updates,
> >most recently with 5.15.63. The nodes where this happens are AWS EC2 instances,
> >using ENA and calico networking in eBPF mode with VXLAN encapsulation. When
> >GRO/GSO is enabled, the host hits this bug and prints the following stacktrace:
> 
> 
> I suspect eBPF code lowers gso_size ?
> 
> gso stack is not able to arbitrarily segment a GRO packet after
> gso_size being changed.
> 
> 

This was a good hint, see Tomas' response for some more observations.

This appears to still be happening with Calico v3.23 which started passing
BPF_F_ADJ_ROOM_FIXED_GSO to bpf_skb_adjust_room() on the decap (rx) path.
BPF_F_ADJ_ROOM_FIXED_GSO is not passed on the encap (tx) path. It is enough to
disable GRO to stop the BUG from being hit though, so there must be more going
on here ? (since the rx path does not change gso_size any longer).

> >
> >[Mon Oct 10 18:22:24 2022] ------------[ cut here ]------------
> >[Mon Oct 10 18:22:24 2022] kernel BUG at net/core/skbuff.c:4219!
> >[Mon Oct 10 18:22:24 2022] invalid opcode: 0000 [#1] SMP PTI
> >[Mon Oct 10 18:22:24 2022] CPU: 6 PID: 0 Comm: swapper/6 Not tainted 5.15.63-flatcar #1
> >[Mon Oct 10 18:22:24 2022] Hardware name: Amazon EC2 z1d.12xlarge/, BIOS 1.0 10/16/2017
> >[Mon Oct 10 18:22:24 2022] RIP: 0010:skb_segment+0xc70/0xe80
> >[Mon Oct 10 18:22:24 2022] Code: 44 24 50 48 89 44 24 30 48 8b 44 24 10 48 89 44 24 50 e9 16 f7 ff ff 0f 0b 89 44 24 2c c7 44 24 4c 00 00 00 00 e9 44 fe ff ff <0f> 0b 0f 0b 0f 0b 41 8b 7d 74 85 ff 0f 85 91 01 00 00 49 8b 95 c0
> >[Mon Oct 10 18:22:24 2022] RSP: 0018:ffffa2d38c780838 EFLAGS: 00010246
> >[Mon Oct 10 18:22:24 2022] RAX: ffff8954dd8312c0 RBX: ffff89293fbde300 RCX: ffff8957bd3d2fa0
> >[Mon Oct 10 18:22:24 2022] RDX: 0000000000000000 RSI: ffff89293fbde2c0 RDI: ffffffffffffffff
> >[Mon Oct 10 18:22:24 2022] RBP: ffffa2d38c780908 R08: 0000000000009db6 R09: 0000000000000000
> >[Mon Oct 10 18:22:24 2022] R10: 000000000000a356 R11: 000000000000a31a R12: 000000000000000b
> >[Mon Oct 10 18:22:24 2022] R13: ffff892940566100 R14: 000000000000a31a R15: ffff891ad0e5c600
> >[Mon Oct 10 18:22:24 2022] FS:  0000000000000000(0000) GS:ffff8948b9b80000(0000) knlGS:0000000000000000
> >[Mon Oct 10 18:22:24 2022] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >[Mon Oct 10 18:22:24 2022] CR2: 000000c011faf000 CR3: 0000000d66a0a001 CR4: 00000000007706e0
> >[Mon Oct 10 18:22:24 2022] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >[Mon Oct 10 18:22:24 2022] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >[Mon Oct 10 18:22:24 2022] PKRU: 55555554
> >[Mon Oct 10 18:22:24 2022] Call Trace:
> >[Mon Oct 10 18:22:24 2022]  <IRQ>
> >[Mon Oct 10 18:22:24 2022] ? csum_block_add_ext (include/net/checksum.h:117)
> >[Mon Oct 10 18:22:24 2022] ? reqsk_fastopen_remove (include/linux/bitops.h:119 include/net/checksum.h:87 include/net/checksum.h:94 include/net/checksum.h:100)
> >[Mon Oct 10 18:22:24 2022] tcp_gso_segment (net/ipv4/tcp_offload.c:99)
> >[Mon Oct 10 18:22:24 2022] inet_gso_segment (net/ipv4/af_inet.c:1385)
> >[Mon Oct 10 18:22:24 2022] skb_mac_gso_segment (net/core/dev.c:3339)
> >[Mon Oct 10 18:22:24 2022] __skb_gso_segment (net/core/dev.c:3414 (discriminator 3))
> >[Mon Oct 10 18:22:24 2022] ? netif_skb_features (include/net/mpls.h:21 net/core/dev.c:3463 net/core/dev.c:3483 net/core/dev.c:3574)
> >[Mon Oct 10 18:22:24 2022] validate_xmit_skb.constprop.0 (net/core/dev.c:3672)
> >[Mon Oct 10 18:22:24 2022] validate_xmit_skb_list (net/core/dev.c:3722)
> >[Mon Oct 10 18:22:24 2022] sch_direct_xmit (net/sched/sch_generic.c:327)
> >[Mon Oct 10 18:22:24 2022] __dev_queue_xmit (net/core/dev.c:3858 net/core/dev.c:4185)
> >[Mon Oct 10 18:22:24 2022] ip_finish_output2 (include/net/neighbour.h:500 include/net/neighbour.h:514 net/ipv4/ip_output.c:228)
> >[Mon Oct 10 18:22:24 2022] ? ip_route_input_rcu (net/ipv4/route.c:1745 net/ipv4/route.c:2499 net/ipv4/route.c:2458)
> >[Mon Oct 10 18:22:24 2022] ? skb_gso_validate_network_len (net/core/skbuff.c:5561 net/core/skbuff.c:5636)
> >[Mon Oct 10 18:22:24 2022] ? __ip_finish_output (net/ipv4/ip_output.c:249 net/ipv4/ip_output.c:301 net/ipv4/ip_output.c:288)
> >[Mon Oct 10 18:22:24 2022] ip_sublist_rcv_finish (include/net/dst.h:460 net/ipv4/ip_input.c:565)
> >[Mon Oct 10 18:22:24 2022] ip_sublist_rcv (net/ipv4/ip_input.c:624)
> >[Mon Oct 10 18:22:24 2022] ? ip_sublist_rcv (net/ipv4/ip_input.c:422)
> >[Mon Oct 10 18:22:24 2022] ip_list_rcv (net/ipv4/ip_input.c:659)
> >[Mon Oct 10 18:22:24 2022] __netif_receive_skb_list_core (net/core/dev.c:5498 net/core/dev.c:5546)
> >[Mon Oct 10 18:22:24 2022] netif_receive_skb_list_internal (net/core/dev.c:5600 net/core/dev.c:5689)
> >[Mon Oct 10 18:22:24 2022] ? inet_gro_complete (net/ipv4/af_inet.c:1645)
> >[Mon Oct 10 18:22:24 2022] napi_gro_complete.constprop.0.isra.0 (include/linux/list.h:35 net/core/dev.c:5844 net/core/dev.c:5839 net/core/dev.c:5856 net/core/dev.c:5892)
> >[Mon Oct 10 18:22:24 2022] dev_gro_receive (net/core/dev.c:6119)
> >[Mon Oct 10 18:22:24 2022] napi_gro_receive (net/core/dev.c:6223)
> >[Mon Oct 10 18:22:24 2022]  0xffffffffc069d699
> >[Mon Oct 10 18:22:24 2022] ? scheduler_tick (kernel/sched/core.c:7053 kernel/sched/core.c:5278)
> >[Mon Oct 10 18:22:24 2022] __napi_poll (net/core/dev.c:7005)
> >[Mon Oct 10 18:22:24 2022] net_rx_action (net/core/dev.c:7074 net/core/dev.c:7159)
> >[Mon Oct 10 18:22:24 2022] __do_softirq (arch/x86/include/asm/jump_label.h:27 include/linux/jump_label.h:212 include/trace/events/irq.h:142 kernel/softirq.c:559)
> >[Mon Oct 10 18:22:24 2022] irq_exit_rcu (kernel/softirq.c:432 kernel/softirq.c:636 kernel/softirq.c:648)
> >[Mon Oct 10 18:22:24 2022] common_interrupt (arch/x86/kernel/irq.c:240 (discriminator 14))
> >[Mon Oct 10 18:22:24 2022]  </IRQ>
> >[Mon Oct 10 18:22:24 2022]  <TASK>
> >[Mon Oct 10 18:22:24 2022]  asm_common_interrupt+0x21/0x40
> >[Mon Oct 10 18:22:24 2022] RIP: 0010:cpuidle_enter_state+0xc7/0x350
> >[Mon Oct 10 18:22:24 2022] Code: 8b 3d f5 e1 9b 4d e8 08 bb a7 ff 49 89 c5 0f 1f 44 00 00 31 ff e8 09 c9 a7 ff 45 84 ff 0f 85 fe 00 00 00 fb 66 0f 1f 44 00 00 <45> 85 f6 0f 88 0a 01 00 00 49 63 c6 4c 2b 2c 24 48 8d 14 40 48 8d
> >[Mon Oct 10 18:22:24 2022] RSP: 0018:ffffa2d38c527ea8 EFLAGS: 00000246
> >[Mon Oct 10 18:22:24 2022] RAX: ffff8948b9bac100 RBX: 0000000000000003 RCX: 00000000ffffffff
> >[Mon Oct 10 18:22:24 2022] RDX: 0000000000000006 RSI: 0000000000000006 RDI: 0000000000000000
> >[Mon Oct 10 18:22:24 2022] RBP: ffff8948b9bb6000 R08: 0000043f38b90644 R09: 0000043f6c0b1df3
> >[Mon Oct 10 18:22:24 2022] R10: 0000000000000014 R11: 0000000000000008 R12: ffffffffb3bbd7e0
> >[Mon Oct 10 18:22:24 2022] R13: 0000043f38b90644 R14: 0000000000000003 R15: 0000000000000000
> >[Mon Oct 10 18:22:24 2022]  ? cpuidle_enter_state+0xb7/0x350
> >[Mon Oct 10 18:22:24 2022]  cpuidle_enter+0x29/0x40
> >[Mon Oct 10 18:22:24 2022]  do_idle+0x1e9/0x280
> >[Mon Oct 10 18:22:24 2022]  cpu_startup_entry+0x19/0x20
> >[Mon Oct 10 18:22:24 2022]  secondary_startup_64_no_verify+0xc2/0xcb
> >[Mon Oct 10 18:22:24 2022]  </TASK>
> >[Mon Oct 10 18:22:24 2022] Modules linked in: xt_CT ip_set_hash_net ip_set vxlan cls_bpf sch_ingress veth xt_comment xt_mark xt_conntrack nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo nft_counter xt_addrtype nft_compat nf_tables nfnetlink nls_ascii nls_cp437 vfat fat mousedev intel_rapl_msr intel_rapl_common psmouse evdev i2c_piix4 i2c_core button sch_fq_codel fuse configfs ext4 crc16 mbcache jbd2 dm_verity dm_bufio aesni_intel nvme nvme_core libaes crypto_simd ena cryptd t10_pi crc_t10dif crct10dif_generic crct10dif_common btrfs blake2b_generic zstd_compress lzo_compress raid6_pq libcrc32c crc32c_generic crc32c_intel dm_mirror dm_region_hash dm_log dm_mod qla4xxx iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi br_netfilter bridge scsi_transport_iscsi stp llc overlay scsi_mod scsi_common
> >[Mon Oct 10 18:22:24 2022] ---[ end trace 86a2732b8f4d0b13 ]---
> >
> >Disabling GSO/GRO *seems* to prevent the BUG_ON() from getting hit but is too
> >costly in terms of performance. There are also suggestions that this happens
> >more often under heavy network load, and has also been observed when running on
> >Vmware.
> >
> >If anyone has any suggestions or needs more information to come up with a
> >theory, we'd love to get to the bottom of this.
> >
> >Jeremi
