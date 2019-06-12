Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD9CE42D2C
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409515AbfFLRMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:12:47 -0400
Received: from vsmx011.vodafonemail.xion.oxcs.net ([153.92.174.89]:50541 "EHLO
        vsmx011.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403940AbfFLRMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:12:47 -0400
Received: from vsmx003.vodafonemail.xion.oxcs.net (unknown [192.168.75.197])
        by mta-5-out.mta.xion.oxcs.net (Postfix) with ESMTP id 17F083E0270;
        Wed, 12 Jun 2019 17:03:31 +0000 (UTC)
Received: from arcor.de (unknown [2.247.255.147])
        by mta-7-out.mta.xion.oxcs.net (Postfix) with ESMTPA id 9610D3005D6;
        Wed, 12 Jun 2019 17:03:22 +0000 (UTC)
Date:   Wed, 12 Jun 2019 19:03:15 +0200
From:   Reinhard Speyerer <rspmn@arcor.de>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     Daniele Palmas <dnlplm@gmail.com>, netdev@vger.kernel.org,
        rspmn@arcor.de
Subject: [PATCH 3/4] qmi_wwan: avoid RCU stalls on device disconnect when in
 QMAP mode
Message-ID: <fbb0cab5f36550668dd4dc6ecdb5eafa90a6e655.1560287477.git.rspmn@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1560287477.git.rspmn@arcor.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-VADE-STATUS: LEGIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch qmimux_unregister_device() and qmi_wwan_disconnect() to
use unregister_netdevice_queue() and unregister_netdevice_many()
instead of unregister_netdevice(). This avoids RCU stalls which
have been observed on device disconnect in certain setups otherwise.

Fixes: c6adf77953bc ("net: usb: qmi_wwan: add qmap mux protocol support")
Cc: Daniele Palmas <dnlplm@gmail.com>
Signed-off-by: Reinhard Speyerer <rspmn@arcor.de>
---
 drivers/net/usb/qmi_wwan.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index b0a96459621f..c6fbc2a2a785 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -312,14 +312,15 @@ static int qmimux_register_device(struct net_device *real_dev, u8 mux_id)
 	return err;
 }
 
-static void qmimux_unregister_device(struct net_device *dev)
+static void qmimux_unregister_device(struct net_device *dev,
+				     struct list_head *head)
 {
 	struct qmimux_priv *priv = netdev_priv(dev);
 	struct net_device *real_dev = priv->real_dev;
 
 	free_percpu(priv->stats64);
 	netdev_upper_dev_unlink(real_dev, dev);
-	unregister_netdevice(dev);
+	unregister_netdevice_queue(dev, head);
 
 	/* Get rid of the reference to real_dev */
 	dev_put(real_dev);
@@ -490,7 +491,7 @@ static ssize_t del_mux_store(struct device *d,  struct device_attribute *attr, c
 		ret = -EINVAL;
 		goto err;
 	}
-	qmimux_unregister_device(del_dev);
+	qmimux_unregister_device(del_dev, NULL);
 
 	if (!qmimux_has_slaves(dev))
 		info->flags &= ~QMI_WWAN_FLAG_MUX;
@@ -1500,6 +1501,7 @@ static void qmi_wwan_disconnect(struct usb_interface *intf)
 	struct qmi_wwan_state *info;
 	struct list_head *iter;
 	struct net_device *ldev;
+	LIST_HEAD(list);
 
 	/* called twice if separate control and data intf */
 	if (!dev)
@@ -1512,8 +1514,9 @@ static void qmi_wwan_disconnect(struct usb_interface *intf)
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
2.11.0

