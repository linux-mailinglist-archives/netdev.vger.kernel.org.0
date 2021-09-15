Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9A940C166
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 10:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbhIOINX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 04:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237042AbhIOINM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 04:13:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDA9C0613EF
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 01:11:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id s204-20020a252cd5000000b005a16e62ee63so2577764ybs.12
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 01:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WuAb6MBtSzivvvxQ/9C3pYrE2NS/OY1FoVAPECcMVH8=;
        b=K9Yt53VW22oqgQL+/rMGeYCH6nAlDx+0sOi3uZ6egzz66Ue1dohvyJJVcpfqKb9MYT
         juYS7Kyo38+lI7/M1iZ0Z4LP1zO/geJkWdmbjD+VW46+r72EWzdWXBBjv6lwUPpwVOLJ
         RKWsGAW/YqC9HI2ozQ1evL2equN9q9opQg87fjJ1w12AJHd3SeeNoSWY3xTcAF3iCPc3
         7dMTUMxxWAs0XGTMOqf7mzVoy4VO8rAgkUmbhH7W4fbEoBAz+uanJZUcidlE8FgcVkQh
         F1Ce0/hd6ycGUBSU+woVOxO9EyU6qcaYuMYcMbN0CeJ4TKjsBOuHQ6WAbs15fhFdbdLx
         phAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WuAb6MBtSzivvvxQ/9C3pYrE2NS/OY1FoVAPECcMVH8=;
        b=AyOaJyRwVBaoKkK2Xe5DuFUguqxzK7cLE6fr+fEYGZ6nF+8kuljwnghcCJs+5At8vv
         0f6J9Rka/Ldt/C04I5GOHLlHqmzxzpKaVfLmoI9jBULxTTuXv55qoB1jrkFEQ2CRwzz8
         BWY604BloJlJ5jdOA6/Hooin80QZiKzuQTt8GwR4r/Ly5ImFTERg7LXsVYfblsDl4I4r
         wxIaGRnV4tT7lewBltKKBM1KiM4FPH4lt2Y/dnWL2v1h2szg0lrAQEYZPglqehq3+Kkj
         PLUrBOKRcFySoJImJQIh8adtqcVc0+c9UwnRQBvgGqtKwPToyEh6zqXcN9RsIB17wNtm
         LyXA==
X-Gm-Message-State: AOAM532zVCFD2cT9vzRHjHpGMcniEeEdcMoNgH9ovphkVNaytr2pgi+3
        4fR/xyDA1ha+Y3Pw3xWuC4bFVfl30I63f/k=
X-Google-Smtp-Source: ABdhPJzpQv0MpGydkOw27weKviy+9CiEfXH7nqPp8EFl39Q7uzmFnDgg1XrIHMmEKRbkXD/TsDULRd1KM9blN14=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:16d1:ab0e:fc4a:b9b1])
 (user=saravanak job=sendgmr) by 2002:a25:1b89:: with SMTP id
 b131mr4526177ybb.40.1631693506005; Wed, 15 Sep 2021 01:11:46 -0700 (PDT)
Date:   Wed, 15 Sep 2021 01:11:33 -0700
In-Reply-To: <20210915081139.480263-1-saravanak@google.com>
Message-Id: <20210915081139.480263-2-saravanak@google.com>
Mime-Version: 1.0
References: <20210915081139.480263-1-saravanak@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v2 1/6] driver core: fw_devlink: Improve handling of cyclic dependencies
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Cc:     John Stultz <john.stultz@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we have a dependency of the form:

Device-A -> Device-C
	Device-B

Device-C -> Device-B

Where,
* Indentation denotes "child of" parent in previous line.
* X -> Y denotes X is consumer of Y based on firmware (Eg: DT).

We have cyclic dependency: device-A -> device-C -> device-B -> device-A

fw_devlink current treats device-C -> device-B dependency as an invalid
dependency and doesn't enforce it but leaves the rest of the
dependencies as is.

While the current behavior is necessary, it is not sufficient if the
false dependency in this example is actually device-A -> device-C. When
this is the case, device-C will correctly probe defer waiting for
device-B to be added, but device-A will be incorrectly probe deferred by
fw_devlink waiting on device-C to probe successfully. Due to this, none
of the devices in the cycle will end up probing.

To fix this, we need to go relax all the dependencies in the cycle like
we already do in the other instances where fw_devlink detects cycles.
A real world example of this was reported[1] and analyzed[2].

[1] - https://lore.kernel.org/lkml/0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com/
[2] - https://lore.kernel.org/lkml/CAGETcx8peaew90SWiux=TyvuGgvTQOmO4BFALz7aj0Za5QdNFQ@mail.gmail.com/
Fixes: f9aa460672c9 ("driver core: Refactor fw_devlink feature")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/base/core.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index e65dd803a453..316df6027093 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1772,14 +1772,21 @@ static int fw_devlink_create_devlink(struct device *con,
 	 * be broken by applying logic. Check for these types of cycles and
 	 * break them so that devices in the cycle probe properly.
 	 *
-	 * If the supplier's parent is dependent on the consumer, then
-	 * the consumer-supplier dependency is a false dependency. So,
-	 * treat it as an invalid link.
+	 * If the supplier's parent is dependent on the consumer, then the
+	 * consumer and supplier have a cyclic dependency. Since fw_devlink
+	 * can't tell which of the inferred dependencies are incorrect, don't
+	 * enforce probe ordering between any of the devices in this cyclic
+	 * dependency. Do this by relaxing all the fw_devlink device links in
+	 * this cycle and by treating the fwnode link between the consumer and
+	 * the supplier as an invalid dependency.
 	 */
 	sup_dev = fwnode_get_next_parent_dev(sup_handle);
 	if (sup_dev && device_is_dependent(con, sup_dev)) {
-		dev_dbg(con, "Not linking to %pfwP - False link\n",
-			sup_handle);
+		dev_info(con, "Fixing up cyclic dependency with %pfwP (%s)\n",
+			 sup_handle, dev_name(sup_dev));
+		device_links_write_lock();
+		fw_devlink_relax_cycle(con, sup_dev);
+		device_links_write_unlock();
 		ret = -EINVAL;
 	} else {
 		/*
-- 
2.33.0.309.g3052b89438-goog

