Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4BA3AF8CD
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbhFUWxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbhFUWx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 18:53:26 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E306CC061574
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:10 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id u11so16483197ljh.2
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 15:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7l78aaQEjWX2/qGdM6ykVAxXCOzp5I0Tf9JvJqtJA7Y=;
        b=fWER/Ne3JysnTovM/VRwXqI7ddwm6jbcLvEANONEJsBzZWXm7yavsyMyGAURLJQ1WL
         zwnW8SzrWgQ+fyN50NrauUOadT4rYKp6j00zsgDT6fv7zHc1GJY79QP+7JVQI6l64Lke
         EfyhJlReCAwcZXFTjlpdgXB5ZDUH8VSfMJUKQ/uX8zLSXEweJxlCCof574nHyb6s143E
         iMsMkiFDW8lMAEYpMDEYj6CUtpTvZIaZxaUBh9OZMG2Wr6kgfNvd/6SvE5/oMmCNq7Jj
         o6Se1pX+dGxwuZ30+nUPujXziMLQM3S4KO5yej4AZIfijJTK/NeCkYtbQx8Cl72uxyM4
         ke6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7l78aaQEjWX2/qGdM6ykVAxXCOzp5I0Tf9JvJqtJA7Y=;
        b=ZTWA7zLjNCp7usbWuRzX7oSHUg36IOD4a3GmOBc3uUsnZw/9V48q7/lGTVFozhsvDb
         Vco93A7f4mn7JsI34y+zarfroJRVc6sOTxybLBVeV2x2Hn43ZMtinuK+dkRTJdN/3nQy
         vx02USx/Yucit/HmcAKyXXwhoFBWAmCRkMP0kwqDoMhQNZhYjnyOy8dBqYzPqzUt+seC
         GmkkChLRf5LAeA0mp2VOKg+Zw7ySEDrJxXaxtH0QICBCDp8BXzbRihnCRiIIgtH/LipC
         Lu1xFfM5G08H/FMLp89HcjKF04h3GN7dC9ZWrCrKssGmp0ep3sqLdplI0iVLPqf0lg/1
         F4cw==
X-Gm-Message-State: AOAM530tARL/qQ4fwQw1BfDvjTTRDoq1H6nyNd51UZtNg7Cpw1ahit4Y
        ofYAMhcp/mGKYFDC/bVHC8I=
X-Google-Smtp-Source: ABdhPJw888xvbNW8VlchvIkYZyY393oSDxthVoHFonZC7yKPjjitxGt1CO94K7qLYQmclAr9sG7Z5g==
X-Received: by 2002:a2e:9855:: with SMTP id e21mr441799ljj.295.1624315869331;
        Mon, 21 Jun 2021 15:51:09 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id x207sm124826lff.53.2021.06.21.15.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 15:51:08 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 05/10] wwan: core: remove all netdevs on ops unregistering
Date:   Tue, 22 Jun 2021 01:50:55 +0300
Message-Id: <20210621225100.21005-6-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
References: <20210621225100.21005-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We use the ops owner module hold to protect against ops memory
disappearing. But this approach does not protect us from a driver that
unregisters ops but forgets to remove netdev(s) that were created using
this ops. In such case, we are left with netdev(s), which can not be
removed since ops is gone. Moreover, batch netdevs removing on
deinitialization is a desireable option for WWAN drivers as it is a
quite common task.

Implement deletion of all created links on WWAN netdev ops unregistering
in the same way that RTNL removes all links on RTNL ops unregistering.
Simply remove all child netdevs of a device whose WWAN netdev ops is
unregistering. This way we protecting the kernel from buggy drivers and
make it easier to write a driver deinitialization code.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---

v1 -> v2:
 * no changes

 drivers/net/wwan/wwan_core.c | 40 ++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index b6b9c52f617c..ec6a69b23dd1 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -941,6 +941,17 @@ int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
 }
 EXPORT_SYMBOL_GPL(wwan_register_ops);
 
+/* Enqueue child netdev deletion */
+static int wwan_child_dellink(struct device *dev, void *data)
+{
+	struct list_head *kill_list = data;
+
+	if (dev->type == &wwan_type)
+		wwan_rtnl_dellink(to_net_dev(dev), kill_list);
+
+	return 0;
+}
+
 /**
  * wwan_unregister_ops - remove WWAN device ops
  * @parent: Device to use as parent and shared by all WWAN ports and
@@ -949,26 +960,37 @@ EXPORT_SYMBOL_GPL(wwan_register_ops);
 void wwan_unregister_ops(struct device *parent)
 {
 	struct wwan_device *wwandev = wwan_dev_get_by_parent(parent);
-	bool has_ops;
+	struct module *owner;
+	LIST_HEAD(kill_list);
 
 	if (WARN_ON(IS_ERR(wwandev)))
 		return;
-
-	has_ops = wwandev->ops;
+	if (WARN_ON(!wwandev->ops)) {
+		put_device(&wwandev->dev);
+		return;
+	}
 
 	/* put the reference obtained by wwan_dev_get_by_parent(),
 	 * we should still have one (that the owner is giving back
-	 * now) due to the ops being assigned, check that below
-	 * and return if not.
+	 * now) due to the ops being assigned.
 	 */
 	put_device(&wwandev->dev);
 
-	if (WARN_ON(!has_ops))
-		return;
+	owner = wwandev->ops->owner;	/* Preserve ops owner */
+
+	rtnl_lock();	/* Prevent concurent netdev(s) creation/destroying */
+
+	/* Remove all child netdev(s), using batch removing */
+	device_for_each_child(&wwandev->dev, &kill_list,
+			      wwan_child_dellink);
+	unregister_netdevice_many(&kill_list);
+
+	wwandev->ops = NULL;	/* Finally remove ops */
+
+	rtnl_unlock();
 
-	module_put(wwandev->ops->owner);
+	module_put(owner);
 
-	wwandev->ops = NULL;
 	wwandev->ops_ctxt = NULL;
 	wwan_remove_dev(wwandev);
 }
-- 
2.26.3

