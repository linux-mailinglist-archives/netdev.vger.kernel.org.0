Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741133E91DC
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 14:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhHKMtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 08:49:23 -0400
Received: from mga06.intel.com ([134.134.136.31]:3753 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230178AbhHKMtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 08:49:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="276150146"
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="276150146"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 05:48:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="445916469"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 11 Aug 2021 05:48:54 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 4FC46142; Wed, 11 Aug 2021 15:48:53 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 net 1/1] wwan: core: Avoid returning NULL from wwan_create_dev()
Date:   Wed, 11 Aug 2021 15:48:45 +0300
Message-Id: <20210811124845.10955-1-andriy.shevchenko@linux.intel.com>
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
Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
---
v3: split from original series with fixed subject (Sergey)

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

