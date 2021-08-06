Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C703E26AB
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244093AbhHFJBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:01:12 -0400
Received: from mga05.intel.com ([192.55.52.43]:22866 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243869AbhHFJBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 05:01:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="299924788"
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="299924788"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 02:00:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,300,1620716400"; 
   d="scan'208";a="513320758"
Received: from black.fi.intel.com ([10.237.72.28])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Aug 2021 02:00:54 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 539FB11C; Fri,  6 Aug 2021 11:54:19 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 1/2] wwan: core: Avoid returning NULL from wwan_create_dev()
Date:   Fri,  6 Aug 2021 11:54:12 +0300
Message-Id: <20210806085413.61536-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make wwan_create_dev() to return either valid or error pointer,
In some cases it may return NULL. Prevent this by converting
it to the respective error pointer.

Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: rewrote to return error pointer, align callers (Loic)
 drivers/net/wwan/wwan_core.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 674a81d79db3..35ece98134c0 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -164,11 +164,14 @@ static struct wwan_device *wwan_create_dev(struct device *parent)
 		goto done_unlock;
 
 	id = ida_alloc(&wwan_dev_ids, GFP_KERNEL);
-	if (id < 0)
+	if (id < 0) {
+		wwandev = ERR_PTR(id);
 		goto done_unlock;
+	}
 
 	wwandev = kzalloc(sizeof(*wwandev), GFP_KERNEL);
 	if (!wwandev) {
+		wwandev = ERR_PTR(-ENOMEM);
 		ida_free(&wwan_dev_ids, id);
 		goto done_unlock;
 	}
@@ -182,7 +185,8 @@ static struct wwan_device *wwan_create_dev(struct device *parent)
 	err = device_register(&wwandev->dev);
 	if (err) {
 		put_device(&wwandev->dev);
-		wwandev = NULL;
+		wwandev = ERR_PTR(err);
+		goto done_unlock;
 	}
 
 done_unlock:
@@ -1014,8 +1018,8 @@ int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
 		return -EINVAL;
 
 	wwandev = wwan_create_dev(parent);
-	if (!wwandev)
-		return -ENOMEM;
+	if (IS_ERR(wwandev))
+		return PTR_ERR(wwandev);
 
 	if (WARN_ON(wwandev->ops)) {
 		wwan_remove_dev(wwandev);
-- 
2.30.2

