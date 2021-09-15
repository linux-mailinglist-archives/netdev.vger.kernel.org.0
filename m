Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F58B40CB73
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 19:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhIORLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 13:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhIORLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 13:11:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D4BBC061764
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:09:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b84-20020a253457000000b0059e6b730d45so4528921yba.6
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2lJ0J4500ZYIhX1EYV/ZexmHeXs7PML1pzFGBHjPm2U=;
        b=nI3Ht9LVInk1Tm3cGHj65FkLZwg8om+aKaHWFC3J/iqkNimaavtGddierU0U/LNH2v
         99P343QiRJrpY2aYxf2G+emGzD7pHJEz8hWTHXDkX//2G6QBCvR/DyVnepVITg44m05L
         QQgtoomCzoO9bxa5fEdFcGYLLg8oJKoferC6gSwkXg9mJInH2HADJScJbYBWP8LPre9k
         0Vt4fQoAauE+bvxgXld+nvBTiQl2rdgsOfY9TT+/+54XCNsfE8J4ACkTV/cAJ3MOVbHf
         +vbj6S4wNwrHt84hDokzcoSzR2PqV4HgJGgITx86IIWI1fWASseP+bzk5LnH/THpXJ0i
         zhjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2lJ0J4500ZYIhX1EYV/ZexmHeXs7PML1pzFGBHjPm2U=;
        b=Rsf2vp/yRSEwxe7bo2SLI9OxRw2CAPvcCIiDaVc9yEx5mYcyEPFX11PdvjFfYMvvN1
         ljuaVDr6Lp0SYz8Iem3dwH9GPhMTjWi+vmqO5j1tQAjch2rTKreKQeBxtDpyFQVWM3Sx
         NhGG2eL2+pbE7N92O0UjID+oDL7PWIlbsQfE+LqZjokPqgCjDjLbDHyBxExemmWcys7P
         /CySiO7HeMllsMftMAy+p9i8I0Lfqo7/9bDgDNXvRIWH0C73hMKY60ybxLvP9F3QzU+b
         XxTzjkbd+RoFRsxu8Z/siCHzwCQGkysk9y/9j/1rlEU5jSOeIVAZdxQJczTxMyrkFZR6
         kBeA==
X-Gm-Message-State: AOAM532e8Xf4xAwuZUgcgXWj7li0bjY2I546PfjtEuCM/8PYH5SqlCsA
        HMIpuz94lSL/Hm8ySQ7KHigE1VdwGH3WkWQ=
X-Google-Smtp-Source: ABdhPJzajoUWYGw9XTDVj89C0KnB5ylhkI12ge/OdvhJfcN8kj38fwKy6OfgQ4NxRDOpj1WyMWcSbTnO/1Dq35I=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:16d1:ab0e:fc4a:b9b1])
 (user=saravanak job=sendgmr) by 2002:a25:bacd:: with SMTP id
 a13mr1389689ybk.216.1631725792265; Wed, 15 Sep 2021 10:09:52 -0700 (PDT)
Date:   Wed, 15 Sep 2021 10:09:38 -0700
In-Reply-To: <20210915170940.617415-1-saravanak@google.com>
Message-Id: <20210915170940.617415-3-saravanak@google.com>
Mime-Version: 1.0
References: <20210915170940.617415-1-saravanak@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v3 2/3] driver core: fw_devlink: Add support for FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a parent device is also a supplier to a child device, fw_devlink=on by
design delays the probe() of the child device until the probe() of the
parent finishes successfully.

However, some drivers of such parent devices (where parent is also a
supplier) expect the child device to finish probing successfully as soon as
they are added using device_add() and before the probe() of the parent
device has completed successfully. One example of such a case is discussed
in the link mentioned below.

Add a flag to make fw_devlink=on not enforce these supplier-consumer
relationships, so these drivers can continue working.

Link: https://lore.kernel.org/netdev/CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com/
Fixes: ea718c699055 ("Revert "Revert "driver core: Set fw_devlink=on by default""")
Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/base/core.c    | 19 +++++++++++++++++++
 include/linux/fwnode.h | 11 ++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 316df6027093..21d4cb5d3767 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1722,6 +1722,25 @@ static int fw_devlink_create_devlink(struct device *con,
 	struct device *sup_dev;
 	int ret = 0;
 
+	/*
+	 * In some cases, a device P might also be a supplier to its child node
+	 * C. However, this would defer the probe of C until the probe of P
+	 * completes successfully. This is perfectly fine in the device driver
+	 * model. device_add() doesn't guarantee probe completion of the device
+	 * by the time it returns.
+	 *
+	 * However, there are a few drivers that assume C will finish probing
+	 * as soon as it's added and before P finishes probing. So, we provide
+	 * a flag to let fw_devlink know not to delay the probe of C until the
+	 * probe of P completes successfully.
+	 *
+	 * When such a flag is set, we can't create device links where P is the
+	 * supplier of C as that would delay the probe of C.
+	 */
+	if (sup_handle->flags & FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD &&
+	    fwnode_is_ancestor_of(sup_handle, con->fwnode))
+		return -EINVAL;
+
 	sup_dev = get_dev_from_fwnode(sup_handle);
 	if (sup_dev) {
 		/*
diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
index 59828516ebaf..9f4ad719bfe3 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -22,10 +22,15 @@ struct device;
  * LINKS_ADDED:	The fwnode has already be parsed to add fwnode links.
  * NOT_DEVICE:	The fwnode will never be populated as a struct device.
  * INITIALIZED: The hardware corresponding to fwnode has been initialized.
+ * NEEDS_CHILD_BOUND_ON_ADD: For this fwnode/device to probe successfully, its
+ *			     driver needs its child devices to be bound with
+ *			     their respective drivers as soon as they are
+ *			     added.
  */
-#define FWNODE_FLAG_LINKS_ADDED		BIT(0)
-#define FWNODE_FLAG_NOT_DEVICE		BIT(1)
-#define FWNODE_FLAG_INITIALIZED		BIT(2)
+#define FWNODE_FLAG_LINKS_ADDED			BIT(0)
+#define FWNODE_FLAG_NOT_DEVICE			BIT(1)
+#define FWNODE_FLAG_INITIALIZED			BIT(2)
+#define FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD	BIT(3)
 
 struct fwnode_handle {
 	struct fwnode_handle *secondary;
-- 
2.33.0.309.g3052b89438-goog

