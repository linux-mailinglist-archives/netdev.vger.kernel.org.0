Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC154C08C5
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 17:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfI0PlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 11:41:05 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34654 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbfI0PlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 11:41:05 -0400
Received: by mail-qt1-f196.google.com with SMTP id 3so7846858qta.1;
        Fri, 27 Sep 2019 08:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=fJXAR3BTSiEDrzcXRUPmAyScpWS/7FX+Os6XghgaQU0=;
        b=uyS4auWyENLNwj4ODdMyhIEu9qmUQi6TF/0NgNXCDOSuv8he1njkkWUbH6MAAuI3dw
         7vLlXOh9w2X0TDPsPQJ0xGa50Y/w8Pbl0Q9cF27Vp8Qvg0noboRK1e1n1eLo/A2AjyuD
         uoQuNkjjiuKExO3npjd3EHDSrgGrqoZRhPGtTlDZDMXATXqpIrJAX7izsK0w7Yxgn93w
         /QvzX10WXMfskAJ0QsMBgNc4pDJMZWNa6H9v21iOR2mV7ZrMDDpVkvXmSUJ1ClSH+Wtd
         HW3kxO7tiQRWuLfj+Hl5STNb7ChjeOJD5rGDjJhnWylO6N16KyagbovNjvtXlcz3Dmtm
         BIGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=fJXAR3BTSiEDrzcXRUPmAyScpWS/7FX+Os6XghgaQU0=;
        b=b1EeUYzNUfYKr2cxCw0a+2WaVE0rou6lpU02jW4o2Xfv80cMUOqcaIrlQs106WHHom
         X/Q1kCfHVYkzn/kXt6sk8WfK4jBs/S74dxAiEt5DD+qUljA0cZf7K05L7adTvWdjmSwm
         i/MFmGij10Vr2W8fKR3KoqQztYbpyt50kiW5JnpZkaWjt6FM93cJo7GenZi48DbD8mLK
         tqGbtOYd8MsjEXdyS9nt4G+JC5gal0ZEV5bOvex1Wayv1CKwSmMmvj4kW7DTT9RQ/oKO
         NMO605D3asO1xm15h87Ne2ynq0D22QhXZCSJcHfVf1duoiJu62txqMLijGf/Ipp9ddEC
         mPFA==
X-Gm-Message-State: APjAAAX/IUOm2t8Z7dLcHrSrjmpBxfdaGtyaduB1272TajRPIcw5rNQa
        3rMQf9d5AQV4PDlHIE52z21jjKJ1GK8v/qYm
X-Google-Smtp-Source: APXvYqzflvmRBLJzHuAYDcQ5In3raI9yBS1yeQB4x+QTsu/BKYjGLPhy0jFumIrbkX37mMPtLYA1/A==
X-Received: by 2002:ac8:67ce:: with SMTP id r14mr10362936qtp.317.1569598864212;
        Fri, 27 Sep 2019 08:41:04 -0700 (PDT)
Received: from ArchLaptop (lithosphere-80.dynamic2.rpi.edu. [129.161.139.80])
        by smtp.gmail.com with ESMTPSA id p53sm2775779qtk.23.2019.09.27.08.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 08:41:03 -0700 (PDT)
Date:   Fri, 27 Sep 2019 11:41:02 -0400
From:   Aaron Hill <aa1ronham@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: mac80211: Disable preeemption when updating stat
 counters
Message-ID: <20190927154102.GA117350@ArchLaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mac80211 subsystem maintains per-cpu stat counters for receive and
transmit operations. Previously, preemption was not disabled when
updating these counters. This creates a race condition where two cpus
could attempt to update the same counters using non-atomic operations.

This was causing a
'BUG: using smp_processor_id() in preemptible [00000000] code'
message to be printed, along with a stacktrace. This was reported
in a few different places:

* https://www.spinics.net/lists/linux-wireless/msg189992.html
* https://bugzilla.kernel.org/show_bug.cgi?id=204127

This patch adds calls to preempt_disable() and preempt_enable()
surrounding the updating of the stat counters.

Signed-off-by: Aaron Hill <aa1ronham@gmail.com>
---
 net/mac80211/rx.c | 7 ++++++-
 net/mac80211/tx.c | 7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 768d14c9a716..5ef0667151bf 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -34,12 +34,17 @@
 
 static inline void ieee80211_rx_stats(struct net_device *dev, u32 len)
 {
-	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
+	struct pcpu_sw_netstats *tstats;
+
+	// Disable preemption while updating per-cpu stats counters
+	preempt_disable();
+	tstats = this_cpu_ptr(dev->tstats);
 
 	u64_stats_update_begin(&tstats->syncp);
 	tstats->rx_packets++;
 	tstats->rx_bytes += len;
 	u64_stats_update_end(&tstats->syncp);
+	preempt_enable();
 }
 
 static u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 1fa422782905..4cad3d741b6b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -40,12 +40,17 @@
 
 static inline void ieee80211_tx_stats(struct net_device *dev, u32 len)
 {
-	struct pcpu_sw_netstats *tstats = this_cpu_ptr(dev->tstats);
+	struct pcpu_sw_netstats *tstats;
+
+	// Disable preemption while updating per-cpu stats counters
+	preempt_disable();
+	tstats = this_cpu_ptr(dev->tstats);
 
 	u64_stats_update_begin(&tstats->syncp);
 	tstats->tx_packets++;
 	tstats->tx_bytes += len;
 	u64_stats_update_end(&tstats->syncp);
+	preempt_enable();
 }
 
 static __le16 ieee80211_duration(struct ieee80211_tx_data *tx,
-- 
2.23.0

