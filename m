Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E85BB4237
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 22:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387829AbfIPUpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 16:45:30 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39807 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfIPUp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 16:45:29 -0400
Received: by mail-wm1-f68.google.com with SMTP id v17so693426wml.4;
        Mon, 16 Sep 2019 13:45:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QR/S6ZclFf3ctqEohNgiNTP20YUhWH32oSyd8G++lVQ=;
        b=f0YHPr6KR/5mTB4I6K26bDjwDoBUB5kWCbO2qAFmfBw4TEbjg/HCndFzzzBgVS0bya
         3sfQwZ4KjngTafUtob1tIUuCuyM9RPlwZ8iVd37/ySr3CbIxsZZSJa4rRsKdF+Khtj0d
         NUKVZ1a3hjClT+bMxwsSdeUNGtuthNko8VcKU/LH0O8kzg6DVInUyPvgSMvNcFDQn0VW
         hniRQ/rzHQyl5Sff6HEliT0dvBSGJY5o4J+7xH6BwQzg/pP6vPMdPmB1k3f32jURYMOD
         zNW2tDWcq7wwaSyw3FDdfn01aMXhlbzs7WIFvsBvrDIMPSzTeV1sBqtGHuW1+RN+DoOy
         IMlQ==
X-Gm-Message-State: APjAAAVGNBgxXmwKL/CRDnepNZ7PKO9Bv834SWadNhnBiGNk2bUbzOzp
        qjJK5NDNN3n5VuXNmnc/Wfc=
X-Google-Smtp-Source: APXvYqztjSg5+p90FlyscHFtm0sWqlZ7NHCNyXeOHpO3+SNipAPorA1rmqYMQHfsoiE2lPw4x64s0Q==
X-Received: by 2002:a1c:bcd6:: with SMTP id m205mr627239wmf.129.1568666727659;
        Mon, 16 Sep 2019 13:45:27 -0700 (PDT)
Received: from black.home (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id x6sm231437wmf.38.2019.09.16.13.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 13:45:27 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Denis Efremov <efremov@linux.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Andrew Murray <andrew.murray@arm.com>,
        netdev@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v3 12/26] ixgb: use PCI_STD_NUM_BARS
Date:   Mon, 16 Sep 2019 23:41:44 +0300
Message-Id: <20190916204158.6889-13-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190916204158.6889-1-efremov@linux.com>
References: <20190916204158.6889-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To iterate through all possible BARs, loop conditions refactored to the
*number* of BARs "i < PCI_STD_NUM_BARS", instead of the index of the last
valid BAR "i <= BAR_5". This is more idiomatic C style and allows to avoid
the fencepost error.

Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/ethernet/intel/ixgb/ixgb.h      | 1 -
 drivers/net/ethernet/intel/ixgb/ixgb_main.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgb/ixgb.h b/drivers/net/ethernet/intel/ixgb/ixgb.h
index e85271b68410..681d44cc9784 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb.h
+++ b/drivers/net/ethernet/intel/ixgb/ixgb.h
@@ -42,7 +42,6 @@
 
 #define BAR_0		0
 #define BAR_1		1
-#define BAR_5		5
 
 struct ixgb_adapter;
 #include "ixgb_hw.h"
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index e5ac2d3fd816..c5bba18eb32a 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -412,7 +412,7 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_ioremap;
 	}
 
-	for (i = BAR_1; i <= BAR_5; i++) {
+	for (i = BAR_1; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pdev, i) == 0)
 			continue;
 		if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
-- 
2.21.0

