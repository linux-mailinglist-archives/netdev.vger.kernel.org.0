Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E8F3E91EA
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 14:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhHKMuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 08:50:40 -0400
Received: from mga04.intel.com ([192.55.52.120]:44140 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhHKMuk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 08:50:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="213262055"
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="213262055"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 05:50:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="503485833"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga001.jf.intel.com with ESMTP; 11 Aug 2021 05:50:12 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 3C2EE142; Wed, 11 Aug 2021 15:50:12 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 net-next 1/1] wwan: core: Unshadow error code returned by ida_alloc_range))
Date:   Wed, 11 Aug 2021 15:50:10 +0300
Message-Id: <20210811125010.11167-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ida_alloc_range() may return other than -ENOMEM error code.
Unshadow it in the wwan_create_port().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
---
v3: split from original series with fixed subject and typo in body (Sergey)

 drivers/net/wwan/wwan_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 35ece98134c0..d293ab688044 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -359,8 +359,8 @@ struct wwan_port *wwan_create_port(struct device *parent,
 {
 	struct wwan_device *wwandev;
 	struct wwan_port *port;
-	int minor, err = -ENOMEM;
 	char namefmt[0x20];
+	int minor, err;
 
 	if (type > WWAN_PORT_MAX || !ops)
 		return ERR_PTR(-EINVAL);
@@ -374,11 +374,14 @@ struct wwan_port *wwan_create_port(struct device *parent,
 
 	/* A port is exposed as character device, get a minor */
 	minor = ida_alloc_range(&minors, 0, WWAN_MAX_MINORS - 1, GFP_KERNEL);
-	if (minor < 0)
+	if (minor < 0) {
+		err = minor;
 		goto error_wwandev_remove;
+	}
 
 	port = kzalloc(sizeof(*port), GFP_KERNEL);
 	if (!port) {
+		err = -ENOMEM;
 		ida_free(&minors, minor);
 		goto error_wwandev_remove;
 	}
-- 
2.30.2

