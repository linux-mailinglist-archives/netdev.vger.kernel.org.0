Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90636AE3E7
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjCGPGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjCGPFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:05:53 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E67A8C53E
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 07:00:01 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536a5a0b6e3so140088207b3.10
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 07:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678201200;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1IX38k+eZqrRt7DSF2usTvftjI1Li1IIGUa3FUvtn3c=;
        b=n12H2wnvnAboaduM5r5LOQeDCpA6cALsaba4Hy9hSJeOj30b0tIgnzJrfDgLYDb6gd
         9MSkCRAJUY+R8+b/qegv5AqCnDQetvW2tjP0drY1MotBwILrXnUQjYYPo5cTbUNTwSyD
         /mqCkxaUGV7JvdfDkRuQpfttoe415fGSxq/wh3jMD7TynLsIZBbpZOcxhByyz0P2nQhK
         OAmozMJ4dMHS2+h0x7ueCIzYyn9TNaMNxgXEOTtpSQI0YXrS8J4N3r/HAXLXvE6f0U2B
         Pq29jagrXd4qp+auE4lXxLgnQv661Sd6FrTwphejMCPga0t0FBWJpUDlHz2ta9StV7wi
         oX4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678201200;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1IX38k+eZqrRt7DSF2usTvftjI1Li1IIGUa3FUvtn3c=;
        b=4HdsUIPrhxKNl86n0drpUPWDAqMN14+uYsH1/kfUICn5nLdu2runMrPOwjqdjYWnHH
         aeCLeAQFSNQhNAEn+mM7xoo0lcGReS1JrdOSO8YfqM35Xdc7J0bcXYSn4nWR7+6s5nA6
         PsLbqtMwdeyjfDpB74uXkD/BFa4woDp4ze/qd844ukT/8OObBlj7m4V3sAiC5HfI/y76
         WX5RXiCNadjf/TWRPeVT6fd/hlj3RT7bFlbcdLF/hP6NXqe2tLHi0Yr92J52oCd8T5vw
         nYurKcfui9HtLphN1mryYOWNKnUAUT8Q/SfyoyWUY1+ufGICgysrSxyNnFkQhvSVQEwc
         NvKA==
X-Gm-Message-State: AO0yUKW3Uxh5WhRM52N9pgEfo7DB9m2XUfDkLiMyTbJ0+hgSv5tMbhFN
        bNhm5Uoaxk5MuttLLuWulEwYoZtq2mCY+g==
X-Google-Smtp-Source: AK7set/+wbP9pDMz9von7qfGO7u/Mx1aHz8JsrzFzzCNroAozRe1X5sEBXwOMcX8sDUnRNfRjDsCgLrjTl/HTQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:10e:b0:98e:6280:74ca with SMTP
 id o14-20020a056902010e00b0098e628074camr6765564ybh.1.1678201200660; Tue, 07
 Mar 2023 07:00:00 -0800 (PST)
Date:   Tue,  7 Mar 2023 14:59:59 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307145959.750210-1-edumazet@google.com>
Subject: [PATCH net-next] net: reclaim skb->scm_io_uring bit
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Jens Axboe <axboe@kernel.dk>
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

Commit 0091bfc81741 ("io_uring/af_unix: defer registered
files gc to io_uring release") added one bit to struct sk_buff.

This structure is critical for networking, and we try very hard
to not add bloat on it, unless absolutely required.

For instance, we can use a specific destructor as a wrapper
around unix_destruct_scm(), to identify skbs that unix_gc()
has to special case.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 include/linux/skbuff.h | 2 --
 include/net/af_unix.h  | 1 +
 io_uring/rsrc.c        | 3 +--
 net/unix/garbage.c     | 2 +-
 net/unix/scm.c         | 6 ++++++
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ff7ad331fb8259fd06c07913dfa197d7ac448390..fe661011644b8f468ff5e92075a6624f0557584c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -810,7 +810,6 @@ typedef unsigned char *sk_buff_data_t;
  *	@csum_level: indicates the number of consecutive checksums found in
  *		the packet minus one that have been verified as
  *		CHECKSUM_UNNECESSARY (max 3)
- *	@scm_io_uring: SKB holds io_uring registered files
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
  *	@slow_gro: state present at GRO time, slower prepare step required
@@ -989,7 +988,6 @@ struct sk_buff {
 #endif
 	__u8			slow_gro:1;
 	__u8			csum_not_inet:1;
-	__u8			scm_io_uring:1;
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 480fa579787e597f264ae26a32e519c235ce1d39..45ebde587138e59f8331d358420d3fca79d9ee66 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -11,6 +11,7 @@
 void unix_inflight(struct user_struct *user, struct file *fp);
 void unix_notinflight(struct user_struct *user, struct file *fp);
 void unix_destruct_scm(struct sk_buff *skb);
+void io_uring_destruct_scm(struct sk_buff *skb);
 void unix_gc(void);
 void wait_for_unix_gc(void);
 struct sock *unix_get_socket(struct file *filp);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a59fc02de5983c4f789e9cdfea3a1376f578ebe6..27ceda3b50cf4e677cde5e2417a80adad66e162f 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -867,8 +867,7 @@ int __io_scm_file_account(struct io_ring_ctx *ctx, struct file *file)
 
 		UNIXCB(skb).fp = fpl;
 		skb->sk = sk;
-		skb->scm_io_uring = 1;
-		skb->destructor = unix_destruct_scm;
+		skb->destructor = io_uring_destruct_scm;
 		refcount_add(skb->truesize, &sk->sk_wmem_alloc);
 	}
 
diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index dc27635403932154f3dec069c2e10d2ae365d8cb..2405f0f9af31c0ccefe2aa404002cfab8583c090 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -305,7 +305,7 @@ void unix_gc(void)
 	 * release.path eventually putting registered files.
 	 */
 	skb_queue_walk_safe(&hitlist, skb, next_skb) {
-		if (skb->scm_io_uring) {
+		if (skb->destructor == io_uring_destruct_scm) {
 			__skb_unlink(skb, &hitlist);
 			skb_queue_tail(&skb->sk->sk_receive_queue, skb);
 		}
diff --git a/net/unix/scm.c b/net/unix/scm.c
index aa27a02478dc1a7e4022f77e6ea7ac55f40b95c7..f9152881d77f636f9500d1b57fdda584df845fc2 100644
--- a/net/unix/scm.c
+++ b/net/unix/scm.c
@@ -152,3 +152,9 @@ void unix_destruct_scm(struct sk_buff *skb)
 	sock_wfree(skb);
 }
 EXPORT_SYMBOL(unix_destruct_scm);
+
+void io_uring_destruct_scm(struct sk_buff *skb)
+{
+	unix_destruct_scm(skb);
+}
+EXPORT_SYMBOL(io_uring_destruct_scm);
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

