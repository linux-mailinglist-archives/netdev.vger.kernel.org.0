Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B061B6C70
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 06:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgDXEKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 00:10:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24508 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725776AbgDXEKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 00:10:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587701439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/QaVRx3Xkf5LNKuHwqXWveCCgZt3Dgenj8AscAuJfEI=;
        b=hjUyrnPaDJQtqVyTsvorcjVyytQNZ3u9e9onehliejc6gzNnAhqNltlaoK5dr7ALORl/Y4
        3zpx6SYAQY4TQQaeHVvVZZ/K3dmpBKI2Yv0/2rQ737ao27EREmWnwesaE5WZF2kFhPkL24
        fjGd76Rwrw8jMTZ1ulJR+QTsP3BgyxM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-LMKa8gmvMNi0ybDA_dQ3Mg-1; Fri, 24 Apr 2020 00:10:37 -0400
X-MC-Unique: LMKa8gmvMNi0ybDA_dQ3Mg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 415131009616;
        Fri, 24 Apr 2020 04:10:36 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-204.gru2.redhat.com [10.97.116.204])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E5225C1D0;
        Fri, 24 Apr 2020 04:10:35 +0000 (UTC)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 816D0C1D71; Fri, 24 Apr 2020 01:10:32 -0300 (-03)
Date:   Fri, 24 Apr 2020 01:10:32 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: mlx5: Panic with conntrack offload
Message-ID: <20200424041032.GG2468@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

I'm triggering this panic out of 1802136023c01075, net-next today
(disregard the hash at the end of the kernel version).
I have a dual-port CX5 with VF LAG, with 1 guest and 2 VFs on it, with
different subnets. Ovs OF flows steering each subnet to each VF and
doing conntrack. (flows at the bottom here)

This happens after 2 or 5 netperf runs. I run netperf, wait for the
flows to expire, then run it again.

I'm suspecting this was introduced in 9808dd0a2aee ("net/mlx5e: CT: Use
rhashtable's ct entries instead of a separate list"), but I didn't
bisect it yet.  I know it also happens with 2fcd80144b93ff908, FWIW.

Ideas?

Thanks,
Marcelo

[  485.557189] ------------[ cut here ]------------
[  485.562976] workqueue: WQ_MEM_RECLAIM nf_flow_table_offload:flow_offload_worr
[  485.562985] WARNING: CPU: 7 PID: 3731 at kernel/workqueue.c:2610 check_flush0
[  485.590191] Kernel panic - not syncing: panic_on_warn set ...
[  485.597100] CPU: 7 PID: 3731 Comm: kworker/u112:8 Not tainted 5.7.0-rc1.21802
[  485.606629] Hardware name: Dell Inc. PowerEdge R730/072T6D, BIOS 2.4.3 01/177
[  485.615487] Workqueue: nf_flow_table_offload flow_offload_work_handler [nf_f]
[  485.624834] Call Trace:
[  485.628077]  dump_stack+0x50/0x70
[  485.632280]  panic+0xfb/0x2d7
[  485.636083]  ? check_flush_dependency+0x110/0x130
[  485.641830]  __warn.cold.12+0x20/0x2a
[  485.646405]  ? check_flush_dependency+0x110/0x130
[  485.652154]  ? check_flush_dependency+0x110/0x130
[  485.657900]  report_bug+0xb8/0x100
[  485.662187]  ? sched_clock_cpu+0xc/0xb0
[  485.666974]  do_error_trap+0x9f/0xc0
[  485.671464]  do_invalid_op+0x36/0x40
[  485.675950]  ? check_flush_dependency+0x110/0x130
[  485.681699]  invalid_op+0x28/0x30
[  485.685891] RIP: 0010:check_flush_dependency+0x110/0x130
[  485.692324] Code: ff ff 48 8b 50 18 48 8d 8b b0 00 00 00 49 89 e8 48 81 c6 b0
[  485.714353] RSP: 0018:ffffa9474aea7a48 EFLAGS: 00010086
[  485.720724] RAX: 0000000000000000 RBX: ffff912c07c19400 RCX: 0000000000000000
[  485.729232] RDX: 0000000000000090 RSI: ffffffffaf67e1f0 RDI: ffffffffaf67bd2c
[  485.737737] RBP: ffffffffade8f8d0 R08: ffffffffaf67e160 R09: 000000000002b6c0
[  485.746240] R10: 0000017f622837fe R11: 0000000000000e93 R12: ffff9148ad011780
[  485.754751] R13: ffff914b3f771700 R14: 0000000000000001 R15: ffff914b30f1c1d0
[  485.763261]  ? rhashtable_insert_slow+0x470/0x470
[  485.769056]  ? check_flush_dependency+0x110/0x130
[  485.774856]  __flush_work+0x96/0x1d0
[  485.779376]  ? work_busy+0x80/0x80
[  485.783681]  __cancel_work_timer+0x103/0x190
[  485.788950]  ? _cond_resched+0x15/0x30
[  485.793634]  ? _cond_resched+0x15/0x30
[  485.798321]  ? _cond_resched+0x15/0x30
[  485.803008]  rhashtable_free_and_destroy+0x20/0x140
[  485.808979]  del_sw_flow_group+0x45/0x2c0 [mlx5_core]
[  485.815119]  tree_put_node+0xc3/0x150 [mlx5_core]
[  485.820893]  mlx5_del_flow_rules+0x11c/0x240 [mlx5_core]
[  485.827344]  __mlx5_eswitch_del_rule+0x20/0xf0 [mlx5_core]
[  485.833978]  mlx5_tc_ct_entry_del_rule+0x46/0x90 [mlx5_core]
[  485.840813]  mlx5_tc_ct_entry_del_rules+0x24/0x40 [mlx5_core]
[  485.847750]  mlx5_tc_ct_block_flow_offload+0x336/0x9f0 [mlx5_core]
[  485.855153]  ? __wake_up_common+0x7a/0x180
[  485.860230]  nf_flow_offload_tuple.isra.23+0xca/0x170 [nf_flow_table]
[  485.867929]  ? __switch_to_asm+0x40/0x70
[  485.872799]  ? __switch_to_asm+0x34/0x70
[  485.877646]  ? __switch_to_asm+0x40/0x70
[  485.882466]  ? __switch_to_asm+0x34/0x70
[  485.887283]  ? __switch_to_asm+0x40/0x70
[  485.892082]  flow_offload_tuple_del+0x30/0x40 [nf_flow_table]
[  485.898917]  flow_offload_work_handler+0x7f/0x270 [nf_flow_table]
[  485.906139]  ? finish_task_switch+0x19c/0x2a0
[  485.911412]  process_one_work+0x1a7/0x370
[  485.916299]  worker_thread+0x30/0x380
[  485.920797]  ? process_one_work+0x370/0x370
[  485.925876]  kthread+0x112/0x130
[  485.929883]  ? kthread_park+0x80/0x80
[  485.934377]  ret_from_fork+0x35/0x40
[  486.975616] Shutting down cpus with NMI
[  486.980297] Kernel Offset: 0x2ca00000 from 0xffffffff81000000 (relocation ra)
[  486.997713] ---[ end Kernel panic - not syncing: panic_on_warn set ... ]---

OF flows:
ovs-ofctl add-flow br0 'in_port=eth4,ip,action=ct(table=10)'
ovs-ofctl add-flow br0 'in_port=eth4,action=output=bond9'
ovs-ofctl add-flow br0 'table=10,ct_state=+trk+est,ip,action=output=bond9'
ovs-ofctl add-flow br0 'table=10,ct_state=+trk+new,tcp,action=ct(commit,table=12)'
ovs-ofctl add-flow br0 'table=12,action=output=bond9'

ovs-ofctl add-flow br0 'in_port=eth0,ip,action=ct(table=20)'
ovs-ofctl add-flow br0 'in_port=eth0,action=output=bond9'
ovs-ofctl add-flow br0 'table=20,ct_state=+trk+est,ip,action=output=bond9'
ovs-ofctl add-flow br0 'table=20,ct_state=+trk+new,tcp,action=ct(commit,table=22)'
ovs-ofctl add-flow br0 'table=22,action=output=bond9'

ovs-ofctl add-flow br0 'in_port=bond9,ip,action=ct(table=30)'
ovs-ofctl add-flow br0 'table=30,ct_state=+trk+est,ip,nw_src=172.0.0.1,action=output=eth0'
ovs-ofctl add-flow br0 'table=30,ct_state=+trk+est,ip,nw_src=172.0.1.1,action=output=eth4'
ovs-ofctl add-flow br0 'table=30,ct_state=+trk+new,ip,action=ct(commit,table=32)'
ovs-ofctl add-flow br0 'table=32,ct_state=+trk,ip,nw_src=172.0.0.1,action=output=eth0'
ovs-ofctl add-flow br0 'table=32,ct_state=+trk,ip,nw_src=172.0.1.1,action=output=eth4'

ovs-ofctl add-flow br0 'arp,action=NORMAL'

