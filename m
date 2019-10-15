Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F36D7016
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 09:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfJOHYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 03:24:49 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40120 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfJOHYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 03:24:49 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so11876401pfb.7;
        Tue, 15 Oct 2019 00:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KJHJMWPt8LmPMLLI5wCldlqqiCjwCa9/7SUVMzKhjEQ=;
        b=Pv2MgHMbxH5uV/C0Izeennt9dyw4UOlO7GrYaYJTX5+UgaAPwMMCkLCAvPIKCkTFN8
         EqfeoJFrT3zUiZ4DM3RMf6EXhfOPyXOQoXwsLgOu7fug21siPRixIugDqh/TLlLDmCcW
         oIcq5bkfQhppAipR98AsumNv4mK6d5AqGyFfP/lBRgayyF532AC9xmf15nv3Oe+uZtGm
         RVW3wsU1WzoWmGFMSKipAaEcuFNhQE5q483FrjM1ieNbRfcD0w7U6IUqirvgpZTtJwVL
         Eik+9ivWKo2q0MvnPH/uj10632RWiFwamheL05yBRGdN/2E1efA7Glcp73EAb4zzrXwR
         vu7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KJHJMWPt8LmPMLLI5wCldlqqiCjwCa9/7SUVMzKhjEQ=;
        b=aLI5VdsSTkUiQFPoywq/G3KRPiqB7H6lUwlKb45H445qbg/KfLl9RZFEl1sfW6s4Yy
         sOf0z+nFV5Xf5psVkUMDtyXYnSqgSISiBCPlQ9Occ9fvph8z3Xhgbiy1U0EwftQws20M
         LlmRvdC/Yws1aHW7/HEzv1HVrYDryuoO9ot7/qgw32/M5MDR+aEqEKuC5Ui/2sI+yB1d
         7o06+hNIULfZElj4L4nTJzM7MZ87CZiGMG6KPjbGhEy1duie6DIffxPKbx4j6uktevt2
         Xra0CriBqv5OEWc33HzBTF0Is0DQRg5DGgee+OffJ8voeISrkcEfZ0K4Einx/jaSMtrk
         4q5A==
X-Gm-Message-State: APjAAAVUaQ6c/iELl7SlH4KWGyEv6IUGoU4Y7fg7r6UZmZvqzHD3p6IB
        5fAimsr3zciN2RIH3e0w6kU/TqV7
X-Google-Smtp-Source: APXvYqwz2aQUjVHw8RIUbJu/D184X+eavo2U8T2pEHbvl4MDbsvELAu1AxobrAcsK1AmNn848WPAZA==
X-Received: by 2002:aa7:970b:: with SMTP id a11mr35518485pfg.37.1571124286313;
        Tue, 15 Oct 2019 00:24:46 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c26sm18472554pfo.173.2019.10.15.00.24.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 00:24:45 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net] sctp: change sctp_prot .no_autobind with true
Date:   Tue, 15 Oct 2019 15:24:38 +0800
Message-Id: <06beb8a9ceaec9224a507b58d3477da106c5f0cd.1571124278.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a memory leak:

  BUG: memory leak, unreferenced object 0xffff888120b3d380 (size 64):
  backtrace:

    [...] slab_alloc mm/slab.c:3319 [inline]
    [...] kmem_cache_alloc+0x13f/0x2c0 mm/slab.c:3483
    [...] sctp_bucket_create net/sctp/socket.c:8523 [inline]
    [...] sctp_get_port_local+0x189/0x5a0 net/sctp/socket.c:8270
    [...] sctp_do_bind+0xcc/0x200 net/sctp/socket.c:402
    [...] sctp_bindx_add+0x4b/0xd0 net/sctp/socket.c:497
    [...] sctp_setsockopt_bindx+0x156/0x1b0 net/sctp/socket.c:1022
    [...] sctp_setsockopt net/sctp/socket.c:4641 [inline]
    [...] sctp_setsockopt+0xaea/0x2dc0 net/sctp/socket.c:4611
    [...] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3147
    [...] __sys_setsockopt+0x10f/0x220 net/socket.c:2084
    [...] __do_sys_setsockopt net/socket.c:2100 [inline]

It was caused by when sending msgs without binding a port, in the path:
inet_sendmsg() -> inet_send_prepare() -> inet_autobind() ->
.get_port/sctp_get_port(), sp->bind_hash will be set while bp->port is
not. Later when binding another port by sctp_setsockopt_bindx(), a new
bucket will be created as bp->port is not set.

sctp's autobind is supposed to call sctp_autobind() where it does all
things including setting bp->port. Since sctp_autobind() is called in
sctp_sendmsg() if the sk is not yet bound, it should have skipped the
auto bind.

THis patch is to avoid calling inet_autobind() in inet_send_prepare()
by changing sctp_prot .no_autobind with true, also remove the unused
.get_port.

Reported-by: syzbot+d44f7bbebdea49dbc84a@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 939b8d2..5ca0ec0 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9500,7 +9500,7 @@ struct proto sctp_prot = {
 	.backlog_rcv =	sctp_backlog_rcv,
 	.hash        =	sctp_hash,
 	.unhash      =	sctp_unhash,
-	.get_port    =	sctp_get_port,
+	.no_autobind =	true,
 	.obj_size    =  sizeof(struct sctp_sock),
 	.useroffset  =  offsetof(struct sctp_sock, subscribe),
 	.usersize    =  offsetof(struct sctp_sock, initmsg) -
@@ -9542,7 +9542,7 @@ struct proto sctpv6_prot = {
 	.backlog_rcv	= sctp_backlog_rcv,
 	.hash		= sctp_hash,
 	.unhash		= sctp_unhash,
-	.get_port	= sctp_get_port,
+	.no_autobind	= true,
 	.obj_size	= sizeof(struct sctp6_sock),
 	.useroffset	= offsetof(struct sctp6_sock, sctp.subscribe),
 	.usersize	= offsetof(struct sctp6_sock, sctp.initmsg) -
-- 
2.1.0

