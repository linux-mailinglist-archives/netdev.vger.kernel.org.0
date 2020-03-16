Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E129318617A
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 03:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729427AbgCPCOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 22:14:43 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38548 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729414AbgCPCOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 22:14:41 -0400
Received: by mail-pf1-f196.google.com with SMTP id z5so9055727pfn.5
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 19:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UAMpz/e4GcTQuZef/9GgSHmWnX1J9EGuEZiUj8i53A4=;
        b=q2Cv5aHGcSmwC8E73+u1Vr1k+oSc4A8C8oq/ZoIu1nEkBNY+5iYM8soZd2uG+mf6nF
         htF1LNdOxrsvYr1MRQxIcMPyIibDOcmFdSubPoDoPO3z7mPGDnOr9dX7Nn1qX33XXFFm
         5/VwVFVvn/v1WV8x48VvaKw3In++yPICHAvIaP9RA7so4SBN+0EdRkQLU6afjpOo/zxP
         5lk6wW9Uh7lZI1kJ0Pwfy9HR7LVmwkWxjlxs44Wm/lAcJ4c2GbsG1EG+Y3ICQLKCqhVB
         LM9p2WXDAghcITpxDYkNNO8yHgrdETDkUbRm/X2+0ErdeoCfj/F9Ia9BosouE+aQ7vKU
         1VqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UAMpz/e4GcTQuZef/9GgSHmWnX1J9EGuEZiUj8i53A4=;
        b=QhKsvjR+foaRCAjDv7slhbvFOpKCr1moxvtz0oMhrPEw2Ui0jTJbPQRAxHGI0Ji35X
         Gl0bWBlMoJFIiW6aXVmuQRHrqS+m68cmf5cKlZznnRo5aHZlFQCMS2FECBJcO5dlHxi1
         blFbR/J6Y5LNea+PLD3qE+pMQoJvDzxTsgDDfy0peOXhLFKmb14tHd0kUNdmnE7Drrfh
         sB53fKYRqk/vAVr9gad+oSazQ+qZYgfgVT0HEe6fxjp4JDoZUak7HI2m5BnGaZFPdr8X
         rNOqdEj92uJ0HpsfQM/mcFRWWhyfqO60M9IdRHCNhV2KIQ+qE+yZW7N/vUKLgVi7pnbS
         bixg==
X-Gm-Message-State: ANhLgQ36372W1aTFDQoFUyCSvNwLy9yCUvsVWcUMUw3ajQ0RsUAh7jwa
        +z5rkWyWFqKIg9J7hdwnbdDbfIkihak=
X-Google-Smtp-Source: ADFU+vtISPBE3aPrPhngsxrdyhKBVqxctg/2mHUYmLhkNaguPWvZf6r1fhz3MDapUGWTgioiiIOTcQ==
X-Received: by 2002:a65:6909:: with SMTP id s9mr23670207pgq.92.1584324880175;
        Sun, 15 Mar 2020 19:14:40 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p4sm4386142pfg.163.2020.03.15.19.14.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Mar 2020 19:14:39 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/5] ionic: return error for unknown xcvr type
Date:   Sun, 15 Mar 2020 19:14:27 -0700
Message-Id: <20200316021428.48919-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200316021428.48919-1-snelson@pensando.io>
References: <20200316021428.48919-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we don't recognize the transceiver type, return an error
so that ethtool doesn't try dumping bogus eeprom contents.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index a233716eac29..3f92f301a020 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -694,7 +694,7 @@ static int ionic_get_module_info(struct net_device *netdev,
 	default:
 		netdev_info(netdev, "unknown xcvr type 0x%02x\n",
 			    xcvr->sprom[0]);
-		break;
+		return -EINVAL;
 	}
 
 	return 0;
@@ -714,7 +714,19 @@ static int ionic_get_module_eeprom(struct net_device *netdev,
 	/* The NIC keeps the module prom up-to-date in the DMA space
 	 * so we can simply copy the module bytes into the data buffer.
 	 */
+
 	xcvr = &idev->port_info->status.xcvr;
+	switch (xcvr->sprom[0]) {
+	case 0x03: /* SFP */
+	case 0x0D: /* QSFP */
+	case 0x11: /* QSFP28 */
+		break;
+	default:
+		netdev_info(netdev, "unknown xcvr type 0x%02x\n",
+			    xcvr->sprom[0]);
+		return -EINVAL;
+	}
+
 	len = min_t(u32, sizeof(xcvr->sprom), ee->len);
 
 	do {
-- 
2.17.1

