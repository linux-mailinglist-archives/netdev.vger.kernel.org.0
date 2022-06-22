Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF7D556E33
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 00:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357349AbiFVV7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 17:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343724AbiFVV72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 17:59:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CE611C26
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 14:59:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m68-20020a253f47000000b006683bd91962so15707981yba.0
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 14:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TSYl2OnOPgIUVM0FnB5YWNZt0eip9Aey9fKvGeEIZ6c=;
        b=JuE5h9PD/539bkLCq5oHJhFDYzn1+YXoF+StWjq3SnT0H3RGIb3TdrcC6p2RLeJH3R
         bTIkxwMMK0AiiTTVWJr1bnvrB7sBe9i/YUJdVTUH8qCKJ6CBcy1T2AWoZC86vVyizDWt
         oGTf9T9Yk+Q1+GAdEjZWRFbG7dcw+Il6FZRB0YrQPlamrfx8M/FzcnHMkQsb8QcICNuF
         xzcttoR+dnJQmlgVy6prUYYejJtZ/WT42YW3hnr93OrR/Q5Ta/bi8BEVNuipIYaI5OO4
         8TmehohCKJnlYSQ3X9idRWuSjlYJiiVtcPtrwZ5dzjZpzQj1Q8FzEj9aHCcNtsFaA+uN
         zAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TSYl2OnOPgIUVM0FnB5YWNZt0eip9Aey9fKvGeEIZ6c=;
        b=r8BLtRyIS6Vm7XhXzQaBq96YssHZpeabNwy9EEyBcCUFZTQ0UWUjdNSbcT+KbNBD3l
         VDLUXoIYHb10J1R3zFJWUYQ3wenKY8P2AaRHGhOm1QW9YlWS1LRDzDsBQhb0fmh0kBf5
         tThcNscoOia/jxc+wHjQRoJqHpjei7M7j5tj5e5gW/3Wpx4tYJnbrkD64XoPnkaw4KEt
         xNpbgAab6A6OOVwuI/gIwj2e8yqnXzItCTmZuPHMwS3Kd/Au7g4otm87m05jX/3YI77s
         1icpKcqApvWqUZNMW68j+UASKLctW4EJXAuI9DcmYZ6olVXwnjxcAEx4n25zYUg5g2xV
         YaHQ==
X-Gm-Message-State: AJIora9veWgdn96UBZH1a7p7TZpUskqt2+us7ZMRPvBp43ztPgE7Z9zY
        cKKGod4wzKuo2bbExd6XPfJoabL6lw7BzFk=
X-Google-Smtp-Source: AGRyM1u/ogeLy4+AFU9N+Uu+j4V9K9r4kJbRFsYGWYib4JKBkDIXDu12JK70RoVFkDx+eINHtoU6HV2JImNGlxs=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:be1f:89ac:a37d:6bb4])
 (user=saravanak job=sendgmr) by 2002:a81:ff08:0:b0:317:7e90:8910 with SMTP id
 k8-20020a81ff08000000b003177e908910mr6784104ywn.417.1655935160200; Wed, 22
 Jun 2022 14:59:20 -0700 (PDT)
Date:   Wed, 22 Jun 2022 14:59:10 -0700
In-Reply-To: <20220622215912.550419-1-saravanak@google.com>
Message-Id: <20220622215912.550419-2-saravanak@google.com>
Mime-Version: 1.0
References: <20220622215912.550419-1-saravanak@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v1 1/2] driver core: fw_devlink: Allow firmware to mark
 devices as best effort
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Cc:     Sascha Hauer <sha@pengutronix.de>, Peng Fan <peng.fan@nxp.com>,
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
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org
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

When firmware sets the FWNODE_FLAG_BEST_EFFORT flag for a fwnode,
fw_devlink will do a best effort ordering for that device where it'll
only enforce the probe/suspend/resume ordering of that device with
suppliers that have drivers. The driver of that device can then decide
if it wants to defer probe or probe without the suppliers.

This will be useful for avoid probe delays of the console device that
were caused by commit 71066545b48e ("driver core: Set
fw_devlink.strict=1 by default").

Fixes: 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
Reported-by: Sascha Hauer <sha@pengutronix.de>
Reported-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/base/core.c    | 3 ++-
 include/linux/fwnode.h | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 839f64485a55..61edd18b7bf3 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -968,7 +968,8 @@ static void device_links_missing_supplier(struct device *dev)
 
 static bool dev_is_best_effort(struct device *dev)
 {
-	return fw_devlink_best_effort && dev->can_match;
+	return (fw_devlink_best_effort && dev->can_match) ||
+		dev->fwnode->flags & FWNODE_FLAG_BEST_EFFORT;
 }
 
 /**
diff --git a/include/linux/fwnode.h b/include/linux/fwnode.h
index 9a81c4410b9f..89b9bdfca925 100644
--- a/include/linux/fwnode.h
+++ b/include/linux/fwnode.h
@@ -27,11 +27,15 @@ struct device;
  *			     driver needs its child devices to be bound with
  *			     their respective drivers as soon as they are
  *			     added.
+ * BEST_EFFORT: The fwnode/device needs to probe early and might be missing some
+ *		suppliers. Only enforce ordering with suppliers that have
+ *		drivers.
  */
 #define FWNODE_FLAG_LINKS_ADDED			BIT(0)
 #define FWNODE_FLAG_NOT_DEVICE			BIT(1)
 #define FWNODE_FLAG_INITIALIZED			BIT(2)
 #define FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD	BIT(3)
+#define FWNODE_FLAG_BEST_EFFORT			BIT(4)
 
 struct fwnode_handle {
 	struct fwnode_handle *secondary;
-- 
2.37.0.rc0.161.g10f37bed90-goog

