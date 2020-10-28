Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BED429DC25
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731762AbgJ2AV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:21:59 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37030 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388934AbgJ1WiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:38:07 -0400
Received: by mail-pl1-f196.google.com with SMTP id b12so350388plr.4;
        Wed, 28 Oct 2020 15:38:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CRi9FZ9Z+UnIZ2SkQnApmkHlHaSq8BXaJGt7reiNtuM=;
        b=TG5yT+WNmWJEvrBaME0cAali7Hku7kGOgrlVD2UIV4eHHSl2OSao+adLYXf8POrxux
         25vPZ6PW4+9fvxE5FAn3SHB7UzBEdf+scVooLnRl6aAqh4bJDjn7ZtEDxWERYzeBm9cX
         dYb1vApYuPz8GaEjacJYwhOZd9kuUG6Juhx39r0r4CgDA7kP5AgXNCNRSk2ne21TPI+m
         zUaq3kAEUVFBPGRY8ymqxKVgZma5LpE7cipy5qyTrUujzIM+E74otDIGIUWd4EBFz14L
         k0C9r1TKFWb5ltZNMx0d7yhRo4gqN2i9B6VQbzYkGEcC9ZB8GeFM7e8W4diGlZurdvCP
         ZWwQ==
X-Gm-Message-State: AOAM533EusHMWbuvjyIdJ7TR5vSkACAZrJ9V+EC918EUkZv5Uq6eOYdZ
        RRKBNQLHmbBUXnVokGR12elUrWOYp5s=
X-Google-Smtp-Source: ABdhPJybJf5w2rTgj/vTCQIw0+jC/10ExJGouMFxqaRROOWNhnuuESZf1ZzFqZMOxvBnAnCm+RtQSg==
X-Received: by 2002:a62:a10a:0:b029:154:fd62:ba90 with SMTP id b10-20020a62a10a0000b0290154fd62ba90mr22740pff.62.1603905696356;
        Wed, 28 Oct 2020 10:21:36 -0700 (PDT)
Received: from localhost ([2601:647:5b00:1161:a4cc:eef9:fbc0:2781])
        by smtp.gmail.com with ESMTPSA id b6sm4775pjq.42.2020.10.28.10.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 10:21:35 -0700 (PDT)
From:   Moritz Fischer <mdf@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lucyyan@google.com,
        moritzf@google.com, James.Bottomley@hansenpartnership.com,
        kuba@kernel.org, Moritz Fischer <mdf@kernel.org>
Subject: [PATCH net-next v4] net: dec: tulip: de2104x: Add shutdown handler to stop NIC
Date:   Wed, 28 Oct 2020 10:21:25 -0700
Message-Id: <20201028172125.496942-1-mdf@kernel.org>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver does not implement a shutdown handler which leads to issues
when using kexec in certain scenarios. The NIC keeps on fetching
descriptors which gets flagged by the IOMMU with errors like this:

DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000
DMAR: DMAR:[DMA read] Request device [5e:00.0]fault addr fffff000

Signed-off-by: Moritz Fischer <mdf@kernel.org>
---

Changes from v3:
- Added rtnl_lock()/unlock() as suggested by Jakub and use dev_close()

Changes from v2:
- Changed to net-next
- Removed extra whitespace

Changes from v1:
- Replace call to de_remove_one with de_shutdown() function
  as suggested by James.

---
 drivers/net/ethernet/dec/tulip/de2104x.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/dec/tulip/de2104x.c b/drivers/net/ethernet/dec/tulip/de2104x.c
index d9f6c19940ef..c3cbe55205a7 100644
--- a/drivers/net/ethernet/dec/tulip/de2104x.c
+++ b/drivers/net/ethernet/dec/tulip/de2104x.c
@@ -2175,11 +2175,21 @@ static int __maybe_unused de_resume(struct device *dev_d)
 
 static SIMPLE_DEV_PM_OPS(de_pm_ops, de_suspend, de_resume);
 
+static void de_shutdown(struct pci_dev *pdev)
+{
+	struct net_device *dev = pci_get_drvdata(pdev);
+
+	rtnl_lock();
+	dev_close(dev);
+	rtnl_unlock();
+}
+
 static struct pci_driver de_driver = {
 	.name		= DRV_NAME,
 	.id_table	= de_pci_tbl,
 	.probe		= de_init_one,
 	.remove		= de_remove_one,
+	.shutdown	= de_shutdown,
 	.driver.pm	= &de_pm_ops,
 };
 
-- 
2.29.1

