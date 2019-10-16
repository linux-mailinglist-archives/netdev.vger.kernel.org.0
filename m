Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7845DD8FBC
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 13:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfJPLkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 07:40:40 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40535 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfJPLkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 07:40:39 -0400
Received: by mail-wm1-f66.google.com with SMTP id b24so2383573wmj.5
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 04:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5BmxpLDnpwLj/rKEuNcorTG+zgO8YvtimK56et3jBEE=;
        b=HomfB66g+peuZMRNypTayjh4DsFkweI6KARmYnQT9H2F4gwdG4NxbHUTro8JV/wtPs
         I8fbQfNQ00x+s408Ql3AsES3Vz9HD3q8mxlVepRKztDKQDXvLZ59Yp6vMEzlCaZ9upBM
         iFDApUfQXUrtRC/fhoWk5XSvB4MdSrM1/GkpVAOiOGn/vSyJfFABKH29pN6C0VIl8NhO
         Ruimz5QleCbow2jAbqFHsF+9FFctFx4K6cTevf8/ItHBy7dbIOtyWzKaJQdKqMSQNGQO
         ook30efWLyvgLaKue1MCQLVHFiOLTNYSmk8dmd+F2w6s0puXoZgCb8TbPRE0hvS0dnY6
         tg9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5BmxpLDnpwLj/rKEuNcorTG+zgO8YvtimK56et3jBEE=;
        b=EGj3CmN4PfLO/Av4tcIlkc6JDe8VqBPmiu9ZDT0V9B4S5UtjHHU3nORxKsyjCXcac3
         kLbu8LBd27fwAunwOxGrUmZM3UpRV2xGozLr0xEJRwwG7WzToVSvAyA76976Rju87lhe
         /yatdAwzVKi4C65g4bHhAZdOFVX1VPkJ2tKL2hgJhfbPcjc2C3bN1wsTsRx0x57/LqAT
         9ogm/lFpp7BrE+gnIC/VYI9g5A8S9wdE8voPz7ZafYryXNSQuIy8hnre7pjvywbApA7K
         kvO56tT+iDGLjZxkDY8dXZlUmWqCZPASyM5JFO0M6O0GQO+QUpoikN4h+hzb0+/r9ucS
         Jmaw==
X-Gm-Message-State: APjAAAUAdgvbFNhE0uo40k/bEpc1y6068aNJ7KH4/5Vo16EBQK9xpMdh
        +MP5RvUrKW25cwakzZS6RyJPsYSpHE4=
X-Google-Smtp-Source: APXvYqw7fIpIsEet7luOieadAozl+vIKiPNjShOFV4JO64GtPPBeFHfMkAavBjCbX5splCH0A/7HYQ==
X-Received: by 2002:a7b:c849:: with SMTP id c9mr3088494wml.58.1571226037275;
        Wed, 16 Oct 2019 04:40:37 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-5.home.otenet.gr. [94.65.92.5])
        by smtp.gmail.com with ESMTPSA id y3sm8361628wmg.2.2019.10.16.04.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 04:40:36 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        davem@davemloft.net, brouer@redhat.com, lorenzo@kernel.org
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH] net: netsec: Correct dma sync for XDP_TX frames
Date:   Wed, 16 Oct 2019 14:40:32 +0300
Message-Id: <20191016114032.21617-1-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_xdp_adjust_head() can change the frame boundaries. Account for the
potential shift properly by calculating the new offset before
syncing the buffer to the device for XDP_TX

Fixes: ba2b232108d3 ("net: netsec: add XDP support")
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 drivers/net/ethernet/socionext/netsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index f9e6744d8fd6..41ddd8fff2a7 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -847,8 +847,8 @@ static u32 netsec_xdp_queue_one(struct netsec_priv *priv,
 		enum dma_data_direction dma_dir =
 			page_pool_get_dma_dir(rx_ring->page_pool);
 
-		dma_handle = page_pool_get_dma_addr(page) +
-			NETSEC_RXBUF_HEADROOM;
+		dma_handle = page_pool_get_dma_addr(page) + xdpf->headroom +
+			sizeof(*xdpf);
 		dma_sync_single_for_device(priv->dev, dma_handle, xdpf->len,
 					   dma_dir);
 		tx_desc.buf_type = TYPE_NETSEC_XDP_TX;
-- 
2.23.0

