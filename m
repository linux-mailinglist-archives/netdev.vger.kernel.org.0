Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AB245B8A4
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 11:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241593AbhKXKvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 05:51:03 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21990 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241596AbhKXKvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 05:51:02 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AO9id6W016299;
        Wed, 24 Nov 2021 10:47:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=jiUIRAA4MTSqSq33RTjwb8SUyrsQk/bsBFe7Zodl87w=;
 b=QSeIR/1jmMoxTRLzR/AE0blb5Poag5d1CEqpk7AQZxvHrR+HY+KHCM2gRxhl/AflHAOW
 Q7IW1T2iHGF0OaDsLRCiaQL5/ypvJnYixI5diibEfthFzx/zl/QHnmHNSDwVze/4QiyT
 oHt9qyRya5xzxAb3ZgUsUmIGDYJnSEUnKi5ozPHzFTVQGftVcP11EE/BhlILXRoraTgW
 ky6llUr4HZBzNDybcTY8I6CmoZh8levoU7EuDFo5M/svvUa5gHQDI9CSA51C4bfHWzVP
 wxp/v5zCcR0/kp1yO8ua5CXI5QzsqCwRfoiSFQyFYGlYfROP+80Se6JMN8I/0hYySeJN og== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg55g94cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 10:47:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOAjYg8026893;
        Wed, 24 Nov 2021 10:47:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3ch5th4qgm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 10:47:43 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1AOAlg1P034603;
        Wed, 24 Nov 2021 10:47:42 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by userp3020.oracle.com with ESMTP id 3ch5th4qf2-1;
        Wed, 24 Nov 2021 10:47:42 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     harshit.m.mogalapalli@oracle.com, vijayendra.suman@oracle.com,
        ramanan.govindarajan@oracle.com, george.kennedy@oracle.com,
        eric.dumazet@gmail.com, syzkaller <syzkaller@googlegroups.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: sched: sch_netem: Fix a divide error in netem_enqueue during randomized corruption.
Date:   Wed, 24 Nov 2021 02:47:15 -0800
Message-Id: <20211124104716.25882-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: miXYQdrgZSsq6gDU5mQGwYepf7dmlqmY
X-Proofpoint-GUID: miXYQdrgZSsq6gDU5mQGwYepf7dmlqmY
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In netem_enqueue function the value of skb_headlen(skb) can be zero
which leads to a division error during randomized corruption of the
packet. This fix  adds a check to skb_headlen(skb) to prevent the division
error.

Crash report:
[  343.170349] netdevsim netdevsim0 netdevsim3: set [1, 0] type 2 family
0 port 6081 - 0
[  343.216110] netem: version 1.3
[  343.235841] divide error: 0000 [#1] PREEMPT SMP KASAN NOPTI
[  343.236680] CPU: 3 PID: 4288 Comm: reproducer Not tainted 5.16.0-rc1+
[  343.237569] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.11.0-2.el7 04/01/2014
[  343.238707] RIP: 0010:netem_enqueue+0x1590/0x33c0 [sch_netem]
[  343.239499] Code: 89 85 58 ff ff ff e8 5f 5d e9 d3 48 8b b5 48 ff ff
ff 8b 8d 50 ff ff ff 8b 85 58 ff ff ff 48 8b bd 70 ff ff ff 31 d2 2b 4f
74 <f7> f1 48 b8 00 00 00 00 00 fc ff df 49 01 d5 4c 89 e9 48 c1 e9 03
[  343.241883] RSP: 0018:ffff88800bcd7368 EFLAGS: 00010246
[  343.242589] RAX: 00000000ba7c0a9c RBX: 0000000000000001 RCX:
0000000000000000
[  343.243542] RDX: 0000000000000000 RSI: ffff88800f8edb10 RDI:
ffff88800f8eda40
[  343.244474] RBP: ffff88800bcd7458 R08: 0000000000000000 R09:
ffffffff94fb8445
[  343.245403] R10: ffffffff94fb8336 R11: ffffffff94fb8445 R12:
0000000000000000
[  343.246355] R13: ffff88800a5a7000 R14: ffff88800a5b5800 R15:
0000000000000020
[  343.247291] FS:  00007fdde2bd7700(0000) GS:ffff888109780000(0000)
knlGS:0000000000000000
[  343.248350] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  343.249120] CR2: 00000000200000c0 CR3: 000000000ef4c000 CR4:
00000000000006e0
[  343.250076] Call Trace:
[  343.250423]  <TASK>
[  343.250713]  ? memcpy+0x4d/0x60
[  343.251162]  ? netem_init+0xa0/0xa0 [sch_netem]
[  343.251795]  ? __sanitizer_cov_trace_pc+0x21/0x60
[  343.252443]  netem_enqueue+0xe28/0x33c0 [sch_netem]
[  343.253102]  ? stack_trace_save+0x87/0xb0
[  343.253655]  ? filter_irq_stacks+0xb0/0xb0
[  343.254220]  ? netem_init+0xa0/0xa0 [sch_netem]
[  343.254837]  ? __kasan_check_write+0x14/0x20
[  343.255418]  ? _raw_spin_lock+0x88/0xd6
[  343.255953]  dev_qdisc_enqueue+0x50/0x180
[  343.256508]  __dev_queue_xmit+0x1a7e/0x3090
[  343.257083]  ? netdev_core_pick_tx+0x300/0x300
[  343.257690]  ? check_kcov_mode+0x10/0x40
[  343.258219]  ? _raw_spin_unlock_irqrestore+0x29/0x40
[  343.258899]  ? __kasan_init_slab_obj+0x24/0x30
[  343.259529]  ? setup_object.isra.71+0x23/0x90
[  343.260121]  ? new_slab+0x26e/0x4b0
[  343.260609]  ? kasan_poison+0x3a/0x50
[  343.261118]  ? kasan_unpoison+0x28/0x50
[  343.261637]  ? __kasan_slab_alloc+0x71/0x90
[  343.262214]  ? memcpy+0x4d/0x60
[  343.262674]  ? write_comp_data+0x2f/0x90
[  343.263209]  ? __kasan_check_write+0x14/0x20
[  343.263802]  ? __skb_clone+0x5d6/0x840
[  343.264329]  ? __sanitizer_cov_trace_pc+0x21/0x60
[  343.264958]  dev_queue_xmit+0x1c/0x20
[  343.265470]  netlink_deliver_tap+0x652/0x9c0
[  343.266067]  netlink_unicast+0x5a0/0x7f0
[  343.266608]  ? netlink_attachskb+0x860/0x860
[  343.267183]  ? __sanitizer_cov_trace_pc+0x21/0x60
[  343.267820]  ? write_comp_data+0x2f/0x90
[  343.268367]  netlink_sendmsg+0x922/0xe80
[  343.268899]  ? netlink_unicast+0x7f0/0x7f0
[  343.269472]  ? __sanitizer_cov_trace_pc+0x21/0x60
[  343.270099]  ? write_comp_data+0x2f/0x90
[  343.270644]  ? netlink_unicast+0x7f0/0x7f0
[  343.271210]  sock_sendmsg+0x155/0x190
[  343.271721]  ____sys_sendmsg+0x75f/0x8f0
[  343.272262]  ? kernel_sendmsg+0x60/0x60
[  343.272788]  ? write_comp_data+0x2f/0x90
[  343.273332]  ? write_comp_data+0x2f/0x90
[  343.273869]  ___sys_sendmsg+0x10f/0x190
[  343.274405]  ? sendmsg_copy_msghdr+0x80/0x80
[  343.274984]  ? slab_post_alloc_hook+0x70/0x230
[  343.275597]  ? futex_wait_setup+0x240/0x240
[  343.276175]  ? security_file_alloc+0x3e/0x170
[  343.276779]  ? write_comp_data+0x2f/0x90
[  343.277313]  ? __sanitizer_cov_trace_pc+0x21/0x60
[  343.277969]  ? write_comp_data+0x2f/0x90
[  343.278515]  ? __fget_files+0x1ad/0x260
[  343.279048]  ? __sanitizer_cov_trace_pc+0x21/0x60
[  343.279685]  ? write_comp_data+0x2f/0x90
[  343.280234]  ? __sanitizer_cov_trace_pc+0x21/0x60
[  343.280874]  ? sockfd_lookup_light+0xd1/0x190
[  343.281481]  __sys_sendmsg+0x118/0x200
[  343.281998]  ? __sys_sendmsg_sock+0x40/0x40
[  343.282578]  ? alloc_fd+0x229/0x5e0
[  343.283070]  ? write_comp_data+0x2f/0x90
[  343.283610]  ? write_comp_data+0x2f/0x90
[  343.284135]  ? __sanitizer_cov_trace_pc+0x21/0x60
[  343.284776]  ? ktime_get_coarse_real_ts64+0xb8/0xf0
[  343.285450]  __x64_sys_sendmsg+0x7d/0xc0
[  343.285981]  ? syscall_enter_from_user_mode+0x4d/0x70
[  343.286664]  do_syscall_64+0x3a/0x80
[  343.287158]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  343.287850] RIP: 0033:0x7fdde24cf289
[  343.288344] Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00
48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b7 db 2c 00 f7 d8 64 89 01 48
[  343.290729] RSP: 002b:00007fdde2bd6d98 EFLAGS: 00000246 ORIG_RAX:
000000000000002e
[  343.291730] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007fdde24cf289
[  343.292673] RDX: 0000000000000000 RSI: 00000000200000c0 RDI:
0000000000000004
[  343.293618] RBP: 00007fdde2bd6e20 R08: 0000000100000001 R09:
0000000000000000
[  343.294557] R10: 0000000100000001 R11: 0000000000000246 R12:
0000000000000000
[  343.295493] R13: 0000000000021000 R14: 0000000000000000 R15:
00007fdde2bd7700
[  343.296432]  </TASK>
[  343.296735] Modules linked in: sch_netem ip6_vti ip_vti ip_gre ipip
sit ip_tunnel geneve macsec macvtap tap ipvlan macvlan 8021q garp mrp
hsr wireguard libchacha20poly1305 chacha_x86_64 poly1305_x86_64
ip6_udp_tunnel udp_tunnel libblake2s blake2s_x86_64 libblake2s_generic
curve25519_x86_64 libcurve25519_generic libchacha xfrm_interface
xfrm6_tunnel tunnel4 veth netdevsim psample batman_adv nlmon dummy team
bonding tls vcan ip6_gre ip6_tunnel tunnel6 gre tun ip6t_rpfilter
ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set
ebtable_nat ebtable_broute ip6table_nat ip6table_mangle
ip6table_security ip6table_raw iptable_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 iptable_mangle iptable_security
iptable_raw ebtable_filter ebtables rfkill ip6table_filter ip6_tables
iptable_filter ppdev bochs drm_vram_helper drm_ttm_helper ttm
drm_kms_helper cec parport_pc drm joydev floppy parport sg syscopyarea
sysfillrect sysimgblt i2c_piix4 qemu_fw_cfg fb_sys_fops pcspkr
[  343.297459]  ip_tables xfs virtio_net net_failover failover sd_mod
sr_mod cdrom t10_pi ata_generic pata_acpi ata_piix libata virtio_pci
virtio_pci_legacy_dev serio_raw virtio_pci_modern_dev dm_mirror
dm_region_hash dm_log dm_mod
[  343.311074] Dumping ftrace buffer:
[  343.311532]    (ftrace buffer empty)
[  343.312040] ---[ end trace a2e3db5a6ae05099 ]---
[  343.312691] RIP: 0010:netem_enqueue+0x1590/0x33c0 [sch_netem]
[  343.313481] Code: 89 85 58 ff ff ff e8 5f 5d e9 d3 48 8b b5 48 ff ff
ff 8b 8d 50 ff ff ff 8b 85 58 ff ff ff 48 8b bd 70 ff ff ff 31 d2 2b 4f
74 <f7> f1 48 b8 00 00 00 00 00 fc ff df 49 01 d5 4c 89 e9 48 c1 e9 03
[  343.315893] RSP: 0018:ffff88800bcd7368 EFLAGS: 00010246
[  343.316622] RAX: 00000000ba7c0a9c RBX: 0000000000000001 RCX:
0000000000000000
[  343.317585] RDX: 0000000000000000 RSI: ffff88800f8edb10 RDI:
ffff88800f8eda40
[  343.318549] RBP: ffff88800bcd7458 R08: 0000000000000000 R09:
ffffffff94fb8445
[  343.319503] R10: ffffffff94fb8336 R11: ffffffff94fb8445 R12:
0000000000000000
[  343.320455] R13: ffff88800a5a7000 R14: ffff88800a5b5800 R15:
0000000000000020
[  343.321414] FS:  00007fdde2bd7700(0000) GS:ffff888109780000(0000)
knlGS:0000000000000000
[  343.322489] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  343.323283] CR2: 00000000200000c0 CR3: 000000000ef4c000 CR4:
00000000000006e0
[  343.324264] Kernel panic - not syncing: Fatal exception in interrupt
[  343.333717] Dumping ftrace buffer:
[  343.334175]    (ftrace buffer empty)
[  343.334653] Kernel Offset: 0x13600000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  343.336027] Rebooting in 86400 seconds..

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
Changes v1->v2: Removed dropping of packet and just added a check on
skb_headlen before corruption.

 net/sched/sch_netem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index ecbb10db1111..13be8054a92d 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -513,8 +513,9 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			goto finish_segs;
 		}
 
-		skb->data[prandom_u32() % skb_headlen(skb)] ^=
-			1<<(prandom_u32() % 8);
+		if (likely(skb_headlen(skb)))
+			skb->data[prandom_u32() % skb_headlen(skb)] ^=
+				1<<(prandom_u32() % 8);
 	}
 
 	if (unlikely(sch->q.qlen >= sch->limit)) {
-- 
2.27.0

