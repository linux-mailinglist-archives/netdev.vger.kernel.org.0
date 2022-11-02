Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91764615C57
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 07:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbiKBGgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 02:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiKBGgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 02:36:31 -0400
Received: from smtp.smtpout.orange.fr (smtp-28.smtpout.orange.fr [80.12.242.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7921526126
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 23:36:30 -0700 (PDT)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id q7MQoir5CJ83Fq7MQoCnDe; Wed, 02 Nov 2022 07:36:28 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 02 Nov 2022 07:36:28 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next RESEND] net: usb: Use kstrtobool() instead of strtobool()
Date:   Wed,  2 Nov 2022 07:36:23 +0100
Message-Id: <d4432a67b6f769cac0a9ec910ac725298b64e102.1667336095.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

strtobool() is the same as kstrtobool().
However, the latter is more used within the kernel.

In order to remove strtobool() and slightly simplify kstrtox.h, switch to
the other function name.

While at it, include the corresponding header file (<linux/kstrtox.h>).

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch was part of a serie (see [1]), patch 01/30.
This is resent as a stand alone patch so that bots and CI can trigger.

[1]: https://lore.kernel.org/all/cover.1667336095.git.christophe.jaillet@wanadoo.fr/
---
 drivers/net/usb/cdc_ncm.c  | 3 ++-
 drivers/net/usb/qmi_wwan.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 8d5cbda33f66..6b5f24f28dd1 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -43,6 +43,7 @@
 #include <linux/ctype.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
+#include <linux/kstrtox.h>
 #include <linux/workqueue.h>
 #include <linux/mii.h>
 #include <linux/crc32.h>
@@ -318,7 +319,7 @@ static ssize_t ndp_to_end_store(struct device *d,  struct device_attribute *attr
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
 	bool enable;
 
-	if (strtobool(buf, &enable))
+	if (kstrtobool(buf, &enable))
 		return -EINVAL;
 
 	/* no change? */
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 26c34a7c21bd..30d733c81ed8 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -13,6 +13,7 @@
 #include <linux/ethtool.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
+#include <linux/kstrtox.h>
 #include <linux/mii.h>
 #include <linux/rtnetlink.h>
 #include <linux/usb.h>
@@ -343,7 +344,7 @@ static ssize_t raw_ip_store(struct device *d,  struct device_attribute *attr, co
 	bool enable;
 	int ret;
 
-	if (strtobool(buf, &enable))
+	if (kstrtobool(buf, &enable))
 		return -EINVAL;
 
 	/* no change? */
@@ -492,7 +493,7 @@ static ssize_t pass_through_store(struct device *d,
 	struct qmi_wwan_state *info;
 	bool enable;
 
-	if (strtobool(buf, &enable))
+	if (kstrtobool(buf, &enable))
 		return -EINVAL;
 
 	info = (void *)&dev->data;
-- 
2.34.1

