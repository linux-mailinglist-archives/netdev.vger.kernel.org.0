Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0304AB4233
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 22:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387913AbfIPUo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 16:44:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33212 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733036AbfIPUoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 16:44:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id r17so868397wme.0;
        Mon, 16 Sep 2019 13:44:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qzo9N5fUquDTsruLiXlDtb8ifZF0psYmg1XFgmwVlAE=;
        b=ofhXOsH398lqeN7n+lSzzu9Riov/tRnomBHh86IvYZakTibaIk8Fpe4GpTfVe4bUeY
         7hcYEKJo6fDkzKf2QzZW+irI9fBta14cih0gTM5lamZKM5Qb0fFQowNTmZM0ly5ZbYoB
         tzKLlJ5V1bHgCkzjWPFw7kgZmBQGBO2b1XI2o8DaMDEz1wRitnV9AlgqLUTa90RhBUGU
         eL26hfXpVtkUuU6npfbgnQSRtBpfaHoIKQI7S6pBncHIueE1rFidrN84xFBoqXE8IJVt
         JGBTbS6cijyFVAlco7LIb6tOdDDtbNT4KJtesL2VlRiTf4VHu4XGAG/X+kz/TRxdl0FE
         b85Q==
X-Gm-Message-State: APjAAAUukmtejsNnYlsfwQ1rqGMWEUGBK43hU2L97RLcCjPRADQ7ZtXg
        rpf8fcR7byhZjPLAKx5Ox84=
X-Google-Smtp-Source: APXvYqyubIyIdrlstzf0Ad0JsGLLntibKR539vulOFUOeqSof1ITb8rIBEpmhXOL5xtxwKIsovzmNA==
X-Received: by 2002:a7b:cbd0:: with SMTP id n16mr661540wmi.82.1568666693707;
        Mon, 16 Sep 2019 13:44:53 -0700 (PDT)
Received: from black.home (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id x6sm231437wmf.38.2019.09.16.13.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 13:44:53 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
Cc:     Denis Efremov <efremov@linux.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Andrew Murray <andrew.murray@arm.com>,
        netdev@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH v3 11/26] net: dwc-xlgmac: Loop using PCI_STD_NUM_BARS
Date:   Mon, 16 Sep 2019 23:41:43 +0300
Message-Id: <20190916204158.6889-12-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190916204158.6889-1-efremov@linux.com>
References: <20190916204158.6889-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor loops to use idiomatic C style and avoid the fencepost error
of using "i < PCI_STD_RESOURCE_END" when "i <= PCI_STD_RESOURCE_END"
is required, e.g., commit 2f686f1d9bee ("PCI: Correct PCI_STD_RESOURCE_END
usage").

To iterate through all possible BARs, loop conditions changed to the
*number* of BARs "i < PCI_STD_NUM_BARS", instead of the index of the last
valid BAR "i <= PCI_STD_RESOURCE_END".

Cc: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c
index 386bafe74c3f..fa8604d7b797 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-pci.c
@@ -34,7 +34,7 @@ static int xlgmac_probe(struct pci_dev *pcidev, const struct pci_device_id *id)
 		return ret;
 	}
 
-	for (i = 0; i <= PCI_STD_RESOURCE_END; i++) {
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
 		if (pci_resource_len(pcidev, i) == 0)
 			continue;
 		ret = pcim_iomap_regions(pcidev, BIT(i), XLGMAC_DRV_NAME);
-- 
2.21.0

