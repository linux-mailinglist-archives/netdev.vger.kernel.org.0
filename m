Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42296207A22
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405497AbgFXRTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405491AbgFXRTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:19:46 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FF1C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:45 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z63so1455019pfb.1
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kHpXfg6D3vEApiJp8FQJ17UW76ojekkZfCE2qlXVgXY=;
        b=Br8IBGH2Xmb73N/0o9TRZOormUqUmQirAesW+uM30rLSADM+9b0Gwt8ZnXWUBHSUsG
         D19XU8quYUF+2lp1lyCCBwOvpGBpv54j+KDdoJsmq8xBQ4uqlE5Feoby9nGL8aJTg0gP
         lJmLMvOOKLzHV7Q4Q0v1gyFX5fGmtJL+tL97zTyjs/rNgZeT510fQGCPOZpTOO6zHVcl
         SbUcPIsvZk/rAlLaCdwYQVbVlnFOMVHlpnAm//cZXzVTRFLYvyhvHu8C432zERcqCUca
         yhSy0TuY48gG6iVPggS2R3jrAFDdnZj1CWkErdhMZeQS3rxYNUUMXKe2KOXQukv+2WQC
         w92w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kHpXfg6D3vEApiJp8FQJ17UW76ojekkZfCE2qlXVgXY=;
        b=gbbnQFqqKq4L+WKaszIiks4Fb4h/DHP3cgShATnVNimibYRmobMxkV1xKayI7N8fkr
         xQNo31yqaLEwxxxatNsQdu75jVBegvA2TILrdgTuVC2Rbly2WqViFeLDesmR23cop/+P
         FKBgjGQZRCX1PhGXMsjlxRGUlsebww1XnZJtBVHzh9La4eFlE2UDa87e63LF/ibkyKKI
         MMIBPQFlTkxTfAPtnbJSOugyG6PxVsog0TllDlZXuE9NUdRFEyk4l0MFFbQWUsiTaRUY
         NW7JBxyOQwT7GulrlsNqE+z9I7AOgCvJdT5PjrU3A/afaxc4nYS4MMFr+B/uvKDzDbXb
         QASw==
X-Gm-Message-State: AOAM533OHip1sLxyDS1MA9QSpn451xDodBwOTywRyYaAB62Y8XZ6JMQn
        Whym1HRX35Z3bnwpk2ss8tJpH6J0vv4=
X-Google-Smtp-Source: ABdhPJwYTaoHrrPEGizGjp15Mv9FGUcMrnWdlabyII631oaj14Xznqo2Dcto8bf6c7ccd6dX4UDwiw==
X-Received: by 2002:a63:564e:: with SMTP id g14mr6655093pgm.326.1593019184487;
        Wed, 24 Jun 2020 10:19:44 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id w18sm17490241pgj.31.2020.06.24.10.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:19:43 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH 10/11] ptq: Hook up receive side of Per Queue Threads
Date:   Wed, 24 Jun 2020 10:17:49 -0700
Message-Id: <20200624171749.11927-11-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624171749.11927-1-tom@herbertland.com>
References: <20200624171749.11927-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add code to set the queue in an rflow as opposed to just setting the
CPU in an rps_dev_flow entry. set_rps_qid is the analogue for
set_rps_cpu but for setting queues. In get_rps_cpu, a check is
performed that identifier in the sock_flow_table refers to a queue;
when it does call set_rps_qid after converting the global qid in the
sock_flow_table to a device qid.

In rps_record_sock_flow check is there is a per task receive queue
for current (i.e. current->ptq_queues.rxq_id != NO_QUEUE). If there
is a queue then set in sock_flow_table instead of setting the running
CPU. Subsequently, the receive queue for the flow can be programmed
by aRFS logic (ndo_rx_flow_steer).
---
 include/linux/netdevice.h | 28 ++++++++++++++++++++++++----
 net/core/dev.c            | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ca163925211a..3b39be470720 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -731,12 +731,25 @@ static inline void rps_dev_flow_set_cpu(struct rps_dev_flow *dev_flow, u16 cpu)
 	if (WARN_ON(cpu > RPS_MAX_CPU))
 		return;
 
-	/* Set the rflow target to the CPU atomically */
+	/* Set the device flow target to the CPU atomically */
 	cpu_qid.use_qid = 0;
 	cpu_qid.cpu = cpu;
 	dev_flow->cpu_qid = cpu_qid;
 }
 
+static inline void rps_dev_flow_set_qid(struct rps_dev_flow *dev_flow, u16 qid)
+{
+	struct rps_cpu_qid cpu_qid;
+
+	if (WARN_ON(qid > RPS_MAX_QID))
+		return;
+
+	/* Set the device flow target to the CPU atomically */
+	cpu_qid.use_qid = 1;
+	cpu_qid.qid = qid;
+	dev_flow->cpu_qid = cpu_qid;
+}
+
 /*
  * The rps_dev_flow_table structure contains a table of flow mappings.
  */
@@ -797,11 +810,18 @@ static inline void rps_record_sock_flow(struct rps_sock_flow_table *table,
 					u32 hash)
 {
 	if (table && hash) {
-		u32 val = hash & table->cpu_masks.hash_mask;
 		unsigned int index = hash & table->mask;
+		u32 val;
 
-		/* We only give a hint, preemption can change CPU under us */
-		val |= raw_smp_processor_id();
+#ifdef CONFIG_PER_THREAD_QUEUES
+		if (current->ptq_queues.rxq_id != NO_QUEUE)
+			val = RPS_SOCK_FLOW_USE_QID |
+			      (hash & table->queue_masks.hash_mask) |
+			      current->ptq_queues.rxq_id;
+		else
+#endif
+			val = (hash & table->cpu_masks.hash_mask) |
+			      raw_smp_processor_id();
 
 		if (table->ents[index] != val)
 			table->ents[index] = val;
diff --git a/net/core/dev.c b/net/core/dev.c
index f4478c9b1c9c..1cad776e8847 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4308,6 +4308,25 @@ set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 	return rflow;
 }
 
+static struct rps_dev_flow *
+set_rps_qid(struct net_device *dev, struct sk_buff *skb,
+	    struct rps_dev_flow *rflow, u16 qid)
+{
+	if (qid > RPS_MAX_QID) {
+		rps_dev_flow_clear(rflow);
+		return rflow;
+	}
+
+#ifdef CONFIG_RFS_ACCEL
+	/* Should we steer this flow to a different hardware queue? */
+	if (skb_rx_queue_recorded(skb) && (dev->features & NETIF_F_NTUPLE) &&
+	    qid != skb_get_rx_queue(skb) && qid < dev->real_num_rx_queues)
+		set_arfs_queue(dev, skb, rflow, qid);
+#endif
+	rps_dev_flow_set_qid(rflow, qid);
+	return rflow;
+}
+
 /*
  * get_rps_cpu is called from netif_receive_skb and returns the target
  * CPU from the RPS map of the receiving queue for a given skb.
@@ -4356,6 +4375,10 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 
 		/* First check into global flow table if there is a match */
 		ident = sock_flow_table->ents[hash & sock_flow_table->mask];
+
+		if (ident == RPS_SOCK_FLOW_NO_IDENT)
+			goto try_rps;
+
 		comparator = ((ident & RPS_SOCK_FLOW_USE_QID) ?
 				sock_flow_table->queue_masks.hash_mask :
 				sock_flow_table->cpu_masks.hash_mask);
@@ -4372,8 +4395,21 @@ static int get_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 		 * CPU. Proceed accordingly.
 		 */
 		if (ident & RPS_SOCK_FLOW_USE_QID) {
+			u16 dqid, gqid;
+
 			/* A queue identifier is in the sock_flow_table entry */
 
+			gqid = ident & sock_flow_table->queue_masks.mask;
+			dqid = netdev_rx_gqid_to_dqid(dev, gqid);
+
+			/* rflow has desired receive qid. Just set the qid in
+			 * HW and return to use current CPU. Note that we
+			 * don't consider OOO in this case.
+			 */
+			rflow = set_rps_qid(dev, skb, rflow, dqid);
+
+			*rflowp = rflow;
+
 			/* Don't use aRFS to set CPU in this case, skip to
 			 * trying RPS
 			 */
-- 
2.25.1

