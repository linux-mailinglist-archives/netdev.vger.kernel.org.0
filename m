Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF43E4DF8
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395157AbfJYOD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394725AbfJYN4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:56:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3342821D7F;
        Fri, 25 Oct 2019 13:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011813;
        bh=a+GKRQsj12e49IKqnLb4YIPS1p3NkJgRmAz+07Mktog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fN4BV8qGGtkDspxwvwGWAp+K6fekNDk002vsLZ1KCiKzvIdHbFBc/7ZU/yunMIl3p
         dTj9aBMV75JyTB2AAGjkXjOdmc8Egqoe/njxNh1vMTz3BVZiGp6FXwZpBHKyroWEJG
         lmyTYOntmqAqru0kvcEVUrsMCCW7jnXkt5Dg9smc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>,
        syzbot+cb035c75c03dbe34b796@syzkaller.appspotmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 26/37] NFC: pn533: fix use-after-free and memleaks
Date:   Fri, 25 Oct 2019 09:55:50 -0400
Message-Id: <20191025135603.25093-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135603.25093-1-sashal@kernel.org>
References: <20191025135603.25093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 6af3aa57a0984e061f61308fe181a9a12359fecc ]

The driver would fail to deregister and its class device and free
related resources on late probe errors.

Reported-by: syzbot+cb035c75c03dbe34b796@syzkaller.appspotmail.com
Fixes: 32ecc75ded72 ("NFC: pn533: change order operations in dev registation")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/usb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 5d823e965883b..fcb57d64d97e6 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -559,18 +559,25 @@ static int pn533_usb_probe(struct usb_interface *interface,
 
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
2.20.1

