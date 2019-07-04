Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 182235F9C8
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfGDOLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:11:16 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33049 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfGDOLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 10:11:15 -0400
Received: by mail-wm1-f65.google.com with SMTP id h19so5396836wme.0
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 07:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=xMgsYX1AlkZeW8QfKJgEPDAQtSAEWuuhGQkYf2wCav8=;
        b=vyw9BL0mwIX+t4a0LrutWaKwJqzmyGeqRhJb4ZLLGoziYIzVnwLFAsg38XMko247xQ
         oDfCs28QNM2NWDPKsRnZTYKV5WSYOFHeb5zPAFvNt8n/HaQ9RiKkl6CipF3LP7oW83Ze
         S/dyaeQN/78RuVxKaTijc2D7xFdIYc5JfAWW8rvJMT1BtLz3HjAOpLg1EBb5MAc8AZUf
         yHxoBay/CEfGgv5p7n6n8zrvjGBDfMZWgWSeeQnDkFgXzCFVYRYvaJoKrZcQtmnqJefK
         vFItL199LiCzdCZ4RG/YRn0z5sjv97WncHKyF9X5RpFPbHGJK+/72FbjBeij5SOO0d/h
         yTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xMgsYX1AlkZeW8QfKJgEPDAQtSAEWuuhGQkYf2wCav8=;
        b=X5griqwvEMGMk6hg9WDqCHWIU5S7VdD6RrLF8J1Fk/edwEDzFXBLiszMt+ECsmo3Tf
         s9wsk3vmpMYHEwHenQbTiIukv07EXOjxpfBhwetLUWx4wmJrlFb3MiocbI6bkBjgmUQV
         m2Z3qkYD4RGOW+Tt9TBf03muPB3FqlVDaVjSFB0AWU/Tde1gyZUJ5N/Qo+zvYME8ox9P
         mbwyiC+VAkuhmNpIvEPBH7WEoRw47Yn1PvxUetTgFnwtCdsLT6OV3VNKxa2iG7Be4HlP
         hHGjOTqnvydRH5d3ir9Aa/EDQPJoC7o8V4tyUdHax3ngsvC2jVmBTBq6m5s7hUSxXs6m
         Tzxg==
X-Gm-Message-State: APjAAAUocc7rfi8E+hPvY6EvqHAJtijNa0IvV+MjrKvDma6F6fnFu9EJ
        EFy9ZT8ylOxkuW9YyPZcjev1K7FDQf1Lbw==
X-Google-Smtp-Source: APXvYqxncxnZpqiU7wEhnIYHMboSYGkJE+Kibfz0t1mjbfwRpq3kz4dIUORr2Z4+83/+LlVkiex0Bw==
X-Received: by 2002:a7b:cb94:: with SMTP id m20mr12250754wmi.144.1562249473191;
        Thu, 04 Jul 2019 07:11:13 -0700 (PDT)
Received: from apalos.lan (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id l11sm5477712wrw.97.2019.07.04.07.11.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 07:11:12 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org
Cc:     ard.biesheuvel@linaro.org, arnd@arndb.de,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH] net: netsec: Sync dma for device on buffer allocation
Date:   Thu,  4 Jul 2019 17:11:09 +0300
Message-Id: <1562249469-14807-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Arnd,

We have to do a sync_single_for_device /somewhere/ before the
buffer is given to the device. On a non-cache-coherent machine with
a write-back cache, there may be dirty cache lines that get written back
after the device DMA's data into it (e.g. from a previous memset
from before the buffer got freed), so you absolutely need to flush any
dirty cache lines on it first.

Since the coherency is configurable in this device make sure we cover
all configurations by explicitly syncing the allocated buffer for the
device before refilling it's descriptors

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 drivers/net/ethernet/socionext/netsec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 5544a722543f..e05a7191336d 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -727,6 +727,7 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
 {
 
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
+	enum dma_data_direction dma_dir;
 	struct page *page;
 
 	page = page_pool_dev_alloc_pages(dring->page_pool);
@@ -742,6 +743,10 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
 	 * cases and reserve enough space for headroom + skb_shared_info
 	 */
 	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
+	dma_dir = page_pool_get_dma_dir(dring->page_pool);
+	dma_sync_single_for_device(priv->dev,
+				   *dma_handle - NETSEC_RXBUF_HEADROOM,
+				   PAGE_SIZE, dma_dir);
 
 	return page_address(page);
 }
-- 
2.20.1

