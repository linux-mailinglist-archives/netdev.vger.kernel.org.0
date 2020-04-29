Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BB51BE802
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgD2UCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgD2UCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:02:12 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40824C03C1AE;
        Wed, 29 Apr 2020 13:02:12 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 18so1591064pfv.8;
        Wed, 29 Apr 2020 13:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CevivX0aGr8AmmZvoR5A9jtsq4aH4kUQzZm/M7FIZ5A=;
        b=E8ctWVjqQpu2nsC3Ydpfc3LtOwRwSwTFLxeQmSyOW7GOyuklsAGKUhnLYZB9c8CsNm
         hpp7dzl3Fd2wqkw4EbMylSk2epGKfN0TPB6mt4zjfeVkYTipehLvMlvMuZaO0CTUQ7gD
         oU8uDZvz0tBNyGI43+GQ8eoilcf7uESduagq48P5M1vNTAGiTY4pwN4luQt20aQ7OoNw
         qu6WQS4rhVoIS2pcvn3VaNL20p976+o1C0iflB/oSe9voUEerFo/AThNy0wmmkGCcsMY
         y4A+/YAY2Qb1ua47Z4KnX4bXjKKaVJyibTfqIkW7k8J8N0wq/L/a4is93rRPGTOqwssF
         aa1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CevivX0aGr8AmmZvoR5A9jtsq4aH4kUQzZm/M7FIZ5A=;
        b=pkz+u7qoMo4R7jonG3fkSC71MOGykA/Syo+D1jkA4btPbDZerT+JPRwsMtI7kWmAc7
         WjOgJzfcbhxywISzyv70oQ4ztyoXB2chLgcDoTuhB/HH8u+qnaIAvqACVeOy+wuV4aVG
         imfb9PiirlSylcD+ICl4W7/tN+qNgL1cXQYvSHlHg8xdwfjEHwfjbVOVnPB0w6NYTfqd
         TD/pAoxnMiYbmCj3LCz9Ux4nzDIMFmxCuhvxa6eDXy600PHUKN/mucubVUrcxoHcd38P
         oJLkgNj1FtGXfZBfDuZgSh8JVV1/w4efigU7/02xPKTiTJIgzt54efDCEUaqZTLnKPw2
         X/9g==
X-Gm-Message-State: AGi0Puah/2YyI7/A8y0dwreTuAvCTSXDr/VDbgisw9RZqU8GjJ4/bLMJ
        cP2G4GwjJfCa/gJNuUegzHg=
X-Google-Smtp-Source: APiQypImKV5ErRzSjavCApt6/HJl9CJMMMT7fj0bHkjKg0gkYmap9I/6LTUHWG0dNp63KbAHLkBTpw==
X-Received: by 2002:a63:8c17:: with SMTP id m23mr17899491pgd.246.1588190531743;
        Wed, 29 Apr 2020 13:02:11 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r128sm1705817pfc.141.2020.04.29.13.02.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 13:02:11 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 1/7] net: bcmgenet: set Rx mode before starting netif
Date:   Wed, 29 Apr 2020 13:02:00 -0700
Message-Id: <1588190526-2082-2-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
References: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit explicitly calls the bcmgenet_set_rx_mode() function when
the network interface is started. This function is normally called by
ndo_set_rx_mode when the flags are changed, but apparently not when
the driver is suspended and resumed.

This change ensures that address filtering or promiscuous mode are
properly restored by the driver after the MAC may have been reset.

Fixes: b6e978e50444 ("net: bcmgenet: add suspend/resume callbacks")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 351d0282f199..eb0dd4d4800c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -65,6 +65,9 @@
 #define GENET_RDMA_REG_OFF	(priv->hw_params->rdma_offset + \
 				TOTAL_DESC * DMA_DESC_SIZE)
 
+/* Forward declarations */
+static void bcmgenet_set_rx_mode(struct net_device *dev);
+
 static inline void bcmgenet_writel(u32 value, void __iomem *offset)
 {
 	/* MIPS chips strapped for BE will automagically configure the
@@ -2793,6 +2796,7 @@ static void bcmgenet_netif_start(struct net_device *dev)
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
 	/* Start the network engine */
+	bcmgenet_set_rx_mode(dev);
 	bcmgenet_enable_rx_napi(priv);
 
 	umac_enable_set(priv, CMD_TX_EN | CMD_RX_EN, true);
-- 
2.7.4

