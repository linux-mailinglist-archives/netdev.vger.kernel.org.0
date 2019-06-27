Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7DE5774D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbfF0Apn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728661AbfF0Akz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:40:55 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD127205ED;
        Thu, 27 Jun 2019 00:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561596054;
        bh=7/1DSFg69VhOmR5parl9oVNvXdxXXvIKGHrdgROtRvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0qFEmI5aa9W0XBLWl2sNq5cOxgSXlJGcdyh9xf4S+dF5DZ3oOnFEbJM121OURDZWJ
         GFMbu9yd43Bfh+C68F+z5/Bjz9ZGuX88eHVIpC67lM2Tm6AgnaNdFpyE94Y60wMFet
         JwVgbDw/d0uJCNGxvbvV5qiIenqUS3CPwux0xxfs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Reinhard Speyerer <rspmn@arcor.de>,
        Daniele Palmas <dnlplm@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 26/35] qmi_wwan: avoid RCU stalls on device disconnect when in QMAP mode
Date:   Wed, 26 Jun 2019 20:39:14 -0400
Message-Id: <20190627003925.21330-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003925.21330-1-sashal@kernel.org>
References: <20190627003925.21330-1-sashal@kernel.org>
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
index 023bb2daa72f..a77223887022 100644
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
@@ -1423,6 +1424,7 @@ static void qmi_wwan_disconnect(struct usb_interface *intf)
 	struct qmi_wwan_state *info;
 	struct list_head *iter;
 	struct net_device *ldev;
+	LIST_HEAD(list);
 
 	/* called twice if separate control and data intf */
 	if (!dev)
@@ -1435,8 +1437,9 @@ static void qmi_wwan_disconnect(struct usb_interface *intf)
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

