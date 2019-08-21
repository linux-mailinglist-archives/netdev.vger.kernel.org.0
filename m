Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32F2C96F3F
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 04:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfHUCKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 22:10:15 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34753 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfHUCKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 22:10:15 -0400
Received: by mail-pl1-f196.google.com with SMTP id d3so444491plr.1
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 19:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M1H7DGjM9bZ46c2uuq51YFz6ISkLkw8ag4maW1na3iE=;
        b=Ffw9dnfNemKGSWx9ST9l8+Jot3dkPb5F/rJPpBixj6HRoGrm55ZXl8rneLpBwcB6+5
         VINWL5ES3BwbSiIbdRe7tjW5WpYTLUz5VnZTcH/RlcD4vlU3goERShX5uxYlL8FSTFA5
         neRRPeVO1H29GnlJgEBOd6IAHgmkSzdgfxlJoSOAAQ6bp33LwW5e/B4qaU8bRM7enq9I
         0uD0JVLpllMGoOmFsEpRARNALNzJr19vDnsEfVPZwf7C/dzAePRi+g/kWQg3MLx5nRpH
         0vHLVc9IqeCHd518poo/yMx+vz+PrOeq5+KJ7I0RQcxDKwJT/gAoCNdGsejHd7/BVnye
         orQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M1H7DGjM9bZ46c2uuq51YFz6ISkLkw8ag4maW1na3iE=;
        b=RciaXo6OcT1xv1N67XdY4Qs5l+0vS7UDUM1WRxxDamzbybVRNz/e3rLjH7H7UGEA9t
         WMlfxjLLXzXW9PgpbJgCNeCPY8YAxfakRMTaUPyow43vuG0VakG7RLmS5gIvIaJRKzPP
         EmduryZp9M2VqzODlB2lkrCKRAh5BwJGNr+3proSF/5eBT29myKVtn5dAqTs/tErJ5X4
         oRhw3WXcuHUbiwyc1KOMGG7skHQe1GDIVufPgqjFNQJVoxYGCUDFL2blognTeRc/fVxU
         0jeXpllq+/mDI5+C4PCkJCNcFsEYRziO7WjpG5OCEWTv3R0enqyJwmX7ymsQyJQq8YkP
         AD4A==
X-Gm-Message-State: APjAAAUsgXAg2ObJUJfLBAykfdAlGuWbQgFlk9Bv3V8W/cZuuXwuB3K2
        FlXTcyaquuZJXHFXyQlWFxge3ER4KoQ=
X-Google-Smtp-Source: APXvYqxF1pdhFoIJaEOg1eBrP/LIxP5Wp05veVOKfLkckPh7M97y9P8WXLY3BPJirJpkC42r3HdmaQ==
X-Received: by 2002:a17:902:1123:: with SMTP id d32mr492200pla.218.1566353413492;
        Tue, 20 Aug 2019 19:10:13 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k3sm36717073pfg.23.2019.08.20.19.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 19:10:12 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, wenxu <wenxu@ucloud.cn>,
        Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 0/2] fix dev null pointer dereference when send packets larger than mtu in collect_md mode
Date:   Wed, 21 Aug 2019 10:09:52 +0800
Message-Id: <20190821020954.21165-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190815060904.19426-1-liuhangbin@gmail.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we send a packet larger than PMTU, we need to reply with
icmp_send(ICMP_FRAG_NEEDED) or icmpv6_send(ICMPV6_PKT_TOOBIG).

But with collect_md mode, kernel will crash while accessing the dst dev
as __metadata_dst_init() init dst->dev to NULL by default. Here is what
the code path looks like, for GRE:

- ip6gre_tunnel_xmit
  - ip6gre_xmit_ipv4
    - __gre6_xmit
      - ip6_tnl_xmit
        - if skb->len - t->tun_hlen - eth_hlen > mtu; return -EMSGSIZE
    - icmp_send
      - net = dev_net(rt->dst.dev); <-- here
  - ip6gre_xmit_ipv6
    - __gre6_xmit
      - ip6_tnl_xmit
        - if skb->len - t->tun_hlen - eth_hlen > mtu; return -EMSGSIZE
    - icmpv6_send
      ...
      - decode_session4
        - oif = skb_dst(skb)->dev->ifindex; <-- here
      - decode_session6
        - oif = skb_dst(skb)->dev->ifindex; <-- here

We could not fix it in __metadata_dst_init() as there is no dev supplied.
Look in to the __icmp_send()/decode_session{4,6} code we could find the dst
dev is actually not needed. In __icmp_send(), we could get the net by skb->dev.
For decode_session{4,6}, as it was called by xfrm_decode_session_reverse()
in this scenario, the oif is not used by
fl4->flowi4_oif = reverse ? skb->skb_iif : oif;

The reproducer is easy:

ovs-vsctl add-br br0
ip link set br0 up
ovs-vsctl add-port br0 gre0 -- set interface gre0 type=gre options:remote_ip=$dst_addr
ip link set gre0 up
ip addr add ${local_gre6}/64 dev br0
ping6 $remote_gre6 -s 1500

The kernel will crash like
[40595.821651] BUG: kernel NULL pointer dereference, address: 0000000000000108
[40595.822411] #PF: supervisor read access in kernel mode
[40595.822949] #PF: error_code(0x0000) - not-present page
[40595.823492] PGD 0 P4D 0
[40595.823767] Oops: 0000 [#1] SMP PTI
[40595.824139] CPU: 0 PID: 2831 Comm: handler12 Not tainted 5.2.0 #57
[40595.824788] Hardware name: Red Hat KVM, BIOS 1.11.1-3.module+el8.1.0+2983+b2ae9c0a 04/01/2014
[40595.825680] RIP: 0010:__xfrm_decode_session+0x6b/0x930
[40595.826219] Code: b7 c0 00 00 00 b8 06 00 00 00 66 85 d2 0f b7 ca 48 0f 45 c1 44 0f b6 2c 06 48 8b 47 58 48 83 e0 fe 0f 84 f4 04 00 00 48 8b 00 <44> 8b 80 08 01 00 00 41 f6 c4 01 4c 89 e7
ba 58 00 00 00 0f 85 47
[40595.828155] RSP: 0018:ffffc90000a73438 EFLAGS: 00010286
[40595.828705] RAX: 0000000000000000 RBX: ffff8881329d7100 RCX: 0000000000000000
[40595.829450] RDX: 0000000000000000 RSI: ffff8881339e70ce RDI: ffff8881329d7100
[40595.830191] RBP: ffffc90000a73470 R08: 0000000000000000 R09: 000000000000000a
[40595.830936] R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90000a73490
[40595.831682] R13: 000000000000002c R14: ffff888132ff1301 R15: ffff8881329d7100
[40595.832427] FS:  00007f5bfcfd6700(0000) GS:ffff88813ba00000(0000) knlGS:0000000000000000
[40595.833266] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[40595.833883] CR2: 0000000000000108 CR3: 000000013a368000 CR4: 00000000000006f0
[40595.834633] Call Trace:
[40595.835392]  ? rt6_multipath_hash+0x4c/0x390
[40595.835853]  icmpv6_route_lookup+0xcb/0x1d0
[40595.836296]  ? icmpv6_xrlim_allow+0x3e/0x140
[40595.836751]  icmp6_send+0x537/0x840
[40595.837125]  icmpv6_send+0x20/0x30
[40595.837494]  tnl_update_pmtu.isra.27+0x19d/0x2a0 [ip_tunnel]
[40595.838088]  ip_md_tunnel_xmit+0x1b6/0x510 [ip_tunnel]
[40595.838633]  gre_tap_xmit+0x10c/0x160 [ip_gre]
[40595.839103]  dev_hard_start_xmit+0x93/0x200
[40595.839551]  sch_direct_xmit+0x101/0x2d0
[40595.839967]  __dev_queue_xmit+0x69f/0x9c0
[40595.840399]  do_execute_actions+0x1717/0x1910 [openvswitch]
[40595.840987]  ? validate_set.isra.12+0x2f5/0x3d0 [openvswitch]
[40595.841596]  ? reserve_sfa_size+0x31/0x130 [openvswitch]
[40595.842154]  ? __ovs_nla_copy_actions+0x1b4/0xad0 [openvswitch]
[40595.842778]  ? __kmalloc_reserve.isra.50+0x2e/0x80
[40595.843285]  ? should_failslab+0xa/0x20
[40595.843696]  ? __kmalloc+0x188/0x220
[40595.844078]  ? __alloc_skb+0x97/0x270
[40595.844472]  ovs_execute_actions+0x47/0x120 [openvswitch]
[40595.845041]  ovs_packet_cmd_execute+0x27d/0x2b0 [openvswitch]
[40595.845648]  genl_family_rcv_msg+0x3a8/0x430
[40595.846101]  genl_rcv_msg+0x47/0x90
[40595.846476]  ? __alloc_skb+0x83/0x270
[40595.846866]  ? genl_family_rcv_msg+0x430/0x430
[40595.847335]  netlink_rcv_skb+0xcb/0x100
[40595.847777]  genl_rcv+0x24/0x40
[40595.848113]  netlink_unicast+0x17f/0x230
[40595.848535]  netlink_sendmsg+0x2ed/0x3e0
[40595.848951]  sock_sendmsg+0x4f/0x60
[40595.849323]  ___sys_sendmsg+0x2bd/0x2e0
[40595.849733]  ? sock_poll+0x6f/0xb0
[40595.850098]  ? ep_scan_ready_list.isra.14+0x20b/0x240
[40595.850634]  ? _cond_resched+0x15/0x30
[40595.851032]  ? ep_poll+0x11b/0x440
[40595.851401]  ? _copy_to_user+0x22/0x30
[40595.851799]  __sys_sendmsg+0x58/0xa0
[40595.852180]  do_syscall_64+0x5b/0x190
[40595.852574]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[40595.853105] RIP: 0033:0x7f5c00038c7d
[40595.853489] Code: c7 20 00 00 75 10 b8 2e 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 8e f7 ff ff 48 89 04 24 b8 2e 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 d7 f7 ff ff 48 89
d0 48 83 c4 08 48 3d 01
[40595.855443] RSP: 002b:00007f5bfcf73c00 EFLAGS: 00003293 ORIG_RAX: 000000000000002e
[40595.856244] RAX: ffffffffffffffda RBX: 00007f5bfcf74a60 RCX: 00007f5c00038c7d
[40595.856990] RDX: 0000000000000000 RSI: 00007f5bfcf73c60 RDI: 0000000000000015
[40595.857736] RBP: 0000000000000004 R08: 0000000000000b7c R09: 0000000000000110
[40595.858613] R10: 0001000800050004 R11: 0000000000003293 R12: 000055c2d8329da0
[40595.859401] R13: 00007f5bfcf74120 R14: 0000000000000347 R15: 00007f5bfcf73c60
[40595.860185] Modules linked in: ip_gre ip_tunnel gre openvswitch nsh nf_conncount nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 sunrpc bochs_drm ttm drm_kms_helper drm pcspkr joydev i2c_piix4 qemu_fw_cfg xfs libcrc32c virtio_net net_failover serio_raw failover ata_generic virtio_blk pata_acpi floppy
[40595.863155] CR2: 0000000000000108
[40595.863551] ---[ end trace 22209bbcacb4addd ]---

v3: only replace pkg to packets in cover letter. So I didn't update the version
info in the follow up patches.

v2: fix it in __icmp_send() and decode_session{4,6} separately instead of
updating shared dst dev in {ip_md, ip6}_tunnel_xmit.

Hangbin Liu (2):
  ipv4/icmp: fix rt dst dev null pointer dereference
  xfrm/xfrm_policy: fix dst dev null pointer dereference in collect_md
    mode

 net/ipv4/icmp.c        | 5 ++++-
 net/xfrm/xfrm_policy.c | 4 ++--
 2 files changed, 6 insertions(+), 3 deletions(-)

-- 
2.19.2

