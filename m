Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EF348512C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 11:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbiAEKdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 05:33:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230175AbiAEKdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 05:33:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641378810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MwXZjqPP0ZAnoQx567GFPG4xDlNNWyMwVPpZmwn5it0=;
        b=QXeqc7RbbzdKS9U7yYWP/L8p6YQZ9Te7jLC/gsSrS5AdqYhMSYZ/vWQfYb8IdUvmf5T6vz
        IrXDqPGE3PYLuGfZtb+LwwHJDijBEHiaF6jxz2YkCqmWsI8IJSfLzkjWWYj0NGxsrj9bs3
        ZuOqVrdT0SS8a/0c9PMUyzp2axG6lug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-601-97uNaiU0P2C12RsWMil0Nw-1; Wed, 05 Jan 2022 05:33:29 -0500
X-MC-Unique: 97uNaiU0P2C12RsWMil0Nw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29FB03482D;
        Wed,  5 Jan 2022 10:33:28 +0000 (UTC)
Received: from queeg.tpb.lab.eng.brq.redhat.com (unknown [10.43.135.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30E135ED29;
        Wed,  5 Jan 2022 10:33:27 +0000 (UTC)
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next] net: fix SOF_TIMESTAMPING_BIND_PHC to work with multiple sockets
Date:   Wed,  5 Jan 2022 11:33:26 +0100
Message-Id: <20220105103326.3130875-1-mlichvar@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When multiple sockets using the SOF_TIMESTAMPING_BIND_PHC flag received
a packet with a hardware timestamp (e.g. multiple PTP instances in
different PTP domains using the UDPv4/v6 multicast or L2 transport),
the timestamps received on some sockets were corrupted due to repeated
conversion of the same timestamp (by the same or different vclocks).

Fix ptp_convert_timestamp() to not modify the shared skb timestamp
and return the converted timestamp as a ktime_t instead. If the
conversion fails, return 0 to not confuse the application with
timestamps corresponding to an unexpected PHC.

Fixes: d7c088265588 ("net: socket: support hardware timestamp conversion to PHC bound")
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Cc: Richard Cochran <richardcochran@gmail.com>
---
 drivers/ptp/ptp_vclock.c         | 10 +++++-----
 include/linux/ptp_clock_kernel.h | 12 +++++++-----
 net/socket.c                     |  9 ++++++---
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index baee0379482b..ab1d233173e1 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -185,8 +185,8 @@ int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
 }
 EXPORT_SYMBOL(ptp_get_vclocks_index);
 
-void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
-			   int vclock_index)
+ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
+			      int vclock_index)
 {
 	char name[PTP_CLOCK_NAME_LEN] = "";
 	struct ptp_vclock *vclock;
@@ -198,12 +198,12 @@ void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
 	snprintf(name, PTP_CLOCK_NAME_LEN, "ptp%d", vclock_index);
 	dev = class_find_device_by_name(ptp_class, name);
 	if (!dev)
-		return;
+		return 0;
 
 	ptp = dev_get_drvdata(dev);
 	if (!ptp->is_virtual_clock) {
 		put_device(dev);
-		return;
+		return 0;
 	}
 
 	vclock = info_to_vclock(ptp->info);
@@ -215,7 +215,7 @@ void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
 	spin_unlock_irqrestore(&vclock->lock, flags);
 
 	put_device(dev);
-	hwtstamps->hwtstamp = ns_to_ktime(ns);
+	return ns_to_ktime(ns);
 }
 EXPORT_SYMBOL(ptp_convert_timestamp);
 #endif
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index 2e5565067355..554454cb8693 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -351,15 +351,17 @@ int ptp_get_vclocks_index(int pclock_index, int **vclock_index);
  *
  * @hwtstamps:    skb_shared_hwtstamps structure pointer
  * @vclock_index: phc index of ptp vclock.
+ *
+ * Returns converted timestamp, or 0 on error.
  */
-void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
-			   int vclock_index);
+ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
+			      int vclock_index);
 #else
 static inline int ptp_get_vclocks_index(int pclock_index, int **vclock_index)
 { return 0; }
-static inline void ptp_convert_timestamp(struct skb_shared_hwtstamps *hwtstamps,
-					 int vclock_index)
-{ }
+static inline ktime_t ptp_convert_timestamp(const struct skb_shared_hwtstamps *hwtstamps,
+					    int vclock_index)
+{ return 0; }
 
 #endif
 
diff --git a/net/socket.c b/net/socket.c
index 7f64a6eccf63..5053eb0100e4 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -829,6 +829,7 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 	int empty = 1, false_tstamp = 0;
 	struct skb_shared_hwtstamps *shhwtstamps =
 		skb_hwtstamps(skb);
+	ktime_t hwtstamp;
 
 	/* Race occurred between timestamp enabling and packet
 	   receiving.  Fill in the current time for now. */
@@ -877,10 +878,12 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 	    (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
 	    !skb_is_swtx_tstamp(skb, false_tstamp)) {
 		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
-			ptp_convert_timestamp(shhwtstamps, sk->sk_bind_phc);
+			hwtstamp = ptp_convert_timestamp(shhwtstamps,
+							 sk->sk_bind_phc);
+		else
+			hwtstamp = shhwtstamps->hwtstamp;
 
-		if (ktime_to_timespec64_cond(shhwtstamps->hwtstamp,
-					     tss.ts + 2)) {
+		if (ktime_to_timespec64_cond(hwtstamp, tss.ts + 2)) {
 			empty = 0;
 
 			if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_PKTINFO) &&
-- 
2.33.1

