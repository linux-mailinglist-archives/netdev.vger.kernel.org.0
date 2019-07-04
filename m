Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E745FA45
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 16:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfGDOqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 10:46:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46020 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727246AbfGDOqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 10:46:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so6889680wre.12
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 07:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=vIlZPh+cGdBas5UVFVe9m7v5eH4HqPXtkpxnK7R76V8=;
        b=by5JoobT6u12N2NqxmbOaAvvscrI4lTaDsNQMaPqOs5k5nDFzoSDmKsm9/s2TFnsWn
         d+j/CfTOGZnqMiTRFKYDpNeQJAXSpHXPrmuAJYk0A8LOkSBleazbQaCiINh2+QroyiMS
         X+0xHHjXJ8i+s1MyTEPA0aUHvM07wXVfv+X2i4CwEDy7fjRsAct5ARlyKWIt0n/Gvdam
         bmmwxTfJGW0Dia5XqIAtXh1AlnirXIVl2LVqHC9VvXjyEOQuAgcsAYP5kfM6HybM7qFt
         4X3BqgBIUMLssHclhAtYlOOhRh3VRHsp1JTFi86726jxi2RcspVa2AUq6ubTCQILh9hR
         lxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vIlZPh+cGdBas5UVFVe9m7v5eH4HqPXtkpxnK7R76V8=;
        b=OfxdCC8+IcFUQJmGcHXYc/qs6zEkAOCB9roNv8EeVyc7LmGE0ynsNfe7gCAWF8ILg0
         c/24tR6CGE+VBOxxPlBa/YzdCYv160OhuM4/shyymv+KDJ57adYCb9HblUiIrKzqbG4f
         EOZ245X5q/Pzl1jHHptWKoaBgoMkJoCh71MeihdwK/2QifBr7eCsQ+gLuBQcT464Kgga
         a3iB4l6Hhca07zdbS0hVACJtm7fkOSry2cS1ROgCa0TMLs6fjtKMblaKGwcuBVQVuNiC
         AApRCuY693PrFnxGpKA9cIuw9kl9eT5eioS++YNv99AwYCQIeFlv0YxxcEXJTVzx67E9
         KdIA==
X-Gm-Message-State: APjAAAWuOhhw05D0prws+CYWBysmIHwwzPY22KBHmOhJhYYjjJBJUAJm
        Kqz8vDpr8aQnhoHjgxffgaRlk14AtXHlEg==
X-Google-Smtp-Source: APXvYqxVy0sEUv3xIfMrZOTmb+DRentv3xwc0JcDUfn2aEicy6EyHj6Je33WTUyG4LdgeTW9CInTDw==
X-Received: by 2002:a5d:6650:: with SMTP id f16mr3076605wrw.89.1562251571548;
        Thu, 04 Jul 2019 07:46:11 -0700 (PDT)
Received: from apalos.lan (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id b12sm2503569wmg.32.2019.07.04.07.46.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 04 Jul 2019 07:46:11 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org
Cc:     ard.biesheuvel@linaro.org, arnd@arndb.de,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [net-next, PATCH, v2] net: netsec: Sync dma for device on buffer allocation
Date:   Thu,  4 Jul 2019 17:46:09 +0300
Message-Id: <1562251569-16506-1-git-send-email-ilias.apalodimas@linaro.org>
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

Changes since V1: 
- Make the code more readable
 
 drivers/net/ethernet/socionext/netsec.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 5544a722543f..ada7626bf3a2 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -727,21 +727,26 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
 {
 
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
+	enum dma_data_direction dma_dir;
+	dma_addr_t dma_start;
 	struct page *page;
 
 	page = page_pool_dev_alloc_pages(dring->page_pool);
 	if (!page)
 		return NULL;
 
+	dma_start = page_pool_get_dma_addr(page);
 	/* We allocate the same buffer length for XDP and non-XDP cases.
 	 * page_pool API will map the whole page, skip what's needed for
 	 * network payloads and/or XDP
 	 */
-	*dma_handle = page_pool_get_dma_addr(page) + NETSEC_RXBUF_HEADROOM;
+	*dma_handle = dma_start + NETSEC_RXBUF_HEADROOM;
 	/* Make sure the incoming payload fits in the page for XDP and non-XDP
 	 * cases and reserve enough space for headroom + skb_shared_info
 	 */
 	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
+	dma_dir = page_pool_get_dma_dir(dring->page_pool);
+	dma_sync_single_for_device(priv->dev, dma_start, PAGE_SIZE, dma_dir);
 
 	return page_address(page);
 }
-- 
2.20.1

