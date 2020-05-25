Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9140A1E1442
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389375AbgEYS0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:26:18 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:36124 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387644AbgEYS0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:26:16 -0400
Received: by mail-ej1-f67.google.com with SMTP id z5so21375647ejb.3;
        Mon, 25 May 2020 11:26:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tkUGbMkkypRL042+ieWSoDccuHFghwak5Hi3wVxhDmE=;
        b=C6FvFlWGYjOrdkQk8jI5gKJ0FH/UIZfAILSeyIMoTRLVytb2uadwYyVnBKtqhCSTxo
         aj7PGbUmhTcR+JDysusQTqgasRYDpRRQVxdYvRfjAv9VZB2QeepMKCxd5gfoeTRCiG/e
         Jmgh6y48CMevLk1MxULlpxQvOwdtAh0T6TWBfaG9cwVabEG8HXYWfG+8hlVFUiRJhf7c
         mtlCsuSP04spjmnUmGR4zpEhwRDaInkTdyS7yw8aXxmvRwo3qaUa74CaZKTiV/4cXz5v
         TEJMF4mWPLspYAssS60gMRqErYpLcUVYYto+4tR5wIWJ4CrG4vDDmSFwZy+Kdd+wz9mq
         Thig==
X-Gm-Message-State: AOAM5325TrlWaByK3eWEBqeVkTpPT770+FJzp0atfEnrNtZYykD0dU5j
        Ga9qYIw6jsILnnvzjKMDVjGtN1EA6vzgYy46
X-Google-Smtp-Source: ABdhPJyLZsaw5mEGXRcLaNb9q3bD5AU4cxUKQ8Vo98mbYphbp21kYQ3Rc8jcjNp3ljuzgmIEt8D4Ug==
X-Received: by 2002:a17:906:f1c3:: with SMTP id gx3mr19110160ejb.278.1590431172312;
        Mon, 25 May 2020 11:26:12 -0700 (PDT)
Received: from workstation.lan ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id n15sm15555707ejs.10.2020.05.25.11.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 11:26:11 -0700 (PDT)
From:   =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Felipe Balbi <balbi@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        greybus-dev@lists.linaro.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 1/8] driver core: Add helper for accessing Power Management callbacs
Date:   Mon, 25 May 2020 18:26:01 +0000
Message-Id: <20200525182608.1823735-2-kw@linux.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525182608.1823735-1-kw@linux.com>
References: <20200525182608.1823735-1-kw@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add driver_to_pm() helper allowing for accessing the Power Management
callbacs for a particular device.  Access to the callbacs (struct
dev_pm_ops) is normally done through using the pm pointer that is
embedded within the device_driver struct.

Helper allows for the code required to reference the pm pointer and
access Power Management callbas to be simplified.  Changing the
following:

  struct device_driver *drv = dev->driver;
  if (dev->driver && dev->driver->pm && dev->driver->pm->prepare) {
      int ret = dev->driver->pm->prepare(dev);

To:

  const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
  if (pm && pm->prepare) {
      int ret = pm->prepare(dev);

Or, changing the following:

     const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;

To:
     const struct dev_pm_ops *pm = driver_to_pm(dev->driver);

Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
---
 include/linux/device/driver.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/device/driver.h b/include/linux/device/driver.h
index ee7ba5b5417e..ccd0b315fd93 100644
--- a/include/linux/device/driver.h
+++ b/include/linux/device/driver.h
@@ -236,6 +236,21 @@ driver_find_device_by_acpi_dev(struct device_driver *drv, const void *adev)
 }
 #endif
 
+/**
+ * driver_to_pm - Return Power Management callbacs (struct dev_pm_ops) for
+ *                a particular device.
+ * @drv: Pointer to a device (struct device_driver) for which you want to access
+ *       the Power Management callbacks.
+ *
+ * Returns a pointer to the struct dev_pm_ops embedded within the device (struct
+ * device_driver), or returns NULL if Power Management is not present and the
+ * pointer is not valid.
+ */
+static inline const struct dev_pm_ops *driver_to_pm(struct device_driver *drv)
+{
+	return drv && drv->pm ? drv->pm : NULL;
+}
+
 extern int driver_deferred_probe_timeout;
 void driver_deferred_probe_add(struct device *dev);
 int driver_deferred_probe_check_state(struct device *dev);
-- 
2.26.2

