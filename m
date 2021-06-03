Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFDD39A5EC
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhFCQmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:42:25 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:36647 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhFCQmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 12:42:24 -0400
Received: by mail-lf1-f42.google.com with SMTP id v22so8449470lfa.3;
        Thu, 03 Jun 2021 09:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lV6Q3W6nkSdzK3hzB+sseFLCHuZyidZULCgpSSGeWe4=;
        b=sT3XU+v2p8XVmtVvsVXgp+Mmwyh4QJOmaJUdQms1f8UCaglDdkxU/mKixEj+WrTzIG
         mRxNzwcZyc+MEVwmK5wZlffXeDGYIov/Z+36+TaAijhjW8mrhed13JMt02aiHAfx4/vz
         2PR+ckX7M8vcaquHysmQEYQc8E/+vO6uxtXxF6cNkfRYzbKzQGwHk1k/7pPKlAsiYRoW
         u3f2jo6MD6D6dUGRbg90BkMRzzJ5DV/fNL96XHmS10AJj0W7HmSTUYZk6NQKx33eoKT8
         6jYuITumEvCV3Uwn6aw1ldwA4CY55z+v9CaYTr2tLY97Ywrfid3Ny9pXLw8fej3JzGFu
         2hPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lV6Q3W6nkSdzK3hzB+sseFLCHuZyidZULCgpSSGeWe4=;
        b=QQF7S5sOXzFOjVjH0FhfFahfxj+AnNIOl1HfpnkpPxQLYNtg0I0Oo6hNJmyxFG3FEZ
         WRSCs+i1X85WAzp5xXzD6aG/6godBty1ABPNh/8DmWnGQh8l3qoF9eD35Vb/xUnlEKBB
         G08HseZdvVSBj89ejpW3YfAzptrjTZW1HSNfvtnnv2cXvRPv9GpphxXxyHd0gbwQjl44
         MriMgsOkz5SsREnXPFTeHgqm9PS3aUIOPDI/9HEquXH253CfZkB/GVFyNU41uVSv1347
         0plaPSVaag8ofANZhxYG3rstJ32LZJ0HwT77MczWOGBIUkCQ9KkBdKuPT1Y7bVYqeVvX
         ex7A==
X-Gm-Message-State: AOAM5316vbZjBJyc52MNfPhxL3ZCH6MHzZ6rYWY4Ly0ngq1ufKmoFQso
        wO61D1U6i+Oi711Wi8CPGME=
X-Google-Smtp-Source: ABdhPJwTH5GT/8hnHzguYo9DcNtmZG54O90JBEoIzXGtAGwQfHJqXULHxgHKKYZkOGwLQLZzhyaK5Q==
X-Received: by 2002:a19:c34a:: with SMTP id t71mr321369lff.499.1622738378208;
        Thu, 03 Jun 2021 09:39:38 -0700 (PDT)
Received: from localhost.localdomain ([94.103.224.40])
        by smtp.gmail.com with ESMTPSA id f5sm363332lfh.178.2021.06.03.09.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 09:39:37 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        sjur.brandeland@stericsson.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 4/4] net: caif: fix memory leak in cfusbl_device_notify
Date:   Thu,  3 Jun 2021 19:39:35 +0300
Message-Id: <c5d148e7a7d48dbe6887efca14863c0310d56326.1622737854.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1622737854.git.paskripkin@gmail.com>
References: <cover.1622737854.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of caif_enroll_dev() fail, allocated
link_support won't be assigned to the corresponding
structure. So simply free allocated pointer in case
of error.

Fixes: 7ad65bf68d70 ("caif: Add support for CAIF over CDC NCM USB interface")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/caif/caif_usb.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/caif/caif_usb.c b/net/caif/caif_usb.c
index a0116b9503d9..b02e1292f7f1 100644
--- a/net/caif/caif_usb.c
+++ b/net/caif/caif_usb.c
@@ -115,6 +115,11 @@ static struct cflayer *cfusbl_create(int phyid, u8 ethaddr[ETH_ALEN],
 	return (struct cflayer *) this;
 }
 
+static void cfusbl_release(struct cflayer *layer)
+{
+	kfree(layer);
+}
+
 static struct packet_type caif_usb_type __read_mostly = {
 	.type = cpu_to_be16(ETH_P_802_EX1),
 };
@@ -127,6 +132,7 @@ static int cfusbl_device_notify(struct notifier_block *me, unsigned long what,
 	struct cflayer *layer, *link_support;
 	struct usbnet *usbnet;
 	struct usb_device *usbdev;
+	int res;
 
 	/* Check whether we have a NCM device, and find its VID/PID. */
 	if (!(dev->dev.parent && dev->dev.parent->driver &&
@@ -169,8 +175,11 @@ static int cfusbl_device_notify(struct notifier_block *me, unsigned long what,
 	if (dev->num_tx_queues > 1)
 		pr_warn("USB device uses more than one tx queue\n");
 
-	caif_enroll_dev(dev, &common, link_support, CFUSB_MAX_HEADLEN,
+	res = caif_enroll_dev(dev, &common, link_support, CFUSB_MAX_HEADLEN,
 			&layer, &caif_usb_type.func);
+	if (res)
+		goto err;
+
 	if (!pack_added)
 		dev_add_pack(&caif_usb_type);
 	pack_added = true;
@@ -178,6 +187,9 @@ static int cfusbl_device_notify(struct notifier_block *me, unsigned long what,
 	strlcpy(layer->name, dev->name, sizeof(layer->name));
 
 	return 0;
+err:
+	cfusbl_release(link_support);
+	return res;
 }
 
 static struct notifier_block caif_device_notifier = {
-- 
2.31.1

