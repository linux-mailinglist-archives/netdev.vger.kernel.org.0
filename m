Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A48F19C44B
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732679AbgDBOdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:33:36 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42458 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbgDBOdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:33:36 -0400
Received: by mail-ed1-f65.google.com with SMTP id cw6so4382055edb.9
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 07:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=0DlET+wvVzmNyjftA2TzbO/GAMI9QlzrPZCjzdYL0+4=;
        b=Dp8lPDgzlo47dIGRVGObnm4faKij1f/fHt6Lq2yJ7LqSCoWzB+vzFaPHZuFsX2Yape
         Tgmo6ts5RPY6K+BlD0FL2s1x4nNqEy9jWXkG49zr78SiakRmNtEpORf1d43OAbfHJHda
         mQihNedfDM3tY89XdmYbo59XJokdvk/+nh09k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=0DlET+wvVzmNyjftA2TzbO/GAMI9QlzrPZCjzdYL0+4=;
        b=DqMsDW60ja0uz16l0h58n9tE7lQJLNW7+dPILdXYJ8o74wi2nLWORQm5QvPW1G4KTt
         07xmE2SvcImmaxLs2K1BHGPbboKawfHjwH1aBeN8XpGsi5nBDle+NWMApv4TrO21Izo3
         b367rint0ddaZJma37uXou80NDWCQQP75awlByuerLOCaa8kEgf/lqjJ2OrZj3Kn64IC
         86bGHjZmtay4pFQNp78/JYx/e64px7eUMtZ6LH38cQHCPr3Q0Ih7VfNU6oTNTYb0yafQ
         O3MU/UBgddUxlazagoDVYsZOfTuO6Q27XK46hXKkCMwJjY88XbCOMzMzm/73R74LxE6m
         Jthw==
X-Gm-Message-State: AGi0PuZvofDvNNZKRD3yj6xqKf9DtS0CVkNjZwUmjt3pTprBlnJ0zW0p
        0Pc67HpoCPLD5cT5GJSqDIc1seUImxA=
X-Google-Smtp-Source: APiQypKUVtzMJf9UJ1/gUEQ4yVNAMmJAkS1443JVimDsVGCq86chH9mRH7D91Am0m9Kf2qBWq1FaUg==
X-Received: by 2002:a50:a285:: with SMTP id 5mr3119112edm.360.1585838012270;
        Thu, 02 Apr 2020 07:33:32 -0700 (PDT)
Received: from carbon ([94.26.108.4])
        by smtp.gmail.com with ESMTPSA id cm7sm968703edb.17.2020.04.02.07.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 07:33:31 -0700 (PDT)
Date:   Thu, 2 Apr 2020 17:33:29 +0300
From:   Petko Manolov <petko.manolov@konsulko.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
Subject: [PATCH] pegasus.c: Remove pegasus' own workqueue
Message-ID: <20200402143329.GC4089@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove pegasus' own workqueue and replace it with system_long_wq.

Signed-off-by: Petko Manolov <petkan@nucleusys.com>
---
 drivers/net/usb/pegasus.c | 38 ++++++--------------------------------
 1 file changed, 6 insertions(+), 32 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 8783e2ab3ec0..0ef7e1f443e3 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -54,6 +54,7 @@ static const char driver_name[] = "pegasus";
 #undef	PEGASUS_WRITE_EEPROM
 #define	BMSR_MEDIA	(BMSR_10HALF | BMSR_10FULL | BMSR_100HALF | \
 			BMSR_100FULL | BMSR_ANEGCAPABLE)
+#define CARRIER_CHECK_DELAY (2 * HZ)
 
 static bool loopback;
 static bool mii_mode;
@@ -1089,17 +1090,12 @@ static inline void setup_pegasus_II(pegasus_t *pegasus)
 		set_register(pegasus, Reg81, 2);
 }
 
-
-static int pegasus_count;
-static struct workqueue_struct *pegasus_workqueue;
-#define CARRIER_CHECK_DELAY (2 * HZ)
-
 static void check_carrier(struct work_struct *work)
 {
 	pegasus_t *pegasus = container_of(work, pegasus_t, carrier_check.work);
 	set_carrier(pegasus->net);
 	if (!(pegasus->flags & PEGASUS_UNPLUG)) {
-		queue_delayed_work(pegasus_workqueue, &pegasus->carrier_check,
+		queue_delayed_work(system_long_wq, &pegasus->carrier_check,
 			CARRIER_CHECK_DELAY);
 	}
 }
@@ -1120,18 +1116,6 @@ static int pegasus_blacklisted(struct usb_device *udev)
 	return 0;
 }
 
-/* we rely on probe() and remove() being serialized so we
- * don't need extra locking on pegasus_count.
- */
-static void pegasus_dec_workqueue(void)
-{
-	pegasus_count--;
-	if (pegasus_count == 0) {
-		destroy_workqueue(pegasus_workqueue);
-		pegasus_workqueue = NULL;
-	}
-}
-
 static int pegasus_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
@@ -1144,14 +1128,6 @@ static int pegasus_probe(struct usb_interface *intf,
 	if (pegasus_blacklisted(dev))
 		return -ENODEV;
 
-	if (pegasus_count == 0) {
-		pegasus_workqueue = alloc_workqueue("pegasus", WQ_MEM_RECLAIM,
-						    0);
-		if (!pegasus_workqueue)
-			return -ENOMEM;
-	}
-	pegasus_count++;
-
 	net = alloc_etherdev(sizeof(struct pegasus));
 	if (!net)
 		goto out;
@@ -1209,7 +1185,7 @@ static int pegasus_probe(struct usb_interface *intf,
 	res = register_netdev(net);
 	if (res)
 		goto out3;
-	queue_delayed_work(pegasus_workqueue, &pegasus->carrier_check,
+	queue_delayed_work(system_long_wq, &pegasus->carrier_check,
 			   CARRIER_CHECK_DELAY);
 	dev_info(&intf->dev, "%s, %s, %pM\n", net->name,
 		 usb_dev_id[dev_index].name, net->dev_addr);
@@ -1222,7 +1198,6 @@ static int pegasus_probe(struct usb_interface *intf,
 out1:
 	free_netdev(net);
 out:
-	pegasus_dec_workqueue();
 	return res;
 }
 
@@ -1237,7 +1212,7 @@ static void pegasus_disconnect(struct usb_interface *intf)
 	}
 
 	pegasus->flags |= PEGASUS_UNPLUG;
-	cancel_delayed_work(&pegasus->carrier_check);
+	cancel_delayed_work_sync(&pegasus->carrier_check);
 	unregister_netdev(pegasus->net);
 	unlink_all_urbs(pegasus);
 	free_all_urbs(pegasus);
@@ -1246,7 +1221,6 @@ static void pegasus_disconnect(struct usb_interface *intf)
 		pegasus->rx_skb = NULL;
 	}
 	free_netdev(pegasus->net);
-	pegasus_dec_workqueue();
 }
 
 static int pegasus_suspend(struct usb_interface *intf, pm_message_t message)
@@ -1254,7 +1228,7 @@ static int pegasus_suspend(struct usb_interface *intf, pm_message_t message)
 	struct pegasus *pegasus = usb_get_intfdata(intf);
 
 	netif_device_detach(pegasus->net);
-	cancel_delayed_work(&pegasus->carrier_check);
+	cancel_delayed_work_sync(&pegasus->carrier_check);
 	if (netif_running(pegasus->net)) {
 		usb_kill_urb(pegasus->rx_urb);
 		usb_kill_urb(pegasus->intr_urb);
@@ -1276,7 +1250,7 @@ static int pegasus_resume(struct usb_interface *intf)
 		pegasus->intr_urb->actual_length = 0;
 		intr_callback(pegasus->intr_urb);
 	}
-	queue_delayed_work(pegasus_workqueue, &pegasus->carrier_check,
+	queue_delayed_work(system_long_wq, &pegasus->carrier_check,
 				CARRIER_CHECK_DELAY);
 	return 0;
 }
-- 
2.25.1

