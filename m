Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BD1207A1A
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405455AbgFXRTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405451AbgFXRTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:19:19 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF85AC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:18 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id w2so915671pgg.10
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=70hby/uDfnlNOV84ZWyp8KNhkZ8UU7RwIhRI9s67NEc=;
        b=PdmPaahHcaUcSThGgBro358sZNBvviSfpxQiyxyA8ko76/Bzs5iTnuHUD+913/p8jg
         D2a8bC+r0tPewLCBMzWLNvMog38jKIsvyhgbBlB53uzSaJfgOYhCnfRuN9c9Zd0EXoyv
         ke97xb6NfZwZCoY4LfJdyZL5rKi6hshYiwhZ5QSbOETi/YtZ0PQ+z65/qk0yL/YIUCPi
         Fdx9jpZXlsS0Tv+sDeLHqyFFHxEc8KSCxxAlgs3YkQMuW9GXdQs295a1VJV4IbTc8OwK
         mKoCiSjls72lA5NvXOsxubXBEVvGBud36rbw2XWvItM9zNoDqAPgfA7GpJv3GZ2C5CTP
         U+Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=70hby/uDfnlNOV84ZWyp8KNhkZ8UU7RwIhRI9s67NEc=;
        b=UvGBNPligWpkOLUgeO6diykQFU9kwAGn4KcpUkwzEp8GiQikk8VJPH3YWhmfrg+y2S
         8elyf6tROQsDibrv2r/v8tv35hdQcklCZfkHSoWyRYneoIQMTdP+TlvzmKbDns4IMmkz
         67E2UWndEv+DEezpsjSUqzmHeKp6hUfK7Iwv2Ho1IFe6xPDeu9H5U0Dnga7ACr2eccaj
         OxbnU6TC4HUg1lxmlHHpu4cTaNUlKjg2uDsY9rNjAZDSSAoyYaflm/uLmH7OjOuEwHTY
         JpeT0Eb0zvIb1bg5cwDW6Wxp0F8XDxK4x5DbBuwjdWU+CwEepecX4p63ju9KALyKjR5E
         corw==
X-Gm-Message-State: AOAM533NrtolOPjjMftYPR58mYvsTmK9/KsFtkQG25ZQwUYX0nk1dvjF
        1CyJ1Crk4IlJKvrkS0IE1ReRgti9cE8=
X-Google-Smtp-Source: ABdhPJzoKpvimB8ijVg2M/UozoW3bWV5HuW9QTZNuuj67H0GJk1ky50V/+WzjqK3YqVMknOaKYFB1g==
X-Received: by 2002:a65:6496:: with SMTP id e22mr23292609pgv.63.1593019158077;
        Wed, 24 Jun 2020 10:19:18 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id w18sm17490241pgj.31.2020.06.24.10.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:19:17 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH 03/11] arfs: Create set_arfs_queue
Date:   Wed, 24 Jun 2020 10:17:42 -0700
Message-Id: <20200624171749.11927-4-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624171749.11927-1-tom@herbertland.com>
References: <20200624171749.11927-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abstract out the code for steering a flow to an aRFS queue (via
ndo_rx_flow_steer) into its own function. This allows the function to
be called in other use cases.
---
 net/core/dev.c | 67 +++++++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6bc2388141f6..9f7a3e78e23a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4250,42 +4250,53 @@ EXPORT_SYMBOL(rps_needed);
 struct static_key_false rfs_needed __read_mostly;
 EXPORT_SYMBOL(rfs_needed);
 
+#ifdef CONFIG_RFS_ACCEL
+static void set_arfs_queue(struct net_device *dev, struct sk_buff *skb,
+			   struct rps_dev_flow *rflow, u16 rxq_index)
+{
+	struct rps_dev_flow_table *flow_table;
+	struct netdev_rx_queue *rxqueue;
+	struct rps_dev_flow *old_rflow;
+	u32 flow_id;
+	int rc;
+
+	rxqueue = dev->_rx + rxq_index;
+
+	flow_table = rcu_dereference(rxqueue->rps_flow_table);
+	if (!flow_table)
+		return;
+
+	flow_id = skb_get_hash(skb) & flow_table->mask;
+	rc = dev->netdev_ops->ndo_rx_flow_steer(dev, skb,
+						rxq_index, flow_id);
+	if (rc < 0)
+		return;
+
+	old_rflow = rflow;
+	rflow = &flow_table->flows[flow_id];
+	rflow->filter = rc;
+	if (old_rflow->filter == rflow->filter)
+		old_rflow->filter = RPS_NO_FILTER;
+}
+#endif
+
 static struct rps_dev_flow *
 set_rps_cpu(struct net_device *dev, struct sk_buff *skb,
 	    struct rps_dev_flow *rflow, u16 next_cpu)
 {
 	if (next_cpu < nr_cpu_ids) {
 #ifdef CONFIG_RFS_ACCEL
-		struct netdev_rx_queue *rxqueue;
-		struct rps_dev_flow_table *flow_table;
-		struct rps_dev_flow *old_rflow;
-		u32 flow_id;
-		u16 rxq_index;
-		int rc;
 
 		/* Should we steer this flow to a different hardware queue? */
-		if (!skb_rx_queue_recorded(skb) || !dev->rx_cpu_rmap ||
-		    !(dev->features & NETIF_F_NTUPLE))
-			goto out;
-		rxq_index = cpu_rmap_lookup_index(dev->rx_cpu_rmap, next_cpu);
-		if (rxq_index == skb_get_rx_queue(skb))
-			goto out;
-
-		rxqueue = dev->_rx + rxq_index;
-		flow_table = rcu_dereference(rxqueue->rps_flow_table);
-		if (!flow_table)
-			goto out;
-		flow_id = skb_get_hash(skb) & flow_table->mask;
-		rc = dev->netdev_ops->ndo_rx_flow_steer(dev, skb,
-							rxq_index, flow_id);
-		if (rc < 0)
-			goto out;
-		old_rflow = rflow;
-		rflow = &flow_table->flows[flow_id];
-		rflow->filter = rc;
-		if (old_rflow->filter == rflow->filter)
-			old_rflow->filter = RPS_NO_FILTER;
-	out:
+		if (skb_rx_queue_recorded(skb) && dev->rx_cpu_rmap &&
+		    (dev->features & NETIF_F_NTUPLE)) {
+			u16 rxq_index;
+
+			rxq_index = cpu_rmap_lookup_index(dev->rx_cpu_rmap,
+							  next_cpu);
+			if (rxq_index != skb_get_rx_queue(skb))
+				set_arfs_queue(dev, skb, rflow, rxq_index);
+		}
 #endif
 		rflow->last_qtail =
 			per_cpu(softnet_data, next_cpu).input_queue_head;
-- 
2.25.1

