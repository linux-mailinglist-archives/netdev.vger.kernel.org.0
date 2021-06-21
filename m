Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A243AEA5B
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 15:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbhFUNv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 09:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbhFUNv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 09:51:56 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A159DC061574;
        Mon, 21 Jun 2021 06:49:41 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id h26so2594469pfo.5;
        Mon, 21 Jun 2021 06:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L3aJmS+A5BgPt7scDAGNNWhO+vstoQ9bplelvtban/o=;
        b=aOBfGhsGV/NRRTJeWDNv1z2nkwtvmYnwdFVVgldj0IhV9Q1geXvY7Z9nnZQlwK+Rbc
         qk5YZ5aoOpdkwISZyz4dOCvaldF5KTmZ+mhIWZjtSASooLEyjZE00qBS/Om5znfIqsNV
         JSTF6fEJRVqb2QuyMqjZY/bbeLfCQIvpIj1Jzs4wlyZdH730LJJksdmBL0YRHiDk9J1i
         ekSpgge0OpCm2BLgSJXFpkTMITKLlOh6D8VDjcELFy19cdB8RaHskS9plLqXcWdDa5EJ
         GUVjB7YybpgG43u/RJjRQPpovrMkoG9cXG7DtzBKimJSxcHpV7xIK5fKb9QkXxn5Pmt3
         s0vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L3aJmS+A5BgPt7scDAGNNWhO+vstoQ9bplelvtban/o=;
        b=ba4IXb9F4j2o/nzejN85mVig8otlRhmeWOPZVHbR0o0ad+T/tWwPkByX0j4/wlDORU
         DNx55NJrOm2alAUvSiL4fDmsj/Q/iW19gRhjA/oz4TcVRlBQQYSHSh4U2G9PhB0pVifN
         XOmzDyLVTPyKm7J0A9vw/l7nI1x+X8CUJqjV5agzOSKRAbnjurG0HIZHEi9/va6djP2e
         cNucesLdKY0YZ3mv8XvCE9tmsE+mryzTtPdbHp89dNES2GvBjywjmGsP+pIpMZMQAgHp
         Rh3h+AKtXIoAFfIEPwPU3bpzoFW3t/AgNjow7nMwfK5o8klr1B9qmiIecaM2pryQ7xom
         s5Sw==
X-Gm-Message-State: AOAM533htqNxXUTW5Dt+WpnwsGNnQPldusyn4PhrJ1WvW1b/L5TE3AkA
        Li0PH3lCYq3Zxd8vlWbQsUE=
X-Google-Smtp-Source: ABdhPJx6GhFN8rBBIVU5c7BUKeFC5mwf3vsK+P3X25A5+EpaHo0zFKilXMuP9A16UB/t5FJOPr9V4g==
X-Received: by 2002:a63:5705:: with SMTP id l5mr23575883pgb.227.1624283381216;
        Mon, 21 Jun 2021 06:49:41 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y15sm15913517pji.47.2021.06.21.06.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 06:49:40 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-staging@lists.linux.dev
Cc:     netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC 03/19] staging: qlge: alloc skb with only enough room for header when data is put in the fragments
Date:   Mon, 21 Jun 2021 21:48:46 +0800
Message-Id: <20210621134902.83587-4-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621134902.83587-1-coiby.xu@gmail.com>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Data is put in the fragments. No need to alloc a skb with unnecessarily
large data buffer.

Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/TODO        | 2 --
 drivers/staging/qlge/qlge_main.c | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
index 0e26fac1ddc5..49cb09fc2be4 100644
--- a/drivers/staging/qlge/TODO
+++ b/drivers/staging/qlge/TODO
@@ -4,8 +4,6 @@
   ql_build_rx_skb(). That function is now used exclusively to handle packets
   that underwent header splitting but it still contains code to handle non
   split cases.
-* in the "chain of large buffers" case, the driver uses an skb allocated with
-  head room but only puts data in the frags.
 * rename "rx" queues to "completion" queues. Calling tx completion queues "rx
   queues" is confusing.
 * struct rx_ring is used for rx and tx completions, with some members relevant
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 6dd69b689a58..c91969b01bd5 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -1471,7 +1471,7 @@ static void qlge_process_mac_rx_page(struct qlge_adapter *qdev,
 	struct napi_struct *napi = &rx_ring->napi;
 	size_t hlen = ETH_HLEN;
 
-	skb = netdev_alloc_skb(ndev, length);
+	skb = napi_alloc_skb(&rx_ring->napi, SMALL_BUFFER_SIZE);
 	if (!skb) {
 		rx_ring->rx_dropped++;
 		put_page(lbq_desc->p.pg_chunk.page);
@@ -1765,7 +1765,7 @@ static struct sk_buff *qlge_build_rx_skb(struct qlge_adapter *qdev,
 			 * jumbo mtu on a non-TCP/UDP frame.
 			 */
 			lbq_desc = qlge_get_curr_lchunk(qdev, rx_ring);
-			skb = netdev_alloc_skb(qdev->ndev, length);
+			skb = napi_alloc_skb(&rx_ring->napi, SMALL_BUFFER_SIZE);
 			if (!skb) {
 				netif_printk(qdev, probe, KERN_DEBUG, qdev->ndev,
 					     "No skb available, drop the packet.\n");
-- 
2.32.0

