Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8572F24ED
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405371AbhALAZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:27 -0500
Received: from www62.your-server.de ([213.133.104.62]:41986 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403812AbhAKXK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:10:26 -0500
Received: from 30.101.7.85.dynamic.wline.res.cust.swisscom.ch ([85.7.101.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kz6Jk-000Dkf-Sm; Tue, 12 Jan 2021 00:09:44 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     yhs@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next v2 1/2] bpf: allow to retrieve sol_socket opts from sock_addr progs
Date:   Tue, 12 Jan 2021 00:09:39 +0100
Message-Id: <cba44439b801e5ddc1170e5be787f4dc93a2d7f9.1610406333.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26046/Mon Jan 11 13:34:14 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The _bpf_setsockopt() is able to set some of the SOL_SOCKET level options,
however, _bpf_getsockopt() has little support to actually retrieve them.
This small patch adds few misc options such as SO_MARK, SO_PRIORITY and
SO_BINDTOIFINDEX. For the latter getter and setter are added. The mark and
priority in particular allow to retrieve the options from BPF cgroup hooks
to then implement custom behavior / settings on the syscall hooks compared
to other sockets that stick to the defaults, for example.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
---
 net/core/filter.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 255aeee72402..9ab94e90d660 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4770,6 +4770,10 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 				ifindex = dev->ifindex;
 				dev_put(dev);
 			}
+			fallthrough;
+		case SO_BINDTOIFINDEX:
+			if (optname == SO_BINDTOIFINDEX)
+				ifindex = val;
 			ret = sock_bindtoindex(sk, ifindex, false);
 			break;
 		case SO_KEEPALIVE:
@@ -4932,8 +4936,25 @@ static int _bpf_getsockopt(struct sock *sk, int level, int optname,
 
 	sock_owned_by_me(sk);
 
+	if (level == SOL_SOCKET) {
+		if (optlen != sizeof(int))
+			goto err_clear;
+
+		switch (optname) {
+		case SO_MARK:
+			*((int *)optval) = sk->sk_mark;
+			break;
+		case SO_PRIORITY:
+			*((int *)optval) = sk->sk_priority;
+			break;
+		case SO_BINDTOIFINDEX:
+			*((int *)optval) = sk->sk_bound_dev_if;
+			break;
+		default:
+			goto err_clear;
+		}
 #ifdef CONFIG_INET
-	if (level == SOL_TCP && sk->sk_prot->getsockopt == tcp_getsockopt) {
+	} else if (level == SOL_TCP && sk->sk_prot->getsockopt == tcp_getsockopt) {
 		struct inet_connection_sock *icsk;
 		struct tcp_sock *tp;
 
@@ -4986,12 +5007,12 @@ static int _bpf_getsockopt(struct sock *sk, int level, int optname,
 		default:
 			goto err_clear;
 		}
+#endif
 #endif
 	} else {
 		goto err_clear;
 	}
 	return 0;
-#endif
 err_clear:
 	memset(optval, 0, optlen);
 	return -EINVAL;
-- 
2.21.0

