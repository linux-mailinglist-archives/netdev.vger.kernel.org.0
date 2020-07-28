Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7AB12309A8
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729357AbgG1MLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:11:41 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46216 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgG1MLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:11:35 -0400
Received: by mail-lf1-f65.google.com with SMTP id i80so10854317lfi.13;
        Tue, 28 Jul 2020 05:11:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XfaoFQeDT9YRusOqXGtxXFyLqPpgWHyL5Hg1Y49medM=;
        b=H1nSy84+USqSXRADm5cUlRl2UCU8/xrtFHg0olIU2BeCBX75smcc5UH6XztR54QFdd
         yaoT+SQG3yQUhIp+DujU4jrQqSvIQ4NsWxG2M7lPWCuCEi7dAjGgZDxDfDvTDkmNyc4i
         XNNqPyalKSfrOrgBrkEJAP8Kw/9qYWrrciolWEGkpLSnU4He/FhdvakvuZ2a67ADxzAu
         vCLSnec0y8LADWUSOMwSgqsyEfEENKMNj/pxm4l5wFlRoPsGp7tkHAJXaLWBEG62+u60
         jfk6n/zgTrZYaTeAu7EY8tP00Y5m+OowVX5jJbfm+2j2sLKfi6PJR64Hfa5qWvU3XdIV
         S9QA==
X-Gm-Message-State: AOAM533xHgdqsnnNxhHkjXGA3QoM3vE1MJk/Y4MaxBhg+OTyyL1iVA5g
        sobskvKNeBwrIHQA8Hjli7U=
X-Google-Smtp-Source: ABdhPJzuHSUFPp+H0bFaE2pdfSypeZV94zayFlixueTWeM/Qj7KGWqg9C1SAl0XLNXCRPrNMfX0u4Q==
X-Received: by 2002:a19:e50:: with SMTP id 77mr9715495lfo.188.1595938292907;
        Tue, 28 Jul 2020 05:11:32 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id 11sm2931980lju.102.2020.07.28.05.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 05:11:31 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1k0OS6-0003Dx-ES; Tue, 28 Jul 2020 14:11:26 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Woojung Huh <woojung.huh@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH net 3/3] net: lan78xx: replace bogus endpoint lookup
Date:   Tue, 28 Jul 2020 14:10:31 +0200
Message-Id: <20200728121031.12323-4-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728121031.12323-1-johan@kernel.org>
References: <20200728121031.12323-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the bogus endpoint-lookup helper which could end up accepting
interfaces based on endpoints belonging to unrelated altsettings.

Note that the returned bulk pipes and interrupt endpoint descriptor
were never actually used. Instead the bulk-endpoint numbers are
hardcoded to 1 and 2 (matching the specification), while the interrupt-
endpoint descriptor was assumed to be the third descriptor created by
USB core.

Try to bring some order to this by dropping the bogus lookup helper and
adding the missing endpoint sanity checks while keeping the interrupt-
descriptor assumption for now.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/usb/lan78xx.c | 117 ++++++++++----------------------------
 1 file changed, 30 insertions(+), 87 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index ee062b27cfa7..442507f25aad 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -377,10 +377,6 @@ struct lan78xx_net {
 	struct tasklet_struct	bh;
 	struct delayed_work	wq;
 
-	struct usb_host_endpoint *ep_blkin;
-	struct usb_host_endpoint *ep_blkout;
-	struct usb_host_endpoint *ep_intr;
-
 	int			msg_enable;
 
 	struct urb		*urb_intr;
@@ -2860,78 +2856,12 @@ lan78xx_start_xmit(struct sk_buff *skb, struct net_device *net)
 	return NETDEV_TX_OK;
 }
 
-static int
-lan78xx_get_endpoints(struct lan78xx_net *dev, struct usb_interface *intf)
-{
-	int tmp;
-	struct usb_host_interface *alt = NULL;
-	struct usb_host_endpoint *in = NULL, *out = NULL;
-	struct usb_host_endpoint *status = NULL;
-
-	for (tmp = 0; tmp < intf->num_altsetting; tmp++) {
-		unsigned ep;
-
-		in = NULL;
-		out = NULL;
-		status = NULL;
-		alt = intf->altsetting + tmp;
-
-		for (ep = 0; ep < alt->desc.bNumEndpoints; ep++) {
-			struct usb_host_endpoint *e;
-			int intr = 0;
-
-			e = alt->endpoint + ep;
-			switch (e->desc.bmAttributes) {
-			case USB_ENDPOINT_XFER_INT:
-				if (!usb_endpoint_dir_in(&e->desc))
-					continue;
-				intr = 1;
-				/* FALLTHROUGH */
-			case USB_ENDPOINT_XFER_BULK:
-				break;
-			default:
-				continue;
-			}
-			if (usb_endpoint_dir_in(&e->desc)) {
-				if (!intr && !in)
-					in = e;
-				else if (intr && !status)
-					status = e;
-			} else {
-				if (!out)
-					out = e;
-			}
-		}
-		if (in && out)
-			break;
-	}
-	if (!alt || !in || !out)
-		return -EINVAL;
-
-	dev->pipe_in = usb_rcvbulkpipe(dev->udev,
-				       in->desc.bEndpointAddress &
-				       USB_ENDPOINT_NUMBER_MASK);
-	dev->pipe_out = usb_sndbulkpipe(dev->udev,
-					out->desc.bEndpointAddress &
-					USB_ENDPOINT_NUMBER_MASK);
-	dev->ep_intr = status;
-
-	return 0;
-}
-
 static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 {
 	struct lan78xx_priv *pdata = NULL;
 	int ret;
 	int i;
 
-	ret = lan78xx_get_endpoints(dev, intf);
-	if (ret) {
-		netdev_warn(dev->net, "lan78xx_get_endpoints failed: %d\n",
-			    ret);
-		return ret;
-	}
-
 	dev->data[0] = (unsigned long)kzalloc(sizeof(*pdata), GFP_KERNEL);
 
 	pdata = (struct lan78xx_priv *)(dev->data[0]);
@@ -3700,6 +3630,7 @@ static void lan78xx_stat_monitor(struct timer_list *t)
 static int lan78xx_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
+	struct usb_host_endpoint *ep_blkin, *ep_blkout, *ep_intr;
 	struct lan78xx_net *dev;
 	struct net_device *netdev;
 	struct usb_device *udev;
@@ -3748,6 +3679,34 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	mutex_init(&dev->stats.access_lock);
 
+	if (intf->cur_altsetting->desc.bNumEndpoints < 3) {
+		ret = -ENODEV;
+		goto out2;
+	}
+
+	dev->pipe_in = usb_rcvbulkpipe(udev, BULK_IN_PIPE);
+	ep_blkin = usb_pipe_endpoint(udev, dev->pipe_in);
+	if (!ep_blkin || !usb_endpoint_is_bulk_in(&ep_blkin->desc)) {
+		ret = -ENODEV;
+		goto out2;
+	}
+
+	dev->pipe_out = usb_sndbulkpipe(udev, BULK_OUT_PIPE);
+	ep_blkout = usb_pipe_endpoint(udev, dev->pipe_out);
+	if (!ep_blkout || !usb_endpoint_is_bulk_out(&ep_blkout->desc)) {
+		ret = -ENODEV;
+		goto out2;
+	}
+
+	ep_intr = &intf->cur_altsetting->endpoint[2];
+	if (!usb_endpoint_is_int_in(&ep_intr->desc)) {
+		ret = -ENODEV;
+		goto out2;
+	}
+
+	dev->pipe_intr = usb_rcvintpipe(dev->udev,
+					usb_endpoint_num(&ep_intr->desc));
+
 	ret = lan78xx_bind(dev, intf);
 	if (ret < 0)
 		goto out2;
@@ -3759,23 +3718,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	netdev->max_mtu = MAX_SINGLE_PACKET_SIZE;
 	netif_set_gso_max_size(netdev, MAX_SINGLE_PACKET_SIZE - MAX_HEADER);
 
-	if (intf->cur_altsetting->desc.bNumEndpoints < 3) {
-		ret = -ENODEV;
-		goto out3;
-	}
-
-	dev->ep_blkin = (intf->cur_altsetting)->endpoint + 0;
-	dev->ep_blkout = (intf->cur_altsetting)->endpoint + 1;
-	dev->ep_intr = (intf->cur_altsetting)->endpoint + 2;
-
-	dev->pipe_in = usb_rcvbulkpipe(udev, BULK_IN_PIPE);
-	dev->pipe_out = usb_sndbulkpipe(udev, BULK_OUT_PIPE);
-
-	dev->pipe_intr = usb_rcvintpipe(dev->udev,
-					dev->ep_intr->desc.bEndpointAddress &
-					USB_ENDPOINT_NUMBER_MASK);
-	period = dev->ep_intr->desc.bInterval;
-
+	period = ep_intr->desc.bInterval;
 	maxp = usb_maxpacket(dev->udev, dev->pipe_intr, 0);
 	buf = kmalloc(maxp, GFP_KERNEL);
 	if (buf) {
-- 
2.26.2

