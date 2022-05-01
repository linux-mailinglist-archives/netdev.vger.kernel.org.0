Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE250516406
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345685AbiEALWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345385AbiEALWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:22:19 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B286583A6
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 04:18:53 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g20so13747591edw.6
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 04:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+5h3vX/uenadcWCVCAzeCC1leutd8xV6aDGFHYcrbP8=;
        b=75BqDTGnuTZlUVn6Dx3YWDzsyduqpsEZcUPdW+8+MNe5LRfw8rAAKOtVJVtn9B+2LW
         u+E/KYN+yFOdcUnwu+tovbBDFpoM5kwToW+I8HNQl1jEWbeOEXEar8pGonvqwn7c0bvq
         JqMLpKKy4IEH/jN4fcpvvAms56ty224vRCg7S9EvHPyOA79seRuA25ySxkQcbqynbesC
         Dnx/QN86CIN6oVEDZKzuVBypMt4WEzm7m7asrbusLe1AdX2DFevIs8akWS0WWU+X5WLD
         UKdvU872pKE1TcLedu/znsxNn6AnzHKaIVjSiDiKStSfG+DF3G47G5Tc/butFvR6fqyC
         wA/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+5h3vX/uenadcWCVCAzeCC1leutd8xV6aDGFHYcrbP8=;
        b=l+Ppl3wZdtwmI9Lqm6Kdit4VNEV1xPsdMWNarSF3Jey1veOcDsvlaJSpHCnW+1SiPb
         WJspvugD+KgDggEBogsbppbhpXRVeeSgtV+fp0y0y2OKCTRe00GF3xjSlKlumPJFZ/SY
         StTZho12JBx5K8YGHwZrkCvyWXmPWJ+4o82PN9J0Bl2Ga+kgZisylA2uHDm2yUIoOHkk
         J97mp8+CBVt7w3+3AFM/wkOhf22QsleHDK4q+DRVzbCiXjl4bG0y+NPHPAMh0hl0Rr8x
         T5960dP//6brgpp8HhZc6+IMZ0VBilIIUEvNaYL6ngha9FTt7ogo4entY8AuLdsdjiuw
         6wOw==
X-Gm-Message-State: AOAM530wuyjgYH2ZRCD+G3KtxeIVa4jSMvkueBNxP4OvMHjK6g2fmEiX
        fKiC1jPsxZmh4JGhlzj61R/2vw==
X-Google-Smtp-Source: ABdhPJyX2CwyLBgyClZHhyBlXlxYcUFsikuc2zhC2hSr8DVclwHnul/O2pLze3//tnbzrH7gfwwrIA==
X-Received: by 2002:aa7:d8d2:0:b0:425:e22b:35c0 with SMTP id k18-20020aa7d8d2000000b00425e22b35c0mr8431393eds.181.1651403932098;
        Sun, 01 May 2022 04:18:52 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id mm29-20020a170906cc5d00b006f3ef214dcesm2508630ejb.52.2022.05.01.04.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 04:18:51 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 6/6] tsnep: Add free running cycle counter support
Date:   Sun,  1 May 2022 13:18:36 +0200
Message-Id: <20220501111836.10910-7-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220501111836.10910-1-gerhard@engleder-embedded.com>
References: <20220501111836.10910-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TSN endpoint Ethernet MAC supports a free running counter
additionally to its clock. This free running counter can be read and
hardware timestamps are supported. As the name implies, this counter
cannot be set and its frequency cannot be adjusted.

Add free running cycle counter support based on this free running
counter to physical clock. This also requires hardware time stamps
based on that free running counter.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_hw.h   |  9 ++++--
 drivers/net/ethernet/engleder/tsnep_main.c | 33 ++++++++++++++++++----
 drivers/net/ethernet/engleder/tsnep_ptp.c  | 28 ++++++++++++++++++
 3 files changed, 63 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_hw.h b/drivers/net/ethernet/engleder/tsnep_hw.h
index 71cc8577d640..916ceac3ada2 100644
--- a/drivers/net/ethernet/engleder/tsnep_hw.h
+++ b/drivers/net/ethernet/engleder/tsnep_hw.h
@@ -43,6 +43,10 @@
 #define ECM_RESET_CHANNEL 0x00000100
 #define ECM_RESET_TXRX 0x00010000
 
+/* counter */
+#define ECM_COUNTER_LOW 0x0028
+#define ECM_COUNTER_HIGH 0x002C
+
 /* control and status */
 #define ECM_STATUS 0x0080
 #define ECM_LINK_MODE_OFF 0x01000000
@@ -190,7 +194,8 @@ struct tsnep_tx_desc {
 /* tsnep TX descriptor writeback */
 struct tsnep_tx_desc_wb {
 	__le32 properties;
-	__le32 reserved1[3];
+	__le32 reserved1;
+	__le64 counter;
 	__le64 timestamp;
 	__le32 dma_delay;
 	__le32 reserved2;
@@ -221,7 +226,7 @@ struct tsnep_rx_desc_wb {
 
 /* tsnep RX inline meta */
 struct tsnep_rx_inline {
-	__le64 reserved;
+	__le64 counter;
 	__le64 timestamp;
 };
 
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 49c93aa38862..cb069a0af7b9 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -470,8 +470,15 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 		    (__le32_to_cpu(entry->desc_wb->properties) &
 		     TSNEP_DESC_EXTENDED_WRITEBACK_FLAG)) {
 			struct skb_shared_hwtstamps hwtstamps;
-			u64 timestamp =
-				__le64_to_cpu(entry->desc_wb->timestamp);
+			u64 timestamp;
+
+			if (skb_shinfo(entry->skb)->tx_flags &
+			    SKBTX_HW_TSTAMP_USE_CYCLES)
+				timestamp =
+					__le64_to_cpu(entry->desc_wb->counter);
+			else
+				timestamp =
+					__le64_to_cpu(entry->desc_wb->timestamp);
 
 			memset(&hwtstamps, 0, sizeof(hwtstamps));
 			hwtstamps.hwtstamp = ns_to_ktime(timestamp);
@@ -704,11 +711,11 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 					skb_hwtstamps(skb);
 				struct tsnep_rx_inline *rx_inline =
 					(struct tsnep_rx_inline *)skb->data;
-				u64 timestamp =
-					__le64_to_cpu(rx_inline->timestamp);
 
+				skb_shinfo(skb)->tx_flags |=
+					SKBTX_HW_TSTAMP_NETDEV;
 				memset(hwtstamps, 0, sizeof(*hwtstamps));
-				hwtstamps->hwtstamp = ns_to_ktime(timestamp);
+				hwtstamps->netdev_data = rx_inline;
 			}
 			skb_pull(skb, TSNEP_RX_INLINE_METADATA_SIZE);
 			skb->protocol = eth_type_trans(skb,
@@ -1010,6 +1017,21 @@ static int tsnep_netdev_set_mac_address(struct net_device *netdev, void *addr)
 	return 0;
 }
 
+static ktime_t tsnep_netdev_get_tstamp(struct net_device *netdev,
+				       const struct skb_shared_hwtstamps *hwtstamps,
+				       bool cycles)
+{
+	struct tsnep_rx_inline *rx_inline = hwtstamps->netdev_data;
+	u64 timestamp;
+
+	if (cycles)
+		timestamp = __le64_to_cpu(rx_inline->counter);
+	else
+		timestamp = __le64_to_cpu(rx_inline->timestamp);
+
+	return ns_to_ktime(timestamp);
+}
+
 static const struct net_device_ops tsnep_netdev_ops = {
 	.ndo_open = tsnep_netdev_open,
 	.ndo_stop = tsnep_netdev_close,
@@ -1019,6 +1041,7 @@ static const struct net_device_ops tsnep_netdev_ops = {
 
 	.ndo_get_stats64 = tsnep_netdev_get_stats64,
 	.ndo_set_mac_address = tsnep_netdev_set_mac_address,
+	.ndo_get_tstamp = tsnep_netdev_get_tstamp,
 	.ndo_setup_tc = tsnep_tc_setup,
 };
 
diff --git a/drivers/net/ethernet/engleder/tsnep_ptp.c b/drivers/net/ethernet/engleder/tsnep_ptp.c
index eaad453d487e..54fbf0126815 100644
--- a/drivers/net/ethernet/engleder/tsnep_ptp.c
+++ b/drivers/net/ethernet/engleder/tsnep_ptp.c
@@ -175,6 +175,33 @@ static int tsnep_ptp_settime64(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static int tsnep_ptp_getcyclesx64(struct ptp_clock_info *ptp,
+				  struct timespec64 *ts,
+				  struct ptp_system_timestamp *sts)
+{
+	struct tsnep_adapter *adapter = container_of(ptp, struct tsnep_adapter,
+						     ptp_clock_info);
+	u32 high_before;
+	u32 low;
+	u32 high;
+	u64 counter;
+
+	/* read high dword twice to detect overrun */
+	high = ioread32(adapter->addr + ECM_COUNTER_HIGH);
+	do {
+		ptp_read_system_prets(sts);
+		low = ioread32(adapter->addr + ECM_COUNTER_LOW);
+		ptp_read_system_postts(sts);
+		high_before = high;
+		high = ioread32(adapter->addr + ECM_COUNTER_HIGH);
+	} while (high != high_before);
+	counter = (((u64)high) << 32) | ((u64)low);
+
+	*ts = ns_to_timespec64(counter);
+
+	return 0;
+}
+
 int tsnep_ptp_init(struct tsnep_adapter *adapter)
 {
 	int retval = 0;
@@ -192,6 +219,7 @@ int tsnep_ptp_init(struct tsnep_adapter *adapter)
 	adapter->ptp_clock_info.adjtime = tsnep_ptp_adjtime;
 	adapter->ptp_clock_info.gettimex64 = tsnep_ptp_gettimex64;
 	adapter->ptp_clock_info.settime64 = tsnep_ptp_settime64;
+	adapter->ptp_clock_info.getcyclesx64 = tsnep_ptp_getcyclesx64;
 
 	spin_lock_init(&adapter->ptp_lock);
 
-- 
2.20.1

