Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601D2485590
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236810AbiAEPOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:14:50 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:55740
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230064AbiAEPOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:14:49 -0500
Received: from localhost.localdomain (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 1D37B40037;
        Wed,  5 Jan 2022 15:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641395687;
        bh=0ahgBxDMV/FnSQcDRoTIL2XGBuHehdIW2pip+BQAyX4=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=Z6PVJZY7dhgs+tApSi3JC4Wp0iCANL67jSngJvDD0RUunWYkhaOhr0II0D5nBXOCo
         SZD9yvSVszfnPyZfptbdovyx4UvpWTqYTyI82m2nlbwdphu7kKoVZbZVopzMHsmkyZ
         bMPTArT23NQvv8BXKwqCmu9yHxKdOTp9DcGSSfd/75HAQZ/Cw0D7cqCp2uIcPYmrN9
         cp8xP2kLXbQcDyDUSaj4CblUczhcvSxcek3yMXXdonAc8QfRrH2gwrh4eRECiSikji
         TUoDrXDm3vOvw7p3EEqncgFjCc0sG/nIvtDEvX/32Bkl7r94sVoUhlAy2kchQfvGv0
         /+gVQhzbYNG6w==
From:   Aaron Ma <aaron.ma@canonical.com>
To:     aaron.ma@canonical.com, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough address
Date:   Wed,  5 Jan 2022 23:14:25 +0800
Message-Id: <20220105151427.8373-1-aaron.ma@canonical.com>
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

v2:
Skip builtin PCI MAC address which is share MAC address with
passthrough MAC.
Check thunderbolt based ethernet.

v3:
Add return value.

Fixes: f77b83b5bbab ("net: usb: r8152: Add MAC passthrough support for
more Lenovo Docks")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/usb/r8152.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f9877a3e83ac..2483dc421dff 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -25,6 +25,7 @@
 #include <linux/atomic.h>
 #include <linux/acpi.h>
 #include <linux/firmware.h>
+#include <linux/pci.h>
 #include <crypto/hash.h>
 #include <linux/usb/r8152.h>
 
@@ -1605,6 +1606,7 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 	char *mac_obj_name;
 	acpi_object_type mac_obj_type;
 	int mac_strlen;
+	struct net_device *ndev;
 
 	if (tp->lenovo_macpassthru) {
 		mac_obj_name = "\\MACA";
@@ -1662,6 +1664,19 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 		ret = -EINVAL;
 		goto amacout;
 	}
+	rcu_read_lock();
+	for_each_netdev_rcu(&init_net, ndev) {
+		if (ndev->dev.parent && dev_is_pci(ndev->dev.parent) &&
+				!pci_is_thunderbolt_attached(to_pci_dev(ndev->dev.parent)))
+			continue;
+		if (strncmp(buf, ndev->dev_addr, 6) == 0) {
+			ret = -EINVAL;
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

