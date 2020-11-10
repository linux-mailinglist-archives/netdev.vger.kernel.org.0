Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF092AE024
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 20:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731760AbgKJTvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 14:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731706AbgKJTv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 14:51:27 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B292C0613D1;
        Tue, 10 Nov 2020 11:51:27 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id s25so19360655ejy.6;
        Tue, 10 Nov 2020 11:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=zHwz+GVnqFj0IOBBK7m9sISogVlrXHBHVpez2vtGxNA=;
        b=FJBcjArrc68gCYiLrDGvZd6QudecMs1EO6nC5MljgPZbFfe8ROp/r6j3bvRtqCpvq2
         pFRmx5QINgTBD8ZQ5/Q/kXtGlpWwhd3ZGEaQJzAHwZn0UTkSqMGNjJ22JLOmeGiUrN0I
         vg3irUcDoRKsa5HMa5rLlPHUINvuozNxCVSuj8id0I5aU3T9xOhXN1u8L/2XAJJqzwnM
         l2yR8xWZYze8QGk51mQjeUgsD9sYUZdgygq7gYJLieRSrIqCm5rQH9of/B9h/nR/yhGg
         gVd4SPgWxifkcfBzEO2f7I3NKvl0nGcgPebK1S59AUD4zATlvibz02AHAdbQMvSYq6ed
         A0qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=zHwz+GVnqFj0IOBBK7m9sISogVlrXHBHVpez2vtGxNA=;
        b=DeyUglLblmwhLLRu/sTJ7F0uyBss9Yj/lgdtLl2lQUtf2K07U77Rtn0YP5XBvAB5vT
         DNxL4HjeINZ4qvny+pbwKPwAM6BM3OGv9cJNBwVLwz6n8i+MEFH2DHyweBpbHDnQ/Xvb
         lSGXCoWFsWKuZur/glQdIZD9d/nueOg9OwUhd5/FRfhkozaKcu0hR4MrJZ1aLaC26U73
         cvP0pds9p1vKmkj75ho28xfM/XZ2jY6n9HsRyLJFSzOWkbyAvUeK90ZaH3XbEiMeGc9G
         fBvDO+LJFQHCJH8VN4wrIJ9b8ThWSgyzZE6wbiDKZgtz7FYoMwRN46essnf80jmURjHO
         mNRw==
X-Gm-Message-State: AOAM530xEcvgrp5qqKessa8SVsk6yNEfEE1QqSoeOaa7ek3BZc45v/Ym
        +qzZrnrj39VENvL/X0/ill5ux7x94Kyq4Q==
X-Google-Smtp-Source: ABdhPJwv7D0aq69+i+DJRpOmUJFGVxjQUqfSRPPhxT0WwRJkW+VRtKG7hep6IvUCrb+x0GgV876iiA==
X-Received: by 2002:a17:906:2cc5:: with SMTP id r5mr21890684ejr.328.1605037885529;
        Tue, 10 Nov 2020 11:51:25 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:895e:e59d:3602:de4b? (p200300ea8f232800895ee59d3602de4b.dip0.t-ipconnect.de. [2003:ea:8f23:2800:895e:e59d:3602:de4b])
        by smtp.googlemail.com with ESMTPSA id r20sm10535899edq.6.2020.11.10.11.51.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 11:51:25 -0800 (PST)
Subject: [PATCH net-next 4/5] usbnet: switch to core handling of rx/tx
 byte/packet counters
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Oliver Neukum <oneukum@suse.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
Message-ID: <8fb63ae9-1179-49e4-f9bb-e0e536f72158@gmail.com>
Date:   Tue, 10 Nov 2020 20:50:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netdev->tstats instead of a member of usbnet for storing a pointer
to the per-cpu counters. This allows us to use core functionality for
statistics handling.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/usb/usbnet.c   | 23 +++++++----------------
 include/linux/usb/usbnet.h |  6 ++----
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 6062dc278..1447da1d5 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -304,7 +304,7 @@ static void __usbnet_status_stop_force(struct usbnet *dev)
  */
 void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
 {
-	struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->stats64);
+	struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->net->tstats);
 	unsigned long flags;
 	int	status;
 
@@ -980,15 +980,6 @@ int usbnet_set_link_ksettings(struct net_device *net,
 }
 EXPORT_SYMBOL_GPL(usbnet_set_link_ksettings);
 
-void usbnet_get_stats64(struct net_device *net, struct rtnl_link_stats64 *stats)
-{
-	struct usbnet *dev = netdev_priv(net);
-
-	netdev_stats_to_stats64(stats, &net->stats);
-	dev_fetch_sw_netstats(stats, dev->stats64);
-}
-EXPORT_SYMBOL_GPL(usbnet_get_stats64);
-
 u32 usbnet_get_link (struct net_device *net)
 {
 	struct usbnet *dev = netdev_priv(net);
@@ -1220,7 +1211,7 @@ static void tx_complete (struct urb *urb)
 	struct usbnet		*dev = entry->dev;
 
 	if (urb->status == 0) {
-		struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->stats64);
+		struct pcpu_sw_netstats *stats64 = this_cpu_ptr(dev->net->tstats);
 		unsigned long flags;
 
 		flags = u64_stats_update_begin_irqsave(&stats64->syncp);
@@ -1596,7 +1587,7 @@ void usbnet_disconnect (struct usb_interface *intf)
 	usb_free_urb(dev->interrupt);
 	kfree(dev->padding_pkt);
 
-	free_percpu(dev->stats64);
+	free_percpu(net->tstats);
 	free_netdev(net);
 }
 EXPORT_SYMBOL_GPL(usbnet_disconnect);
@@ -1608,7 +1599,7 @@ static const struct net_device_ops usbnet_netdev_ops = {
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_set_rx_mode	= usbnet_set_rx_mode,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_get_stats64	= usbnet_get_stats64,
+	.ndo_get_stats64	= dev_get_tstats64,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
@@ -1671,8 +1662,8 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	dev->driver_info = info;
 	dev->driver_name = name;
 
-	dev->stats64 = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
-	if (!dev->stats64)
+	net->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
+	if (!net->tstats)
 		goto out0;
 
 	dev->msg_enable = netif_msg_init (msg_level, NETIF_MSG_DRV
@@ -1812,7 +1803,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	 */
 	cancel_work_sync(&dev->kevent);
 	del_timer_sync(&dev->delay);
-	free_percpu(dev->stats64);
+	free_percpu(net->tstats);
 out0:
 	free_netdev(net);
 out:
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 2e4f7721f..1f6dfa977 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -65,8 +65,6 @@ struct usbnet {
 	struct usb_anchor	deferred;
 	struct tasklet_struct	bh;
 
-	struct pcpu_sw_netstats __percpu *stats64;
-
 	struct work_struct	kevent;
 	unsigned long		flags;
 #		define EVENT_TX_HALT	0
@@ -285,7 +283,7 @@ extern int usbnet_status_start(struct usbnet *dev, gfp_t mem_flags);
 extern void usbnet_status_stop(struct usbnet *dev);
 
 extern void usbnet_update_max_qlen(struct usbnet *dev);
-extern void usbnet_get_stats64(struct net_device *dev,
-			       struct rtnl_link_stats64 *stats);
+
+#define usbnet_get_stats64 dev_get_tstats64
 
 #endif /* __LINUX_USB_USBNET_H */
-- 
2.29.2


