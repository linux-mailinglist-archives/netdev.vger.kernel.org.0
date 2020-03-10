Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50DB317EFE4
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 06:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgCJFQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 01:16:57 -0400
Received: from mail-vk1-f201.google.com ([209.85.221.201]:37291 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgCJFQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 01:16:57 -0400
Received: by mail-vk1-f201.google.com with SMTP id h26so5533595vkn.4
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 22:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qlkc3lstB8viYH6PTDeV+46tsu4TlJq92uxB1YryNdc=;
        b=ejKiPIjD0GtiAKcJ3Gaj202XVbpxBQvhDBSY7rz8rfFOExoEot3lkuQXtFggrgrZVT
         OYgzMehYpUfnSYPwRJI/8AFdNONytigNW2znh+4Z+l5KKtSUoXbnVypELhi9anijwFjU
         5AjVztlBLTzRurndLNu6j1VyReVgCHihIYM1Yno5Gnw3281g3FlxEYQ2BmPDq09ab9a2
         b537M87Rq/6zOkLFE4NbgqCss7T0I13DjofmCnDUMNL0qZzmEYjZRYERFJliNw4+Diwd
         McC4l1Py95cx8gMZxjGXlPaaMIAauH6/RBDg8x7atkebQWTBR1Q0wmimxLuMIvctbmcp
         nbXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qlkc3lstB8viYH6PTDeV+46tsu4TlJq92uxB1YryNdc=;
        b=APIr9w9W71zs/nzI48G1qWF7Sg7MmQcPRD19NTBW1Ti+u6K+CwjDn5taEay85UOuKD
         HcKmHUstCHd1CkpoOBD1ytawOTASNJzrqyjb8tiQTMXHsTV8vI8dM/pYqZz0iCml52GR
         brfBkpR2SEl/1Lihm4MmG6Me3R7vEChjxKG6ziMkKYKzT7pgEzlxsu0hJRZESq8qGSf4
         92Oqo72kOZfTRk4HMvWW9ksZGGOVmp64PzD2E8vVg/0mfuKdSE6jy0GjkJbqIhXvHBoF
         m95rQytVMl7tA/Fb5C6Uwv7Oxwt/Qn4/K0cXj6QxjhuGq4aaEPoKmH5GqcLP1/yZmEtC
         M2yg==
X-Gm-Message-State: ANhLgQ0NO3bpHfRXbQZbqRibnbxQXRVLbXgpm1uD33Z1AVDivsfZj27Y
        hfNkdAdJKWTQRC7quDIieZDcEt86G5YuEg==
X-Google-Smtp-Source: ADFU+vu05+1XJj00xUUY5nWHb75mpQagWKleiSaRoA1Rkd9cq1yjoid5/9z3RUqEKGqqzhZVdW5qxxpPO93sRQ==
X-Received: by 2002:a1f:5385:: with SMTP id h127mr10294318vkb.56.1583817415532;
 Mon, 09 Mar 2020 22:16:55 -0700 (PDT)
Date:   Mon,  9 Mar 2020 22:16:05 -0700
Message-Id: <20200310051606.33121-1-shakeelb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v4 1/2] cgroup: memcg: net: do not associate sock with
 unrelated cgroup
From:   Shakeel Butt <shakeelb@google.com>
To:     Eric Dumazet <edumazet@google.com>, Roman Gushchin <guro@fb.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are testing network memory accounting in our setup and noticed
inconsistent network memory usage and often unrelated cgroups network
usage correlates with testing workload. On further inspection, it
seems like mem_cgroup_sk_alloc() and cgroup_sk_alloc() are broken in
irq context specially for cgroup v1.

mem_cgroup_sk_alloc() and cgroup_sk_alloc() can be called in irq context
and kind of assumes that this can only happen from sk_clone_lock()
and the source sock object has already associated cgroup. However in
cgroup v1, where network memory accounting is opt-in, the source sock
can be unassociated with any cgroup and the new cloned sock can get
associated with unrelated interrupted cgroup.

Cgroup v2 can also suffer if the source sock object was created by
process in the root cgroup or if sk_alloc() is called in irq context.
The fix is to just do nothing in interrupt.

WARNING: Please note that about half of the TCP sockets are allocated
from the IRQ context, so, memory used by such sockets will not be
accouted by the memcg.

The stack trace of mem_cgroup_sk_alloc() from IRQ-context:

CPU: 70 PID: 12720 Comm: ssh Tainted:  5.6.0-smp-DEV #1
Hardware name: ...
Call Trace:
 <IRQ>
 dump_stack+0x57/0x75
 mem_cgroup_sk_alloc+0xe9/0xf0
 sk_clone_lock+0x2a7/0x420
 inet_csk_clone_lock+0x1b/0x110
 tcp_create_openreq_child+0x23/0x3b0
 tcp_v6_syn_recv_sock+0x88/0x730
 tcp_check_req+0x429/0x560
 tcp_v6_rcv+0x72d/0xa40
 ip6_protocol_deliver_rcu+0xc9/0x400
 ip6_input+0x44/0xd0
 ? ip6_protocol_deliver_rcu+0x400/0x400
 ip6_rcv_finish+0x71/0x80
 ipv6_rcv+0x5b/0xe0
 ? ip6_sublist_rcv+0x2e0/0x2e0
 process_backlog+0x108/0x1e0
 net_rx_action+0x26b/0x460
 __do_softirq+0x104/0x2a6
 do_softirq_own_stack+0x2a/0x40
 </IRQ>
 do_softirq.part.19+0x40/0x50
 __local_bh_enable_ip+0x51/0x60
 ip6_finish_output2+0x23d/0x520
 ? ip6table_mangle_hook+0x55/0x160
 __ip6_finish_output+0xa1/0x100
 ip6_finish_output+0x30/0xd0
 ip6_output+0x73/0x120
 ? __ip6_finish_output+0x100/0x100
 ip6_xmit+0x2e3/0x600
 ? ipv6_anycast_cleanup+0x50/0x50
 ? inet6_csk_route_socket+0x136/0x1e0
 ? skb_free_head+0x1e/0x30
 inet6_csk_xmit+0x95/0xf0
 __tcp_transmit_skb+0x5b4/0xb20
 __tcp_send_ack.part.60+0xa3/0x110
 tcp_send_ack+0x1d/0x20
 tcp_rcv_state_process+0xe64/0xe80
 ? tcp_v6_connect+0x5d1/0x5f0
 tcp_v6_do_rcv+0x1b1/0x3f0
 ? tcp_v6_do_rcv+0x1b1/0x3f0
 __release_sock+0x7f/0xd0
 release_sock+0x30/0xa0
 __inet_stream_connect+0x1c3/0x3b0
 ? prepare_to_wait+0xb0/0xb0
 inet_stream_connect+0x3b/0x60
 __sys_connect+0x101/0x120
 ? __sys_getsockopt+0x11b/0x140
 __x64_sys_connect+0x1a/0x20
 do_syscall_64+0x51/0x200
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

The stack trace of mem_cgroup_sk_alloc() from IRQ-context:
Fixes: 2d7580738345 ("mm: memcontrol: consolidate cgroup socket tracking")
Fixes: d979a39d7242 ("cgroup: duplicate cgroup reference when cloning sockets")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
---
Changes since v3:
- None

Changes since v2:
- Added a warning.
- Fixed a typo.
- Added the stacktrace.

Changes since v1:
- Fix cgroup_sk_alloc() too.

 kernel/cgroup/cgroup.c | 4 ++++
 mm/memcontrol.c        | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 4b70d0ae37e5..7e8755e8c33e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6461,6 +6461,10 @@ void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
 		return;
 	}
 
+	/* Don't associate the sock with unrelated interrupted task's cgroup. */
+	if (in_interrupt())
+		return;
+
 	rcu_read_lock();
 
 	while (true) {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1e1260847c63..06a889b0538b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6751,6 +6751,10 @@ void mem_cgroup_sk_alloc(struct sock *sk)
 		return;
 	}
 
+	/* Do not associate the sock with unrelated interrupted task's memcg. */
+	if (in_interrupt())
+		return;
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_task(current);
 	if (memcg == root_mem_cgroup)
-- 
2.25.1.481.gfbce0eb801-goog

