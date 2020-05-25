Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C1A1E1410
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389290AbgEYS0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:26:14 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:37236 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387644AbgEYS0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:26:13 -0400
Received: by mail-ej1-f66.google.com with SMTP id l21so21340052eji.4;
        Mon, 25 May 2020 11:26:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1qikXNcYuPEp2SbYrhq3PIeLmdf37Vp6toU2hryNiAU=;
        b=UmCbsIdwmg0jEmX4PliEuAzxbhnr++enG6DM+5PuammxCnBstbdR/KQuR+PQ0y42pB
         fELpWJdXAh9RRdvCdWiH9zJBGAFpDDjj9hVcqgZRFsmp+QEJ3TaWFO9YfkzBGYJJHvAw
         o4Q+ZpiNqa5bc5+55Ii/p9IZQV6zI7wmnkKzetFoTXnND07uZfTbO0xCl/Lq513bMTAH
         5Wh8pwjGqrxPUiH1SErSegLkfEqMhFcnq8ekW5Ri//s16Av17xL3ey9iqTng4x6xVtNd
         6L3rIuXUbnfs+yEY4cuwJJkqbYguGR9w4bl6PHVt3r2SZMgjF5r8gFw3XllbqpAHOW39
         eTGQ==
X-Gm-Message-State: AOAM530wgjA9f4C4bbwoAhVYMprvnaEiCXOn5aEnfXakvXVCvKmo8Wih
        B7R6u9qx8iVPnxwLifqJiBg=
X-Google-Smtp-Source: ABdhPJxkEBfJS/XXtSSCnmQUkO84UroYhCAKuA4jbTqreWDo9ErA8dsQuCsf23LSLacMkksSHFqFeg==
X-Received: by 2002:a17:906:4bc1:: with SMTP id x1mr19051208ejv.13.1590431170704;
        Mon, 25 May 2020 11:26:10 -0700 (PDT)
Received: from workstation.lan ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id n15sm15555707ejs.10.2020.05.25.11.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 11:26:09 -0700 (PDT)
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
Subject: [PATCH 0/8] Add helper for accessing Power Management callbacs
Date:   Mon, 25 May 2020 18:26:00 +0000
Message-Id: <20200525182608.1823735-1-kw@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series aims to add a new driver_to_pm() helper allowing for
accessing the Power Management callbacs for a particular device.

Access to the callbacs (struct dev_pm_ops) is normally done through
using the pm pointer that is embedded within the device_driver struct.

This new helper allows for the code required to reference the pm pointer
and access Power Management callbas to be simplified.  Changing the
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

This series builds on top of the previous commit 6da2f2ccfd2d ("PCI/PM:
Make power management op coding style consistent") that had an aim to
make accessing the Power Managemnet callbacs more consistent.

No functional change intended.

Links:
  https://lore.kernel.org/driverdev-devel/20191014230016.240912-6-helgaas@kernel.org/
  https://lore.kernel.org/driverdev-devel/8592302.r4xC6RIy69@kreacher/
  https://lore.kernel.org/driverdev-devel/20191016135002.GA24678@kadam/

Krzysztof Wilczyński (8):
  driver core: Add helper for accessing Power Management callbacs
  ACPI: PM: Use the new device_to_pm() helper to access struct
    dev_pm_ops
  greybus: Use the new device_to_pm() helper to access struct dev_pm_ops
  scsi: pm: Use the new device_to_pm() helper to access struct
    dev_pm_ops
  usb: phy: fsl: Use the new device_to_pm() helper to access struct
    dev_pm_ops
  PCI/PM: Use the new device_to_pm() helper to access struct dev_pm_ops
  PM: Use the new device_to_pm() helper to access struct dev_pm_ops
  net/iucv: Use the new device_to_pm() helper to access struct
    dev_pm_ops

 drivers/acpi/device_pm.c         |  5 ++-
 drivers/base/power/domain.c      | 12 ++++--
 drivers/base/power/generic_ops.c | 65 ++++++++++++++------------------
 drivers/base/power/main.c        | 48 +++++++++++++++--------
 drivers/base/power/runtime.c     |  7 ++--
 drivers/greybus/bundle.c         |  4 +-
 drivers/pci/pci-driver.c         | 32 ++++++++--------
 drivers/scsi/scsi_pm.c           |  8 ++--
 drivers/usb/phy/phy-fsl-usb.c    | 11 ++++--
 include/linux/device/driver.h    | 15 ++++++++
 net/iucv/iucv.c                  | 30 +++++++++------
 11 files changed, 138 insertions(+), 99 deletions(-)

-- 
2.26.2

