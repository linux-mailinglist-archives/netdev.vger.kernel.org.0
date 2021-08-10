Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3EB83E51EA
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 06:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbhHJESV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 00:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237242AbhHJER4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 00:17:56 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350CEC0613D3;
        Mon,  9 Aug 2021 21:17:33 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d17so19210145plr.12;
        Mon, 09 Aug 2021 21:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OIcoax9PQR0R3OnS5s26gNkuo62hz7EbqgNWPiTkgQM=;
        b=lAH95ClMQCGVsVezjaAKFYn2KOwKLL38WigaMEuHcmdwKJrXLdhdlfBf+6mNuxQv2D
         G5+p2a0jm3H+rBVWMN5ojVgcHbBG87vq+KGdk/R9FUVvQNKcAXw8PauG+f+8pnhMTiHw
         uxjHra7w5+S39KfkMVk8Bw5/Cte+uKXNLg5c67WAy6OBxK92uOHn7QgfxNgYgvlLpUA5
         S4qEXAWVpWQFwIOaj5iKii0jGzQJeEu7v44R7B9cofNeG8RNuinzGld7YNqQqGRvG7XD
         UVNetqQlFPfbe+voiQZRr/gEkXHH7JTdYuW5u/J0YaxcRo2RCdeMYvyryjG8qdNprQbh
         FXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OIcoax9PQR0R3OnS5s26gNkuo62hz7EbqgNWPiTkgQM=;
        b=G00zuEMTMf3Hln5Mt+lQ+JnXiiiM6TZG2qQ/urLlDo3YtS8zTsMK+o9fIDoksuVN/M
         Ppx/yOJck3mKnyCtFgEiOOxtko7u4rO5zaqdYH/I1jFdx9eUZ22xnLs4LMPvsvQPz9XW
         QzcaDQNPVMpzykOTDNgq8XVV5rZq+9KQG+5gzFGnQ5xOn2SRztvsrC+BAAFHBW1Fcx4j
         osiW3tcld5kTzyMWsLuqSRpF6+oM622B35v6zABNJigdijCmuXrqmg6LQixa9ntf+pA7
         dMkKf/O+zDrxoozAqO0GeU1sBx7bmKNM7rTFt5B/6K7gJteg6gE/6hQOSWmefe6fEiXN
         cAPQ==
X-Gm-Message-State: AOAM530lueWELQbu8TCacKpik8pUOd7f4DgCvDl76ZGrV5McFCdDiWP1
        VJBphrgSRGjvPcJKmqcuQx4=
X-Google-Smtp-Source: ABdhPJwfTlSiybFidKyx8OGCgRRGpma1nh/Zbq4L8DCNiIjmWbxmyUIYmQeEEzzwGsDYHxZXCKVe9Q==
X-Received: by 2002:a63:8ac2:: with SMTP id y185mr159072pgd.179.1628569052608;
        Mon, 09 Aug 2021 21:17:32 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id b8sm20132478pjo.51.2021.08.09.21.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 21:17:32 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v6 6/6] Bluetooth: fix repeated calls to sco_sock_kill
Date:   Tue, 10 Aug 2021 12:14:10 +0800
Message-Id: <20210810041410.142035-7-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810041410.142035-1-desmondcheongzx@gmail.com>
References: <20210810041410.142035-1-desmondcheongzx@gmail.com>
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
index 77490338f4fa..98a881586512 100644
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
 
@@ -197,7 +195,6 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 		sco_sock_clear_timer(sk);
 		sco_chan_del(sk, err);
 		release_sock(sk);
-		sco_sock_kill(sk);
 		sock_put(sk);
 
 		/* Ensure no more work items will run before freeing conn. */
@@ -404,8 +401,7 @@ static void sco_sock_cleanup_listen(struct sock *parent)
  */
 static void sco_sock_kill(struct sock *sk)
 {
-	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket ||
-	    sock_flag(sk, SOCK_DEAD))
+	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
 		return;
 
 	BT_DBG("sk %p state %d", sk, sk->sk_state);
@@ -457,7 +453,6 @@ static void sco_sock_close(struct sock *sk)
 	sco_sock_clear_timer(sk);
 	__sco_sock_close(sk);
 	release_sock(sk);
-	sco_sock_kill(sk);
 }
 
 static void sco_skb_put_cmsg(struct sk_buff *skb, struct msghdr *msg,
-- 
2.25.1

