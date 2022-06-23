Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA91E5574F0
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 10:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiFWII2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 04:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiFWIIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 04:08:13 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956E2167EC
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 01:08:10 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 92-20020a17090a09e500b001d917022847so6710940pjo.1
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 01:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zZJrI+RbMRkrmHfhlt/j/MmMDuQlYzWrcboe4IkTaNE=;
        b=X3cn1S0CzIm4FWlNm7Ryg2/2EhJ00v8hxnIIDKiY0q1xKgtQnRGMiDKSXOEkZbvZhP
         4uuCwD503iseCprVScSWZ4pQAjCrhi5cSXg2767cmkjO+dH6ZtTzMD8IgkJml4P1nS5Y
         KRkC8Q3fbKTSbVuwwYgY40M7YBq7K4GfinxXw1gKkP9ckyTCf5jZEnxIrlT4m5ctvBId
         aFDhAWxWEib2HfJK+X0wU6lZpwgwBLpDzcd7ufJxyOwRN0hhKAFrayM0jxIwcjjWVfRA
         dKJY5P21I5RqGps1wnOhf0Q0ky3RmaD6EK6D2UEz4teRjKPN/KhAkLDsA4wB4nGaqEqu
         RHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zZJrI+RbMRkrmHfhlt/j/MmMDuQlYzWrcboe4IkTaNE=;
        b=l1HgSyqUkXIQcwDs1meqYY+gj+nJeY+RA2X0FV6jHCymjbdmD4OfIPRFSg28DJWV4H
         5w0B9OlQtj7wUhSX/fow4SAuW52IGss59LuJB5KOwIhfvn3sah8ywVd2Hz/VZEWWfe/Q
         b2BpTIdtc/2dNEPebML+L15Ze2CzQkFYMQwegKBQcQ3PEKOB51+ZmYCQRJcIFGxwtp7C
         eqTDwJyY1DDARoYyMAyWe5fIcmFImbG5FYpOkuYWFU+N7kIN14fFwP1v6KVavmyUgIuG
         60w9hXiQ7qth7TjCrYntxLP5NwAZuG3Axg812tE/Jvv4Ia/qE7vpJujqcSMgsxcz5llS
         gvng==
X-Gm-Message-State: AJIora+ejfB81s2AGSPljfMpQCncY2eoluzFOYvjFIHFYGlBvaZDXnY9
        aKQEb3s2TmH6SfvrXf/XDxn5jjflBRcJ7Ro=
X-Google-Smtp-Source: AGRyM1tnEDDd6vXWrrgmwo6F71ebTbd/zg3maYPwEQqNaZ5fOSmTNlY8C2FC3Fw0+TpkwTsE/6rFVWhkzcP3DDw=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:8b2d:9894:73a4:8e1f])
 (user=saravanak job=sendgmr) by 2002:a17:902:8309:b0:167:9a4c:cd58 with SMTP
 id bd9-20020a170902830900b001679a4ccd58mr37342398plb.166.1655971689836; Thu,
 23 Jun 2022 01:08:09 -0700 (PDT)
Date:   Thu, 23 Jun 2022 01:03:42 -0700
In-Reply-To: <20220623080344.783549-1-saravanak@google.com>
Message-Id: <20220623080344.783549-2-saravanak@google.com>
Mime-Version: 1.0
References: <20220623080344.783549-1-saravanak@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v2 1/2] driver core: fw_devlink: Allow firmware to mark
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
Cc:     sascha hauer <sha@pengutronix.de>, peng fan <peng.fan@nxp.com>,
        kevin hilman <khilman@kernel.org>,
        ulf hansson <ulf.hansson@linaro.org>,
        len brown <len.brown@intel.com>, pavel machek <pavel@ucw.cz>,
        joerg roedel <joro@8bytes.org>, will deacon <will@kernel.org>,
        andrew lunn <andrew@lunn.ch>,
        heiner kallweit <hkallweit1@gmail.com>,
        russell king <linux@armlinux.org.uk>,
        "david s. miller" <davem@davemloft.net>,
        eric dumazet <edumazet@google.com>,
        jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>,
        linus walleij <linus.walleij@linaro.org>,
        hideaki yoshifuji <yoshfuji@linux-ipv6.org>,
        david ahern <dsahern@kernel.org>, kernel-team@android.com,
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
Tested-by: Peng Fan <peng.fan@nxp.com>
---
 drivers/base/core.c    | 3 ++-
 include/linux/fwnode.h | 4 ++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 839f64485a55..ccdd5b4295de 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -968,7 +968,8 @@ static void device_links_missing_supplier(struct device *dev)
 
 static bool dev_is_best_effort(struct device *dev)
 {
-	return fw_devlink_best_effort && dev->can_match;
+	return (fw_devlink_best_effort && dev->can_match) ||
+		(dev->fwnode && (dev->fwnode->flags & FWNODE_FLAG_BEST_EFFORT));
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

