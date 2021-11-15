Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 618EA450123
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 10:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237536AbhKOJYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 04:24:14 -0500
Received: from mx1.tq-group.com ([93.104.207.81]:12298 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237590AbhKOJXf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 04:23:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1636968041; x=1668504041;
  h=from:to:cc:subject:date:message-id;
  bh=9cFyr0y761pT/zVc4s7vOYwjjT571s07IyHIJLr/+MU=;
  b=pczY0aIE0g8DKelIfHjTH/kPaNn0xLrhFV+0BxcbtEtqSjy9CmpaUUj8
   2+GhkWRV9gi7nBXzVXXjWsiLMpWpcw6McZ8ZG9Xv2+wKf55a/9VhQye06
   QcUSLtpDn2xiRuawltVvqIVGYWP/aZnHfKoxVFZyo/zIFkppdY5r5Vfgt
   HA9xrbLckz1+qAtYqe1VzZQNckr74i07SqDu6Bg+c4fBNPaKt1FkT5m7M
   Pf9B4Cc/et2B2Zv5y60W8IiDdp9gIaDTFfRMhXQIVc3i9/sagSdOZpjju
   3aP9mGsmpVi9+QWHNpwb+0g7KyTM+aIPd2PLImD7xZU6C9Bl+T9lLOwMf
   w==;
X-IronPort-AV: E=Sophos;i="5.87,236,1631570400"; 
   d="scan'208";a="20459392"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 15 Nov 2021 10:20:19 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 15 Nov 2021 10:20:19 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 15 Nov 2021 10:20:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1636968019; x=1668504019;
  h=from:to:cc:subject:date:message-id;
  bh=9cFyr0y761pT/zVc4s7vOYwjjT571s07IyHIJLr/+MU=;
  b=VCWRnF0mHtbUxKzKlOLw/E05vf6qDAQp+V7XFiroaIrrJj/aR6puVzDI
   +cL62+Hu60axwM9DNH82AZdGHJBf0ilqo8tDrIAFXnTimgIg2d98CqGot
   SDAEFS4jmFdRL/jCrxea+D148ESf5LpzOMJt9nBhntFoRNlqzgAZLVfA5
   fwahpJmpnN9L+s+LZTneAkKaUhHXHawwfSJ3SLUkNUKYClnsbPhMSMk+9
   xl5NGn9NXA8tBluMb/R6P3/lTxnnGyqlBxqwSvderqWEHxFDRqYZ3qh6t
   Apcg+anj63UH6x2D8AyhzScdOyOBKf9KtyNiPILkrWw42XihUSQn73uyw
   w==;
X-IronPort-AV: E=Sophos;i="5.87,236,1631570400"; 
   d="scan'208";a="20459391"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 15 Nov 2021 10:20:19 +0100
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id E8FA4280075;
        Mon, 15 Nov 2021 10:20:18 +0100 (CET)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Felipe Balbi (Intel)" <balbi@kernel.org>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH net 1/4] can: m_can: pci: fix incorrect reference clock rate
Date:   Mon, 15 Nov 2021 10:18:49 +0100
Message-Id: <c9cf3995f45c363e432b3ae8eb1275e54f009fc8.1636967198.git.matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
In-Reply-To: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
References: <cover.1636967198.git.matthias.schiffer@ew.tq-group.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When testing the CAN controller on our Ekhart Lake hardware, we
determined that all communication was running with twice the configured
bitrate. Changing the reference clock rate from 100MHz to 200MHz fixed
this. Intel's support has confirmed to us that 200MHz is indeed the
correct clock rate.

Fixes: cab7ffc0324f ("can: m_can: add PCI glue driver for Intel Elkhart Lake")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/net/can/m_can/m_can_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can_pci.c b/drivers/net/can/m_can/m_can_pci.c
index 89cc3d41e952..d3c030a13cbe 100644
--- a/drivers/net/can/m_can/m_can_pci.c
+++ b/drivers/net/can/m_can/m_can_pci.c
@@ -18,7 +18,7 @@
 
 #define M_CAN_PCI_MMIO_BAR		0
 
-#define M_CAN_CLOCK_FREQ_EHL		100000000
+#define M_CAN_CLOCK_FREQ_EHL		200000000
 #define CTL_CSR_INT_CTL_OFFSET		0x508
 
 struct m_can_pci_priv {
-- 
2.17.1

