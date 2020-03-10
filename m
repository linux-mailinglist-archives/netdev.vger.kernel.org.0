Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93B01805BD
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 19:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgCJSCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 14:02:02 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35817 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbgCJSCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 14:02:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id r7so17111290wro.2
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 11:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XBayypK4/1mH8FX4bDqcTwlvPGPgyJbmX4IS7XQdDFQ=;
        b=BoKD1N5hRp/4c4/oA8LE1REZthCg79KPOu7zXDRzmh9uU5BAnv9FmPhODB7KIRU4oI
         wvOiFk9wQA3WNQK/l/DC/MTnuY0qRTeAYEGd07S4PzZB4cePn6ckiHV/n38isi/quwgi
         6ltJ8xn2Ts72wbFnG2Jd8G2IDwGe5lPVLyETVhJxsttlnATyhxWnHZBtRrFmT0bCFcCH
         ye13bH3Zr+k2d4fAMlHQSkD9iBAzfIBMRL8eaALTGS5fTUihJlmwhLoAi/Hl3KFIYOGX
         bdvgEgr5PkItf93/ad1W8XX3Pbqjl/f/tbBOKYtAwsLGLG1Efpus3lfQvpWCM9WUEsed
         Nd3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XBayypK4/1mH8FX4bDqcTwlvPGPgyJbmX4IS7XQdDFQ=;
        b=OK+QHaoucTEJEF3Uq0TvqWHKVkmlpVx7XE1CvkynZyEZeO5M48VrKoi9gZ7CzPja/B
         vyxO49isSmr306KMyecdRS+nrt42+bV1bXb8cuX5a8mtOCceLF+Umw8twbIv5xXf1/nA
         3CgLwKIe1z3JVmEvVlCjGlCk8xnqBTJJX4XCD+BszLOd/Kw8Rel3O4Usoxojm4NATwlZ
         PXx38xRvtgn/+KundcnUqF4bXirrMOBUb2cfXYUljsiYw6rsSaU3nUwPFkMmyrEXZRgg
         BgaduoFnvknZaU3AFJOAEdUqNtjfMmPD1rLSKqPv+wsQsAbbvDKNDZ4X/rinv0orrPmb
         ZNuA==
X-Gm-Message-State: ANhLgQ0bdRJ19gLWECihC43oS1G+42BCMWz9bNtkPfJ45CoHc/f09XzT
        DpoQzcPzEVr4wcMaUW3dDE658E+MB2E=
X-Google-Smtp-Source: ADFU+vtm1RgnpOh+spM6Tv3F/SmXAbhtBF1T7FjMGQwHWRdnj75nWuisnEs8wrvThJA6wJ+3qXaVsA==
X-Received: by 2002:a5d:5702:: with SMTP id a2mr22089139wrv.17.1583863319281;
        Tue, 10 Mar 2020 11:01:59 -0700 (PDT)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id b203sm5403466wme.32.2020.03.10.11.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 11:01:57 -0700 (PDT)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Cc:     paul.gildea@gmail.com, netdev@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [RFC PATCH 1/1] net: usb: qmi_wwan: add mtu change functions
Date:   Tue, 10 Mar 2020 19:01:43 +0100
Message-Id: <20200310180143.2790-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch introduces mtu change functions both for master and qmimux
network interfaces in order to properly deal with downlink aggregated
packets feature set from user-space.

rmnet can be configured for downling aggregated packets, requiring
the rx_urb_size to be as much as the value set from user-space with
the proper QMI request (see libqmi wda_set_data_format), so a default
value for rx_urb_size is set when the first qmimux netdevice is created.

Since some modems could require a different (usually higher) value,
an mtu change function for the master netdevice has been added, in
order to link the mtu change with rx_urb_size when qmimux is enabled.
This affects also rx_qlen, but not tx_qlen.

The possibility of modifying the tx_qlen is left to the qmimux mtu
change function.

Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
Hi Bjørn and Paul,

this is an attempt to fix the dl aggregated rx_urb_size related issue
and provide an hook for solving also Paul's issue, that can be done with
a follow-up patch: it currently does not change the behavior when qmap
is not enabled, calling usbnet_change_mtu. Let me know if it is
something that could make sense.

Thanks,
Daniele
---
 drivers/net/usb/qmi_wwan.c | 72 +++++++++++++++++++++++++++++++++++---
 1 file changed, 68 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 5754bb6ca0ee..88bb55736413 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -153,11 +153,30 @@ static void qmimux_get_stats64(struct net_device *net,
 	}
 }
 
+static int qmimux_change_mtu(struct net_device *net, int new_mtu)
+{
+	struct qmimux_priv *priv = netdev_priv(net);
+	struct net_device *real_dev = priv->real_dev;
+	struct usbnet *dev = netdev_priv(real_dev);
+
+	net->mtu = new_mtu;
+	if (dev->hard_mtu < new_mtu + sizeof(struct qmimux_hdr)) {
+		/* rx_urb_size is not in sync with hard_mtu and should
+		 * be changed through qmi_wwan_change_mtu
+		 */
+		dev->hard_mtu = new_mtu + sizeof(struct qmimux_hdr);
+		usbnet_update_max_qlen(dev);
+	}
+
+	return 0;
+}
+
 static const struct net_device_ops qmimux_netdev_ops = {
 	.ndo_open        = qmimux_open,
 	.ndo_stop        = qmimux_stop,
 	.ndo_start_xmit  = qmimux_start_xmit,
 	.ndo_get_stats64 = qmimux_get_stats64,
+	.ndo_change_mtu  = qmimux_change_mtu,
 };
 
 static void qmimux_setup(struct net_device *dev)
@@ -322,6 +341,33 @@ static void qmimux_unregister_device(struct net_device *dev,
 	dev_put(real_dev);
 }
 
+static int qmi_wwan_change_mtu(struct net_device *net, int new_mtu)
+{
+	struct usbnet	*dev = netdev_priv(net);
+	struct qmi_wwan_state *info = (void *)&dev->data;
+
+	if (info->flags & QMI_WWAN_FLAG_MUX) {
+		int old_rx_urb_size = dev->rx_urb_size;
+
+		net->mtu = new_mtu;
+		dev->rx_urb_size = net->mtu;
+
+		if (dev->rx_urb_size > old_rx_urb_size) {
+			usbnet_pause_rx(dev);
+			usbnet_unlink_rx_urbs(dev);
+			usbnet_resume_rx(dev);
+		}
+		/* max qlen depend on hard_mtu and rx_urb_size: hard_mtu is used
+		 * for tx_qlen and is set by qmimux_change_mtu
+		 */
+		usbnet_update_max_qlen(dev);
+
+		return 0;
+	} else {
+		return usbnet_change_mtu(net, new_mtu);
+	}
+}
+
 static void qmi_wwan_netdev_setup(struct net_device *net)
 {
 	struct usbnet *dev = netdev_priv(net);
@@ -345,7 +391,7 @@ static void qmi_wwan_netdev_setup(struct net_device *net)
 	}
 
 	/* recalculate buffers after changing hard_header_len */
-	usbnet_change_mtu(net, net->mtu);
+	qmi_wwan_change_mtu(net, net->mtu);
 }
 
 static ssize_t raw_ip_show(struct device *d, struct device_attribute *attr, char *buf)
@@ -450,7 +496,19 @@ static ssize_t add_mux_store(struct device *d,  struct device_attribute *attr, c
 
 	ret = qmimux_register_device(dev->net, mux_id);
 	if (!ret) {
-		info->flags |= QMI_WWAN_FLAG_MUX;
+		if (!(info->flags & QMI_WWAN_FLAG_MUX)) {
+			info->flags |= QMI_WWAN_FLAG_MUX;
+			/* Setting a default rx_urb_size for dealing with qmap
+			 * downlink data aggregation: this should be good for
+			 * most of the modems, but some could require a larger
+			 * value to be set changing the MTU of the master
+			 * interface
+			 */
+			dev->rx_urb_size = 16384;
+			dev->hard_mtu =
+				ETH_DATA_LEN + sizeof(struct qmimux_hdr);
+			usbnet_update_max_qlen(dev);
+		}
 		ret = len;
 	}
 err:
@@ -492,8 +550,14 @@ static ssize_t del_mux_store(struct device *d,  struct device_attribute *attr, c
 	}
 	qmimux_unregister_device(del_dev, NULL);
 
-	if (!qmimux_has_slaves(dev))
+	if (!qmimux_has_slaves(dev)) {
 		info->flags &= ~QMI_WWAN_FLAG_MUX;
+		/* Restore mtu to eth default */
+		dev->net->mtu = ETH_DATA_LEN;
+		dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
+		dev->rx_urb_size = dev->hard_mtu;
+		qmi_wwan_netdev_setup(dev->net);
+	}
 	ret = len;
 err:
 	rtnl_unlock();
@@ -619,7 +683,7 @@ static const struct net_device_ops qmi_wwan_netdev_ops = {
 	.ndo_stop		= usbnet_stop,
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
-	.ndo_change_mtu		= usbnet_change_mtu,
+	.ndo_change_mtu		= qmi_wwan_change_mtu,
 	.ndo_get_stats64	= usbnet_get_stats64,
 	.ndo_set_mac_address	= qmi_wwan_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-- 
2.17.1

