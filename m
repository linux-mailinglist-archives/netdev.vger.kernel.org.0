Return-Path: <netdev+bounces-4504-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E4270D225
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:03:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E20882808F2
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB82863D2;
	Tue, 23 May 2023 03:00:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C163C4C83
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:00:52 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD21210E0;
	Mon, 22 May 2023 20:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1684810831; x=1716346831;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nny6LjxpUW6mJRzHzp9QlRzCPGPnlS5WgOn3BfbgZ8Q=;
  b=jTVCBqxOe8UffKjtkGpafqUU/E37SRTrD7EOsTm6J9+Clw/O1JTQbbgr
   jqKTWMLntBqTDMtCA0RfELboOTqvjU+a8rd95tiLxSeEm3Bcv3H2mYKE/
   dSycnFZeGgiPIzOjUi1spMv8hOvanKyIUdP6DJeonEI+UY8KSke38z0fb
   g=;
X-IronPort-AV: E=Sophos;i="6.00,185,1681171200"; 
   d="scan'208";a="5068788"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 03:00:29 +0000
Received: from EX19D009EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-26a610d2.us-west-2.amazon.com (Postfix) with ESMTPS id 99CC040D3F;
	Tue, 23 May 2023 03:00:28 +0000 (UTC)
Received: from EX19D026EUB004.ant.amazon.com (10.252.61.64) by
 EX19D009EUA001.ant.amazon.com (10.252.50.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 23 May 2023 03:00:27 +0000
Received: from uc3ecf78c6baf56.ant.amazon.com (10.119.183.60) by
 EX19D026EUB004.ant.amazon.com (10.252.61.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 23 May 2023 03:00:25 +0000
From: Andrew Paniakin <apanyaki@amazon.com>
To: <stable@vger.kernel.org>
CC: <luizcap@amazon.com>, <benh@amazon.com>, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Andrew Paniakin
	<apanyaki@amazon.com>, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, "David S.
 Miller" <davem@davemloft.net>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH 4.14] netfilter: nf_tables: fix register ordering
Date: Mon, 22 May 2023 19:59:41 -0700
Message-ID: <20230523025941.1695616-1-apanyaki@amazon.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.183.60]
X-ClientProxiedBy: EX19D045UWC004.ant.amazon.com (10.13.139.203) To
 EX19D026EUB004.ant.amazon.com (10.252.61.64)
Precedence: Bulk
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Florian Westphal <fw@strlen.de>

commit d209df3e7f7002d9099fdb0f6df0f972b4386a63 upstream

[ We hit the trace described in commit message with the
kselftest/nft_trans_stress.sh. This patch diverges from the upstream one
since kernel 4.14 does not have following symbols:
nft_chain_filter_init, nf_tables_flowtable_notifier ]

We must register nfnetlink ops last, as that exposes nf_tables to
userspace.  Without this, we could theoretically get nfnetlink request
before net->nft state has been initialized.

Fixes: 99633ab29b213 ("netfilter: nf_tables: complete net namespace support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
[apanyaki: backport to v4.14-stable]
Signed-off-by: Andrew Paniakin <apanyaki@amazon.com>
---

[  163.471426] Call Trace:
[  163.474901]  netlink_dump+0x125/0x2d0
[  163.479081]  __netlink_dump_start+0x16a/0x1c0
[  163.483589]  nf_tables_gettable+0x151/0x180 [nf_tables]
[  163.488561]  ? nf_tables_gettable+0x180/0x180 [nf_tables]
[  163.493658]  nfnetlink_rcv_msg+0x222/0x250 [nfnetlink]
[  163.498608]  ? __skb_try_recv_datagram+0x114/0x180
[  163.503359]  ? nfnetlink_net_exit_batch+0x60/0x60 [nfnetlink]
[  163.508590]  netlink_rcv_skb+0x4d/0x130
[  163.512832]  nfnetlink_rcv+0x92/0x780 [nfnetlink]
[  163.517465]  ? netlink_recvmsg+0x202/0x3e0
[  163.521801]  ? __kmalloc_node_track_caller+0x31/0x290
[  163.526635]  ? copy_msghdr_from_user+0xd5/0x150
[  163.531216]  ? __netlink_lookup+0xd0/0x130
[  163.535536]  netlink_unicast+0x196/0x240
[  163.539759]  netlink_sendmsg+0x2da/0x400
[  163.544010]  sock_sendmsg+0x36/0x40
[  163.548030]  SYSC_sendto+0x10e/0x140
[  163.552119]  ? __audit_syscall_entry+0xbc/0x110
[  163.556741]  ? syscall_trace_enter+0x1df/0x2e0
[  163.561315]  ? __audit_syscall_exit+0x231/0x2b0
[  163.565857]  do_syscall_64+0x67/0x110
[  163.569930]  entry_SYSCALL_64_after_hwframe+0x59/0xbe

Reproduce with debug logs clearly shows the nft initialization issue exactly as
in ported patch description:
[   22.600051] nft load start
[   22.600858] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[   22.601241] nf_tables_gettable start: ffff888527c10000
[   22.601271] register_pernet_subsys ffffffffa02ba0c0
[   22.601274] netns ops_init ffffffffa02ba0c0 ffffffff821aeec0
[   22.602506] nf_tables_dump_tables: ffff888527c10000
[   22.603187] af_info list init done: ffffffff821aeec0
[   22.604064] nf_tables_dump_tables: afi:           (null)
[   22.604077] BUG: unable to handle kernel
[   22.604820] netns ops_init end ffffffffa02ba0c0 ffffffff821aeec0
[   22.605698] NULL pointer dereference
[   22.606354] netns ops_init ffffffffa02ba0c0 ffff888527c10000

(gdb) p &init_net
$2 = (struct net *) 0xffffffff821aeec0 <init_net>
ffff888527c10000 is a testns1 namespaces

To reproduce this problem and test the fix I scripted following steps:
- start Qemu VM
- run nft_trans_stress.sh test
- check dmesg logs for NULL pointer dereference
- reboot via QMP and repeat

I tested the fix with our kernel regression tests (including kselftest) also.

 net/netfilter/nf_tables_api.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c683a45b8ae53..65495b528290b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6032,18 +6032,25 @@ static int __init nf_tables_module_init(void)
 		goto err1;
 	}
 
-	err = nf_tables_core_module_init();
+	err = register_pernet_subsys(&nf_tables_net_ops);
 	if (err < 0)
 		goto err2;
 
-	err = nfnetlink_subsys_register(&nf_tables_subsys);
+	err = nf_tables_core_module_init();
 	if (err < 0)
 		goto err3;
 
+	/* must be last */
+	err = nfnetlink_subsys_register(&nf_tables_subsys);
+	if (err < 0)
+		goto err4;
+
 	pr_info("nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>\n");
-	return register_pernet_subsys(&nf_tables_net_ops);
-err3:
+	return err;
+err4:
 	nf_tables_core_module_exit();
+err3:
+	unregister_pernet_subsys(&nf_tables_net_ops);
 err2:
 	kfree(info);
 err1:
-- 
2.39.2


