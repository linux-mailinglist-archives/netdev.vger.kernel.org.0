Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D9C3ABC29
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 20:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhFQSyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 14:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbhFQSyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 14:54:06 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1C8C061574;
        Thu, 17 Jun 2021 11:51:57 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id f30so12216297lfj.1;
        Thu, 17 Jun 2021 11:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=40iSRLWtvPNc31eMVSQCNXCOo1P/U4f/2ame7W8s7LA=;
        b=rsxaC1znzCn7fziXWptJz1qN5MODcSouxR5lI+u78WoyFsSgt3dsGIF5Tv44ipxQv6
         kemni53G002ljSgD21taefI9UNC1Yl7M7R4+qVdy+RBLWlayR3c0ovbFqzU+rq1dReE0
         lHNahHTvby841ZMPr/rNIrzJj6klsQMbCh0mVbpGclEZ72IeBmHO3+BjP+MY8xfP/8mv
         uFhLWqW9/WtLcbShF3YxfE3G3NeayGKkIFZGyEfmd+TF+P9wiFsKQhbSMue5CNRUfzLi
         2bvHsgkDWLIADU5pn48jsGYd7xhP078ZpP6u0El9alolLXxEnA+rXUN08/L9CLA5i2xx
         JEnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=40iSRLWtvPNc31eMVSQCNXCOo1P/U4f/2ame7W8s7LA=;
        b=Ph/onVcCCybALHHFtXrPvENN+yMaQc82wFcbIUwhYX+xr733zRF9SMBu6Vli1k5x3w
         m6u3JX3c87MgacBxujDJUJgOuHyCINsz305qZAiKW5zrOqTTRm3R3uRBFkyHdNL18IJF
         eEKmGn8eQ0lj3Fg9mkB60hrerCuaYMCyccQUZ38nZfiMGyQ+Y8DUOqaNP3vZ4oRuOt6M
         Jl02ImcgPXBLDx6K8Uvm1CJjS2BPMQ7g/hhFC2yV3Dw4jlIwNGOt/cET6GvDi5GUQBix
         EMSyLdwUj7O4AOgcgKhavDWG0KwHPtAsYXxav8vmqlNJE3zrXtpwa3M63bYYH2be8+gI
         VQhA==
X-Gm-Message-State: AOAM533YFRinddhJcCdR2iu8ATasbHkY7ez1NMAxj5HG2la7N70bNa8h
        OZxQpaFixdtxLbY0j4+PBzM=
X-Google-Smtp-Source: ABdhPJxSIdVAbppcnUgVPWZU81UNJMf0YO8KayLnXtSZpBuvMAVk8l2cBRtQr9dzR26muqB+cJO9Tw==
X-Received: by 2002:a19:c10:: with SMTP id 16mr5184114lfm.54.1623955913761;
        Thu, 17 Jun 2021 11:51:53 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.24])
        by smtp.gmail.com with ESMTPSA id i130sm655175lfd.304.2021.06.17.11.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 11:51:53 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: can: fix use-after-free in ems_usb_disconnect
Date:   Thu, 17 Jun 2021 21:51:30 +0300
Message-Id: <20210617185130.5834-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ems_usb_disconnect() dev pointer, which is
netdev private data, is used after free_candev() call:

	if (dev) {
		unregister_netdev(dev->netdev);
		free_candev(dev->netdev);

		unlink_all_urbs(dev);

		usb_free_urb(dev->intr_urb);

		kfree(dev->intr_in_buffer);
		kfree(dev->tx_msg_buffer);
	}

Fix it by simply moving free_candev() at the end of
the block.

Fail log:
 BUG: KASAN: use-after-free in ems_usb_disconnect
 Read of size 8 at addr ffff88804e041008 by task kworker/1:2/2895

 CPU: 1 PID: 2895 Comm: kworker/1:2 Not tainted 5.13.0-rc5+ #164
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.4
 Workqueue: usb_hub_wq hub_event
 Call Trace:
     dump_stack (lib/dump_stack.c:122)
     print_address_description.constprop.0.cold (mm/kasan/report.c:234)
     kasan_report.cold (mm/kasan/report.c:420 mm/kasan/report.c:436)
     ems_usb_disconnect (drivers/net/can/usb/ems_usb.c:683 drivers/net/can/usb/ems_usb.c:1058)

Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/can/usb/ems_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 5af69787d9d5..0a37af4a3fa4 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -1053,7 +1053,6 @@ static void ems_usb_disconnect(struct usb_interface *intf)
 
 	if (dev) {
 		unregister_netdev(dev->netdev);
-		free_candev(dev->netdev);
 
 		unlink_all_urbs(dev);
 
@@ -1061,6 +1060,8 @@ static void ems_usb_disconnect(struct usb_interface *intf)
 
 		kfree(dev->intr_in_buffer);
 		kfree(dev->tx_msg_buffer);
+
+		free_candev(dev->netdev);
 	}
 }
 
-- 
2.32.0

