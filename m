Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DB420E150
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387744AbgF2UyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731315AbgF2TNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:19 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C404EC02E2F0;
        Mon, 29 Jun 2020 07:26:09 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id t11so3118150pfq.11;
        Mon, 29 Jun 2020 07:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=mlt9jkXFO3CZS6x7qBk1OZMI7sTVBkCcQrKajfIoY1A=;
        b=KQJdYN7uO+u4O8k6UboV5gaofYXIX+FFQti+hRLArPFMyPrbEkAGU7SBRue63Zt6Ks
         /oUFKJ0hW+iEZ1uyX9O9dnD2Fmw5+UVJOwA9ajYKku2N3ePATzctyVnzcY1d/CaiCcIb
         rGUGlKTrDmnoO3it8eUtykQl+DXDfJyNiLR9Oolwh5hE4J8mJXMFwvx9FBx0Kq/rB0bx
         +R9PtqpBdu7NAcaOJgFHm5xOgv8gbzoZU2Rh/gqMfBp9QzTV32bvNaFCR0JfNCbqnYeY
         27ipvZWnIQbqOYJsN5hnIlAb9wo5yHLzkEvFjDXo44d+jazEYAeVNN8q+0N2I8QqX/hN
         FVTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=mlt9jkXFO3CZS6x7qBk1OZMI7sTVBkCcQrKajfIoY1A=;
        b=sNda6ovyT4kC5ciqhmtDhChhWYlbt+oYe0DyDdCVaKIXCIzD5HtarJnzVzMSCwUmTE
         rm7insZ+iVElx7aUzWtnRdio68iD/mInPRKZGBqkCtgJLHJyBMPg+90kvLpYWhhN2zz8
         cDFM6VpnqpD9FGdsOqwwRjnlSMmq2NW9gJGJ5zChnK4ZEExXsj52+K6PXz7fhXWspOVd
         +tr0tTIDzMdXMXkuq3TN1jxkvtCAfX7vq0oz7mwyD/Vh7/n3j7kmEf0NbHjttSGC1hIY
         vjn+E0MfsxZe7DVDESE9DWDGGsHzCPAmHj962TlmYy0ziL/ge87tZTQQa7aQh9RWrdqO
         Y+BA==
X-Gm-Message-State: AOAM533V74Cs7V/waYh+RYlYpTR6Nq5Gp22Up4fKSm+HbOoaIxw1aNkB
        AkYVzHLfzBfvtV02LTXsWcY=
X-Google-Smtp-Source: ABdhPJy2N9NMsDqgB+cALwHqxUF/3QVeC2ne2FVGQEU1gsqvE2aDODdqsX6eGAu71ddInlQ2cFlR5g==
X-Received: by 2002:a63:f408:: with SMTP id g8mr11134230pgi.184.1593440769384;
        Mon, 29 Jun 2020 07:26:09 -0700 (PDT)
Received: from cosmos ([122.167.176.23])
        by smtp.gmail.com with ESMTPSA id b4sm151710pjn.38.2020.06.29.07.26.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jun 2020 07:26:08 -0700 (PDT)
Date:   Mon, 29 Jun 2020 19:56:03 +0530
From:   Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: fix kernel null pointer dereference error on
 suspend
Message-ID: <20200629142600.GA3102@cosmos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BUG Call Trace:
  queue_work_on+0x39/0x40
  hci_adv_monitors_clear+0x71/0x90 [bluetooth]
  hci_unregister_dev+0x18a/0x2f0 [bluetooth]
  btusb_disconnect+0x68/0x150 [btusb]
  usb_unbind_interface+0x7f/0x260
  device_release_driver_internal+0xec/0x1b0
  device_release_driver+0x12/0x20
  bus_remove_device+0xe1/0x150
  device_del+0x17d/0x3e0
  usb_disable_device+0x9f/0x250
  usb_disconnect+0xc6/0x270
  hub_event+0x6da/0x18d0
  process_one_work+0x20c/0x400
  worker_thread+0x34/0x400

RIP: 0010:__queue_work+0x92/0x3f0

NULL deference occurs in hci_update_background_scan() while it tries
to queue_work on already destroyed workqueues.

Change hci_unregister_dev() to invoke destroy_workqueues after the
call to hci_adv_monitors_clear().

Signed-off-by: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
---
 net/bluetooth/hci_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 7959b85..5577cf9 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -3795,9 +3795,6 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	kfree_const(hdev->hw_info);
 	kfree_const(hdev->fw_info);
 
-	destroy_workqueue(hdev->workqueue);
-	destroy_workqueue(hdev->req_workqueue);
-
 	hci_dev_lock(hdev);
 	hci_bdaddr_list_clear(&hdev->blacklist);
 	hci_bdaddr_list_clear(&hdev->whitelist);
@@ -3815,6 +3812,9 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	hci_blocked_keys_clear(hdev);
 	hci_dev_unlock(hdev);
 
+	destroy_workqueue(hdev->workqueue);
+	destroy_workqueue(hdev->req_workqueue);
+
 	hci_dev_put(hdev);
 
 	ida_simple_remove(&hci_index_ida, id);
-- 
2.7.4

