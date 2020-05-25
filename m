Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FAC1E1422
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389803AbgEYS0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:26:30 -0400
Received: from mail-ej1-f67.google.com ([209.85.218.67]:37256 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389424AbgEYS0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:26:24 -0400
Received: by mail-ej1-f67.google.com with SMTP id l21so21340550eji.4;
        Mon, 25 May 2020 11:26:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zNLfwJcteMTXr7l2k3f76K9ak6QhgvPhJMdyVWXtook=;
        b=S2upfNGqFWbRgK7c41NmdMByKGk4hqVDyMU9Qa+RACz2GQ1itC1GNbhBGRQ8o/5R/H
         bzzeu4DxSD5MY+hrMhR3QsAvKPdA65bK8BcLG830DnetEQErjDpA+SgBHr4w23LucSe8
         /s0SKw3buAirKCEUjLjXVNA5WV5TlGMliMTpiyTdU2msD6YuaFSYEV61G2CvQLSzKIVP
         m2Uhemk/HRBhxVwDCCEZ2SB6Z2DeBqp3N9iCcPYN/MI+psXLOxoUZjkKbDXXVWxMYlDe
         47UHwFLs+ikmsxh7RfFnTmmIdI08QpkHiXgXD2+B2jPRCu/f0F6UWHCZXaEBij1OSlG1
         KLJQ==
X-Gm-Message-State: AOAM532EtWLTmnD29SMRf473doTEiqHIDde/WD1ohkL5VNqo2U1Y/Phg
        +Ye9Fy/SvOwFHEJW0AYWU1I=
X-Google-Smtp-Source: ABdhPJxHXwXAwSKGbmYve3v9WBtP/87qC9xOP1l2MkD3w7uNppn5ljU8phz0KQh9kDPYuSYY7QZQjA==
X-Received: by 2002:a17:906:e112:: with SMTP id gj18mr10286586ejb.352.1590431180269;
        Mon, 25 May 2020 11:26:20 -0700 (PDT)
Received: from workstation.lan ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id n15sm15555707ejs.10.2020.05.25.11.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 11:26:19 -0700 (PDT)
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
Subject: [PATCH 6/8] PCI/PM: Use the new device_to_pm() helper to access struct dev_pm_ops
Date:   Mon, 25 May 2020 18:26:06 +0000
Message-Id: <20200525182608.1823735-7-kw@linux.com>
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

Use the new device_to_pm() helper to access Power Management callbacs
(struct dev_pm_ops) for a particular device (struct device_driver).

No functional change intended.

Signed-off-by: Krzysztof Wilczyński <kw@linux.com>
---
 drivers/pci/pci-driver.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 0454ca0e4e3f..bb52bb6642a0 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -652,7 +652,7 @@ static bool pci_has_legacy_pm_support(struct pci_dev *pci_dev)
 static int pci_pm_prepare(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 
 	if (pm && pm->prepare) {
 		int error = pm->prepare(dev);
@@ -721,7 +721,7 @@ static void pcie_pme_root_status_cleanup(struct pci_dev *pci_dev)
 static int pci_pm_suspend(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 
 	pci_dev->skip_bus_pm = false;
 
@@ -787,7 +787,7 @@ static int pci_pm_suspend_late(struct device *dev)
 static int pci_pm_suspend_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 
 	if (dev_pm_smart_suspend_and_suspended(dev)) {
 		dev->power.may_skip_resume = true;
@@ -889,7 +889,7 @@ static int pci_pm_suspend_noirq(struct device *dev)
 static int pci_pm_resume_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 	pci_power_t prev_state = pci_dev->current_state;
 	bool skip_bus_pm = pci_dev->skip_bus_pm;
 
@@ -931,7 +931,7 @@ static int pci_pm_resume_noirq(struct device *dev)
 static int pci_pm_resume(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 
 	/*
 	 * This is necessary for the suspend error path in which resume is
@@ -976,7 +976,7 @@ struct dev_pm_ops __weak pcibios_pm_ops;
 static int pci_pm_freeze(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_FREEZE);
@@ -1012,7 +1012,7 @@ static int pci_pm_freeze(struct device *dev)
 static int pci_pm_freeze_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend_late(dev, PMSG_FREEZE);
@@ -1040,7 +1040,7 @@ static int pci_pm_freeze_noirq(struct device *dev)
 static int pci_pm_thaw_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 	int error;
 
 	if (pcibios_pm_ops.thaw_noirq) {
@@ -1073,7 +1073,7 @@ static int pci_pm_thaw_noirq(struct device *dev)
 static int pci_pm_thaw(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 	int error = 0;
 
 	if (pci_has_legacy_pm_support(pci_dev))
@@ -1094,7 +1094,7 @@ static int pci_pm_thaw(struct device *dev)
 static int pci_pm_poweroff(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return pci_legacy_suspend(dev, PMSG_HIBERNATE);
@@ -1138,7 +1138,7 @@ static int pci_pm_poweroff_late(struct device *dev)
 static int pci_pm_poweroff_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 
 	if (dev_pm_smart_suspend_and_suspended(dev))
 		return 0;
@@ -1181,7 +1181,7 @@ static int pci_pm_poweroff_noirq(struct device *dev)
 static int pci_pm_restore_noirq(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 	int error;
 
 	if (pcibios_pm_ops.restore_noirq) {
@@ -1205,7 +1205,7 @@ static int pci_pm_restore_noirq(struct device *dev)
 static int pci_pm_restore(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 
 	/*
 	 * This is necessary for the hibernation error path in which restore is
@@ -1248,7 +1248,7 @@ static int pci_pm_restore(struct device *dev)
 static int pci_pm_runtime_suspend(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 	pci_power_t prev = pci_dev->current_state;
 	int error;
 
@@ -1303,7 +1303,7 @@ static int pci_pm_runtime_suspend(struct device *dev)
 static int pci_pm_runtime_resume(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 	pci_power_t prev_state = pci_dev->current_state;
 	int error = 0;
 
@@ -1334,7 +1334,7 @@ static int pci_pm_runtime_resume(struct device *dev)
 static int pci_pm_runtime_idle(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	const struct dev_pm_ops *pm = driver_to_pm(dev->driver);
 
 	/*
 	 * If pci_dev->driver is not set (unbound), the device should
-- 
2.26.2

