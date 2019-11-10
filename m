Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5025F6954
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 15:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfKJOHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 09:07:55 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45774 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfKJOHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 09:07:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oAsW+6vaZ3vMQ22IWpMAq/IXQq11fFKYU/9W2qOrH9g=; b=KNrVj44Qobmp+N05mebfbPJZOF
        CL4aNuPzVCeNKrgFoJHiowpNJmlgWok+64KAEXk06Au2Ez0mzoiLhmq6w8l4oqqJreIXz337ggbai
        aizrLQm29Fg+QLHQd3Mn1WUq1Rmrq54kyuu6/qzmFdu51FnVQ64O+z5kDR6/5zhoiaC/ovy6Ok7cJ
        d+fuxh3ARLxxfTCrf1UlGDIC081j9MyqcJ2JLdv/azBw1vfgQ6kpXnPTJoc9m0FXFuzS+953MHxpi
        EqdLn9JJ4ovv6qgZ1AHzWIMbyXaZLBz0x1mKudgfLq2OsynWeyoLVgAoBCYqGZ7xB+P+TEkfLbbSE
        /kzFZHJA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:53666 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnsQ-0007fP-Uo; Sun, 10 Nov 2019 14:07:39 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iTnsN-0005CH-CM; Sun, 10 Nov 2019 14:07:35 +0000
In-Reply-To: <20191110140530.GA25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 17/17] net: sfp: allow modules with slow diagnostics
 to probe
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iTnsN-0005CH-CM@rmk-PC.armlinux.org.uk>
Date:   Sun, 10 Nov 2019 14:07:35 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a module is inserted, we attempt to read read the ID from address
0x50.  Once we are able to read the ID, we immediately attempt to
initialise the hwmon support by reading from address 0x51.  If this
fails, then we fall into error state, and assume that the module is
not usable.

Modules such as the ALCATELLUCENT 3FE46541AA use a real EEPROM for
I2C address 0x50, which responds immediately.  However, address 0x51
is an emulated, which only becomes available once the on-board firmware
has booted.  This prompts us to fall into the error state.

Since the module may be usable without diagnostics, arrange for the
hwmon probe independent of the rest of the SFP itself, retrying every
5s for up to about 60s for the monitoring to become available, and
print an error message if it doesn't become available.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 96 +++++++++++++++++++++++++++++++++----------
 1 file changed, 74 insertions(+), 22 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 68d91fae2077..69bedef96ca7 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -218,6 +218,8 @@ struct sfp {
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
+	struct delayed_work hwmon_probe;
+	unsigned int hwmon_tries;
 	struct device *hwmon_dev;
 	char *hwmon_name;
 #endif
@@ -1096,29 +1098,27 @@ static const struct hwmon_chip_info sfp_hwmon_chip_info = {
 	.info = sfp_hwmon_info,
 };
 
-static int sfp_hwmon_insert(struct sfp *sfp)
+static void sfp_hwmon_probe(struct work_struct *work)
 {
+	struct sfp *sfp = container_of(work, struct sfp, hwmon_probe.work);
 	int err, i;
 
-	if (sfp->id.ext.sff8472_compliance == SFP_SFF8472_COMPLIANCE_NONE)
-		return 0;
-
-	if (!(sfp->id.ext.diagmon & SFP_DIAGMON_DDM))
-		return 0;
-
-	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE)
-		/* This driver in general does not support address
-		 * change.
-		 */
-		return 0;
-
 	err = sfp_read(sfp, true, 0, &sfp->diag, sizeof(sfp->diag));
-	if (err < 0)
-		return err;
+	if (err < 0) {
+		if (sfp->hwmon_tries--) {
+			mod_delayed_work(system_wq, &sfp->hwmon_probe,
+					 T_PROBE_RETRY_SLOW);
+		} else {
+			dev_warn(sfp->dev, "hwmon probe failed: %d\n", err);
+		}
+		return;
+	}
 
 	sfp->hwmon_name = kstrdup(dev_name(sfp->dev), GFP_KERNEL);
-	if (!sfp->hwmon_name)
-		return -ENODEV;
+	if (!sfp->hwmon_name) {
+		dev_err(sfp->dev, "out of memory for hwmon name\n");
+		return;
+	}
 
 	for (i = 0; sfp->hwmon_name[i]; i++)
 		if (hwmon_is_bad_char(sfp->hwmon_name[i]))
@@ -1128,18 +1128,52 @@ static int sfp_hwmon_insert(struct sfp *sfp)
 							 sfp->hwmon_name, sfp,
 							 &sfp_hwmon_chip_info,
 							 NULL);
+	if (IS_ERR(sfp->hwmon_dev))
+		dev_err(sfp->dev, "failed to register hwmon device: %ld\n",
+			PTR_ERR(sfp->hwmon_dev));
+}
+
+static int sfp_hwmon_insert(struct sfp *sfp)
+{
+	if (sfp->id.ext.sff8472_compliance == SFP_SFF8472_COMPLIANCE_NONE)
+		return 0;
 
-	return PTR_ERR_OR_ZERO(sfp->hwmon_dev);
+	if (!(sfp->id.ext.diagmon & SFP_DIAGMON_DDM))
+		return 0;
+
+	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE)
+		/* This driver in general does not support address
+		 * change.
+		 */
+		return 0;
+
+	mod_delayed_work(system_wq, &sfp->hwmon_probe, 1);
+	sfp->hwmon_tries = R_PROBE_RETRY_SLOW;
+
+	return 0;
 }
 
 static void sfp_hwmon_remove(struct sfp *sfp)
 {
+	cancel_delayed_work_sync(&sfp->hwmon_probe);
 	if (!IS_ERR_OR_NULL(sfp->hwmon_dev)) {
 		hwmon_device_unregister(sfp->hwmon_dev);
 		sfp->hwmon_dev = NULL;
 		kfree(sfp->hwmon_name);
 	}
 }
+
+static int sfp_hwmon_init(struct sfp *sfp)
+{
+	INIT_DELAYED_WORK(&sfp->hwmon_probe, sfp_hwmon_probe);
+
+	return 0;
+}
+
+static void sfp_hwmon_exit(struct sfp *sfp)
+{
+	cancel_delayed_work_sync(&sfp->hwmon_probe);
+}
 #else
 static int sfp_hwmon_insert(struct sfp *sfp)
 {
@@ -1149,6 +1183,15 @@ static int sfp_hwmon_insert(struct sfp *sfp)
 static void sfp_hwmon_remove(struct sfp *sfp)
 {
 }
+
+static int sfp_hwmon_init(struct sfp *sfp)
+{
+	return 0;
+}
+
+static void sfp_hwmon_exit(struct sfp *sfp)
+{
+}
 #endif
 
 /* Helpers */
@@ -1485,10 +1528,6 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	if (ret < 0)
 		return ret;
 
-	ret = sfp_hwmon_insert(sfp);
-	if (ret < 0)
-		return ret;
-
 	return 0;
 }
 
@@ -1637,6 +1676,15 @@ static void sfp_sm_module(struct sfp *sfp, unsigned int event)
 	case SFP_MOD_ERROR:
 		break;
 	}
+
+#if IS_ENABLED(CONFIG_HWMON)
+	if (sfp->sm_mod_state >= SFP_MOD_WAITDEV &&
+	    IS_ERR_OR_NULL(sfp->hwmon_dev)) {
+		err = sfp_hwmon_insert(sfp);
+		if (err)
+			dev_warn(sfp->dev, "hwmon probe failed: %d\n", err);
+	}
+#endif
 }
 
 static void sfp_sm_main(struct sfp *sfp, unsigned int event)
@@ -1938,6 +1986,8 @@ static struct sfp *sfp_alloc(struct device *dev)
 	INIT_DELAYED_WORK(&sfp->poll, sfp_poll);
 	INIT_DELAYED_WORK(&sfp->timeout, sfp_timeout);
 
+	sfp_hwmon_init(sfp);
+
 	return sfp;
 }
 
@@ -1945,6 +1995,8 @@ static void sfp_cleanup(void *data)
 {
 	struct sfp *sfp = data;
 
+	sfp_hwmon_exit(sfp);
+
 	cancel_delayed_work_sync(&sfp->poll);
 	cancel_delayed_work_sync(&sfp->timeout);
 	if (sfp->i2c_mii) {
-- 
2.20.1

