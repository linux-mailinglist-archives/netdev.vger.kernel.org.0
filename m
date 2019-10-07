Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133CACE974
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 18:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbfJGQl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 12:41:26 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39932 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfJGQl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 12:41:26 -0400
Received: by mail-lj1-f196.google.com with SMTP id y3so14424103ljj.6;
        Mon, 07 Oct 2019 09:41:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jI/iLcOzPQTe2f97TrWx71MZt1CEPA+WREXnjknhy+c=;
        b=eAHeAGQvB0yjKcC+675QO0viA5bq9QiSHfGf62JaiFxze/uqvjwwoETHfjC9kSZW9v
         Rg4OpvFaytYRyl0oneg5MLure+OuT8WB6+elc6E/PVhGFQW0i9WsYQIRZCSWZiE7k2Kb
         GQ8spupna243F1U/ExGKl2mDxHXJyjANSD5dDiu19T8XjlipjTZP4NOIgKI2sy5R3txR
         wg2qruN6gpiDFlggTA3zM1lE/bkGFRsbklmpljT6lyn0ohFy0oHn8ZijbzI8zRUDqd1X
         dGRyFCGvnc6hRXMNGg5GRZYul0UtGEgVILEskDuKVCOA9nvuyGiehzKU4+1sOMMtjeQ+
         4eJQ==
X-Gm-Message-State: APjAAAWK5KEtfuPYHkkpTtbhtlUhi5Sv5XnJHv10+v4VNLKPsHvAcQq7
        00rfqfKHv+h9dgdPkkPAn2DgaqWK
X-Google-Smtp-Source: APXvYqyNv2VKLAXOA9KNrpBz/Cds2AegDowgIvxaSpQnmeZebACb49uKRiLDPsG28obB29nUOBT/MQ==
X-Received: by 2002:a2e:7e05:: with SMTP id z5mr19566975ljc.8.1570466483459;
        Mon, 07 Oct 2019 09:41:23 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id g3sm3137094lja.61.2019.10.07.09.41.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 09:41:22 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.2)
        (envelope-from <johan@xi.terra>)
        id 1iHW4f-0001YL-4G; Mon, 07 Oct 2019 18:41:29 +0200
From:   Johan Hovold <johan@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrey Rusalin <arusalin@dev.rtsoft.ru>,
        Lars Poeschel <poeschel@lemonage.de>,
        linux-usb@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        syzbot+cb035c75c03dbe34b796@syzkaller.appspotmail.com,
        stable <stable@vger.kernel.org>
Subject: [PATCH] NFC: pn533: fix use-after-free and memleaks
Date:   Mon,  7 Oct 2019 18:40:59 +0200
Message-Id: <20191007164059.5927-1-johan@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <000000000000f0d74d0594536e2c@google.com>
References: <000000000000f0d74d0594536e2c@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver would fail to deregister and its class device and free
related resources on late probe errors.

Reported-by: syzbot+cb035c75c03dbe34b796@syzkaller.appspotmail.com
Fixes: 32ecc75ded72 ("NFC: pn533: change order operations in dev registation")
Cc: stable <stable@vger.kernel.org>	# 4.11
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/nfc/pn533/usb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index c5289eaf17ee..e897e4d768ef 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -547,18 +547,25 @@ static int pn533_usb_probe(struct usb_interface *interface,
 
 	rc = pn533_finalize_setup(priv);
 	if (rc)
-		goto error;
+		goto err_deregister;
 
 	usb_set_intfdata(interface, phy);
 
 	return 0;
 
+err_deregister:
+	pn533_unregister_device(phy->priv);
 error:
+	usb_kill_urb(phy->in_urb);
+	usb_kill_urb(phy->out_urb);
+	usb_kill_urb(phy->ack_urb);
+
 	usb_free_urb(phy->in_urb);
 	usb_free_urb(phy->out_urb);
 	usb_free_urb(phy->ack_urb);
 	usb_put_dev(phy->udev);
 	kfree(in_buf);
+	kfree(phy->ack_buffer);
 
 	return rc;
 }
-- 
2.23.0

