Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842CB40CB70
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 19:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhIORLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 13:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhIORLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 13:11:08 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA57BC061764
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:09:49 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id j27-20020a05620a0a5b00b0042874883070so5583344qka.19
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SK0Awx6gBdtKUkOkh7F3holwbySWbAOSfl3fXGrSMFk=;
        b=j/6JMqqVwtPJr2PuYNwQ9wHyUtwghqpcHDRgXk+GpqAzIOKLLlEezdzFBuFFcvA3bk
         lFWUqD4frWgBGCCe5sqKyNW9RTDZkP5GBw+rmHvsu78Kqu3BZ9BFR6OLgKh0+OdBAZ77
         LMXJdaaUkF5RaBueu/TL8CHaIDou4p6a4kLpK87FJW3yiy5bAuZylth0AtGOwEDzBt/0
         RsnqKLvC7W7ZiPQ+7OPB8fpQxfbzYXS34akl0jznUoy+gFauKX3DjrXQQAYh5A7nD39E
         0xtxj7UWDMDfs9lkdv7KBSW1SMh1Uy0qu+e3rf6A6rn9bVwdSYkvFNqs6oFWhtUj27rr
         KTzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SK0Awx6gBdtKUkOkh7F3holwbySWbAOSfl3fXGrSMFk=;
        b=BF1tiHqMGIOQBNheBQjtQqHB3HjkJibxQSO75GHfnnxerzXZGMEGJxGKXoSywzM6ry
         eHPsrNQMF8R6F/nTkbjDu/wOoPyaIGq1bKrZdEwBwgGR3cQxbs8Cib1/m490yDnChbfG
         YS8wjnIiXu93zBh6BhxB/R7wbH8LcMCbavFsh82DPQX/vErfyWDXaTR+3KKe5V2si6YS
         +wg0Fcya9mAT7YfU23S3Fkit/Lg6YCiCbYeZbCng5HU+yxrVsEis3Z/G/UX0L4RWBjCs
         PUEHH0CG1jAC9k46LkmTGOZXu1UwjJ+qzvYq/ZZYv9lJ3ISLsHW37JjPe0l7joVUAUXN
         1QYA==
X-Gm-Message-State: AOAM532I7TDhrQxPuBDe54O+xOViF9TwBUY3CT/zaJ+v+Ga4RQGdLhdU
        dE1JmvRc1QJKfpypZUWa+BjNs+Z29sNnlUc=
X-Google-Smtp-Source: ABdhPJzpSB08zJBnLwbHl02W9xYuCHlr5gBvgb/tW3BrQDILrEXB073GvlAwzYRJ7nRDUowH61DjK//i7prT180=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:16d1:ab0e:fc4a:b9b1])
 (user=saravanak job=sendgmr) by 2002:a0c:aa01:: with SMTP id
 d1mr714696qvb.47.1631725789030; Wed, 15 Sep 2021 10:09:49 -0700 (PDT)
Date:   Wed, 15 Sep 2021 10:09:37 -0700
In-Reply-To: <20210915170940.617415-1-saravanak@google.com>
Message-Id: <20210915170940.617415-2-saravanak@google.com>
Mime-Version: 1.0
References: <20210915170940.617415-1-saravanak@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v3 1/3] driver core: fw_devlink: Improve handling of cyclic dependencies
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
        linux-acpi@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
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
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
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

