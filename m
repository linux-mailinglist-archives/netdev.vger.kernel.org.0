Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8381221280F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 17:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbgGBPhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 11:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728680AbgGBPhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 11:37:45 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074A8C08C5C1;
        Thu,  2 Jul 2020 08:37:45 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id j4so11460223plk.3;
        Thu, 02 Jul 2020 08:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MKByQ46pgwwug2FS04MHEvNcYmmcyxdFTwu8Aog6KoM=;
        b=aNzCTHKM3gapvmJb3IY3wPNpOzs9PdYRDtlxS/xcyfeKsrofUW1jZDo7JfB/9HAOJy
         wiKc9yESsjKqf4kBJokxCrervIpX0SutNdEbxm7c6M5hQkG2Qk3gwDIv6BgKtwyBtrm4
         QxAGMo3or3dqGcPp75KFJ1WsUpBuxXdVt3fYM6LPin8lekhSU63klxnjx4a5kVLu7h5p
         mYm91S77piPyqj40MkXuFwdaTzyCnR1qw2WpmwIOKPFREdjDrlaf1iwKw52JIkfLo3DM
         W3NMFvhSOfUkshKp+qPV4OEJ2FCHVDvwzCSdBMe2ULg76+8wrdmuQtckt8vA9O2djOPb
         4VZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MKByQ46pgwwug2FS04MHEvNcYmmcyxdFTwu8Aog6KoM=;
        b=CdPHPAjZFMqJ9tQqpSwQUCkQMwVTkfxWH2jQeGq4QCx3sl5t4SYN/0wuwtwFox01kv
         3Ym6A3jh14y/FrfIpEm+qspc9T2tPKVx0m668GxAE4i2+/2ms/K3GlQSApSOYqCV2SmY
         lMEzDZvz4GzYDjABgvNrjph1YHse16R3H5/1+KtYt+tfSCdPTQwXK0m7CFXzx1QyIMaR
         0NOwIguVsyid2L87VusmkWfXJPkMw6uY6njjV5xag1LuDBZrVOo2ASgRHHlRdmb5T1Vo
         rDy9lbVD7YAglr1NnbPOx+TWUkhqHfp7bTIcIsF1ZaXZfO+SIJYVO0RpQa6nWd+dPn7r
         kX9Q==
X-Gm-Message-State: AOAM533zltqJ5BGK0LmKfgYhOTBN3r7gjrjZtG3qBe3qL8XkFIlgj70I
        YAFF7dVLepz7BNeZGO+GzqQ=
X-Google-Smtp-Source: ABdhPJxx6EcFOxz8w9IU/G9WY1sqs/dZRjNtcHIjOAhcwZTBpooIkvD/F3ANC6BbCsypQgleYwIcCg==
X-Received: by 2002:a17:90a:ff92:: with SMTP id hf18mr26992214pjb.10.1593704264564;
        Thu, 02 Jul 2020 08:37:44 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (jfdmzpr04-ext.jf.intel.com. [134.134.137.73])
        by smtp.gmail.com with ESMTPSA id r6sm552651pgn.65.2020.07.02.08.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 08:37:43 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net-next 1/4] i40e, xsk: remove HW descriptor prefetch in AF_XDP path
Date:   Thu,  2 Jul 2020 17:37:27 +0200
Message-Id: <20200702153730.575738-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702153730.575738-1-bjorn.topel@gmail.com>
References: <20200702153730.575738-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The software prefetching of HW descriptors has a negative impact on
the performance. Therefore, it is now removed.

Performance for the rx_drop benchmark increased with 2%.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        | 13 +++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_txrx_common.h | 13 -------------
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         | 12 ++++++++++++
 3 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 3e5c566ceb01..e1a76fc05b8d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2299,6 +2299,19 @@ void i40e_finalize_xdp_rx(struct i40e_ring *rx_ring, unsigned int xdp_res)
 	}
 }
 
+/**
+ * i40e_inc_ntc: Advance the next_to_clean index
+ * @rx_ring: Rx ring
+ **/
+static void i40e_inc_ntc(struct i40e_ring *rx_ring)
+{
+	u32 ntc = rx_ring->next_to_clean + 1;
+
+	ntc = (ntc < rx_ring->count) ? ntc : 0;
+	rx_ring->next_to_clean = ntc;
+	prefetch(I40E_RX_DESC(rx_ring, ntc));
+}
+
 /**
  * i40e_clean_rx_irq - Clean completed descriptors from Rx ring - bounce buf
  * @rx_ring: rx descriptor ring to transact packets on
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h b/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
index 667c4dc4b39f..1397dd3c1c57 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx_common.h
@@ -99,19 +99,6 @@ static inline bool i40e_rx_is_programming_status(u64 qword1)
 	return qword1 & I40E_RXD_QW1_LENGTH_SPH_MASK;
 }
 
-/**
- * i40e_inc_ntc: Advance the next_to_clean index
- * @rx_ring: Rx ring
- **/
-static inline void i40e_inc_ntc(struct i40e_ring *rx_ring)
-{
-	u32 ntc = rx_ring->next_to_clean + 1;
-
-	ntc = (ntc < rx_ring->count) ? ntc : 0;
-	rx_ring->next_to_clean = ntc;
-	prefetch(I40E_RX_DESC(rx_ring, ntc));
-}
-
 void i40e_xsk_clean_rx_ring(struct i40e_ring *rx_ring);
 void i40e_xsk_clean_tx_ring(struct i40e_ring *tx_ring);
 bool i40e_xsk_any_rx_ring_enabled(struct i40e_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 8ce57b507a21..1f2dd591dbf1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -253,6 +253,18 @@ static struct sk_buff *i40e_construct_skb_zc(struct i40e_ring *rx_ring,
 	return skb;
 }
 
+/**
+ * i40e_inc_ntc: Advance the next_to_clean index
+ * @rx_ring: Rx ring
+ **/
+static void i40e_inc_ntc(struct i40e_ring *rx_ring)
+{
+	u32 ntc = rx_ring->next_to_clean + 1;
+
+	ntc = (ntc < rx_ring->count) ? ntc : 0;
+	rx_ring->next_to_clean = ntc;
+}
+
 /**
  * i40e_clean_rx_irq_zc - Consumes Rx packets from the hardware ring
  * @rx_ring: Rx ring
-- 
2.25.1

