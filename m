Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D813E1A1C96
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 09:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgDHH1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 03:27:00 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44315 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgDHH07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 03:26:59 -0400
Received: by mail-pl1-f196.google.com with SMTP id h11so2199639plr.11
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 00:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MmpEQ8SQC6Xl5tR7Jjj5y8uD8BC/8L8xLziXkQ0TWVI=;
        b=Z+eW7VdIANVP+y7K6bQ7lohbpmARsE8zZhuKT6N6QZUHELquqVNPm9CQ7F1SLG7RYS
         QIdpR3lDKGieyLPJ0t7fBN9hqU017Ekfn1idJP58ax8+d6CR4DdzOSkuV9dAs/B0PhgF
         DSZFB10RTROOOWvuV4752//VE1+P9z1sNXB83AHPCBQT51jB8SkiisAOqvfedZ58/p8d
         YwGW5wlHsBud4pZ0OLcZ6LYZESBsqCRrVY2oC/ziYwL9X1n2QCZYKLe71lpMS6FC8adA
         +uhz6cm1LtsjPcCIGOdBcTHcmEqpXVzn7LY68DsRxuCjOCLb2zkaEKfO3HL6LxETGtG7
         Hsug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MmpEQ8SQC6Xl5tR7Jjj5y8uD8BC/8L8xLziXkQ0TWVI=;
        b=XYLQYlpbRtKCVNhhM40GCDSAMHc6ZG6lbMYTJzUTQ+Lo+uywz8nYktnwZZD1MMCxpo
         XY+7G3DPkMKaVlCG9CpL/m/YWIpxNyoQ1Lm0kwCrvtG0Nu6zsReb/SZtTQcQBnuCjLUJ
         AJBXC5mCxqihVPQsA0u6TeScdw0x34lqxBz3r0qpftPpidnvszhI5nLrNZXLMK2cb0w9
         wHgizr0mnn+SE3CcN7X3MZQSiX0vBuKYKhFlXnr+8yPAn1vdjHP56SYYh/9XOqAuRIbW
         6xmdBsjYcL2iEAuMx7RJP72ZHSiH8XY0h9SLVK13eye0z1ebqt8ddVi0bNJNRtAkr3KX
         sRrA==
X-Gm-Message-State: AGi0PuaZTJtghy3rZ1uPLWmLpImULjyNQpzxLpJDhYhH7txF+aHpzbqW
        mZeYu+4qEVmUqysCvocVbY/edw==
X-Google-Smtp-Source: APiQypJY5jt1Z+kCEh8DOZw5UuW9RxeqX3HfnqdnLIu6JVDPye1OyCCRnTHl4q5Efv/HapSv97ToSg==
X-Received: by 2002:a17:902:d303:: with SMTP id b3mr5933935plc.63.1586330818286;
        Wed, 08 Apr 2020 00:26:58 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:692:26ff:feda:3a81])
        by smtp.gmail.com with ESMTPSA id e187sm15356066pfe.143.2020.04.08.00.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 00:26:57 -0700 (PDT)
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
Subject: [RFC][PATCH v2 2/2] driver core: Ensure wait_for_device_probe() waits until the deferred_probe_timeout fires
Date:   Wed,  8 Apr 2020 07:26:50 +0000
Message-Id: <20200408072650.1731-2-john.stultz@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200408072650.1731-1-john.stultz@linaro.org>
References: <20200408072650.1731-1-john.stultz@linaro.org>
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

The downside to this solution is that kernel functionality that
uses wait_for_device_probe(), will block until the
driver_deferred_probe_timeout fires, regardless of if there is
any missing dependencies.

However, the previous patch reverts the default timeout value to
zero, so this side-effect will only affect users who specify a
driver_deferred_probe_timeout= value as a boot argument, where
the additional delay would be beneficial to allow modules to
load later during boot.

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
* v2: Split patch, and apply it as a follow-on to setting
      the driver_deferred_probe_timeout defalt back to zero
---
 drivers/base/dd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 908ae4d7805e..5e6c00176969 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -226,6 +226,7 @@ DEFINE_SHOW_ATTRIBUTE(deferred_devs);
 
 int driver_deferred_probe_timeout;
 EXPORT_SYMBOL_GPL(driver_deferred_probe_timeout);
+static DECLARE_WAIT_QUEUE_HEAD(probe_timeout_waitqueue);
 
 static int __init deferred_probe_timeout_setup(char *str)
 {
@@ -275,6 +276,7 @@ static void deferred_probe_timeout_work_func(struct work_struct *work)
 
 	list_for_each_entry_safe(private, p, &deferred_probe_pending_list, deferred_probe)
 		dev_info(private->device, "deferred probe pending");
+	wake_up(&probe_timeout_waitqueue);
 }
 static DECLARE_DELAYED_WORK(deferred_probe_timeout_work, deferred_probe_timeout_work_func);
 
@@ -649,6 +651,9 @@ int driver_probe_done(void)
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

