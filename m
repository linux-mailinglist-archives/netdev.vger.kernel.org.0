Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2289F1FB
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 20:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbfH0SB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 14:01:57 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43931 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbfH0SB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 14:01:56 -0400
Received: by mail-pl1-f193.google.com with SMTP id 4so12136230pld.10
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 11:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cJMJeKPgC75iwMFiSSf1fcZFhifdUxyd5AN7WKIvkYs=;
        b=T9Xq5rHkhyBI6gMPpZIzyiDG0tST+gj521ti53yJvFDm6irjIQLri9OZDB7lA3ePpi
         5fVNLy7H/PlVRPkeDWnrrlSzWNQANWC+rXtrakklFKdnrLkhY/IGR2SlcDqohPU2Ozmp
         kW9MBArp492gI/AMnXFD/bk3PdkNIHGMaYUZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cJMJeKPgC75iwMFiSSf1fcZFhifdUxyd5AN7WKIvkYs=;
        b=YJkQPqNTcOrAFZHF8GKd9Kl/8RlOS60CDYvuqZpf92dcb+OUeqF68mRBb1hrqwQz/r
         KoMx6T8q+xaQBeGqA+67wran5UEt46eC34F8hydOX/a2se8hc9tv+F4tWAq7SiH/LhXn
         3opfoexUDVsRx7XyGtJtH6+lQKGEIYlUh6DbVskTaRXpOPGnlaCrlm8zFLRJizH2qHtV
         d/swFhSUVm2l1uh72OehU0GmJsIxj2zb/s6dtAMtF8A6vgwamSDRnziHvl+pazGWcGUC
         Q7rbc+rH5Z/oe4radneWKVUR0Te5EiT9hE1qI7NwCOh/UCtIH/fRNziaHUmgR2WUfpws
         yAKw==
X-Gm-Message-State: APjAAAXLwQEAt5uBzfId8wkPVIwcO7j4i40P+QQvOI1UZ2kPglPcJMTI
        ly0QZ6XqSbHXEA/0YsfFnuudTw==
X-Google-Smtp-Source: APXvYqxEM9lKFuUO2yYl4zaZsWbB5GwqhM672VFmXKoR5gz3IHFjIP84QSlHk+wVc4plfxxxRMWflQ==
X-Received: by 2002:a17:902:e406:: with SMTP id ci6mr120643plb.207.1566928916123;
        Tue, 27 Aug 2019 11:01:56 -0700 (PDT)
Received: from pmalani2.mtv.corp.google.com ([2620:15c:202:201:172e:4646:c089:ce59])
        by smtp.gmail.com with ESMTPSA id y188sm16346534pfb.115.2019.08.27.11.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 11:01:55 -0700 (PDT)
From:   Prashant Malani <pmalani@chromium.org>
To:     hayeswang@realtek.com, davem@davemloft.net
Cc:     grundler@chromium.org, netdev@vger.kernel.org,
        nic_swsd@realtek.com, Prashant Malani <pmalani@chromium.org>
Subject: [PATCH] r8152: Add rx_buf_sz field to struct r8152
Date:   Tue, 27 Aug 2019 11:01:46 -0700
Message-Id: <20190827180146.253431-1-pmalani@chromium.org>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tp->rx_buf_sz is set according to the specific version of HW being used.

agg_buf_sz was originally added to support LSO (Large Send Offload) and
then seems to have been co-opted for LRO (Large Receive Offload). But RX
large buffer size can be larger than TX large buffer size with newer HW.
Using larger buffers can result in fewer "large RX packets" processed
by the rest of the networking stack to reduce RX CPU utilization.

This patch is copied from the r8152 driver (v2.12.0) published by
Realtek (www.realtek.com).

Signed-off-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/r8152.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 0cc03a9ff545..d221e59a5392 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -750,6 +750,7 @@ struct r8152 {
 	u32 tx_qlen;
 	u32 coalesce;
 	u16 ocp_base;
+	u32 rx_buf_sz;
 	u16 speed;
 	u8 *intr_buff;
 	u8 version;
@@ -1516,13 +1517,13 @@ static int alloc_all_mem(struct r8152 *tp)
 	skb_queue_head_init(&tp->rx_queue);
 
 	for (i = 0; i < RTL8152_MAX_RX; i++) {
-		buf = kmalloc_node(agg_buf_sz, GFP_KERNEL, node);
+		buf = kmalloc_node(tp->rx_buf_sz, GFP_KERNEL, node);
 		if (!buf)
 			goto err1;
 
 		if (buf != rx_agg_align(buf)) {
 			kfree(buf);
-			buf = kmalloc_node(agg_buf_sz + RX_ALIGN, GFP_KERNEL,
+			buf = kmalloc_node(tp->rx_buf_sz + RX_ALIGN, GFP_KERNEL,
 					   node);
 			if (!buf)
 				goto err1;
@@ -2113,7 +2114,7 @@ int r8152_submit_rx(struct r8152 *tp, struct rx_agg *agg, gfp_t mem_flags)
 		return 0;
 
 	usb_fill_bulk_urb(agg->urb, tp->udev, usb_rcvbulkpipe(tp->udev, 1),
-			  agg->head, agg_buf_sz,
+			  agg->head, tp->rx_buf_sz,
 			  (usb_complete_t)read_bulk_callback, agg);
 
 	ret = usb_submit_urb(agg->urb, mem_flags);
@@ -2447,7 +2448,7 @@ static void r8153_set_rx_early_timeout(struct r8152 *tp)
 
 static void r8153_set_rx_early_size(struct r8152 *tp)
 {
-	u32 ocp_data = agg_buf_sz - rx_reserved_size(tp->netdev->mtu);
+	u32 ocp_data = tp->rx_buf_sz - rx_reserved_size(tp->netdev->mtu);
 
 	switch (tp->version) {
 	case RTL_VER_03:
@@ -5115,6 +5116,7 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->in_nway		= rtl8152_in_nway;
 		ops->hw_phy_cfg		= r8152b_hw_phy_cfg;
 		ops->autosuspend_en	= rtl_runtime_suspend_enable;
+		tp->rx_buf_sz		= 16 * 1024;
 		break;
 
 	case RTL_VER_03:
@@ -5132,6 +5134,7 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8153_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153_runtime_enable;
+		tp->rx_buf_sz		= 32 * 1024;
 		break;
 
 	case RTL_VER_08:
@@ -5147,6 +5150,7 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8153b_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153b_runtime_enable;
+		tp->rx_buf_sz		= 32 * 1024;
 		break;
 
 	default:
-- 
2.23.0.187.g17f5b7556c-goog

