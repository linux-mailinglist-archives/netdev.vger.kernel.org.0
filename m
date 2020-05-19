Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D3C1DA359
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 23:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgESVP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 17:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbgESVPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 17:15:55 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FE7F20826;
        Tue, 19 May 2020 21:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589922954;
        bh=BsSOFtmV7u1jPVJuOgFAo1ISyFJ3dm/VGxsNz+31aOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+l/QP7Caz+Vwato0aIZ7fKNtE51zlgpMpSQsd0GfvW0A3K4eg911OVDEr52MNiQ7
         6JXWtncJ6risFf9z6fpmyvnU89qnHG8acFt1iU8brX8dJGMTxgeKGIevP4JlzcYeJJ
         RSrcjrxbGiTzzj232j3DIXn45/4eT7ADalrFwdqc=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mcgrof@kernel.org
Cc:     johannes@sipsolutions.net, derosier@gmail.com,
        greearb@candelatech.com, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, jiri@resnulli.us,
        briannorris@chromium.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC 2/2] i2400m: use devlink health reporter
Date:   Tue, 19 May 2020 14:15:31 -0700
Message-Id: <20200519211531.3702593-2-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200519010530.GS11244@42.do-not-panic.com>
References: <20200519010530.GS11244@42.do-not-panic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It builds.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/wimax/i2400m/rx.c  | 2 ++
 drivers/net/wimax/i2400m/usb.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wimax/i2400m/rx.c b/drivers/net/wimax/i2400m/rx.c
index c9fb619a9e01..cc7fe78f2df0 100644
--- a/drivers/net/wimax/i2400m/rx.c
+++ b/drivers/net/wimax/i2400m/rx.c
@@ -144,6 +144,7 @@
  *       i2400m_msg_size_check
  *       wimax_msg
  */
+#include <linux/devlink.h>
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
@@ -712,6 +713,7 @@ void __i2400m_roq_queue(struct i2400m *i2400m, struct i2400m_roq *roq,
 	dev_err(dev, "SW BUG? failed to insert packet\n");
 	dev_err(dev, "ERX: roq %p [ws %u] skb %p nsn %d sn %u\n",
 		roq, roq->ws, skb, nsn, roq_data->sn);
+	devlink_simple_fw_reporter_report_crash(dev);
 	skb_queue_walk(&roq->queue, skb_itr) {
 		roq_data_itr = (struct i2400m_roq_data *) &skb_itr->cb;
 		nsn_itr = __i2400m_roq_nsn(roq, roq_data_itr->sn);
diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/net/wimax/i2400m/usb.c
index 9659f9e1aaa6..5c811dccbf1d 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -49,6 +49,7 @@
  *   usb_reset_device()
  */
 #include "i2400m-usb.h"
+#include <linux/devlink.h>
 #include <linux/wimax/i2400m.h>
 #include <linux/debugfs.h>
 #include <linux/slab.h>
@@ -423,6 +424,8 @@ int i2400mu_probe(struct usb_interface *iface,
 	if (usb_dev->speed != USB_SPEED_HIGH)
 		dev_err(dev, "device not connected as high speed\n");
 
+	devlink_simple_fw_reporter_prepare(dev);
+
 	/* Allocate instance [calls i2400m_netdev_setup() on it]. */
 	result = -ENOMEM;
 	net_dev = alloc_netdev(sizeof(*i2400mu), "wmx%d", NET_NAME_UNKNOWN,
@@ -506,6 +509,7 @@ int i2400mu_probe(struct usb_interface *iface,
 	usb_put_dev(i2400mu->usb_dev);
 	free_netdev(net_dev);
 error_alloc_netdev:
+	devlink_simple_fw_reporter_cleanup(dev);
 	return result;
 }
 
@@ -532,6 +536,7 @@ void i2400mu_disconnect(struct usb_interface *iface)
 	usb_set_intfdata(iface, NULL);
 	usb_put_dev(i2400mu->usb_dev);
 	free_netdev(net_dev);
+	devlink_simple_fw_reporter_cleanup(dev);
 	d_fnend(3, dev, "(iface %p i2400m %p) = void\n", iface, i2400m);
 }
 
-- 
2.25.4

