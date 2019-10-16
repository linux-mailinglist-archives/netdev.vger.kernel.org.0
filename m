Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5453ADA1F7
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405987AbfJPXH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:07:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36262 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389129AbfJPXHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 19:07:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id y19so147158wrd.3;
        Wed, 16 Oct 2019 16:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RvbOBY39VyZYC+CLZJKtp27+9Ba/+z9ER2H7LIJA86Q=;
        b=TPD3+AGAyP/QnOmTbBLfqC+Hb3TnF5JXnNTpBFMazGTzlGzEM/eUemUZc8xxuYKVTZ
         2sEMlgbLVct2X4pnTZ+e8o782csqTesxNB6bCOs7siTJmp+uK5eOEZQlb1JFFQ8E5BcL
         6mQr4op4bRRDPhlcRINdGrR5KvyWLLgwphHXPbsEu0fan61y5Y3eoAI/ySe4YLIYFkqZ
         STcqio9AIg2/NmDbWBKvPOz/52qQ8BVksiwH2asKO//TotoWeZafTXEXUpr8okRApwkK
         ZY4P1SVRhpSZFU2jSVtfoHa7WlGInQ6DWxbMk5kjgoVY8eEkjsDSP9ZxHoKCMAPnLV35
         eYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RvbOBY39VyZYC+CLZJKtp27+9Ba/+z9ER2H7LIJA86Q=;
        b=IiqKuJ7kkLaAk5PzDeHptT80xfuig+Rf8iWbfKMbLfEbD6Ed7QcJ0y3pXCwgm/GEQ7
         uL2fnkgabwBC0uVSCJdkiTgvJpYOr6m+ulNrZSSPNapWglZSyiUeL64ZI4WG7P4MnDfm
         90OYBQmuk1h2AxZeSDSjuvVmGRZ6drfMkPQfUJvdVF0RAyMmK4eq5O7MNOiLXtXYDY6L
         XuIhUxiKozpTtiy5Ast2zFUrin2vgwvAogzlT74vBg4vrDtgvFMTBzQDhPf4pB790Z4J
         un1pXd1BgzpOuUsRpmNardqHbih6cYuMD1qbHNxe50TWR/HDkTMJh8UvpE8UdU3oXiIA
         GoIg==
X-Gm-Message-State: APjAAAWcI77xc6LAixVsC1NBBlE/VPNe2gJxd83q37mfIGWc4mQImUCA
        l+be6K+UoFAtkDlMUcHmOPg=
X-Google-Smtp-Source: APXvYqwcTj1IMST/hl8Ybvo0FcKzTMJpoh9r2Q7KfZq7QgGxfWq0ndDhXuEqa7nV7Z40bfIrRXuA7g==
X-Received: by 2002:adf:ed43:: with SMTP id u3mr252825wro.236.1571267243835;
        Wed, 16 Oct 2019 16:07:23 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l9sm297071wme.45.2019.10.16.16.07.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 16 Oct 2019 16:07:23 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 1/4] net: bcmgenet: don't set phydev->link from MAC
Date:   Wed, 16 Oct 2019 16:06:29 -0700
Message-Id: <1571267192-16720-2-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
References: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When commit 28b2e0d2cd13 ("net: phy: remove parameter new_link from
phy_mac_interrupt()") removed the new_link parameter it set the
phydev->link state from the MAC before invoking phy_mac_interrupt().

However, once commit 88d6272acaaa ("net: phy: avoid unneeded MDIO
reads in genphy_read_status") was added this initialization prevents
the proper determination of the connection parameters by the function
genphy_read_status().

This commit removes that initialization to restore the proper
functionality.

Fixes: 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in genphy_read_status")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 12cb77ef1081..10d68017ff6c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2612,10 +2612,8 @@ static void bcmgenet_irq_task(struct work_struct *work)
 	spin_unlock_irq(&priv->lock);
 
 	/* Link UP/DOWN event */
-	if (status & UMAC_IRQ_LINK_EVENT) {
-		priv->dev->phydev->link = !!(status & UMAC_IRQ_LINK_UP);
+	if (status & UMAC_IRQ_LINK_EVENT)
 		phy_mac_interrupt(priv->dev->phydev);
-	}
 }
 
 /* bcmgenet_isr1: handle Rx and Tx priority queues */
-- 
2.7.4

