Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0EE338118
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 00:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhCKXKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 18:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhCKXKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 18:10:04 -0500
X-Greylist: delayed 82 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 11 Mar 2021 15:10:03 PST
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98CD1C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 15:10:03 -0800 (PST)
Received: from vla1-fdfb804fb3f3.qloud-c.yandex.net (vla1-fdfb804fb3f3.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3199:0:640:fdfb:804f])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 7AB612E1489
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 02:08:33 +0300 (MSK)
Received: from vla5-d6d5ce7a4718.qloud-c.yandex.net (vla5-d6d5ce7a4718.qloud-c.yandex.net [2a02:6b8:c18:341e:0:640:d6d5:ce7a])
        by vla1-fdfb804fb3f3.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 1Nr09IQosQ-8X0WwbMu;
        Fri, 12 Mar 2021 02:08:33 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1615504113; bh=JLnczieDRCuCvmXTPiehoIy1m8/CU6yiJur5g4LOsgs=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=gSSs2DaVILb5+R7/V4coKXBHhu9FTj1bWxWYAkOt+wxkJgvrBQ1bWDShrp/CGGgje
         uFVLKZlLFuefISZp/PhJtZsBYCzfz7nwSs27Kc0ZMw/nZ+Ei6yZ7gVYlBi9QpkqArs
         oh5D7GLrzc95NFa2YHgu6x8Jds8A+HtOqUo85tBA=
Authentication-Results: vla1-fdfb804fb3f3.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from ov.vla.yp-c.yandex.net (ov.vla.yp-c.yandex.net [2a02:6b8:c0f:1a86:0:696:9377:0])
        by vla5-d6d5ce7a4718.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id FUQgboVWS6-8Wne6uqv;
        Fri, 12 Mar 2021 02:08:32 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Alexander Ovechkin <ovov@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     zeil@yandex-team.ru, dmtrmonakhov@yandex-team.ru
Subject: [PATCH] tcp: relookup sock for RST+ACK packets handled by obsolete req sock
Date:   Fri, 12 Mar 2021 02:07:56 +0300
Message-Id: <20210311230756.971993-1-ovov@yandex-team.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tcp_check_req can be called with obsolete req socket for which big
socket have been already created (because of CPU race or early demux
assigning req socket to multiple packets in gro batch).

Commit e0f9759f530bf789e984 (\"tcp: try to keep packet if SYN_RCV race
is lost\") added retry in case when tcp_check_req is called for PSH|ACK packet.
But if client sends RST+ACK immediatly after connection being
established (it is performing healthcheck, for example) retry does not
occur. In that case tcp_check_req tries to close req socket,
leaving big socket active.

Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
Reported-by: Oleg Senin <olegsenin@yandex-team.ru>
---
 include/net/inet_connection_sock.h | 2 +-
 net/ipv4/inet_connection_sock.c    | 6 ++++--
 net/ipv4/tcp_minisocks.c           | 6 ++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

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
index 6bd7ca09af03..08ca9de2a708 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -705,12 +705,14 @@ static bool reqsk_queue_unlink(struct request_sock *req)
 	return found;
 }
 
-void inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req)
+bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req)
 {
-	if (reqsk_queue_unlink(req)) {
+	bool unlinked = reqsk_queue_unlink(req);
+	if (unlinked) {
 		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
 		reqsk_put(req);
 	}
+	return unlinked;
 }
 EXPORT_SYMBOL(inet_csk_reqsk_queue_drop);
 
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 0055ae0a3bf8..31ed3423503d 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -804,8 +804,10 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		tcp_reset(sk, skb);
 	}
 	if (!fastopen) {
-		inet_csk_reqsk_queue_drop(sk, req);
-		__NET_INC_STATS(sock_net(sk), LINUX_MIB_EMBRYONICRSTS);
+		bool unlinked = inet_csk_reqsk_queue_drop(sk, req);
+		if (unlinked)
+			__NET_INC_STATS(sock_net(sk), LINUX_MIB_EMBRYONICRSTS);
+		*req_stolen = !unlinked;
 	}
 	return NULL;
 }
-- 
2.17.1

