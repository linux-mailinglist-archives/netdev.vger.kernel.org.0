Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8483E604B3
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 12:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfGEKrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 06:47:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52074 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfGEKrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 06:47:52 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so8404720wma.1
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 03:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=asdFhBAN7guh/2+9CqH9SHn+nDdcmy5dtZmjkwjbik8=;
        b=lceqm/LOpruqjrBHLp1WD9aFjJqxIp9TFWHV9om+rFySQmhPLDRoO8Mdi1+XfgDf+R
         gY5XMjckScUZ9hCcL29CoEDibW7jIpnqLEJYDeCYcEvEXfZG3AELeTK+bfupwP67MoA6
         rj2VRVd2N9RwpNKFGuNc18JuoYqboE/FCbY1GGEtN+UbHAJ8OKonXBUZtBEQCrq3+rEA
         W+2XcWY3U28aarMRqoybF/TyMhXJ4WxM7qLk/bju80+vVUvQxmuqOHsp6QRwJBQKdwrS
         1HOF/iea3AiPovhtU7nTUGOvIk4L7GZVLftFhwDlRUhMXqvHtdHkVgHFpAoez9zzvLIu
         TF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=asdFhBAN7guh/2+9CqH9SHn+nDdcmy5dtZmjkwjbik8=;
        b=K8PxdOU3A5ANnhYhVGUlUQXJ2Ui3Ku4If/mcBeNlv5xZy3n2tF8WXYSuj2mBrYJHlI
         /Rp7RUpxvQWZfs8zd4zgYjMnMXSk8T0QJk0D/NV46AN8ZvQlSpi/02zUMHDjB48GOmZr
         NXZQmHJVpoDSls6AfR8KokPwzCFD2oZUeh8uO7OzWolg+0GMy/OVKo8H3itFqDhV9vTe
         mMmu48gDC2o9TF9NBHIePMjobZTOuRiAWp5E9JmEr7qndnq2ZYs456mC7IfoVzNt/nXm
         H2N0RCOZSiDL+Q/7Od2prSajdgVSny0gsJhOuos5p5tARAphFdkDLvbaT2SzEaKOuQHL
         /YQA==
X-Gm-Message-State: APjAAAUrhpF8cYSASYylaUkDvguGQt2XuwuHylcul3CLHe2nEnkiwmST
        Spcnz5poV10AjKDPBnlPfAdPP7OhG0Lj1A==
X-Google-Smtp-Source: APXvYqyUwbh9WCWY0O9E9bgrqhpBRLUqyczugdOonLK9PjNpvhBYTlQKRIebYeFXuNMsYrfDsb0w2w==
X-Received: by 2002:a1c:3cc4:: with SMTP id j187mr2671091wma.36.1562323670070;
        Fri, 05 Jul 2019 03:47:50 -0700 (PDT)
Received: from apalos.lan (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id 72sm8480349wrk.22.2019.07.05.03.47.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 05 Jul 2019 03:47:49 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org
Cc:     brouer@redhat.com, ard.biesheuvel@linaro.org, arnd@arndb.de,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [net-next, PATCH, v3] net: netsec: Sync dma for device on buffer allocation
Date:   Fri,  5 Jul 2019 13:47:47 +0300
Message-Id: <1562323667-6945-1-git-send-email-ilias.apalodimas@linaro.org>
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
Changes since v2:
- Only sync for the portion of the packet owned by the NIC as suggested by 
  Jesper

 drivers/net/ethernet/socionext/netsec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 5544a722543f..6b954ad88842 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -727,6 +727,7 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
 {
 
 	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
+	enum dma_data_direction dma_dir;
 	struct page *page;
 
 	page = page_pool_dev_alloc_pages(dring->page_pool);
@@ -742,6 +743,8 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
 	 * cases and reserve enough space for headroom + skb_shared_info
 	 */
 	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
+	dma_dir = page_pool_get_dma_dir(dring->page_pool);
+	dma_sync_single_for_device(priv->dev, *dma_handle, *desc_len, dma_dir);
 
 	return page_address(page);
 }
-- 
2.20.1

