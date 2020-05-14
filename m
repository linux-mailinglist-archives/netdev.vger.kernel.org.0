Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9367E1D2F74
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 14:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgENMTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 08:19:36 -0400
Received: from correo.us.es ([193.147.175.20]:54272 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbgENMTW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 08:19:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BF1AA15AEB7
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:19:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD7A7DA712
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 14:19:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ACCECDA711; Thu, 14 May 2020 14:19:20 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9E18DA718;
        Thu, 14 May 2020 14:19:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 May 2020 14:19:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7FC0E42EF42B;
        Thu, 14 May 2020 14:19:18 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/6] netfilter: flowtable: Remove WQ_MEM_RECLAIM from workqueue
Date:   Thu, 14 May 2020 14:19:10 +0200
Message-Id: <20200514121913.24519-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514121913.24519-1-pablo@netfilter.org>
References: <20200514121913.24519-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 3d4ca62c81f9..2276a73ccba2 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1062,7 +1062,7 @@ static struct flow_indr_block_entry block_ing_entry = {
 int nf_flow_table_offload_init(void)
 {
 	nf_flow_offload_wq  = alloc_workqueue("nf_flow_table_offload",
-					      WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+					      WQ_UNBOUND, 0);
 	if (!nf_flow_offload_wq)
 		return -ENOMEM;
 
-- 
2.20.1

