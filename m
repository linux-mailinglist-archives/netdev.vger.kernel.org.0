Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B49301500
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 13:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbhAWMIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 07:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbhAWMIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 07:08:24 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B108C06178B
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 04:07:44 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id g15so5557247pjd.2
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 04:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ib5yrjhRxj1gxfBqNCCgQcI6y8o+/2z4BcgmutvFBFQ=;
        b=FLwmC5MYLBs1IceoqIt2nKlJK8x1hpKFBQAToFC/+Hfoyxoc39v7QqhAAvBe/BpM1I
         fxO++3hW/t5UAtVN6x5xZVTiHCWzrvBIBSSnFEGcXbpYPKlJ8CJpZR87T6qq+KRL87bn
         68TUwomsj/RkUXX590WLzUiuAAxR8ccET3YxKMK/SMd0EFMg9x2fCDiTiVClv6Ki6qB7
         vWL1lp6VswMD48rRCLW5p1sxWQXuwuyW0ovcM7hkY9Ul187fYZdgdMRotl9jJsbhFl7g
         g9pxz4ZMz1E26V2T71lZ0e5tZCVrO/j8M61Zz2wuJwM8aIxa2QAVD9H51lSw5UZ7CVcU
         s20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ib5yrjhRxj1gxfBqNCCgQcI6y8o+/2z4BcgmutvFBFQ=;
        b=bbjwddoGAROkHOfLBnWaBJ+zKBOA4b+tC5a7xskiMQ1MvP5Q50ujsQ5eTDCx29kVR5
         UyCYSWVkkhqvdYaVZQKP78IuuD3oIyZGg7kuqhOydkibtzB4hWZ/7Nflg9EYuKepBMas
         P/+7Y4y4x9e5kKLNT9FBCrpiyUBBPZCmxVbfWDNuwDdoz/W6lp2pEPuN8aIEa2ziK4QD
         rIVBXHxxVebmPK1Vwkk47jc8BwL+rdNxtjTCeRk7439Vz/fEUwE/xrvyyuDeXkwAmJEQ
         BIjCwgkMSaWt/7YJ9G1Wq35mQZZdOnmZmsvoiKtXDlxfAiqOfUdlRkT9D9i3VRNALNUy
         j0LQ==
X-Gm-Message-State: AOAM530U48kvUSyspwHK3tdEkwfXvdQoOyAqsa6wOARIkXCXfx5ZHwGF
        jkPleACyMzf3AVZpsPq1Z8M5N1hA7+Q=
X-Google-Smtp-Source: ABdhPJz6NmyGBIXCMIXd2nGE0F/4oGvckAlNEWACSloaHUJrKjaa2tvmarDjfoFaVQaeCegtr5LC5A==
X-Received: by 2002:a17:902:bf06:b029:dc:1f:ac61 with SMTP id bi6-20020a170902bf06b02900dc001fac61mr9985382plb.16.1611403663905;
        Sat, 23 Jan 2021 04:07:43 -0800 (PST)
Received: from pek-lpggp6.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id v9sm11471079pff.102.2021.01.23.04.07.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Jan 2021 04:07:43 -0800 (PST)
From:   Kevin Hao <haokexin@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: [PATCH net-next 4/4] net: dpaa2: Use napi_alloc_frag_align() to avoid the memory waste
Date:   Sat, 23 Jan 2021 19:59:03 +0800
Message-Id: <20210123115903.31302-5-haokexin@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210123115903.31302-1-haokexin@gmail.com>
References: <20210123115903.31302-1-haokexin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The napi_alloc_frag_align() will guarantee that a correctly align
buffer address is returned. So use this function to simplify the buffer
alloc and avoid the unnecessary memory waste.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index fb0bcd18ec0c..b7aaf4b4f3fb 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -768,12 +768,11 @@ static int dpaa2_eth_build_sg_fd(struct dpaa2_eth_priv *priv,
 	/* Prepare the HW SGT structure */
 	sgt_buf_size = priv->tx_data_offset +
 		       sizeof(struct dpaa2_sg_entry) *  num_dma_bufs;
-	sgt_buf = napi_alloc_frag(sgt_buf_size + DPAA2_ETH_TX_BUF_ALIGN);
+	sgt_buf = napi_alloc_frag_align(sgt_buf_size, DPAA2_ETH_TX_BUF_ALIGN);
 	if (unlikely(!sgt_buf)) {
 		err = -ENOMEM;
 		goto sgt_buf_alloc_failed;
 	}
-	sgt_buf = PTR_ALIGN(sgt_buf, DPAA2_ETH_TX_BUF_ALIGN);
 	memset(sgt_buf, 0, sgt_buf_size);
 
 	sgt = (struct dpaa2_sg_entry *)(sgt_buf + priv->tx_data_offset);
-- 
2.29.2

