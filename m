Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A23C483080
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 13:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732827AbfHFLTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 07:19:04 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:57490 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732800AbfHFLTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 07:19:04 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x76BJ2iW023734, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x76BJ2iW023734
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 6 Aug 2019 19:19:02 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.439.0; Tue, 6 Aug 2019
 19:19:00 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 5/5] r8152: change rx_frag_head_sz and rx_max_agg_num dynamically
Date:   Tue, 6 Aug 2019 19:18:04 +0800
Message-ID: <1394712342-15778-294-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-289-albertk@realtek.com>
References: <1394712342-15778-289-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let rx_frag_head_sz and rx_max_agg_num could be modified dynamically
through the sysfs.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 119 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 115 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 1615900c8592..0b4d439f603a 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -26,7 +26,7 @@
 #include <linux/acpi.h>
 
 /* Information for net-next */
-#define NETNEXT_VERSION		"09"
+#define NETNEXT_VERSION		"10"
 
 /* Information for net */
 #define NET_VERSION		"10"
@@ -756,6 +756,9 @@ struct r8152 {
 	u32 tx_qlen;
 	u32 coalesce;
 	u32 rx_buf_sz;
+	u32 rx_frag_head_sz;
+	u32 rx_max_agg_num;
+
 	u16 ocp_base;
 	u16 speed;
 	u8 *intr_buff;
@@ -1992,7 +1995,7 @@ static struct rx_agg *rtl_get_free_rx(struct r8152 *tp, gfp_t mflags)
 
 	spin_unlock_irqrestore(&tp->rx_lock, flags);
 
-	if (!agg_free && atomic_read(&tp->rx_count) < RTL8152_MAX_RX_AGG)
+	if (!agg_free && atomic_read(&tp->rx_count) < tp->rx_max_agg_num)
 		agg_free = alloc_rx_agg(tp, mflags);
 
 	return agg_free;
@@ -2072,10 +2075,10 @@ static int rx_bottom(struct r8152 *tp, int budget)
 			pkt_len -= ETH_FCS_LEN;
 			rx_data += sizeof(struct rx_desc);
 
-			if (!agg_next || RTL8152_RXFG_HEADSZ > pkt_len)
+			if (!agg_next || tp->rx_frag_head_sz > pkt_len)
 				rx_frag_head_sz = pkt_len;
 			else
-				rx_frag_head_sz = RTL8152_RXFG_HEADSZ;
+				rx_frag_head_sz = tp->rx_frag_head_sz;
 
 			skb = napi_alloc_skb(napi, rx_frag_head_sz);
 			if (!skb) {
@@ -5383,6 +5386,101 @@ static u8 rtl_get_version(struct usb_interface *intf)
 	return version;
 }
 
+static ssize_t rx_frag_head_sz_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct r8152 *tp = usb_get_intfdata(intf);
+
+	sprintf(buf, "%u\n", tp->rx_frag_head_sz);
+
+	return strlen(buf);
+}
+
+static ssize_t rx_frag_head_sz_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct usb_interface *intf;
+	u32 rx_frag_head_sz;
+	struct r8152 *tp;
+
+	intf = to_usb_interface(dev);
+	tp = usb_get_intfdata(intf);
+
+	if (sscanf(buf, "%u\n", &rx_frag_head_sz) != 1)
+		return -EINVAL;
+
+	if (rx_frag_head_sz < ETH_ZLEN)
+		return -EINVAL;
+
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return -ENODEV;
+
+	if (tp->rx_frag_head_sz != rx_frag_head_sz) {
+		napi_disable(&tp->napi);
+		tp->rx_frag_head_sz = rx_frag_head_sz;
+		napi_enable(&tp->napi);
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(rx_frag_head_sz);
+
+static ssize_t rx_max_agg_num_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct usb_interface *intf = to_usb_interface(dev);
+	struct r8152 *tp = usb_get_intfdata(intf);
+
+	sprintf(buf, "%u\n", tp->rx_max_agg_num);
+
+	return strlen(buf);
+}
+
+static ssize_t rx_max_agg_num_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct usb_interface *intf;
+	u32 rx_max_agg_num;
+	struct r8152 *tp;
+
+	intf = to_usb_interface(dev);
+	tp = usb_get_intfdata(intf);
+
+	if (sscanf(buf, "%u\n", &rx_max_agg_num) != 1)
+		return -EINVAL;
+
+	if (rx_max_agg_num < (RTL8152_MAX_RX * 2))
+		return -EINVAL;
+
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return -ENODEV;
+
+	if (tp->rx_max_agg_num != rx_max_agg_num) {
+		napi_disable(&tp->napi);
+		tp->rx_max_agg_num = rx_max_agg_num;
+		napi_enable(&tp->napi);
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(rx_max_agg_num);
+
+static struct attribute *rtk_adv_attrs[] = {
+	&dev_attr_rx_frag_head_sz.attr,
+	&dev_attr_rx_max_agg_num.attr,
+	NULL
+};
+
+static struct attribute_group rtk_adv_grp = {
+	.name = "rtl_adv",
+	.attrs = rtk_adv_attrs,
+};
+
 static int rtl8152_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -5487,6 +5585,9 @@ static int rtl8152_probe(struct usb_interface *intf,
 	tp->speed = tp->mii.supports_gmii ? SPEED_1000 : SPEED_100;
 	tp->duplex = DUPLEX_FULL;
 
+	tp->rx_frag_head_sz = RTL8152_RXFG_HEADSZ;
+	tp->rx_max_agg_num = RTL8152_MAX_RX_AGG;
+
 	intf->needs_remote_wakeup = 1;
 
 	tp->rtl_ops.init(tp);
@@ -5513,8 +5614,16 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	netif_info(tp, probe, netdev, "%s\n", DRIVER_VERSION);
 
+	ret = sysfs_create_group(&intf->dev.kobj, &rtk_adv_grp);
+	if (ret < 0) {
+		netif_err(tp, probe, netdev, "creat rtk_adv_grp fail\n");
+		goto out2;
+	}
+
 	return 0;
 
+out2:
+	unregister_netdev(netdev);
 out1:
 	netif_napi_del(&tp->napi);
 	usb_set_intfdata(intf, NULL);
@@ -5527,6 +5636,8 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 {
 	struct r8152 *tp = usb_get_intfdata(intf);
 
+	sysfs_remove_group(&intf->dev.kobj, &rtk_adv_grp);
+
 	usb_set_intfdata(intf, NULL);
 	if (tp) {
 		rtl_set_unplug(tp);
-- 
2.21.0

