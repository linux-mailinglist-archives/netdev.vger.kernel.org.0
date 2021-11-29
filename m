Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986CC4611EB
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 11:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbhK2KS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 05:18:56 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:38100 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbhK2KQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 05:16:55 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1ATADZWJ0027609, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1ATADZWJ0027609
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Nov 2021 18:13:35 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 18:13:35 +0800
Received: from fc34.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Mon, 29 Nov
 2021 18:13:33 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [RFC PATCH 4/4] r8169: add sysfs for dash
Date:   Mon, 29 Nov 2021 18:13:15 +0800
Message-ID: <20211129101315.16372-385-nic_swsd@realtek.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211129101315.16372-381-nic_swsd@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXH36504.realtek.com.tw (172.21.6.27) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 11/29/2021 10:02:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzExLzI5IKRXpMggMDg6MjY6MDA=?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the sysfs for dash. Then the application could configure the
firmware through them.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/ethernet/realtek/r8169_dash.c | 131 +++++++++++++++
 drivers/net/ethernet/realtek/r8169_dash.h |   8 +
 drivers/net/ethernet/realtek/r8169_main.c | 188 +++++++++++++++++++++-
 3 files changed, 326 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_dash.c b/drivers/net/ethernet/realtek/r8169_dash.c
index acee7519e9f1..197feb2c4a23 100644
--- a/drivers/net/ethernet/realtek/r8169_dash.c
+++ b/drivers/net/ethernet/realtek/r8169_dash.c
@@ -754,3 +754,134 @@ void rtl_dash_interrupt(struct rtl_dash *dash)
 	tasklet_schedule(&dash->tl);
 }
 
+int rtl_dash_to_fw(struct rtl_dash *dash, u8 *src, int size)
+{
+	int ret;
+	long t;
+
+	if (dash->cmac_state != CMAC_STATE_RUNNING)
+		return -ENETDOWN;
+
+	spin_lock_bh(&dash->cmac_lock);
+	ret = dash_rx_data(dash, NULL, 0);
+	spin_unlock_bh(&dash->cmac_lock);
+	if (ret < 0)
+		return -EUCLEAN;
+
+	reinit_completion(&dash->cmac_tx);
+	reinit_completion(&dash->fw_ack);
+
+	spin_lock_bh(&dash->cmac_lock);
+	ret = cmac_start_xmit(dash, src, size, false);
+	spin_unlock_bh(&dash->cmac_lock);
+
+	if (ret < 0)
+		goto err;
+
+	t = wait_for_completion_interruptible_timeout(&dash->cmac_tx,
+						      CMAC_TIMEOUT);
+	if (!t) {
+		ret = -ETIMEDOUT;
+		dev_err(&dash->pdev_cmac->dev, "CMAC tx timeout\n");
+		goto err;
+	} else if (t < 0) {
+		ret = t;
+		dev_err(&dash->pdev_cmac->dev, "CMAC tx fail %ld\n", t);
+		goto err;
+	}
+
+	t = wait_for_completion_interruptible_timeout(&dash->fw_ack,
+						      CMAC_TIMEOUT);
+	if (!t) {
+		ret = -ETIMEDOUT;
+		dev_err(&dash->pdev_cmac->dev, "FW ACK timeout\n");
+	} else if (t < 0) {
+		ret = t;
+		dev_err(&dash->pdev_cmac->dev, "FW ACK fail %ld\n", t);
+	}
+
+err:
+	return ret;
+}
+
+int rtl_dash_from_fw(struct rtl_dash *dash, u8 *src, int size)
+{
+	int ret;
+	long t;
+
+	if (dash->cmac_state != CMAC_STATE_RUNNING)
+		return -ENETDOWN;
+
+	reinit_completion(&dash->cmac_rx);
+
+	spin_lock_bh(&dash->cmac_lock);
+	ret = dash_rx_data(dash, src, size);
+	spin_unlock_bh(&dash->cmac_lock);
+
+	if (ret)
+		goto out;
+
+	t = wait_for_completion_interruptible_timeout(&dash->cmac_rx,
+						      CMAC_TIMEOUT);
+	if (!t) {
+		dev_warn(&dash->pdev_cmac->dev, "CMAC data timeout\n");
+	} else if (t < 0) {
+		ret = t;
+		dev_err(&dash->pdev_cmac->dev, "Wait CMAC data fail %ld\n", t);
+		goto out;
+	}
+
+	spin_lock_bh(&dash->cmac_lock);
+	ret = dash_rx_data(dash, src, size);
+	spin_unlock_bh(&dash->cmac_lock);
+
+out:
+	return ret;
+}
+
+void rtl_dash_set_ap_ready(struct rtl_dash *dash, bool enable)
+{
+	struct rtl8169_private *tp = dash->tp;
+	u32 data;
+
+	data = r8168ep_ocp_read(tp, 0x124);
+	if (enable)
+		data |= BIT(1);
+	else
+		data &= ~BIT(1);
+	r8168ep_ocp_write(tp, 0x1, 0x124, data);
+}
+
+bool rtl_dash_get_ap_ready(struct rtl_dash *dash)
+{
+	struct rtl8169_private *tp = dash->tp;
+
+	if (r8168ep_ocp_read(tp, 0x124) & BIT(1))
+		return true;
+	else
+		return false;
+}
+
+ssize_t rtl_dash_info(struct rtl_dash *dash, char *buf)
+{
+	struct rtl8169_private *tp = dash->tp;
+	char *dest = buf;
+	int size;
+	u32 data;
+
+	data = r8168ep_ocp_read(tp, 0x120);
+	size = sprintf(dest, "FW_VERSION=0x%08X\n", data);
+	if (size > 0)
+		dest += size;
+	else
+		return size;
+
+	data = r8168ep_ocp_read(tp, 0x174);
+	size = sprintf(dest, "FW_BUILD=0x%08X\n", data);
+	if (size > 0)
+		dest += size;
+	else
+		return size;
+
+	return strlen(buf) + 1;
+}
diff --git a/drivers/net/ethernet/realtek/r8169_dash.h b/drivers/net/ethernet/realtek/r8169_dash.h
index 1e9a54a3df1b..b33f3adeef13 100644
--- a/drivers/net/ethernet/realtek/r8169_dash.h
+++ b/drivers/net/ethernet/realtek/r8169_dash.h
@@ -16,6 +16,14 @@ void rtl_dash_up(struct rtl_dash *dash);
 void rtl_dash_down(struct rtl_dash *dash);
 void rtl_dash_cmac_reset_indicate(struct rtl_dash *dash);
 void rtl_dash_interrupt(struct rtl_dash *dash);
+void rtl_dash_set_ap_ready(struct rtl_dash *dash, bool enable);
+
+int rtl_dash_to_fw(struct rtl_dash *dash, u8 *src, int size);
+int rtl_dash_from_fw(struct rtl_dash *dash, u8 *src, int size);
+
+bool rtl_dash_get_ap_ready(struct rtl_dash *dash);
+
+ssize_t rtl_dash_info(struct rtl_dash *dash, char *buf);
 
 struct rtl_dash *rtl_request_dash(struct rtl8169_private *tp,
 				  struct pci_dev *pci_dev, enum mac_version ver,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 83da05e5769e..4c8439d3ae4d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4654,6 +4654,184 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	return 0;
 }
 
+static ssize_t
+information_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct net_device *net = to_net_dev(dev);
+	struct rtl8169_private *tp = netdev_priv(net);
+	ssize_t ret;
+
+	if (rtnl_lock_killable())
+		return -EINTR;
+
+	ret = rtl_dash_info(tp->rtl_dash, buf);
+
+	rtnl_unlock();
+
+	return ret;
+}
+
+static DEVICE_ATTR_RO(information);
+
+static ssize_t
+ap_ready_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct net_device *net = to_net_dev(dev);
+	struct rtl8169_private *tp = netdev_priv(net);
+	bool enable;
+
+	if (rtnl_lock_killable())
+		return -EINTR;
+
+	enable = rtl_dash_get_ap_ready(tp->rtl_dash);
+
+	rtnl_unlock();
+
+	if (enable)
+		strcat(buf, "enable\n");
+	else
+		strcat(buf, "disable\n");
+
+	return (strlen(buf) + 1);
+}
+
+static ssize_t ap_ready_store(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct net_device *net = to_net_dev(dev);
+	struct rtl8169_private *tp = netdev_priv(net);
+	ssize_t len = strlen(buf);
+	bool enable;
+
+	if (buf[len - 1] <= ' ')
+		len--;
+
+	/* strlen("enable") = 6, and strlen("disable") = 7 */
+	if (len != 6 && len != 7)
+		return -EINVAL;
+
+	if (len == 6 && !strncmp(buf, "enable", 6))
+		enable = true;
+	else if (len == 7 && !strncmp(buf, "disable", 7))
+		enable = false;
+	else
+		return -EINVAL;
+
+	if (rtnl_lock_killable())
+		return -EINTR;
+
+	rtl_dash_set_ap_ready(tp->rtl_dash, enable);
+
+	rtnl_unlock();
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(ap_ready);
+
+static struct attribute *rtl_dash_attrs[] = {
+	&dev_attr_ap_ready.attr,
+	&dev_attr_information.attr,
+	NULL
+};
+
+static ssize_t cmac_data_write(struct file *fp, struct kobject *kobj,
+			       struct bin_attribute *attr, char *buf,
+			       loff_t offset, size_t size)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct net_device *net = to_net_dev(dev);
+	struct rtl8169_private *tp = netdev_priv(net);
+	int ret;
+
+	if (IS_ERR_OR_NULL(tp->rtl_dash))
+		return -ENODEV;
+
+	if (size > CMAC_BUF_SIZE)
+		return -EFBIG;
+
+	if (offset)
+		return -EINVAL;
+
+	if (rtnl_lock_killable())
+		return -EINTR;
+
+	ret = rtl_dash_to_fw(tp->rtl_dash, buf, size);
+
+	rtnl_unlock();
+
+	return ret;
+}
+
+static ssize_t cmac_data_read(struct file *fp, struct kobject *kobj,
+			      struct bin_attribute *attr, char *buf,
+			      loff_t offset, size_t size)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct net_device *net = to_net_dev(dev);
+	struct rtl8169_private *tp = netdev_priv(net);
+	int ret;
+
+	if (IS_ERR_OR_NULL(tp->rtl_dash))
+		return -ENODEV;
+
+	if (offset)
+		return -EINVAL;
+
+	if (rtnl_lock_killable())
+		return -EINTR;
+
+	ret = rtl_dash_from_fw(tp->rtl_dash, buf, size);
+
+	rtnl_unlock();
+
+	return ret;
+}
+
+static BIN_ATTR_RW(cmac_data, CMAC_BUF_SIZE);
+
+static struct bin_attribute *rtl_dash_bin_attrs[] = {
+	&bin_attr_cmac_data,
+	NULL
+};
+
+static umode_t is_dash_visible(struct kobject *kobj, struct attribute *attr,
+			       int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct net_device *net = to_net_dev(dev);
+	struct rtl8169_private *tp = netdev_priv(net);
+
+	if (IS_ERR_OR_NULL(tp->rtl_dash))
+		return 0;
+
+	if (attr == &dev_attr_information.attr)
+		return 0440;
+
+	return 0660;
+}
+
+static umode_t is_dash_bin_visible(struct kobject *kobj,
+				   struct bin_attribute *attr, int n)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct net_device *net = to_net_dev(dev);
+	struct rtl8169_private *tp = netdev_priv(net);
+
+	if (IS_ERR_OR_NULL(tp->rtl_dash))
+		return 0;
+
+	return 0660;
+}
+
+static struct attribute_group rtl_dash_grp = {
+	.name = "dash",
+	.is_visible	= is_dash_visible,
+	.attrs		= rtl_dash_attrs,
+	.is_bin_visible = is_dash_bin_visible,
+	.bin_attrs = rtl_dash_bin_attrs,
+};
+
 static void rtl8169_dash_release(struct rtl8169_private *tp)
 {
 	if (tp->dash_type > RTL_DASH_DP) {
@@ -4717,6 +4895,8 @@ static int rtl8169_close(struct net_device *dev)
 
 	phy_disconnect(tp->phydev);
 
+	sysfs_remove_group(&dev->dev.kobj, &rtl_dash_grp);
+
 	dma_free_coherent(&pdev->dev, R8169_RX_RING_BYTES, tp->RxDescArray,
 			  tp->RxPhyAddr);
 	dma_free_coherent(&pdev->dev, R8169_TX_RING_BYTES, tp->TxDescArray,
@@ -4775,6 +4955,10 @@ static int rtl_open(struct net_device *dev)
 		if (retval)
 			goto err_release_fw_2;
 
+		retval = sysfs_create_group(&dev->dev.kobj, &rtl_dash_grp);
+		if (retval < 0)
+			goto err_release_dash;
+
 		tp->irq_mask |= DashCMAC | DashIntr;
 	}
 
@@ -4782,7 +4966,7 @@ static int rtl_open(struct net_device *dev)
 	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
 			     irqflags, dev->name, tp);
 	if (retval < 0)
-		goto err_release_dash;
+		goto err_remove_group;
 
 	retval = r8169_phy_connect(tp);
 	if (retval)
@@ -4798,6 +4982,8 @@ static int rtl_open(struct net_device *dev)
 
 err_free_irq:
 	free_irq(pci_irq_vector(pdev, 0), tp);
+err_remove_group:
+	sysfs_remove_group(&dev->dev.kobj, &rtl_dash_grp);
 err_release_dash:
 	rtl8169_dash_release(tp);
 err_release_fw_2:
-- 
2.31.1

