Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD6D01028D3
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 17:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfKSQCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 11:02:54 -0500
Received: from mail-vk1-f202.google.com ([209.85.221.202]:38400 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbfKSQCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 11:02:53 -0500
Received: by mail-vk1-f202.google.com with SMTP id s17so10009037vkb.5
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 08:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=eYHCshOL4Ta7/kAHI9D4sL+6xf6whnvt+kf8BS/U26M=;
        b=n1wYswlzZmgIS2fyBjO1hZx2GQvP5UwStG1Qxwq0CVNJOE9rynDL+2TllNeWYu5ZVY
         4P4wuTDAkMOel/GIhfU0la1y+oPLMIUGuoCgNlyn0X1Eb70UWwQ8eSImcOWB3KGqfDK3
         pC4xQu6aoBn0XXHI92WO/5Wu5blmE8vcrEOIgTqGj/YZDJLByAgH7UK/QPH+xGg46CAW
         /vpV594QLj/DoufDikAA6vaxvnCWI5Pk0lmce8iLN8VaMRtz7tQAs4q5ZOr5rtI7jkui
         K8tk8FhpUdeUMWs1jtIzUv5SOBeqF6lglUcDLHFuHga/lgY+1j89hPBBIBSJs1iYX8sF
         tByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=eYHCshOL4Ta7/kAHI9D4sL+6xf6whnvt+kf8BS/U26M=;
        b=jcykJsc72Q8fR+ArJrPyJAUy8jRB8d1ue7QeCQLvYoRALWLdWTa0pmiAQ91yTPzO+I
         jBOmYLMPCzHRxkbW/pMsBEyziH7MQAS5oOCWBf+aFMhKNGQTPd95baS1bcykSM4eo6m9
         6RwAbEHjPYnf/rZ0ItwCyi14zOsLWx0FMQRB8o6rRKTCw7sLpVjfGt/3SnFQw+5n/bHg
         qBDpj4oKFQHcAppCOugCMieGOYzNUEuxVnJu/8E70ZVpM2Xi3DPUhLTtc1lT+TpQGDFW
         2m8pP2QRydse7VQHUrOEAyhgWY8YSinO+3lJRHHbLYyi5mROKcRhSw++J3bOsJRpYu5z
         nn5g==
X-Gm-Message-State: APjAAAWtjzRmnAD3tsdGPk2hju3Wfhj28o0n9WgGrxKIWVdjs2u7bRA0
        P5XxDlQUE1PAV6HHTUXpbMb6zN/cYSO5WluWKCsHjtCFCnu/Chg1iQn4n+1c18iL70yR+yQpQ73
        cWENcElR5itesZ4XlcE6NP/vQxzetLFqpSBPFvX4syF0w/ioMobJ9j2EzGzt148/pqlscSg==
X-Google-Smtp-Source: APXvYqyzpPP0SH4ZozicPnv6RfyqLyERiu42j1B/cUXDJr7h07wxB82lRTGCkbFqha+L1I0r809IVCkRpctJ9k4=
X-Received: by 2002:a1f:2a82:: with SMTP id q124mr20465392vkq.8.1574179371151;
 Tue, 19 Nov 2019 08:02:51 -0800 (PST)
Date:   Tue, 19 Nov 2019 08:02:47 -0800
Message-Id: <20191119160247.29158-1-adisuresh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net v4] gve: fix dma sync bug where not all pages synced
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

Fixes: 9cfeeb576d49 ("gve: Fixes DMA synchronization")
Signed-off-by: Adi Suresh <adisuresh@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 Addressed in v4:
 - Used correct 12 digits of hash of commit in Fixes tag
   
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

