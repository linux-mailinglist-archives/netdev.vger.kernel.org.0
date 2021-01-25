Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CBE30227B
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 08:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbhAYHh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 02:37:56 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:10418 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727185AbhAYHfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 02:35:20 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611560099; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=/lsVz8gMDVaJB0fhRDVbi9JRpm8ZUi3sr1krkiDGETY=; b=B9TS8S2ARrilvHOcAutuDnuDhrwLDMiYRr1vzAHnUIao0Zw1kfsRsn8o5hhmbFMwk2Awjspa
 29pmmlvB0mDDsyc82ecnV14xSfYgFLQ93I6arDHORrC475ZMVFdaC5LR9J7DaWN6eSbAVfmI
 I3DDJZmUXo3n2IfsUkmCIunE3zk=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 600e7488fb02735e8cbae920 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 25 Jan 2021 07:34:32
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 32452C433ED; Mon, 25 Jan 2021 07:34:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from subashab-lnx.qualcomm.com (unknown [129.46.15.92])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DB154C433C6;
        Mon, 25 Jan 2021 07:34:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DB154C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=subashab@codeaurora.org
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        stranche@codeaurora.org, aleksander@aleksander.es,
        dnlplm@gmail.com, bjorn@mork.no, stephan@gerhold.net,
        ejcaruso@google.com, andrewlassalle@google.com
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH net-next v2] net: qmi_wwan: Add pass through mode
Date:   Mon, 25 Jan 2021 00:33:35 -0700
Message-Id: <1611560015-20034-1-git-send-email-subashab@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass through mode is to allow packets in MAP format to be passed
on to the stack. rmnet driver can be used to process and demultiplex
these packets.

Pass through mode can be enabled when the device is in raw ip mode only.
Conversely, raw ip mode cannot be disabled when pass through mode is
enabled.

Userspace can use pass through mode in conjunction with rmnet driver
through the following steps-

1. Enable raw ip mode on qmi_wwan device
2. Enable pass through mode on qmi_wwan device
3. Create a rmnet device with qmi_wwan device as real device using netlink

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
v1->v2: Update commit text and fix the following comments from Bjorn-
Remove locking as no netdev state change is requried since all the
configuration is already done in raw_ip_store.
Check the inverse relationship between raw_ip mode and pass_through mode.
pass_through_mode just sets/resets the flag now.
raw_ip check is not needed when queueing pass_through mode packets as
that is enforced already during the mode configuration.

 drivers/net/usb/qmi_wwan.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 7ea113f5..e58a80a 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -57,6 +57,7 @@ struct qmi_wwan_state {
 enum qmi_wwan_flags {
 	QMI_WWAN_FLAG_RAWIP = 1 << 0,
 	QMI_WWAN_FLAG_MUX = 1 << 1,
+	QMI_WWAN_FLAG_PASS_THROUGH = 1 << 2,
 };
 
 enum qmi_wwan_quirks {
@@ -326,6 +327,13 @@ static ssize_t raw_ip_store(struct device *d,  struct device_attribute *attr, co
 	if (enable == (info->flags & QMI_WWAN_FLAG_RAWIP))
 		return len;
 
+	/* ip mode cannot be cleared when pass through mode is set */
+	if (!enable && (info->flags & QMI_WWAN_FLAG_PASS_THROUGH)) {
+		netdev_err(dev->net,
+			   "Cannot clear ip mode on pass through device\n");
+		return -EINVAL;
+	}
+
 	if (!rtnl_trylock())
 		return restart_syscall();
 
@@ -456,14 +464,59 @@ static ssize_t del_mux_store(struct device *d,  struct device_attribute *attr, c
 	return ret;
 }
 
+static ssize_t pass_through_show(struct device *d,
+				 struct device_attribute *attr, char *buf)
+{
+	struct usbnet *dev = netdev_priv(to_net_dev(d));
+	struct qmi_wwan_state *info;
+
+	info = (void *)&dev->data;
+	return sprintf(buf, "%c\n",
+		       info->flags & QMI_WWAN_FLAG_PASS_THROUGH ? 'Y' : 'N');
+}
+
+static ssize_t pass_through_store(struct device *d,
+				  struct device_attribute *attr,
+				  const char *buf, size_t len)
+{
+	struct usbnet *dev = netdev_priv(to_net_dev(d));
+	struct qmi_wwan_state *info;
+	bool enable;
+
+	if (strtobool(buf, &enable))
+		return -EINVAL;
+
+	info = (void *)&dev->data;
+
+	/* no change? */
+	if (enable == (info->flags & QMI_WWAN_FLAG_PASS_THROUGH))
+		return len;
+
+	/* pass through mode can be set for raw ip devices only */
+	if (!(info->flags & QMI_WWAN_FLAG_RAWIP)) {
+		netdev_err(dev->net,
+			   "Cannot set pass through mode on non ip device\n");
+		return -EINVAL;
+	}
+
+	if (enable)
+		info->flags |= QMI_WWAN_FLAG_PASS_THROUGH;
+	else
+		info->flags &= ~QMI_WWAN_FLAG_PASS_THROUGH;
+
+	return len;
+}
+
 static DEVICE_ATTR_RW(raw_ip);
 static DEVICE_ATTR_RW(add_mux);
 static DEVICE_ATTR_RW(del_mux);
+static DEVICE_ATTR_RW(pass_through);
 
 static struct attribute *qmi_wwan_sysfs_attrs[] = {
 	&dev_attr_raw_ip.attr,
 	&dev_attr_add_mux.attr,
 	&dev_attr_del_mux.attr,
+	&dev_attr_pass_through.attr,
 	NULL,
 };
 
@@ -510,6 +563,11 @@ static int qmi_wwan_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	if (info->flags & QMI_WWAN_FLAG_MUX)
 		return qmimux_rx_fixup(dev, skb);
 
+	if (info->flags & QMI_WWAN_FLAG_PASS_THROUGH) {
+		skb->protocol = htons(ETH_P_MAP);
+		return (netif_rx(skb) == NET_RX_SUCCESS);
+	}
+
 	switch (skb->data[0] & 0xf0) {
 	case 0x40:
 		proto = htons(ETH_P_IP);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

