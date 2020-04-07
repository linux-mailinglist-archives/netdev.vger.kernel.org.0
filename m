Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBC601A07EF
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 09:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgDGHGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 03:06:21 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45435 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgDGHGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 03:06:20 -0400
Received: by mail-pl1-f196.google.com with SMTP id t4so866733plq.12
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 00:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xAVY7T1+cZqyUQSpaOqLvP0ADsbvMfjMiLxlWlklJPo=;
        b=pddZluUMZtOco59Dv37yDhn0NwXH3iQvM0Oq48SS68zWVnjH55cfcAZhaBOJy4u1rv
         tJMnbj26p7YyNtuecgLVHXc4lGwC12izuYcBXigtG4ewMwsQ7MRtsr4sqmF4Y4gOouAN
         j4g3UTq3JaV7GmqCVZl40LSiDLx3/t/+SrkL54U/sCBsgj9+ujSwVa7tMfyn2C2dayPY
         bP6W5wxM7/3dzSe52070VxoT/fwX1/EyPrSk1vSBJY/UvQnu+VTl+/A9VfH84cSqb0+Z
         mYSHWrP+R6wGxZhLHeBsD1dn2Y1Z3ljyanl7uyiyXbR9t3mgjDl4eE0Y2wiEqOSU3GRe
         UdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xAVY7T1+cZqyUQSpaOqLvP0ADsbvMfjMiLxlWlklJPo=;
        b=oo07E+qOrPdOeqk9XO2v83eV6kLOGHwU6YlazxSBnJ43b/3BTDwa0yYU5TXnxSskkW
         o65y302to9u5L6iBlTZrGY2LTJ9/dxglFndckVC3vQP9mjx4uUBqXwTIFElUd04CE8Ko
         jPdQmB9wVox2DMTvOqFepWzeDEhykE/ABNxeKDU4U8rFRNaWNcSN5e+1R/nLO9TYeYvm
         PI2DN68AsevD1qutUTdkKl59otJCYkCIzECzxsUEAr8pnjZd5hfjYUjanZ4CHYzQgjAh
         l9j06XAqB3NzZxtJfYXF3C2MD/a98yZf+YeoSPzm9YGvl3sro6tZ6sTj+cIZB7CwUSes
         JvlQ==
X-Gm-Message-State: AGi0PuY+lEF7oNKGN+Lfv0IOzQqWJ+mCY+Q/bWLPV9UZVjPFiJ+k7Aqi
        e4eClbjgpORb52E4ORhcqC49mw==
X-Google-Smtp-Source: APiQypI9ny5imcqnQwUupSAXYN43rwnatWBWoNOx4g9R3mWkwWVHU851cSuUArsLGxHk8bcLnyA8Cw==
X-Received: by 2002:a17:90a:30c3:: with SMTP id h61mr1110597pjb.18.1586243179017;
        Tue, 07 Apr 2020 00:06:19 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id na18sm826900pjb.31.2020.04.07.00.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 00:06:18 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     lkml <linux-kernel@vger.kernel.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev <netdev@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: [RFC][PATCH] driver core: Ensure wait_for_device_probe() waits until the deferred_probe_timeout fires
Date:   Tue,  7 Apr 2020 07:06:09 +0000
Message-Id: <20200407070609.42865-1-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <TYAPR01MB45443FA43152C0091D6EBF9AD8C20@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <TYAPR01MB45443FA43152C0091D6EBF9AD8C20@TYAPR01MB4544.jpnprd01.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit c8c43cee29f6 ("driver core: Fix
driver_deferred_probe_check_state() logic"), we set the default
driver_deferred_probe_timeout value to 30 seconds to allow for
drivers that are missing dependencies to have some time so that
the dependency may be loaded from userland after initcalls_done
is set.

However, Yoshihiro Shimoda reported that on his device that
expects to have unmet dependencies (due to "optional links" in
its devicetree), was failing to mount the NFS root.

In digging further, it seemed the problem was that while the
device properly probes after waiting 30 seconds for any missing
modules to load, the ip_auto_config() had already failed,
resulting in NFS to fail. This was due to ip_auto_config()
calling wait_for_device_probe() which doesn't wait for the
driver_deferred_probe_timeout to fire.

This patch tries to fix the issue by creating a waitqueue
for the driver_deferred_probe_timeout, and calling wait_event()
to make sure driver_deferred_probe_timeout is zero in
wait_for_device_probe() to make sure all the probing is
finished.

NOTE: I'm not 100% sure this won't have other unwanted side
effects (I don't have failing hardware myself to validate),
so I'd apprecate testing and close review.

If this approach doesn't work, I'll simply set the default
driver_deferred_probe_timeout value back to zero, to avoid any
behavioral change from before.

Thanks to Geert for chasing down that ip_auto_config was why NFS
was failing in this case!

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Rob Herring <robh@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: netdev <netdev@vger.kernel.org>
Cc: linux-pm@vger.kernel.org
Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state() logic")
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/base/dd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 06ec0e851fa1..8c13f0df3282 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -232,9 +232,10 @@ DEFINE_SHOW_ATTRIBUTE(deferred_devs);
 int driver_deferred_probe_timeout = 30;
 #else
 /* In the case of !modules, no probe timeout needed */
-int driver_deferred_probe_timeout = -1;
+int driver_deferred_probe_timeout;
 #endif
 EXPORT_SYMBOL_GPL(driver_deferred_probe_timeout);
+static DECLARE_WAIT_QUEUE_HEAD(probe_timeout_waitqueue);
 
 static int __init deferred_probe_timeout_setup(char *str)
 {
@@ -266,7 +267,7 @@ int driver_deferred_probe_check_state(struct device *dev)
 		return -ENODEV;
 	}
 
-	if (!driver_deferred_probe_timeout) {
+	if (!driver_deferred_probe_timeout && initcalls_done) {
 		dev_WARN(dev, "deferred probe timeout, ignoring dependency");
 		return -ETIMEDOUT;
 	}
@@ -284,6 +285,7 @@ static void deferred_probe_timeout_work_func(struct work_struct *work)
 
 	list_for_each_entry_safe(private, p, &deferred_probe_pending_list, deferred_probe)
 		dev_info(private->device, "deferred probe pending");
+	wake_up(&probe_timeout_waitqueue);
 }
 static DECLARE_DELAYED_WORK(deferred_probe_timeout_work, deferred_probe_timeout_work_func);
 
@@ -658,6 +660,9 @@ int driver_probe_done(void)
  */
 void wait_for_device_probe(void)
 {
+	/* wait for probe timeout */
+	wait_event(probe_timeout_waitqueue, !driver_deferred_probe_timeout);
+
 	/* wait for the deferred probe workqueue to finish */
 	flush_work(&deferred_probe_work);
 
-- 
2.17.1

