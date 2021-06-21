Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05FA33AEA56
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhFUNvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhFUNvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:51:37 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9828DC061574;
        Mon, 21 Jun 2021 06:49:22 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso10214581pjx.1;
        Mon, 21 Jun 2021 06:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7viMnibfS6VsxzlqCvYb7FwB8QCMPLVzuuh0psBNrJU=;
        b=tjJFcaz40QGLpVSYaxM07H8/eGzJESZ6yozxTdvYlveGp0wRby2HUQECj350JoC5if
         kDo/DC08G/mA2KmpyzjofP83+sJnABlcXw37McOROnOgmcqUhG17ULQrqzZjbTS1v0kS
         82Oyyo7j2Jz3xUUaKtR+4UDKnR1dLpIe7s3chpgUP7vbb6pMmOgYIQkRvtG2yVsXP7hq
         cfOKqtBRT/EdrWVW41y5Chrymf3V1QS1KFSkkkOa29Fy7j0Sptx+1BDepm2+FVXcyMss
         3FthpzKHS55bIjL/2DxwCOonm7w74cGB64GEJhW4nzUSc8nbKjBZClxFOHOMx1ooa7Cx
         zOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7viMnibfS6VsxzlqCvYb7FwB8QCMPLVzuuh0psBNrJU=;
        b=YXEmMINUsQgoaiSu8Fwh85ETWeqDC6SSQDUaEYmxWVsHQk91OgrmWHw8J2hdPeIOmh
         etPViZ5DtMd+M6EKK6RVemREKxXBhPco1gxvnUp/994c1gZMgVJ3WDpkh7rpjUUxv9BC
         uLYPxIccqZ+Rplas1tUzxn34kyG6SrpDRrhc9fo0Rj0SfG/Vq9D0upUlOYAy6NFn5lZj
         OGi045CRcIGSVSwuWjFelgrZ/js/s48lx+6H3v0rKlIGfSi14GNLpFhDeysnxJYp4Ht+
         eXtttSyeewoT3S4NzSVAxs+wFLd3N7qlYLUuQhITQAa67lYkErrtPuGb8QdqfwJy7f8m
         ZGCQ==
X-Gm-Message-State: AOAM533xMcBqyy+DE2cjhkSCGuk7KUUh3+55GDqUM9kZ7gA0nLZzja9U
        KUAl4uo314UIdh1qoBMhXPW9NK1yFcCLTCRh
X-Google-Smtp-Source: ABdhPJxyDY65TbjH9aeMH8nrQD14NHk4OE72CXa7oqptYgUzmsUi/Cm7+meEe8G2ml/icEIlQjGhzQ==
X-Received: by 2002:a17:902:8c87:b029:11d:6f72:78aa with SMTP id t7-20020a1709028c87b029011d6f7278aamr18252075plo.12.1624283362192;
        Mon, 21 Jun 2021 06:49:22 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m12sm8594396pfd.151.2021.06.21.06.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:49:21 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 01/19] staging: qlge: fix incorrect truesize accounting
Date:   Mon, 21 Jun 2021 21:48:44 +0800
Message-Id: <20210621134902.83587-2-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 7c734359d3504c869132166d159c7f0649f0ab34 ("qlge: Size RX buffers
based on MTU") introduced page_chunk structure. We should add
qdev->lbq_buf_size to skb->truesize after __skb_fill_page_desc.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO        |  2 --
 drivers/staging/qlge/qlge_main.c | 10 +++++-----
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index c76394b9451b..449d7dca478b 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -4,8 +4,6 @@
   ql_build_rx_skb(). That function is now used exclusively to handle packets
   that underwent header splitting but it still contains code to handle non
   split cases.
-* truesize accounting is incorrect (ex: a 9000B frame has skb->truesize 10280
-  while containing two frags of order-1 allocations, ie. >16K)
 * while in that area, using two 8k buffers to store one 9k frame is a poor
   choice of buffer size.
 * in the "chain of large buffers" case, the driver uses an skb allocated with
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 19a02e958865..6dd69b689a58 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -1446,7 +1446,7 @@ static void qlge_process_mac_rx_gro_page(struct qlge_adapter *qdev,
 
 	skb->len += length;
 	skb->data_len += length;
-	skb->truesize += length;
+	skb->truesize += qdev->lbq_buf_size;
 	skb_shinfo(skb)->nr_frags++;
 
 	rx_ring->rx_packets++;
@@ -1507,7 +1507,7 @@ static void qlge_process_mac_rx_page(struct qlge_adapter *qdev,
 			   lbq_desc->p.pg_chunk.offset + hlen, length - hlen);
 	skb->len += length - hlen;
 	skb->data_len += length - hlen;
-	skb->truesize += length - hlen;
+	skb->truesize += qdev->lbq_buf_size;
 
 	rx_ring->rx_packets++;
 	rx_ring->rx_bytes += skb->len;
@@ -1757,7 +1757,7 @@ static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
 					   lbq_desc->p.pg_chunk.offset, length);
 			skb->len += length;
 			skb->data_len += length;
-			skb->truesize += length;
+			skb->truesize += qdev->lbq_buf_size;
 		} else {
 			/*
 			 * The headers and data are in a single large buffer. We
@@ -1783,7 +1783,7 @@ static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
 					   length);
 			skb->len += length;
 			skb->data_len += length;
-			skb->truesize += length;
+			skb->truesize += qdev->lbq_buf_size;
 			qlge_update_mac_hdr_len(qdev, ib_mac_rsp,
 						lbq_desc->p.pg_chunk.va,
 						&hlen);
@@ -1835,7 +1835,7 @@ static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
 					   lbq_desc->p.pg_chunk.offset, size);
 			skb->len += size;
 			skb->data_len += size;
-			skb->truesize += size;
+			skb->truesize += qdev->lbq_buf_size;
 			length -= size;
 			i++;
 		} while (length > 0);
-- 
2.32.0

