Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0DF2AD241
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbgKJJUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:20:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:52778 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729902AbgKJJUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 04:20:03 -0500
IronPort-SDR: VTOdLM41QaQ4d+8u7dlY3lPwdDPSdHczm9Pud3661geeSaNPaXYdJw5EHqS3ibEnU1PR+ALG5y
 rYtkvF+FQEGg==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="156950716"
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="156950716"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 01:20:02 -0800
IronPort-SDR: 4A5Xw2r4utUleEYpydkYPK2f9fNblcldT+q+Fj8si7Sa9DH9ieTCeDuzxRbVIY701REvku3Jvg
 KX5w4XV/Sn/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="473356419"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 10 Nov 2020 01:19:58 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 590304B0; Tue, 10 Nov 2020 11:19:57 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 03/10] thunderbolt: Create XDomain devices for loops back to the host
Date:   Tue, 10 Nov 2020 12:19:50 +0300
Message-Id: <20201110091957.17472-4-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
References: <20201110091957.17472-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is perfectly possible to have loops back from the routers to the
host, or even from one host port to another. Instead of ignoring these,
we create XDomain devices for each. This allows creating services such
as DMA traffic test that is used in manufacturing for example.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Yehezkel Bernat <YehezkelShB@gmail.com>
---
 drivers/thunderbolt/xdomain.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index e436e9efa7e7..da229ac4e471 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -961,10 +961,8 @@ static void tb_xdomain_get_uuid(struct work_struct *work)
 		return;
 	}
 
-	if (uuid_equal(&uuid, xd->local_uuid)) {
+	if (uuid_equal(&uuid, xd->local_uuid))
 		dev_dbg(&xd->dev, "intra-domain loop detected\n");
-		return;
-	}
 
 	/*
 	 * If the UUID is different, there is another domain connected
-- 
2.28.0

