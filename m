Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A62E9138499
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 03:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732017AbgALCh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 21:37:58 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:36646 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731985AbgALCh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 21:37:58 -0500
Received: by mail-io1-f67.google.com with SMTP id d15so6115174iog.3;
        Sat, 11 Jan 2020 18:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=tMBuKvBK8Si7i2xUAU0++949aUuYSuAcPP+8ON5MMKI=;
        b=Q1wk3Bar+nVU/mEEC2dawCa8jrTCS63p6rXbCivzlDINWjFCkz1C4I7jEkXd15w3bO
         KdKSXC/p2c70BW6SGAPwklUMeNVFiJMlWTUmiy5Cp3Ux3csc0mBh4RoTiOI92PL+Ew2p
         8MWYw8Gp6UN2s6MQVIZQKz8zLjbVyhiq/DQ6au+KsJCApfc2qd5DJ5Wi/zez4tm++QEI
         +bKM2/aQ52fyRKWqDV3QgP9RyB4PCbniwor86t2sUU0PJq1Y345k5ynHjqh8PnVo++Ik
         AVZjOlU3jPv8ZIKjrSseul7WVBfhCnBm4paZ4Ot31Pzkb4e4RtXX2FDbnxMgA2QrD+Tt
         nR0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tMBuKvBK8Si7i2xUAU0++949aUuYSuAcPP+8ON5MMKI=;
        b=KUtGfjVDF8GvDdSQgsUymG8ninjJ4f8qx4fZIWLD1TgTbwsr1m9Qn3gHm2NzWAeq5p
         j08cc/UxPNqC42c3AOFJyzlIk1bzgj2fGdZG2JV9t0JImtLRZBhR6+lL8PdeCe93UmSV
         aRzAHhX4ezB+9yvRGHdmLvj8f3UDCHghUJPcfGv8p9sGOZtoqbs3uMruRc6OSRQ8ap4l
         nmPNBJkGdaCQKnrDyO3FZ2KQilXZcc1JGY5wsRfDm7C17FEkJKoFLVFAhiAVUORnx/8R
         j73pun3zA08e1Rd6zCMw4IPuFhlKP/5w/6/rAkTq2xWsfTl8s2/fModeqmK7io2u/k5l
         ZXTA==
X-Gm-Message-State: APjAAAXfZXOetVU4iOzYcplCZuS73/AkDxfSwUe/C7Sq66SsJcOdS4Ki
        KmNK4eTFtZTjI7nYrsNYBXgkpnym
X-Google-Smtp-Source: APXvYqyyjl3TOhK/uirIOrPJbRHdxYLdsg8bY7HrFmFUxtHM3lbZOUH/Vs+yhSo1V91COkR0QSKplg==
X-Received: by 2002:a6b:148c:: with SMTP id 134mr8278272iou.178.1578796677332;
        Sat, 11 Jan 2020 18:37:57 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id q23sm1680240iob.39.2020.01.11.18.37.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jan 2020 18:37:56 -0800 (PST)
Subject: [bpf-next PATCH v2 2/2] bpf: xdp,
 remove no longer required rcu_read_{un}lock()
From:   John Fastabend <john.fastabend@gmail.com>
To:     bjorn.topel@gmail.com, bpf@vger.kernel.org, toke@redhat.com,
        toshiaki.makita1@gmail.com
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Sat, 11 Jan 2020 18:37:42 -0800
Message-ID: <157879666276.8200.5529955400195897154.stgit@john-Precision-5820-Tower>
In-Reply-To: <157879606461.8200.2816751890292483534.stgit@john-Precision-5820-Tower>
References: <157879606461.8200.2816751890292483534.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we depend on rcu_call() and synchronize_rcu() to also wait
for preempt_disabled region to complete the rcu read critical section
in __dev_map_flush() is no longer required. Except in a few special
cases in drivers that need it for other reasons.

These originally ensured the map reference was safe while a map was
also being free'd. And additionally that bpf program updates via
ndo_bpf did not happen while flush updates were in flight. But flush
by new rules can only be called from preempt-disabled NAPI context.
The synchronize_rcu from the map free path and the rcu_call from the
delete path will ensure the reference there is safe. So lets remove
the rcu_read_lock and rcu_read_unlock pair to avoid any confusion
around how this is being protected.

If the rcu_read_lock was required it would mean errors in the above
logic and the original patch would also be wrong.

Now that we have done above we put the rcu_read_lock in the driver
code where it is needed in a driver dependent way. I think this
helps readability of the code so we know where and why we are
taking read locks. Most drivers will not need rcu_read_locks here
and further XDP drivers already have rcu_read_locks in their code
paths for reading xdp programs on RX side so this makes it symmetric
where we don't have half of rcu critical sections define in driver
and the other half in devmap.

Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 drivers/net/veth.c       |    6 +++++-
 drivers/net/virtio_net.c |    8 ++++++--
 kernel/bpf/devmap.c      |    5 +++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index a552df3..184e1b4 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -377,6 +377,7 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 	unsigned int max_len;
 	struct veth_rq *rq;
 
+	rcu_read_lock();
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK)) {
 		ret = -EINVAL;
 		goto drop;
@@ -418,11 +419,14 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
 	if (flags & XDP_XMIT_FLUSH)
 		__veth_xdp_flush(rq);
 
-	if (likely(!drops))
+	if (likely(!drops)) {
+		rcu_read_unlock();
 		return n;
+	}
 
 	ret = n - drops;
 drop:
+	rcu_read_unlock();
 	atomic64_add(drops, &priv->dropped);
 
 	return ret;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4d7d5434..2c11f82 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -498,12 +498,16 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	void *ptr;
 	int i;
 
+	rcu_read_lock();
+
 	/* Only allow ndo_xdp_xmit if XDP is loaded on dev, as this
 	 * indicate XDP resources have been successfully allocated.
 	 */
 	xdp_prog = rcu_dereference(rq->xdp_prog);
-	if (!xdp_prog)
+	if (!xdp_prog) {
+		rcu_read_unlock();
 		return -ENXIO;
+	}
 
 	sq = virtnet_xdp_sq(vi);
 
@@ -552,7 +556,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	sq->stats.xdp_tx_drops += drops;
 	sq->stats.kicks += kicks;
 	u64_stats_update_end(&sq->stats.syncp);
-
+	rcu_read_unlock();
 	return ret;
 }
 
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f0bf525..d0ce2e2 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -372,16 +372,17 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, u32 flags)
  * from NET_RX_SOFTIRQ. Either way the poll routine must complete before the
  * net device can be torn down. On devmap tear down we ensure the flush list
  * is empty before completing to ensure all flush operations have completed.
+ * When drivers update the bpf program they may need to ensure any flush ops
+ * are also complete. Using synchronize_rcu or call_rcu will suffice for this
+ * because both wait for napi context to exit.
  */
 void __dev_map_flush(void)
 {
 	struct list_head *flush_list = this_cpu_ptr(&dev_map_flush_list);
 	struct xdp_bulk_queue *bq, *tmp;
 
-	rcu_read_lock();
 	list_for_each_entry_safe(bq, tmp, flush_list, flush_node)
 		bq_xmit_all(bq, XDP_XMIT_FLUSH);
-	rcu_read_unlock();
 }
 
 /* rcu_read_lock (from syscall and BPF contexts) ensures that if a delete and/or

