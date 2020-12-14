Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0F92D945A
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 09:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407285AbgLNIwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 03:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407277AbgLNIwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 03:52:23 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F581C0613D3;
        Mon, 14 Dec 2020 00:51:43 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id f17so12021279pge.6;
        Mon, 14 Dec 2020 00:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=coxpgFuIFoxnBuCGxXF5CM5p8NoKWp1Vl8M+nx+DzgE=;
        b=PvPRuFGXJEAyivYwHyvwzp/IvfmrOLfw0HnqZdC1XTAFDKg4nCaPO5jr+d+tCJhYyt
         +TtzBUdFnIKUA48oooDBf2vQh2rb1FouNzSJtygni1mjgkaAOhSdKCFcBB+PEx4HAAuW
         mAvUMSdDGICMfYlfU/nTAX7WPHox3vXQP0/WuXDxf1QncOcJzYDyIAwYR7ZXiM5IviwE
         AlaA2T6/drUhUVoZMeNjlqzGAWDp47TGxDmGasUrhtYYp2wOrzxXoEtYgbupN/XZP72S
         JdvNgc1Q/jRd3zdjt2p09o1XQ4TJoFrcfpC61NR6RDnprfm3PEWRWaH7eb/oOfHnAvJN
         3ulQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=coxpgFuIFoxnBuCGxXF5CM5p8NoKWp1Vl8M+nx+DzgE=;
        b=YnUjCZzu3MZjtKM+B7NF4cqiu2feruikG+vYmkGHGUO2rL7BMgMmbe5iy8hbGNZnSV
         +KrzfxXj13ERr9l+198fIv7w2V+sNRWH39/DMvzV05JcM2ICyaurm+JsvvKpAQnkE/G2
         7VbuJGXYq30brKjHAnAmfgUo8bxy8RVvc9diKCkQ7qPTaRBKL7f2dUDVggUh2BYUAipN
         RmnDQO8SyJDMYObV7HKBY46xqewSUaiA0aGI1tsYw4cM2YUGRi12Jt/eiA4wRhjF5Kgs
         HK80M/+jJLw6tTyzrWkDnk3ngr7v1pu0OfmMCU9xttDacVS63O9jK5idNkmD6f6chdIU
         sC+A==
X-Gm-Message-State: AOAM532H8PAExP1RHEmUubfxpxiozcVv1sF0hQM8USDzDzBROphodJ1g
        do3A5k4WxDaUnhSzZVhiXCagnYhhq4F0mAaI
X-Google-Smtp-Source: ABdhPJym1906IeDJ5IxUsVd+Rp1BkGsFUTcztHen3EbKiBlm5UEHC6saKPJA2qaIi973Zw2/uta/LA==
X-Received: by 2002:a62:1a47:0:b029:19b:c093:2766 with SMTP id a68-20020a621a470000b029019bc0932766mr23196683pfa.10.1607935903230;
        Mon, 14 Dec 2020 00:51:43 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id e65sm18917090pfh.175.2020.12.14.00.51.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Dec 2020 00:51:42 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org,
        syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com
Subject: [PATCH bpf] xsk: fix memory leak for failed bind
Date:   Mon, 14 Dec 2020 09:51:27 +0100
Message-Id: <20201214085127.3960-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a possible memory leak when a bind of an AF_XDP socket fails. When
the fill and completion rings are created, they are tied to the
socket. But when the buffer pool is later created at bind time, the
ownership of these two rings are transferred to the buffer pool as
they might be shared between sockets (and the buffer pool cannot be
created until we know what we are binding to). So, before the buffer
pool is created, these two rings are cleaned up with the socket, and
after they have been transferred they are cleaned up together with
the buffer pool.

The problem is that ownership was transferred before it was absolutely
certain that the buffer pool could be created and initialized
correctly and when one of these errors occurred, the fill and
completion rings did neither belong to the socket nor the pool and
where therefore leaked. Solve this by moving the ownership transfer
to the point where the buffer pool has been completely set up and
there is no way it can fail.

Fixes: 7361f9c3d719 ("xsk: Move fill and completion rings to buffer pool")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Reported-by: syzbot+cfa88ddd0655afa88763@syzkaller.appspotmail.com
---
 net/xdp/xsk.c           | 4 ++++
 net/xdp/xsk_buff_pool.c | 2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 62504471fd20..189cfbbcccc0 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -772,6 +772,10 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		}
 	}
 
+	/* FQ and CQ are now owned by the buffer pool and cleaned up with it. */
+	xs->fq_tmp = NULL;
+	xs->cq_tmp = NULL;
+
 	xs->dev = dev;
 	xs->zc = xs->umem->zc;
 	xs->queue_id = qid;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index d5adeee9d5d9..46c2ae7d91d1 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -75,8 +75,6 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 
 	pool->fq = xs->fq_tmp;
 	pool->cq = xs->cq_tmp;
-	xs->fq_tmp = NULL;
-	xs->cq_tmp = NULL;
 
 	for (i = 0; i < pool->free_heads_cnt; i++) {
 		xskb = &pool->heads[i];

base-commit: d9838b1d39283c1200c13f9076474c7624b8ec34
-- 
2.29.0

