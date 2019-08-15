Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76CC68E4C6
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 08:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbfHOGJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 02:09:21 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40142 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfHOGJV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 02:09:21 -0400
Received: by mail-pf1-f193.google.com with SMTP id w16so853162pfn.7
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 23:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H0FUUKrFlqdWump7W1EUv5nga0iBe170uSdZnb39lew=;
        b=u18pL2F1DLRoM8Ut6wSIh60dYWS1Q2NYJ0T84dzm044C11i4+IYrFMCgfg06dPNvNE
         X4p1siNX0TrNjTJAf84xyyenq1IWtbvDoeVPQGEKx1hSsdMhmvYCXAy++lz3S2XFiybd
         YKIEtplgq3rmhc3sGdZP2X8g7c38Kn9k91te3vjY/InShL5DlvbKgFPYclMKd91Jl95R
         WiuJc9KohF7eQWcpubnbEJKttB+r42QSpipd0kX9I1/eA8h/r5O+YtX1YBo1ul5YKxbO
         QMSnjw2njRXViDgYAa1wTWGwwVd3Mg3E1kOj9ohmW5nPGPwReIU3CEAHzU8eiqOvMScL
         OVLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H0FUUKrFlqdWump7W1EUv5nga0iBe170uSdZnb39lew=;
        b=t06pY0nsqr9vJ3lJv83c+zIFYPtg5Y7hmcVoLuAduO+gpSBQ/mOhfDp7b3WTTOuHuz
         wnYLP70skVcLsbUAFDp5OFTS6BsqI8BV5Qu7URG1Z3IZx8Nxb8NNvMUlUNshXCEVw+bV
         uYouTepWx7rDzDy6MH6DXUpA018rbpY4U1nrHklcSMYT1DCkpttpxKrNNxPkclwUX3Rz
         1tvXMuL8WcfjblwdQ4O8LceX4bcEwR4tQmCQqo3aRSSnkXfNAMxlHxh68byfZGAbJzAx
         0Th3126SPP6W2sAgjx/P8JzwtVUYKJ1lodeQByGy7fUHJZ3yz2s3B74qEQGfTapUwoy3
         tITA==
X-Gm-Message-State: APjAAAVSAF8/RgW9YoKONLIiCYOJL6Rq0gRDmxNqwMpJFEvW3e1ih3my
        J6TQ2qh3OvCln5EegvZWGG3Gy48KNnG9RQ==
X-Google-Smtp-Source: APXvYqx71Wv5m7J7dqf/7PuakzdQ257NFftF6Dr3hmL1nc5D0Yt5OUtfnenwkE/oZ3fkdr+1S48PaQ==
X-Received: by 2002:a17:90a:b102:: with SMTP id z2mr808339pjq.91.1565849359971;
        Wed, 14 Aug 2019 23:09:19 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m34sm589154pje.5.2019.08.14.23.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 23:09:19 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, wenxu <wenxu@ucloud.cn>,
        Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] tunnel: fix dev null pointer dereference when send pkg larger than mtu in collect_md mode
Date:   Thu, 15 Aug 2019 14:09:04 +0800
Message-Id: <20190815060904.19426-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we send a packet larger than PMTU, we need to reply with
icmp_send(ICMP_FRAG_NEEDED) or icmpv6_send(ICMPV6_PKT_TOOBIG).

But in collect_md mode, kernel will crash while accessing the dst dev
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

Fix it by updating the dst dev if not set.

The reproducer is easy:

ovs-vsctl add-br br0
ip link set br0 up
ovs-vsctl add-port br0 gre0 -- \
	  set interface gre0 type=gre options:remote_ip=$dst_addr
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

Fixes: c8b34e680a09 ("ip_tunnel: Add tnl_update_pmtu in ip_md_tunnel_xmit")
Fixes: 8d79266bc48c ("ip6_tunnel: add collect_md mode to IPv6 tunnels")
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/ip_tunnel.c  |  3 +++
 net/ipv6/ip6_tunnel.c | 13 +++++++++----
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 38c02bb62e2c..c6713c7287df 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -597,6 +597,9 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 		goto tx_error;
 	}
 
+	if (skb_dst(skb) && !skb_dst(skb)->dev)
+		skb_dst(skb)->dev = rt->dst.dev;
+
 	if (key->tun_flags & TUNNEL_DONT_FRAGMENT)
 		df = htons(IP_DF);
 	if (tnl_update_pmtu(dev, skb, rt, df, inner_iph, tunnel_hlen,
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 754a484d35df..6ccf8f0eb8e7 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1109,10 +1109,15 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 			dst = NULL;
 			goto tx_err_link_failure;
 		}
-		if (t->parms.collect_md && ipv6_addr_any(&fl6->saddr) &&
-		    ipv6_dev_get_saddr(net, ip6_dst_idev(dst)->dev,
-				       &fl6->daddr, 0, &fl6->saddr))
-			goto tx_err_link_failure;
+		if (t->parms.collect_md) {
+			if (ipv6_addr_any(&fl6->saddr) &&
+			    ipv6_dev_get_saddr(net, ip6_dst_idev(dst)->dev,
+					       &fl6->daddr, 0, &fl6->saddr))
+				goto tx_err_link_failure;
+
+			if (skb_dst(skb) && !skb_dst(skb)->dev)
+				skb_dst(skb)->dev = dst->dev;
+		}
 		ndst = dst;
 	}
 
-- 
2.19.2

