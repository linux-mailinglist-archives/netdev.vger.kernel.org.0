Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10ECD485448
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240649AbiAEOYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:24:23 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:38698
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237053AbiAEOYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:24:22 -0500
Received: from localhost.localdomain (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 7531F3F128;
        Wed,  5 Jan 2022 14:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641392657;
        bh=dJNzo6SiEX3Gi2Px27mlhp0zXbiR0HYOw7Oc0LeGGYk=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=BS+cqfzePlG5R2ww5lIIQJG+/eqlqmS2rkXQduVdDXRSObQBbMm9EdFWmec764uN9
         1xg2bpmr+SanyRiZkeqkWnTQak6n29A9miGhJtvGMoj87R+5v361H/O68S+QF5rWvp
         DEfOmpaChmKC/fnKMn1zNQTlz6slEhlPSGNo0/RpKTnwPHg6hyXAl1aSwFkXKWrhs0
         bQCt5akOENIh1HlxwSRqeCaEioYeWBxv1H9GzyjAfGe9hAyRtY3BfDLoMJgANKBbGJ
         EZfJU+2ii4Cv1m9djlXa7FB1OjwcoluS7ILF75iWHlVs2Ju4Qkkj4bL1f7OP5KYXh+
         Zxxwr8yyxaeCQ==
From:   Aaron Ma <aaron.ma@canonical.com>
To:     aaron.ma@canonical.com, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: [PATCH 1/3] net: usb: r8152: Check used MAC passthrough address
Date:   Wed,  5 Jan 2022 22:23:49 +0800
Message-Id: <20220105142351.8026-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When plugin multiple r8152 ethernet dongles to Lenovo Docks
or USB hub, MAC passthrough address from BIOS should be
checked if it had been used to avoid using on other dongles.

Skip builtin PCI MAC address which is share MAC address with
passthrough MAC.
Check thunderbolt based ethernet.

Currently builtin r8152 on Dock still can't be identified.
First detected r8152 will use the MAC passthrough address.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/usb/r8152.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f9877a3e83ac..91f4b2761f8e 100644
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
@@ -1662,6 +1664,18 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 		ret = -EINVAL;
 		goto amacout;
 	}
+	rcu_read_lock();
+	for_each_netdev_rcu(&init_net, ndev) {
+		if (ndev->dev.parent && dev_is_pci(ndev->dev.parent) &&
+				!pci_is_thunderbolt_attached(to_pci_dev(ndev->dev.parent)))
+			continue;
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

