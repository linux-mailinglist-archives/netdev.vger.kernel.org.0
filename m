Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C383E04D3
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbhHDPuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239555AbhHDPtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:49:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4676AC0617A0;
        Wed,  4 Aug 2021 08:48:59 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so4189184pjb.2;
        Wed, 04 Aug 2021 08:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zIRbv5ZXxIid872Ol8a8JiBpz6JG4aviAWXZnPlaMDM=;
        b=rdJHyKNkVdzEDu+i17BA0ESSeSHw7WdgDcmPzNzHC5dNA/1Da4om9QYVZAQ4eTNOjp
         nE7CuugZzapfrdXloo+i/YUsSvvhPFb8bL/XF5p6FrBQ0OqA2vxwuuZ2sM5q1vxRpRue
         n0O0otg/gigaHc2qifkS2eW1v/eG19WJXQ/iS+t6g1Esnq/NqkYKxcYuQjkLbTq/6COt
         CAuJtvNvD3qolCfKL0fDxxGKxq6BLmjxxVeIP6P1H1GHP9ukH7cFRBxdeCgh2Iv4T8tC
         ukT5oftekjWfwOTmCOFM6YyyGyTXX/3a8wSbvliCRkgp6dtFCLUCCTzM5CrqfO7m9XU5
         Do0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zIRbv5ZXxIid872Ol8a8JiBpz6JG4aviAWXZnPlaMDM=;
        b=ersTFvuKsw/bo1mk+TXK65cmFfXMPrBNu8rOsAQYYVLdh5iztpnZpocGq1Mi5F8B36
         dTSrT5AinLzXTrRanJuI85MjCSlJi1nGCLCi0Sr+TZLn8gA8UjyPnzH8JNVf8cO0CyZs
         m5Fm+HzReU9yEsQ2tMcJe7pbIT81dTcpzWo4u2dUn2lgF2SZPBMCkcs97yR5zUNEMarX
         /g9zNBQI9kQ01IBVVxPoKqzaYZZOGx+oWaSbTmZ17m2JcqNNqYWIC17pYIGpSnpx4i0x
         cUur+GW5D9t15+f/tFfuMsjLNHSNBe8tv+baWHoX7y5QiOj5oqOdnD5OJFhiw0FVTozV
         uKIA==
X-Gm-Message-State: AOAM531hyo+muHu7o/2QdNqD4dyaiVxZQU2dvbDGvfPyLgyf0sI+hKot
        OXaQaZ8/Ny5z3HLt9Ph2yjg=
X-Google-Smtp-Source: ABdhPJwP+rVDzJk6NLCQWzc1MhjnFtm/lsX/BNe/Q5+lIAcE/FyZ6bVOH1EuWhB8m67xqjLUaSJHpA==
X-Received: by 2002:a17:90a:bd18:: with SMTP id y24mr10513325pjr.83.1628092138838;
        Wed, 04 Aug 2021 08:48:58 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id b15sm4007274pgj.60.2021.08.04.08.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:48:58 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [RESEND PATCH v5 6/6] Bluetooth: fix repeated calls to sco_sock_kill
Date:   Wed,  4 Aug 2021 23:47:12 +0800
Message-Id: <20210804154712.929986-7-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804154712.929986-1-desmondcheongzx@gmail.com>
References: <20210804154712.929986-1-desmondcheongzx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 4e1a720d0312 ("Bluetooth: avoid killing an already killed
socket"), a check was added to sco_sock_kill to skip killing a socket
if the SOCK_DEAD flag was set.

This was done after a trace for a use-after-free bug showed that the
same sock pointer was being killed twice.

Unfortunately, this check prevents sco_sock_kill from running on any
socket. sco_sock_kill kills a socket only if it's zapped and orphaned,
however sock_orphan announces that the socket is dead before detaching
it. i.e., orphaned sockets have the SOCK_DEAD flag set.

To fix this, we remove the check for SOCK_DEAD, and avoid repeated
calls to sco_sock_kill by removing incorrect calls in:

1. sco_sock_timeout. The socket should not be killed on timeout as
further processing is expected to be done. For example,
sco_sock_connect sets the timer then waits for the socket to be
connected or for an error to be returned.

2. sco_conn_del. This function should clean up resources for the
connection, but the socket itself should be cleaned up in
sco_sock_release.

3. sco_sock_close. Calls to sco_sock_close in sco_sock_cleanup_listen
and sco_sock_release are followed by sco_sock_kill. Hence the
duplicated call should be removed.

Fixes: 4e1a720d0312 ("Bluetooth: avoid killing an already killed socket")
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---
 net/bluetooth/sco.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 418543c390b3..cf43ccb50573 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -97,8 +97,6 @@ static void sco_sock_timeout(struct work_struct *work)
 	sk->sk_err = ETIMEDOUT;
 	sk->sk_state_change(sk);
 	release_sock(sk);
-
-	sco_sock_kill(sk);
 	sock_put(sk);
 }
 
@@ -203,7 +201,6 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 		sco_sock_clear_timer(sk);
 		sco_chan_del(sk, err);
 		release_sock(sk);
-		sco_sock_kill(sk);
 		sock_put(sk);
 
 		/* Ensure no more work items will run before freeing conn. */
@@ -410,8 +407,7 @@ static void sco_sock_cleanup_listen(struct sock *parent)
  */
 static void sco_sock_kill(struct sock *sk)
 {
-	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket ||
-	    sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
 		return;
 
 	BT_DBG("sk %p state %d", sk, sk->sk_state);
@@ -463,7 +459,6 @@ static void sco_sock_close(struct sock *sk)
 	sco_sock_clear_timer(sk);
 	__sco_sock_close(sk);
 	release_sock(sk);
-	sco_sock_kill(sk);
 }
 
 static void sco_skb_put_cmsg(struct sk_buff *skb, struct msghdr *msg,
-- 
2.25.1

