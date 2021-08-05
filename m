Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB91B3E1B7A
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241498AbhHESi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:38:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:4238 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241019AbhHESiz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 14:38:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="236197431"
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="236197431"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 11:38:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="419925391"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 05 Aug 2021 11:38:33 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 7FB9D15E; Thu,  5 Aug 2021 21:31:06 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] wwan: core: Avoid returning error pointer from wwan_create_dev()
Date:   Thu,  5 Aug 2021 21:31:00 +0300
Message-Id: <20210805183100.49071-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wwan_create_dev() is expected to return either valid pointer or NULL,
In some cases it might return the error pointer. Prevent this by converting
it to NULL after wwan_dev_get_by_parent().

Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wwan/wwan_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 674a81d79db3..35e10a98e774 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -160,7 +160,9 @@ static struct wwan_device *wwan_create_dev(struct device *parent)
 
 	/* If wwandev already exists, return it */
 	wwandev = wwan_dev_get_by_parent(parent);
-	if (!IS_ERR(wwandev))
+	if (IS_ERR(wwandev))
+		wwandev = NULL;
+	else
 		goto done_unlock;
 
 	id = ida_alloc(&wwan_dev_ids, GFP_KERNEL);
-- 
2.30.2

