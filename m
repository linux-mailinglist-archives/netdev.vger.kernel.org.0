Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCC57100ED3
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 23:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfKRWgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 17:36:40 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:39303 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfKRWgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 17:36:39 -0500
Received: by mail-pl1-f201.google.com with SMTP id x5so11888838pln.6
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 14:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=D1LOEcQvrJiDII0NI8BEGzsSYR8a83fu9Rt/2hCSvds=;
        b=Wiqmv3JBuYBY9QcvA05fwY2wNApdnOSlqjbgTxwVT20+JJrTSLlzbCXLy0X/mDAd0Z
         dNQotL/T4q28DQ/ZSQROfkI50Rfcux2Kv/oNmnN/27c+3WpBooyz3Lv1L/qYx2M9gNwS
         ZnhdEoPWKaIC14A1/jpYmRdft4W1G0N/p5rv6xxQWzh4gc+AOHUBb7YOmUbILjf4ZyNk
         BtvzXq3UIg876tvE8hndQAUvER4s43QH00bS/4bvpsUl6bFqwyoVX6P5ITTO10dFhCkW
         b3DTJ4ReBUmD++0Mrvki6WSOI+ddzz8H+YC4siORgNAjB5xLHoRl8b1vRo3V2S4Dr1CE
         RNHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=D1LOEcQvrJiDII0NI8BEGzsSYR8a83fu9Rt/2hCSvds=;
        b=VmNVplo7naFeu3RL1sRIqdtn7tJ790kR2Bs/DKazAtC1bWfuodTrfRH/ZZ3vLTU6Y1
         8A+fk80mFepzsEl8XQvLAFitjJJFY15A6pIT4xZaoIDy1irvfGo5RTih5dZ0AqPoz09z
         ARqwzX7xNv/sbB+tXalETU/jYCLx6SrX2N//HNpOpfyDy29spr3pwmeIOl3svCycmvl6
         BGR4VRhPpZdjMfm1xlXpjx84jbEJJL5WO+Odyvlw8c4kp7MwLEg6EQM/Fo8fHBXm2GRl
         uXDZqZDSKDoDFbsNu3g+k3sdqUxD2YT6Utwq2Tp0Y6/ZHqVlzKmyuMw/yN57IXuCjgst
         CX7Q==
X-Gm-Message-State: APjAAAX2XMJuxLOufKXFkKsaHTfdrC8SnvtOr/g9IrM/EHDt3MWQ305p
        adet4mF9w/mo2ToT5uiy/kr0N6ZsXQslZ+1zuTuBFJ2uHmKQF3ZYf0ySwpZLr3J/3jO7iwTjAgK
        oCf7M8qQhzC+DkctT2vcfgWkUm2ZlHidjuIdzcJDwjv7g07YtPwHdud74TkYwtj1BMplTUQ==
X-Google-Smtp-Source: APXvYqzeG9W4kdvMt73yBG3TfLtpfJtbz8mJvc5dPACEbtnufZojpHX62VqqYMHpD0JfLPNedPrJk9H/gaD2rcE=
X-Received: by 2002:a63:b44e:: with SMTP id n14mr1860402pgu.154.1574116598684;
 Mon, 18 Nov 2019 14:36:38 -0800 (PST)
Date:   Mon, 18 Nov 2019 14:36:30 -0800
Message-Id: <20191118223630.7468-1-adisuresh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net] gve: fix dma sync bug where not all pages synced
From:   Adi Suresh <adisuresh@google.com>
To:     netdev@vger.kernel.org
Cc:     Adi Suresh <adisuresh@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit "Fixes DMA synchronization" had a bug where the
last page in the memory range could not be synced. This change fixes
the behavior so that all the required pages are synced.

Signed-off-by: Adi Suresh <adisuresh@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 drivers/net/ethernet/google/gve/gve_tx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 0a9a7ee2a866..89271380bbfd 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -393,12 +393,12 @@ static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
 static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
 				    u64 iov_offset, u64 iov_len)
 {
-	dma_addr_t dma;
-	u64 addr;
+	u64 last_page = (iov_offset + iov_len - 1) / PAGE_SIZE;
+	u64 first_page = iov_offset / PAGE_SIZE;
+	u64 page;
 
-	for (addr = iov_offset; addr < iov_offset + iov_len;
-	     addr += PAGE_SIZE) {
-		dma = page_buses[addr / PAGE_SIZE];
+	for (page = first_page; page <= last_page; page++) {
+		dma_addr_t dma = page_buses[page];
 		dma_sync_single_for_device(dev, dma, PAGE_SIZE, DMA_TO_DEVICE);
 	}
 }
-- 
2.24.0.432.g9d3f5f5b63-goog

