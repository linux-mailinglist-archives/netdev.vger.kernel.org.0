Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C70166A59
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 23:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgBTW0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 17:26:55 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37297 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbgBTW0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 17:26:55 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so96485pfn.4
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 14:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sUyMlFbRRGR/Od/yvQ4X4umEQFvI7SXuzbnwFNE55aU=;
        b=Abj8RfD4pM5G65znD0OBeJx5NDJDuxmATz7rtTsWnTClwqi/pEuNMTbRuWU+NnVJVD
         t7RLZ4fvmX9lG4NaChKnjHBk61a0CiTSY82mV+7L+JhpU+4PRuHV1/m1FjB35Lv4O16n
         G3bw0ocml8S6fW8Qr1ce2J9ANIq1hkehBlPj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sUyMlFbRRGR/Od/yvQ4X4umEQFvI7SXuzbnwFNE55aU=;
        b=Qyw51Mo4R/9Mx/i65jNbbmAbxhxZOtCp0mDQQEBne3IjZdTU7dDHGuIsJZqTi4j5c9
         p7iOTpU7i8K/3XTAwL0JYoOGqOxoh3xlrxXAs0UzMptMF/QI83It5CTIdKwv//V8fYEG
         8XB47fazVyMoyGm1cKJUa6RS+HOd/XKY9d/OOaamUkq63aoQtMj0AJZZX8p2JZjHytLD
         7nE1ylfSunlgEpfl6RhcM+HVfhFzWtSem5zZyTpwcbCAjAfGNVc7SXLzxV60LH/vXTUJ
         6VHgzhSfp1Wg2NgeHK+bzDr9FDidL/3mhoFd+S8oKaay3Ly/RpJuczuswN9zQWliCG/r
         2XfA==
X-Gm-Message-State: APjAAAUIWyJY/h2RbdpsFxilKmh9H+2NVLg+LvUQPF2pXrlAOpeIyykM
        o+IHN4HETNgRIGnIRwBqP/ZGayuXU0I=
X-Google-Smtp-Source: APXvYqyz81i7ZcblSF5lOvu4gr7c2PoxMR60W0rgdTSF3Y+cGAGIw5Qml41rhoHTy+ogGH+TWqQ3Dw==
X-Received: by 2002:a63:565b:: with SMTP id g27mr35357078pgm.309.1582237614368;
        Thu, 20 Feb 2020 14:26:54 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c26sm607831pfj.8.2020.02.20.14.26.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Feb 2020 14:26:53 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: [PATCH net 2/2] bnxt_en: Issue PCIe FLR in kdump kernel to cleanup pending DMAs.
Date:   Thu, 20 Feb 2020 17:26:35 -0500
Message-Id: <1582237595-10503-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1582237595-10503-1-git-send-email-michael.chan@broadcom.com>
References: <1582237595-10503-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

If crashed kernel does not shutdown the NIC properly, PCIe FLR
is required in the kdump kernel in order to initialize all the
functions properly.

Fixes: d629522e1d66 ("bnxt_en: Reduce memory usage when running in kdump kernel.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2ad007e..fd6e0e4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11786,6 +11786,14 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (version_printed++ == 0)
 		pr_info("%s", version);
 
+	/* Clear any pending DMA transactions from crash kernel
+	 * while loading driver in capture kernel.
+	 */
+	if (is_kdump_kernel()) {
+		pci_clear_master(pdev);
+		pcie_flr(pdev);
+	}
+
 	max_irqs = bnxt_get_max_irq(pdev);
 	dev = alloc_etherdev_mq(sizeof(*bp), max_irqs);
 	if (!dev)
-- 
2.5.1

