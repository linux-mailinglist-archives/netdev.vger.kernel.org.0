Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD791064F4
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbfKVGUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:20:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:58584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728657AbfKVFwo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8585F2071B;
        Fri, 22 Nov 2019 05:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401963;
        bh=/Y/AFb/HLWd/GJdXfqnLvWAYyyhntv+qURI/r1g4Xjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2deNZ4kwEiudlMFzQCnbPF9dYNvCM+j1uE9rQu5UrlugIE2w07IkwXJ25ZV16pGNX
         LRCOBsJZoAMXmnMm/l3/iyyYJ3B2eeVfALO9uppsdUyavH1N8nsu6w7B/be5gzDIKs
         Odpcc4yxKlXvNQvgVxahmRAYXbKdJG3fglzxc+e8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ursula Braun <ubraun@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 184/219] net/smc: fix sender_free computation
Date:   Fri, 22 Nov 2019 00:48:36 -0500
Message-Id: <20191122054911.1750-177-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

[ Upstream commit b8649efad879c69c7ab1f19ce8814fcabef1f72b ]

In some scenarios a separate consumer cursor update is necessary.
The decision is made in smc_tx_consumer_cursor_update(). The
sender_free computation could be wrong:

The rx confirmed cursor is always smaller than or equal to the
rx producer cursor. The parameters in the smc_curs_diff() call
have to be exchanged, otherwise sender_free might even be negative.

And if more data arrives local_rx_ctrl.prod might be updated, enabling
a cursor difference between local_rx_ctrl.prod and rx confirmed cursor
larger than the RMB size. This case is not covered by smc_curs_diff().
Thus function smc_curs_diff_large() is introduced here.

If a recvmsg() is processed in parallel, local_tx_ctrl.cons might
change during smc_cdc_msg_send. Make sure rx_curs_confirmed is updated
with the actually sent local_tx_ctrl.cons value.

Fixes: e82f2e31f559 ("net/smc: optimize consumer cursor updates")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_cdc.c |  5 +++--
 net/smc/smc_cdc.h | 26 +++++++++++++++++++++++++-
 net/smc/smc_tx.c  |  3 ++-
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index ed5dcf03fe0b6..8f691b5a44ddf 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -96,6 +96,7 @@ int smc_cdc_msg_send(struct smc_connection *conn,
 		     struct smc_wr_buf *wr_buf,
 		     struct smc_cdc_tx_pend *pend)
 {
+	union smc_host_cursor cfed;
 	struct smc_link *link;
 	int rc;
 
@@ -107,10 +108,10 @@ int smc_cdc_msg_send(struct smc_connection *conn,
 	conn->local_tx_ctrl.seqno = conn->tx_cdc_seq;
 	smc_host_msg_to_cdc((struct smc_cdc_msg *)wr_buf,
 			    &conn->local_tx_ctrl, conn);
+	smc_curs_copy(&cfed, &((struct smc_host_cdc_msg *)wr_buf)->cons, conn);
 	rc = smc_wr_tx_send(link, (struct smc_wr_tx_pend_priv *)pend);
 	if (!rc)
-		smc_curs_copy(&conn->rx_curs_confirmed,
-			      &conn->local_tx_ctrl.cons, conn);
+		smc_curs_copy(&conn->rx_curs_confirmed, &cfed, conn);
 
 	return rc;
 }
diff --git a/net/smc/smc_cdc.h b/net/smc/smc_cdc.h
index 934df4473a7ce..2377a51772d51 100644
--- a/net/smc/smc_cdc.h
+++ b/net/smc/smc_cdc.h
@@ -135,7 +135,9 @@ static inline void smc_curs_copy_net(union smc_cdc_cursor *tgt,
 #endif
 }
 
-/* calculate cursor difference between old and new, where old <= new */
+/* calculate cursor difference between old and new, where old <= new and
+ * difference cannot exceed size
+ */
 static inline int smc_curs_diff(unsigned int size,
 				union smc_host_cursor *old,
 				union smc_host_cursor *new)
@@ -160,6 +162,28 @@ static inline int smc_curs_comp(unsigned int size,
 	return smc_curs_diff(size, old, new);
 }
 
+/* calculate cursor difference between old and new, where old <= new and
+ * difference may exceed size
+ */
+static inline int smc_curs_diff_large(unsigned int size,
+				      union smc_host_cursor *old,
+				      union smc_host_cursor *new)
+{
+	if (old->wrap < new->wrap)
+		return min_t(int,
+			     (size - old->count) + new->count +
+			     (new->wrap - old->wrap - 1) * size,
+			     size);
+
+	if (old->wrap > new->wrap) /* wrap has switched from 0xffff to 0x0000 */
+		return min_t(int,
+			     (size - old->count) + new->count +
+			     (new->wrap + 0xffff - old->wrap) * size,
+			     size);
+
+	return max_t(int, 0, (new->count - old->count));
+}
+
 static inline void smc_host_cursor_to_cdc(union smc_cdc_cursor *peer,
 					  union smc_host_cursor *local,
 					  struct smc_connection *conn)
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index f1f621675db01..0ecbbdc337b82 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -595,7 +595,8 @@ void smc_tx_consumer_update(struct smc_connection *conn, bool force)
 	if (to_confirm > conn->rmbe_update_limit) {
 		smc_curs_copy(&prod, &conn->local_rx_ctrl.prod, conn);
 		sender_free = conn->rmb_desc->len -
-			      smc_curs_diff(conn->rmb_desc->len, &prod, &cfed);
+			      smc_curs_diff_large(conn->rmb_desc->len,
+						  &cfed, &prod);
 	}
 
 	if (conn->local_rx_ctrl.prod_flags.cons_curs_upd_req ||
-- 
2.20.1

