Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5602229531E
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 21:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440724AbgJUTvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 15:51:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:57150 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410356AbgJUTvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 15:51:11 -0400
IronPort-SDR: PFxj8FoUo/AHMWn/kgf2abQRp28BMEIrvVdVFVascb/XnHozEokmOVKKtDAYYlI8MaJIRXNKp5
 8aIpC9/DlVrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="231618707"
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="231618707"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 12:51:10 -0700
IronPort-SDR: LEu7RheVpZJHscdDcW/p7vlZP2t69JSgTlBob5kI7UeBvlFjVBkr58iXn/GzdlfYUqfkzMQENx
 xqFZmSjtOq7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="392834638"
Received: from harshitha-linux4.jf.intel.com ([10.166.17.87])
  by orsmga001.jf.intel.com with ESMTP; 21 Oct 2020 12:51:10 -0700
From:   Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     tom@herbertland.com, carolyn.wyborny@intel.com,
        jacob.e.keller@intel.com, amritha.nambiar@intel.com,
        Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
Subject: [RFC PATCH net-next 1/3] sock: Definition and general functions for dev_and_queue structure
Date:   Wed, 21 Oct 2020 12:47:41 -0700
Message-Id: <20201021194743.781583-2-harshitha.ramamurthy@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201021194743.781583-1-harshitha.ramamurthy@intel.com>
References: <20201021194743.781583-1-harshitha.ramamurthy@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>

Add struct dev_and_queue which holds and ifindex and queue pair. Add
generic functions to get the queue for the ifindex held as well as
functions to set, clear the pair in a structure.

Signed-off-by: Tom Herbert <tom@herbertland.com>
Signed-off-by: Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
---
 include/net/sock.h | 52 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index a5c6ae78df77..9755a6cab1a1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -107,6 +107,16 @@ typedef struct {
 #endif
 } socket_lock_t;
 
+struct dev_and_queue {
+	union {
+		struct {
+			int ifindex;
+			u16 queue;
+		};
+		u64 val64;
+	};
+};
+
 struct sock;
 struct proto;
 struct net;
@@ -1791,6 +1801,46 @@ static inline int sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 	return __sk_receive_skb(sk, skb, nested, 1, true);
 }
 
+#define NO_QUEUE_MAPPING	USHRT_MAX
+
+static inline int __dev_and_queue_get(const struct dev_and_queue *idandq,
+				       int ifindex)
+{
+	struct dev_and_queue dandq;
+
+	dandq.val64 = idandq->val64;
+
+	if (dandq.ifindex == ifindex && dandq.queue != NO_QUEUE_MAPPING)
+		return dandq.queue;
+
+	return -1;
+}
+
+static inline void __dev_and_queue_set(struct dev_and_queue *odandq,
+				       int ifindex, int queue)
+{
+	struct dev_and_queue dandq;
+
+	/* queue_mapping accept only upto a 16-bit value */
+	if (WARN_ON_ONCE((unsigned short)queue >= USHRT_MAX))
+		return;
+
+	dandq.ifindex = ifindex;
+	dandq.queue = queue;
+
+	odandq->val64 = dandq.val64;
+}
+
+static inline void __dev_and_queue_clear(struct dev_and_queue *odandq)
+{
+	struct dev_and_queue dandq;
+
+	dandq.ifindex = -1;
+	dandq.queue = NO_QUEUE_MAPPING;
+
+	odandq->val64 = dandq.val64;
+}
+
 static inline void sk_tx_queue_set(struct sock *sk, int tx_queue)
 {
 	/* sk_tx_queue_mapping accept only upto a 16-bit value */
@@ -1799,8 +1849,6 @@ static inline void sk_tx_queue_set(struct sock *sk, int tx_queue)
 	sk->sk_tx_queue_mapping = tx_queue;
 }
 
-#define NO_QUEUE_MAPPING	USHRT_MAX
-
 static inline void sk_tx_queue_clear(struct sock *sk)
 {
 	sk->sk_tx_queue_mapping = NO_QUEUE_MAPPING;
-- 
2.26.2

