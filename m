Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306BC149DF5
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 01:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgA0AOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 19:14:52 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46719 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgA0AOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 19:14:51 -0500
Received: by mail-pf1-f196.google.com with SMTP id k29so1566134pfp.13;
        Sun, 26 Jan 2020 16:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p84g0qKiuqEEntAsj7EHhSdJwxP3dtEjqrEnC5w/2AI=;
        b=Oacr/vODgYV7TIyH2HUpaYeIk/9HDS4DdfHNXvKCMX0O+GEB5JYVeL0hoghFcv0lUk
         0HDvEQcAgvBUZv9cIWmyzp+879xuJ/JL20hboLKtOhFpxKyaL+XLupQ1+AVAZX0GfEPu
         5JxyRXhloU0a8+Pvv/fWOLXKE1J6QRsTPsNbSa0mzZnvzxH2AZ431OmQ/EYf2ThjNxaF
         7Bu/UKkUoOaaLGU92Nx22AyaBnnK7iVn++SpRLT1aVhvlEWmkCsFgFKSMp3ltHMU+pkQ
         P/OQNE8eG9bIfkgvag6arFXhT7aGTPnunKi9bjseLeBaQNY0BsFLQDSZzzqajH1ZuHp7
         8F6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p84g0qKiuqEEntAsj7EHhSdJwxP3dtEjqrEnC5w/2AI=;
        b=j9oToHBDhFzJC6lemC7J+DhN3SaOQFmNzeW46Ewj3pwvgCoRULmupyoHcz1LswfZyw
         Ibngblaq3Rry7KAOXeL4Ra+d1lf+EaBVsMwIsvitUcWqruyVxjd4ufcFAZNpz9hZerxy
         L/KsT51KpADpEL6oCi5gpifl6pO5sOytrxojXoGU7fi4wMPPOAuVFAXNE9mdmsHcpeGA
         GyTngw81LabSskoi2GliQgTIuVbXIAl37deGEPanl9CJcL6uXsGcC/WKl94+ye8iiVMG
         +1eucDTkXK3yTMA/32miNcub9FZI7ShtFDwuxZvoSLD9ZZtO0Zmmz3+QWfcsVeFsWCWm
         m+3Q==
X-Gm-Message-State: APjAAAWN0FNs5cf/BFeZuytmCrH0ZxVsRC0h4qSOop8fP2NgWPiqXFqk
        6v2aW+9OJEUd4QoQnbms1lTx/m9i
X-Google-Smtp-Source: APXvYqwZvBOZMavlMQd3vOkL1+oPCz1EkiblVDRhZxAbl0HVcjXH8SKuzHEQBEeLu764j6tIf4JVcg==
X-Received: by 2002:a62:486:: with SMTP id 128mr6804130pfe.236.1580084090722;
        Sun, 26 Jan 2020 16:14:50 -0800 (PST)
Received: from localhost.localdomain ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id i23sm13326949pfo.11.2020.01.26.16.14.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 26 Jan 2020 16:14:50 -0800 (PST)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org
Cc:     bjorn.topel@intel.com, songliubraving@fb.com,
        john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        toke@redhat.com, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 3/3] bpf: xdp, remove no longer required rcu_read_{un}lock()
Date:   Sun, 26 Jan 2020 16:14:02 -0800
Message-Id: <1580084042-11598-4-git-send-email-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580084042-11598-1-git-send-email-john.fastabend@gmail.com>
References: <1580084042-11598-1-git-send-email-john.fastabend@gmail.com>
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

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
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
index 707583f..2b83c56 100644
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

