Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1885C39ED5B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhFHEGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:06:01 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:42556 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbhFHEF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:05:59 -0400
Received: by mail-lf1-f44.google.com with SMTP id j2so2243755lfg.9;
        Mon, 07 Jun 2021 21:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eweejLmoSrLMGgxviVt5Oq8o8u/eXalaOHg4faHNMwQ=;
        b=DEicVTJlL9BJlXrfsbLc8FfsrzgKQgxkUoQ5o1rbmVI3H5agGQujSv0jcl7ut64fJd
         cv367FiRFk0s39P05eIUsVZTue7u0k9cmoLtsmVqp3zUq0Gi7+PaH9OSNOM1jy3WEVah
         OgVySP537dX9jqq7DzBQWM6J/uaiKaHk0Qb9KBIWkxReQsLLVBhIOUOdQS/38BWPgXAS
         D9by5jIy6im5w6CeaxjnQQ4EDteImBKa5Ec+l6nFQRP4FAlE4R+P76kcsFFdww7eSaEy
         rG6GaS2Zt8Mctcp9AQox91F+Gx5Sf/DxgkJKy+TLBW8Ywu9pIbitj+PcuGodxR71CrZ/
         pfiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eweejLmoSrLMGgxviVt5Oq8o8u/eXalaOHg4faHNMwQ=;
        b=TSvw63mmogpV6Z2vUXQYLuG7gY71dlYwds3lZH46TsTRkzAokSyMSG/Qs6ib+0+Jv5
         wn1JPoR/RMhWqCECCQmDznjPWzUxb2WWT6JhCymBj7iHgbNfggDHNiEtCz6Ibhhsqm9J
         QezDUiiHtSr++sdNtt+epGVzBNj3DQkIKECFNhz/gPr3EmSdzpqDUlErAXybfQHk5J3t
         99wRhBLIomDYN8fuGfWIBCen1CclrKiZs0aq0um/LWEoRBhkvdy+3UdE/JxXMLBR3XgE
         PdfwPYFJHNPLJN+QWQ9mmBWKFHbpLIbGH38WXwQZjh7apAH21KzuIRxPLcE2ZGSHjEmu
         ImbQ==
X-Gm-Message-State: AOAM530bpuZWJMbLC9vK8/5pmKuMGU5Pfe0RDRdrVEN8S03vssZxJiBu
        HvR98umXrSIHhwmXBbZ0MSY=
X-Google-Smtp-Source: ABdhPJwByhS19BKXJuwk46HkmvNENjteCYJTB4mxLWJk69lD07yMBvJbeiWohHjAmJI1DI/YGkEWow==
X-Received: by 2002:a19:ec14:: with SMTP id b20mr14595414lfa.244.1623124977790;
        Mon, 07 Jun 2021 21:02:57 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id l23sm1729096lfj.26.2021.06.07.21.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 21:02:57 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 09/10] net: wwan: core: implement terminal ioctls for AT port
Date:   Tue,  8 Jun 2021 07:02:40 +0300
Message-Id: <20210608040241.10658-10-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not unreasonable to assume that users will use terminal emulation
software to communicate directly with a WWAN device over the AT port.
But terminal emulators  will refuse to work with a device that does not
support terminal IOCTLs (e.g. TCGETS, TCSETS, TIOCMSET, etc.). To make
it possible to interact with the WWAN AT port using a terminal emulator,
implement a minimal set of terminal IOCTLs.

The implementation is rather stub, no passed data are actually used to
control a port behaviour. An obtained configuration is kept inside the
port structure and returned back by a request. The latter is done to
fool a program that will test the configuration status by comparing the
readed back data from the device with earlier configured ones.

Tested with fresh versions of minicom and picocom terminal apps.

MBIM, QMI and other ports for binary protocols can hardly be considered
a terminal device, so terminal IOCTLs are only implemented for the AT
port.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/wwan_core.c | 91 ++++++++++++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index d5a197da4a41..38da3124d81e 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -51,6 +51,8 @@ struct wwan_device {
  * @dev: Underlying device
  * @rxq: Buffer inbound queue
  * @waitqueue: The waitqueue for port fops (read/write/poll)
+ * @data_lock: Port specific data access serialization
+ * @at_data: AT port specific data
  */
 struct wwan_port {
 	enum wwan_port_type type;
@@ -61,6 +63,13 @@ struct wwan_port {
 	struct device dev;
 	struct sk_buff_head rxq;
 	wait_queue_head_t waitqueue;
+	struct mutex data_lock;	/* Port specific data access serialization */
+	union {
+		struct {
+			struct ktermios termios;
+			int mdmbits;
+		} at_data;
+	};
 };
 
 static ssize_t index_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -230,6 +239,7 @@ static void wwan_port_destroy(struct device *dev)
 	struct wwan_port *port = to_wwan_port(dev);
 
 	ida_free(&minors, MINOR(port->dev.devt));
+	mutex_destroy(&port->data_lock);
 	skb_queue_purge(&port->rxq);
 	mutex_destroy(&port->ops_lock);
 	kfree(port);
@@ -344,6 +354,7 @@ struct wwan_port *wwan_create_port(struct device *parent,
 	mutex_init(&port->ops_lock);
 	skb_queue_head_init(&port->rxq);
 	init_waitqueue_head(&port->waitqueue);
+	mutex_init(&port->data_lock);
 
 	port->dev.parent = &wwandev->dev;
 	port->dev.class = wwan_class;
@@ -619,10 +630,90 @@ static __poll_t wwan_port_fops_poll(struct file *filp, poll_table *wait)
 	return mask;
 }
 
+/* Implements minimalistic stub terminal IOCTLs support */
+static long wwan_port_fops_at_ioctl(struct wwan_port *port, unsigned int cmd,
+				    unsigned long arg)
+{
+	int ret = 0;
+
+	mutex_lock(&port->data_lock);
+
+	switch (cmd) {
+	case TCFLSH:
+		break;
+
+	case TCGETS:
+		if (copy_to_user((void __user *)arg, &port->at_data.termios,
+				 sizeof(struct termios)))
+			ret = -EFAULT;
+		break;
+
+	case TCSETS:
+	case TCSETSW:
+	case TCSETSF:
+		if (copy_from_user(&port->at_data.termios, (void __user *)arg,
+				   sizeof(struct termios)))
+			ret = -EFAULT;
+		break;
+
+#ifdef TCGETS2
+	case TCGETS2:
+		if (copy_to_user((void __user *)arg, &port->at_data.termios,
+				 sizeof(struct termios2)))
+			ret = -EFAULT;
+		break;
+
+	case TCSETS2:
+	case TCSETSW2:
+	case TCSETSF2:
+		if (copy_from_user(&port->at_data.termios, (void __user *)arg,
+				   sizeof(struct termios2)))
+			ret = -EFAULT;
+		break;
+#endif
+
+	case TIOCMGET:
+		ret = put_user(port->at_data.mdmbits, (int __user *)arg);
+		break;
+
+	case TIOCMSET:
+	case TIOCMBIC:
+	case TIOCMBIS: {
+		int mdmbits;
+
+		if (copy_from_user(&mdmbits, (int __user *)arg, sizeof(int))) {
+			ret = -EFAULT;
+			break;
+		}
+		if (cmd == TIOCMBIC)
+			port->at_data.mdmbits &= ~mdmbits;
+		else if (cmd == TIOCMBIS)
+			port->at_data.mdmbits |= mdmbits;
+		else
+			port->at_data.mdmbits = mdmbits;
+		break;
+	}
+
+	default:
+		ret = -ENOIOCTLCMD;
+	}
+
+	mutex_unlock(&port->data_lock);
+
+	return ret;
+}
+
 static long wwan_port_fops_ioctl(struct file *filp, unsigned int cmd,
 				 unsigned long arg)
 {
 	struct wwan_port *port = filp->private_data;
+	int res;
+
+	if (port->type == WWAN_PORT_AT) {	/* AT port specific IOCTLs */
+		res = wwan_port_fops_at_ioctl(port, cmd, arg);
+		if (res != -ENOIOCTLCMD)
+			return res;
+	}
 
 	switch (cmd) {
 	case TIOCINQ: {	/* aka SIOCINQ aka FIONREAD */
-- 
2.26.3

