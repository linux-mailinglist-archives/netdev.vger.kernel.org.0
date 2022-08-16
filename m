Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB3BB5957B6
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233918AbiHPKM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbiHPKL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:11:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46A74578A8
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 02:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660642486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+KFOMoWGAyHxHdtORsjFxcSg87BzWtJ/0Drcua3zx9E=;
        b=VuS7x2UkwRT8FX7/FFfSiKX6L2IzV2NtUJrjZHSr4e8sHnpXGp6mxC3CQ0Zxk/PiGHSZrW
        Dvq7ggayxPcVA6nbtFJzoUzD3+fz9JbSuzRi3EQW7fCg5m0clo6mVts8ns7dGWoNRWqkK3
        13LuugyOkG3VVQI9YTG34HkdHX9PRbs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-VWv000_QN42ZqFWb0ChMoQ-1; Tue, 16 Aug 2022 05:34:42 -0400
X-MC-Unique: VWv000_QN42ZqFWb0ChMoQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A6C13C0D195;
        Tue, 16 Aug 2022 09:34:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A4CE492C3B;
        Tue, 16 Aug 2022 09:34:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] net: Fix suspicious RCU usage in bpf_sk_reuseport_detach()
From:   David Howells <dhowells@redhat.com>
To:     yin31149@gmail.com
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Date:   Tue, 16 Aug 2022 10:34:40 +0100
Message-ID: <166064248071.3502205.10036394558814861778.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

Fix this by adding a new helper, __locked_read_sk_user_data_with_flags()
that checks to see if sk->sk_callback_lock() is held and use that here
instead.

Alternatively, making __rcu_dereference_sk_user_data_with_flags() use
rcu_dereference_checked() might suffice.

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

Fixes: cf8c1e967224 ("net: refactor bpf_sk_reuseport_detach()")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hawkins Jiawei <yin31149@gmail.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: netdev@vger.kernel.org
---

 include/net/sock.h           |   25 +++++++++++++++++++++++++
 kernel/bpf/reuseport_array.c |    2 +-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 05a1bbdf5805..d08cfe190a78 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -577,6 +577,31 @@ static inline bool sk_user_data_is_nocopy(const struct sock *sk)
 
 #define __sk_user_data(sk) ((*((void __rcu **)&(sk)->sk_user_data)))
 
+/**
+ * __locked_read_sk_user_data_with_flags - return the pointer
+ * only if argument flags all has been set in sk_user_data. Otherwise
+ * return NULL
+ *
+ * @sk: socket
+ * @flags: flag bits
+ *
+ * The caller must be holding sk->sk_callback_lock.
+ */
+static inline void *
+__locked_read_sk_user_data_with_flags(const struct sock *sk,
+				      uintptr_t flags)
+{
+	uintptr_t sk_user_data =
+		(uintptr_t)rcu_dereference_check(__sk_user_data(sk),
+						 lockdep_is_held(&sk->sk_callback_lock));
+
+	WARN_ON_ONCE(flags & SK_USER_DATA_PTRMASK);
+
+	if ((sk_user_data & flags) == flags)
+		return (void *)(sk_user_data & SK_USER_DATA_PTRMASK);
+	return NULL;
+}
+
 /**
  * __rcu_dereference_sk_user_data_with_flags - return the pointer
  * only if argument flags all has been set in sk_user_data. Otherwise
diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 85fa9dbfa8bf..82c61612f382 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -24,7 +24,7 @@ void bpf_sk_reuseport_detach(struct sock *sk)
 	struct sock __rcu **socks;
 
 	write_lock_bh(&sk->sk_callback_lock);
-	socks = __rcu_dereference_sk_user_data_with_flags(sk, SK_USER_DATA_BPF);
+	socks = __locked_read_sk_user_data_with_flags(sk, SK_USER_DATA_BPF);
 	if (socks) {
 		WRITE_ONCE(sk->sk_user_data, NULL);
 		/*


