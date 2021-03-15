Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18F633B09E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 12:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCOLGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 07:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhCOLGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 07:06:21 -0400
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C69FC061574
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 04:06:21 -0700 (PDT)
Received: from vla1-fdfb804fb3f3.qloud-c.yandex.net (vla1-fdfb804fb3f3.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3199:0:640:fdfb:804f])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 165112E1606;
        Mon, 15 Mar 2021 14:06:16 +0300 (MSK)
Received: from vla5-d6d5ce7a4718.qloud-c.yandex.net (vla5-d6d5ce7a4718.qloud-c.yandex.net [2a02:6b8:c18:341e:0:640:d6d5:ce7a])
        by vla1-fdfb804fb3f3.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 760x53L6g2-6FoKXLVZ;
        Mon, 15 Mar 2021 14:06:15 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1615806375; bh=NfeT6wxslNJNzf5wf3FD0ZmRDdoGGzzdmQ00r24pK44=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=bA/gYivCtYgeiemX59FLrAiBATL0NjPALuI7+FCEKgXoIOMIXDgPW+kBbv2bi5vGg
         9G6GB460qVPf6DgmzIeUiUJRh1wwmEuLCoW0YuEIcCvGqrcxuBLm6A0JmlhAkvhGYQ
         ztISNCIESbAmcfeOMnpX1Hd1PlFlCljwbomPVUYY=
Authentication-Results: vla1-fdfb804fb3f3.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from ov.vla.yp-c.yandex.net (ov.vla.yp-c.yandex.net [2a02:6b8:c0f:1a86:0:696:9377:0])
        by vla5-d6d5ce7a4718.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id eHBazmBFFL-6Fne1Uck;
        Mon, 15 Mar 2021 14:06:15 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Alexander Ovechkin <ovov@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, zeil@yandex-team.ru,
        dmtrmonakhov@yandex-team.ru, olegsenin@yandex-team.ru
Subject: [PATCH v2] tcp: relookup sock for RST+ACK packets handled by obsolete req sock
Date:   Mon, 15 Mar 2021 14:05:45 +0300
Message-Id: <20210315110545.111555-1-ovov@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tcp_check_req can be called with obsolete req socket for which big
socket have been already created (because of CPU race or early demux
assigning req socket to multiple packets in gro batch).

Commit e0f9759f530bf789e984 ("tcp: try to keep packet if SYN_RCV race
is lost") added retry in case when tcp_check_req is called for PSH|ACK packet.
But if client sends RST+ACK immediatly after connection being
established (it is performing healthcheck, for example) retry does not
occur. In that case tcp_check_req tries to close req socket,
leaving big socket active.

Fixes: e0f9759f530 ("tcp: try to keep packet if SYN_RCV race is lost")
Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
Reported-by: Oleg Senin <olegsenin@yandex-team.ru>
---
 include/net/inet_connection_sock.h | 2 +-
 net/ipv4/inet_connection_sock.c    | 7 +++++--
 net/ipv4/tcp_minisocks.c           | 7 +++++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 10a625760de9..3c8c59471bc1 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -282,7 +282,7 @@ static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 	return inet_csk_reqsk_queue_len(sk) >= sk->sk_max_ack_backlog;
 }
 
-void inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
+bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
 void inet_csk_reqsk_queue_drop_and_put(struct sock *sk, struct request_sock *req);
 
 static inline void inet_csk_prepare_for_destroy_sock(struct sock *sk)
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 6bd7ca09af03..fd472eae4f5c 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -705,12 +705,15 @@ static bool reqsk_queue_unlink(struct request_sock *req)
 	return found;
 }
 
-void inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req)
+bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req)
 {
-	if (reqsk_queue_unlink(req)) {
+	bool unlinked = reqsk_queue_unlink(req);
+
+	if (unlinked) {
 		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
 		reqsk_put(req);
 	}
+	return unlinked;
 }
 EXPORT_SYMBOL(inet_csk_reqsk_queue_drop);
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0055ae0a3bf8..7513ba45553d 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -804,8 +804,11 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		tcp_reset(sk, skb);
 	}
 	if (!fastopen) {
-		inet_csk_reqsk_queue_drop(sk, req);
-		__NET_INC_STATS(sock_net(sk), LINUX_MIB_EMBRYONICRSTS);
+		bool unlinked = inet_csk_reqsk_queue_drop(sk, req);
+
+		if (unlinked)
+			__NET_INC_STATS(sock_net(sk), LINUX_MIB_EMBRYONICRSTS);
+		*req_stolen = !unlinked;
 	}
 	return NULL;
 }
-- 
2.17.1

