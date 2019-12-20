Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D88512820D
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfLTSPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:15:35 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44973 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727681AbfLTSPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:15:33 -0500
Received: by mail-pg1-f194.google.com with SMTP id x7so5311907pgl.11;
        Fri, 20 Dec 2019 10:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HBtEN8uxRFo6GiqOvwtE5p5fqWGQ2KXhufiiWi2owA4=;
        b=NxxlgPf23SAYgx+uuYsd+35mP0zC8DTYBO1k+RUJWfTd3cfMGf/FeUilgzXrfSfuoU
         yr6+ZtA4srCYIocMdzJlmO4rgM8MBaonODMT8KRHNii/Zj1aqvE3H6VUsyka5uMP7vqr
         42I6Q7hDI/bSWhPxKJ5kE4iEArF6pHOfiL4Ltke2lOC/2me7tk1SiCPR1wUFon1Yr8SB
         Aat2CS2pGd91JMYZIPEmGZKFMyLYT4xLrxsfaPAyCGyZkzrwaPW86sWWYUmzQ4ugGP3C
         RxLbQTafMTJ4OOq9ynnPBi+8slXamZifUFIE9ZwYP1C3jzAD5DFWGkoHMKXKYA8NJpQ0
         IrUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HBtEN8uxRFo6GiqOvwtE5p5fqWGQ2KXhufiiWi2owA4=;
        b=LpCl23ILa4BiCyk1rWxnyy/YbD2uAPDNoluZwknZdrghg0Jhjxb4Km2cn9Pww9wRfr
         rvGe2l7sEy1P8ia58sDSRxGB6PRvW1S2/8KAnupjX117vrDDQOLfeQda9it1rlnMzWS8
         Yo/f+T5fqxJcz8azrd5CYclRt1PwYlt6rIvlx81Bny7BQbcpAfRG6wMM2jZwcB1TLiYG
         7iHQQaePO9Zo5AQlFc88FCfdpg8xlt1hvKX+0nZMvvr5/oIHTf00QXPDOE1izakwm7wS
         /ShJatnHTky+SooNl8BHgjzY0ZoLUl4eaoRHP2///NxCuWuoWSwk6Vg9gO431hDeTbO8
         b1uA==
X-Gm-Message-State: APjAAAWCZ5PVQGRX9iivGDH2VmPDUGTtZzgShI6+kX+P2mZohUHV/vRr
        L49G5HgYMANBspjx/sI7D1GYPVlj
X-Google-Smtp-Source: APXvYqyxQMCQUf9jae0A7rYum6mA2coMQkbF8j++Rw93PXipv6niopccBeQyf8iV9dH2rgHDMltCxg==
X-Received: by 2002:a65:5608:: with SMTP id l8mr16635881pgs.210.1576865732099;
        Fri, 20 Dec 2019 10:15:32 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j28sm11833869pgb.36.2019.12.20.10.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 10:15:31 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V7 net-next 05/11] net: netcp_ethss: Use the PHY time stamping interface.
Date:   Fri, 20 Dec 2019 10:15:14 -0800
Message-Id: <2ccbb4b81949214c34053da6b1462947f33ec450.1576865315.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576865315.git.richardcochran@gmail.com>
References: <cover.1576865315.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netcp_ethss driver tests fields of the phy_device in order to
determine whether to defer to the PHY's time stamping functionality.
This patch replaces the open coded logic with an invocation of the
proper methods.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/ti/netcp_ethss.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index 86a3f42a3dcc..1280ccd581d4 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -2533,8 +2533,6 @@ static int gbe_del_vid(void *intf_priv, int vid)
 }
 
 #if IS_ENABLED(CONFIG_TI_CPTS)
-#define HAS_PHY_TXTSTAMP(p) ((p)->drv && (p)->drv->txtstamp)
-#define HAS_PHY_RXTSTAMP(p) ((p)->drv && (p)->drv->rxtstamp)
 
 static void gbe_txtstamp(void *context, struct sk_buff *skb)
 {
@@ -2566,7 +2564,7 @@ static int gbe_txtstamp_mark_pkt(struct gbe_intf *gbe_intf,
 	 * We mark it here because skb_tx_timestamp() is called
 	 * after all the txhooks are called.
 	 */
-	if (phydev && HAS_PHY_TXTSTAMP(phydev)) {
+	if (phy_has_txtstamp(phydev)) {
 		skb_shinfo(p_info->skb)->tx_flags |= SKBTX_IN_PROGRESS;
 		return 0;
 	}
@@ -2588,7 +2586,7 @@ static int gbe_rxtstamp(struct gbe_intf *gbe_intf, struct netcp_packet *p_info)
 	if (p_info->rxtstamp_complete)
 		return 0;
 
-	if (phydev && HAS_PHY_RXTSTAMP(phydev)) {
+	if (phy_has_rxtstamp(phydev)) {
 		p_info->rxtstamp_complete = true;
 		return 0;
 	}
@@ -2830,7 +2828,7 @@ static int gbe_ioctl(void *intf_priv, struct ifreq *req, int cmd)
 	struct gbe_intf *gbe_intf = intf_priv;
 	struct phy_device *phy = gbe_intf->slave->phy;
 
-	if (!phy || !phy->drv->hwtstamp) {
+	if (!phy_has_hwtstamp(phy)) {
 		switch (cmd) {
 		case SIOCGHWTSTAMP:
 			return gbe_hwtstamp_get(gbe_intf, req);
-- 
2.20.1

