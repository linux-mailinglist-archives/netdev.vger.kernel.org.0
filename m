Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF7FA13E523
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390603AbgAPRMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:56466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390586AbgAPRMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D630924696;
        Thu, 16 Jan 2020 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194771;
        bh=1fFE5iS0h/osjV3rPKtgPo6w7c/71rYCJlFdfhgNAiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VkGyH10iHJloPIXZkpdzQK2vZtP+Vi3B3kAilrdsy1lliUM4bFNRvtgq9ltXf5q9Q
         GawzRQfygTo6DHCDbM/JExP4OuXaQC2VMWwVRfov70E5veUSVddTpLlvwWRzbfIWd9
         f7sU2yCsHWDTVikMFb/b3qDHIlvPDozoGY6sHN74=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 590/671] net: add {READ|WRITE}_ONCE() annotations on ->rskq_accept_head
Date:   Thu, 16 Jan 2020 12:03:48 -0500
Message-Id: <20200116170509.12787-327-sashal@kernel.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 60b173ca3d1cd1782bd0096dc17298ec242f6fb1 ]

reqsk_queue_empty() is called from inet_csk_listen_poll() while
other cpus might write ->rskq_accept_head value.

Use {READ|WRITE}_ONCE() to avoid compiler tricks
and potential KCSAN splats.

Fixes: fff1f3001cc5 ("tcp: add a spinlock to protect struct request_sock_queue")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/pvcalls-back.c      | 2 +-
 include/net/request_sock.h      | 4 ++--
 net/ipv4/inet_connection_sock.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/pvcalls-back.c b/drivers/xen/pvcalls-back.c
index d4ea33581ac2..b3fbfed28682 100644
--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -784,7 +784,7 @@ static int pvcalls_back_poll(struct xenbus_device *dev,
 	mappass->reqcopy = *req;
 	icsk = inet_csk(mappass->sock->sk);
 	queue = &icsk->icsk_accept_queue;
-	data = queue->rskq_accept_head != NULL;
+	data = READ_ONCE(queue->rskq_accept_head) != NULL;
 	if (data) {
 		mappass->reqcopy.cmd = 0;
 		ret = 0;
diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index 347015515a7d..1653435f18f5 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -183,7 +183,7 @@ void reqsk_fastopen_remove(struct sock *sk, struct request_sock *req,
 
 static inline bool reqsk_queue_empty(const struct request_sock_queue *queue)
 {
-	return queue->rskq_accept_head == NULL;
+	return READ_ONCE(queue->rskq_accept_head) == NULL;
 }
 
 static inline struct request_sock *reqsk_queue_remove(struct request_sock_queue *queue,
@@ -195,7 +195,7 @@ static inline struct request_sock *reqsk_queue_remove(struct request_sock_queue
 	req = queue->rskq_accept_head;
 	if (req) {
 		sk_acceptq_removed(parent);
-		queue->rskq_accept_head = req->dl_next;
+		WRITE_ONCE(queue->rskq_accept_head, req->dl_next);
 		if (queue->rskq_accept_head == NULL)
 			queue->rskq_accept_tail = NULL;
 	}
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 636a11c56cf5..79320858e719 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -937,7 +937,7 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
 		req->sk = child;
 		req->dl_next = NULL;
 		if (queue->rskq_accept_head == NULL)
-			queue->rskq_accept_head = req;
+			WRITE_ONCE(queue->rskq_accept_head, req);
 		else
 			queue->rskq_accept_tail->dl_next = req;
 		queue->rskq_accept_tail = req;
-- 
2.20.1

