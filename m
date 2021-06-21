Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2898B3AEA6F
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhFUNxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhFUNxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:53:24 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08700C061574;
        Mon, 21 Jun 2021 06:51:08 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c15so8513297pls.13;
        Mon, 21 Jun 2021 06:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TREWgCZWamyM+cAvFe+be+iyBQ2mM4FCIj8jAxnCWs0=;
        b=fEpcFCM2VjpxKDX6qBcqcW976jrBvNzdDnqeE7kkmCA54xvYA4tjne6uHuRPjecEbr
         JB9MtUDnrHIPae2hAflr8rrpbzIZwu5s8pvuWPRaVeAHzJDk1LtGQsAg6m0Uvv6waFVi
         IYqPOVWlKZlVSDTIDk0gj8bSXfzdIYB/avCm8m4wpaEn2vD/q9t+UWhFeXfrZF/ggsl8
         nDAMEXJNPyGYM0f7+U32sdGdLo69dfwECtTNfintPs6QIW1gs3v48Po+50q7BbBtz8u9
         5OrzIka2R+hFKvGmDHqgS+eKEfvhaXhb68CxDcOOK8JMq0xrwtATR5CHGmp6K1NMTDvq
         SKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TREWgCZWamyM+cAvFe+be+iyBQ2mM4FCIj8jAxnCWs0=;
        b=EsNfity4yVD3MmeySEzAm/BbrAJ9dyH2dMLmcJ0C1QnrwwnDodEg3/UdmF2+GQ4E9h
         1Mv8N2slflLXU1ijYweDIsd4oT5tQ2pH93J1cREZfW0zLgE8X758DpIV/Z/Kq4njTA+B
         Vo6BJ2yqN7oydxLlnF2mrGg6CBZuo3K8CkCY9Le3mOc2VTJZqe/vc/9+nIWyWap9yF07
         Bmnxr+NuDVh9DwgWwT7RdX9Qpca9YBM1QbvU7S9EPxotRQgBMRERxal9w/BEAHbK6GgF
         qDy1UrGD1k5Pb6+AH3od1QYOvuu4VCwYXGWYK+bCcNbv1OPzfc7+8HGYEn9CqyfvaZyx
         vWLg==
X-Gm-Message-State: AOAM530OF5Ab1WOK22bRAnZhaCKJFfyyT9aAoY5L0QEHRXaXT2lOrFe8
        hM7sxbw1aGPZR2HWMZFb6jw=
X-Google-Smtp-Source: ABdhPJzZjS77z8PraDiF4aOCsoGOuHLIIF3lM0XWqXPAxHUs+FwCRZ91wEzksH0o6KrPa+OMPFwJQw==
X-Received: by 2002:a17:902:d4cb:b029:124:3333:9ded with SMTP id o11-20020a170902d4cbb029012433339dedmr6883227plg.22.1624283467638;
        Mon, 21 Jun 2021 06:51:07 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k25sm15256121pfa.213.2021.06.21.06.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:51:07 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 12/19] staging: qlge: rewrite do while loops as for loops in qlge_start_rx_ring
Date:   Mon, 21 Jun 2021 21:48:55 +0800
Message-Id: <20210621134902.83587-13-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since MAX_DB_PAGES_PER_BQ > 0, the for loop is equivalent to do while
loop.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 7aee9e904097..c5e161595b1f 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3029,12 +3029,11 @@ static int qlge_start_cq(struct qlge_adapter *qdev, struct qlge_cq *cq)
 		tmp = (u64)rx_ring->lbq.base_dma;
 		base_indirect_ptr = rx_ring->lbq.base_indirect;
 		page_entries = 0;
-		do {
+		for (page_entries = 0; page_entries < MAX_DB_PAGES_PER_BQ; page_entries++) {
 			*base_indirect_ptr = cpu_to_le64(tmp);
 			tmp += DB_PAGE_SIZE;
 			base_indirect_ptr++;
-			page_entries++;
-		} while (page_entries < MAX_DB_PAGES_PER_BQ);
+		}
 		cqicb->lbq_addr = cpu_to_le64(rx_ring->lbq.base_indirect_dma);
 		cqicb->lbq_buf_size =
 			cpu_to_le16(QLGE_FIT16(qdev->lbq_buf_size));
@@ -3046,12 +3045,11 @@ static int qlge_start_cq(struct qlge_adapter *qdev, struct qlge_cq *cq)
 		tmp = (u64)rx_ring->sbq.base_dma;
 		base_indirect_ptr = rx_ring->sbq.base_indirect;
 		page_entries = 0;
-		do {
+		for (page_entries = 0; page_entries < MAX_DB_PAGES_PER_BQ; page_entries++) {
 			*base_indirect_ptr = cpu_to_le64(tmp);
 			tmp += DB_PAGE_SIZE;
 			base_indirect_ptr++;
-			page_entries++;
-		} while (page_entries < MAX_DB_PAGES_PER_BQ);
+		}
 		cqicb->sbq_addr = cpu_to_le64(rx_ring->sbq.base_indirect_dma);
 		cqicb->sbq_buf_size = cpu_to_le16(QLGE_SMALL_BUFFER_SIZE);
 		cqicb->sbq_len = cpu_to_le16(QLGE_FIT16(QLGE_BQ_LEN));
-- 
2.32.0

