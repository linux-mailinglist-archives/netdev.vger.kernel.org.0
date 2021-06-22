Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98763AFC90
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 07:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhFVF0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 01:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhFVF0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 01:26:54 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE7DC061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 22:24:38 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id p7so33756008lfg.4
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 22:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kG78t0JV5yGRAVhXZ+gQItvCmD2cSFBlsZqJlY4Yk/0=;
        b=YPJ29W677osVntsuBbII6OvwBhxFud8bK1xuilHg4DzMs+4f1egcyD1SVIBirPJ6Cu
         YRiB45BYpQp6/+gb4vlq7+KOeV+I1edBsUliTBptNQR6p49VcdZulgf/Nd/cvXMfPn/g
         DgFzuUYMnwo0dtUNAp1cl6fRorCjrXpY43t44NaRTwQzRdEElQ/jHidVVeja6khgWksW
         VAxMXCtGPC9Kgiu+LdOJiqleO6jTu01pFpVJX3wcRWgFUom7TmXevWBkjTtcn5jb7zd/
         I19/5lx5CwQWGswW//82MHuhbLxHCLnQR1BWPRpmqg6dB+nmQG8PM37oTf3S5CUHUvCH
         gwbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kG78t0JV5yGRAVhXZ+gQItvCmD2cSFBlsZqJlY4Yk/0=;
        b=MOSi8SvzIhkC1ig3KhoREmByG118Az4lgMmHHyI2c/JJcmdzDVbOqk9UE3jkMfCtxG
         L8eJBA3ajwFO9HcGxWjp6lRPSyS81kO/mYh6bYRSSFP7K+Kq+UfFAPv4XuhwUontieBD
         cFlPUwbqY+caPbzy2QhMe2wCBQaRgjqbmcu67X7NDHV/6W2gbsAgLNfn4tke/jmOKf76
         Oe60KkhOZAnkj36NX+x4fjWIZ9lXF88zVCv+hC46Ii2HB//DC3+PR/XCU5qfPAMXGcm2
         C+IFJfesMYR+iOu+BDMtJbfmQtTpjKc+6sR8xMQf02EXIgTAYS8e9Dsv8Ks3hKwZa4ZS
         vuxA==
X-Gm-Message-State: AOAM532OMBJgRfM2TZnYLBT1yZxDrCPKbXOLQXLb0MdDteZ7HP7w1hUA
        QX/2yP1+88GuGs4SzysgAa8=
X-Google-Smtp-Source: ABdhPJzVFmXubSl6fMmPix99K0dosYLAq7DJoD7gHACN21n/2Omd25BO1X/oSGhnvHcywuhRjXyxHw==
X-Received: by 2002:ac2:4255:: with SMTP id m21mr1520040lfl.633.1624339477234;
        Mon, 21 Jun 2021 22:24:37 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id q2sm2446449ljj.7.2021.06.21.22.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 22:24:36 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net] net: broadcom: bcm4908_enet: reset DMA rings sw indexes properly
Date:   Tue, 22 Jun 2021 07:24:15 +0200
Message-Id: <20210622052415.12040-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Resetting software indexes in bcm4908_dma_alloc_buf_descs() is not
enough as it's called during device probe only. Driver resets DMA on
every .ndo_open callback and it's required to reset indexes then.

This fixes inconsistent rings state and stalled traffic after interface
down & up sequence.

Fixes: 4feffeadbcb2 ("net: broadcom: bcm4908enet: add BCM4908 controller driver")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
Sorry for a late fix, this bug has been exposed by OpenWrt and debugged
just yesterday.
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 60d908507f51..02a569500234 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -174,9 +174,6 @@ static int bcm4908_dma_alloc_buf_descs(struct bcm4908_enet *enet,
 	if (!ring->slots)
 		goto err_free_buf_descs;
 
-	ring->read_idx = 0;
-	ring->write_idx = 0;
-
 	return 0;
 
 err_free_buf_descs:
@@ -304,6 +301,9 @@ static void bcm4908_enet_dma_ring_init(struct bcm4908_enet *enet,
 
 	enet_write(enet, ring->st_ram_block + ENET_DMA_CH_STATE_RAM_BASE_DESC_PTR,
 		   (uint32_t)ring->dma_addr);
+
+	ring->read_idx = 0;
+	ring->write_idx = 0;
 }
 
 static void bcm4908_enet_dma_uninit(struct bcm4908_enet *enet)
-- 
2.26.2

