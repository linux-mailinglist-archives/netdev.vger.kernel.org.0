Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E14E59ABEF
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 09:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245573AbiHTHN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 03:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243618AbiHTHNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 03:13:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D2D3DF30;
        Sat, 20 Aug 2022 00:13:52 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27K73qqC005180;
        Sat, 20 Aug 2022 07:13:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=dWGrWl+UMhlJQeLNhVrfQNRrr4ww1miYbYawyZs4VUM=;
 b=u1ve8juOr6vqm4Lj2Mp4xn6tvYqoHSg2svQrEWZgyOeO55ROnrupKhlByR0SqBxlvqw7
 Ii43OYg0JAf4/B0p5BeEfqAMVlfZwUmugoyNJl/9Ren7TXKRput4dBBzN2G1Eu1u0+/K
 DqOYAUwvNb9KdCOIcUjJkqqE9YCu/PVm5hezan/b7pdzNRPpykLXcOLJtFNaFUflwjiF
 2xggAUACXhgFGUwWspjs576xca0774E/fV0RplRqJ2SPQbK4xEWDE+aAV0uB2ussXdod
 9VbjEV7ytYzQDehlf+SciOH054f4e29sERWKxH0KupfSGSXmxjUNxSr9SS4kkC6E05/2 qg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j2tvx0085-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Aug 2022 07:13:18 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27K1WpGK035366;
        Sat, 20 Aug 2022 07:03:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j2p203r96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 20 Aug 2022 07:03:52 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27K73pYX023337;
        Sat, 20 Aug 2022 07:03:51 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.147.25.63])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3j2p203r8u-1;
        Sat, 20 Aug 2022 07:03:51 +0000
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To:     syzkaller@googlegroups.com
Cc:     harshit.m.mogalapalli@oracle.com, george.kennedy@oracle.com,
        vegard.nossum@oracle.com, john.p.donnelly@oracle.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: ebtables: fix a NULL pointer dereference in ebt_do_table()
Date:   Sat, 20 Aug 2022 00:03:29 -0700
Message-Id: <20220820070331.48817-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-20_04,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208200027
X-Proofpoint-GUID: H3nWHTMoMdOJVycV1j3LQSwuoVb8gUJO
X-Proofpoint-ORIG-GUID: H3nWHTMoMdOJVycV1j3LQSwuoVb8gUJO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ebt_do_table() function dereferencing 'private->hook_entry[hook]'
can lead to NULL pointer dereference. So add a check to prevent that.

Kernel panic:

[  119.229105][   T31] general protection fault, probably for
non-canonical address 0xdffffc0000000005: 0000 [#1] PREEMPT SMP KASAN
[  119.230280][   T31] KASAN: null-ptr-deref in range
[0x0000000000000028-0x000000000000002f]
[  119.231043][   T31] CPU: 3 PID: 31 Comm: kworker/3:0 Not tainted
6.0.0-rc1 #1
[  119.231652][   T31] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.11.0-2.el7 04/01/2014
[  119.232440][   T31] Workqueue: mld mld_ifc_work
[  119.232846][   T31] RIP: 0010:ebt_do_table+0x1dc/0x1ce0
[  119.233291][   T31] Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 5c 16
00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 6c df 08 48 8d 7d 2c 48 89 fa
48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2
0f 85 88
[  119.234920][   T31] RSP: 0018:ffffc90000347178 EFLAGS: 00010217
[  119.235425][   T31] RAX: dffffc0000000000 RBX: 0000000000000003 RCX:
ffffffff8158677b
[  119.236097][   T31] RDX: 0000000000000005 RSI: ffffffff889a7b80 RDI:
000000000000002c
[  119.236764][   T31] RBP: 0000000000000000 R08: 0000000000000001 R09:
ffff888101a78443
[  119.237425][   T31] R10: ffffed102034f088 R11: 000200100040dd86 R12:
ffffc90001111018
[  119.238100][   T31] R13: ffffc90001103080 R14: ffffc90001111000 R15:
ffffc90001103000
[  119.238769][   T31] FS:  0000000000000000(0000)
GS:ffff88811a380000(0000) knlGS:0000000000000000
[  119.239592][   T31] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  119.240221][   T31] CR2: 00007f6a9adda000 CR3: 0000000100be3000 CR4:
00000000000006e0
[  119.240970][   T31] Call Trace:
[  119.241253][   T31]  <TASK>
[  119.241495][   T31]  ? ip6_output+0x1f4/0x6e0
[  119.241877][   T31]  ? NF_HOOK.constprop.0+0xe6/0x5f0
[  119.242309][   T31]  ? mld_ifc_work+0x564/0xaa0
[  119.242708][   T31]  ? kthread+0x297/0x340
[  119.243060][   T31]  ? ret_from_fork+0x22/0x30
[  119.243454][   T31]  ? br_multicast_count+0xbf/0x8d0
[  119.243896][   T31]  ? rcu_read_lock_sched_held+0xd/0xa0
[  119.244356][   T31]  ? compat_copy_ebt_replace_from_user+0x380/0x380
[  119.244907][   T31]  ? compat_copy_ebt_replace_from_user+0x380/0x380
[  119.245454][   T31]  nf_hook_slow+0xb1/0x170
[  119.245835][   T31]  __br_forward+0x289/0x730
[  119.246219][   T31]  ? br_forward_finish+0x320/0x320
[  119.246656][   T31]  ? br_dev_queue_push_xmit+0x650/0x650
[  119.247118][   T31]  ? memcpy+0x39/0x60
[  119.247444][   T31]  ? __skb_clone+0x56c/0x750
[  119.247845][   T31]  maybe_deliver+0x24b/0x380
[  119.248234][   T31]  br_flood+0xc6/0x390
[  119.248577][   T31]  br_dev_xmit+0xa2e/0x12c0
[  119.248975][   T31]  ? rcu_read_lock_sched_held+0xd/0xa0
[  119.249498][   T31]  ? br_netpoll_setup+0x170/0x170
[  119.249987][   T31]  ? fib_rules_lookup+0x2eb/0x9d0
[  119.250462][   T31]  ? lock_repin_lock+0x30/0x420
[  119.250922][   T31]  ? rcu_read_lock_sched_held+0xd/0xa0
[  119.251376][   T31]  ? lock_acquire+0x510/0x630
[  119.251773][   T31]  ? netif_inherit_tso_max+0x1e0/0x1e0
[  119.252228][   T31]  dev_hard_start_xmit+0x151/0x660
[  119.252663][   T31]  __dev_queue_xmit+0x240e/0x3200
[  119.253080][   T31]  ? ip6mr_rtm_dumproute+0x530/0x530
[  119.253522][   T31]  ? netdev_core_pick_tx+0x2a0/0x2a0
[  119.253968][   T31]  ? unwind_next_frame+0x3de/0x1c90
[  119.254403][   T31]  ? rcu_read_lock_sched_held+0xd/0xa0
[  119.254872][   T31]  ? lock_acquire+0x510/0x630
[  119.255266][   T31]  ? rcu_read_lock_sched_held+0xd/0xa0
[  119.255724][   T31]  ? lock_release+0x5a2/0x840
[  119.256119][   T31]  ? mroute6_is_socket+0x14d/0x220
[  119.256549][   T31]  ? rcu_read_lock_sched_held+0xd/0xa0
[  119.257064][   T31]  ? lock_acquire+0x510/0x630
[  119.257507][   T31]  ? rcu_read_lock_sched_held+0xd/0xa0
[  119.258016][   T31]  ? lock_release+0x5a2/0x840
[  119.258410][   T31]  ? lock_release+0x840/0x840
[  119.258812][   T31]  ? ip6_finish_output+0x779/0x1190
[  119.259304][   T31]  ? lock_downgrade+0x7b0/0x7b0
[  119.259778][   T31]  ? rcu_read_lock_bh_held+0xd/0x90
[  119.260275][   T31]  ? ___neigh_lookup_noref.constprop.0+0x266/0x6d0
[  119.260896][   T31]  ? ip6_finish_output2+0x861/0x1690
[  119.261343][   T31]  ip6_finish_output2+0x861/0x1690
[  119.261776][   T31]  ? lock_release+0x5a2/0x840
[  119.262176][   T31]  ? __kasan_kmalloc+0x7f/0xa0
[  119.262574][   T31]  ? ip6_mtu+0x139/0x320
[  119.262942][   T31]  ? ip6_frag_next+0xcc0/0xcc0
[  119.263341][   T31]  ? rcu_read_lock_sched_held+0xd/0xa0
[  119.263816][   T31]  ? nf_ct_netns_get+0xe0/0xe0
[  119.264214][   T31]  ? rcu_read_lock_sched_held+0xd/0xa0
[  119.264679][   T31]  ? lock_release+0x5a2/0x840
[  119.265066][   T31]  ? nf_conntrack_in.cold+0x9b/0xe2
[  119.265504][   T31]  ? ip6_output+0x4c9/0x6e0
[  119.265891][   T31]  ip6_finish_output+0x779/0x1190
[  119.266315][   T31]  ? nf_hook_slow+0xb1/0x170
[  119.266711][   T31]  ip6_output+0x1f4/0x6e0
[  119.267069][   T31]  ? rcu_read_lock_sched_held+0xd/0xa0
[  119.267520][   T31]  ? ip6_finish_output+0x1190/0x1190
[  119.267969][   T31]  ? NF_HOOK.constprop.0+0x1b3/0x5f0
[  119.268415][   T31]  ? lock_pin_lock+0x184/0x380
[  119.268817][   T31]  ? ip6_fragment+0x2910/0x2910
[  119.269269][   T31]  ? nf_ct_netns_do_get+0x6c0/0x6c0
[  119.269773][   T31]  ? nf_hook_slow+0xb1/0x170
[  119.270211][   T31]  NF_HOOK.constprop.0+0xe6/0x5f0
[  119.270697][   T31]  ? igmp6_mcf_seq_next+0x460/0x460
[  119.271159][   T31]  ? igmp6_mcf_seq_stop+0x130/0x130
[  119.271600][   T31]  ? icmp6_dst_alloc+0x3dc/0x610
[  119.272030][   T31]  mld_sendpack+0x619/0xb50
[  119.272413][   T31]  ? NF_HOOK.constprop.0+0x5f0/0x5f0
[  119.272867][   T31]  ? lock_release+0x840/0x840
[  119.273254][   T31]  mld_ifc_work+0x564/0xaa0
[  119.273642][   T31]  ? pwq_activate_inactive_work+0xb2/0x190
[  119.274126][   T31]  process_one_work+0x875/0x1440
[  119.274543][   T31]  ? lock_release+0x840/0x840
[  119.274936][   T31]  ? pwq_dec_nr_in_flight+0x230/0x230
[  119.275381][   T31]  ? rwlock_bug.part.0+0x90/0x90
[  119.275801][   T31]  worker_thread+0x598/0xec0
[  119.276187][   T31]  ? process_one_work+0x1440/0x1440
[  119.276613][   T31]  kthread+0x297/0x340
[  119.276958][   T31]  ? kthread_complete_and_exit+0x20/0x20
[  119.277422][   T31]  ret_from_fork+0x22/0x30
[  119.277796][   T31]  </TASK>
[  119.278048][   T31] Modules linked in:
[  119.278377][   T31] Dumping ftrace buffer:
[  119.278733][   T31]    (ftrace buffer empty)
[  119.279151][   T31] ---[ end trace 0000000000000000 ]---
[  119.279679][   T31] RIP: 0010:ebt_do_table+0x1dc/0x1ce0
[  119.280187][   T31] Code: 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 5c 16
00 00 48 b8 00 00 00 00 00 fc ff df 49 8b 6c df 08 48 8d 7d 2c 48 89 fa
48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2
0f 85 88
[  119.282006][   T31] RSP: 0018:ffffc90000347178 EFLAGS: 00010217
[  119.282569][   T31] RAX: dffffc0000000000 RBX: 0000000000000003 RCX:
ffffffff8158677b
[  119.283308][   T31] RDX: 0000000000000005 RSI: ffffffff889a7b80 RDI:
000000000000002c
[  119.284056][   T31] RBP: 0000000000000000 R08: 0000000000000001 R09:
ffff888101a78443
[  119.284811][   T31] R10: ffffed102034f088 R11: 000200100040dd86 R12:
ffffc90001111018
[  119.285549][   T31] R13: ffffc90001103080 R14: ffffc90001111000 R15:
ffffc90001103000
[  119.286284][   T31] FS:  0000000000000000(0000)
GS:ffff88811a380000(0000) knlGS:0000000000000000
[  119.287119][   T31] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  119.287741][   T31] CR2: 00007f6a9adda000 CR3: 0000000100be3000 CR4:
00000000000006e0
[  119.288489][   T31] Kernel panic - not syncing: Fatal exception in
interrupt
[  119.298556][   T31] Dumping ftrace buffer:
[  119.298974][   T31]    (ftrace buffer empty)
[  119.299399][   T31] Kernel Offset: disabled
[  119.299823][   T31] Rebooting in 86400 seconds..

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
Testing is only done with reproducer.

 net/bridge/netfilter/ebtables.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index f2dbefb61ce8..d19d439a66c5 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -217,6 +217,11 @@ unsigned int ebt_do_table(void *priv, struct sk_buff *skb,
 	else
 		cs = NULL;
 	chaininfo = private->hook_entry[hook];
+	if (!chaininfo) {
+		read_unlock_bh(&table->lock);
+		return NF_DROP;
+	}
+
 	nentries = private->hook_entry[hook]->nentries;
 	point = (struct ebt_entry *)(private->hook_entry[hook]->data);
 	counter_base = cb_base + private->hook_entry[hook]->counter_offset;
-- 
2.31.1

