Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF824379AB
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 17:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbhJVPQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 11:16:03 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:42653 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbhJVPQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 11:16:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1634915625; x=1666451625;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0pgSFMhFrjUwp8nUnDZv1E2iTrfi+4h7xkTesoJnttA=;
  b=kzgiyll2hBme7qBeqYylCSKA91vAzbt+UjoAEaCvVrV6UR2oRNuj2VUF
   +dad6v2uMxS9jga/DjScnw9EaTlmXg5jw4TQKycsql5CpMBAsvu+ZVdtf
   mQE2L/t5AZyJ60ZwAY/qQgS3Jd//MrkWk0wCE4V191kxfWUhdYehon3D9
   NrfD6P8Grw8wj70Bg6y9MHGpkfOvSt/v+4lUvcxZDx7PR2QokAwR+kb00
   Q+cffC/KO8BUzhRhIPb94pIKoGG22NWKXjQMc4l5Iwy0yY5/gVcdOs0fc
   wZGANqalahNPDtx4A+rJsHxvKlgNyKlMOiLwP7Zs7ap/Ne5q5lxsTkdKB
   A==;
IronPort-SDR: Ss6X8wYeLFLk1NWJmZOJoQyv3MeOHpX/Wsxj+Milba3Xs9xe3XaxzVlGE6T0/ewbzu28/hK5eu
 tXYbn7TllAd6L6ChM/rOv8OP2TOyOJj+DMX69bZPXXYQTPtP6V1lAe9Gdnx+00zCsNNrnkGvbL
 CMCDztRgNGrPOttQJjmjRg9yDfrbH0RTCorycMzYWRfdpWoxBwnsk4RTk34h80NiI9AdfnVy1U
 qWxOYrq+PS+83sFU1znVNkiPsIt0B+xPnodt08HmeAmvsahK7WVRm7tOmwiS+WCInRvqOepNoi
 lAhAKpfU6jQTiZSs3raPgioB
X-IronPort-AV: E=Sophos;i="5.87,173,1631602800"; 
   d="scan'208";a="141365468"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Oct 2021 08:13:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 22 Oct 2021 08:13:45 -0700
Received: from validation1-XPS-8900.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 22 Oct 2021 08:13:44 -0700
From:   Yuiko Oshino <yuiko.oshino@microchip.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <bryan.whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>,
        "Yuiko Oshino" <yuiko.oshino@microchip.com>
Subject: [PATCH net] net: ethernet: microchip: lan743x: Fix driver crash when lan743x_pm_resume fails
Date:   Fri, 22 Oct 2021 11:13:53 -0400
Message-ID: <20211022151353.89908-1-yuiko.oshino@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver needs to clean up and return when the initialization fails on resume.

Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x driver")
Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 03d02403c19e..3f8cce7cce77 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3019,6 +3019,8 @@ static int lan743x_pm_resume(struct device *dev)
 	if (ret) {
 		netif_err(adapter, probe, adapter->netdev,
 			  "lan743x_hardware_init returned %d\n", ret);
+		lan743x_pci_cleanup(adapter);
+		return ret;
 	}
 
 	/* open netdev when netdev is at running state while resume.
-- 
2.25.1

