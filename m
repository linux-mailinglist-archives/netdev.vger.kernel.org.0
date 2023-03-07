Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05C76AE736
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjCGQtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbjCGQtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:49:11 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BB89310C
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 08:45:32 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id x64-20020a25ce43000000b00ae6d5855d78so14690455ybe.12
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 08:45:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678207532;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4XM5xVF0nTvf8PGtK7KVlUTEedOy4rXUSvv5qvd10Z8=;
        b=qKXsUfpNRhNJ9rpAfczd2rGb6sopu38LhSrD5+B9kf6ETcCZ33Pfp3oVS/VIbBkZ3T
         UPFcGm2tqNu9ZosSDwRgJ4tMn1Oi86e2lVx8horAibvtjGDz7u4aFIcwp+v95N7k1KH5
         QujDvquNDd/4aaXyM3vyjPoCHBQiwBRqKgVeGFAJuPrY4ZyPMS9VETzQf+3sBlaK32CA
         FTMsIR3aCXKyHv1iERdS32Upk2PI6cl8SvlaOAZUTfLfvDlYEarzX2j4E2QcKgyPtLF1
         09aE8tUr8VJTMBWuTZtiV5cNj5g/ALKlVr1rgCjN4WwxIQCciURvIhQmI3IQ/zQ+teU6
         cNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678207532;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4XM5xVF0nTvf8PGtK7KVlUTEedOy4rXUSvv5qvd10Z8=;
        b=YhiOfBrWzIEw5rXoZRmLXxlOSpFydDVmEkMBJvS97lTp97Zy6DkeLFjVCSudwzftyK
         q0O1RJobUaKb3nR0tGCZ1focZw9H6VWIVhQzSaCcrqSoswqdaO6vXxsFRjibYR3P/kad
         NJIuSR8bZx/3OMPJGx4qvnZSgPne0+IjIpNsoEh4IG4to7utuYEMm8hn6qU6GU3mjwPx
         iI+jlYbEgUPlbzazzNw5EvABvGG08xXRy3iiTmilv8y9i3X6ucO7qYqMMMo4HnHeoYDm
         UtWgtlOIfdA21o2qfRmSH7l900lLUBfrxyFmQcNNNZ5TSaIvtCBXgVqFX53UYYKi6rqI
         CcIw==
X-Gm-Message-State: AO0yUKV0mmWZy4IrfVeUqTDp0Yw5ygZIp5+gxM6QcdKU8Dg6j5HdaPzH
        XP7V676LjI+3vgdLZdUmgcLOkQaT1CQl2A==
X-Google-Smtp-Source: AK7set8JatIYe37Sabh+QT7f8224h0QXzl7Dgf547WyAqjIOo0UZGQ5rhO1sVSbVuIH/SCBVvGDZm+71k7J4MQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:c3:b0:9f1:6c48:f95f with SMTP id
 i3-20020a05690200c300b009f16c48f95fmr7263232ybs.5.1678207531919; Tue, 07 Mar
 2023 08:45:31 -0800 (PST)
Date:   Tue,  7 Mar 2023 16:45:30 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307164530.771896-1-edumazet@google.com>
Subject: [PATCH net] af_unix: fix struct pid leaks in OOB support
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot+7699d9e5635c10253a27@syzkaller.appspotmail.com,
        Rao Shoaib <rao.shoaib@oracle.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported struct pid leak [1].

Issue is that queue_oob() calls maybe_add_creds() which potentially
holds a reference on a pid.

But skb->destructor is not set (either directly or by calling
unix_scm_to_skb())

This means that subsequent kfree_skb() or consume_skb() would leak
this reference.

In this fix, I chose to fully support scm even for the OOB message.

[1]
BUG: memory leak
unreferenced object 0xffff8881053e7f80 (size 128):
comm "syz-executor242", pid 5066, jiffies 4294946079 (age 13.220s)
hex dump (first 32 bytes):
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
backtrace:
[<ffffffff812ae26a>] alloc_pid+0x6a/0x560 kernel/pid.c:180
[<ffffffff812718df>] copy_process+0x169f/0x26c0 kernel/fork.c:2285
[<ffffffff81272b37>] kernel_clone+0xf7/0x610 kernel/fork.c:2684
[<ffffffff812730cc>] __do_sys_clone+0x7c/0xb0 kernel/fork.c:2825
[<ffffffff849ad699>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
[<ffffffff849ad699>] do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
[<ffffffff84a0008b>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Reported-by: syzbot+7699d9e5635c10253a27@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Rao Shoaib <rao.shoaib@oracle.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/unix/af_unix.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 347122c3575eaae597405369e2e9d8324d6ad240..0b0f18ecce4470d6fd21c084a3ea49e04dcbb9bd 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2105,7 +2105,8 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
 #define UNIX_SKB_FRAGS_SZ (PAGE_SIZE << get_order(32768))
 
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
-static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other)
+static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other,
+		     struct scm_cookie *scm, bool fds_sent)
 {
 	struct unix_sock *ousk = unix_sk(other);
 	struct sk_buff *skb;
@@ -2116,6 +2117,11 @@ static int queue_oob(struct socket *sock, struct msghdr *msg, struct sock *other
 	if (!skb)
 		return err;
 
+	err = unix_scm_to_skb(scm, skb, !fds_sent);
+	if (err < 0) {
+		kfree_skb(skb);
+		return err;
+	}
 	skb_put(skb, 1);
 	err = skb_copy_datagram_from_iter(skb, 0, &msg->msg_iter, 1);
 
@@ -2243,7 +2249,7 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 	if (msg->msg_flags & MSG_OOB) {
-		err = queue_oob(sock, msg, other);
+		err = queue_oob(sock, msg, other, &scm, fds_sent);
 		if (err)
 			goto out_err;
 		sent++;
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

