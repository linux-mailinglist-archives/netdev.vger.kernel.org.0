Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4363075B28
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 01:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfGYXPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 19:15:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54588 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbfGYXPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 19:15:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so46337795wme.4
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 16:15:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ck441Qj9jL1H01OefMYtBUDrpsMMGmY/zScqF+3gCpk=;
        b=rDlUeW5iaDnlsWK5awpqiALj97h3/74PB6UOlTiZLmjSn0Xq8p6rKkO3epQJA2LAwa
         pH9u+qm2gE/QNyXhDZrtmx8TEBTNgi45YBUuZyDvgyfsrhU4HnbLcYoVEc/+JMhCOb4s
         V0ZrXq/7Xhmf7tCO6qdCp9k9BgmMZciOWXszRF9jVHUMNDByOsI7Os+CLx5Lk/wVir9O
         kHsrNtiCwHBpDk9VjLzZDaUmLIOWwyGr5mZRDDuVaa5bveXiJuhL+JtamJjhF/MAietD
         IdDF8X/QhvKgECX0rP/G0zRdCcRDVNotONkEesLYfc8fFx6cusSVpIkMNmquWXBBgwTJ
         8Pbg==
X-Gm-Message-State: APjAAAWSgEGqB66dHKkRDmPGaIpf9PAEbbxLzFLCLuJX8k/CfEfUOIFY
        ezflGWMhPFpJn1HMhKtGeIgXlkpwy98=
X-Google-Smtp-Source: APXvYqytyJUpKevgoV3T4HW3iBeKwgkT4O3GKaE9aTEYwfBtFogyYBWWmoBnzhNSuDlKhf6m2MvUoA==
X-Received: by 2002:a1c:f90f:: with SMTP id x15mr4620092wmh.69.1564096551576;
        Thu, 25 Jul 2019 16:15:51 -0700 (PDT)
Received: from mcroce-redhat.homenet.telecomitalia.it (host21-50-dynamic.21-87-r.retail.telecomitalia.it. [87.21.50.21])
        by smtp.gmail.com with ESMTPSA id v23sm44657202wmj.32.2019.07.25.16.15.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 16:15:50 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] mvpp2: document HW checksum behaviour
Date:   Fri, 26 Jul 2019 01:15:46 +0200
Message-Id: <20190725231546.23878-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware can only offload checksum calculation on first port due to
the Tx FIFO size limitation. Document this in a comment.

Fixes: 576193f2d579 ("net: mvpp2: jumbo frames support")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d8e5241097a9..2f7286bd203b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -843,7 +843,10 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
 		/* Add port to new short & long pool */
 		mvpp2_swf_bm_pool_init(port);
 
-		/* Update L4 checksum when jumbo enable/disable on port */
+		/* Update L4 checksum when jumbo enable/disable on port.
+		 * Only port 0 supports hardware checksum offload due to
+		 * the Tx FIFO size limitation.
+		 */
 		if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
 			dev->features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
 			dev->hw_features &= ~(NETIF_F_IP_CSUM |
-- 
2.21.0

