Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE0A131A10
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgAFVF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:05:28 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42785 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgAFVFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:05:21 -0500
Received: by mail-pg1-f194.google.com with SMTP id s64so27403074pgb.9
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 13:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E8kuBhvQjVSYVziYAoWgqMCiuOOHXOD4BqBOGj3RIJ4=;
        b=H4orBqITU3ofRgPXado+xB09DYNvKgZZSY8pfmfAnLscB8dPr6VWLmKm2BmotU7Ado
         H3wEvGIewk92jVdf7lBjLPvOqdMtIWzagrFV0nSH7ZXF6SeqMum9K58Ztw4Dc8TQ7YsS
         8hrPgWw6FC8bJVWIJKE8V1FSsEdDawUSlj9SVBAjt6nStX6dUT/mvvQgQhXpdK9cSzNG
         dUPLT08YnrTT2UXPHyHgipNOOUJEzA/EgzebDypMhg7X+esoZqoCFINs4ARkUm8mX/11
         WYtnOduIrdO0+bGO1cVqEEVZCU0MC4P8leckGco04+LWBl3g2ivnEAiPd2MpVmEM3a8f
         JfsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E8kuBhvQjVSYVziYAoWgqMCiuOOHXOD4BqBOGj3RIJ4=;
        b=GelUnQ1N3W5Aq7YwhqObMyDhoBGj/LrRcY2bKPRcLyteqKspVH5XWGD+peSNYhn4xl
         d99mV6JDmIpYWpld6lqCoI4U6mXfofCnTprMKG2uvGAJmK2GzdcLXjfVkkUjWAjY4i/m
         pEKL9X5/eaBcxUx5oKpceKsNqkoKQpd799MHWEuK0TN3LIebgGwzh40Y/qC3Px/i94Np
         a44IqRBLamWRz8DeRDyxt0Lv3k2VbJ7HGE1647iaVXTKGp+hqn2wEReH0tnMP4Ks0+gp
         tAfsPkiFmrvoYaZeAk33SuxFXXfiVWhsBelv13w0jJTYORR9qPxW5Kf5pxs+oaWUH0A9
         SlSg==
X-Gm-Message-State: APjAAAX6uAVnDbt3JLaEKfaEZxh4rhFPYZPolumxj+JoR+eE7fKr4dMF
        7ak9YD0D5rTPDQHgQp8eeVhg8tCm85U=
X-Google-Smtp-Source: APXvYqyD5w84guC2W6wsijhZvmCuR0rE3T+KaGwEXt605MgO6DOu0lMpeieK5UCbkYHnjWC9cT21Tw==
X-Received: by 2002:a62:258:: with SMTP id 85mr115837364pfc.254.1578344720838;
        Mon, 06 Jan 2020 13:05:20 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p16sm63183003pfq.184.2020.01.06.13.05.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 13:05:20 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/4] ionic: fix for ppc msix layout
Date:   Mon,  6 Jan 2020 13:05:10 -0800
Message-Id: <20200106210512.34244-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200106210512.34244-1-snelson@pensando.io>
References: <20200106210512.34244-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IBM Power9 ppc64 seems to have a problem with not wanting
to limit the address space used by a PCI device.  The Naples
internal HW can only address up to 52 bits, but the ppc does
not play well with that limitation.  This patch tells the
system how to work with Naples successfully.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 448d7b23b2f7..9fd3862dee0d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -222,6 +222,9 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	mutex_init(&ionic->dev_cmd_lock);
 
 	/* Query system for DMA addressing limitation for the device. */
+#ifdef CONFIG_PPC64
+	ionic->pdev->no_64bit_msi = 1;
+#endif
 	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(IONIC_ADDR_LEN));
 	if (err) {
 		dev_err(dev, "Unable to obtain 64-bit DMA for consistent allocations, aborting.  err=%d\n",
-- 
2.17.1

