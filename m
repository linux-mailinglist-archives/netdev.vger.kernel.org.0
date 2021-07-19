Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164633CD039
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhGSIbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234808AbhGSIbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:31:43 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDFBC061574
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 01:13:26 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d12so15919997pfj.2
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 02:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kiYKsZ8R5WTDRPL6u2eNvTsV/BFSE4zePxbNkAdOUh8=;
        b=k3dbhXNW03C0WysWhHYBIUbr/YNzyTe4oUbg3oXw67hS1GGK56IUXsq7kXHf/dGZnG
         XBVJRCWmQvfDworwKgh989PKcv/DlqxV/nczKDM3O6u/atxJVefd375giBWXdyZLD8zp
         wouGeZuhysGq1sxaNRstqUYgEPSRg0jtpSqL117ywbRa7NcFI838+nTUq4X+V0me1cTd
         OeSs3SZZWk8QBi/CWTli3fo9lN1djg01KtEsIg9WId0DJeiEEbriytUzUdJLe3wDtel7
         JTuHi3phtkSUtqjZJPbV6kJbBXcF6xCWDpqpww2AnmYilCujZy+zK8VovCQDZnMypBJW
         NLZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kiYKsZ8R5WTDRPL6u2eNvTsV/BFSE4zePxbNkAdOUh8=;
        b=czinJGX8thMF0jF9EG05/QzYSutKpTP5rgYt2nfBo59LXl5RMVvs3DM+lkj0izVcvh
         ZcIVmw8QhRKvDax6iyWPe8IALJNHz6BNZm9VYElwmj4V7KtplL4C1JMS0xVtFKuGPmMl
         1ME2ky6vVZ3NRVYKdkh+X4BSpqp7I8iMRIGd6bowgt8b+zlDsQpKenf/vrgBokvepFkH
         VQWrg6JyScEtMRM03iPlXFmb20LvkPu2nylBLl48rgwYpXoJxfzafrDsC5pcx8b0//6G
         riUAClO4/8SKtKDVrAYQmH8sMgA2tONcjR3U1lkteQYAEizok3MPR5c5ZWY6Hl0csSHp
         /AIA==
X-Gm-Message-State: AOAM5326WDQ/wqUQEyZgFKykZaC0EX/Qj+C2qN249x40u4kKJV5W0LmU
        cFT7JDX6p+/AaES8U+vGPqYCtgWhF+Y=
X-Google-Smtp-Source: ABdhPJzFhpqGzCdv7/4NFfPlbCjedggvY8t0h3+Kjpa9SyUvdh1hGEYbQi+TyTF+MUh9STJ1c+29uA==
X-Received: by 2002:a65:5542:: with SMTP id t2mr24265559pgr.358.1626685942317;
        Mon, 19 Jul 2021 02:12:22 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d265:ee2c:6429:76fd])
        by smtp.gmail.com with ESMTPSA id q12sm19053754pfj.220.2021.07.19.02.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 02:12:21 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Wei Wang <weiwan@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH net] net/tcp_fastopen: fix data races around tfo_active_disable_stamp
Date:   Mon, 19 Jul 2021 02:12:18 -0700
Message-Id: <20210719091218.2969611-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tfo_active_disable_stamp is read and written locklessly.
We need to annotate these accesses appropriately.

Then, we need to perform the atomic_inc(tfo_active_disable_times)
after the timestamp has been updated, and thus add barriers
to make sure tcp_fastopen_active_should_disable() wont read
a stale timestamp.

Fixes: cf1ef3f0719b ("net/tcp_fastopen: Disable active side TFO in certain scenarios")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Wei Wang <weiwan@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
---
 net/ipv4/tcp_fastopen.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 47c32604d38fca960d2cd56f3588bfd2e390b789..b32af76e21325373126b51423496e3b8d47d97ff 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -507,8 +507,15 @@ void tcp_fastopen_active_disable(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 
+	/* Paired with READ_ONCE() in tcp_fastopen_active_should_disable() */
+	WRITE_ONCE(net->ipv4.tfo_active_disable_stamp, jiffies);
+
+	/* Paired with smp_rmb() in tcp_fastopen_active_should_disable().
+	 * We want net->ipv4.tfo_active_disable_stamp to be updated first.
+	 */
+	smp_mb__before_atomic();
 	atomic_inc(&net->ipv4.tfo_active_disable_times);
-	net->ipv4.tfo_active_disable_stamp = jiffies;
+
 	NET_INC_STATS(net, LINUX_MIB_TCPFASTOPENBLACKHOLE);
 }
 
@@ -526,10 +533,16 @@ bool tcp_fastopen_active_should_disable(struct sock *sk)
 	if (!tfo_da_times)
 		return false;
 
+	/* Paired with smp_mb__before_atomic() in tcp_fastopen_active_disable() */
+	smp_rmb();
+
 	/* Limit timeout to max: 2^6 * initial timeout */
 	multiplier = 1 << min(tfo_da_times - 1, 6);
-	timeout = multiplier * tfo_bh_timeout * HZ;
-	if (time_before(jiffies, sock_net(sk)->ipv4.tfo_active_disable_stamp + timeout))
+
+	/* Paired with the WRITE_ONCE() in tcp_fastopen_active_disable(). */
+	timeout = READ_ONCE(sock_net(sk)->ipv4.tfo_active_disable_stamp) +
+		  multiplier * tfo_bh_timeout * HZ;
+	if (time_before(jiffies, timeout))
 		return true;
 
 	/* Mark check bit so we can check for successful active TFO
-- 
2.32.0.402.g57bb445576-goog

