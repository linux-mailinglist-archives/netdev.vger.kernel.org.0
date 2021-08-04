Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8363A3DFFDB
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 13:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbhHDLEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 07:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237861AbhHDLE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 07:04:29 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73007C06179B;
        Wed,  4 Aug 2021 04:04:16 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id u16so2618154ple.2;
        Wed, 04 Aug 2021 04:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wuePCI4FbrrQHwWiYSThmxmEPxR9cgsWrPSKODj9+7k=;
        b=ZeyQaebz+I8qQT4Ub6+aQ5HL2PbtkM9sacpF80+Jy0H271i/JeWa/dDeOv10raNNGj
         AQrWEBvfXjqQKBlptoFQ/AskMbzPCIGXHxHEaKtsfmWzHE4LKFMoA9EWLirBZgdfvNyG
         klhLqfChZFDcLVl5F/JK3IY/PqUevXvLL02X+29OTWs5j9jnPeZX6tz+K9wkKvDkbiX7
         wPZjZ6K2E+10FGA5ofXJ7EJtdYHm5qdIRAXjpSXR3Ec+r0axCxkH0KGTdZHyGRzg5ZCr
         uOLz/ncGQyGSPIoA90c22XumSeSxWzqGnhYsExyWXTVFDqELt4ZCq0/T9Y5O+F2yzfUf
         q1RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wuePCI4FbrrQHwWiYSThmxmEPxR9cgsWrPSKODj9+7k=;
        b=uLjlhy4TOSggflNVhQMO/Qh0Zr3/KB6/OZ0pbwvbTyMNrzJ8SmrxWvDUMnafuEeaIG
         UP11bB4FsKb9e9KOfl5NRc3Q0Pd7Q3xYf5Drux4E0CDPWn2cvZZTkUO2JtRLEh2o8uxz
         rkldSXvdcLE1jYbTr+PnhA2CfySFBzkdZzJYxp7YJv2rt6HK8bwX4O7vuxntV+L2X9mb
         +ZMYIFayZBu9zb16xUMsy67Yje1BIZZ4EggNqRTn6zU696E88hjY+MtYvfPwW+HR90dD
         em7zS5xU3WBQpiK6oJhWAp3XH+7KynBuACOapifVaeeGw1Nlot+8ZqSxtKewND62Kbkb
         LXSg==
X-Gm-Message-State: AOAM531fEpN8J5PTfSvyU+XMM9u39+bXPom+497UNKS9bZdAvsadOcsU
        cq/PzdV55Xpn3pzvPwL8Ttg=
X-Google-Smtp-Source: ABdhPJzUKNNoQeqTm8yohHsjU8iT18AjzrgmdBaUfF7PHoha5iGqKI206C2n/5zO8ebm2SRAk8NvzA==
X-Received: by 2002:a17:90a:2c05:: with SMTP id m5mr3335774pjd.32.1628075055960;
        Wed, 04 Aug 2021 04:04:15 -0700 (PDT)
Received: from localhost.localdomain ([118.200.190.93])
        by smtp.gmail.com with ESMTPSA id k4sm2206147pjs.55.2021.08.04.04.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 04:04:15 -0700 (PDT)
From:   Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, kuba@kernel.org, sudipm.mukherjee@gmail.com
Cc:     Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH v5 4/6] Bluetooth: serialize calls to sco_sock_{set,clear}_timer
Date:   Wed,  4 Aug 2021 19:03:06 +0800
Message-Id: <20210804110308.910744-5-desmondcheongzx@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804110308.910744-1-desmondcheongzx@gmail.com>
References: <20210804110308.910744-1-desmondcheongzx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, calls to sco_sock_set_timer are made under the locked
socket, but this does not apply to all calls to sco_sock_clear_timer.

Both sco_sock_{set,clear}_timer should be serialized by lock_sock to
prevent unexpected concurrent clearing/setting of timers.

Additionally, since sco_pi(sk)->conn is only cleared under the locked
socket, this change allows us to avoid races between
sco_sock_clear_timer and the call to kfree(conn) in sco_conn_del.

Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
---
 net/bluetooth/sco.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 1246e6bc09fe..418543c390b3 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -459,8 +459,8 @@ static void __sco_sock_close(struct sock *sk)
 /* Must be called on unlocked socket. */
 static void sco_sock_close(struct sock *sk)
 {
-	sco_sock_clear_timer(sk);
 	lock_sock(sk);
+	sco_sock_clear_timer(sk);
 	__sco_sock_close(sk);
 	release_sock(sk);
 	sco_sock_kill(sk);
@@ -1110,8 +1110,8 @@ static void sco_conn_ready(struct sco_conn *conn)
 	BT_DBG("conn %p", conn);
 
 	if (sk) {
-		sco_sock_clear_timer(sk);
 		lock_sock(sk);
+		sco_sock_clear_timer(sk);
 		sk->sk_state = BT_CONNECTED;
 		sk->sk_state_change(sk);
 		release_sock(sk);
-- 
2.25.1

