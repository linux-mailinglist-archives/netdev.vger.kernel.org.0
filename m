Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912A7575FE
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfF0Aeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728049AbfF0Ae2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:34:28 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BE772184C;
        Thu, 27 Jun 2019 00:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595668;
        bh=OaJ8YQFmVlqIGTvmOIj3W8cEQP2IORmxLmRcS7NdN1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6lAzKGZDUrIbZxghQtPsaEzNLKi27d8AoiPfHYfxPVMP8j0POuoIB7GJFpSfuWi5
         W2TaICX3Hm2zuhcUCLykBOWLesp1yYyGBB0h7kiGz/X52CDYDkD2LSyh94KDcSM4Y9
         pHdk25W4Kvg+gXwfo4ASdeL8p5tpVAQwjINezQSs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Reinhard Speyerer <rspmn@arcor.de>,
        Daniele Palmas <dnlplm@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 73/95] qmi_wwan: avoid RCU stalls on device disconnect when in QMAP mode
Date:   Wed, 26 Jun 2019 20:29:58 -0400
Message-Id: <20190627003021.19867-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Reinhard Speyerer <rspmn@arcor.de>

[ Upstream commit a8fdde1cb830e560208af42b6c10750137f53eb3 ]

Switch qmimux_unregister_device() and qmi_wwan_disconnect() to
use unregister_netdevice_queue() and unregister_netdevice_many()
instead of unregister_netdevice(). This avoids RCU stalls which
have been observed on device disconnect in certain setups otherwise.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Cc: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/qmi_wwan.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index fd3d078a1923..4165113c435a 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -247,13 +247,14 @@ static int qmimux_register_device(struct net_device *real_dev, u8 mux_id)
 	return err;
 }
 
-static void qmimux_unregister_device(struct net_device *dev)
+static void qmimux_unregister_device(struct net_device *dev,
+				     struct list_head *head)
 {
 	struct qmimux_priv *priv = netdev_priv(dev);
 	struct net_device *real_dev = priv->real_dev;
 
 	netdev_upper_dev_unlink(real_dev, dev);
-	unregister_netdevice(dev);
+	unregister_netdevice_queue(dev, head);
 
 	/* Get rid of the reference to real_dev */
 	dev_put(real_dev);
@@ -424,7 +425,7 @@ static ssize_t del_mux_store(struct device *d,  struct device_attribute *attr, c
 		ret = -EINVAL;
 		goto err;
 	}
-	qmimux_unregister_device(del_dev);
+	qmimux_unregister_device(del_dev, NULL);
 
 	if (!qmimux_has_slaves(dev))
 		info->flags &= ~QMI_WWAN_FLAG_MUX;
@@ -1434,6 +1435,7 @@ static void qmi_wwan_disconnect(struct usb_interface *intf)
 	struct qmi_wwan_state *info;
 	struct list_head *iter;
 	struct net_device *ldev;
+	LIST_HEAD(list);
 
 	/* called twice if separate control and data intf */
 	if (!dev)
@@ -1446,8 +1448,9 @@ static void qmi_wwan_disconnect(struct usb_interface *intf)
 		}
 		rcu_read_lock();
 		netdev_for_each_upper_dev_rcu(dev->net, ldev, iter)
-			qmimux_unregister_device(ldev);
+			qmimux_unregister_device(ldev, &list);
 		rcu_read_unlock();
+		unregister_netdevice_many(&list);
 		rtnl_unlock();
 		info->flags &= ~QMI_WWAN_FLAG_MUX;
 	}
-- 
2.20.1

