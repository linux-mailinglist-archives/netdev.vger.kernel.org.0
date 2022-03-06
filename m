Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AB24CEA1E
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 09:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiCFI6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 03:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiCFI6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 03:58:38 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921FA220E0
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 00:57:46 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id y2so11372808edc.2
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 00:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hxr58LzZb0xxkkoq+RaydR2euslE0TC19IlcbYrBZQY=;
        b=Pfh75midBf1EUr2TAsvYTlIJ+DYEdwl8BN5UPbCWSQOth9ajWfpD+86OfZndGAXcvz
         eAgCXhImV9xhOc2N0vW/6hGC93N7UmRi7o9k3yP4Xxi1Q0hMT2eQMBdmp3GN8HHuiEB6
         GWRrqDRLKe+G8IDuSRZrWQeRzUUgD7DAQuWrW4TZq7WJMiKzbuzwD6WqpL4MnP/02vsX
         0BTJrvGjL7XG5Bh+omAYgSnfEqPFMyTzzVQx0ts0koHsfYY90LCvSarM6mu/E2pjYxji
         btKejEQWgyixY/uB6CyiRSxnyd/IahpLWf3bFLAZbYnmS2PSqaJJSC2qwAC1oYq6lviV
         Zdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hxr58LzZb0xxkkoq+RaydR2euslE0TC19IlcbYrBZQY=;
        b=VDHnlUvCEfl/rPCmSCNFBs/cpEMx9XxtbI57bpOpCToYvyk/m+PYPh8Wz23qEDPEqF
         N9hdn8B1vA7OVLjynXQhkHbEhEntF8Q6l/LJQr0tv0MqY4j03ncS5yLsfmspID38xGNc
         qZ8NJ7vIT+D8dK7jSruIetUNUqD7AldFzgD+O1c6/B79368+F2fCjD60FEE3PlJrjET2
         XsP2ZDGDKmav0t1N3C0pKEUwE1IuHfaLFPWYLEeqJ0T8GdkJ11n+nxveio5Jn3psf5HH
         lODoGlmlQq+9dI4TdAqaFdhBjrgoQMoTAyt5uzsGYAKYaL2lU6tH2ictsbFdBUv3GbsJ
         t4rQ==
X-Gm-Message-State: AOAM5339sNfzYAeVFxijiIgklC6fV0I3rJa0JJY9iQmOOl2DIsdMchFD
        gq+JswvBFZdX/zUsSrlSiKW1wA==
X-Google-Smtp-Source: ABdhPJx4y9mO5/uw/w0zmTscsH8XTeYed+K5MptAi/ri9hbPRqKK+5Ei0ve0lsp6Vwl9KLvaDSBzWA==
X-Received: by 2002:a05:6402:8d5:b0:416:1b20:5090 with SMTP id d21-20020a05640208d500b004161b205090mr5728555edz.393.1646557065183;
        Sun, 06 Mar 2022 00:57:45 -0800 (PST)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id z24-20020a170906815800b006dab4bd985dsm2663423ejw.107.2022.03.06.00.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 00:57:44 -0800 (PST)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, yangbo.lu@nxp.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     mlichvar@redhat.com, vinicius.gomes@intel.com,
        netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [RFC PATCH net-next 6/6] tsnep: Add free running time support
Date:   Sun,  6 Mar 2022 09:56:58 +0100
Message-Id: <20220306085658.1943-7-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220306085658.1943-1-gerhard@engleder-embedded.com>
References: <20220306085658.1943-1-gerhard@engleder-embedded.com>
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
hardware time stamps are supported. As the name implies, this counter
cannot be set and its frequency cannot be adjusted.

Add free running time support based on free running counter to physical
clock. This also requires hardware time stamps based on that free
running time.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_hw.h   |  9 +++++--
 drivers/net/ethernet/engleder/tsnep_main.c |  6 +++++
 drivers/net/ethernet/engleder/tsnep_ptp.c  | 28 ++++++++++++++++++++++
 3 files changed, 41 insertions(+), 2 deletions(-)

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
index 904f3304727e..4aa3d04da2e4 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -472,9 +472,12 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 			struct skb_shared_hwtstamps hwtstamps;
 			u64 timestamp =
 				__le64_to_cpu(entry->desc_wb->timestamp);
+			u64 counter =
+				__le64_to_cpu(entry->desc_wb->counter);
 
 			memset(&hwtstamps, 0, sizeof(hwtstamps));
 			hwtstamps.hwtstamp = ns_to_ktime(timestamp);
+			hwtstamps.hwfreeruntstamp = ns_to_ktime(counter);
 
 			skb_tstamp_tx(entry->skb, &hwtstamps);
 		}
@@ -706,9 +709,12 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
 					(struct tsnep_rx_inline *)skb->data;
 				u64 timestamp =
 					__le64_to_cpu(rx_inline->timestamp);
+				u64 counter =
+					__le64_to_cpu(rx_inline->counter);
 
 				memset(hwtstamps, 0, sizeof(*hwtstamps));
 				hwtstamps->hwtstamp = ns_to_ktime(timestamp);
+				hwtstamps->hwfreeruntstamp = ns_to_ktime(counter);
 			}
 			skb_pull(skb, TSNEP_RX_INLINE_METADATA_SIZE);
 			skb->protocol = eth_type_trans(skb,
diff --git a/drivers/net/ethernet/engleder/tsnep_ptp.c b/drivers/net/ethernet/engleder/tsnep_ptp.c
index eaad453d487e..5f0b807fd86c 100644
--- a/drivers/net/ethernet/engleder/tsnep_ptp.c
+++ b/drivers/net/ethernet/engleder/tsnep_ptp.c
@@ -175,6 +175,33 @@ static int tsnep_ptp_settime64(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+static int tsnep_ptp_getfreeruntimex64(struct ptp_clock_info *ptp,
+				       struct timespec64 *ts,
+				       struct ptp_system_timestamp *sts)
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
+	adapter->ptp_clock_info.getfreeruntimex64 = tsnep_ptp_getfreeruntimex64;
 
 	spin_lock_init(&adapter->ptp_lock);
 
-- 
2.20.1

