Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C104FB423B
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 22:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391579AbfIPUpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 16:45:38 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34375 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfIPUph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 16:45:37 -0400
Received: by mail-wr1-f68.google.com with SMTP id a11so871077wrx.1;
        Mon, 16 Sep 2019 13:45:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M1ZS90764/FVzY30XHh7UWixn+HhsaFXDfA2e3hQE2w=;
        b=mZRpJpKYdjD/+XXl0WODP6vSrqivr7IGe5tjubBAsG1BasDHAuJ6M6I/+yXmew5kIb
         pZgAcZdYKkKDla0uidxcTUZst3shFFaE+Pvj25LBDGrNf/Z+vJ8Cx7jD7kjXBuDpecfo
         g4WnupsZlAjepeN61RxU9GMdpBi7iH2il4eeFJe3KrEtCrs0/Ftgn1PxC30xW1x38aZG
         jPStpRaiWFks75X6gWYY1OH7FPRZPGTvqxK0DAPVqAhKn6rtwo3Y5h6leqWPSbZLuzII
         srs6Dgh2h95qTCK6mKi4v7bYa3nd0ZV1F2QHA0mEoC4GMA4K29BwJs1T78qPWudR/F4C
         ohgg==
X-Gm-Message-State: APjAAAVkAfWczaokSO3BRJgS0EtQybNO/gy8XR50o5PkuOYFOKPm9zg0
        2ct0wPpU/5qsHiY6RglU5Zc=
X-Google-Smtp-Source: APXvYqwDWU5ArjS7gzWl4fYqQGrhHTqL0s1rQuZlWAFSAZTLLXsZad+mPx9KuMQHVFx2pUboEnyPiw==
X-Received: by 2002:a5d:61c4:: with SMTP id q4mr159268wrv.327.1568666734658;
        Mon, 16 Sep 2019 13:45:34 -0700 (PDT)
Received: from black.home (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id x6sm231437wmf.38.2019.09.16.13.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 13:45:34 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Denis Efremov <efremov@linux.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Andrew Murray <andrew.murray@arm.com>,
        netdev@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v3 13/26] e1000: Use PCI_STD_NUM_BARS
Date:   Mon, 16 Sep 2019 23:41:45 +0300
Message-Id: <20190916204158.6889-14-efremov@linux.com>
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
 drivers/net/ethernet/intel/e1000/e1000.h      | 1 -
 drivers/net/ethernet/intel/e1000/e1000_main.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000.h b/drivers/net/ethernet/intel/e1000/e1000.h
index c40729b2c184..7fad2f24dcad 100644
--- a/drivers/net/ethernet/intel/e1000/e1000.h
+++ b/drivers/net/ethernet/intel/e1000/e1000.h
@@ -45,7 +45,6 @@
 
 #define BAR_0		0
 #define BAR_1		1
-#define BAR_5		5
 
 #define INTEL_E1000_ETHERNET_DEVICE(device_id) {\
 	PCI_DEVICE(PCI_VENDOR_ID_INTEL, device_id)}
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index f703fa58458e..db4fd82036af 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -977,7 +977,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_ioremap;
 
 	if (adapter->need_ioport) {
-		for (i = BAR_1; i <= BAR_5; i++) {
+		for (i = BAR_1; i < PCI_STD_NUM_BARS; i++) {
 			if (pci_resource_len(pdev, i) == 0)
 				continue;
 			if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
-- 
2.21.0

