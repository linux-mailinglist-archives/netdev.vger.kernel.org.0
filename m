Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5E5616D19
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 19:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiKBSre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 14:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231706AbiKBSrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 14:47:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 71B2C2FFEE;
        Wed,  2 Nov 2022 11:47:14 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 6/7] netfilter: nf_nat: Fix possible memory leak in nf_nat_init()
Date:   Wed,  2 Nov 2022 19:46:58 +0100
Message-Id: <20221102184659.2502-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221102184659.2502-1-pablo@netfilter.org>
References: <20221102184659.2502-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

In nf_nat_init(), register_nf_nat_bpf() can fail and return directly
without any error handling.
Then nf_nat_bysource will leak and registering of &nat_net_ops,
&follow_master_nat and nf_nat_hook won't be reverted.

This leaves wild ops in linkedlists and when another module tries to
call register_pernet_operations() or nf_ct_helper_expectfn_register()
it triggers page fault:

 BUG: unable to handle page fault for address: fffffbfff81b964c
 RIP: 0010:register_pernet_operations+0x1b9/0x5f0
 Call Trace:
 <TASK>
  register_pernet_subsys+0x29/0x40
  ebtables_init+0x58/0x1000 [ebtables]
  ...

Fixes: 820dc0523e05 ("net: netfilter: move bpf_ct_set_nat_info kfunc in nf_nat_bpf.c")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 18319a6e6806..e29e4ccb5c5a 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1152,7 +1152,16 @@ static int __init nf_nat_init(void)
 	WARN_ON(nf_nat_hook != NULL);
 	RCU_INIT_POINTER(nf_nat_hook, &nat_hook);
 
-	return register_nf_nat_bpf();
+	ret = register_nf_nat_bpf();
+	if (ret < 0) {
+		RCU_INIT_POINTER(nf_nat_hook, NULL);
+		nf_ct_helper_expectfn_unregister(&follow_master_nat);
+		synchronize_net();
+		unregister_pernet_subsys(&nat_net_ops);
+		kvfree(nf_nat_bysource);
+	}
+
+	return ret;
 }
 
 static void __exit nf_nat_cleanup(void)
-- 
2.30.2

