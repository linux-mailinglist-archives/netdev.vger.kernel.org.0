Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB3A382059
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 20:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhEPSaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 14:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhEPSaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 14:30:23 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B33C061573
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 11:29:08 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 22so3084385pfv.11
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 11:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=th+JQDDOusQXsKw3hnWKrNIHdArIdeb6yYB/CrRj8QE=;
        b=h9C91KXaj/tVj78/tcKfGXrwimTUxqSyIKZPnlpn6UbAOVHKCc0zTLP9Xg/wg2uObA
         u1nHR3qo8LjeyvHvInI3W535E+9nTeO0TTSmeoIHZdbtv85yynRUUDhxlkXXZR7g4scL
         PSjEw8MXCK5bbMkWbhlV3CEyJkhawgFxLcZhTOKDbLbdDn4aBjA+bWBwpmnccIkOHqbc
         PeQXtdxbUO+r3Sxekxr4MOsImNCvKqvKF594dTv4FMNDFY5mue7aNMx1yONxg+HaDu+v
         vW6fQOGG7O9RBArJaubXvKhhYDtOpTuOLiwUiOhY990E3EZ2Bni4kCPTuz1PJgfV0nD1
         NRcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=th+JQDDOusQXsKw3hnWKrNIHdArIdeb6yYB/CrRj8QE=;
        b=F0FuIzSi/AF9L6k2KoxiR3+4V1/5MbkaTAyO9gWLypw1wovRVDoFLcmyCoxy7RMz/l
         vyKS4659um77yyktGFp/uWGIz9emgkMNLpRHkYij48FLRbR8k+ui8sb8kWuKi+eZ5yDl
         XRzz/Lp/3fkDwqDexIAT9I2MgEUfwBEq+EIlP1YUhYaHZUPf5tSnD9vo628MHpyyNg9S
         Jp7eaOsCvDns/WrfDvE2qlWYSa5F1+YFKyYhwlXaIKTVuI1QLz8jiogyKmWSp1Ajnapf
         cIHIZ1LxZv+O15fp+QkAnf5XxUveQAUqSePuvQB/MCJ9JfZz03aeX6WJJoFwh2GKZZZ8
         RUww==
X-Gm-Message-State: AOAM533JgL68odeZrW3Mdal9PduJrGVAf8H+qaToz2assyTbuiz9TqbN
        sN+c+xOk5pFqae4FtNy4MG/H26xJ9X5sTA==
X-Google-Smtp-Source: ABdhPJxOtLTqD2mtDfhvmpPpt5vUZoGb+ju4pnA/SBEGCT27v3tJ6fS3F8fSkuTpBq3FsMQjat73LA==
X-Received: by 2002:a63:af57:: with SMTP id s23mr5671726pgo.393.1621189747459;
        Sun, 16 May 2021 11:29:07 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id s12sm13382083pji.5.2021.05.16.11.29.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 May 2021 11:29:07 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, tipc-discussion@lists.sourceforge.net
Cc:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>
Subject: [PATCH net] tipc: wait and exit until all work queues are done
Date:   Mon, 17 May 2021 02:28:58 +0800
Message-Id: <5db04a37335895e04e98bdf53aff3c8ecb6774db.1621189738.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some host, a crash could be triggered simply by repeating these
commands several times:

  # modprobe tipc
  # tipc bearer enable media udp name UDP1 localip 127.0.0.1
  # rmmod tipc

  [] BUG: unable to handle kernel paging request at ffffffffc096bb00
  [] Workqueue: events 0xffffffffc096bb00
  [] Call Trace:
  []  ? process_one_work+0x1a7/0x360
  []  ? worker_thread+0x30/0x390
  []  ? create_worker+0x1a0/0x1a0
  []  ? kthread+0x116/0x130
  []  ? kthread_flush_work_fn+0x10/0x10
  []  ? ret_from_fork+0x35/0x40

When removing the TIPC module, the UDP tunnel sock will be delayed to
release in a work queue as sock_release() can't be done in rtnl_lock().
If the work queue is schedule to run after the TIPC module is removed,
kernel will crash as the work queue function cleanup_beareri() code no
longer exists when trying to invoke it.

To fix it, this patch introduce a member wq_count in tipc_net to track
the numbers of work queues in schedule, and  wait and exit until all
work queues are done in tipc_exit_net().

Fixes: d0f91938bede ("tipc: add ip/udp media type")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/core.c      | 2 ++
 net/tipc/core.h      | 2 ++
 net/tipc/udp_media.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index 5cc1f03..72f3ac7 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -119,6 +119,8 @@ static void __net_exit tipc_exit_net(struct net *net)
 #ifdef CONFIG_TIPC_CRYPTO
 	tipc_crypto_stop(&tipc_net(net)->crypto_tx);
 #endif
+	while (atomic_read(&tn->wq_count))
+		cond_resched();
 }
 
 static void __net_exit tipc_pernet_pre_exit(struct net *net)
diff --git a/net/tipc/core.h b/net/tipc/core.h
index 03de7b2..5741ae4 100644
--- a/net/tipc/core.h
+++ b/net/tipc/core.h
@@ -149,6 +149,8 @@ struct tipc_net {
 #endif
 	/* Work item for net finalize */
 	struct tipc_net_work final_work;
+	/* The numbers of work queues in schedule */
+	atomic_t wq_count;
 };
 
 static inline struct tipc_net *tipc_net(struct net *net)
diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index e556d2c..c2bb818 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -814,6 +814,7 @@ static void cleanup_bearer(struct work_struct *work)
 		kfree_rcu(rcast, rcu);
 	}
 
+	atomic_dec(&tipc_net(sock_net(ub->ubsock->sk))->wq_count);
 	dst_cache_destroy(&ub->rcast.dst_cache);
 	udp_tunnel_sock_release(ub->ubsock);
 	synchronize_net();
@@ -834,6 +835,7 @@ static void tipc_udp_disable(struct tipc_bearer *b)
 	RCU_INIT_POINTER(ub->bearer, NULL);
 
 	/* sock_release need to be done outside of rtnl lock */
+	atomic_inc(&tipc_net(sock_net(ub->ubsock->sk))->wq_count);
 	INIT_WORK(&ub->work, cleanup_bearer);
 	schedule_work(&ub->work);
 }
-- 
2.1.0

