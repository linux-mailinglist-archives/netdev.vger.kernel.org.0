Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8104354BBC
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 06:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242440AbhDFE3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 00:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238031AbhDFE3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 00:29:34 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E6DC061574;
        Mon,  5 Apr 2021 21:29:26 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id a8so13783815oic.11;
        Mon, 05 Apr 2021 21:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=p2gbpjC+ao++IvW4sYrYmOKvYw6PHjppj8Y5t8Ls2Fk=;
        b=dOPy0zdQRcqzO/oC3UWnfi8nZDBwPQb7h9Fhmy+AtuGAkdEXNEtYSyAXOa0Com5FqC
         j6uQMtLplf8nYfH2nySIpwpi729C6xqk7lc0WTXMTsV8hoNAYLpOwrmqCm9OTPvSV+us
         4a06QTIGvFckvnpBMpQeoyWOKDSNs6iiPw4uIqHoOHteKI65JwBmJApbKB7VoBOKtBwB
         1mf+tIFfLZVwaFyGKZsbyPgbqfooamH72gL9bYxMQsQ+znD7BBX4c0PVHB3XP3kjWnij
         Dn/Qq6bjU6UYJpL0G/S66VFGKkg1GceJhFloqorhsAj/isrKvJgUoHqwj+DndbfrcQ6G
         Rt5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=p2gbpjC+ao++IvW4sYrYmOKvYw6PHjppj8Y5t8Ls2Fk=;
        b=AcUjhUJgGYyHbp8PxsfH70X24v8Vo/DdAjU8pV+hkyPew8/tBY8vDqafsEdKeQuAcY
         gkH/L2dw8BTYIBpQXyuZuT9zPWi/+iV1/9YL80B67JF8u6jUq7TBmPzBpem5H9cCN0TM
         EFPa0jdBSCWIYccIfhvK3r5/dADsEokiEcqCDngvz/NeF80ootEKz8V0j5H4ahXu9+iP
         F+LY20kEHaGwCkAguQO8PlWxFA17vH86dGBoT68zIZWEPVV8Qi2sc9DuYZ4wwkbnSxBF
         3SyTlTNZZDG4OMpTdFVTOyEDP/NG+Oqw8ONbxrAKsSrg+azmice+Ni0V6PdO7awAH+vX
         I3GA==
X-Gm-Message-State: AOAM531wcRHoRhQRzSnNkgoIY+ZzgBWdTR3YduTdfB64Hpw1CES+CZGe
        X4MhMo10LOEpoWfP2lp9Pd0=
X-Google-Smtp-Source: ABdhPJyHrgKP/4SP1cXCpsgPwLFPyTo/xwtkmnJyHul0DMZkytB8vH5nF5agxYNOv+0U3UsqjqUREg==
X-Received: by 2002:aca:3bc4:: with SMTP id i187mr1948491oia.174.1617683366009;
        Mon, 05 Apr 2021 21:29:26 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g2sm4400873otn.32.2021.04.05.21.29.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Apr 2021 21:29:25 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Don Fry <pcnet32@frontier.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] pcnet32: Use pci_resource_len to validate PCI resource
Date:   Mon,  5 Apr 2021 21:29:22 -0700
Message-Id: <20210406042922.210327-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pci_resource_start() is not a good indicator to determine if a PCI
resource exists or not, since the resource may start at address 0.
This is seen when trying to instantiate the driver in qemu for riscv32
or riscv64.

pci 0000:00:01.0: reg 0x10: [io  0x0000-0x001f]
pci 0000:00:01.0: reg 0x14: [mem 0x00000000-0x0000001f]
...
pcnet32: card has no PCI IO resources, aborting

Use pci_resouce_len() instead.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/ethernet/amd/pcnet32.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index 187b0b9a6e1d..f78daba60b35 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -1534,8 +1534,7 @@ pcnet32_probe_pci(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	pci_set_master(pdev);
 
-	ioaddr = pci_resource_start(pdev, 0);
-	if (!ioaddr) {
+	if (!pci_resource_len(pdev, 0)) {
 		if (pcnet32_debug & NETIF_MSG_PROBE)
 			pr_err("card has no PCI IO resources, aborting\n");
 		err = -ENODEV;
@@ -1548,6 +1547,8 @@ pcnet32_probe_pci(struct pci_dev *pdev, const struct pci_device_id *ent)
 			pr_err("architecture does not support 32bit PCI busmaster DMA\n");
 		goto err_disable_dev;
 	}
+
+	ioaddr = pci_resource_start(pdev, 0);
 	if (!request_region(ioaddr, PCNET32_TOTAL_SIZE, "pcnet32_probe_pci")) {
 		if (pcnet32_debug & NETIF_MSG_PROBE)
 			pr_err("io address range already allocated\n");
-- 
2.17.1

