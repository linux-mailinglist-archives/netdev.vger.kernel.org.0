Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023C42F068B
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 12:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbhAJLAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 06:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbhAJLAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 06:00:19 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E92C061786
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 02:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JYBm7cuxn9QeEiw/JmBzH4tRGSX1u2keYjyAagUmnJg=; b=DWhfg1uWdI8SjQ5gc00G3weMWk
        3T6Hw+ntjz8euS78ABJ/f2xN6UnmTrxYKw/2M67NB/oQrOd5F+/3gK4LKoVO/rWskEy6nWXwvy1SK
        QrU9PNC/iEvhMIp+lV00vDqLH6yW/CfJZKmchY4OB4CAVweMXbk48JV+IINiFv8CRYBkEOHVTEkAl
        14RuWbsDGns6juJSjiya/3y1Ja2uumOgMYtyg7YKKKiumEF7//SvgxnzPHTj6/mR6f4xgLdAj+7b4
        yP8cQL8TDdipvDIaE/42wDrLMDqJacS+1I2ddcnvekAgLHxa/hX4JaW4NNTQrn71JT1AUWbJUjONC
        w+AP5byQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52398 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kyYRe-0005mg-9m; Sun, 10 Jan 2021 10:59:38 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kyYRe-0004kN-3F; Sun, 10 Jan 2021 10:59:38 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH RESEND net-next] net: sfp: add debugfs support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kyYRe-0004kN-3F@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sun, 10 Jan 2021 10:59:38 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add debugfs support to SFP so that the internal state of the SFP state
machines and hardware signal state can be viewed from userspace, rather
than having to compile a debug kernel to view state state transitions
in the kernel log.  The 'state' output looks like:

Module state: empty
Module probe attempts: 0 0
Device state: up
Main state: down
Fault recovery remaining retries: 5
PHY probe remaining retries: 12
moddef0: 0
rx_los: 1
tx_fault: 1
tx_disable: 1

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 55 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 91d74c1a920a..374351de2063 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/acpi.h>
 #include <linux/ctype.h>
+#include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/gpio/consumer.h>
 #include <linux/hwmon.h>
@@ -258,6 +259,9 @@ struct sfp {
 	char *hwmon_name;
 #endif
 
+#if IS_ENABLED(CONFIG_DEBUG_FS)
+	struct dentry *debugfs_dir;
+#endif
 };
 
 static bool sff_module_supported(const struct sfp_eeprom_id *id)
@@ -1390,6 +1394,54 @@ static void sfp_module_tx_enable(struct sfp *sfp)
 	sfp_set_state(sfp, sfp->state);
 }
 
+#if IS_ENABLED(CONFIG_DEBUG_FS)
+static int sfp_debug_state_show(struct seq_file *s, void *data)
+{
+	struct sfp *sfp = s->private;
+
+	seq_printf(s, "Module state: %s\n",
+		   mod_state_to_str(sfp->sm_mod_state));
+	seq_printf(s, "Module probe attempts: %d %d\n",
+		   R_PROBE_RETRY_INIT - sfp->sm_mod_tries_init,
+		   R_PROBE_RETRY_SLOW - sfp->sm_mod_tries);
+	seq_printf(s, "Device state: %s\n",
+		   dev_state_to_str(sfp->sm_dev_state));
+	seq_printf(s, "Main state: %s\n",
+		   sm_state_to_str(sfp->sm_state));
+	seq_printf(s, "Fault recovery remaining retries: %d\n",
+		   sfp->sm_fault_retries);
+	seq_printf(s, "PHY probe remaining retries: %d\n",
+		   sfp->sm_phy_retries);
+	seq_printf(s, "moddef0: %d\n", !!(sfp->state & SFP_F_PRESENT));
+	seq_printf(s, "rx_los: %d\n", !!(sfp->state & SFP_F_LOS));
+	seq_printf(s, "tx_fault: %d\n", !!(sfp->state & SFP_F_TX_FAULT));
+	seq_printf(s, "tx_disable: %d\n", !!(sfp->state & SFP_F_TX_DISABLE));
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(sfp_debug_state);
+
+static void sfp_debugfs_init(struct sfp *sfp)
+{
+	sfp->debugfs_dir = debugfs_create_dir(dev_name(sfp->dev), NULL);
+
+	debugfs_create_file("state", 0600, sfp->debugfs_dir, sfp,
+			    &sfp_debug_state_fops);
+}
+
+static void sfp_debugfs_exit(struct sfp *sfp)
+{
+	debugfs_remove_recursive(sfp->debugfs_dir);
+}
+#else
+static void sfp_debugfs_init(struct sfp *sfp)
+{
+}
+
+static void sfp_debugfs_exit(struct sfp *sfp)
+{
+}
+#endif
+
 static void sfp_module_tx_fault_reset(struct sfp *sfp)
 {
 	unsigned int state = sfp->state;
@@ -2483,6 +2535,8 @@ static int sfp_probe(struct platform_device *pdev)
 	if (!sfp->sfp_bus)
 		return -ENOMEM;
 
+	sfp_debugfs_init(sfp);
+
 	return 0;
 }
 
@@ -2490,6 +2544,7 @@ static int sfp_remove(struct platform_device *pdev)
 {
 	struct sfp *sfp = platform_get_drvdata(pdev);
 
+	sfp_debugfs_exit(sfp);
 	sfp_unregister_socket(sfp->sfp_bus);
 
 	rtnl_lock();
-- 
2.20.1

