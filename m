Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D84E5C44
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfJZNU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728608AbfJZNUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:20:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A44F02070B;
        Sat, 26 Oct 2019 13:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096024;
        bh=t60YEIkTPM+weChxBuQ9RL7zky9tW+NV2nEWVLpqr8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOto8NhTURjLqudCTr+yqPs8SVm2XP8crAIvf6q08wyZYUPe5FCgyTXZuYF56hg5i
         RPtT+0bG752i8ZrOZAzwMIW2MH0mErxWgt1NYOBsYNkZ4TqZ+F4OSo9GghsAZW/6tA
         qfrsWPZUT+9cGQ2KoI2Cukt13HJM3IASugNZk6zU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 37/59] net/smc: receive pending data after RCV_SHUTDOWN
Date:   Sat, 26 Oct 2019 09:18:48 -0400
Message-Id: <20191026131910.3435-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131910.3435-1-sashal@kernel.org>
References: <20191026131910.3435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karsten Graul <kgraul@linux.ibm.com>

[ Upstream commit 107529e31a87acd475ff6a0f82745821b8f70fec ]

smc_rx_recvmsg() first checks if data is available, and then if
RCV_SHUTDOWN is set. There is a race when smc_cdc_msg_recv_action() runs
in between these 2 checks, receives data and sets RCV_SHUTDOWN.
In that case smc_rx_recvmsg() would return from receive without to
process the available data.
Fix that with a final check for data available if RCV_SHUTDOWN is set.
Move the check for data into a function and call it twice.
And use the existing helper smc_rx_data_available().

Fixes: 952310ccf2d8 ("smc: receive data from RMBE")
Reviewed-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_rx.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 1ee5fdbf8284e..36340912df48a 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -262,6 +262,18 @@ static int smc_rx_recv_urg(struct smc_sock *smc, struct msghdr *msg, int len,
 	return -EAGAIN;
 }
 
+static bool smc_rx_recvmsg_data_available(struct smc_sock *smc)
+{
+	struct smc_connection *conn = &smc->conn;
+
+	if (smc_rx_data_available(conn))
+		return true;
+	else if (conn->urg_state == SMC_URG_VALID)
+		/* we received a single urgent Byte - skip */
+		smc_rx_update_cons(smc, 0);
+	return false;
+}
+
 /* smc_rx_recvmsg - receive data from RMBE
  * @msg:	copy data to receive buffer
  * @pipe:	copy data to pipe if set - indicates splice() call
@@ -303,15 +315,18 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 		if (read_done >= target || (pipe && read_done))
 			break;
 
-		if (atomic_read(&conn->bytes_to_rcv))
+		if (smc_rx_recvmsg_data_available(smc))
 			goto copy;
-		else if (conn->urg_state == SMC_URG_VALID)
-			/* we received a single urgent Byte - skip */
-			smc_rx_update_cons(smc, 0);
 
 		if (sk->sk_shutdown & RCV_SHUTDOWN ||
-		    conn->local_tx_ctrl.conn_state_flags.peer_conn_abort)
+		    conn->local_tx_ctrl.conn_state_flags.peer_conn_abort) {
+			/* smc_cdc_msg_recv_action() could have run after
+			 * above smc_rx_recvmsg_data_available()
+			 */
+			if (smc_rx_recvmsg_data_available(smc))
+				goto copy;
 			break;
+		}
 
 		if (read_done) {
 			if (sk->sk_err ||
-- 
2.20.1

