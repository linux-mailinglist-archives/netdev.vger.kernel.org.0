Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409D71CCA5F
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 12:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbgEJK4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 06:56:00 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50232 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728689AbgEJK4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 06:56:00 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from roid@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 10 May 2020 13:55:55 +0300
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04AAttoN009099;
        Sun, 10 May 2020 13:55:55 +0300
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, davem@davemloft.net
Cc:     Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: [PATCH net] netfilter: nf_flow_table_offload: Remove WQ_MEM_RECLAIM from workqueue
Date:   Sun, 10 May 2020 13:55:43 +0300
Message-Id: <20200510105543.13546-1-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This workqueue is in charge of handling offloaded flow tasks like
add/del/stats we should not use WQ_MEM_RECLAIM flag.
The flag can result in the following warning.

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

Fixes: 7da182a998d6 ("netfilter: flowtable: Use work entry per offload command")
Reported-by: Marcelo Ricardo Leitner <mleitner@redhat.com>
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
---
 net/netfilter/nf_flow_table_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index e3b099c14eff..148d3bd11fbc 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1056,7 +1056,7 @@ static struct flow_indr_block_entry block_ing_entry = {
 int nf_flow_table_offload_init(void)
 {
 	nf_flow_offload_wq  = alloc_workqueue("nf_flow_table_offload",
-					      WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+					      WQ_UNBOUND, 0);
 	if (!nf_flow_offload_wq)
 		return -ENOMEM;
 
-- 
2.8.4

