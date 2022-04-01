Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D94F4EF4A5
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349133AbiDAOxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351106AbiDAOsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:48:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1673A5C650;
        Fri,  1 Apr 2022 07:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33D1560ECC;
        Fri,  1 Apr 2022 14:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFCEC3410F;
        Fri,  1 Apr 2022 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823913;
        bh=t2tijDUPP4VO64niUbgn0Fht/DzVe2yijHxsnN1fYIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhsuRAMKdBPekBeURXHI6+BqlN3mxLkSyDw3SGSTOdcL6ZJ6lUA3T+VQQnd9UOVYO
         nx7ztyPQEP6IuD4BXXzhLGplP1TNdsZKMhep0Es3vE1IImgb+3YxVwFSlzJF8ShCdL
         A9G7ALvnQZR3BP0IbAhalSu7H6Ou0QgE8rrsV/eNIFv0LXyT1xoSsj/Ew16BoXYrUX
         WSG27wfG6dSMNo51t/QXFh2FtfxEcJNgUHagdIincKGilP1ImCs0fEBmjnSu3TmYp0
         g0PEn8Jqj+Kw5CI6kXV5wGf1wh/Yv/7NRIx0MJedDyXVdBub8Y9Rh9TyMFfKFhrxe3
         v0P+VFDJRFiLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lu <tonylu@linux.alibaba.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kgraul@linux.ibm.com,
        kuba@kernel.org, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 16/98] net/smc: Send directly when TCP_CORK is cleared
Date:   Fri,  1 Apr 2022 10:36:20 -0400
Message-Id: <20220401143742.1952163-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Lu <tonylu@linux.alibaba.com>

[ Upstream commit ea785a1a573b390a150010b3c5b81e1ccd8c98a8 ]

According to the man page of TCP_CORK [1], if set, don't send out
partial frames. All queued partial frames are sent when option is
cleared again.

When applications call setsockopt to disable TCP_CORK, this call is
protected by lock_sock(), and tries to mod_delayed_work() to 0, in order
to send pending data right now. However, the delayed work smc_tx_work is
also protected by lock_sock(). There introduces lock contention for
sending data.

To fix it, send pending data directly which acts like TCP, without
lock_sock() protected in the context of setsockopt (already lock_sock()ed),
and cancel unnecessary dealyed work, which is protected by lock.

[1] https://linux.die.net/man/7/tcp

Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c |  4 ++--
 net/smc/smc_tx.c | 25 +++++++++++++++----------
 net/smc/smc_tx.h |  1 +
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 5c4c0320e822..183b122807b6 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2430,8 +2430,8 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		    sk->sk_state != SMC_CLOSED) {
 			if (!val) {
 				SMC_STAT_INC(smc, cork_cnt);
-				mod_delayed_work(smc->conn.lgr->tx_wq,
-						 &smc->conn.tx_work, 0);
+				smc_tx_pending(&smc->conn);
+				cancel_delayed_work(&smc->conn.tx_work);
 			}
 		}
 		break;
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 738a4a99c827..31ee76131a79 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -594,27 +594,32 @@ int smc_tx_sndbuf_nonempty(struct smc_connection *conn)
 	return rc;
 }
 
-/* Wakeup sndbuf consumers from process context
- * since there is more data to transmit
- */
-void smc_tx_work(struct work_struct *work)
+void smc_tx_pending(struct smc_connection *conn)
 {
-	struct smc_connection *conn = container_of(to_delayed_work(work),
-						   struct smc_connection,
-						   tx_work);
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 	int rc;
 
-	lock_sock(&smc->sk);
 	if (smc->sk.sk_err)
-		goto out;
+		return;
 
 	rc = smc_tx_sndbuf_nonempty(conn);
 	if (!rc && conn->local_rx_ctrl.prod_flags.write_blocked &&
 	    !atomic_read(&conn->bytes_to_rcv))
 		conn->local_rx_ctrl.prod_flags.write_blocked = 0;
+}
+
+/* Wakeup sndbuf consumers from process context
+ * since there is more data to transmit
+ */
+void smc_tx_work(struct work_struct *work)
+{
+	struct smc_connection *conn = container_of(to_delayed_work(work),
+						   struct smc_connection,
+						   tx_work);
+	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 
-out:
+	lock_sock(&smc->sk);
+	smc_tx_pending(conn);
 	release_sock(&smc->sk);
 }
 
diff --git a/net/smc/smc_tx.h b/net/smc/smc_tx.h
index 07e6ad76224a..a59f370b8b43 100644
--- a/net/smc/smc_tx.h
+++ b/net/smc/smc_tx.h
@@ -27,6 +27,7 @@ static inline int smc_tx_prepared_sends(struct smc_connection *conn)
 	return smc_curs_diff(conn->sndbuf_desc->len, &sent, &prep);
 }
 
+void smc_tx_pending(struct smc_connection *conn);
 void smc_tx_work(struct work_struct *work);
 void smc_tx_init(struct smc_sock *smc);
 int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len);
-- 
2.34.1

