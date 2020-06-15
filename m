Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD891F97D1
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 15:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbgFONCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 09:02:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:45787 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730143AbgFONCl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 09:02:41 -0400
IronPort-SDR: y2FG8d4uNhZR4Ce5FIL0ezC9yTdrHNH5aLDi5Q8E49djdMpq5vC3u/P401usdwxLX7wHsmjXMg
 TXUX9EcoBelQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2020 06:01:46 -0700
IronPort-SDR: b22rBwN3qku8X8jMPPXaFYSj7RASPaThNUcmo1zAJFJ59JRRJzvaEXWuDz59j634aFDORFhRrY
 JfABsCT1x1vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,514,1583222400"; 
   d="scan'208";a="290687907"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 15 Jun 2020 06:01:40 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id B778F217; Mon, 15 Jun 2020 16:01:39 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: [PATCH 2/4] thunderbolt: No need to warn if NHI hop_count != 12 or hop_count != 32
Date:   Mon, 15 Jun 2020 16:01:37 +0300
Message-Id: <20200615130139.83854-3-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.27.0.rc2
In-Reply-To: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
References: <20200615130139.83854-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While Intel hardware typically has hop_count (Total Paths in the spec)
12 the USB4 spec allows this to be anything between 1 and 21 so no need
to warn about this. Simply log number of paths at debug level.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/nhi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index d299dc168147..b617922b5b0a 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -1123,9 +1123,7 @@ static int nhi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* cannot fail - table is allocated bin pcim_iomap_regions */
 	nhi->iobase = pcim_iomap_table(pdev)[0];
 	nhi->hop_count = ioread32(nhi->iobase + REG_HOP_COUNT) & 0x3ff;
-	if (nhi->hop_count != 12 && nhi->hop_count != 32)
-		dev_warn(&pdev->dev, "unexpected hop count: %d\n",
-			 nhi->hop_count);
+	dev_dbg(&pdev->dev, "total paths: %d\n", nhi->hop_count);
 
 	nhi->tx_rings = devm_kcalloc(&pdev->dev, nhi->hop_count,
 				     sizeof(*nhi->tx_rings), GFP_KERNEL);
-- 
2.27.0.rc2

