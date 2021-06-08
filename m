Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9010239ED4B
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFHEFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbhFHEFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 00:05:06 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458A1C06178B;
        Mon,  7 Jun 2021 21:03:00 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id bn21so25136922ljb.1;
        Mon, 07 Jun 2021 21:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YmBtymAM7wgwIofW8yEeRoReg1tpJoUaeSkobDLn7ao=;
        b=XOGTFK/tMSLZL6v16lZUIQSDZWe5b9M4sWftQVzagrB3DYWPYW/hQE5bDkd3KlyhBd
         fSL10yZS2iw41aZ1Lot3KFmSN0bYCHIc+wh5+n5J6bBV+QgG2nAQrKkWrQtyM5omau+o
         7XRPAarOMgGEVbfJFhMxtVWbCIYgKamkYnRnDxlBbuONeSGNhpulqmHqIXsJzwI2ezZg
         HFD3cMnQYAg6bGDykUhPZuv+xqtxA9wGhJvtkVouccc62xm4K9SJcF5bUzxS/PaZ/6J8
         t6LlPjtrn/Wf9E+8sWC4zb5qe69+vurBx6KNHLarAsQ4VGW/ZVe+sTrIE3DPlRZnE7Et
         V/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YmBtymAM7wgwIofW8yEeRoReg1tpJoUaeSkobDLn7ao=;
        b=eEZEbBP+V9TKAc3lGeDwKbxwW3e/Rh77gAfaXV74KK4ZquWr7FuC+VFF+oZaXduVJ0
         JNU9WvqmuNySW71zpbtkje0GXoXF8i5xwxdWzwbOzLTarSf1E+AD1AtPwpaR+72HPqqi
         wOFZwAdlrwh7A2URwVKgvnj9pi/8EoXq209lsjx2iFFMtdWBdFmD+PC7ncJrxxNGjLQL
         eoBl+deUaFdGouNEttBQIGIEggG4BDAO3bpasMbIBlkARZ1camRAgvM7FyXY5jIXJec3
         tRb0Lun/E5j2mrz1OGGObPN3z9axu39pyhWk1KXYkB98jxszh3tHCHTxDFZ2nOAqcRnY
         FIVw==
X-Gm-Message-State: AOAM5310UTLWWqcS2vFJk0K2U40sX8mhtNe1jBpINSLPRy6uYmoF5GIo
        j59P+kIm6Y3jWVroZ8JEB+Q=
X-Google-Smtp-Source: ABdhPJyBbKuxc9FAMrZ38/YD56E1BgF3YXX7mMQSK9xI+gisLAIjScf9eKU7LQrLeIcLW1CANS4gEQ==
X-Received: by 2002:a2e:84cc:: with SMTP id q12mr6541116ljh.274.1623124976959;
        Mon, 07 Jun 2021 21:02:56 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id l23sm1729096lfj.26.2021.06.07.21.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 21:02:56 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/10] net: wwan: core: implement TIOCINQ ioctl
Date:   Tue,  8 Jun 2021 07:02:39 +0300
Message-Id: <20210608040241.10658-9-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
References: <20210608040241.10658-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is quite common for a userpace program to fetch the buffered amount
of data in the rx queue to avoid the read block. Implement the TIOCINQ
ioctl to make the migration to the WWAN port usage smooth.

Despite the fact that the read call will return no more data than the
size of a first skb in the queue, TIOCINQ returns the entire amount of
buffered data (sum of all queued skbs). This is done to prevent the
breaking of programs that optimize reading, avoiding it if the buffered
amount of data is too small.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/wwan_core.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 9346b2661eb3..d5a197da4a41 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -12,6 +12,7 @@
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/termios.h>
 #include <linux/wwan.h>
 
 /* Maximum number of minors in use */
@@ -618,6 +619,30 @@ static __poll_t wwan_port_fops_poll(struct file *filp, poll_table *wait)
 	return mask;
 }
 
+static long wwan_port_fops_ioctl(struct file *filp, unsigned int cmd,
+				 unsigned long arg)
+{
+	struct wwan_port *port = filp->private_data;
+
+	switch (cmd) {
+	case TIOCINQ: {	/* aka SIOCINQ aka FIONREAD */
+		unsigned long flags;
+		struct sk_buff *skb;
+		int amount = 0;
+
+		spin_lock_irqsave(&port->rxq.lock, flags);
+		skb_queue_walk(&port->rxq, skb)
+			amount += skb->len;
+		spin_unlock_irqrestore(&port->rxq.lock, flags);
+
+		return put_user(amount, (int __user *)arg);
+	}
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
 static const struct file_operations wwan_port_fops = {
 	.owner = THIS_MODULE,
 	.open = wwan_port_fops_open,
@@ -625,6 +650,10 @@ static const struct file_operations wwan_port_fops = {
 	.read = wwan_port_fops_read,
 	.write = wwan_port_fops_write,
 	.poll = wwan_port_fops_poll,
+	.unlocked_ioctl = wwan_port_fops_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = compat_ptr_ioctl,
+#endif
 	.llseek = noop_llseek,
 };
 
-- 
2.26.3

