Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A0E23A036
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 09:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgHCHXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 03:23:17 -0400
Received: from mail-177132.yeah.net ([123.58.177.132]:32952 "EHLO
        mail-177132.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbgHCHXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 03:23:17 -0400
X-Greylist: delayed 1881 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Aug 2020 03:23:15 EDT
Received: from localhost.localdomain (unknown [220.180.239.201])
        by smtp2 (Coremail) with SMTP id C1UQrABnb3vesydfvXCkGA--.40163S2;
        Mon, 03 Aug 2020 14:51:11 +0800 (CST)
From:   yzc666@netease.com
To:     bjorn@mork.no
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, carl <carl.yin@quectel.com>
Subject: [PATCH]     qmi_wwan: support modify usbnet's rx_urb_size
Date:   Mon,  3 Aug 2020 14:51:05 +0800
Message-Id: <20200803065105.8997-1-yzc666@netease.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: C1UQrABnb3vesydfvXCkGA--.40163S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF1xWw1xury5uFWDZry7Jrb_yoW5Zr1xpF
        W3XayrWrWUJrZrWrsxJF4DW3W3Wr1ru34fG3y2gwnYkrnrXwnrta4UJFyYyrZ3KF98CrWY
        qr4Dta1UGrs8XFJanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jFUDJUUUUU=
X-Originating-IP: [220.180.239.201]
X-CM-SenderInfo: h12fllmw6qv3phdvvhhfrp/1tbiDR91HFszSoasMQAAsC
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: carl <carl.yin@quectel.com>

    When QMUX enabled, the 'dl-datagram-max-size' can be 4KB/16KB/31KB depend on QUALCOMM's chipsets.
    User can set 'dl-datagram-max-size' by 'QMI_WDA_SET_DATA_FORMAT'.
    The usbnet's rx_urb_size must lager than or equal to the 'dl-datagram-max-size'.
    This patch allow user to modify usbnet's rx_urb_size by next command.

		echo 4096 > /sys/class/net/wwan0/qmi/rx_urb_size

		Next commnds show how to set and query 'dl-datagram-max-size' by qmicli
		# qmicli -d /dev/cdc-wdm1 --wda-set-data-format="link-layer-protocol=raw-ip, ul-protocol=qmap,
				dl-protocol=qmap, dl-max-datagrams=32, dl-datagram-max-size=31744, ep-type=hsusb, ep-iface-number=4"
		[/dev/cdc-wdm1] Successfully set data format
		                        QoS flow header: no
		                    Link layer protocol: 'raw-ip'
		       Uplink data aggregation protocol: 'qmap'
		     Downlink data aggregation protocol: 'qmap'
		                          NDP signature: '0'
		Downlink data aggregation max datagrams: '10'
		     Downlink data aggregation max size: '4096'

	    # qmicli -d /dev/cdc-wdm1 --wda-get-data-format
		[/dev/cdc-wdm1] Successfully got data format
		                   QoS flow header: no
		               Link layer protocol: 'raw-ip'
		  Uplink data aggregation protocol: 'qmap'
		Downlink data aggregation protocol: 'qmap'
		                     NDP signature: '0'
		Downlink data aggregation max datagrams: '10'
		Downlink data aggregation max size: '4096'

Signed-off-by: carl <carl.yin@quectel.com>
---
 drivers/net/usb/qmi_wwan.c | 39 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 07c42c0719f5b..8ea57fd99ae43 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -400,6 +400,44 @@ static ssize_t raw_ip_store(struct device *d,  struct device_attribute *attr, co
 	return ret;
 }
 
+static ssize_t rx_urb_size_show(struct device *d, struct device_attribute *attr, char *buf)
+{
+	struct usbnet *dev = netdev_priv(to_net_dev(d));
+
+	return sprintf(buf, "%zd\n", dev->rx_urb_size);
+}
+
+static ssize_t rx_urb_size_store(struct device *d,  struct device_attribute *attr,
+				 const char *buf, size_t len)
+{
+	struct usbnet *dev = netdev_priv(to_net_dev(d));
+	u32 rx_urb_size;
+	int ret;
+
+	if (kstrtou32(buf, 0, &rx_urb_size))
+		return -EINVAL;
+
+	/* no change? */
+	if (rx_urb_size == dev->rx_urb_size)
+		return len;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	/* we don't want to modify a running netdev */
+	if (netif_running(dev->net)) {
+		netdev_err(dev->net, "Cannot change a running device\n");
+		ret = -EBUSY;
+		goto err;
+	}
+
+	dev->rx_urb_size = rx_urb_size;
+	ret = len;
+err:
+	rtnl_unlock();
+	return ret;
+}
+
 static ssize_t add_mux_show(struct device *d, struct device_attribute *attr, char *buf)
 {
 	struct net_device *dev = to_net_dev(d);
@@ -505,6 +543,7 @@ static DEVICE_ATTR_RW(add_mux);
 static DEVICE_ATTR_RW(del_mux);
 
 static struct attribute *qmi_wwan_sysfs_attrs[] = {
+	&dev_attr_rx_urb_size.attr,
 	&dev_attr_raw_ip.attr,
 	&dev_attr_add_mux.attr,
 	&dev_attr_del_mux.attr,
-- 
2.17.1

