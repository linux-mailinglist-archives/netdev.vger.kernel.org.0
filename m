Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773681498A3
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 04:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgAZD7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 22:59:45 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39861 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbgAZD7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 22:59:44 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so2464972plp.6;
        Sat, 25 Jan 2020 19:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fEp2tBURROlhYKIVBLvlPnIxXcmQzUZcU2zhMK+Ny8k=;
        b=kAH2Mk54tpKfeIvs9dLDJlgOWFPzBScpMH9NWN+aDHXxUDPDDeuErMlLavKpwd5zKq
         mkeTSMB2uuUfMcHGjgaLsfNPW6P7uABX4pb3vettusUzlLzEvEM1HrhgR1PLzgOOOSyp
         jITNLWv/GDcfjekI2X1w6rNXk6hcxByGIMzrSCQE8Ysyu9ZBh2AgcMMQDVXGgzJZJ+W0
         PXkK8+gSLRYDg9KpzGsXFLFqbqHKb2P6f4iHyzYpjb0WAQgRQHFH4xeklUIS0LLUBbAR
         9O3u9LkTSQvV/rC3J4XoPKbcejDsNhI8ksax6l6CcZ4PY3cWyHJx3lSQ+c9V0arCg25/
         L7qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fEp2tBURROlhYKIVBLvlPnIxXcmQzUZcU2zhMK+Ny8k=;
        b=KtMEOoOt+66rGh0DW5xBOQEcPbkWlcRYhCmbEsM74ONi9YuUaRqe/VHMRye1iWbrT7
         FOJ7Ardpoz4wkxs5ySLXxmFP51tjBxvR8LlHnl2fGo46f7l4DoxYSvGNQ/5goHRG+XDt
         h1MAh6jaRQJYYmtMrHRoqEJWXW/rP+0VKjLe6iaAQgdv8oGHvSLJB8+YXhfz+1CYE8aW
         uE93l1CYS1EQHruLnJivqMkEAJ+N/Vbyb74h90VC2cRGyBmGO7Hyt21eTRGl9QZMkWxr
         dmU2pc/y3YAw5x0LSSmyYqUnW5eaap2aLT6ETVil7SXgQCbyzmVrwOG/2ypxVlGDQEaJ
         OOLA==
X-Gm-Message-State: APjAAAV61hbdHfAetq2zBDLPH3rayZXBWQxSmkpeoqOJuEuYMq8uJz8T
        BmICwoAYZAAsWtfiZxEy89gxKaf1
X-Google-Smtp-Source: APXvYqyHTXdBfKiLJkEnjWvxfqF4QBLDJW+YZ2cQ3ABDFcXiok5eZDGeypK/2ozN1BDcfkRZB+uB7g==
X-Received: by 2002:a17:90b:3011:: with SMTP id hg17mr7607242pjb.90.1580011183786;
        Sat, 25 Jan 2020 19:59:43 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 64sm11078650pfd.48.2020.01.25.19.59.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 25 Jan 2020 19:59:43 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     bjorn.topel@intel.com, songliubraving@fb.com,
        john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        toke@redhat.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 3/3] bpf: xdp, remove no longer required rcu_read_{un}lock()
Date:   Sat, 25 Jan 2020 19:58:53 -0800
Message-Id: <1580011133-17784-4-git-send-email-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580011133-17784-1-git-send-email-john.fastabend@gmail.com>
References: <1580011133-17784-1-git-send-email-john.fastabend@gmail.com>
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

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 drivers/net/veth.c  | 6 +++++-
 kernel/bpf/devmap.c | 5 +++--
 2 files changed, 8 insertions(+), 3 deletions(-)

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
-- 
2.7.4

