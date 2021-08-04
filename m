Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18B33DFFE0
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 13:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237880AbhHDLEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 07:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237956AbhHDLEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 07:04:43 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63A7C0617BC;
        Wed,  4 Aug 2021 04:04:28 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j1so2395318pjv.3;
        Wed, 04 Aug 2021 04:04:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zIRbv5ZXxIid872Ol8a8JiBpz6JG4aviAWXZnPlaMDM=;
        b=dkqVASp2vIm2+9eG8qv+AApsyYt3ZndFWyEGeg91xxlutOvj87XPa41NO4TcugMcMK
         qJtVwlAOK9GBt4h0MMZRsUPha8YZWIN0rxsPHOkkk1I81w3VUe07s7cJA5OLVyldzBF1
         +45RYhc4C3xNEwMIWp4n6o6miZNZSe3qMNMwtoS3Xp4l54BebRxP6MxrsS622bfEmjQN
         6X7nMmR0Jgpot93puCvPpPHMNzZQI7YSpQuGcl99zTiIb0ZCEvxNKwzjUmQUi88LlCn9
         uXfYRPoK+Qx3LRgo1GHEWOoBit+QggDmBLBgDMaqbhJBK9BqG+6sFoTe4AHpzwCYW/6+
         MfBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zIRbv5ZXxIid872Ol8a8JiBpz6JG4aviAWXZnPlaMDM=;
        b=UqaGgVj6CoVK/+DOksEsyuDLM0ELwGYIaMQ7JrVDZkpV7iku6/hJbRoOTh3Vn6qlXz
         nL9P18xeBdOydkC2Lsn+BgyQYqL4/tjS4kN7P1ElfGYiLFX/+pQ6kXQGRUv/ajQP2JH1
         5MNazYsM7rHMUOM7huWSPpFv9WeRki9947Y9D0OVwfIK7TfSvClyYqgu2Q+TI3e4g9CG
         vgHv99ZeI8k7/YF2FxeDNcif8kz2iGRI0MNo5k2ZX9mmXIsBDKDgtYYWq1lLFvJkB7Yt
         2Cjuy/C0koJdXw/ZYoiIxQwg9s1AjMDRDISG3rDE6oPUSexs9bq5GY62TYoK02R1Ap8I
         HJdA==
X-Gm-Message-State: AOAM533YkCf/Bo2mgmoXlSbbkUFUi2ElN2ffjTGcXslCOlCBD2pocLfV
        /Mw98qZ3rHoISoEWqwLc2xw=
X-Google-Smtp-Source: ABdhPJxYdG55SlPSNbYcL/QxOycARXWHFDr5RrHwa46cfambF1NpTtyt6+IEGe95qXWmdnXH+tNQBw==
X-Received: by 2002:a63:171d:: with SMTP id x29mr1357294pgl.418.1628075068468;
        Wed, 04 Aug 2021 04:04:28 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id k4sm2206147pjs.55.2021.08.04.04.04.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 04:04:28 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v5 6/6] Bluetooth: fix repeated calls to sco_sock_kill
Date:   Wed,  4 Aug 2021 19:03:08 +0800
Message-Id: <20210804110308.910744-7-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804110308.910744-1-desmondcheongzx@gmail.com>
References: <20210804110308.910744-1-desmondcheongzx@gmail.com>
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

