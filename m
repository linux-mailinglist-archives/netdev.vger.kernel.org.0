Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26874EC66A
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 16:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346762AbiC3OYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 10:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346758AbiC3OYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 10:24:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4C1920594A
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 07:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648650144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=V8lwe1nJ277ErLzO2JvOAl8qLHlH5LlGzwKHRcvdCBU=;
        b=aBP1RazWPdzzHAztzePZ1V1geEEmSJgZ3FIxoN16uR6LW5SVOYNBxvuIWxE8LR9pDY9asd
        U9ZY4jypCkCddOnGQwg1/ZcQMmGcjapTg+P7VtvKmFrTIWjXj9Bzq6/I/+zcGqvezay+PO
        iSF28+cr7Owh3MSqEuQMHJ5zDPxyu4E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-5Y00R3zkPfq4RQIRR8_cwg-1; Wed, 30 Mar 2022 10:22:21 -0400
X-MC-Unique: 5Y00R3zkPfq4RQIRR8_cwg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 919DA381749F;
        Wed, 30 Mar 2022 14:22:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77553C1D38B;
        Wed, 30 Mar 2022 14:22:17 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net] rxrpc: fix some null-ptr-deref bugs in server_key.c
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Xiaolong Huang <butterflyhuangxx@gmail.com>,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Date:   Wed, 30 Mar 2022 15:22:14 +0100
Message-ID: <164865013439.2941502.8966285221215590921.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaolong Huang <butterflyhuangxx@gmail.com>

Some function calls are not implemented in rxrpc_no_security, there are
preparse_server_key, free_preparse_server_key and destroy_server_key.
When rxrpc security type is rxrpc_no_security, user can easily trigger a
null-ptr-deref bug via ioctl. So judgment should be added to prevent it

The crash log:
user@syzkaller:~$ ./rxrpc_preparse_s
[   37.956878][T15626] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   37.957645][T15626] #PF: supervisor instruction fetch in kernel mode
[   37.958229][T15626] #PF: error_code(0x0010) - not-present page
[   37.958762][T15626] PGD 4aadf067 P4D 4aadf067 PUD 4aade067 PMD 0
[   37.959321][T15626] Oops: 0010 [#1] PREEMPT SMP
[   37.959739][T15626] CPU: 0 PID: 15626 Comm: rxrpc_preparse_ Not tainted 5.17.0-01442-gb47d5a4f6b8d #43
[   37.960588][T15626] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
[   37.961474][T15626] RIP: 0010:0x0
[   37.961787][T15626] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
[   37.962480][T15626] RSP: 0018:ffffc9000d9abdc0 EFLAGS: 00010286
[   37.963018][T15626] RAX: ffffffff84335200 RBX: ffff888012a1ce80 RCX: 0000000000000000
[   37.963727][T15626] RDX: 0000000000000000 RSI: ffffffff84a736dc RDI: ffffc9000d9abe48
[   37.964425][T15626] RBP: ffffc9000d9abe48 R08: 0000000000000000 R09: 0000000000000002
[   37.965118][T15626] R10: 000000000000000a R11: f000000000000000 R12: ffff888013145680
[   37.965836][T15626] R13: 0000000000000000 R14: ffffffffffffffec R15: ffff8880432aba80
[   37.966441][T15626] FS:  00007f2177907700(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
[   37.966979][T15626] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.967384][T15626] CR2: ffffffffffffffd6 CR3: 000000004aaf1000 CR4: 00000000000006f0
[   37.967864][T15626] Call Trace:
[   37.968062][T15626]  <TASK>
[   37.968240][T15626]  rxrpc_preparse_s+0x59/0x90
[   37.968541][T15626]  key_create_or_update+0x174/0x510
[   37.968863][T15626]  __x64_sys_add_key+0x139/0x1d0
[   37.969165][T15626]  do_syscall_64+0x35/0xb0
[   37.969451][T15626]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   37.969824][T15626] RIP: 0033:0x43a1f9

Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
Tested-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: http://lists.infradead.org/pipermail/linux-afs/2022-March/005069.html
---

 net/rxrpc/server_key.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/server_key.c b/net/rxrpc/server_key.c
index ead3471307ee..ee269e0e6ee8 100644
--- a/net/rxrpc/server_key.c
+++ b/net/rxrpc/server_key.c
@@ -84,6 +84,9 @@ static int rxrpc_preparse_s(struct key_preparsed_payload *prep)
 
 	prep->payload.data[1] = (struct rxrpc_security *)sec;
 
+	if (!sec->preparse_server_key)
+		return -EINVAL;
+
 	return sec->preparse_server_key(prep);
 }
 
@@ -91,7 +94,7 @@ static void rxrpc_free_preparse_s(struct key_preparsed_payload *prep)
 {
 	const struct rxrpc_security *sec = prep->payload.data[1];
 
-	if (sec)
+	if (sec && sec->free_preparse_server_key)
 		sec->free_preparse_server_key(prep);
 }
 
@@ -99,7 +102,7 @@ static void rxrpc_destroy_s(struct key *key)
 {
 	const struct rxrpc_security *sec = key->payload.data[1];
 
-	if (sec)
+	if (sec && sec->destroy_server_key)
 		sec->destroy_server_key(key);
 }
 


