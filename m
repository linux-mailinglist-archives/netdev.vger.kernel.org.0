Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D83BDA1F4
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438001AbfJPXHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:07:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51648 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437662AbfJPXHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 19:07:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id 7so512457wme.1;
        Wed, 16 Oct 2019 16:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ojfnadijHOPOCIQe26f89HvAE7/IDT63+su1is3tzr8=;
        b=lY5CUcT4nAFgne+0DY/Jrp7zFWt0eXI+t/q/cxUVdS0Z3vSW8amESZDEOd1se+Oaa3
         Lqyz0Tq8BNtX/irF+O5HBKg2+XqzDpLbQsYMYQ9jkoXWlF5Tn7FTNxt8McdNc5AYGVuP
         xoWkq7CoN2UOzxEQva8YPqXcadLnkS0cjS0empf9qLOtWrbiyQtwB8ZMZOPudOEmOPHd
         iTE5MmLQksTO5gao6n7solbfLJJh1eagjGivp+pLnkc7nMNqb1YtCfIlF3eAmxdiUXUl
         zDkk/Ovjz5b8ickpm4Y8olSqjxw09/U6/2ba/ch0CK3TM0k5uQS0H5EtS1JLLxQrj9BU
         mUVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ojfnadijHOPOCIQe26f89HvAE7/IDT63+su1is3tzr8=;
        b=Y+ZmNubUCgm0cAC4Haj6V+Un0+YtPtCymHRA8iXjDV+/MBCkGRrJQgSzGMSB+4RgA4
         JkqFRZ859kIddEGhUKbxKAdTHb52JXkcSaby6nbES4ov5QJzmQnTQ9pZKYz1Sgawyink
         cgKOacXSdwUJ8fBceH0PmDYimzsh+igIms2fOI+1HKtMaCaIlQo/GHcpQBrdZBhXSIdh
         2LRwYeagFmEgz9SioqPgASFmf+7j0s7D44sqdquaUB0CnyDPgwcqgXaK7k7SMcjGVs2f
         sDGY/xH4nxufsMmQA5s/Um1Wo0TUEwAAS7qlBQG24O3t+e/J+DW1HL54ZdJ8F/88qCWz
         acIg==
X-Gm-Message-State: APjAAAU5KWpsHCKTApObMdp9G6ujdkpfeLJoBwtw/hn98CplRR49qVNC
        vWLiKzcjbaaNLkwGUsc++js=
X-Google-Smtp-Source: APXvYqzVaTcVEj9/DSFJ+OeDTUdB9Rzl62iE9/bOW9PuSB5M2D5R1yNixttwWgkxdjIA4kKyoV2F0g==
X-Received: by 2002:a7b:cb95:: with SMTP id m21mr112778wmi.36.1571267251034;
        Wed, 16 Oct 2019 16:07:31 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l9sm297071wme.45.2019.10.16.16.07.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 16 Oct 2019 16:07:30 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 4/4] net: bcmgenet: reset 40nm EPHY on energy detect
Date:   Wed, 16 Oct 2019 16:06:32 -0700
Message-Id: <1571267192-16720-5-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
References: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The EPHY integrated into the 40nm Set-Top Box devices can falsely
detect energy when connected to a disabled peer interface. When the
peer interface is enabled the EPHY will detect and report the link
as active, but on occasion may get into a state where it is not
able to exchange data with the connected GENET MAC. This issue has
not been observed when the link parameters are auto-negotiated;
however, it has been observed with a manually configured link.

It has been empirically determined that issuing a soft reset to the
EPHY when energy is detected prevents it from getting into this bad
state.

Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index f0937c650e3c..0f138280315a 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2018,6 +2018,8 @@ static void bcmgenet_link_intr_enable(struct bcmgenet_priv *priv)
 	 */
 	if (priv->internal_phy) {
 		int0_enable |= UMAC_IRQ_LINK_EVENT;
+		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
+			int0_enable |= UMAC_IRQ_PHY_DET_R;
 	} else if (priv->ext_phy) {
 		int0_enable |= UMAC_IRQ_LINK_EVENT;
 	} else if (priv->phy_interface == PHY_INTERFACE_MODE_MOCA) {
@@ -2611,9 +2613,14 @@ static void bcmgenet_irq_task(struct work_struct *work)
 	priv->irq0_stat = 0;
 	spin_unlock_irq(&priv->lock);
 
+	if (status & UMAC_IRQ_PHY_DET_R &&
+	    priv->dev->phydev->autoneg != AUTONEG_ENABLE)
+		phy_init_hw(priv->dev->phydev);
+
 	/* Link UP/DOWN event */
 	if (status & UMAC_IRQ_LINK_EVENT)
 		phy_mac_interrupt(priv->dev->phydev);
+
 }
 
 /* bcmgenet_isr1: handle Rx and Tx priority queues */
@@ -2708,7 +2715,7 @@ static irqreturn_t bcmgenet_isr0(int irq, void *dev_id)
 	}
 
 	/* all other interested interrupts handled in bottom half */
-	status &= UMAC_IRQ_LINK_EVENT;
+	status &= (UMAC_IRQ_LINK_EVENT | UMAC_IRQ_PHY_DET_R);
 	if (status) {
 		/* Save irq status for bottom-half processing. */
 		spin_lock_irqsave(&priv->lock, flags);
-- 
2.7.4

