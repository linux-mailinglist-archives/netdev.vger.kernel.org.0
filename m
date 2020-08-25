Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBA12517F1
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 13:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730043AbgHYLlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 07:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbgHYLga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 07:36:30 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C47C061755;
        Tue, 25 Aug 2020 04:36:16 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u20so7142236pfn.0;
        Tue, 25 Aug 2020 04:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MKByQ46pgwwug2FS04MHEvNcYmmcyxdFTwu8Aog6KoM=;
        b=KxPN3LdURiJQJJHI+7W95jH6ria7e92JnvDmYZ7sJfxiC4VpG4107WK+DCGB8aH2Yb
         W0rzC1IL3n7ra0sbNPycNgX0fPf3XmQZhGterI4gFWkEvPn0txoDpmCeuWo54CogFORG
         kwGLMlHDdpS2vJqtiCmIHqP8RqkCh1NB/Q7O4jxcpIzopQAw5x+Ohdjdnq1BuAajGHcg
         3ao4QtB8ptWDYRQKqTao2pULQiiig48U0PaQ4s0jm3LcE4g8YYwRsaUGHBXMEtydSUTc
         6AGWG9jx08aI2ffMNyDlVi0TjDz4/Hzx+VsP9hGI4m6pzfdN2My74O548l4jiuAMoQxt
         6szA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MKByQ46pgwwug2FS04MHEvNcYmmcyxdFTwu8Aog6KoM=;
        b=onmViFSTUAF2/M5vWw+xBMLiXvA4jGuajCAhEYCt/DX7e+6SwsB3F8AB/lg1yS/S58
         j+8Kmil6gjIMfBKgIREJNItWf/gTpp8ArmZurbXsOPxuZrjjQAKSlrOosTJvk+0ZEtLy
         wwel3nccUA6mJ7u9795/sXsLu8YowpuksexL9UImgheb/s5LfxH3niwoWBoeSHUX9vGm
         qxivXPsxgPRwnbNQRVWtHYHSgQugiNf0wrmS9JnhdUK6plXVYTr3b6V8fn9OsQU1UjBM
         9r4zHui/N8YYvOonQaHIWrqI6wEVIZI9ibPFp/F8J31p3Es+PLJot7dJZ7l8WieKTX+1
         9jWQ==
X-Gm-Message-State: AOAM530QXGrtRymxZkBPEiYPfG+x/GOX0hQ7Bvs+ApHrWCXo48GhSbka
        E7/HqpvlcteIEd3ycfO+Jz0=
X-Google-Smtp-Source: ABdhPJy089I37yUmgoghRv6ll7QM6Tz7TRYt0VT7Dn/UuGtC67TNorNbHf/g6lUG6Bo5pMugRHcQkQ==
X-Received: by 2002:a17:902:780f:: with SMTP id p15mr7737669pll.56.1598355375887;
        Tue, 25 Aug 2020 04:36:15 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id e7sm12699937pgn.64.2020.08.25.04.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 04:36:15 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next v2 1/3] i40e, xsk: remove HW descriptor prefetch in AF_XDP path
Date:   Tue, 25 Aug 2020 13:35:54 +0200
Message-Id: <20200825113556.18342-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200825113556.18342-1-bjorn.topel@gmail.com>
References: <20200825113556.18342-1-bjorn.topel@gmail.com>
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

