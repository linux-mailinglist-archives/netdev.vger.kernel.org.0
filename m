Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420AF355471
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 15:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344303AbhDFNBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 09:01:11 -0400
Received: from sender4-of-o53.zoho.com ([136.143.188.53]:21354 "EHLO
        sender4-of-o53.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344275AbhDFNBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 09:01:09 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Apr 2021 09:01:09 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1617713124; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=AksbyrHmkX3dwlHkSpJIHQP+nJwA6iHXpM0kqQOvKDC5H3kduQu7WPR61wfyNizycuNcYgdA0dNVwHhA6kcB2Ppd2pUrB1ueckODfmAVb3Qo8nuG8uch4S3pCCNrtirXRirTpJAmq8XScrimHG4gwTnT+or/QdVg0AHFS6x5+/0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1617713124; h=Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=m3YhZRYhbPszqTHrr3Ftf84/MKjbvjCe58AbZURF9HY=; 
        b=GQeS8q01rG9jeLrfIrUhsDzav8p6T9GlTrs/tXaoXhGmXb1rpRQMA8mGFhwYpOtV5GSXE78Y9QmaaFJJyvVHSIIr5HgFVKLz3J6jrpP+agdG2LKYK1qnBEh/R6VisR/9MUDH84iMM/rBA64JWU8h4EbClyKiQhxLeh1U/Nm31Z0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=anirudhrb.com;
        spf=pass  smtp.mailfrom=mail@anirudhrb.com;
        dmarc=pass header.from=<mail@anirudhrb.com> header.from=<mail@anirudhrb.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617713124;
        s=zoho; d=anirudhrb.com; i=mail@anirudhrb.com;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Transfer-Encoding;
        bh=m3YhZRYhbPszqTHrr3Ftf84/MKjbvjCe58AbZURF9HY=;
        b=l9hF+jN+xbKTmXbM3zc70VXURx8F7QzRjsk4u3xdEB8V7g5+D8txqXea6PhS3YNa
        NiwHajt5InGLlEpCMiZPj+sbtE5B5tsMhU8/oNkmiwZErUp/rtAkbghd18GD4t/EDYz
        SxanGDN0ixZLtC7Jm8uK9AUacM9hbUuABExBTkk8=
Received: from localhost.localdomain (49.207.62.127 [49.207.62.127]) by mx.zohomail.com
        with SMTPS id 1617713118803591.989363998497; Tue, 6 Apr 2021 05:45:18 -0700 (PDT)
From:   Anirudh Rayabharam <mail@anirudhrb.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Rustam Kovhaev <rkovhaev@gmail.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     gregkh@linuxfoundation.org,
        syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: hso: fix null-ptr-deref during tty device unregistration
Date:   Tue,  6 Apr 2021 18:13:59 +0530
Message-Id: <20210406124402.20930-1-mail@anirudhrb.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multiple ttys try to claim the same the minor number causing a double
unregistration of the same device. The first unregistration succeeds
but the next one results in a null-ptr-deref.

The get_free_serial_index() function returns an available minor number
but doesn't assign it immediately. The assignment is done by the caller
later. But before this assignment, calls to get_free_serial_index()
would return the same minor number.

Fix this by modifying get_free_serial_index to assign the minor number
immediately after one is found to be and rename it to obtain_minor()
to better reflect what it does. Similary, rename set_serial_by_index()
to release_minor() and modify it to free up the minor number of the
given hso_serial. Every obtain_minor() should have corresponding
release_minor() call.

Reported-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com
Tested-by: syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com

Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
---
 drivers/net/usb/hso.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 31d51346786a..295ca330e70c 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -611,7 +611,7 @@ static struct hso_serial *get_serial_by_index(unsigned index)
 	return serial;
 }
 
-static int get_free_serial_index(void)
+static int obtain_minor(struct hso_serial *serial)
 {
 	int index;
 	unsigned long flags;
@@ -619,8 +619,10 @@ static int get_free_serial_index(void)
 	spin_lock_irqsave(&serial_table_lock, flags);
 	for (index = 0; index < HSO_SERIAL_TTY_MINORS; index++) {
 		if (serial_table[index] == NULL) {
+			serial_table[index] = serial->parent;
+			serial->minor = index;
 			spin_unlock_irqrestore(&serial_table_lock, flags);
-			return index;
+			return 0;
 		}
 	}
 	spin_unlock_irqrestore(&serial_table_lock, flags);
@@ -629,15 +631,12 @@ static int get_free_serial_index(void)
 	return -1;
 }
 
-static void set_serial_by_index(unsigned index, struct hso_serial *serial)
+static void release_minor(struct hso_serial *serial)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&serial_table_lock, flags);
-	if (serial)
-		serial_table[index] = serial->parent;
-	else
-		serial_table[index] = NULL;
+	serial_table[serial->minor] = NULL;
 	spin_unlock_irqrestore(&serial_table_lock, flags);
 }
 
@@ -2230,6 +2229,7 @@ static int hso_stop_serial_device(struct hso_device *hso_dev)
 static void hso_serial_tty_unregister(struct hso_serial *serial)
 {
 	tty_unregister_device(tty_drv, serial->minor);
+	release_minor(serial);
 }
 
 static void hso_serial_common_free(struct hso_serial *serial)
@@ -2258,19 +2258,18 @@ static int hso_serial_common_create(struct hso_serial *serial, int num_urbs,
 
 	tty_port_init(&serial->port);
 
-	minor = get_free_serial_index();
-	if (minor < 0)
+	if (obtain_minor(serial))
 		goto exit2;
 
 	/* register our minor number */
 	serial->parent->dev = tty_port_register_device_attr(&serial->port,
-			tty_drv, minor, &serial->parent->interface->dev,
+			tty_drv, serial->minor, &serial->parent->interface->dev,
 			serial->parent, hso_serial_dev_groups);
-	if (IS_ERR(serial->parent->dev))
+	if (IS_ERR(serial->parent->dev)) {
+		release_minor(serial);
 		goto exit2;
+	}
 
-	/* fill in specific data for later use */
-	serial->minor = minor;
 	serial->magic = HSO_SERIAL_MAGIC;
 	spin_lock_init(&serial->serial_lock);
 	serial->num_rx_urbs = num_urbs;
@@ -2667,9 +2666,6 @@ static struct hso_device *hso_create_bulk_serial_device(
 
 	serial->write_data = hso_std_serial_write_data;
 
-	/* and record this serial */
-	set_serial_by_index(serial->minor, serial);
-
 	/* setup the proc dirs and files if needed */
 	hso_log_port(hso_dev);
 
@@ -2726,9 +2722,6 @@ struct hso_device *hso_create_mux_serial_device(struct usb_interface *interface,
 	serial->shared_int->ref_count++;
 	mutex_unlock(&serial->shared_int->shared_int_lock);
 
-	/* and record this serial */
-	set_serial_by_index(serial->minor, serial);
-
 	/* setup the proc dirs and files if needed */
 	hso_log_port(hso_dev);
 
@@ -3113,7 +3106,6 @@ static void hso_free_interface(struct usb_interface *interface)
 			cancel_work_sync(&serial_table[i]->async_get_intf);
 			hso_serial_tty_unregister(serial);
 			kref_put(&serial_table[i]->ref, hso_serial_ref_free);
-			set_serial_by_index(i, NULL);
 		}
 	}
 
-- 
2.26.2

