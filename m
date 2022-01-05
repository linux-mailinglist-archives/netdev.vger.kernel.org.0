Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540F7484E47
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 07:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiAEGTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 01:19:00 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:33450
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232071AbiAEGSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 01:18:12 -0500
Received: from localhost.localdomain (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id B7C9F3F118;
        Wed,  5 Jan 2022 06:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641363491;
        bh=susPpOXdW3sPmuZ++MaBrHyoO48nzh+p35//AkrGgmY=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=E0BvXRLluxfjiI6ndBfdyeDrkCq3Wd6BMNhIsYCWWdklGWqxObhgIVrRHNAoPolpP
         inuF3kUOT18W7QkmJKQBZLGdIrOg+qL5FIAqHJo7V9lQka7g5RrUWLARATnM2zxqPR
         fQ1tgrM7KkHHeMYeHIvhJ/IQGWcm+xPhQd1CRJRSFhdkaH05WYve8Ey5JaG/4lEgjG
         AgAL/2yaO/iI4li/jm7BLQ1r11Ban1qlIEwsViXf8LEjDAeqd9pgTVL/cpK6ISrzOp
         EJu6YBzqIH7ajnVcqgp0zsRxyIu/qaoUKHUM7NuYq1lRd3d5PgudihNdUXC7pYDNa7
         j5DoJoIzNiotw==
From:   Aaron Ma <aaron.ma@canonical.com>
To:     aaron.ma@canonical.com, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: [PATCH] net: usb: r8152: Check used MAC passthrough address
Date:   Wed,  5 Jan 2022 14:17:47 +0800
Message-Id: <20220105061747.7104-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When plugin multiple r8152 ethernet dongles to Lenovo Docks
or USB hub, MAC passthrough address from BIOS should be
checked if it had been used to avoid using on other dongles.

Currently builtin r8152 on Dock still can't be identified.
First detected r8152 will use the MAC passthrough address.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/usb/r8152.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f9877a3e83ac..77f11b3f847b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1605,6 +1605,7 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 	char *mac_obj_name;
 	acpi_object_type mac_obj_type;
 	int mac_strlen;
+	struct net_device *ndev;
 
 	if (tp->lenovo_macpassthru) {
 		mac_obj_name = "\\MACA";
@@ -1662,6 +1663,15 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 		ret = -EINVAL;
 		goto amacout;
 	}
+	rcu_read_lock();
+	for_each_netdev_rcu(&init_net, ndev) {
+		if (strncmp(buf, ndev->dev_addr, 6) == 0) {
+			rcu_read_unlock();
+			goto amacout;
+		}
+	}
+	rcu_read_unlock();
+
 	memcpy(sa->sa_data, buf, 6);
 	netif_info(tp, probe, tp->netdev,
 		   "Using pass-thru MAC addr %pM\n", sa->sa_data);
-- 
2.30.2

