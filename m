Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3784A4BC927
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 16:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbiBSPak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 10:30:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239468AbiBSPai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 10:30:38 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E57960ABC
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 07:30:19 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id w37so4027836pga.7
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 07:30:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TWVoVvPl3J1+lplu9uDc3ZvU/uzAs+N73fw7NVvAwiY=;
        b=Q4WW6q5EmaPxltWDpzAab91aCxnESYbl95v0fyoJ2jRDpapBvuiLVuitZBhW4//yNi
         avOuhm1m3Hy8eTTA7D8lJ1CG57SgpAHT4aHGoHZeT08diS8/F6DEz/APMAHaUZgaTKFj
         +d5ftxQ+9dz62SFMlWMAvVefjK+3Z28IO4oiNUfLfb7g8T+ZDGwDm52nEPSfRbUIcf16
         bSLNISrtDg6EzuWzW2KyIzMMQJkQL6gX1AUlyMBJLJG1XvJGWBB8pKCGMMJ7Aw6bVuhG
         y6CuiLrqOMJc0gz1q8kOCTEZlZkY2xeRk53a/zODSolD4dFHfq3EIMIla9Lmg2eSyn5u
         f04g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TWVoVvPl3J1+lplu9uDc3ZvU/uzAs+N73fw7NVvAwiY=;
        b=eYF1x0RcChllWJljPJu6dniYtqVVeAc1ZrdRgJ6aeXyT/Bmm3XFrcOWyVkhSUaa/3R
         c0ZK+6os0I83SIF+Bl3njSicT1swnvE1CwM4vmePMI/GAaQIR+b3ELdbZSniZf4SIplg
         kY9L970fEaIq3DuOSLf73kvxwtIWrA0J66Krohc97pgrOB2P5TgkXagLJ+1lNn9nrU6Z
         kEquBpD6BAvoVZhhmwzXabAg1EahBSaCl6xSDpWvBGpX5V10XGyxRE7kdx/PY2yTRix2
         p6WCi9/wm91uQYfKjSe+dXgQRiRnGkE8cILqugheayulEQJdmTOC0zr5BCBMA3hrNTbx
         g64Q==
X-Gm-Message-State: AOAM530kZKzRap8rl92Aj6CZ/ZqKPX1uXDV24uRHKMBGV3y7/C7Oi/4I
        3DONtDZKHPO1AL9RyJkYq9o6Cy9kQu5hXAa8Hq4=
X-Google-Smtp-Source: ABdhPJz8cLzQZr1pJl2ON0Cn92VVgzzqpvzvFm1bf5s/bqX5//Vu/RehLpG5PO2VP39LSGv8pv8mwA==
X-Received: by 2002:a05:6a00:2788:b0:4c7:abe1:f94a with SMTP id bd8-20020a056a00278800b004c7abe1f94amr12428211pfb.66.1645284618723;
        Sat, 19 Feb 2022 07:30:18 -0800 (PST)
Received: from localhost.localdomain ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id m17-20020a17090a7f9100b001b9e4d62ed0sm2551392pjl.13.2022.02.19.07.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 07:30:18 -0800 (PST)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Cc:     ennoerlangen@gmail.com, george.mccollister@gmail.com,
        olteanv@gmail.com, marco.wenzel@a-eberle.de,
        syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
Subject: [PATCH net-next v3] net: hsr: fix suspicious RCU usage warning in hsr_node_get_first()
Date:   Sat, 19 Feb 2022 15:29:59 +0000
Message-Id: <20220219152959.5761-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When hsr_create_self_node() calls hsr_node_get_first(), the suspicious
RCU usage warning is occurred. The reason why this warning is raised is
the callers of hsr_node_get_first() use rcu_read_lock_bh() and
other different synchronization mechanisms. Thus, this patch solved by
replacing rcu_dereference() with rcu_dereference_bh_check().

The kernel test robot reports:
    [   50.083470][ T3596] =============================
    [   50.088648][ T3596] WARNING: suspicious RCU usage
    [   50.093785][ T3596] 5.17.0-rc3-next-20220208-syzkaller #0 Not tainted
    [   50.100669][ T3596] -----------------------------
    [   50.105513][ T3596] net/hsr/hsr_framereg.c:34 suspicious rcu_dereference_check() usage!
    [   50.113799][ T3596]
    [   50.113799][ T3596] other info that might help us debug this:
    [   50.113799][ T3596]
    [   50.124257][ T3596]
    [   50.124257][ T3596] rcu_scheduler_active = 2, debug_locks = 1
    [   50.132368][ T3596] 2 locks held by syz-executor.0/3596:
    [   50.137863][ T3596]  #0: ffffffff8d3357e8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x3be/0xb80
    [   50.147470][ T3596]  #1: ffff88807ec9d5f0 (&hsr->list_lock){+...}-{2:2}, at: hsr_create_self_node+0x225/0x650
    [   50.157623][ T3596]
    [   50.157623][ T3596] stack backtrace:
    [   50.163510][ T3596] CPU: 1 PID: 3596 Comm: syz-executor.0 Not tainted 5.17.0-rc3-next-20220208-syzkaller #0
    [   50.173381][ T3596] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
    [   50.183623][ T3596] Call Trace:
    [   50.186904][ T3596]  <TASK>
    [   50.189844][ T3596]  dump_stack_lvl+0xcd/0x134
    [   50.194640][ T3596]  hsr_node_get_first+0x9b/0xb0
    [   50.199499][ T3596]  hsr_create_self_node+0x22d/0x650
    [   50.204688][ T3596]  hsr_dev_finalize+0x2c1/0x7d0
    [   50.209669][ T3596]  hsr_newlink+0x315/0x730
    [   50.214113][ T3596]  ? hsr_dellink+0x130/0x130
    [   50.218789][ T3596]  ? rtnl_create_link+0x7e8/0xc00
    [   50.223803][ T3596]  ? hsr_dellink+0x130/0x130
    [   50.228397][ T3596]  __rtnl_newlink+0x107c/0x1760
    [   50.233249][ T3596]  ? rtnl_setlink+0x3c0/0x3c0
    [   50.238043][ T3596]  ? is_bpf_text_address+0x77/0x170
    [   50.243362][ T3596]  ? lock_downgrade+0x6e0/0x6e0
    [   50.248219][ T3596]  ? unwind_next_frame+0xee1/0x1ce0
    [   50.253605][ T3596]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
    [   50.259669][ T3596]  ? __sanitizer_cov_trace_cmp4+0x1c/0x70
    [   50.265423][ T3596]  ? is_bpf_text_address+0x99/0x170
    [   50.270819][ T3596]  ? kernel_text_address+0x39/0x80
    [   50.275950][ T3596]  ? __kernel_text_address+0x9/0x30
    [   50.281336][ T3596]  ? unwind_get_return_address+0x51/0x90
    [   50.286975][ T3596]  ? create_prof_cpu_mask+0x20/0x20
    [   50.292178][ T3596]  ? arch_stack_walk+0x93/0xe0
    [   50.297172][ T3596]  ? kmem_cache_alloc_trace+0x42/0x2c0
    [   50.302637][ T3596]  ? rcu_read_lock_sched_held+0x3a/0x70
    [   50.308194][ T3596]  rtnl_newlink+0x64/0xa0
    [   50.312524][ T3596]  ? __rtnl_newlink+0x1760/0x1760
    [   50.317545][ T3596]  rtnetlink_rcv_msg+0x413/0xb80
    [   50.322631][ T3596]  ? rtnl_newlink+0xa0/0xa0
    [   50.327159][ T3596]  netlink_rcv_skb+0x153/0x420
    [   50.331931][ T3596]  ? rtnl_newlink+0xa0/0xa0
    [   50.336436][ T3596]  ? netlink_ack+0xa80/0xa80
    [   50.341095][ T3596]  ? netlink_deliver_tap+0x1a2/0xc40
    [   50.346532][ T3596]  ? netlink_deliver_tap+0x1b1/0xc40
    [   50.351839][ T3596]  netlink_unicast+0x539/0x7e0
    [   50.356633][ T3596]  ? netlink_attachskb+0x880/0x880
    [   50.361750][ T3596]  ? __sanitizer_cov_trace_const_cmp8+0x1d/0x70
    [   50.368003][ T3596]  ? __sanitizer_cov_trace_const_cmp8+0x1d/0x70
    [   50.374707][ T3596]  ? __phys_addr_symbol+0x2c/0x70
    [   50.379753][ T3596]  ? __sanitizer_cov_trace_cmp8+0x1d/0x70
    [   50.385568][ T3596]  ? __check_object_size+0x16c/0x4f0
    [   50.390859][ T3596]  netlink_sendmsg+0x904/0xe00
    [   50.395715][ T3596]  ? netlink_unicast+0x7e0/0x7e0
    [   50.400722][ T3596]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
    [   50.407003][ T3596]  ? netlink_unicast+0x7e0/0x7e0
    [   50.412119][ T3596]  sock_sendmsg+0xcf/0x120
    [   50.416548][ T3596]  __sys_sendto+0x21c/0x320
    [   50.421052][ T3596]  ? __ia32_sys_getpeername+0xb0/0xb0
    [   50.426427][ T3596]  ? lockdep_hardirqs_on_prepare+0x400/0x400
    [   50.432721][ T3596]  ? __context_tracking_exit+0xb8/0xe0
    [   50.438188][ T3596]  ? lock_downgrade+0x6e0/0x6e0
    [   50.443041][ T3596]  ? lock_downgrade+0x6e0/0x6e0
    [   50.447902][ T3596]  __x64_sys_sendto+0xdd/0x1b0
    [   50.452759][ T3596]  ? lockdep_hardirqs_on+0x79/0x100
    [   50.457964][ T3596]  ? syscall_enter_from_user_mode+0x21/0x70
    [   50.464150][ T3596]  do_syscall_64+0x35/0xb0
    [   50.468565][ T3596]  entry_SYSCALL_64_after_hwframe+0x44/0xae
    [   50.474452][ T3596] RIP: 0033:0x7f3148504e1c
    [   50.479052][ T3596] Code: fa fa ff ff 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 20 fb ff ff 48 8b
    [   50.498926][ T3596] RSP: 002b:00007ffeab5f2ab0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
    [   50.507342][ T3596] RAX: ffffffffffffffda RBX: 00007f314959d320 RCX: 00007f3148504e1c
    [   50.515393][ T3596] RDX: 0000000000000048 RSI: 00007f314959d370 RDI: 0000000000000003
    [   50.523444][ T3596] RBP: 0000000000000000 R08: 00007ffeab5f2b04 R09: 000000000000000c
    [   50.531492][ T3596] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
    [   50.539455][ T3596] R13: 00007f314959d370 R14: 0000000000000003 R15: 0000000000000000

Fixes: 4acc45db7115 ("net: hsr: use hlist_head instead of list_head for mac addresses")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Reported-and-tested-by: syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
v3:
 - include whole stack
 - replace rcu_rcu_dereference() with rcu_dereference_bh_check()

v2:
 - rebase current net-next tree

 net/hsr/hsr_framereg.c | 16 ++++++++++------
 net/hsr/hsr_framereg.h |  2 +-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index b3c6ffa1894d..62272d76545c 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -27,11 +27,11 @@ u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr)
 	return reciprocal_scale(hash, hsr->hash_buckets);
 }
 
-struct hsr_node *hsr_node_get_first(struct hlist_head *head)
+struct hsr_node *hsr_node_get_first(struct hlist_head *head, int cond)
 {
 	struct hlist_node *first;
 
-	first = rcu_dereference(hlist_first_rcu(head));
+	first = rcu_dereference_bh_check(hlist_first_rcu(head), cond);
 	if (first)
 		return hlist_entry(first, struct hsr_node, mac_list);
 
@@ -59,7 +59,8 @@ bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr)
 {
 	struct hsr_node *node;
 
-	node = hsr_node_get_first(&hsr->self_node_db);
+	node = hsr_node_get_first(&hsr->self_node_db,
+				  lockdep_is_held(&hsr->list_lock));
 	if (!node) {
 		WARN_ONCE(1, "HSR: No self node\n");
 		return false;
@@ -106,7 +107,8 @@ int hsr_create_self_node(struct hsr_priv *hsr,
 	ether_addr_copy(node->macaddress_B, addr_b);
 
 	spin_lock_bh(&hsr->list_lock);
-	oldnode = hsr_node_get_first(self_node_db);
+	oldnode = hsr_node_get_first(self_node_db,
+				     lockdep_is_held(&hsr->list_lock));
 	if (oldnode) {
 		hlist_replace_rcu(&oldnode->mac_list, &node->mac_list);
 		spin_unlock_bh(&hsr->list_lock);
@@ -125,7 +127,8 @@ void hsr_del_self_node(struct hsr_priv *hsr)
 	struct hsr_node *node;
 
 	spin_lock_bh(&hsr->list_lock);
-	node = hsr_node_get_first(self_node_db);
+	node = hsr_node_get_first(self_node_db,
+				  lockdep_is_held(&hsr->list_lock));
 	if (node) {
 		hlist_del_rcu(&node->mac_list);
 		kfree_rcu(node, rcu_head);
@@ -597,7 +600,8 @@ void *hsr_get_next_node(struct hsr_priv *hsr, void *_pos,
 	hash = hsr_mac_hash(hsr, addr);
 
 	if (!_pos) {
-		node = hsr_node_get_first(&hsr->node_db[hash]);
+		node = hsr_node_get_first(&hsr->node_db[hash],
+					  lockdep_is_held(&hsr->list_lock));
 		if (node)
 			ether_addr_copy(addr, node->macaddress_A);
 		return node;
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index d7cce6b161e3..2efd03fb3465 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -29,7 +29,7 @@ struct hsr_frame_info {
 };
 
 u32 hsr_mac_hash(struct hsr_priv *hsr, const unsigned char *addr);
-struct hsr_node *hsr_node_get_first(struct hlist_head *head);
+struct hsr_node *hsr_node_get_first(struct hlist_head *head, int cond);
 void hsr_del_self_node(struct hsr_priv *hsr);
 void hsr_del_nodes(struct hlist_head *node_db);
 struct hsr_node *hsr_get_node(struct hsr_port *port, struct hlist_head *node_db,
-- 
2.25.1

