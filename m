Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C425E595D3C
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 15:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbiHPN0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 09:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbiHPN02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 09:26:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83AC98769D
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 06:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660656386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zxJ1v8+cjZ+tYJe90RAlV6rz4Psbcq8JkXLwBn2PQcI=;
        b=VGrXdM35ZcqdfMZmHfwfAiEabt3liOAttCUYxwtqEXNrYzX1Cmdipk6T0ZvCPeBmggvcS+
        75/gXItjonfe0nZqjwICyVD311WI+Bgq6iG/mSU+oZZzNkwGrVZB90HwZc8fGwfTSyXkRk
        +CXOdnHg/H/gLBiADuqyk7VXjZ/6MGA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-JOp7kY0TNAutV_QSqaFoVA-1; Tue, 16 Aug 2022 09:26:21 -0400
X-MC-Unique: JOp7kY0TNAutV_QSqaFoVA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F123B2999B28;
        Tue, 16 Aug 2022 13:26:20 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4263E492C3B;
        Tue, 16 Aug 2022 13:26:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH net v2] net: Fix suspicious RCU usage in
 bpf_sk_reuseport_detach()
From:   David Howells <dhowells@redhat.com>
To:     yin31149@gmail.com
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Date:   Tue, 16 Aug 2022 14:26:19 +0100
Message-ID: <166065637961.4008018.10420960640773607710.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_sk_reuseport_detach() calls __rcu_dereference_sk_user_data_with_flags()
to obtain the value of sk->sk_user_data, but that function is only usable
if the RCU read lock is held, and neither that function nor any of its
callers hold it.

Fix this by adding a new helper,
__rcu_dereference_sk_user_data_with_flags_check() that checks to see if
sk->sk_callback_lock() is held and use that here instead.

__rcu_dereference_sk_user_data_with_flags() then calls that, supplying false
as condition indicating only the RCU read lock should be checked.

Without this, the following warning can be occasionally observed:

=============================
WARNING: suspicious RCU usage
6.0.0-rc1-build2+ #563 Not tainted
-----------------------------
include/net/sock.h:592 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
5 locks held by locktest/29873:
 #0: ffff88812734b550 (&sb->s_type->i_mutex_key#9){+.+.}-{3:3}, at: __sock_release+0x77/0x121
 #1: ffff88812f5621b0 (sk_lock-AF_INET){+.+.}-{0:0}, at: tcp_close+0x1c/0x70
 #2: ffff88810312f5c8 (&h->lhash2[i].lock){+.+.}-{2:2}, at: inet_unhash+0x76/0x1c0
 #3: ffffffff83768bb8 (reuseport_lock){+...}-{2:2}, at: reuseport_detach_sock+0x18/0xdd
 #4: ffff88812f562438 (clock-AF_INET){++..}-{2:2}, at: bpf_sk_reuseport_detach+0x24/0xa4

stack backtrace:
CPU: 1 PID: 29873 Comm: locktest Not tainted 6.0.0-rc1-build2+ #563
Hardware name: ASUS All Series/H97-PLUS, BIOS 2306 10/09/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x4c/0x5f
 bpf_sk_reuseport_detach+0x6d/0xa4
 reuseport_detach_sock+0x75/0xdd
 inet_unhash+0xa5/0x1c0
 tcp_set_state+0x169/0x20f
 ? lockdep_sock_is_held+0x3a/0x3a
 ? __lock_release.isra.0+0x13e/0x220
 ? reacquire_held_locks+0x1bb/0x1bb
 ? hlock_class+0x31/0x96
 ? mark_lock+0x9e/0x1af
 __tcp_close+0x50/0x4b6
 tcp_close+0x28/0x70
 inet_release+0x8e/0xa7
 __sock_release+0x95/0x121
 sock_close+0x14/0x17
 __fput+0x20f/0x36a
 task_work_run+0xa3/0xcc
 exit_to_user_mode_prepare+0x9c/0x14d
 syscall_exit_to_user_mode+0x18/0x44
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Changes
=======
ver #2)
 - Changed to suggestion from Hawkins Jiawei to have a ..._check() function
   and make the original a special case of that.

Fixes: cf8c1e967224 ("net: refactor bpf_sk_reuseport_detach()")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hawkins Jiawei <yin31149@gmail.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: netdev@vger.kernel.org
Link: https://lore.kernel.org/r/166064248071.3502205.10036394558814861778.stgit@warthog.procyon.org.uk # v1
---

 include/net/sock.h           |   18 ++++++++++++++----
 kernel/bpf/reuseport_array.c |    3 ++-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 05a1bbdf5805..6464da28e842 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -578,18 +578,22 @@ static inline bool sk_user_data_is_nocopy(const struct sock *sk)
 #define __sk_user_data(sk) ((*((void __rcu **)&(sk)->sk_user_data)))
 
 /**
- * __rcu_dereference_sk_user_data_with_flags - return the pointer
+ * __rcu_dereference_sk_user_data_with_flags_check - return the pointer
  * only if argument flags all has been set in sk_user_data. Otherwise
  * return NULL
  *
  * @sk: socket
  * @flags: flag bits
+ * @condition: Condition under which non-RCU access may take place
+ *
+ * The caller must be holding the RCU read lock 
  */
 static inline void *
-__rcu_dereference_sk_user_data_with_flags(const struct sock *sk,
-					  uintptr_t flags)
+__rcu_dereference_sk_user_data_with_flags_check(const struct sock *sk,
+						uintptr_t flags, bool condition)
 {
-	uintptr_t sk_user_data = (uintptr_t)rcu_dereference(__sk_user_data(sk));
+	uintptr_t sk_user_data =
+		(uintptr_t)rcu_dereference_check(__sk_user_data(sk), condition);
 
 	WARN_ON_ONCE(flags & SK_USER_DATA_PTRMASK);
 
@@ -598,6 +602,12 @@ __rcu_dereference_sk_user_data_with_flags(const struct sock *sk,
 	return NULL;
 }
 
+static inline void *
+__rcu_dereference_sk_user_data_with_flags(const struct sock *sk, uintptr_t flags)
+{
+	return __rcu_dereference_sk_user_data_with_flags_check(sk, flags, false);
+}
+
 #define rcu_dereference_sk_user_data(sk)				\
 	__rcu_dereference_sk_user_data_with_flags(sk, 0)
 #define __rcu_assign_sk_user_data_with_flags(sk, ptr, flags)		\
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 85fa9dbfa8bf..856c360a591d 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -24,7 +24,8 @@ void bpf_sk_reuseport_detach(struct sock *sk)
 	struct sock __rcu **socks;
 
 	write_lock_bh(&sk->sk_callback_lock);
-	socks = __rcu_dereference_sk_user_data_with_flags(sk, SK_USER_DATA_BPF);
+	socks = __rcu_dereference_sk_user_data_with_flags_check(
+		sk, SK_USER_DATA_BPF, lockdep_is_held(&sk->sk_callback_lock));
 	if (socks) {
 		WRITE_ONCE(sk->sk_user_data, NULL);
 		/*


