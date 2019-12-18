Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D66A2123BEE
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 01:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbfLRAvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 19:51:48 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37530 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbfLRAvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 19:51:32 -0500
Received: by mail-pg1-f195.google.com with SMTP id q127so266902pga.4;
        Tue, 17 Dec 2019 16:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zyYDhbBHYvJZcIK28oQRV3QueIffU3NZ46cPVs6WCSA=;
        b=F4dbjTCPRYF+0mZOoHCvhPm/uD7JX9NaojKIPtOWYdTvdwtbuRnKbXj/HlcJPMGfDW
         VZrHY2dn9jKx/pr7Sl5oQb9XeTnobsZSHix1pqmp6vmALF9fe4M9x5IYIPLnEdyFLW5P
         7260rwcnICRAP2Wt3MphO0avgiuaCeuGoxGZ2+8pWnJqe5x0xsRXY8op9cnKiKwYgIoC
         GcXnr3PHxeIIZpTsZEAmZ6AWXj8Se/fUkDNs8tiZl2D9xkxP8ZrfQlqEAaaDE/NGpJTU
         OmHQ/kaFKc6It7ifgfNg3sYcrVGHq8oZGAoS0Fqbrluvlc8OUxXqdfz2O/UmbZpSCx+u
         2zmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zyYDhbBHYvJZcIK28oQRV3QueIffU3NZ46cPVs6WCSA=;
        b=BCftIUXhJbpUl74ADSB025ambbOzZmgeCqp7MnOIUjIasGvWul7lCqrGlm4JIIh27i
         QWiCxO6xaMGVZlqVrqNOrdLfbqs2ohO0Y5TZNPj7JwUUQh92nL51A2yBUtP7K+qQu2ZE
         i2KWUcZlVzLBodn33/uUrDE781AFmg8n/OtaU5hSX6dbZGRUWdg+xoxRnAAP+/DHygTv
         vyXNgFUFWNM3vTB+AXRj5S+h7FMJkR3x6koVoNhVTtiwV4b//RfB03uPRjmmgAwS0KBa
         n3bK3zuvteWv9nuuFhgi6KLdBqOESMZUnBPVI5Psvo7EHNvmbF5j+SVS8H07FGvXwl5Q
         QlsA==
X-Gm-Message-State: APjAAAXTlbcgPkamUnCvpazifZAH6y8cWtEJ/aWt4uPr4z29qWfwHBuR
        JkD1PoTFi/2tB6OGsn6qt2w=
X-Google-Smtp-Source: APXvYqziQZsXcOA+snrNlWN2e99nedKcHk53G1hf/HJ6kScHVkxYI4FMBamnRO68Um/mCpj+kR2wTQ==
X-Received: by 2002:a62:1d52:: with SMTP id d79mr715735pfd.144.1576630291677;
        Tue, 17 Dec 2019 16:51:31 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 81sm274819pfx.30.2019.12.17.16.51.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Dec 2019 16:51:31 -0800 (PST)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 6/8] net: bcmgenet: Turn on offloads by default
Date:   Tue, 17 Dec 2019 16:51:13 -0800
Message-Id: <1576630275-17591-7-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
References: <1576630275-17591-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can turn on the RX/TX checksum offloads and the scatter/gather
features by default and make sure that those are properly reflected
back to e.g: stacked devices such as VLAN.

Signed-off-by: Doug Berger <opendmb@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 0e57effd5b19..13e9154db253 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3530,9 +3530,11 @@ static int bcmgenet_probe(struct platform_device *pdev)
 
 	priv->msg_enable = netif_msg_init(-1, GENET_MSG_DEFAULT);
 
-	/* Set hardware features */
-	dev->hw_features |= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
-		NETIF_F_RXCSUM;
+	/* Set default features */
+	dev->features |= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
+			 NETIF_F_RXCSUM;
+	dev->hw_features |= dev->features;
+	dev->vlan_features |= dev->features;
 
 	/* Request the WOL interrupt and advertise suspend if available */
 	priv->wol_irq_disabled = true;
-- 
2.7.4

