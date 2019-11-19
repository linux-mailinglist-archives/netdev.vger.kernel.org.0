Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3885910116C
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 03:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKSCrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 21:47:13 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:37905 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfKSCrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 21:47:13 -0500
Received: by mail-pl1-f202.google.com with SMTP id i5so12281310plt.5
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 18:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ANTVSVd0jTjvOw3HPzUWbcDRxx356D+ZKBeUnyYDSsI=;
        b=SGelGUVA5vJJwWJur01bkDh70p/a77AcaQwf0m3gSrAYbWhmSMDcrQY2/keTVZ+RVz
         QmcXUElJ8EIg64UUAx5GVAbvKXYJ1I0OxIHfMJsYLEUK6T2ybrw/lu34FjSJTiKQaIPn
         qcduEFhRsJrjMP6KUwXqeOYFYE7otn5h/ycY0h4AEjMkOINJ4DHQ3JO1XrK9IGgFENkP
         4yNJ8qN0iaqAiNA7nVcyrgYeRy9wGf2oj6s7mGaTsHa5a0WPtT3eNLJGhn7HLv77ShtZ
         nkUzQIUz0twT3aAIkFX5mCrTfUF+2rl9PGRaJUjEM7sl1YBEfsG13CL4taeu+mI2UUcL
         AyLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ANTVSVd0jTjvOw3HPzUWbcDRxx356D+ZKBeUnyYDSsI=;
        b=eulIQpBqv3n6OEMa+Z0N6GTKmdOHV3bLx7ZGC9Zv2xQz0p2+ChvEPbXsk/zkgY5qTy
         gSKkG9EVW2LtIAulMKCWQe9xY1z+5IvjnjawePGfW81EqX1+arRvzSNxCuDdfvyIVJ0W
         fHiY4A4/3LQI8Hu3w+FfkKg/qF28ElPGuAJk6azv7aS27BgZHPMDq+OQV+dBjGJD9Lo5
         IYRnasN7LCSMN4qxjVxgV3SIz5Q+tT+ztSj9Zq0F8Nr3Iq5eZJfteAWLm5NB09D0r4XM
         cQ6MaZiX7tVCCBh8C0QqGdZO2nRkAw+BvdYkIaryyfjCWMOr0wnAMdnPWi2Vuvvzk51y
         srjQ==
X-Gm-Message-State: APjAAAXob1QcMy9dwJ8YZq8tUL8HEn790B2Re2yAQdrWjJuGQv4CLSEZ
        XPdjT1lOg8WgrdYl9qyQMOoT/PiebzAR0ANabvvnGMXwW8Kp0yrPiOreEq3IhNoyqN3gO1s7ulH
        7wLp7+M4hbki+ZgQE8D9uuxnzq0/6fAZMlhLlzmqOeEjp9v3Y/XM4tRAzilkH3nbPTazTHQ==
X-Google-Smtp-Source: APXvYqwjseSY1tKlW1LR+N5gtVunOBOKM47HaYbQr8l8lWpHIWHJ4TUrVS+UqGQmCkB8f0msGSZwPhN+/RX9B+s=
X-Received: by 2002:a63:2151:: with SMTP id s17mr2925351pgm.46.1574131632542;
 Mon, 18 Nov 2019 18:47:12 -0800 (PST)
Date:   Mon, 18 Nov 2019 18:47:06 -0800
Message-Id: <20191119024706.161479-1-adisuresh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net v3] gve: fix dma sync bug where not all pages synced
From:   Adi Suresh <adisuresh@google.com>
To:     netdev@vger.kernel.org
Cc:     Adi Suresh <adisuresh@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit had a bug where the last page in the memory range
could not be synced. This change fixes the behavior so that all the
required pages are synced.

Fixes: 4a55e8417c5d ("gve: Fixes DMA synchronization")
Signed-off-by: Adi Suresh <adisuresh@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 Addressed in v3:
 - Used 12 digits of commit hash in Fixes tag

 drivers/net/ethernet/google/gve/gve_tx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 0a9a7ee2a866..f4889431f9b7 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -393,12 +393,13 @@ static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
 static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
 				    u64 iov_offset, u64 iov_len)
 {
+	u64 last_page = (iov_offset + iov_len - 1) / PAGE_SIZE;
+	u64 first_page = iov_offset / PAGE_SIZE;
 	dma_addr_t dma;
-	u64 addr;
+	u64 page;
 
-	for (addr = iov_offset; addr < iov_offset + iov_len;
-	     addr += PAGE_SIZE) {
-		dma = page_buses[addr / PAGE_SIZE];
+	for (page = first_page; page <= last_page; page++) {
+		dma = page_buses[page];
 		dma_sync_single_for_device(dev, dma, PAGE_SIZE, DMA_TO_DEVICE);
 	}
 }
-- 
2.24.0.432.g9d3f5f5b63-goog

