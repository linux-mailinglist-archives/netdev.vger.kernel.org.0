Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3551F534B7A
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbiEZIRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346665AbiEZIQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:16:16 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CD149FB9
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:16:15 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2fed274f3fbso7281627b3.17
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LHvrfQT4UXFPIW7HvFCMhDyzwcScgNhuNK8AAkQqhh0=;
        b=ckTLEE9Ka8zRBQWZF8bw1bzPyohHSB7lFDGLGx8zTrvE1U6jlLS2u8eGVyiyeggEvU
         f2EkV92DxtJdRwumDctwEA2IQx70gREKkuzwEB+3OV15TZsv4nnJNeHpcR3jy+FuEHO1
         E+wXrf/OpSIAmM7QLQFDf1+Hl/jJe7k56R5tSxkJdxRlRw2RMnjPZSIzlQ613IfRTFOa
         Zx8mX+wckPdc1dHZYVMnSMTwB7wl2UW03yvyEnDwGVANY6EkvB+fRXiLFfl04V8Uv38Y
         DXO0NJt9s3+k0LJaHseJ6m+c87C0hU/eJug6HuK1f5WfFNhgvCbmyh04c4hNdwY8HvkX
         PXvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LHvrfQT4UXFPIW7HvFCMhDyzwcScgNhuNK8AAkQqhh0=;
        b=qCJKMIeQF4JWxjrdtiSd1N8Ws5m74cUv76rJ61zEfXuuuUHlKSd4t38vXgR0Z/477a
         4G+I77WuGuT15eO5qxXl7obhxkqR4P7yXfKZnsWoPVPNt/8Am3DJSEl7V0v5duWGl8oM
         t6ZteDi4q66fzcdVwkMw4XSsvZ6r6HMYS8flPePz8Ofk87+0FJ/1yiz2iT2f8cF2UPZj
         VCM34t8BmPrtjYAL3gv8H2meh4qonmF9FeK7uzDVZSqnV6QveMrBNxEXCmv0dlTDTH03
         tdfBSx4vjEfVonRQntRdv0WORYkgog8Z+2p9WsqEPKQ8ggSe7mHhgwqG2omiGoZxB+c1
         w+gg==
X-Gm-Message-State: AOAM5330ecjNr1q8zG+Z/gQOkxldKQUfHkqgI79T+nfBkcAx7ts4Wxjm
        CKgUSs7Oy3EXFWOU/3ZgFpcIpVHdoszSB/A=
X-Google-Smtp-Source: ABdhPJw4+9jAT07QlqTfVdN89DFF1UyFTJg5uRAxow4srxchUBWqQAUPj+CYeVjLPhmM3eADjwvBI1mMP+o/3L0=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:ff1f:a3b7:b6de:d30f])
 (user=saravanak job=sendgmr) by 2002:a25:928b:0:b0:64a:f505:427f with SMTP id
 y11-20020a25928b000000b0064af505427fmr33415597ybl.146.1653552974289; Thu, 26
 May 2022 01:16:14 -0700 (PDT)
Date:   Thu, 26 May 2022 01:15:46 -0700
In-Reply-To: <20220526081550.1089805-1-saravanak@google.com>
Message-Id: <20220526081550.1089805-8-saravanak@google.com>
Mime-Version: 1.0
References: <20220526081550.1089805-1-saravanak@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [RFC PATCH v1 7/9] driver core: Add fw_devlink_unblock_may_probe()
 helper function
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Len Brown <lenb@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        John Stultz <jstultz@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function can be used during the kernel boot sequence to forcefully
override fw_devlink=on and unblock the probing of all devices that have
a driver.

It's mainly meant to be called from late_initcall() or
late_initcall_sync() where a device needs to probe before the kernel can
mount rootfs.

Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/base/base.h    |  1 +
 drivers/base/core.c    | 58 ++++++++++++++++++++++++++++++++++++++++++
 drivers/base/dd.c      |  2 +-
 include/linux/fwnode.h |  2 ++
 4 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index ab71403d102f..b3a43a164dcd 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -160,6 +160,7 @@ extern int devres_release_all(struct device *dev);
 extern void device_block_probing(void);
 extern void device_unblock_probing(void);
 extern void deferred_probe_extend_timeout(void);
+extern void driver_deferred_probe_trigger(void);
 
 /* /sys/devices directory */
 extern struct kset *devices_kset;
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 7672f23231c1..7ff7fbb00643 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1655,6 +1655,64 @@ void fw_devlink_drivers_done(void)
 	device_links_write_unlock();
 }
 
+static int fw_devlink_may_probe(struct device *dev, void *data)
+{
+	struct device_link *link = to_devlink(dev);
+
+	if (!link->supplier->can_match && link->consumer->can_match)
+		fw_devlink_relax_link(link);
+
+	return 0;
+}
+
+/**
+ * fw_devlink_unblock_may_probe - Force unblock any device that has a driver
+ *
+ * This function is more of a sledge hammer than a scalpel. Use this very
+ * sparingly.
+ *
+ * Some devices might need to be probed and bound successfully before the kernel
+ * boot sequence can finish and move on to init/userspace. For example, a
+ * network interface might need to be bound to be able to mount a NFS rootfs.
+ *
+ * With fw_devlink=on by default, some of these devices might be blocked from
+ * probing because they are waiting on a optional supplier that doesn't have a
+ * driver. While fw_devlink will eventually identify such devices and unblock
+ * the probing automatically, it might be too late by the time it unblocks the
+ * probing of devices. For example, the IP4 autoconfig might timeout before
+ * fw_devlink unblocks probing of the network interface. This function is
+ * available to unblock the probing of such devices.
+ *
+ * Since there's no easy way to know which unprobed device needs to probe for
+ * boot to succeed, this function makes sure fw_devlink doesn't block any device
+ * that has a driver at the point in time this function is called.
+ *
+ * It does this by relaxing (fw_devlink=permissive behavior) all the device
+ * links created by fw_devlink where the consumer has a driver and the supplier
+ * doesn't have a driver.
+ *
+ * It's extremely unlikely that a proper use of this function will be outside of
+ * an initcall. So, until a case is made for that, this function is
+ * intentionally marked with __init.
+ */
+void __init fw_devlink_unblock_may_probe(void)
+{
+	struct device_link *link, *ln;
+
+	if (!fw_devlink_flags || fw_devlink_is_permissive())
+		return;
+
+	/* Wait for current probes to finish to limit impact. */
+	wait_for_device_probe();
+
+	device_links_write_lock();
+	class_for_each_device(&devlink_class, NULL, NULL,
+			      fw_devlink_may_probe);
+	device_links_write_unlock();
+
+	driver_deferred_probe_trigger();
+}
+
 static void fw_devlink_unblock_consumers(struct device *dev)
 {
 	struct device_link *link;
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index f963d9010d7f..af8138d44e6c 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -172,7 +172,7 @@ static bool driver_deferred_probe_enable;
  * changes in the midst of a probe, then deferred processing should be triggered
  * again.
  */
-static void driver_deferred_probe_trigger(void)
+void driver_deferred_probe_trigger(void)
 {
 	if (!driver_deferred_probe_enable)
 		return;
diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
index 9a81c4410b9f..0770edda7068 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -13,6 +13,7 @@
 #include <linux/list.h>
 #include <linux/bits.h>
 #include <linux/err.h>
+#include <linux/init.h>
 
 struct fwnode_operations;
 struct device;
@@ -199,5 +200,6 @@ extern bool fw_devlink_is_strict(void);
 int fwnode_link_add(struct fwnode_handle *con, struct fwnode_handle *sup);
 void fwnode_links_purge(struct fwnode_handle *fwnode);
 void fw_devlink_purge_absent_suppliers(struct fwnode_handle *fwnode);
+void __init fw_devlink_unblock_may_probe(void);
 
 #endif
-- 
2.36.1.124.g0e6072fb45-goog

