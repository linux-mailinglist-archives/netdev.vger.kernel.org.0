Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5352C500BB
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 06:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfFXE1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 00:27:08 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38666 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbfFXE1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 00:27:07 -0400
Received: by mail-qt1-f193.google.com with SMTP id n11so1886295qtl.5
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 21:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TpfEq+s9BJouFPdTNLC/BNws0AXhM6t7c+nUi8pwy3M=;
        b=N4AO9uAgy4G0uCcEd/vWPMrgswbuVCILRAlhSRPIgyZLq9TaLj6nEDLXLYJNxOojoh
         8xT+PFzszGnGhEeG8FZ0ZrfQH8odkyXXjHPdpEbOU7GHmWVnOH1eR71V5En0c7IBTyWN
         cb7IHcs+GTbjsdbIUKWeuxJuhps5PeCsBQoHSXFZFJB+Wl/ZVPs0U6F9HQziFxq2woL4
         BdZgZWgJwumTMUSvTu7MbKRgUecJkuv7LAfROid6pEYyd43bN28OCn6RYyCsmswMokpy
         5PmP3OmpuGArQM+dRXwVGTUnIxZ2xIvDnuBr9e8Fqw08dX8fLOCnEhvk5w/J1W47OifR
         o5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TpfEq+s9BJouFPdTNLC/BNws0AXhM6t7c+nUi8pwy3M=;
        b=AyG0oBOrFirbqpkLWwshHom6cUJI92ajKRsW27CJDWjyeWQhFzoSalZuME5mua61xG
         M3pIzaBxsqJdxxNvn+Q3idA2SvNHWxBbprh8cHMuIajnHNhjqIbgN5Dwh/dquq51Px9q
         r0DX0iN30LrXyyBnlDMHhpqsWKRGcrHAqp+emwAb3VmDiRuaixluuDMMNQU1wKJZQpV7
         KxgLYf0co87kuiMPOV/PPFmFQ5+DgOXe6Vf7L4zY3aceV23mxEsXAXLok21uOLZthGo1
         /jlLaifAfFPCjd8XT0Zu1aaHqHhEyd16/HIBSs7Mpcpa0uGFKlF8KAmB+9/KPAKGbqM5
         6iPg==
X-Gm-Message-State: APjAAAVERAv0zu15k66ZFsyDkvKMLuIUnnUqyAKqJsH0PZkxeTeCLaID
        YvzrOXjUbPsCSNkQYUwBUtnhfA==
X-Google-Smtp-Source: APXvYqzY00wNvldLgMZCkTPmUNJx7xZtcBwA12DQu2g2UgVJ5Cw2WSHxJpKBNI/Ez8R7Z7A/M6PukQ==
X-Received: by 2002:ac8:2309:: with SMTP id a9mr64085470qta.103.1561350426574;
        Sun, 23 Jun 2019 21:27:06 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t29sm6745997qtt.42.2019.06.23.21.27.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 23 Jun 2019 21:27:05 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        john.fastabend@gmail.com, vakul.garg@nxp.com, borisp@mellanox.com,
        alexei.starovoitov@gmail.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net] net/tls: fix page double free on TX cleanup
Date:   Sun, 23 Jun 2019 21:26:58 -0700
Message-Id: <20190624042658.19198-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

With commit 94850257cf0f ("tls: Fix tls_device handling of partial records")
a new path was introduced to cleanup partial records during sk_proto_close.
This path does not handle the SW KTLS tx_list cleanup.

This is unnecessary though since the free_resources calls for both
SW and offload paths will cleanup a partial record.

The visible effect is the following warning, but this bug also causes
a page double free.

    WARNING: CPU: 7 PID: 4000 at net/core/stream.c:206 sk_stream_kill_queues+0x103/0x110
    RIP: 0010:sk_stream_kill_queues+0x103/0x110
    RSP: 0018:ffffb6df87e07bd0 EFLAGS: 00010206
    RAX: 0000000000000000 RBX: ffff8c21db4971c0 RCX: 0000000000000007
    RDX: ffffffffffffffa0 RSI: 000000000000001d RDI: ffff8c21db497270
    RBP: ffff8c21db497270 R08: ffff8c29f4748600 R09: 000000010020001a
    R10: ffffb6df87e07aa0 R11: ffffffff9a445600 R12: 0000000000000007
    R13: 0000000000000000 R14: ffff8c21f03f2900 R15: ffff8c21f03b8df0
    Call Trace:
     inet_csk_destroy_sock+0x55/0x100
     tcp_close+0x25d/0x400
     ? tcp_check_oom+0x120/0x120
     tls_sk_proto_close+0x127/0x1c0
     inet_release+0x3c/0x60
     __sock_release+0x3d/0xb0
     sock_close+0x11/0x20
     __fput+0xd8/0x210
     task_work_run+0x84/0xa0
     do_exit+0x2dc/0xb90
     ? release_sock+0x43/0x90
     do_group_exit+0x3a/0xa0
     get_signal+0x295/0x720
     do_signal+0x36/0x610
     ? SYSC_recvfrom+0x11d/0x130
     exit_to_usermode_loop+0x69/0xb0
     do_syscall_64+0x173/0x180
     entry_SYSCALL_64_after_hwframe+0x3d/0xa2
    RIP: 0033:0x7fe9b9abc10d
    RSP: 002b:00007fe9b19a1d48 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
    RAX: fffffffffffffe00 RBX: 0000000000000006 RCX: 00007fe9b9abc10d
    RDX: 0000000000000002 RSI: 0000000000000080 RDI: 00007fe948003430
    RBP: 00007fe948003410 R08: 00007fe948003430 R09: 0000000000000000
    R10: 0000000000000000 R11: 0000000000000246 R12: 00005603739d9080
    R13: 00007fe9b9ab9f90 R14: 00007fe948003430 R15: 0000000000000000

Fixes: 94850257cf0f ("tls: Fix tls_device handling of partial records")
Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/tls.h  | 15 ---------------
 net/tls/tls_main.c |  3 ++-
 2 files changed, 2 insertions(+), 16 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 4a55ce6a303f..53d96bca220d 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -373,21 +373,6 @@ static inline bool tls_is_partially_sent_record(struct tls_context *ctx)
 	return !!ctx->partially_sent_record;
 }
 
-static inline int tls_complete_pending_work(struct sock *sk,
-					    struct tls_context *ctx,
-					    int flags, long *timeo)
-{
-	int rc = 0;
-
-	if (unlikely(sk->sk_write_pending))
-		rc = wait_on_pending_writer(sk, timeo);
-
-	if (!rc && tls_is_partially_sent_record(ctx))
-		rc = tls_push_partial_record(sk, ctx, flags);
-
-	return rc;
-}
-
 static inline bool tls_is_pending_open_record(struct tls_context *tls_ctx)
 {
 	return tls_ctx->pending_open_record_frags;
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index fc81ae18cc44..e2b69e805d46 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -279,7 +279,8 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 		goto skip_tx_cleanup;
 	}
 
-	if (!tls_complete_pending_work(sk, ctx, 0, &timeo))
+	if (unlikely(sk->sk_write_pending) &&
+	    !wait_on_pending_writer(sk, &timeo))
 		tls_handle_open_record(sk, 0);
 
 	/* We need these for tls_sw_fallback handling of other packets */
-- 
2.21.0

