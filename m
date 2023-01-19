Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736D66741A6
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjASS61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbjASS55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:57:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A7395748
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 10:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674154579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mBLA8rBSnN6RQ3B9TlRgpqpG+P/6fsEGitvJakD9N/k=;
        b=gEmIuVoRfUy5HkPHdp+h5/FLO7qJh9tJ20tDSgqPmZwwDBC3RCMzRoRXqtRqXGPvLx8uAu
        u4FK1wKSrN+EIgVytbKAT61aSiqA+YCzMbTPYodW/7lWjlogPsb+8uUxUFIZ30+rQyx32n
        4xYWBkVgtP9snDlKLuq8cZrIohnrWlo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-1yDI0gZkPYugJW8VllwGhw-1; Thu, 19 Jan 2023 13:56:15 -0500
X-MC-Unique: 1yDI0gZkPYugJW8VllwGhw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74A6785C073;
        Thu, 19 Jan 2023 18:56:14 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3760D492B02;
        Thu, 19 Jan 2023 18:56:13 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhengchao Shao <shaozhengchao@huawei.com>
Subject: [PATCH net] net: fix UaF in netns ops registration error path
Date:   Thu, 19 Jan 2023 19:55:45 +0100
Message-Id: <cec4e0f3bb2c77ac03a6154a8508d3930beb5f0f.1674154348.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If net_assign_generic() fails, the current error path in ops_init() tries
to clear the gen pointer slot. Anyway, in such error path, the gen pointer
itself has not been modified yet, and the existing and accessed one is
smaller than the accessed index, causing an out-of-bounds error:

 BUG: KASAN: slab-out-of-bounds in ops_init+0x2de/0x320
 Write of size 8 at addr ffff888109124978 by task modprobe/1018

 CPU: 2 PID: 1018 Comm: modprobe Not tainted 6.2.0-rc2.mptcp_ae5ac65fbed5+ #1641
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.1-2.fc37 04/01/2014
 Call Trace:
  <TASK>
  dump_stack_lvl+0x6a/0x9f
  print_address_description.constprop.0+0x86/0x2b5
  print_report+0x11b/0x1fb
  kasan_report+0x87/0xc0
  ops_init+0x2de/0x320
  register_pernet_operations+0x2e4/0x750
  register_pernet_subsys+0x24/0x40
  tcf_register_action+0x9f/0x560
  do_one_initcall+0xf9/0x570
  do_init_module+0x190/0x650
  load_module+0x1fa5/0x23c0
  __do_sys_finit_module+0x10d/0x1b0
  do_syscall_64+0x58/0x80
  entry_SYSCALL_64_after_hwframe+0x72/0xdc
 RIP: 0033:0x7f42518f778d
 Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48
       89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
       ff 73 01 c3 48 8b 0d cb 56 2c 00 f7 d8 64 89 01 48
 RSP: 002b:00007fff96869688 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
 RAX: ffffffffffffffda RBX: 00005568ef7f7c90 RCX: 00007f42518f778d
 RDX: 0000000000000000 RSI: 00005568ef41d796 RDI: 0000000000000003
 RBP: 00005568ef41d796 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000000
 R13: 00005568ef7f7d30 R14: 0000000000040000 R15: 0000000000000000
  </TASK>

This change addresses the issue by skipping the gen pointer
de-reference in the mentioned error-path.

Found by code inspection and verified with explicit error injection
on a kasan-enabled kernel.

Fixes: d266935ac43d ("net: fix UAF issue in nfqnl_nf_hook_drop() when ops_init() failed")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/net_namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 5581d22cc191..078a0a420c8a 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -137,12 +137,12 @@ static int ops_init(const struct pernet_operations *ops, struct net *net)
 		return 0;
 
 	if (ops->id && ops->size) {
-cleanup:
 		ng = rcu_dereference_protected(net->gen,
 					       lockdep_is_held(&pernet_ops_rwsem));
 		ng->ptr[*ops->id] = NULL;
 	}
 
+cleanup:
 	kfree(data);
 
 out:
-- 
2.39.0

