Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 794BE13F2B0
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436815AbgAPShE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:37:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390610AbgAPRM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EE9324690;
        Thu, 16 Jan 2020 17:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194775;
        bh=bJUm5nK+rfL/cXysbF/6l/nRR6yIxDo6UYp8z+0j554=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XP2cs0Vc79R5k9xFXmikrHzEzsRXXJJZqMjExeIH0LJtkKzQLVUAkzRpFP1cjn0f+
         eVe0pOBqlwuxDD+O8zyvFsfn51LMIu+DgBt617DL/whIGzG3XrEbedpLtjoporfdhj
         btxtpsIck23sU++4Gu+pZb4rwlNP92V7gxGbujsY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 593/671] net/smc: receive returns without data
Date:   Thu, 16 Jan 2020 12:03:51 -0500
Message-Id: <20200116170509.12787-330-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 882dcfe5a1785c20f45820cbe6fec4b8b647c946 ]

smc_cdc_rxed_any_close_or_senddone() is used as an end condition for the
receive loop. This conflicts with smc_cdc_msg_recv_action() which could
run in parallel and set the bits checked by
smc_cdc_rxed_any_close_or_senddone() before the receive is processed.
In that case we could return from receive with no data, although data is
available. The same applies to smc_rx_wait().
Fix this by checking for RCV_SHUTDOWN only, which is set in
smc_cdc_msg_recv_action() after the receive was actually processed.

Fixes: 952310ccf2d8 ("smc: receive data from RMBE")
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_rx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index bbcf0fe4ae10..1ee5fdbf8284 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -212,8 +212,7 @@ int smc_rx_wait(struct smc_sock *smc, long *timeo,
 	rc = sk_wait_event(sk, timeo,
 			   sk->sk_err ||
 			   sk->sk_shutdown & RCV_SHUTDOWN ||
-			   fcrit(conn) ||
-			   smc_cdc_rxed_any_close_or_senddone(conn),
+			   fcrit(conn),
 			   &wait);
 	remove_wait_queue(sk_sleep(sk), &wait);
 	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
@@ -311,7 +310,6 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 			smc_rx_update_cons(smc, 0);
 
 		if (sk->sk_shutdown & RCV_SHUTDOWN ||
-		    smc_cdc_rxed_any_close_or_senddone(conn) ||
 		    conn->local_tx_ctrl.conn_state_flags.peer_conn_abort)
 			break;
 
-- 
2.20.1

